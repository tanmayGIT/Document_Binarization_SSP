clear;
close all 
clc 

mainFolderPath = '/Volumes/Study_Materials/Safran_Project/DESIRIndexation-SAEDATA-20180629.zip/DESIR/';
files = dir(mainFolderPath) ; 

S = dir(fullfile(mainFolderPath,'*.csv')); % pattern to match filenames.
keepAllHeading = zeros(1,1);
for k = 1:numel(S)
    F = fullfile(mainFolderPath,S(k).name);
    readCSV = xlsread(F,1,0);
    readCSVHeadingLn = xlsread(F);
    keepAllHeading(k,1:(size(readCSV,2))) = readCSV(1,:);
    % figure, plot(readCSV(:,1))
end

disp ('see me here');