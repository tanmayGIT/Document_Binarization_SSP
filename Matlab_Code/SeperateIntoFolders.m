% This is code written to seperate the images into seperate folders and to
% name them same as the names exits for the same image file in GT (ground
% truth folder). The reason behind is as initially we put all the images in
% one single folder and manually named them according to the specific
% competetion (DIBCO_12, DIBCO_14 etc.) for the recognize the image by it's name. 

% After processing these images (finding the binarization results) they
% should be put back in specific folders of particular competetion. 


% PLEASE CHANGE THE NAMES ACCORDING TO YOUR COMPUTER PATH

clear
clc
close

mainFolderPath = 'Dataset/All_Results/';
resultSavingFolder = 'Dataset/Seperated_All_Results/';
files = dir(mainFolderPath) ;
dirFlags = ~[files.isdir];
subFolders = files(dirFlags);




%% This part is needed to seperate the images into seperate folders of competetions


% some files get generated automatically in Mac, so to ignore those files 
avoidStr1 = '.';
avoidStr2 = '..';
avoidStr3 = '.DS_Store';

for k = 1:size(subFolders,1)
    if(  (~(strcmp((subFolders(k).name), avoidStr1)))  &&  (~(strcmp((subFolders(k).name), avoidStr2))) &&  (~(strcmp((subFolders(k).name), avoidStr3))))
        F = fullfile(mainFolderPath,subFolders(k).name);  % read the image file from GT
        [filepath,name,ext] = fileparts(F);
        actualResultSavingPath = resultSavingFolder;
        % now for each image file from GT you got the name
        splitGTName = strsplit(name,'_');
        if (splitGTName{end} == "09")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_09/AlgoResult/');
        end
        if (splitGTName{end} == "2010")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_10/AlgoResult/');
        end
        if (splitGTName{end} == "11")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_11/AlgoResult/');
        end
        if (splitGTName{end} == "12")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_12/AlgoResult/');
        end
        if (splitGTName{end} == "13")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_13/AlgoResult/');
        end
        if (splitGTName{end} == "14")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_14/AlgoResult/');
        end
        if (splitGTName{end} == "16")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_16/AlgoResult/');
        end
        if (splitGTName{end} == "17")
            actualResultSavingPath = strcat(actualResultSavingPath,'DIBCO_17/AlgoResult/');
        end
        
        Img = imread(F); % read the image
        if(size(Img,3)==3)
            Img = rgb2gray(Img);
        end
        imgNamNew = strcat(actualResultSavingPath, name, '.png'); % formulate new path
        imwrite(Img,imgNamNew);
    end
end

%% This part is needed to change the name of the files according to the names of the same image in GT folder


mainFolderPath_1 = strcat(resultSavingFolder,'DIBCO_09/GT/');
resultFolderPath_1 = strcat(resultSavingFolder,'AlgoResult/');
changeNames(mainFolderPath_1, resultFolderPath_1)


mainFolderPath_2 = strcat(resultSavingFolder,'DIBCO_10/GT/');
resultFolderPath_2 = strcat(resultSavingFolder,'DIBCO_10/AlgoResult/');
changeNames(mainFolderPath_2, resultFolderPath_2)


mainFolderPath_3 = strcat(resultSavingFolder,'DIBCO_11/GT/');
resultFolderPath_3 = strcat(resultSavingFolder,'DIBCO_11/AlgoResult/');
changeNames(mainFolderPath_3, resultFolderPath_3)


mainFolderPath_4 = strcat(resultSavingFolder,'DIBCO_12/GT/');
resultFolderPath_4 = strcat(resultSavingFolder,'DIBCO_12/AlgoResult/');
changeNames(mainFolderPath_4, resultFolderPath_4)


mainFolderPath_5 = strcat(resultSavingFolder,'DIBCO_13/GT/');
resultFolderPath_5 = strcat(resultSavingFolder,'DIBCO_13/AlgoResult/');
changeNames(mainFolderPath_5, resultFolderPath_5)


mainFolderPath_6 = strcat(resultSavingFolder,'DIBCO_14/GT/');
resultFolderPath_6 = strcat(resultSavingFolder,'DIBCO_14/AlgoResult/');
changeNames(mainFolderPath_6, resultFolderPath_6)


mainFolderPath_7 = strcat(resultSavingFolder,'DIBCO_16/GT/');
resultFolderPath_7 = strcat(resultSavingFolder,'DIBCO_16/AlgoResult/');
changeNames(mainFolderPath_7, resultFolderPath_7)


mainFolderPath_8 = strcat(resultSavingFolder,'DIBCO_17/GT/');
resultFolderPath_8 = strcat(resultSavingFolder,'DIBCO_17/AlgoResult/');
changeNames(mainFolderPath_8, resultFolderPath_8)
%%