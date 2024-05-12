cmake_minimum_required(VERSION 3.19)
project(ORB_SLAM3)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(Boost_NO_WARN_NEW_VERSIONS 1)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})

# Global compiler options
add_compile_options(-Wall -O3)

# Option to enable verbose output
option(VERBOSE "Enable verbose output, including compiler warnings" OFF)

if(NOT VERBOSE)
  add_compile_options(
    $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-w>
    $<$<CXX_COMPILER_ID:MSVC>:/W0>
  )
endif()

# Release-specific optimization
if(CMAKE_BUILD_TYPE STREQUAL "Release")
  add_compile_options(-march=native)
endif()

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

# Add third-party dependencies
add_subdirectory(Thirdparty/DBoW2)
add_subdirectory(Thirdparty/g2o)
add_subdirectory(Thirdparty/Sophus)

# Uncompress vocabulary as part of the build process
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/Vocabulary/ORBvoc.txt
    COMMAND tar -xzf ${CMAKE_CURRENT_SOURCE_DIR}/Vocabulary/ORBvoc.txt.tar.gz -C ${CMAKE_CURRENT_SOURCE_DIR}/Vocabulary
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vocabulary/ORBvoc.txt.tar.gz
    COMMENT "Uncompressing vocabulary"
)
add_custom_target(uncompress_vocabulary ALL DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vocabulary/ORBvoc.txt)

add_library(${PROJECT_NAME} SHARED
src/System.cc
src/Tracking.cc
src/LocalMapping.cc
src/LoopClosing.cc
src/ORBextractor.cc
src/ORBmatcher.cc
src/FrameDrawer.cc
src/Converter.cc
src/MapPoint.cc
src/KeyFrame.cc
src/Atlas.cc
src/Map.cc
src/MapDrawer.cc
src/Optimizer.cc
src/Frame.cc
src/KeyFrameDatabase.cc
src/Sim3Solver.cc
src/Viewer.cc
src/ImuTypes.cc
src/G2oTypes.cc
src/CameraModels/Pinhole.cpp
src/CameraModels/KannalaBrandt8.cpp
src/OptimizableTypes.cpp
src/MLPnPsolver.cpp
src/GeometricTools.cc
src/TwoViewReconstruction.cc
src/Config.cc
src/Settings.cc
include/System.h
include/Tracking.h
include/LocalMapping.h
include/LoopClosing.h
include/ORBextractor.h
include/ORBmatcher.h
include/FrameDrawer.h
include/Converter.h
include/MapPoint.h
include/KeyFrame.h
include/Atlas.h
include/Map.h
include/MapDrawer.h
include/Optimizer.h
include/Frame.h
include/KeyFrameDatabase.h
include/Sim3Solver.h
include/Viewer.h
include/ImuTypes.h
include/G2oTypes.h
include/CameraModels/GeometricCamera.h
include/CameraModels/Pinhole.h
include/CameraModels/KannalaBrandt8.h
include/OptimizableTypes.h
include/MLPnPsolver.h
include/GeometricTools.h
include/TwoViewReconstruction.h
include/SerializationUtils.h
include/Config.h
include/Settings.h)

set(OpenCV_DIR "${VCPKG_INSTALLED_DIR}/x64-linux/share/opencv4")

# Finding packages
find_package(OpenCV REQUIRED)
find_package(Eigen3 REQUIRED NO_MODULE)
find_package(Pangolin CONFIG REQUIRED)
find_package(realsense2 CONFIG REQUIRED)
find_package(Boost REQUIRED COMPONENTS serialization)
find_package(OpenSSL REQUIRED)

target_include_directories(${PROJECT_NAME}
  PUBLIC
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/include/CameraModels
    ${EIGEN3_INCLUDE_DIR}
    ${Pangolin_INCLUDE_DIRS}
    ${OpenCV_INCLUDE_DIRS}
    ${PROJECT_SOURCE_DIR}/Thirdparty/DBoW2
    ${PROJECT_SOURCE_DIR}/Thirdparty/Sophus
)

target_link_libraries(${PROJECT_NAME}
  PUBLIC
    ${OpenCV_LIBS}
    Eigen3::Eigen
    ${Pangolin_LIBRARIES}
    realsense2::fw realsense2::usb realsense2::rsutils realsense2::realsense2
    Boost::boost Boost::serialization
    ${PROJECT_SOURCE_DIR}/Thirdparty/DBoW2/lib/libDBoW2.so
    ${PROJECT_SOURCE_DIR}/Thirdparty/g2o/lib/libg2o.so
    OpenSSL::SSL OpenSSL::Crypto
)

add_dependencies(${PROJECT_NAME} uncompress_vocabulary)

# Build examples

# Example executables
function(add_example_target TARGET_NAME SOURCE_FILE FOLDER_NAME)
  add_executable(${TARGET_NAME} ${SOURCE_FILE})
  target_link_libraries(${TARGET_NAME} ${PROJECT_NAME})
  set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/${FOLDER_NAME})
endfunction()

# Examples by category
foreach(category IN ITEMS "RGB-D" "Stereo" "Monocular" "RGB-D-Inertial" "Stereo-Inertial" "Monocular-Inertial")
  file(GLOB example_sources "${PROJECT_SOURCE_DIR}/Examples/${category}/*.cc")
  foreach(source_file IN LISTS example_sources)
    get_filename_component(example_name ${source_file} NAME_WE)
    add_example_target("${example_name}" ${source_file} ${category})
  endforeach()
endforeach()
