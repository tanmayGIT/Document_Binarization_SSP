/*
 * DirectoryHandler.cpp
 *
 *  Created on: Feb 7, 2015
 *      Author: tanmoymondal
 */

#include "hdr/DirectoryHandler.hpp"

namespace std {
    
    DirectoryHandler* DirectoryHandler::instance = 0; // initilizing the object of the class
    
    DirectoryHandler* DirectoryHandler::getInstance() { // the function for getting the object of the class
        if (!instance)
            instance = new DirectoryHandler();
        
        return instance;
    }
    
    
    DirectoryHandler::DirectoryHandler() {
        
    }
    
    DirectoryHandler::~DirectoryHandler() {
        delete instance; // clearing the object
    }

    /**
     * For unixoid systems only: Lists all files in a given directory and returns a vector of path+name in string format
     * @param dirName
     * @param fileNames found file names in specified directory
     * @param validExtensions containing the valid file extensions for collection in lower case
     */
    void DirectoryHandler::getFilesInDirectory(const string& dirName, vector<string>& fileNames, const vector<string>& validExtensions) {
        printf("Opening directory %s\n", dirName.c_str());
        struct dirent* ep;
        size_t extensionLocation;
        DIR* dp = opendir(dirName.c_str());
        if (dp != NULL) {
            while ((ep = readdir(dp))) {
                // Ignore (sub-)directories like . , .. , .svn, etc.
                if (ep->d_type & DT_DIR) {
                    continue;
                }
                extensionLocation = string(ep->d_name).find_last_of("."); // Assume the last point marks beginning of extension like file.ext
                // Check if extension is matching the wanted ones
                string tempExt = toLowerCase(string(ep->d_name).substr(extensionLocation + 1));
                if (find(validExtensions.begin(), validExtensions.end(), tempExt) != validExtensions.end()) {
                    //   printf("Found matching data file '%s'\n", ep->d_name);
                    fileNames.push_back((string) dirName + ep->d_name);
                } else {
                    //  printf("Found file does not match required file type, skipping: '%s'\n", ep->d_name);
                }
            }
            (void) closedir(dp);
        } else {
            printf("Error opening directory '%s'!\n", dirName.c_str());
        }
        return;
    }
    string DirectoryHandler::toLowerCase(const string& in) {
        string t;
        for (string::const_iterator i = in.begin(); i != in.end(); ++i) {
            t += tolower(*i);
        }
        return t;
    }


} /* namespace std */

