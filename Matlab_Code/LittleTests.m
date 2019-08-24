clear;
close 
clc;

% This is the program for changinng the extension of image files. Mainly
% the GT files extensions are inconsistent. The extension ".tiff" and
% ".tif" often have some problem with openCV. As the executable of DIBCO
% competetion has used openCV, so when I wan trying to execute the exe it
% was giving errors for the .tiff and .tif files. So, I thought to make it
% symmetric and make all the GT as .bmp extension for all the DIBCO
% competetion. 


% To run this program, you need to change the folder path, containing all
% the images and as a result it will give you all the images with .bmp
% extension in the same folder. The files with .tiff extension will be
% deleted. 

mainFolderPath = '/Dataset/Seperated_All_Results_New/DIBCO_14/GT/';
files = dir(mainFolderPath) ; 

S = dir(fullfile(mainFolderPath,'*.tiff')); % pattern to match filenames.
for k = 1:numel(S)
    F = fullfile(mainFolderPath,S(k).name);
    [filepath,name,ext] = fileparts(F); 
    Img = imread(F);
    if(size(Img,3)==3)
        Img = rgb2gray(Img);
    end
    delete (F);
    imgNamNew = strcat(mainFolderPath, name, '.bmp');
    imwrite(Img,imgNamNew);
end   
    
disp('see me');    
