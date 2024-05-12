#include <iostream>
#include <chrono>
#include <thread>
#include <atomic>
#include <opencv2/opencv.hpp>
#include "System.h"

using namespace std;
using namespace cv;

// Global flag to control program execution
atomic<bool> quitFlag(false);

// Function to run in a separate thread that checks for exit commands
void checkForExit() {
    string input;
    while (!quitFlag) {
        cin >> input;
        if (input == "q" || input == "quit" || input == "exit") {
            quitFlag = true;
        }
    }
}

int main(int argc, char **argv)
{
    if (argc < 3)
    {
        cerr << "Usage: " << argv[0] << " path_to_vocabulary path_to_settings" << endl;
        return 1;
    }

    // Initialize webcam
    VideoCapture cap(2); // Open the default camera
    if (!cap.isOpened())  // Check if we succeeded
    {
        cerr << "Could not open camera" << endl;
        return -1;
    }

    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM3::System SLAM(argv[1], argv[2], ORB_SLAM3::System::MONOCULAR, true);

    // Start the exit command listening thread
    thread exitThread(checkForExit);

    // Main loop
    double tframe = 0.0;
    while (!quitFlag)
    {
        Mat frame;
        cap >> frame; // Get a new frame from camera
        if (frame.empty())
        {
            cerr << "Failed to capture image!" << endl;
            break;
        }

        // Process the image frame
        SLAM.TrackMonocular(frame, tframe);

        // Increment the time based on the frame rate
        tframe += 1.0 / 30.0; // Assuming a frame rate of 30 FPS
    }

    // Stop all threads
    SLAM.Shutdown();

    // Save camera trajectory if required
    SLAM.SaveTrajectoryEuRoC("CameraTrajectory.txt");
    SLAM.SaveKeyFrameTrajectoryEuRoC("KeyFrameTrajectory.txt");

    // Join the exit thread
    exitThread.join();

    return 0;
}
