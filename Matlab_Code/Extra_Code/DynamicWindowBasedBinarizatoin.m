function DynamicWindowBasedBinarizatoin(origGrayImag)

globalMinImag = min(min(origGrayImag));
globalMaxImag = max(max(origGrayImag));

globalMeanImag = mean(mean(origGrayImag));
globalSTDImag = std(std(origGrayImag));

Tcon = globalMeanImag - ((pow(globalMeanImag, 2) * globalSTDImag) / ...
    ((globalMeanImag + globalSTDImag) * ((0.5 * globalMaxImag) +...
    globalSTD)));
leftLimit = Tcon - (globalSTDImag / 2);
rightLimit = Tcon + (globalSTDImag / 2);

newConfusionImg = zeros(size(origGrayImag,1), size(origGrayImag,2));

numRedPix = 0;
numBlackPixel = 0;
numWhitePixel = 0;

for ii = 1:1:size(origGrayImag,1)
    for jj = 1:1:size(origGrayImag,2)
        if ((origGrayImag(ii, jj) < leftLimit) || (origGrayImag(ii, jj) == leftLimit))
            newConfusionImg(ii, jj) = 0;  % for black
            numBlackPixel = numBlackPixel+1;
        elseif ((gray_image(ii, jj) > leftLimit) && (gray_image(ii, jj) < rightLimit))
            newConfusionImg(ii, jj) = 25; % for red
            numRedPix = numRedPix +1;
        elseif ((gray_image(ii, jj) > rightLimit) || (gray_image(ii, jj) == rightLimit))
            newConfusionImg(ii, jj) = 255; % for white
            numWhitePixel = numWhitePixel +1;
        end
    end
end

% the probability of red and black pixels
getProb = double (numBlackPixel) / double (numRedPix);
winHeight = 0;
winWidth = 0;

if ((getProb > 2.5) || (getProb == 2.5) || globalSTD < (0.1 * maxImage))
    winHeight = (size(gray_image,1) / 4);
    winWidth = (size(gray_image,2) / 6);
elseif (((getProb > 1) && (getProb < 2.5)) || ((size(gray_image,1) + size(gray_image,2)) < 400))
    winHeight = (size(gray_image,1) / 20);
    winWidth = (size(gray_image,2) / 30);
elseif ((getProb < 1) || (getProb == 1))
    winHeight = (size(gray_image,1)) / 30);
    winWidth = (size(gray_image,2) / 40);
end
end