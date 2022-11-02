#!/bin/bash

# Check if the current user os root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo -e "Adding Docker repo"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable"

echo -e "Adding Vscode repo"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg


echo -e "Update our Repos"
apt update -y

# Additional Packages
echo -e "\nInstalling Additional Packages ..."
if ! apt install -y  libreoffice firefox nvidia-driver code docker-ce docker-ce-cli containerd.io docker-compose-plugin vlc ttf-mscorefonts-installer libreoffice-gnome 
then
    echo "Error while installing packages."
    exit
fi
echo -e "\nAdditionalPackages installation completed"

fc-cache -f

# Enable Docker
sudo systemctl enable docker.service
groupadd docker
usermod -aG docker $USER

# Nvidia
nvidia_check=$(/sbin/lspci | grep -i '.* vga .* nvidia .*')

if [[ $nvidia_check == *' nvidia '* ]]; then
  printf 'NVIDIA GPU is present:  %s\n' "$nvidia_check"
  read -p "install the proprietary NVIDIA Drivers? (Yes/No) " choice
	if [[ "$choice" =~ ^[Yy] ]]
	then
		echo "Okay, installing NVIDIA drivers."
		sudo dnf install nvidia-driver -y
	else
		echo "Okay, Not installing NVIDIA drivers.
		"
	fi
	else
  	echo "NVIDIA GPU is not present."
fi

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
