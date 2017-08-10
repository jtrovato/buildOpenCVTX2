#!/bin/bash
cd $HOME
sudo apt-get install -y \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng12-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    libgtk-3-dev \
    cmake \
    pkg-config \
    build-essential \
    libatlas-base-dev \
    gfortran \
    

# Python 2.7
sudo apt-get install -y python2.7-dev python3.5-dev python-numpy python-py python-pytest -y

cd ~
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.2.0.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.2.0.zip
unzip opencv_contrib.zip


cd ~/opencv-3.2.0
mkdir build
cd build
# Jetson TX2 
cmake \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D BUILD_PNG=OFF \
    -D BUILD_TIFF=OFF \
    -D BUILD_TBB=OFF \
    -D BUILD_JPEG=OFF \
    -D BUILD_JASPER=OFF \
    -D BUILD_ZLIB=OFF \
    -D BUILD_EXAMPLES=ON \
    -D BUILD_opencv_java=OFF \
    -D BUILD_opencv_python2=ON \
    -D BUILD_opencv_python3=OFF \
    -D ENABLE_PRECOMPILED_HEADERS=OFF \
    -D WITH_OPENCL=OFF \
    -D WITH_OPENMP=OFF \
    -D WITH_FFMPEG=ON \
    -D WITH_GSTREAMER=OFF \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_CUDA=ON \
    -D WITH_GTK=ON \
    -D WITH_VTK=OFF \
    -D WITH_TBB=ON \
    -D WITH_1394=ON \
    -D WITH_OPENEXR=OFF \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
    -D CUDA_ARCH_BIN=6.2 \
    -D CUDA_ARCH_PTX="" \
    -D INSTALL_PYTHON_EXAMPLES=OFF\
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_TESTS=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.2.0/modules \
    ../

# delete condition that disables dnn if on AARCH64 system
sed -i '4d' ~/opencv_contrib-3.2.0/modules/dnn/CMakeLists.txt
cmake ..

# Consider using all 6 cores; $ sudo nvpmodel -m 2 or $ sudo nvpmodel -m 0
make -j4
sudo make install

sudo rm /opt/ros/kinetic/lib/python2.7/dist-packages/cv2.so
sudo ln -s /usr/local/lib/python2.7/dist_packages/cv2.so /opt/ros/kinetic/lib/python2.7/dist-packages/cv2.so
