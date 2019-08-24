clear
clc
close

mainFolderPath = '/Volumes/Miscellaneous/Windows_Virtual_Shared/Seperated_All_Results_New/DIBCO_09/GT/';
resultFolderPath = '/Volumes/Miscellaneous/Windows_Virtual_Shared/Seperated_All_Results_New/DIBCO_09/AlgoResult/';
files = dir(mainFolderPath) ; 

S = [dir(fullfile(mainFolderPath,'*.tiff'));dir(fullfile(mainFolderPath,'*.tif'));...
    dir(fullfile(mainFolderPath,'*.jpg'));dir(fullfile(mainFolderPath,'*.png'));
    dir(fullfile(mainFolderPath,'*.bmp'))]; % pattern to match filenames.

S1 = [dir(fullfile(resultFolderPath,'*.tiff'));dir(fullfile(resultFolderPath,'*.tif'));...
    dir(fullfile(resultFolderPath,'*.jpg'));dir(fullfile(resultFolderPath,'*.png'));
    dir(fullfile(resultFolderPath,'*.bmp'))]; % pattern to match filenames.

for k = 1:numel(S)
    F = fullfile(mainFolderPath,S(k).name);  % read the image file from GT
    [filepath,name,ext] = fileparts(F); 
    % now for each image file from GT you got the name 
    splitGTName = strsplit(name,'_');
    % search for the same name in result file 
    for ty = 1:1:numel(S1)
        pickNm = S1(ty).name;
        splitMe = strsplit(pickNm,'_');
        if(strcmp(splitMe{1},splitGTName{1} )) % if both the name are same then 
            F1 = fullfile(resultFolderPath,S1(ty).name);
            [filepathRes,nameRes,extRes] = fileparts(F1); 
            Img = imread(F1);
            if(size(Img,3)==3)
                Img = rgb2gray(Img);
            end
            delete (F1);
            imgNamNew = strcat(resultFolderPath, name, extRes);
            imwrite(Img,imgNamNew);
            break;
        end
    end    
end