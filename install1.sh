contains() {
    found=0
    list=$1
    element=$2
    for el in $list
    do
        if [ $el = $element ]; then
            found=1
        fi
    done
    return $found
}

nolist=("no" "No" "n" "N" "NO")

echo -e "ctrl_interface=/run/wpa_supplicant \nupdate_config=1" >> /etc/wpa_supplicant/wpa_supplicant.conf

echo "Do you want to install through wifi (if you haven't connected lan wire already)\n: "
read wificond

contains nolist $wificond
if [ $? = 1 ]; then
    echo "LAN it is then!"
else
    "Wifi it is then!"
    rfkill unblock wlan
    ip link
    echo "Enter the name of interface which you want to connect through (eg. wlan0 )\n: "
    read devname
    ip link set wlan0 up
    echo "Find your Network's SSID (press 'ENTER' to move forward and 'q' when you see your SSID) after 5 seconds "
    sleep 5
    iw dev $devname scan dump | less
    echo "Enter the SSID of the network to connect to\n: "
    read assid
    iw dev $devname connect -w $assid
    systemctl start dhcpcd
fi

# uncomment this line before running to turn off 802.11n frequency
#echo "options iwlwifi 11n_disable=1" >> /etc/modprobe.d/iwlwifi.conf

systemctl start dhcpcd
echo "Enter your new super user's name\n: "
read user_name
useradd -m $user_name
echo "Enter the passwoed for $user_name"
passwd $user_name
echo "type '$user_name   ALL=(ALL) ALL' in the text editor after 5 seconds to make it a super user"
sleep 5
EDITOR=nano visudo
pacman -S alsa-firmware alsa-utils pulseaudio pavucontrol pulseaudio-bluetooth fftw linux-headers
pacman -S xf86-video-modesetting  xf86-video-intel

echo "Do you have - \n1. No Separate GPU\n2. NVIDIA (2011 and later) only\n3. NVIDIA (2011 and later) Optimus Dual Graphics\n4. AMD (GCN or RDNA)\n5. AMD (TeraScale and older)\n: "
read gfx

case $gfx in
    2) 
    echo "Do you want to install proprietary driver? (recommended yes)\n: "
    read proprietary_cndn
    contains $nolist $proprietary_cndn
    if [ $? = 1 ]; then
        pacman -S xf86-video-nouveau
    else
        pacman -S nvidia nvidia-settings nvidia-utils
    fi
    ;;
    
    3)
    pacman -S nvidia nvidia-utils nvidia-prime nvidia-settings
    sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
    sudo cp ./working_xorg.conf /etc/X11/xorg.conf
    ;;
    
    4)
    pacman -S xf86-video-amdgpu radeon vulkan-radeon
    ;;
    
    5)
    pacman -S xf86-video-ati
    ;;
esac
pacman -S xorg xorg-twm xorg-xclock xterm ttf-dejavu firefox mesa mesa-demos
echo "reboot, type startx, try prime-run, and meet me on the other side\n"
