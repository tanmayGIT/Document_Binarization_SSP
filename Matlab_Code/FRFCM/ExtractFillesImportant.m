clear;
close all
clc

mainFolderPath = '/Volumes/Study_Materials/Datasets/L3i-Text-Copies/Dataset/Scans/';
savingDir_1 = '/Volumes/Study_Materials/Datasets/L3i-Text-Copies/Dataset/Selected_Images/600/';
savingDir_2 = '/Volumes/Study_Materials/Datasets/L3i-Text-Copies/Dataset/Selected_Images/300/';

filePattern = fullfile(mainFolderPath, '*.jpg');
jpegFiles = dir(filePattern);
cnt = 0;
for tk = 1:length(jpegFiles)
    baseFileName = jpegFiles(tk).name;
    splitedNm = strsplit(baseFileName, '-');
    extraNm = strsplit(splitedNm{1,end}, '.');
    if(  ( (strcmp(splitedNm{1,5}, 'Tim')) )  && ...
        ( (strcmp(splitedNm{1,4}, '10')) || (strcmp(splitedNm{1,4}, '12')) )    )
        if(strcmp(splitedNm{1,3}, '300')) 
            fullFileName = fullfile(mainFolderPath, baseFileName);
            fprintf(1, 'Now reading %s\n', fullFileName);
            imageArray = imread(fullFileName);
            savingFullNm = fullfile(savingDir_2,baseFileName);
            % savingFullNm = convertCharsToStrings(savingFullNm);
            if exist(savingFullNm, 'file')
                delete(savingFullNm)        
            end
            imwrite(imageArray, savingFullNm, 'jpg');
            cnt = cnt + 1;
        elseif (strcmp(splitedNm{1,3}, '600'))
            fullFileName = fullfile(mainFolderPath, baseFileName);
            fprintf(1, 'Now reading %s\n', fullFileName);
            imageArray = imread(fullFileName);
            savingFullNm = fullfile(savingDir_1,baseFileName);
            imwrite(imageArray, savingFullNm);
            cnt = cnt + 1;
        end
    end
 
end
disp(cnt);