/*
 * BasicAlgo.cpp
 *
 *  Created on: Feb 18, 2015
 *      Author: tanmoymondal
 */

#include "hdr/BasicAlgo.h"


BasicAlgo *BasicAlgo::instance = 0;

BasicAlgo *BasicAlgo::getInstance() {
    if (!instance)
        instance = new BasicAlgo();

    return instance;
}

BasicAlgo::BasicAlgo() {
}

BasicAlgo::~BasicAlgo() {
}

void BasicAlgo::showImage(cv::Mat &image) {
    cv::namedWindow("Display Image", cv::WINDOW_AUTOSIZE);
    cv::imshow("Display Image", image);
    cvWaitKey(0);
    cvDestroyWindow("Display Image");
}

void BasicAlgo::writeImage(cv::Mat &image) {
    imwrite("/Users/tmondal/Documents/Save_Image.jpg", image);
}


void BasicAlgo::writeImageGivenPath(cv::Mat &image, string path) {
    try {
        imwrite(path, image);
    } catch (const std::exception &e) {
        std::cout << e.what(); // information from length_error printed
    }
}



