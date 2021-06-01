#!/bin/bash


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

echo "Choose your keyboard layout (press 'ENTER' to move forward and 'q' when you see your layout) after 3 seconds "

sleep 3
ls /usr/share/kbd/keymaps/**/*.map.gz | less
echo "What keyboard layout to choose?: "
read key_layout
loadkeys $key_layout



echo "Do you want to install through wifi (if you haven't connected lan wire already): "
read wificond

contains $nolist $wificond
if [ $? = 1 ]; then
    echo "LAN it is then!"
else
    "Wifi it is then!"
    rfkill unblock wlan
    ip link
    echo -e "Enter the name of interface which you want to connect through (eg. wlan0 ): "
    read devname
    ip link set wlan0 up
    echo -e "Find your Network's SSID (press 'ENTER' to move forward and 'q' when you see your SSID) after 5 seconds "
    sleep 5
    iw dev $devname scan dump | less
    echo -e "Enter the SSID of the network to connect to: "
    read assid
    iw dev $devname connect -w $assid
    systemctl start dhcpcd
fi

timedatectl set-ntp true

fdisk -l | less
echo "Are at least 3 partitions (efi, root, swap) available to format and mount? (Better check the above list for data partitions by size, etc): "
read wut

contains $nolist $wut
if [ $? = 1 ]; then
    echo "Enter the name of device of which partitions are to be edited (eg. sda ): "
    read devicename
    fdisk /dev/$devicename
fi

echo "Enter the partition to be set as efi (eg. 'sda1' ): "
read efi_partition
echo "Enter the partition to be set as root (eg. 'sda6' ): "
read root_partition
echo "Enter the partition to be set as swap (eg. 'sda7' ): "
read swap_partition
echo "Do you want a separate home partition as well?\n: "
read homeornot
contains $nolist $homeornot
if [ $? = 1 ]; then
    # user didn't opt for home partition
    home_partition=0
    else
    echo "Enter the home partition: "
    read home_partition
fi



mkfs.ext4 /dev/$root_partition
mkswap /dev/$swap_partition
mount /dev/$root_partition /mnt
mkdir /mnt/efi
contains $nolist homeornot
if [ $? = 1 ]; then
    #pass
else
    mkdir /mnt/home
    mount /dev/$home_partition /mnt/home
fi
mount /dev/$efi_partition /mnt/efi
swapon /dev/$swap_partition
pacstrap /mnt base linux linux-firmware linux-zen iwd wpa_supplicant grub dhcpcd efibootmgr os-prober intel-ucode vim nano acpi ntfs-3g
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

##Yet to confirm if the below section works in arch-chroot


timedatectl list-timezones
echo "Enter your time zone: "
read time_zone
ln -sf /usr/share/zoneinfo/$time_zone /etc/localtime

hwclock --systohc

echo "\nUncomment the one language and encoding which you prefer for this machine"
sleep 5
nano /etc/locale.gen
locale-gen
touch /etc/locale.conf


# sieving out the uncommented language
locale_string=$(grep -v '#' /etc/locale.gen)
langvar=""
keyvar=""
c=0
for i in $locale_string
do
    if [ $c = 0 ]; then
        langvar=$i
    else
        keyvar=$i
    fi  
    c+=0
done
echo "LANG=$langvar" >> /etc/locale.conf
echo "KEYMAP=$keyvar" >> /etc/vconsole.conf



echo -e "Enter a host name\n: "
read host_name
echo "$host_name" >> /etc/hostname
echo -e "127.0.0.1	localhost\n::1		localhost\n127.0.1.1	$host_name.localdomain	$host_name" >> /etc/hosts
echo -e "Enter a new password for root user: "
passwd
echo "Installing grub to arch folder in uefi"
grub-install --target=x86_64-efi --efi-directory=/efi  --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg
echo "reboot and meet me on the other side"
