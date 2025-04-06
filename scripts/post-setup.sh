#!/usr/bin/env bash
#

# This script will install everything realsense related. Eventually will be used
#    for either the D456 or L515 systems to keep setup and RPi5 image consistent.

sudo -v

jp2a --colors --color-depth=24 --width=80 --chars=~oO0z --background=light $HOME/lemon-3d-scanner/assets/lemon.png

cd $HOME

echo "Welcome to the RoSE Lab LEMON Pi!"
echo ""
echo ""
echo "[INFO] Running post-system-setup routines..."

############################################################################
# INTEL REALSENSE SDK: RSUSB BACKEND + BUILD SDK FROM SOURCE
# Instructions: https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md

echo "[INFO] Install: LibRealsenseSDK 2.0"
echo "[INFO] Building RSUSB backend rather than UVC event-driven backend, from source..."

# Get the specific version of source from tag on librealsense github if it doesn't already exist
if [[ ! -e $HOME/librealsense]] then
	# download
	echo "[INFO] Cloning..."
	cd $HOME && git clone "https://github.com/IntelRealSense/librealsense.git"
	echo "[INFO] Source cloned into "$HOME/librealsense
else
	echo "[INFO] librealsense source already exists... Skipping."
fi


# Then, install any dependencies we may have missed (shouldn't be any after setup.sh)

echo "[INFO] Installing dependencies..."

sudo apt update && sudo apt upgrade && sudo apt dist-upgrade -y
sudo apt install v4l-utils libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev -y
sudo apt install git wget cmake build-essential -y
sudo apt install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev at -y

echo "[INFO] Dependency installation successful.... done!"

#  Navigate to librealsense folder and setup udev rules for camera device
cd $HOME/librealsense
./scripts/setup_udev_rules.sh

# Then execute cmake built using correct build flags for USB backend

echo "[INFO] Building project from source, then installing on system..."
mkdir -p build && cd build
# NOTE: Edit the line below if you'd like other flags. Available build flags can
#	be found with  `cmake -LAH ..` which will display all options and values
cmake .. -DCMAKE_BUILD_TYPE=Release -DFORCE_RSUSB_BACKEND=true -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=true
make -j1 # IMPORTANT TO ONLY USE ONE CORE!!! USING ALL CORES LIKELY CRASHES PI!!!
sudo make install

# NOTE: If you ever need to uninstall or reinstall the source, perhaps after patching:
# sudo make uninstall && make clean && make && sudo make install

echo "[INFO] Source build and installation successful.... done!"

echo "[INFO] Intel Realsense SDK 2.0 installation successful.... done!"

############################################################################
# ROS2 JAZZY + REALSENSE PACKAGES
# Instructions: https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html

echo "[INFO] Installing ROS2 JAZZY and appropriate realsense packages..."

# Install ros2 via apt
sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale

sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update && sudo apt install ros-dev-tools

sudo apt update
sudo apt upgrade
sudo apt install ros-jazzy-desktop
source /opt/ros/jazzy/setup.bash

# Little helper for adding ros to path by default (only if we haven't already)
line_to_add="source /opt/ros/jazzy/setup.bash"
if ! grep -q "$line_to_add" ~/.bashrc; then
  echo "$line_to_add" >> ~/.bashrc
fi

# Install realsense packages
# Instructions: https://github.com/IntelRealSense/realsense-ros
sudo apt install ros-jazzy-realsense2-*

# Done!
echo "[INFO] All installation steps done!"
