This project contains the code for various feature extraction methods used to extract feature from 4 kinds of Sensors(Accelerometer, Gyroscope, Orientation and EMG). 
Feature Extraction methods used were Discrete Fourier Transform, Discrete Wavelet Transform, Discrete Cosine Transform, Power Spectral Density and Piece Wise Aggregation. 
It also contains the code to visualize the extracted features as Grouped Box Plots for a "Gesture" Vs "Not of Gesture" which gives an interesting way to find out important features. 
PCA is also implemented and similarly visualized to find and understand the meaning of each Principal Component.

This file contains descriptions for all the files and how to run them.

Please follow the specified order of running the files to avoid any errors.

RUNNING THE SCRIPT FOR TASK 1:-
->Task1_Scrip_V1.m ::
	When you run this file, a window will open where you can choose the data Folder.
	Once this folder is chosen. This files runs and creates a folder named 	'transformedDataFolder' inside the  		data Folder. This is where it saves all the 10 csvs Each CSV is per gesture and in the format specified in 	     	     the assignment 2 document.


**NOTE** 
After successfully running the 'Task1.scrip.V1.m' script, please open the init_globalVariables.m file and change the folderName variable to point to transformedDataFolder. 

RUNNING THE SCRIPT FOR TASK 2:-
->Task2_Script_V3.m ::
	->Run this file. It will generate 6 CSVs. 
	->5 CSVs for the 5 feature extraction methods that we have used, with each one containing the extracted features (by 		the particular method) for all the 10 gestures.
	->6th CSV is the combined CSV, containing all the features extracted by all the five methods for all the 10 gestures.

RUNNING THE SCRIPT FOR TASK 2:-
->Task3_Script_V1.m ::
	->Run this file.It will read the combined feature matrix that was created and saved after running Task2_Script_V3.m. 
	->It will generate 2 CSVs and 12 plots.
	->The first CSV will be all the Eigen Vectors as columns and all the sensors as rows. The second CSV will the 		original feature matrix in the transformed space of given the Eigen vectors.
	->The first 2 plots generated will be the Eigen vectors against the original features. 1 plot with all the Eigen 	 Vectors and the other with only top 10 Eigen Vectors.
	->The other 10 plots will be box plots for the 10 gestures similar to the ones created in Task 2. These will compare t	      he top 10 principal components for a gesture and not of that gesture.


**OPTIONAL FILES TO RUN**
->The 2 files mentioned below were used to make various plots for our personal analysis. You can choose to run them to see the plots for yourself.

->plotCombined_GestureNotGesture_AllFeatureBoxPlot.m::
	->This file outputs 70 plots. Each plot is for a gesture and a particular feature extraction method, showing the all 	     23 features. It will have box plots comparing features(sensors) of a gesture with that of anything NOT of that 		gesture.

**OPTIONAL
->plotCombined_GestureNotGesture_GoodFeatureBoxPlot.m::
	->This file outputs 10 plots. Each plot is for a gesture, showing the good features we identified. It will have box 	    plots comparing features of a gesture with that of anything NOT of that gesture.
