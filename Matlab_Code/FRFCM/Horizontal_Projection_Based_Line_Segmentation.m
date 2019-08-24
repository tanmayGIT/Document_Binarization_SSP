%   Copyright (c) 2019. Tanmoy Mondal <tanmoy.besu@gmail.com>.
%   Released to public domain under terms of the BSD Simplified license.
%  
%   Redistribution and use in source and binary forms, with or without
%   modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the organization nor the names of its contributors
%       may be used to endorse or promote products derived from this software
%       without specific prior written permission.
%  
%     See <http://www.opensource.org/licenses/bsd-license>
 

% The idea here is to get the horizontal projection of the binarized image
% and then calculate the average of existing black runs in each rows. When
% we have it then we put a threshold of 20% of this average value.

% Now for start of a text line the idea is the number of black run should
% be more this threshold and should also maintian a continuity of 5/7 pixels 

% For the end of a text line, after finding the start of the line, we
% initiate from there and try to get the row where the previous row has
% number of black run greater than threshold and the next row has number of 
% black run less than threshold and so on for some more rows to check the
% continuity (5-7 rows more)

% Then we repeat this process.


% Date of Implementation : 015/01/2019


function [textLineImages, avgLineHeight, startLineRow,endLineRow]  = Horizontal_Projection_Based_Line_Segmentation(binImage)

[rwTest, colTest] = size(binImage);
textLineImages = zeros(1, 3);

horiHistMatTest = zeros(rwTest,colTest); % creating the histogram matrix for generating horizontal histograms

S0Y = zeros(rwTest,2);
keepAllIndexes = zeros((size(binImage,1)), 1);

getAvg = 0;
getCnt = 0;
for p2 = 1:(size(binImage,1))
    indexes = find(binImage(p2,:));
    number_Of_FG_Pixels = colTest - (length(indexes));
    number_Of_BG_Pixels = (length(indexes));
    %  keepAllIndexes(p2,1) = (length(indexes));
    
    if((length(indexes)) >= 1)
        horiHistMatTest(p2,1:number_Of_FG_Pixels) = 1;
        getAvg = getAvg + double(number_Of_FG_Pixels);
        S0Y(p2,1) = number_Of_FG_Pixels;
        S0Y(p2,2) = number_Of_BG_Pixels; % horizontal projection of zero
        % S0Y(p2,2) = getMaxRunLengthOfPixels(binImage(p2,:)); % getting the black pixels run for the particular row
        getCnt = getCnt +1;
    end
end
getAvg = round(getAvg /getCnt);
% figure,imshow(horiHistMatTest);


smoothDia = 7; % We do a simple smoothing with a window of 7
smoothingWin = floor(smoothDia/2);
for ikk = (smoothingWin+1):1:(length(keepAllIndexes)-smoothingWin)
    sumMe = 0;
    for tickP = -smoothingWin:1:smoothingWin
        sumMe = sumMe + double(S0Y((ikk+tickP),1));
    end
    keepAllIndexes(ikk,1) = round(sumMe /smoothDia);
    horiHistMatTest(ikk,1:keepAllIndexes(ikk,1)) = 1;
end
% figure,imshow(horiHistMatTest);



% It is assumed that the text writing starts with some margin so there are
% some white space at the begininig

% if the continuous peaks are less than 10% of average height then this region is background
lineSegThresh = round((getAvg *20)/100);

% if the continuous "smoothDia" number of rows have total number of ON pixel, greater than
% lineSegThresh, then it is the begining of background region

startLineFlag = false;
ith = 1;
partImgs = 1;
while(ith <= (size(horiHistMatTest,1)-1))
    if (keepAllIndexes(ith,1) > lineSegThresh)
        % check if it is continuous or not
        cntMe = 0;
        for ut =1:1:(smoothDia-1)
            if(keepAllIndexes((ith+ut),1) > lineSegThresh)
                cntMe = cntMe +1;
            end
        end
        if(cntMe == (smoothDia-1))
            % then we get start of a line
            startLineFlag = true;
            startLine = ith;
            textLineImages(partImgs,1) = startLine;
        end
    end
    if (startLineFlag) % if startLineFlag is true then only do the following checks
        binImage((startLine-1),:) = 0; % mark the start line
        
        % Now look for the end line
        for iko = startLine:1:size(horiHistMatTest,1)-1
            % if the current line is more than threshold and next line is less than threshold
            if((keepAllIndexes(iko,1) >= lineSegThresh) && (keepAllIndexes(iko+1,1) <= lineSegThresh) )
                
                % check if it is continuous or not
                cntMe = 0;
                for ut = 1:1:(smoothDia-1)
                    takeMin = min((iko+ut), (size(horiHistMatTest,1)-1));
                    if(keepAllIndexes(takeMin,1) <= lineSegThresh)
                        cntMe = cntMe +1;
                    end
                end
                if(cntMe == (smoothDia-1))
                    % then we get start of a line
                    endLine = iko;
                    binImage((endLine+1),:) = 0;
                    textLineImages(partImgs,2) = endLine;
                    textLineImages(partImgs,3) = textLineImages(partImgs,2) - textLineImages(partImgs,1); % The distance 
                    startLineFlag = false;
                    ith = endLine;
                    partImgs = partImgs +1;
                    break;
                end
            end
        end
        
    end
    ith = ith +1; 
end
% Now get the intelligent average distance 
if(size(textLineImages,1) > 5)
    avgLineHeight = round(getPerfectAvgValues(textLineImages(:,3)'));
else
    avgLineHeight = round(mean(textLineImages(:,3)));
end
if (avgLineHeight < 1)
    disp('see me');
end
startLineRow = textLineImages(1,1);
endLineRow = textLineImages(end,2);

% figure,imshow(binImage);
return;

end