clear;
close 
clc;

mainFolderPath = '/Volumes/Study_Materials/Dataset/Binarization/Selected_DIBCO/Seperated_Final_Result/DIBCO_14/GT/';
files = dir(mainFolderPath) ; 

S = dir(fullfile(mainFolderPath,'*.tiff')); % pattern to match filenames.
for k = 1:numel(S)
    F = fullfile(mainFolderPath,S(k).name);
    [filepath,name,ext] = fileparts(F); 
    Img = imread(F);
    if(size(Img,3)==3)
        Img = rgb2gray(Img);
    end

%     for ii = 1:1:size(Img,1)
%         for jj = 1:1:size(Img,2)
%             if(Img(ii,jj) < 80)
%                Img(ii,jj) = 0;
%             else
%                 Img(ii,jj) = 255;
%             end
%         end
%     end
%     uniqueVals = unique(Img);
%     if(length(uniqueVals) >2)
%         error('there is a problem');
%     end
    imgNamNew = strcat(mainFolderPath, name, '.bmp');
    imwrite(Img,imgNamNew);
end   
    
disp('see me');    
