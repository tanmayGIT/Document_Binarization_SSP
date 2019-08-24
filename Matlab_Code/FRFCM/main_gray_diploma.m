% Please cite the paper "Tao Lei, Xiaohong Jia, Yanning Zhang, Lifeng He, Hongying Meng and Asoke K. Nandi, Significantly Fast and Robust
% Fuzzy C-Means Clustering Algorithm Based on Morphological Reconstruction and Membership Filtering, IEEE Transactions on Fuzzy Systems,
% DOI: 10.1109/TFUZZ.2018.2796074, 2018.2018"

% The paper is OpenAccess and you can download the paper freely from "http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8265186."
% The code was written by Tao Lei in 2017.
% If you have any problems, please contact me.
% Email address: leitao@sust.edu.cn

clc
close all
clear
imgPath = '/Users/tmondal/Documents/11_onlyForeGdImage_Mannual.jpg';
%% test a gray image
f_ori=imread(imgPath);
fn = f_ori;  % imnoise(f_ori,'gaussian',0.03);
%% parameters
cluster=5; % the number of clustering centers
se=3; % the parameter of structuing element used for morphological reconstruction
w_size=3; % the size of fitlering window
%% segment an image corrupted by noise
tic
[center1,U1,~,t1]=FRFCM(double(fn),cluster,se,w_size);
Time1=toc;
disp(strcat('running time is: ',num2str(Time1)))
f_seg = fcm_image(f_ori,U1,center1);


[fSureTextPixels, fSure_and_ConfusedTextPixels, fSegRefined, fSureTextPixelsBinImag] = SeperateClustersCreateImage(f_seg);
[textLineImages, avgLineHeight, startLineRow,endLineRow]  = Horizontal_Projection_Based_Line_Segmentation(fSureTextPixelsBinImag);


imwrite(fSure_and_ConfusedTextPixels,'/Users/tmondal/Documents/Sure_and_Confused_Text_Imag.jpg');
imwrite(fSureTextPixels,'/Users/tmondal/Documents/Sure_Text_Imag.jpg');
imwrite(fSegRefined,'/Users/tmondal/Documents/fSegRefined.jpg');
imwrite(f_seg,'/Users/tmondal/Documents/f_seg.jpg');


if (exist('/Users/tmondal/Documents/11_onlyForeGdImage_Mannual.txt', 'file') == 0)
    disp('File does not exist, creating file.')
    fid = fopen( '/Users/tmondal/Documents/11_onlyForeGdImage_Mannual.txt', 'w' );
    fprintf(fid, '%d \t %d \t %d', avgLineHeight, startLineRow, endLineRow);
    fclose(fid);
else
    disp('File exists.');
    fid = fopen( '/Users/tmondal/Documents/11_onlyForeGdImage_Mannual.txt', 'wt' );
    fprintf(fid, '%d \t %d \t %d', avgLineHeight, startLineRow, endLineRow);
    fclose(fid);
end

% figure, imshow(fn),title('Original image');
% figure, imshow(fSure_and_ConfusedTextPixels);title('Sure and Confused Text Segmentation');
% figure, imshow(fSureTextPixels);title('Sure Text Result');

