# Build the project

Install dependencies: 

```bash
sudo apt upgrade

# Compilers and Build Tools
sudo apt install -y g++ ninja-build build-essential cmake git nasm autoconf pkg-config

# Media Libraries
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev

# Image Processing Libraries
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev openexr libdc1394-dev

# Math and Data Structure Libraries
sudo apt install -y libeigen3-dev libatlas-base-dev python3-numpy libtbb2 libtbb-dev

# X11 and Graphics Libraries
sudo apt install -y libxmu-dev libxi-dev libgl-dev libglu1-mesa-dev libxtst-dev libx11-dev libxft-dev libxext-dev libgles2-mesa-dev

# Other Libraries
sudo apt install -y libgtk-3-dev libboost-all-dev libudev-dev linux-libc-dev

# Tools
sudo apt install -y wget curl zip unzip tar gfortran
```

To build this project, run:

```bash
cmake --preset ninja-build
cmake --build --preset build-default
```

Test by running example (broken in VSCode terminal):
```bash
cd Examples
./Monocular/mono_euroc ../Vocabulary/ORBvoc.txt ./Monocular/EuRoC.yaml ../Datasets/EuRoC/MH01 ./Monocular/EuRoC_TimeStamps/MH01.txt dataset-MH01_mono
```