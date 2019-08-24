clear 
% close
clc
addpath 'FRFCM/';    
origImg = imread('Dataset/AllImages/6_DIBCO_17.bmp');

L_p_ForeGround_Image = RunBinarizationAllImg_1(origImg, 'Dataset/AllImages/6_DIBCO_17.bmp');
figure, imshow(L_p_ForeGround_Image);