# Build the project

Install dependencies: 

```bash
sudo apt upgrade
sudo apt install -y g++ ninja-build wget curl zip unzip tar libxmu-dev libxi-dev libgl-dev build-essential cmake git pkg-config libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev gfortran openexr libatlas-base-dev python3-dev python3-numpy libtbb2 libtbb-dev libdc1394-dev libeigen3-dev nasm libglu1-mesa-dev libboost-all-dev libxi-dev libxtst-dev libx11-dev libxft-dev libxext-dev libx11-dev libgles2-mesa-dev autoconf libudev-dev linux-libc-dev
```

To build this project, run:

```bash
cmake --preset ninja-build
cmake --build --preset build-default
```

Test by running example:
```bash
./Monocular/mono_euroc ../Vocabulary/ORBvoc.txt ./Monocular/EuRoC.yaml ../Datasets/EuRoC/MH01 ./Monocular/EuRoC_TimeStamps/MH01.txt dataset-MH01_mono
```