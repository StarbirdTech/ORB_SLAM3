### Install Pangolin
cd
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
./vcpkg install pangolin
sudo apt-get install libxmu-dev libxi-dev libgl-dev

### Install Eigen
sudo apt install libeigen3-dev

### Install OpenCV
cd
sudo apt update
sudo apt install build-essential
sudo apt install cmake
sudo apt install git
sudo apt install pkg-config libgtk-3-dev
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
sudo apt install libjpeg-dev libpng-dev libtiff-dev gfortran openexr libatlas-base-dev
sudo apt install python3-dev python3-numpy libtbb2 libtbb-dev libdc1394-dev

cd ~
mkdir opencv_with_contrib
cd opencv_with_contrib
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

cd opencv
git checkout 4.5.1
cd ../opencv_contrib
git checkout 4.5.1
cd ..

mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE -D OPENCV_GENERATE_PKGCONFIG=ON -DOPENCV_ENABLE_NONFREE=ON -DENABLE_PRECOMPILED_HEADERS=OFF -DOPENCV_EXTRA_MODULES_PATH=~/opencv_with_contrib/opencv_contrib/modules -DBUILD_opencv_legacy=OFF -DCMAKE_INSTALL_PREFIX=/usr/local ../opencv            
make -j4 #increasing the number will make building faster. Maximum value can be found by running nproc.
sudo make install

#OpenCV include path for gcc
echo 'export CPLUS_INCLUDE_PATH=/usr/local/include/opencv4' >> ~/.bashrc

# Test OpenCV install
python -c "import cv2; print(cv2.__version__)"

### Install Python
sudo apt install libpython2.7-dev