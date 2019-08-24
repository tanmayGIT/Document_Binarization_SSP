/*
 * BasicAlgo.h
 *
 *  Created on: Feb 18, 2015
 *      Author: tanmoymondal
 */

#ifndef BASICALGO_H_
#define BASICALGO_H_

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>

#include <opencv2/features2d/features2d.hpp>

#include "opencv/cv.h"
#include "opencv/cxcore.h"

#include <vector>
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <string>
#include <stdlib.h>
#include <algorithm>
#include <set>
#include <iterator>
#include <string.h>
#include <math.h>
#include <limits>
#include <stdexcept>

using namespace cv;
using namespace std;

class BasicAlgo {
public:
    BasicAlgo();

    static BasicAlgo *getInstance();

    virtual ~BasicAlgo();

    void showImage(cv::Mat &);
    void writeImage(cv::Mat &);
    void writeImageGivenPath(cv::Mat &, string);


private:
    static BasicAlgo *instance;
};


#endif /* BASICALGO_H_ */
