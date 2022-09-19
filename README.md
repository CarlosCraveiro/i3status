# i3 status bar

This is the code of my personal i3 bar, so feel free to fork, modify and adapt to your own taste and need.
It was inspired from @Tazeg's i3 status bar.

<!-- In the future it will be an image -->

It contains :

- public IP address
- local IP address
- Connection with FPGA (on/off) (using AlteraQuartus tools) 
- disk usage
- memory usage
- CPU usage
- date and time
- weather
- volume information
- battery information
- log out

Please read the [i3-bar input protocol](https://i3wm.org/docs/i3bar-protocol.html) to understand the basics of how i3bar works.


## Install

In your `~/.config/i3/config` file, add the path to the script `mybar.sh` :

```bash
bar {
  status_command exec /home/you/.config/i3status/mybar.sh
}
```
Replace `/home/you/` in this project with your home path.

Copy the files from this `i3status` repository directory to `~/.config/i3status`.

Please, check and modify each script as it is given as an example working actually on Fedora-36 (You may not have/work work with FPGA, and you may want to adapt some specification)

Restart i3 : `MOD4+SHIFT+R`.

<!-- Specify font -->
<!-- Describe packages
You may also need to install, i.e. for Fedora-36 :
```bash
sudo dnf install  SOME FONT# for icons 
yay -S alsa-utils # for alsamixer (sound volume)
pip3 install psutil --user # for cpu, memory, disk usage
```
-->

## Documentation

- <https://i3wm.org/docs/i3bar-protocol.html>
- <https://i3wm.org/i3status/manpage.html>
- <https://github.com/i3/i3status/tree/master/contrib>
- <https://fontawesome.com/cheatsheet?from=io>
