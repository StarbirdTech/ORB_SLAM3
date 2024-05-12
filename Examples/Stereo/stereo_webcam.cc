#include <iostream>
#include <chrono>
#include <opencv2/opencv.hpp>
#include "System.h"

using namespace std;
using namespace cv;

int main(int argc, char **argv)
{
    if (argc < 3)
    {
        cerr << "Usage: " << argv[0] << " path_to_vocabulary path_to_settings" << endl;
        return 1;
    }

    // Initialize two webcams
    VideoCapture capLeft(2);  // Laptop's built-in webcam
    VideoCapture capRight(4); // USB webcam

    if (!capLeft.isOpened() || !capRight.isOpened())
    {
        cerr << "Could not open cameras" << endl;
        return -1;
    }

    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM3::System SLAM(argv[1], argv[2], ORB_SLAM3::System::STEREO, true);

    // Main loop
    cv::Mat frameLeft, frameRight;
    double tframe = 0.0;
    while (true)
    {
        capLeft >> frameLeft;
        capRight >> frameRight;

        if (frameLeft.empty() || frameRight.empty())
        {
            cerr << "Failed to capture images from the cameras!" << endl;
            break;
        }

        // Process the stereo images
        SLAM.TrackStereo(frameLeft, frameRight, tframe);

        // Increment the time based on the frame rate
        tframe += 1.0 / 30.0; // Assuming a frame rate of 30 FPS

        if (waitKey(1) == 27) // ESC key
            break;
    }

    // Stop all threads
    SLAM.Shutdown();

    // Save camera trajectory
    SLAM.SaveTrajectoryEuRoC("CameraTrajectory.txt");
    SLAM.SaveKeyFrameTrajectoryEuRoC("KeyFrameTrajectory.txt");

    return 0;
}
