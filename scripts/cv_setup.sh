#!/usr/bin/env bash

# This script installs all dependencies and OpenCV from source
#    NOTE: Assumes we're executing with sudo privs

echo "[INFO] Beginning OpenCV installation process..."

# Install deps
echo "[INFO] Installing build dependencies..."
sudo apt install pkg-config git libjpeg-dev libpng-dev libtiff-dev libavformat-dev libxvidcore-dev libv4l-dev libopenblas-dev libtbb-dev

# Get opencv source
echo "[INFO] Downloading OpenCV source from Github..."

# Configure and Build OpenCV using CMake, specifying all available hardware accelerations (NEON, TBB, etc)
# SPECIFY WITH_LIBREALSENSE DURING BUILD!!!!!!!!

echo "[INFO] "
echo "[INFO] "
echo "[INFO] "
echo "[INFO] "
echo "[INFO] "
echo "[INFO] "
echo "[INFO] "
