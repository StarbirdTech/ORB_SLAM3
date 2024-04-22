#!/bin/bash

# Default verbosity flag
VERBOSE_FLAG=""

# Parse command line arguments
for arg in "$@"
do
    case $arg in
        -v|--verbose)
        VERBOSE_FLAG="-DVERBOSE=ON"
        shift # Remove --verbose or -v from processing
        ;;
    esac
done

echo "Configuring and building Thirdparty/DBoW2 ..."
cmake -S Thirdparty/DBoW2 -B Thirdparty/DBoW2/build
cmake --build Thirdparty/DBoW2/build

echo "Configuring and building Thirdparty/g2o ..."
cmake -S Thirdparty/g2o -B Thirdparty/g2o/build
cmake --build Thirdparty/g2o/build

echo "Configuring and building Thirdparty/Sophus ..."
cmake -S Thirdparty/Sophus -B Thirdparty/Sophus/build
cmake --build Thirdparty/Sophus/build

echo "Uncompress vocabulary ..."
tar -xzf Vocabulary/ORBvoc.txt.tar.gz -C Vocabulary

echo "Configuring and building ORB_SLAM3 ..."
cmake -S . -B build $VERBOSE_FLAG
cmake --build build
