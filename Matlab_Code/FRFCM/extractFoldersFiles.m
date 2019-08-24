clear;
close all 
clc 

mainFolderPath = '/Users/tmondal/Documents/Datasets/Univ_Diploma/All_Result_Dir/';
finalResultDir = '/Users/tmondal/Documents/Datasets/Univ_Diploma/Final_Result_Dir/';
% Get a list of all files and folders in this folder.
files = dir(mainFolderPath) ; 

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];

% Extract only those that are directories.
subFolders = files(dirFlags);

% Print folder names to command window.
s1 = '.';
s2 = '..';
cnt = 1;
parfor k = 1 : length(subFolders)
    if(  (~(strcmp((subFolders(k).name), s1)))  &&  (~(strcmp((subFolders(k).name), s2))) )
        folderNm = subFolders(k).name; 
        fullPath = strcat(mainFolderPath, folderNm, '/');
        originalImageName = strcat(fullPath, '1_original_Image.jpg');
        foreGdImageName = strcat(fullPath, '9_onlyForeGdImage.jpg');
        newResultFolder = strcat(finalResultDir, folderNm, '/');
        if ~exist(newResultFolder, 'dir')
            mkdir(newResultFolder);
        end
        origImg = imread(originalImageName);
        origImgSavingPath = strcat(newResultFolder,'original_Image.jpg' );
        imwrite(origImg,origImgSavingPath );
        
        foreGdImg = imread(foreGdImageName);
        segmentedImg = applyClustering(foreGdImg);
        
        segmentedImgSavingPath = strcat(newResultFolder,'Segmented_Image.jpg' );
        imwrite(segmentedImg,segmentedImgSavingPath );
        
        
%         filePattern = fullfile(fullPath, '*.jpg');
%         jpegFiles = dir(filePattern);
%         for tk = 1:length(jpegFiles)
%           baseFileName = jpegFiles(tk).name;
%           fullFileName = fullfile(fullPath, baseFileName);
%           fprintf(1, 'Now reading %s\n', fullFileName);
%           % imageArray = imread(fullFileName);
%         end
        
        
        
        
        % fprintf('Sub folder #%d = %s\n', cnt, subFolders(k).name);
        % cnt = cnt + 1;
    end
end