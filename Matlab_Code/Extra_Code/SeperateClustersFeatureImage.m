function [BW2] = SeperateClustersFeatureImage(f_seg, strokeWidth)

% as we are taking unique values and sorting them, so we will get the black at the top 
% and the lesser black at the bottom
uniqueVals = unique(f_seg, 'sorted');  


fSureTextPixels = zeros(size(f_seg));

for iRw = 1:1:size(f_seg,1)
    for jCol = 1:1:size(f_seg,2)
        if( (f_seg(iRw,jCol) == uniqueVals(2)) ) % the third and fourth values are made white/background  
            fSureTextPixels(iRw,jCol) = 1;
        end
    end
end
fSureTextPixels = (fSureTextPixels);

% BW2 = bwmorph(fSureTextPixels,'bridge');
% BW2 = bwmorph(BW2,'fill');
% BW2 = bwmorph(BW2,'majority');
% BW2 = bwmorph(BW2,'clean');
BW2 = bwmorph(fSureTextPixels,'spur');
BW2 = bwareaopen(BW2,strokeWidth,8);

return;
end