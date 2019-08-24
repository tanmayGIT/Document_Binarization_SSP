function [fSureTextPixels, fSure_and_ConfusedTextPixels, fSegRefined, fSureTextPixelsBinImag] = SeperateClustersCreateImage(f_seg)

% as we are taking unique values and sorting them, so we will get the black at the top 
% and the lesser black at the bottom
uniqueVals = unique(f_seg, 'sorted');  
fSegRefined = f_seg;

fSureTextPixels = f_seg;
fSure_and_ConfusedTextPixels = f_seg;

fSureTextPixelsBinImag = ones(size(f_seg,1),size(f_seg,2));
for iRw = 1:1:size(fSegRefined,1)
    for jCol = 1:1:size(fSegRefined,2)
        if( (fSegRefined(iRw,jCol) == uniqueVals(3))|| (fSegRefined(iRw,jCol) == uniqueVals(4)) ) % the third and fourth values are made white/background
            fSegRefined(iRw,jCol) = uniqueVals(5);  % putting it 255
            fSureTextPixels(iRw,jCol) = uniqueVals(5);
            fSure_and_ConfusedTextPixels(iRw,jCol) = uniqueVals(5);
        elseif(fSegRefined(iRw,jCol) == uniqueVals(2))
            fSegRefined(iRw,jCol) = uniqueVals(1);
            fSureTextPixels(iRw,jCol) = uniqueVals(5);
        elseif(fSegRefined(iRw,jCol) == uniqueVals(1))
            fSureTextPixelsBinImag(iRw,jCol) = 0;
            fSureTextPixels(iRw,jCol) = 0;
            fSure_and_ConfusedTextPixels(iRw,jCol) = 0;
        end
    end
end
return;
end