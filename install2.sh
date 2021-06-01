pacman -S networkmanager
echo "Which Desktop Environments do you want? (separate numbers by spaces):"
echo "1. GNOME\n2. KDE Plasma\n3. XFCE4: "
read denvs
for denv in $denvs
do
    case $denvs in
    1) pacman -S gnome gdm ;;
    2) pacman -S plasma-desktop powerdevil network-manager-applet nm-connection-editor plasma-nm plasma-pa pavucontrol-qt ;;
    3) pacman -S xfce4 xfce4-whiskermenu-plugin xfce4-pulseaudio-plugin xfce4-screenshooter xfce4-battery-plugin;;
    *) 
        echo "Installing GDM by default"
        pacman -S gnome gdm;;
    esac
done

systemctl enable NetworkManager
systemctl enable gdm
echo "Reboot and Enjoy the Arch"
