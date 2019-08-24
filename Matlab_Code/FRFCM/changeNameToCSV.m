clear;
close all 
clc 

mainFolderPath = '/Volumes/Study_Materials/Safran_Project/DESIRIndexation-SAEDATA-20180629.zip/DESIRIndexation-SHEDATA-20190206/anonymise_vibratory_data/';
files = dir(mainFolderPath) ; 

S = dir(fullfile(mainFolderPath,'*.crv')); % pattern to match filenames.
for k = 1:numel(S)
    F = fullfile(mainFolderPath,S(k).name);
    [pathstr,name,ext] = fileparts(F);
    newName = sprintf('%s.csv', name);
    fnameNew = fullfile(mainFolderPath, newName);
    movefile(F,fnameNew); 
end