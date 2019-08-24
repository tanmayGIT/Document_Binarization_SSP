

//
//  TextGraphicsSeperation.cpp
//  DocScanImageProcessing
//
//  Created by tmondal on 16/07/2018.
//  Copyright © 2018 Tanmoy. All rights reserved.
//


#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>

#include "TextGraphichSeperationBulk.h"

#include <opencv2/ximgproc.hpp>
#include "opencv2/core/utility.hpp"
#include <highgui.h>
#include <cv.h>



using namespace cv::ximgproc;
int main(int argc, char** argv) {
    cv::Ptr<StructuredEdgeDetection> pDollar = createStructuredEdgeDetection("../model.yml");

    TextGraphichSeperationBulk operateOnALL = *new TextGraphichSeperationBulk();

    string Image_Path_1 = "../../Matlab_Code/Dataset/All_BackGd/"; // argv[1] ;
    string ResultSavingPath_1 =  "../../Matlab_Code/Dataset/All_Results_Grad/"; // argv[2];
    operateOnALL.ApplyBulkEdgeDetection(Image_Path_1, ResultSavingPath_1);

}


