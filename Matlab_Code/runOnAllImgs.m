clear;
close all
clc

allImgFolderPath = 'Dataset/AllImages/';
savingDir = 'Dataset/All_Results/';
addpath('FRFCM/');

S = [dir(fullfile(allImgFolderPath,'*.tiff'));dir(fullfile(allImgFolderPath,'*.tif'));...
    dir(fullfile(allImgFolderPath,'*.jpg'));dir(fullfile(allImgFolderPath,'*.png'));
    dir(fullfile(allImgFolderPath,'*.bmp'))]; % pattern to match filenames.

% use parfor instead for -- for parallel processing
for k = 1:numel(S)
    fullFilePath = fullfile(allImgFolderPath,S(k).name);  % read the image file from GT
    origImg = imread(fullFilePath);
    
    
    [binImg] = RunBinarizationAllImg_1(origImg, fullFilePath);
    savingFullNm = strcat(savingDir, S(k).name);
    colorImg = origImg;
    
    imwrite(binImg, savingFullNm);
end

