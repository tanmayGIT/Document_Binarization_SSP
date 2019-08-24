//
// Created by tmondal on 26/07/2018.
//

#ifndef CLION_PROJECT_ANISOTROPICGAUSSIANFILTER_H
#define CLION_PROJECT_ANISOTROPICGAUSSIANFILTER_H

#define UCHAR_T unsigned char

#include<iostream>
#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<opencv2/imgproc/imgproc.hpp>

using namespace std;
using namespace cv;

class AnisotropicGaussianFilter {

public:
    AnisotropicGaussianFilter(){
    }

    const double lambda = 1.0 / 7.0;
    const double k = 30;
    const int iter = 15;


    float ahN[3][3] = { {0, 1, 0}, {0, -1, 0}, {0, 0, 0} };
    float ahS[3][3] = { {0, 0, 0}, {0, -1, 0}, {0, 1, 0} };
    float ahE[3][3] = { {0, 0, 0}, {0, -1, 1}, {0, 0, 0} };
    float ahW[3][3] = { {0, 0, 0}, {1, -1, 0}, {0, 0, 0} };
    float ahNE[3][3] = { {0, 0, 1}, {0, -1, 0}, {0, 0, 0} };
    float ahSE[3][3] = { {0, 0, 0}, {0, -1, 0}, {0, 0, 1} };
    float ahSW[3][3] = { {0, 0, 0}, {0, -1, 0}, {1, 0, 0} };
    float ahNW[3][3] = { {1, 0, 0}, {0, -1, 0}, {0, 0, 0} };

    Mat hN = Mat(3, 3, CV_32FC1, &ahN);
    Mat hS = Mat(3, 3, CV_32FC1, &ahS);
    Mat hE = Mat(3, 3, CV_32FC1, &ahE);
    Mat hW = Mat(3, 3, CV_32FC1, &ahW);
    Mat hNE = Mat(3, 3, CV_32FC1, &ahNE);
    Mat hSE = Mat(3, 3, CV_32FC1, &ahSE);
    Mat hSW = Mat(3, 3, CV_32FC1, &ahSW);
    Mat hNW = Mat(3, 3, CV_32FC1, &ahNW);

    void doAnisotropicDiffusionFiltering(Mat &output, int width, int height) {

        //mat initialisation
        Mat nablaN, nablaS, nablaW, nablaE, nablaNE, nablaSE, nablaSW, nablaNW;
        Mat cN, cS, cW, cE, cNE, cSE, cSW, cNW;

        //depth of filters
        int ddepth = -1;

        //center pixel distance
        double dx = 1, dy = 1, dd = sqrt(2);
        double idxSqr = 1.0 / (dx * dx), idySqr = 1.0 / (dy * dy), iddSqr = 1 / (dd * dd);

        for (int i = 0; i < iter; i++) {

            //filters
            filter2D(output, nablaN, ddepth, hN);
            filter2D(output, nablaS, ddepth, hS);
            filter2D(output, nablaW, ddepth, hW);
            filter2D(output, nablaE, ddepth, hE);
            filter2D(output, nablaNE, ddepth, hNE);
            filter2D(output, nablaSE, ddepth, hSE);
            filter2D(output, nablaSW, ddepth, hSW);
            filter2D(output, nablaNW, ddepth, hNW);

            //exponential flux
            cN = nablaN / k;
            cN = cN.mul(cN);
            cN = 1.0 / (1.0 + cN);
            //exp(-cN, cN);

            cS = nablaS / k;
            cS = cS.mul(cS);
            cS = 1.0 / (1.0 + cS);
            //exp(-cS, cS);

            cW = nablaW / k;
            cW = cW.mul(cW);
            cW = 1.0 / (1.0 + cW);
            //exp(-cW, cW);

            cE = nablaE / k;
            cE = cE.mul(cE);
            cE = 1.0 / (1.0 + cE);
            //exp(-cE, cE);

            cNE = nablaNE / k;
            cNE = cNE.mul(cNE);
            cNE = 1.0 / (1.0 + cNE);
            //exp(-cNE, cNE);

            cSE = nablaSE / k;
            cSE = cSE.mul(cSE);
            cSE = 1.0 / (1.0 + cSE);
            //exp(-cSE, cSE);

            cSW = nablaSW / k;
            cSW = cSW.mul(cSW);
            cSW = 1.0 / (1.0 + cSW);
            //exp(-cSW, cSW);

            cNW = nablaNW / k;
            cNW = cNW.mul(cNW);
            cNW = 1.0 / (1.0 + cNW);
            //exp(-cNW, cNW);

            output = output + lambda * (idySqr * cN.mul(nablaN) + idySqr * cS.mul(nablaS) +
                                        idxSqr * cW.mul(nablaW) + idxSqr * cE.mul(nablaE) +
                                        iddSqr * cNE.mul(nablaNE) + iddSqr * cSE.mul(nablaSE) +
                                        iddSqr * cNW.mul(nablaNW) + iddSqr * cSW.mul(nablaSW));
        }
    }


};


#endif //CLION_PROJECT_ANISOTROPICGAUSSIANFILTER_H
