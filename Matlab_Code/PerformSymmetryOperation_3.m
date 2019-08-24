function [L_p_ForeGround_Image, S_p_Padded] = PerformSymmetryOperation_3(S_p_Padded, thetaGradImage_Padded, NormImag_Padded, ...
    fSureConfusedTextPixelsPadded, L_p_ForeGround_Image,checkingVal, winX, winY, strokeWidth,fSureTextBinFeaturePixelsPadded)

%% Finding the clusters for this particular pixel color
clusterWiseImage = zeros(size(S_p_Padded));
alphaCut = 0.2;
for ii = (winY+1):1:(size(S_p_Padded,1)-winY)
    for jj = (winX+1):1:(size(S_p_Padded,2)-winX)
        if((fSureConfusedTextPixelsPadded(ii,jj) == checkingVal) )
            clusterWiseImage(ii,jj) = 1;
        end
    end
end
HoldConnecCom = ApplyConnectedCompLabelling(clusterWiseImage);
totalComponent = size(HoldConnecCom,1);
%%

for AccesEachCell = 1:1:totalComponent
    goodQualifyPxCntForComp = 0;
    for nSz = 1:1:size(HoldConnecCom{AccesEachCell,1},1)
        ii = HoldConnecCom{AccesEachCell,1}(nSz,1);
        jj = HoldConnecCom{AccesEachCell,1}(nSz,2);
        
        % treat it component wise not as pixel wise
        alphaStrokeWidth = 0.3;
        betaAngleThresh = 0.75;
        
        % Define the group of angles here
        Angle_Top_Left = 150;
        Angle_Top_Right = 15;
        
        Angle_Bottom_Left = 210;
        Angle_Bottom_Right = 345;
        
        Angle_Left_Left = 105;
        Angle_Left_Right = 240;
        
        Angle_Right_Left_1 = 300;
        Angle_Right_Left_2 = 360;
        Angle_Right_Right_1 = 0;
        Angle_Right_Right_2 = 75;
        
        Angle_TopRigt_Left_1 = 345;
        Angle_TopRigt_Left_2 = 360;
        Angle_TopRight_Right_1 = 0;
        Angle_TopRight_Right_2 = 105;
        
        Angle_BottomLeft_Left = 165;
        Angle_BottomLeft_Right = 300;
        
        Angle_Top_Left_Left = 75;
        Angle_Top_Left_Right = 210;
        
        Angle_Bottom_Right_Left_1 = 0;
        Angle_Bottom_Right_Left_2 = 15;
        Angle_Bottom_Right_Right_1 = 250;
        Angle_Bottom_Right_Right_2 = 360;
        
        
        
        % Now move the neighborhood
        groupTop = 0;
        groupBot = 0;
        groupLeft = 0;
        groupRight = 0;
        groupTopLeft = 0;
        groupBotLeft = 0;
        groupTopRight = 0;
        groupBottomRight = 0;
        neighCnt = 0;
        
        sumNeighBorThreshCnt = 0;
        sumNeighBorThreshCnt = CheckNiblackThreshCond(fSureTextBinFeaturePixelsPadded,S_p_Padded,...
            NormImag_Padded,strokeWidth, ii, jj);
        
        
        for k = -winY:1:winY % go in surround
            for j = -winX:1:winX % go in surround
                if ((k ~= 0) || (j ~= 0) ) % To avoid the center pixel
                    if( (S_p_Padded(ii+k, jj+j) == 1) )  % we would check the neighborhood in potential SSP image  which is binarized sobel gradient image
                        getAngleNeigh = thetaGradImage_Padded(ii+k, jj+j); % get the neighborhood angle value
                        if((Angle_Top_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Top_Right))
                            groupTop = groupTop + 1;
                        end
                        if((Angle_Bottom_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Bottom_Right))
                            groupBot = groupBot + 1;
                        end
                        if((Angle_Left_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Left_Right))
                            groupLeft = groupLeft + 1;
                        end
                        if( ((Angle_Right_Left_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Right_Left_2)) ||...
                                ((Angle_Right_Right_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Right_Right_2)) )
                            groupRight = groupRight + 1;
                        end
                        if( ((Angle_TopRigt_Left_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_TopRigt_Left_2)) ||...
                                ((Angle_TopRight_Right_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_TopRight_Right_2)) )
                            groupTopLeft = groupTopLeft + 1;
                        end
                        if((Angle_BottomLeft_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_BottomLeft_Right))
                            groupBotLeft = groupBotLeft + 1;
                        end
                        
                        
                        if((Angle_Top_Left_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Top_Left_Right))
                            groupTopRight = groupTopRight + 1;
                        end
                        if( ((Angle_Bottom_Right_Left_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Bottom_Right_Left_2))|| ...
                                ((Angle_Bottom_Right_Right_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Bottom_Right_Right_2)) )
                            groupBottomRight = groupBottomRight + 1;
                        end
                        
                        
                        % now check niblack threshold at each ssp
                        %                         getThreshSSP = (fSureTextBinFeaturePixelsPadded(ii+k, jj+j));
                        %                         if(NormImag_Padded(ii+k, jj+j) <= getThreshSSP)
                        %                             sumNeighBorThreshCnt = sumNeighBorThreshCnt + 1;
                        %                         else
                        %                             sumNeighBorThreshCnt = sumNeighBorThreshCnt - 1;
                        %                         end
                        neighCnt = neighCnt +1;
                        
                    end
                end
            end
        end
        
        if (neighCnt > 0) % that means there are atleast one neighboring SSP otherwise make this pixel background surely
            % Density Adjustment
            if (neighCnt < (alphaStrokeWidth * strokeWidth))
                validFlag = 0;
            else
                % Symmetry Adjustment
                getMaxVals = max([groupTop,groupBot,groupLeft,groupRight,groupTopLeft,groupBotLeft,groupTopRight,groupBottomRight]);
                if(  (getMaxVals > (betaAngleThresh * neighCnt))  )  % if it is more than then this is asymmetric (bad means there are pixels dispersed in same direction which should noise)
                    validFlag = 0; % make it backgd pixels
                else
                    % threshold condition
                    if(sumNeighBorThreshCnt <= 0)
                        validFlag = 0; % make it backgd pixel
                    else
                        validFlag = 1; % make it foregd (which is already done)
                    end
                end
            end
        else
            validFlag = 0;
        end
        
        if(validFlag == 1)
            goodQualifyPxCntForComp = goodQualifyPxCntForComp +1;
        end
        
    end
    
    checkLimitComp = round(alphaCut*size(HoldConnecCom{AccesEachCell,1},1));
    if(checkLimitComp < 1)
        checkLimitComp = 1;
    end
    if(goodQualifyPxCntForComp >=checkLimitComp)
        for nSz = 1:1:size(HoldConnecCom{AccesEachCell,1},1)
            ii = HoldConnecCom{AccesEachCell,1}(nSz,1);
            jj = HoldConnecCom{AccesEachCell,1}(nSz,2);
            L_p_ForeGround_Image(ii,jj) = 1;
        end
    end
end

return;
end


function sumNeighBorThreshCnt = CheckNiblackThreshCond(fSureTextBinFeaturePixelsPadded, SSP_Padded, NormImag_Padded,strokewidth, iiToSee, jjToSee)
totalStrokeWidth = 2 * strokewidth;
winX = round(totalStrokeWidth/2);
winY = round(totalStrokeWidth/2);
sumNeighBorThreshCnt = 0;
for k = -winY:1:winY % go in surround
    for j = -winX:1:winX % go in surround
        if ((k ~= 0) || (j ~= 0) ) % To avoid the center pixel
            
            iiLimit = (iiToSee+k);
            if (iiLimit <= 0 )
                iiLimit = 1;
            elseif (iiLimit > size(NormImag_Padded,1) )
                iiLimit = size(NormImag_Padded,1);
            end
            
            jjLimit = (jjToSee+j);
            if (jjLimit <= 0 )
                jjLimit = 1;
            elseif (jjLimit > size(NormImag_Padded,2) )
                jjLimit = size(NormImag_Padded,2);
            end
            
            % now check niblack threshold at each ssp
            try
                if(SSP_Padded(iiLimit, jjLimit) == 1)
                    getThreshSSP = (fSureTextBinFeaturePixelsPadded(iiLimit, jjLimit));
                    if(NormImag_Padded(iiLimit, jjLimit) <= getThreshSSP)
                        sumNeighBorThreshCnt = sumNeighBorThreshCnt + 1;
                    else
                        sumNeighBorThreshCnt = sumNeighBorThreshCnt - 1;
                    end
                end
            catch
                disp('see me');
            end
            
        end
    end
end

end


function HoldConnecCom = ApplyConnectedCompLabelling(binImage)

binarisedImg = binImage;
CC = bwconncomp(binarisedImg);
L = labelmatrix(CC);

totalComponent = max(max(L));

HoldConnecCom  = cell(totalComponent, 1);
HoldConnecComRefined = cell(totalComponent, 1);
for Ini = 1:totalComponent
    HoldConnecCom{Ini,1}(1,1) = 0;
    HoldConnecCom{Ini,1}(1,2) = 0;
    
    HoldConnecComRefined{Ini,1}(1,1) = 0;
    HoldConnecComRefined{Ini,1}(1,2) = 0;
    
end

for ConnComX = 1:1:size(L,1)
    for ConnComY = 1:1:size(L,2)
        if (L(ConnComX,ConnComY)~=0)
            s = L(ConnComX,ConnComY);
            if(HoldConnecCom{s,1}(1,1)==0)
                HoldConnecCom{s,1}(1,1) = ConnComX;
                HoldConnecCom{s,1}(1,2) = ConnComY;
            else
                HoldConnecCom{s,1}(end+1,1) = ConnComX;
                HoldConnecCom{s,1}(end,2) = ConnComY;
            end
        end
    end
end
return;
end