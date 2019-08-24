clear
clc
close

fid=fopen('DIBCO_09_BinResults.txt');
tline = fgetl(fid);
tlines = cell(0,1);

calcFmeasure = 0;
cnt1 = 0;

calpseudoFmeasure = 0;
cnt2 = 0;

calcPSNR = 0;
cnt3 = 0;

calcDRD = 0;
cnt4 = 0;

calcRecall = 0;
cnt5 = 0;

calcPrecision = 0;
cnt6 = 0;

calcPseudoRecall = 0;
cnt7 = 0;

calcPseudoPrecision = 0;
cnt8 = 0;


while ischar(tline)
    splitName = strsplit(tline,':'); % split the line
    newTxt = strtrim(splitName{1,1}); % get the first element and remove beginning and ending spaces
    if (strcmp(newTxt, 'F-Measure'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcFmeasure = calcFmeasure + getVal;
        cnt1 = cnt1 + 1;
    end
    
    if (strcmp(newTxt, 'pseudo F-Measure (Fps)'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calpseudoFmeasure = calpseudoFmeasure + getVal;
        cnt2 = cnt2 + 1;
    end
    
    if (strcmp(newTxt, 'PSNR'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcPSNR = calcPSNR + getVal;
        cnt3 = cnt3 + 1;
    end
    
    
    if (strcmp(newTxt, 'DRD'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcDRD = calcDRD + getVal;
        cnt4 = cnt4 + 1;
    end
    
    
    if (strcmp(newTxt, 'Recall'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcRecall = calcRecall + getVal;
        cnt5 = cnt5 + 1;
    end
    
    
    if (strcmp(newTxt, 'Precision'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcPrecision = calcPrecision + getVal;
        cnt6 = cnt6 + 1;
    end
    
    
    if (strcmp(newTxt, 'pseudo-Recall (Rps)'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcPseudoRecall = calcPseudoRecall + getVal;
        cnt7 = cnt7 + 1;
    end
    
    if (strcmp(newTxt, 'pseudo-Precision (Pps)'))
        % get the value which is at the seonnd cell
        getVal = splitName{1,2};
        getVal = str2double(getVal);
        calcPseudoPrecision = calcPseudoPrecision + getVal;
        cnt8 = cnt8 + 1;
    end
    % tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
calcFmeasure = calcFmeasure / cnt1;
calpseudoFmeasure = calpseudoFmeasure / cnt2;
calcPSNR = calcPSNR / cnt3;
calcDRD = calcDRD / cnt4;
calcRecall = calcRecall / cnt5;
calcPrecision = calcPrecision / cnt6;
calcPseudoRecall = calcPseudoRecall / cnt7;
calcPseudoPrecision = calcPseudoPrecision / cnt8;

fprintf('The F-Measure is %f \n',calcFmeasure);
fprintf('The Pseudo F-Measure is %f \n',calpseudoFmeasure);
fprintf('The PSNR is %f \n',calcPSNR);
fprintf('The DRD is %f \n',calcDRD);
fprintf('The Recall is %f \n',calcRecall);
fprintf('The Precision is %f \n',calcPrecision);
fprintf('The Pseudo Recall is %f \n',calcPseudoRecall);
fprintf('The Pseudo Precision is %f \n',calcPseudoPrecision);

fclose(fid);