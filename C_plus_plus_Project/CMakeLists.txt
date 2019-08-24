cmake_minimum_required(VERSION 3.10)
PROJECT(C_plus_plus_Project CXX)
SET( PROJ_NAME  "Clion_Project" )
set(CMAKE_CXX_STANDARD 14)


############################     Portion needed for OpenCV - Part_1   ######################################

#set(CMAKE_BUILD_TYPE Release)

set("OpenCV_DIR" "/opt/OpenCV/3.6/")


set(CMAKE_PREFIX_PATH "/opt/OpenCV/3.6/")
set(OpenCV_INSTALL_PATH /opt/OpenCV/3.6/)
set(OpenCV_INCLUDE_DIRS "${OpenCV_INSTALL_PATH}/include/opencv;${OpenCV_INSTALL_PATH}/include")
set(OpenCV_LIBS "/opt/OpenCV/3.6/lib/")
find_package(OpenCV REQUIRED)


# If the package has been found, several variables will
# be set, you can find the full list with descriptions
# in the OpenCVConfig.cmake file.
# Print some message showing some of them
message(STATUS "OpenCV library status:")
message(STATUS "    version: ${OpenCV_VERSION}")
message(STATUS "    libraries: ${OpenCV_LIBS}")
message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")

if(UNIX)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=gnu++0x")
endif()
#################################    End of Portion Needed for OpenCV - Part_1  ############################






############################     Project files and folder inclusion    ######################################
include_directories(ImageFiltering)
include_directories(ImageFiltering/hdr)

include_directories(util)
include_directories(util/hdr)


add_executable(C_plus_plus_Project
        ImageFiltering/hdr/AnisotropicGaussianFilter.h
        util/hdr/BasicAlgo.h
        util/hdr/DirectoryHandler.hpp
        util/BasicAlgo.cpp
        util/DirectoryHandler.cpp
        model.yml
        TextGraphicsSeperation.cpp
        TextGraphichSeperationBulk.cpp TextGraphichSeperationBulk.h)
############################     End of Project files and folder inclusion    ######################################






############################     Portion needed for OpenCV - Part_2     ############################################
include_directories( ${OpenCV_INCLUDE_DIRS} )
target_link_libraries( C_plus_plus_Project ${OpenCV_LIBS})
TARGET_LINK_LIBRARIES(C_plus_plus_Project opencv_core opencv_features2d opencv_flann opencv_highgui opencv_imgproc opencv_ml
        opencv_objdetect opencv_photo opencv_stitching opencv_superres opencv_video opencv_highgui opencv_imgproc
        opencv_imgcodecs opencv_ximgproc opencv_calib3d opencv_imgcodecs)
#################################    End of Portion Needed for OpenCV - Part_2     #################################



############################     Portion needed for OpenMP    ######################################
# set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c++1y")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")


find_package(OpenMP)
if (OPENMP_FOUND)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()
#################################    End of Portion Needed for OpenMP     #################################



############################     Start of Portion needed for Boost    ######################################
FIND_PACKAGE(Boost ${BOOST_MIN_VERSION} REQUIRED)
SET (BOOST_ROOT "/usr/local/Cellar/boost@1.60/1.60.0/")
SET (BOOST_INCLUDEDIR "/usr/local/Cellar/boost@1.60/1.60.0/include")
SET (BOOST_LIBRARYDIR "/usr/local/Cellar/boost@1.60/1.60.0/lib")

SET (BOOST_MIN_VERSION "1.51.0")
set (Boost_NO_BOOST_CMAKE ON)
if (NOT Boost_FOUND)
    message(FATAL_ERROR "Fatal error: Boost (version >= 1.51) required.")
else()
    message(STATUS "Setting up BOOST")
    message(STATUS " Includes - ${Boost_INCLUDE_DIRS}")
    message(STATUS " Library  - ${Boost_LIBRARY_DIRS}")
    include_directories(${Boost_INCLUDE_DIRS})
    link_directories(${Boost_LIBRARY_DIRS})
endif (NOT Boost_FOUND)

find_package(Boost COMPONENTS regex date_time system filesystem graph program_options)

find_package(Boost REQUIRED regex date_time system filesystem graph program_options)
find_package(Boost COMPONENTS program_options REQUIRED)


if(Boost_FOUND)
    include_directories(${BOOST_INCLUDE_DIRS})
    link_directories(${Boost_LIBRARY_DIRS})
    add_definitions(${Boost_DEFINITIONS})

    target_link_libraries(C_plus_plus_Project ${Boost_LIBRARIES})
    target_link_libraries( C_plus_plus_Project ${Boost_PROGRAM_OPTIONS_LIBRARY} ${Boost_FILESYSTEM_LIBRARY} ${Boost_REGEX_LIBRARY} ${Boost_SYSTEM_LIBRARY})
endif()
############################     End of Portion needed for Boost     ########################################