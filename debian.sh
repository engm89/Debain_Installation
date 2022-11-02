#!/bin/bash

# Check if the current user os root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo -e "\nCopying config files ..."
rm /etc/apt/sources.list
rm /etc/nanorc
if [[ -d configs ]]; then
  cp -ri configs/sources.list /etc/apt
  cp -ri configs/nanorc /etc/
else
  echo -e "\nDirectory not found."
fi


# Base Packages
echo -e "\nInstalling Base Packages ..."
if ! apt install -y  --no-install-recommends gnome-core vim build-essential gpg libavcodec-extra apt-transport-https ca-certificates curl gnupg2 software-properties-common gnome-shell-extensions gnome-tweaks bash-completion pciutils linux-headers-$(uname -r)

then
    echo "Error while installing packages."
    exit
fi
echo -e "\nBase Packages installation completed"


# Setup complete.  reboot system now or not
read -p "Setup of this system is complete. Reboot is recommended. Would you like to do this now? " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy] ]]
	then
		echo "Rebooting in 5 seconds"
		sleep 5
		sudo reboot now
	else
		echo "Exiting Setup"
		sleep 1
fi

exit
