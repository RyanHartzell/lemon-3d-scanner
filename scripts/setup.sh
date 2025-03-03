#!/usr/bin/env bash
#

sudo -v

# Grab jp2a for image to ascii art logo of RoSE Lab funnnnnn :)
sudo apt install jp2a
source /home/dev/.bashrc
#jp2a --colors --color-depth=24 --width=100 assets/RoSELab.png
jp2a --colors --color-depth=24 --width=80 --chars=~oO0z --background=light assets/lemon.png

echo "Welcome to the RoSE Lab LEMON Pi. We'll have this setup in no time!"
echo ""
echo ""
echo "[INFO] Starting system setup..."

echo "[INFO] Installing build tools..."
sudo apt update
sudo apt install git curl build-essential cmake -y

echo "[INFO] Build tools installation successful.... done!"

echo "[INFO] Installing dependencies..."

echo "[INFO] Install: OpenGL ES, Mesa, GLUT, GLEW"
sudo apt install mesa-utils libglu1-mesa-dev freeglut3-dev libglew-dev -y

echo "[INFO] Install: EIGEN"
sudo apt install libeigen3-dev -y

echo "[INFO] Dependency installation successful.... done!"

############################################################################
# Python setup

echo "[INFO] Installing Python 3.11 via UV project + package manager..."

if [[ ! -e /home/dev/.local/bin/uv ]];
then 
	wget -qO- https://astral.sh/uv/install.sh | bash
	source /home/dev/.bashrc
	echo 'eval "$(uv generate-shell-completion bash)"' >> /home/dev/.bashrc
	echo 'eval "$(uvx generate-shell-completion bash)"' >> /home/dev/.bashrc;
else
	echo "[INFO] uv and uvx already installed.... skipping!";
fi

if [[ ! -d .venv ]];
then 
	uv venv --python 3.11;
else
	echo "[INFO] Python 3.11 virtual environment already set up via uv at '/home/dev/.venv' ....skipping!"
fi

# Run a quick little test script to make sure we have access to Python 3.11 (and pyrealsense2 and opencv bindings)
source .venv/bin/activate
echo "[INFO] $(python -V) installation successful.... done!"

