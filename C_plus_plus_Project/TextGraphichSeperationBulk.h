//
// Created by tmondal on 14/02/2019.
//

#ifndef CLION_PROJECT_TEXTGRAPHICHSEPERATIONBULK_H
#define CLION_PROJECT_TEXTGRAPHICHSEPERATIONBULK_H

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <chrono>

#include "util/hdr/DirectoryHandler.hpp"
#include "util/hdr/BasicAlgo.h"
#include "AnisotropicGaussianFilter.h"
#include <opencv2/ximgproc.hpp>
#include "opencv2/core/utility.hpp"
#include <highgui.h>
#include <cv.h>

using namespace cv::ximgproc;
using namespace std;
using namespace cv;

class TextGraphichSeperationBulk {
public:

    void ApplyBulkEdgeDetection(string allImgDir, string resultSavingDir) {

        DirectoryHandler *instance = DirectoryHandler::getInstance();
        cv::Ptr<StructuredEdgeDetection> pDollar = createStructuredEdgeDetection("../model.yml");


        // Get the image files
        vector<string> validImgFileNames;
        vector<string> validImgExtensions;
        validImgExtensions.push_back("png");
        validImgExtensions.push_back("jpg");
        validImgExtensions.push_back("bmp");
        validImgExtensions.push_back("tiff");
        validImgExtensions.push_back("tif");
        if (boost::filesystem::exists(allImgDir))
            instance->getFilesInDirectory(allImgDir, validImgFileNames, validImgExtensions);

// #pragma omp parallel
        for (auto const &imgFilePath: validImgFileNames) {
            boost::filesystem::path getImgPath(imgFilePath); // getting only the file name
            string onlyNm = getImgPath.filename().string(); //  getting only the file name with extension
            string keepNmExt = onlyNm;

            string imgFullPath = allImgDir + onlyNm;
            Mat imgOrig = imread(imgFullPath, CV_LOAD_IMAGE_ANYDEPTH | CV_LOAD_IMAGE_UNCHANGED);

            if (imgOrig.empty()) {
                std::cerr << "File not available for reading" << std::endl;
            }
            Mat imgGrey = imgOrig.clone(); // keeping seperately the original image

            // auto start = chrono::steady_clock::now();
            if (imgGrey.channels() >= 3)
                cv::cvtColor(imgGrey, imgGrey, CV_BGR2GRAY);
            int subtractThresh = 0;
            Mat imgGreyCropped = imgGrey(
                    Rect(subtractThresh, subtractThresh, imgGrey.cols - subtractThresh, imgGrey.rows - subtractThresh));
            //   **********************************   Doing Random Forest Based Edge Detection ********************************
            Mat colorImg;
            cv::cvtColor(imgGreyCropped, colorImg, cv::COLOR_GRAY2BGR);
            Mat3b imgGreyCopy = (Mat3b) colorImg.clone();
            colorImg.release();

            Mat3f f_imgGrey;
            imgGreyCopy.convertTo(f_imgGrey, CV_32F, 1.0 / 255.0); // Convert source image to [0;1] range
            imgGreyCopy.release();

            Mat1f edgeImage;
            pDollar->detectEdges(f_imgGrey, edgeImage);
            f_imgGrey.release();

            // computes orientation from edge map
            Mat orientation_map;
            pDollar->computeOrientation(edgeImage, orientation_map);
            // suppress edges
            Mat edge_nms;
            pDollar->edgesNms(edgeImage, orientation_map, edge_nms, 2, 0, 1, true);
            edgeImage = 255 * edgeImage;

            BasicAlgo::getInstance()->writeImageGivenPath(edgeImage, "/home/mondal/Documents/Save_Image.png");
            // BasicAlgo::getInstance()->writeImage(edgeImage);
            // BasicAlgo::getInstance()->writeImageGivenPath(edgeImage, "/home/mondal/Documents/2_gradient_Image.jpg");

            orientation_map.release();
            edgeImage.release();
            //   **********************************   End of Random Forest Based Edge Detection ********************************



            Mat gray_image = imread("/home/mondal/Documents/Save_Image.png", CV_LOAD_IMAGE_GRAYSCALE);

            // *****               Anisotropic diffusion filter                    *****  //
            Mat filteredImage = gray_image.clone();
            filteredImage.convertTo(filteredImage, CV_32FC1);

            AnisotropicGaussianFilter filtImag = *new AnisotropicGaussianFilter();
            filtImag.doAnisotropicDiffusionFiltering(filteredImage, filteredImage.cols, filteredImage.rows);
            double min;
            double max;
            minMaxIdx(filteredImage, &min, &max);
            filteredImage.convertTo(filteredImage, CV_8UC1, 255 / (max - min), -min);
            // BasicAlgo::getInstance()->writeImageGivenPath(filteredImage, "/home/mondal/Documents/3_filtered_Image.jpg");
            gray_image.release();


            // *****               Apply Canny Edge Detection                   *****  //
            Mat dummyMat;
            double otsuThreshVal = cv::threshold(filteredImage, dummyMat, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
            dummyMat.release(); // delete the dummy mat
            double highThreshCanny = otsuThreshVal;
            double lowThreshCanny = otsuThreshVal * 0.5;
            Canny(filteredImage, filteredImage, lowThreshCanny, highThreshCanny, 3);
            // BasicAlgo::getInstance()->writeImageGivenPath(filteredImage, "/home/mondal/Documents/4_canny_Image.jpg");

            string resultImgSavingName = resultSavingDir + "/" + onlyNm;
            BasicAlgo::getInstance()->writeImageGivenPath(filteredImage, resultImgSavingName);

        }
    }

};

#endif //CLION_PROJECT_TEXTGRAPHICHSEPERATIONBULK_H
