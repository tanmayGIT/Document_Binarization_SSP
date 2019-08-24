# Binarization Based on Fuzzy C-Means Algorithm # 

This is the work for the binarization using Fuzzy C-Means algorithm and using structural symmetry pattern (SSP) of strokes feature. 

To use this code, please follow the below instruction. This code is implemented using 2 parts. One in Matlab and other 
is in C++. 

## First Step ##
Use the code named as **Run_Bulk_BackGd_Removal.m** in **Matlab_Code** folder to get all the background removed images
from the original images. You will generate all the background removed images in **Dataset/All_BackGd** folder. 

## Second Step ##

1.  After generating the background images, we will generate the structural symmetry stroke images. 
    For this you need to install **clion** IDE in your computer. Clion is a cross platform IDE for Mac, 
    Linux and Windows. I have implemented this code in Mac but you can choose to do it in any other platform. 
    https://www.jetbrains.com/clion/
2.  After that you need to install OpenCV 3.* and provide the correct path of installed library and include paths. 
    Change the path in the line 11, 12, 13 from the CMakeLists.txt file.
3.  Then you have to install the Boost library. Make sure to change the path of installed boost library in line 87, 88 and 89 in
    CMakeLists.txt file

Then the code should be ready to run. Now you can run the file **TextGraphicsSeperation.cpp** to get the SSP images 
in the folder named as **Dataset/All_Results_Grad **. Please verify the paths of BackGround Removed images directory and 
saving path fr saving ssp images, before running the code. 

## Third Step ##
When the SSP images are saved in **Dataset/All_Results_Grad ** folder, you can now run the final part of this binarization algorithm.
Simply run the code **runOnAllImgs.m** from the **Matlab_Code** folder. This will run the binarization algorithm on all the images 
and will save the output in the folder **Dataset/All_Results/**

If you like to just run on only one image then look the code named as :**testBinSingleImag.m**

# Evaluation #
For the evaluation, we have used the same protocol as the DIBCO competetion. For that as you can see that at first we have renamed the
images according to the competetion which are saved in the folder named as :**Dataset/All_Images**. The final binarization result is also 
saved into the folder **Dataset/All_Results** by the same image names. 

To run the .exe file for the calculation of Precison and Recall, we need to name same as the name of correcponding Ground Truth file
of the specific image. First of all we remove the ending portion of names which were containing **\_DIBCO\_*** (* represents the DIBCO
competetion year i.e. 10, 11, 12 etc.). Then to maintain same extension of all the result images, we convert all the image into .png 
extension. 
After that the names are changed as exactly same as the name of corresponding Ground Truth image in the **GT** folder. For that we mainly
have used the **"changeNames"** function. All these is done in the file named as : **"SeperateIntoFolders.m"** file. Please remember to 
carefully chnage the correct path in line 17 and 18 of this **"SeperateIntoFolders.m"** file.

I noticed that the ground truth file having **.tiff** or **.tif** extensions are giving error while running the DIBCO competetion .exe files
So, I have changed all the GT files as **.bmp** extension. For this I have used the file named as : **LittleTests.m**. Please note to change 
everytime the path of GT folder for each competetion folder.

DIBCO competetion evaluation has two parts :
1.  Generating the **\_PWeight.dat** and **\_RWeight.dat** file for each GT images. To do this you need to run the **PR_Metric_DIBCO_*.bat**
    file. Don't forget to modify the path here. In the line-1, you have to give the path of the GT images and in Line 3 you have to provide
    the path of **BinEvalWeights.exe** file, which is in the folder named as **BinEvalWeights** and that's all. 
2.  When you have generated all the **\_PWeight.bat** and **\_RWeight.bat** files for all the GT images then it is the time to get the 
    evaluation metrics. For this you need to run **evalMetric_*.bat** file. Here also don't forgot to change the path of GT folder in Line-1
    and then in Line-3, you need to give the path of the .exe **DIBCO_metrics.exe** which is is **DIBCO_metrics** folder. Then in Line-3
    also, you have to change the path of the second argument i.e. the path of result images of this particular competetion folder. 

When you have calculated the metrics in the terminal window then you can easily copy them and can save in a textfile. You can see 
such text files in the folder named as: **All_Results_Metrics**.

Now to automatically calculate the average of these following metrics, you need to run the matlab file **readLineCalcStats.m **. Don't 
forget to change the path of the text file of the calculated metric for all the images:
1. The F-Measure
2. The Pseudo F-Measure 
3. The PSNR
4. The DRD
5. The Recall
6. The Precision
7. The Pseudo Recall
8. The Pseudo Precision 

For any queries, contact me at : tanmoy.besu@gmail.com