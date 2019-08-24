function NormImag = SaveBackGdRemovedImage(origImg)
% origImg = imread(imgPath);
if(size(origImg,3)==3)
    origImg = rgb2gray(origImg);
end
% Calculate stroke width
strokeWidth = CalculateStrokeWidth(origImg);

[outputNiblack, ~, ~, ~] = niblack(origImg, [strokeWidth strokeWidth], -0.2, 0, 'replicate');
% output = mat2gray(output);
% figure, imshow(output);
NormImag = doBackGdRemoval(origImg, outputNiblack);
end