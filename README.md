# arch-install
Interactive Bash Scripts to install Arch Linux (which can be very problematic for newcomers)
<br>
These are 3 Interactive bash scripts written entirely in Bash: Install0.sh, Install1.sh, Install2.sh
<br>
These files reduce the time taken to install Arch Linux and still wins over calamares because of being entirely in cli

HOW TO USE
1. Download Arch Linux ISO from <a href="https://archlinux.org/download/" >official site</a><br>
2. Flash it onto your pen drive using <a href="https://rufus.ie/en_US/">Rufus</a> or <a href="https://www.balena.io/etcher/">Balena Etcher</a><br>
3. Boot it into your system using F11 / F12 / BIOS Menu Boot Priority<br>
4. Type 'fdisk -l' and identify the drive in which you kept the scripts using hints from format and size (or plug in a second pendrive with scripts in it) <br>
5. Type 'mkdir /mydir'<br>
6. Mount the drive you kept the files in by typing 'mount /dev/<your drive name eg. sda3>'<br>
7. Navigate to the Location of the files by using 'ls' and 'cd <directory name>' commands<br>
8. When required directory is reached, run "chmod +x install0.sh" to make the file executable<br>
9. Run the file by Typing ./install0.sh<br>
10. Repeat steps 8 and 9 to run the next 2 scripts after reboots (use 'shutdown now', 'poweroff', or 'systemctl reboot' commands)<br>
