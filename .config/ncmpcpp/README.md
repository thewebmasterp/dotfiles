# ncmpcpp with cover-art and Mopidy-Spotify support

Setup for displaying cover art in ncmpcpp with Mopidy-Spotify Support and Song Change Notifications with cover art.


Note: I use kitty and my tmux pane numbering start from 1 by default it starts from 0 so u have to edit that in `ncmp` file


## Dependencies

- `tmux`           (to encapsulate everything in one window)  
- `inotify-tools`  (for changing album art when switching songs)  
- `kitty`       (for image rendering)  
- `ffmpeg`         (used in scaling the album art)  
- `mpc`            (cli client for MPD and notifications)  
- `mopidy-mpris`            (connecting to dubs)  
- `playerctl`            (for images)  

## Install
Drop all the files in your `~/.config/ncmpcpp` directory and add copy  the ```ncmp``` file into your `~/.local/bin/` dir.


Run it with `ncmp`.

## Screenshot
![image1](https://github.com/user-attachments/assets/3ba50d36-b5d5-4fa4-94cc-cebb1a9f6af2)

![image](https://github.com/user-attachments/assets/b38a1247-646a-44d9-b9e8-7af601fb6095)

![image](https://github.com/user-attachments/assets/297c8c97-3d01-431c-8935-a5557d9c40ad)

![image](https://github.com/user-attachments/assets/df054a43-86a8-4996-93b9-1ef869dd416a)


For Any Help or Suggestions you can open a pull request or

Contact me on discord @tr1x_em

Other Socials: https://trix.is-a.dev/


_The Linux philosophy is 'Laugh in the face of danger'. Oops. Wrong One. 'Do it yourself'. Yes, that's it._

_-Linus Torvalds_
