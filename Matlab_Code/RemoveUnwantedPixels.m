function clusteredImage = RemoveUnwantedPixels(clusteredImage, strokeWidth)
uniqueVals = unique(clusteredImage, 'sorted'); % as we have only 3 cluster here
winY = round(strokeWidth/2);
winX = round(strokeWidth/2);
for ii = (winY+1):1:(size(clusteredImage,1)-winY)
    for jj = (winX+1):1:(size(clusteredImage,2)-winX)
        
        if((clusteredImage(ii,jj) == uniqueVals(3)) ) % if this pixel is not much surrounded by sure pixels (close to 0)   
            neighCnt = 0;
            for k = -winY:1:winY % go in surround
                for j = -winX:1:winX % go in surround
                    if ((k ~= 0) || (j ~= 0) ) % To avoid the center pixel
                        if((clusteredImage(ii+k,jj+j) == uniqueVals(2))) % surrounded by sure pixels
                            neighCnt = neighCnt + 1;
                        end
                    end
                end
            end
            if(neighCnt >= (round((winX * winY)/2)))
                clusteredImage(ii,jj) = uniqueVals(2);
            else
                clusteredImage(ii,jj) = uniqueVals(1);
            end
        end
    end
end
% figure, imshow(clusteredImage);
return;
end