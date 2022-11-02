#!/bin/bash

# Check if the current user os root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi


# Base Packages
echo -e "\nInstalling Base Packages ..."
if ! apt install -y  --no-install-recommends gnome-core gdm vim build-essential gpg firmware-linux firmware-misc-nonfree libavcodec-extra apt-transport-https ca-certificates curl gnupg2 software-properties-common gnome-shell-extensions gnome-tweaks bash-completion

then
    echo "Error while installing packages."
    exit
fi
echo -e "\nBase Packages installation completed"