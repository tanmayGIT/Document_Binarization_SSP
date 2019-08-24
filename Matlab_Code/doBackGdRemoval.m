function NormImag = doBackGdRemoval(origImg, outputBin)

nRows = size(origImg,1);
nCols = size(origImg,2);

copyDialatedBackGdMasks = double (outputBin);
copyOrigImg = origImg;


X_Start = [1, 1, nCols, nCols];
X_End = [nCols, nCols, 1, 1];
Y_Start = [1, nRows, 1, nRows];
Y_End = [nRows, 1, nRows, 1];

putAll_P_Image = cell(4,1);
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);




%% ****   First Image     ***/
for yy = (Y_Start(1)+1):1:(Y_End(1)-1) % For the rows
    for xx = (X_Start(1)+1):1:(X_End(1)-1) % For the columns
        
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = origImg(yy,xx);
        end
    end
end
transTemp_P_Img_1 = uint8(temp_P_Image);
putAll_P_Image{1,1} = transTemp_P_Img_1;
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);

%% ****   Second Image     ***/
for yy = (Y_Start(2)-1):-1:(Y_End(2)+1)
    for xx = (X_Start(2)+1):1:(X_End(2)-1)
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = copyOrigImg(yy,xx);
        end
    end
end

transTemp_P_Img_2 = uint8(temp_P_Image);
putAll_P_Image{2,1} = transTemp_P_Img_2;
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);


%% ***   Third Image     ***/
for yy = (Y_Start(3)+1):1:(Y_End(3)-1)
    for xx = (X_Start(3)-1):-1:X_End(3)+1
        
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = copyOrigImg(yy,xx);
        end
    end
end

transTemp_P_Img_3 = uint8(temp_P_Image);
putAll_P_Image{3,1} = transTemp_P_Img_3;
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);


%% ****   Fourth Image     ***/
for yy = (Y_Start(4)-1):-1:Y_End(4)+1
    for xx = (X_Start(4)-1):-1:(X_End(4)+1)
        
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = copyOrigImg(yy,xx);
        end
    end
end

transTemp_P_Img_4 = uint8(temp_P_Image);
putAll_P_Image{4,1} = transTemp_P_Img_4;

DialatedBackGdMasks = copyDialatedBackGdMasks;
backGdImag = zeros(nRows,nCols);
for yy = Y_Start(1):1:Y_End(1)
    for xx = X_Start(1):1:X_End(1)
        if(DialatedBackGdMasks(yy,xx) == 0)
            val1 = putAll_P_Image{1,1}(yy,xx);
            val2 = putAll_P_Image{2,1}(yy,xx);
            val3 = putAll_P_Image{3,1}(yy,xx);
            val4 = putAll_P_Image{4,1}(yy,xx);
            minValue = [ val1 val2 val3 val4];
            backGdImag(yy, xx) = min(minValue);
        else
            backGdImag(yy, xx) = origImg(yy,xx);
        end
    end
end
transTemp_backGd_Img = uint8(backGdImag);

% figure,imshow((transTemp_backGd_Img));
NormImag = NormalizeImage(origImg, transTemp_backGd_Img);
return;
end