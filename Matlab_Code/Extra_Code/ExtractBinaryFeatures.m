function featureImage = ExtractBinaryFeatures (origGrayImg, strokeWidth)

featureImage = BolanSuFeatures(origGrayImg, strokeWidth, strokeWidth);
figure, imshow(featureImage);


 S_savoula = 128;
 featureImage = SavoulaSuFeatures(origGrayImg, strokeWidth, strokeWidth, S_savoula);
 figure, imshow(featureImage);


featureImage = LogIntensityPercentileFeatures(origGrayImg, strokeWidth, strokeWidth);
figure, imshow(featureImage);



[featureMat_RDI_1,featureMat_RDI_0,featureMat_RDI_minus_1,...
    featureMat_RDI_1_div_0_1, featureMat_RDI_0_div_minus_1_0,... 
    featureMat_RDI_minus_1_div_minus_1_1] = RelativeDarknessIndexFeatures(origGrayImg, strokeWidth, strokeWidth, 5);
figure, imshow(featureMat_RDI_1);
figure, imshow(featureMat_RDI_0);
figure, imshow(featureMat_RDI_minus_1);
figure, imshow(featureMat_RDI_1_div_0_1);
figure, imshow(featureMat_RDI_0_div_minus_1_0);
figure, imshow(featureMat_RDI_minus_1_div_minus_1_1);
end


function contrastImg = BolanSuFeatures (imagGray, windowXFull, windowYFull)
% sum  = 0; x1 = 0; y1 = 0, th_prec = 0.01;
windowX = floor(windowXFull/2);
windowY = floor(windowYFull/2);
epsilonSU = 0.001;

imagGray_Padded = padarray(imagGray,[windowX windowY],'replicate');

contrastImg  = zeros(size(imagGray_Padded,1), size(imagGray_Padded,2));

for y = (windowY+1):1:(size(imagGray_Padded,1)-windowY)
    for x = (windowX+1):1:(size(imagGray_Padded,2)-windowX)
        keepAllEle = zeros(8,1);
        cnt = 1;
        for k = -windowY:1:windowY
            for j = -windowX:1:windowX
                if ((k ~= 0) || (j ~= 0) )
                    tempVal = imagGray_Padded(y+k,x+j);
                    keepAllEle(cnt,1) = tempVal;
                    cnt = cnt +1;
                end
            end
        end
        minVal = min(keepAllEle);
        maxVal = max(keepAllEle);
        
        C_ij = (maxVal - minVal) / ((maxVal + minVal) + epsilonSU);
        contrastImg(y,x) = C_ij;
    end
end
contrastImg = contrastImg((windowY+1):(end-windowY), (windowX+1):(end-windowX));
% figure,imshow(contrastImg);
end

function [meanImg, stdImg] = calcLocalStats(imagGray, windowXFull, windowYFull)

windowX = floor(windowXFull/2);
windowY = floor(windowYFull/2);

imagGray_Padded = padarray(imagGray,[windowX windowY],'replicate');

meanImg  = zeros(size(imagGray_Padded,1), size(imagGray_Padded,2));
stdImg  = zeros(size(imagGray_Padded,1), size(imagGray_Padded,2));

for y = 2:1:(size(imagGray,1)-1)
    for x = 2:1:(size(imagGray,2)-1)
        keepAllEle = zeros(8,1);
        cnt = 1;
        for k = -windowY:1:windowY
            for j = -windowX:1:windowX
                if ((k ~= 0) || (j ~= 0) )
                    tempVal = imagGray_Padded(y+k,x+j);
                    keepAllEle(cnt,1) = tempVal;
                    cnt = cnt +1;
                end
            end
        end
        meanVal = mean(keepAllEle);
%         makeSquare = keepAllEle.^2;
%         makeSquareDiv = sum(makeSquare)/((windowXFull * windowYFull)-1);
%         makeSquareDiv = (makeSquareDiv - (meanVal^2));
         stdVal = std(keepAllEle);
        
        meanImg(y,x) = meanVal;
        stdImg(y,x) = stdVal;
    end
end

% meanImg = meanImg(2:end-1, 2:end-1);
% stdImg = stdImg(2:end-1, 2:end-1);
%  figure,imshow(meanImg);
%  figure,imshow(stdImg);
end


function [featureMat_RDI_1,featureMat_RDI_0,featureMat_RDI_minus_1,...
    featureMat_RDI_1_div_0_1, featureMat_RDI_0_div_minus_1_0,... 
    featureMat_RDI_minus_1_div_minus_1_1] = RelativeDarknessIndexFeatures(imagGray, windowXFull, windowYFull, relaxation)

windowX = floor(windowXFull/2);
windowY = floor(windowYFull/2);

imagGray_Padded = padarray(imagGray,[windowX windowY],'replicate');

% featureMat = zeros(size(imagGray,1),size(imagGray,2));

featureMat_RDI_1 = zeros(size(imagGray_Padded,1),size(imagGray_Padded,2));
featureMat_RDI_0 = zeros(size(imagGray_Padded,1),size(imagGray_Padded,2));
featureMat_RDI_minus_1 = zeros(size(imagGray_Padded,1),size(imagGray_Padded,2));

featureMat_RDI_1_div_0_1 = zeros(size(imagGray_Padded,1),size(imagGray_Padded,2));
featureMat_RDI_0_div_minus_1_0 = zeros(size(imagGray_Padded,1),size(imagGray_Padded,2));
featureMat_RDI_minus_1_div_minus_1_1 = zeros(size(imagGray_Padded,1),size(imagGray_Padded,2));

for y = (windowY+1):1:(size(imagGray_Padded,1)-windowY)
    for x = (windowX+1):1:(size(imagGray_Padded,2)-windowX)
        
        codeCnt_1 = 0;
        codeCnt_0 = 0;
        codeCnt_minus_1 = 0;
        
        for k = -windowY:1:windowY
            for j = -windowX:1:windowX
                if ((k ~= 0) || (j ~= 0) )
                    codeVal = 0;
                    
                    if ( ((imagGray_Padded(y+k,x+j)) > (imagGray_Padded(y, x) + relaxation)) ||...
                            ((imagGray_Padded(y+k,x+j)) > (imagGray_Padded(y, x) + relaxation)) )
                        codeVal = 1;
                    elseif ( ((imagGray_Padded(y+k,x+j)) < (imagGray_Padded(y, x) - relaxation)) ||...
                            ((imagGray_Padded(y+k,x+j)) == (imagGray_Padded(y, x) - relaxation)) )
                        codeVal = -1;
                    elseif ((abs(imagGray_Padded(y+k,x+j) - imagGray_Padded(y, x))) < relaxation)
                        codeVal = 0;
                    end
                    
                    %  for code :  1
                    if((codeVal - 1) == 0) %  that means the codeVal = 1
                        codeCnt_1 = codeCnt_1 + 1;
                        % for code : 0
                    elseif ((codeVal - 0) == 0)    % that means the codeVal = 1
                        codeCnt_0 = codeCnt_0 + 1;
                        % for code : -1
                    elseif ((codeVal - (-1)) == 0)    % that means the codeVal = 1
                        codeCnt_minus_1 = codeCnt_minus_1 + 1;
                    end
                    
                end
            end
        end
        
        featureMat_RDI_1(y,x) = (codeCnt_1 / 8);
        featureMat_RDI_0(y,x) = (codeCnt_0 / 8);
        featureMat_RDI_minus_1(y,x) = (codeCnt_minus_1 / 8);
        
        featureMat_RDI_1_div_0_1(y,x) = featureMat_RDI_1(y,x) /...
            (featureMat_RDI_0(y,x) + featureMat_RDI_1(y,x));
        
        featureMat_RDI_0_div_minus_1_0(y,x) = featureMat_RDI_0(y,x) /...
            (featureMat_RDI_minus_1(y,x) + featureMat_RDI_0(y,x));
        
        featureMat_RDI_minus_1_div_minus_1_1(y,x) = featureMat_RDI_minus_1(y,x) /...
            (featureMat_RDI_minus_1(y,x) + featureMat_RDI_1(y,x)) ;  
    end
end

featureMat_RDI_1 = featureMat_RDI_1((windowY+1):(end-windowY), (windowX+1):(end-windowX));
featureMat_RDI_0 = featureMat_RDI_0((windowY+1):(end-windowY), (windowX+1):(end-windowX));
featureMat_RDI_minus_1 = featureMat_RDI_minus_1((windowY+1):(end-windowY), (windowX+1):(end-windowX));
featureMat_RDI_1_div_0_1 = featureMat_RDI_1_div_0_1((windowY+1):(end-windowY), (windowX+1):(end-windowX));
featureMat_RDI_0_div_minus_1_0 = featureMat_RDI_0_div_minus_1_0((windowY+1):(end-windowY), (windowX+1):(end-windowX));
featureMat_RDI_minus_1_div_minus_1_1 = featureMat_RDI_minus_1_div_minus_1_1((windowY+1):(end-windowY), (windowX+1):(end-windowX));

end

function featureMat = LogIntensityPercentileFeatures (imagGray, windowXFull, windowYFull)

Th_perc = 0.01;
windowX = floor(windowXFull/2);
windowY = floor(windowYFull/2);

imagGray_Padded = padarray(imagGray,[windowX windowY],'replicate');

featureMat  = zeros(size(imagGray_Padded,1), size(imagGray_Padded,2));

for y = (windowY+1):1:(size(imagGray_Padded,1)-windowY)
    for x = (windowX+1):1:(size(imagGray_Padded,2)-windowX)
        sum = 0.0;
        s_cnt = 0;
        for k = -windowY:1:windowY
            for j = -windowX:1:windowX
                if ((k ~= 0) || (j ~= 0) )
                    tempVal = (double(imagGray_Padded(y,x)) - double(imagGray_Padded(y+k,x+j)));
                    
                    if( (tempVal > 0) ||(tempVal == 0) )
                        binVal = 1;
                    else
                        binVal = 0;
                    end
                    sum = sum + binVal;
                    s_cnt = s_cnt +1;
                end
            end
        end
        sum  = sum / s_cnt;
        if(sum <= Th_perc)
            featureMat(y,x) = 1;
        else
            featureMat(y,x) = log(sum)/log(Th_perc);
        end
    end
end
featureMat = featureMat((windowY+1):(end-windowY), (windowX+1):(end-windowX));
% figure,imshow(contrastImg);
end

function featureMat = SavoulaSuFeatures (imagGray, windowXFull, windowYFull, S_savoula)
windowX = floor(windowXFull/2);
windowY = floor(windowYFull/2);

imagGray_Padded = padarray(imagGray,[windowX windowY],'replicate');
[meanImg, stdImg] = calcLocalStats(imagGray, windowXFull, windowYFull);

featureMat  = zeros(size(imagGray_Padded,1), size(imagGray_Padded,2));

for y = (windowY+1):1:(size(imagGray_Padded,1)-windowY)
    for x = (windowX+1):1:(size(imagGray_Padded,2)-windowX)
        
        tempVal = ((imagGray_Padded(y,x) / meanImg(y,x)) -1 ) / ((stdImg(y,x) / S_savoula) - 1);
        exponentialNiblack = exp(double(-tempVal));
        if (stdImg(y,x) > S_savoula)
            featureMat(y,x) = 0 ;
        else
            denoVal = double((1.0 + exponentialNiblack));
            tempValGoFor = power(denoVal,(-1));
            featureMat(y,x) = tempValGoFor;
        end
    end
end
featureMat = featureMat((windowY+1):(end-windowY), (windowX+1):(end-windowX));
%figure,imshow(featureMat);
end