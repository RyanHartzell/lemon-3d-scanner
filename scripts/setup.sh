#!/usr/bin/env bash
#

sudo -v

# Grab jp2a for image to ascii art logo of RoSE Lab funnnnnn :)
sudo apt install jp2a
source $HOME/.bashrc
#jp2a --colors --color-depth=24 --width=100 assets/RoSELab.png
jp2a --colors --color-depth=24 --width=80 --chars=~oO0z --background=light $HOME/lemon-3d-scanner/assets/lemon.png

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

#echo "[INFO] Install: Miscellaneous other libraries from apt"
#sudo apt install libeigen3-dev -y


echo "[INFO] Dependency installation successful.... done!"

############################################################################
# Python setup (Should probably do this absolutely last!!! Need system site packages)

echo "[INFO] Installing Python 3.11 via UV project + package manager..."

cd $HOME/lemon-3d-scanner

if [[ ! -e $HOME/.local/bin/uv ]];
then 
	wget -qO- https://astral.sh/uv/install.sh | bash
else
	echo "[INFO] uv and uvx already installed.... skipping!";
fi

source $HOME/.local/bin/env
eval "$(uv generate-shell-completion bash)"
eval "$(uvx generate-shell-completion bash)"

if [[ ! -d .venv ]];
then 
	# Create venv for lemon-3d-scanner which makes available all ros2 python packages at system level
	uv venv --system-site-packages --python 3.11;
else
	echo "[INFO] Python 3.11 virtual environment already set up via uv at '"$HOME"/lemon-3d-scanner/.venv' ....skipping!"
fi

# Run a quick little test script to make sure we have access to Python 3.11 (and pyrealsense2 and opencv bindings)
source .venv/bin/activate

# Install pyrealsense (possibly from intelrealsense/build dir)? Other useful libs like scipy, numpy, matplotlib?
# uv pip install <package list>

echo "[INFO] $(python -V) installation successful.... done!"

