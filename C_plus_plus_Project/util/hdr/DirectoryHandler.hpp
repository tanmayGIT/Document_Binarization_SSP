/*
 * DirectoryHandler.h
 *
 *  Created on: Feb 7, 2015
 *      Author: tanmoymondal
 */
#pragma once

#include <stdio.h>
#include <dirent.h>
#include <ios>

#include <sys/uio.h>     // For access().
#include <sys/types.h>  // For stat().
#include <sys/stat.h>   // For stat().

#include <fstream>
#include <iostream>
#include <string.h>
#include <stdexcept>
#include <vector>
#include <sstream>// used for istringstream
#include <map>
#include <utility>
#include <algorithm>

#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/photo/photo.hpp>

#include <boost/range/algorithm.hpp>
#include <boost/filesystem.hpp>
#include <boost/range/irange.hpp>
#include <boost/format.hpp>
#include <boost/algorithm/string.hpp>


#ifndef DIRECTORYHANDLER_H_
#define DIRECTORYHANDLER_H_

namespace std {
    
    class DirectoryHandler {
    public:
        DirectoryHandler();
        virtual ~DirectoryHandler();
        void getFilesInDirectory(const string&, vector<string>&, const vector<string>&);
        string toLowerCase(const string& in);

        static DirectoryHandler* getInstance();

    private:
        static DirectoryHandler* instance;
        
    };
    
} /* namespace std */

#endif /* DIRECTORYHANDLER_H_ */
