# ncmpcpp with cover-art and Mopidy-Spotify support

Setup for displaying cover art in ncmpcpp with Mopidy-Spotify Support and Song Change Notifications With cover art.

Note: To enable notifications comment out the notify-send line in `cover_obs.sh` file


## Dependencies

- `tmux`            (to encapsulate everything in one window)  
- `inotify-tools`           (for changing album art when switching songs)  
- ~~`kitty`~~ foot          (terminal emulator with sixel support)
- `ffmpeg`          (used in scaling the album art)  
- `mpc`         (cli client for MPD and notifications)  
- `mopidy-mpris`            (connecting to dubs)  
- `playerctl`           (for images)
- `cava`            (for audio visualization) (you can find my cava config [here](https://github.com/thewebmasterp/dotfiles/tree/main/.config/cava))
- `img2sixel`           (used for image rendering)

## Install
Drop all the files in your `~/.config/ncmpcpp` directory, add execution permission to the scripts and create a soft link to the ```ncmp``` file in a directory of your choice listed in $PATH (`~/.local/bin/` for example).


Run it with `ncmp` in your sixel-compatible terminal emulator (tested with dnkl/foot).

## Screenshots (do not correspond with the changes made in this fork)
![image](https://github.com/user-attachments/assets/3ba50d36-b5d5-4fa4-94cc-cebb1a9f6af2)

![image](https://github.com/user-attachments/assets/b38a1247-646a-44d9-b9e8-7af601fb6095)

![image](https://github.com/user-attachments/assets/297c8c97-3d01-431c-8935-a5557d9c40ad)

![image](https://github.com/user-attachments/assets/df054a43-86a8-4996-93b9-1ef869dd416a)


Forked from [https://github.com/tr1xem/ncmpcpp-with-cover-art](https://github.com/tr1xem/ncmpcpp-with-cover-art)


_The Linux philosophy is 'Laugh in the face of danger'. Oops. Wrong One. 'Do it yourself'. Yes, that's it._

_-Linus Torvalds_


## Inspiration for creating this fork
I am using foot terminal and have been loving it so far, however the original repo seems to only work with Kitty and a few other (trash in my opinion) terminals so it needed intervention to rely on img2sixel in order to support my terminal emulator of choice. I also made a few more changes like the visualizer employed (cava being more configurable) and the tmux layout to fit to my liking.
