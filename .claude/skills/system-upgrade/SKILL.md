---
name: system-upgrade
description: Upgrade this Arch Linux system end to end with metapac (yay underneath, repos + AUR), unattended. Reads Arch news first, reviews AUR PKGBUILD changes, runs the upgrade, merges .pacnew/.pacsave files, investigates and fixes anything that breaks, re-checks every pinned package (IgnorePkg) to see whether its pin can be lifted, keeps a local upgrade log and ends with a summary. Trigger when the user says "upgrade the system", "update the system", "system upgrade", "update arch", "pacman -Syu", "run metapac update", or asks whether a pinned package can be unpinned.
---

# System upgrade (Arch + metapac)

Run the whole upgrade without stopping to ask, except where this file says to stop.
The user reads the summary at the end, not the transcript, so anything they must know
or do goes there.

Paths:
- Upgrade log (local, never committed): `~/.local/state/system-upgrade/log.md`
- Pins: blocks in the `[options]` section of `/etc/pacman.conf` (format below)
- metapac config: `~/.config/metapac/` (`metapac update-all` = `yay -Syu`)

Every privileged step uses `sudo`. If `sudo -n true` fails, stop and ask the user to
run `sudo -v` in a terminal, then continue.

## The pin convention

A package is never pinned with a bare `IgnorePkg`. Each pin is a comment block with
its own `IgnorePkg` line directly under it (pacman adds repeated `IgnorePkg` lines
together):

```
# PIN <package>
#   status: pinned | trial <version> since <YYYY-MM-DD>
#   since: <YYYY-MM-DD>
#   pinned-at: <version that works>
#   broken-in: <first version that showed the problem>
#   why: <the symptom, in the user's words>
#   unignore-when: <the condition that lifts the pin, with the upstream issue/commit URL>
#   test: <how the user checks the problem is gone, steps and duration>
IgnorePkg = <package>
```

During a trial the `IgnorePkg` line is commented out (`#IgnorePkg = <package>`) and
the block stays, so the working version and the test survive in one place. When
adding a new pin for the user, write the full block. If any field is unknown, ask
the user rather than leave it empty: a pin without `unignore-when` can never be
lifted.

## 1. Load history and state

1. Read the last five entries of the upgrade log in full. Once step 3 has listed the
   updates, `grep -n -i '<pkg>'` the whole log for each package in that list. The log is there for recurring trouble: a DKMS module that fails on every kernel
   bump, a .pacnew merge decision already taken, a package that broke before. Reuse
   what it says; don't rediscover it. If the log does not exist, create it with a
   `# System upgrade log` heading.
2. Read every `# PIN` block in `/etc/pacman.conf`.
3. **Trials come first.** For any block with `status: trial`, ask the user whether
   the test in that block passed before doing anything else (this is the one question
   the skill always asks). Then:
   - passed: delete the block and its commented `IgnorePkg` line; log it.
   - failed: revert (see "Reverting a trial"), set `status: pinned`, and update
     `broken-in` if the trial version is a newer broken one; log it.
   - not tested yet: leave it as it is, and say so in the summary again.
4. Snapshot the "before" state for comparison later:
   `systemctl --failed --no-legend`, `systemctl --user --failed --no-legend`,
   `uname -r`, `dkms status`, and `journalctl -b -p err --no-pager | wc -l`.

## 2. Read Arch news

Find the last upgrade date: `grep 'starting full system upgrade' /var/log/pacman.log | tail -1`.
Fetch `https://archlinux.org/feeds/news/` and read every item published since then.
If an item requires manual intervention for a package that is installed
(`pacman -Q <pkg>`), follow its steps in the order it gives, before or after the
upgrade as it says. If the steps are destructive or ambiguous, stop and show the user
the item.

## 3. List and review updates

```
sudo pacman -Sy          # refresh databases only; step 4 completes the upgrade
pacman -Qu               # repo updates; pinned ones show "[ignored]"
yay -Qua                 # AUR updates
```

Do not install any single package between `pacman -Sy` and step 4: that is a partial
upgrade.

AUR packages build code from strangers, so read what changed before building it.
For each AUR update, the clone lives in `~/.cache/yay/<pkg>` (if missing, run
`yay -G <pkg>` there). Run `git fetch` and then `git diff HEAD..origin/master` (or
`origin/HEAD`), and read the PKGBUILD and any `.install` diff. Stop and show the user
any of these: a `source` URL that moved to a different host or owner, a new
`.install` script or hook, a download piped into a shell, obfuscated or base64
content, or a change of maintainer together with any of the above. `-git` packages
pull upstream HEAD, so their PKGBUILD diff is often empty; that is normal.

Note in the summary anything that needs a reboot: `linux*`, `systemd`, `glibc`,
`mesa`, `nvidia*`, `intel-ucode`/`amd-ucode`, the compositor, `pipewire`.

## 4. Upgrade

```
metapac update-all --no-confirm
```

Read the whole output. Lines to act on: `error:`, `warning: ... installed as ...pacnew`,
`warning: ... saved as ...pacsave`, `==> ERROR` from a hook or DKMS, a failed
mkinitcpio/initramfs, and failed AUR builds.

If pacman refuses because of a conflict or a dependency on a pinned package's newer
version, don't force it. Read the message, check whether the pin must be lifted or
the other package held back as well, and if the choice is not clear, stop and ask.
Never use `--overwrite '*'`, `-Sdd` or `--nodeps` without the user's say-so.

## 5. Merge .pacnew and .pacsave

List them with `pacdiff -o`. For each one:

- **.pacnew** (the package shipped a new default; the local file was edited): diff it
  against the live file. Keep every local change and take every upstream change that
  doesn't conflict with one (new options, renamed keys, changed defaults, comments).
  When an upstream change replaces something the user edited, keep the user's value
  and mention it in the summary. Back up first (`sudo cp f f.bak-<date>`), write the
  merged file, then remove the `.pacnew`.
- `/etc/passwd`, `/etc/group`, `/etc/shadow`, `/etc/gshadow`: never replace. Add only
  the missing system users and groups (`pwck -r`/`grpck -r` must stay clean).
- `/etc/pacman.conf`: merge, and carry every `# PIN` block across unchanged.
- `/etc/mkinitcpio.conf`: after merging, run `sudo mkinitcpio -P` and check it
  succeeds.
- **.pacsave** (the package was removed and its config kept): if the package is gone
  for good, delete the .pacsave; if it was replaced by another package, move the
  local settings into the new package's config. Say which in the summary.

Log every merge decision. The next .pacnew for the same file will look the same, and
the log is where that decision is found again.

## 6. Check what broke, and fix it

Compare against the step 1 snapshot:

- `systemctl --failed`, `systemctl --user --failed`: any new failed unit. Read its
  log with `journalctl -u <unit> -b`.
- `dkms status`: every module must be `installed` for every installed kernel
  (`ls /usr/lib/modules`). A module that failed to build blocks its hardware after
  the reboot. Read `/var/lib/dkms/<module>/<version>/build/make.log`.
- `/boot`: an initramfs and vmlinuz for each installed kernel.
- `journalctl -b -p err` new since the upgrade (compare with `--since`).
- `pacman -Dk` (dependency consistency) and `pacman -Qkq 2>/dev/null | head` (missing files).

To fix: find the root cause, from the error text, the Arch news, the package's AUR
or GitLab comments, the Arch forums, and the upstream issue tracker. Apply the
smallest fix that removes it: rebuild a DKMS module, rebuild an AUR package against
new libraries (`yay -S --rebuild <pkg>`), adjust a config, or downgrade one package
from `/var/cache/pacman/pkg/` and pin it with a full `# PIN` block. A downgrade
always gets a pin; otherwise the next upgrade puts the broken version back.

Things this skill does not do without asking: remove packages, change the
bootloader, edit `/etc/fstab`, touch partitions or btrfs subvolumes, disable
security features.

## 7. Re-check every pin

For each block with `status: pinned`:

1. Compare the repo or AUR version with `broken-in`
   (`pacman -Si <pkg>`, or `yay -Si <pkg>` for AUR).
   If the newest version is still `broken-in`, the pin stays; log one line and move on.
2. If a newer version exists, check `unignore-when` against upstream: is the linked
   issue closed, and is the fixing commit in a release at or below the new version?
   (`gh api repos/<owner>/<repo>/compare/<fix-sha>...v<new>` shows whether a release
   contains a commit.) Read the release notes as well.
3. If the condition is met, or a newer version plausibly fixes it, **start a trial**:
   comment out the `IgnorePkg` line, set `status: trial <new version> since <today>`,
   then `sudo pacman -S <pkg>` (or `yay -S <pkg>`) and restart whatever runs it.
   Put the block's `test` in the summary as something the user must do.
4. If the condition is not met, the pin stays. Say what was checked in the log
   ("0.8.5 out, #411 still open").

### Reverting a trial

Install `pinned-at` again from the cache:
`sudo pacman -U /var/cache/pacman/pkg/<pkg>-<pinned-at>-<arch>.pkg.tar.zst`.
If paccache has removed it, fetch it from
`https://archive.archlinux.org/packages/<first letter>/<pkg>/` (repo packages), or
check out the AUR commit for that version in `~/.cache/yay/<pkg>` and build it
(AUR packages). Uncomment `IgnorePkg`, restart the service, and confirm
`pacman -Q <pkg>` shows `pinned-at`.

## 8. Write the log entry

Append one entry to `~/.local/state/system-upgrade/log.md`. Keep it short; it is read
by the next run, not by people browsing:

```
## <YYYY-MM-DD HH:MM> upgrade
- packages: <n> repo, <n> AUR. Notable: <kernel, systemd, mesa, compositor, anything major with old -> new>
- news: <items acted on, or none>
- aur review: <anything suspicious, or clean>
- pacnew/pacsave: <file: what was kept / taken>
- broke: <symptom -> root cause -> fix>   (omit if nothing broke)
- pins: <pkg: kept (reason) | trial <ver> started | lifted | reverted>
- user to do: <reboot, tests>
- note for next time: <only if something here will matter again>
```

## 9. Summary for the user

End with a short message containing:

1. One line: upgraded or not, and the package counts.
2. **Action needed**, first and only if something is needed: reboot (and why), pin
   trials to test with the exact test steps, choices that were left to them.
3. What broke and how it was fixed, one line each.
4. .pacnew merges where a local setting was kept over a new upstream default.
5. Pins: which stayed, and why, in one line each.

Keep anything that worked without trouble out of the summary.
