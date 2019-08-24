function [fSureTextPixels, fSure_and_ConfusedTextPixels] = SeperateClustersCreateImageForBin(f_seg)

% as we are taking unique values and sorting them, so we will get the black at the top 
% and the lesser black at the bottom
uniqueVals = unique(f_seg, 'sorted');  


fSureTextPixels = f_seg;
fSure_and_ConfusedTextPixels = f_seg;

for iRw = 1:1:size(f_seg,1)
    for jCol = 1:1:size(f_seg,2)
        if(  (f_seg(iRw,jCol) == uniqueVals(4)) ) % the third and fourth values are made white/background
            
            fSureTextPixels(iRw,jCol) = uniqueVals(5);
            fSure_and_ConfusedTextPixels(iRw,jCol) = uniqueVals(5);
            
        elseif( (f_seg(iRw,jCol) == uniqueVals(2)) || (f_seg(iRw,jCol) == uniqueVals(3)) )
        
            fSureTextPixels(iRw,jCol) = uniqueVals(5);
        elseif(f_seg(iRw,jCol) == uniqueVals(1))
            fSureTextPixels(iRw,jCol) = 0;
            fSure_and_ConfusedTextPixels(iRw,jCol) = 0;
        end
    end
end
return;
end