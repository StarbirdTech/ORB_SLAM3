echo "Configuring and building Thirdparty/DBoW2 ..."

# cd Thirdparty/DBoW2
# mkdir build
# cd build
# cmake .. -DCMAKE_BUILD_TYPE=Release
# make -j

cmake -S Thirdparty/DBoW2 -B Thirdparty/DBoW2/build
cmake --build Thirdparty/DBoW2/build

# cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

# mkdir build
# cd build
# cmake .. -DCMAKE_BUILD_TYPE=Release
# make -j

cmake -S Thirdparty/g2o -B Thirdparty/g2o/build
cmake --build Thirdparty/g2o/build

# cd ../../Sophus

echo "Configuring and building Thirdparty/Sophus ..."

# mkdir build
# cd build
# cmake .. -DCMAKE_BUILD_TYPE=Release
# make -j

cmake -S Thirdparty/Sophus -B Thirdparty/Sophus/build
cmake --build Thirdparty/Sophus/build

# cd ../../../

echo "Uncompress vocabulary ..."

# cd Vocabulary
# tar -xf ORBvoc.txt.tar.gz
# cd ..

tar -xzf Vocabulary/ORBvoc.txt.tar.gz -C Vocabulary

echo "Configuring and building ORB_SLAM3 ..."

# mkdir build
# cd build
# cmake .. -DCMAKE_BUILD_TYPE=Release
# make -j4

cmake -S . -B build
cmake --build build