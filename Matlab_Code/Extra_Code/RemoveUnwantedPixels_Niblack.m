function clusteredImage = RemoveUnwantedPixels_Niblack(clusteredImage, strokeWidth)
uniqueVals = unique(clusteredImage, 'sorted'); % as we have only 3 cluster here
winY = round(strokeWidth/2);
winX = round(strokeWidth/2);

valsToCheck = uniqueVals(2);
valsToGet = uniqueVals(1);
valsBackGD = uniqueVals(end);
clusteredImage = RemoveParticularClass(clusteredImage, valsToCheck, valsToGet, valsBackGD, winY, winX);

valsToCheck = uniqueVals(3);
clusteredImage = RemoveParticularClass(clusteredImage, valsToCheck, valsToGet, valsBackGD, winY, winX);

% figure, imshow(clusteredImage);
return;
end

function clusteredImage = RemoveParticularClass(clusteredImage, valsToCheck, valsToGet,valsBackGD,  winY, winX )
for ii = (winY+1):1:(size(clusteredImage,1)-winY)
    for jj = (winX+1):1:(size(clusteredImage,2)-winX)
        
        if((clusteredImage(ii,jj) == valsToCheck) ) % if this pixel is not much surrounded by sure pixels (close to 0)   
            neighCnt = 0;
            for k = -winY:1:winY % go in surround
                for j = -winX:1:winX % go in surround
                    if ((k ~= 0) || (j ~= 0) ) % To avoid the center pixel
                        if((clusteredImage(ii+k,jj+j) == valsToGet)) % surrounded by sure pixels
                            neighCnt = neighCnt + 1;
                        end
                    end
                end
            end
            if(neighCnt >= (round((winX * winY)/2)))
                clusteredImage(ii,jj) = valsToGet;
            else
                clusteredImage(ii,jj) = valsBackGD;
            end
        end
    end
end
end