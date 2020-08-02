#/bin/sh

set -euo pipefail


cat << EOF
Known errors:

dd: /dev/rdiskN: Resource busy -> need to unmount disk first
dd: bs: illegal numeric value -> change bs=1m to bs=1M
dd: /dev/rdiskN: Operation not permitted -> disable SIP before continuing
dd: /dev/rdiskN: Permission denied -> erase first with 
    sudo diskutil partitionDisk /dev/diskN 1 MBR "Free Space" "%noformat%" 100%

EOF

bootable_usb() {
    local disk
    local img_path
    local confirm
    local confirm_format
    diskutil list

    printf "Choose your disk (eg /dev/disk2) : " && read disk
    diskutil unmountDisk $disk
    printf "\nWould you like to format $disk ? (y / n)" && read confirm_format
    if [ "confirm_format" == "y" ]; then
        sudo diskutil partitionDisk $disk 1 MBR "Free Space" "%noformat%" 100%
        echo "$disk formated"
    fi
    printf "\nChoose your img path (eg: /home/thomas/Download/myos.img)" && read img_path
    printf "\nConfirm writing $img_path to $disk ? (y / n)" && read confirm
    
    if [ "$confirm" == "y" ]; then
        sudo dd bs=1m if=$img_path of=$disk; sync
    else
        printf "\nExiting\n" && exit 1
    fi

    sudo diskutil eject $disk
}

bootable_usb