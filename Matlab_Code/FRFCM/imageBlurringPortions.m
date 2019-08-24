clear
close all
clc

imgFullPath = '/Volumes/Study_Materials/Dataset/Univ_Diploma/BDD3_JPEG/scan fujitsu copy/p04_CS_SF_NVG_300.jpg';
origImg = imread(imgFullPath);

if(size(origImg,3)==3)
    origImg = rgb2gray(origImg);
end