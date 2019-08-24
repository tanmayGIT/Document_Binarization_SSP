clear;
close all
clc

mainFolderPath = '/Volumes/Study_Materials/Dataset/Binarization/Selected_DIBCO/All_BG_Seperated/';
finalResultDir = '/Volumes/Study_Materials/Dataset/Binarization/Selected_DIBCO/All_Img_Cluster/';
% Get a list of all files and folders in this folder.
files = dir(mainFolderPath) ;
dirFlags = ~[files.isdir];
subFolders = files(dirFlags);

s1 = '.';
s2 = '..';
s3 = '.DS_Store';
S = dir(fullfile(mainFolderPath,'*.*')); % pattern to match filenames.
for k = 1:numel(S)
    if(  (~(strcmp((subFolders(k).name), s1)))  &&  (~(strcmp((subFolders(k).name), s2))) &&  (~(strcmp((subFolders(k).name), s3))))
        
%         if (strcmp('H06_DIBCO_14.png',(subFolders(k).name)))
            F = fullfile(mainFolderPath,subFolders(k).name);
            I = imread(F);
            if(size(I,3)==3)
                I = rgb2gray(I);
            end
            [filepath,name,ext] = fileparts(F);
            % test a gray image
            f_ori= I;
            fn = f_ori;  % imnoise(f_ori,'gaussian',0.03);
            % parameters
            cluster=5; % the number of clustering centers
            se=3; % the parameter of structuing element used for morphological reconstruction
            w_size=3; % the size of fitlering window
            % segment an image corrupted by noise
            tic
            [center1,U1,~,t1]=FRFCM(double(fn),cluster,se,w_size);
            Time1=toc;
            disp(strcat('running time is: ',num2str(Time1)))
            f_seg = fcm_image(f_ori,U1,center1);
            
            
            [fSureTextPixels, fSure_and_ConfusedTextPixels, fSegRefined, fSureTextPixelsBinImag] = SeperateClustersCreateImage(f_seg);
            [textLineImages, avgLineHeight, startLineRow,endLineRow]  = Horizontal_Projection_Based_Line_Segmentation(fSureTextPixelsBinImag);
            
            imageNam1 = strcat(finalResultDir, name, '_Sure_and_Confused_Text_Imag', ext);
            imageNam2 = strcat(finalResultDir, name, '_Sure_Text_Imag', ext);
            textFileNam = strcat(finalResultDir, name, '_TextFile', '.txt');
            
            imwrite(fSure_and_ConfusedTextPixels,imageNam1);
            imwrite(fSureTextPixels,imageNam2);
            
            
            if (exist(textFileNam, 'file') == 0)
                disp('File does not exist, creating file.')
                fid = fopen( textFileNam, 'w' );
                fprintf(fid, '%d \t %d \t %d', avgLineHeight, startLineRow, endLineRow);
                fclose(fid);
            else
                disp('File exists.');
                fid = fopen(textFileNam, 'wt' );
                fprintf(fid, '%d \t %d \t %d', avgLineHeight, startLineRow, endLineRow);
                fclose(fid);
            end
%         end
    end
end