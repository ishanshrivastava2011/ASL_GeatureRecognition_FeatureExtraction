global suffix
global folderName
global sensors
global listOfActions
global map_gesture_numRecords
global totalNumRecords
% suffix = '_CSE572_A2_data.csv';
% folderName = '/Users/ishanshrivastava/Documents/Masters At ASU/Spring Sem 2017/Data Mining CSE 572/Project/Assignment 2/CSE572_A2_data/transformedDataFolder/';
%     

sensors = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
listOfActions = ["About","Can","And","Cop","Deaf","Decide","Father","Find","Go Out","Hearing"];
keySet = {'About','Can','And','Cop','Deaf','Decide','Father','Find','Go Out','Hearing'};

valueSet = [];
totalNumRecords=0;
for i=1:length(listOfActions)
        currGesture = listOfActions{i};
        CompiledDataTable = importfile(strcat(folderName,currGesture,suffix),2,30000);
        numOfActionsInCurGesture=height(CompiledDataTable)/34;
        valueSet=[valueSet,numOfActionsInCurGesture];
        totalNumRecords = totalNumRecords+numOfActionsInCurGesture;
end
map_gesture_numRecords = containers.Map(keySet,valueSet) ;

filename = strcat(folderName,'compiled_featureMatrix_Table.csv');
compiled_featureMatrix_Table = readCompiledfeatureMatrixTable(filename);

%TO PLOT THE COMBINED FEATURE BOX PLOT FOR ALL THE GESTURE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% About
FFTFeatures = {'ALX','ARX','ARY','ARZ','OPL','EMG5R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORR','OPR','OYR'};
PSDFeatures = {'ALX', 'ALY', 'ARX', 'ARY', 'ARZ', 'EMG0L', 'EMG1L', 'EMG4R', 'EMG5R', 'EMG6R', 'EMG7R', 'GLX', 'GLY', 'GLZ', 'GRX', 'GRY', 'GRZ', 'ORR', 'OPR', 'OYR'};
WavletFeatures = {'GRX','GRY','GRZ','OPL','ALX'};
DCTFeatures = {'ALX', 'ARY', 'ARZ', 'EMG4R', 'EMG5R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORR', 'OPR', 'OYR'};
PAAFeatures1 = {'ALX','ALY','ALZ','ARX', 'ARY', 'ARZ', 'GRX' , 'GRY' , 'GRZ' ,  'OPL', 'OYL', 'ORR', 'OPR', 'OYR'};
PAAFeatures2 = {'ALX','ALY','ALZ','ARX', 'ARY', 'ARZ', 'OPL', 'OPR','ORR', 'OYR'};
PAAFeatures3 = {'ARX' , 'ARY' , 'ARZ' ,'GRX','GRY','GRZ'};
featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
subset = table2array(compiled_featureMatrix_Table(:,featureList));
createBoxPlotForGesture('About', subset, 'Combined',featureList);
% 
% %Can
% FFTFeatures = {'ALX', 'ARX', 'ARY', 'ARZ', 'EMG6L', 'EMG7L', 'EMG0R', 'EMG1R', 'EMG4R', 'EMG6R', 'EMG7R', 'GLX', 'GLY', 'GLZ', 'GRX', 'GRY', 'GRZ', 'OPL', 'ORR', 'OPR'};
% PSDFeatures = { 'ARX', 'ARY', 'EMG6L', 'EMG7L', 'EMG0R', 'EMG1R', 'EMG2R', 'EMG3R', 'EMG4R', 'EMG6R', 'EMG7R', 'GLX', 'GLY', 'GLZ', 'GRX', 'GRY', 'GRZ', 'OPL', 'ORR', 'OPR'};
% WavletFeatures = {'ALY','ARX','ARY','ARZ', 'OYL', 'ORR', 'OPR', 'OYR'};
% DCTFeatures = {'ARX', 'ARY', 'ARZ', 'EMG6L', 'EMG7L', 'EMG0R', 'EMG1R', 'EMG3R', 'EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','OPL','OYL','ORR','OPR','OYR'};
% PAAFeatures1 = {'ARX', 'ARY', 'ARZ', 'ORR', 'OPR'};
% PAAFeatures2 = { 'ALX', 'ALY', 'ARX','ARY', 'ARZ','GRX','GRY','GRZ', 'OPL', 'OYL','ORR','ALZ','OYR'};
% PAAFeatures3 = {};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Can', subset, 'Combined',featureList);
% 
% %And
% FFTFeatures = { 'ALZ','EMG7L','ORL'};
% PSDFeatures = {'ALX', 'ALZ', 'EMG4L', 'EMG6L', 'EMG7L', 'EMG0R', 'EMG3R', 'EMG4R', 'GRX', 'GRY', 'GRZ'};
% WavletFeatures = {'OYL'};
% DCTFeatures = { 'ALZ','ORL'};
% PAAFeatures1 = {'ALZ', 'EMG5R', 'GLX', 'GLY', 'GLZ'};
% PAAFeatures2 = {'ALZ','ARZ'};
% PAAFeatures3 = {'ARZ','ARZ','EMG5R', 'ORL'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('And', subset, 'Combined',featureList);
% 
% %Cop
% FFTFeatures = {'OYL','OYR'};
% PSDFeatures = { 'OYL', 'OYR'};
% WavletFeatures = {'ALX', 'ALY', 'ALZ', 'ORL', 'OPL', 'OYL', 'OYR'};
% DCTFeatures = {'OYL','OYR'};
% PAAFeatures1 = {'GRX','GRY','GRZ','OYL', 'ORL'};
% PAAFeatures2 = {'ALZ','ORL','OYL','OYR'};
% PAAFeatures3 = {'ALX','ALY','GLX','GLY','GLZ','OYL','OYR'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Cop', subset, 'Combined',featureList);
% 
% %'And','Cop','Deaf','Decide','Father','Find','Go Out','Hearing'
% %Deaf
% FFTFeatures = {'ALX', 'ALY', 'ORL','OYR','EMG5L'};
% PSDFeatures = {'ALX', 'ALY', 'OYR'};
% WavletFeatures = {'GRX', 'GRY', 'GRZ'};
% DCTFeatures = {'ALX', 'ALY', 'ALZ','ORL','OYR'};
% PAAFeatures1 = {'ALY', 'OYR' };
% PAAFeatures2 = {'OYR'};
% PAAFeatures3 = {'ALY','ALZ','ORL','OYR'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Deaf', subset, 'Combined',featureList);
% 
% %Decide
% FFTFeatures = {'ARX', 'ARY', 'GRX', 'GRY', 'GRZ', 'ORR', 'OPR', 'EMG0R', 'EMG3R', 'EMG5R', 'EMG6R', 'EMG7R'};
% PSDFeatures = {'ARX', 'ARY', 'GRX', 'GRY', 'GRZ', 'ORR', 'OPR', 'EMG0R', 'EMG4R', 'EMG5R', 'EMG6R', 'EMG7R'};
% WavletFeatures = {'ALY','ALZ', 'ARX', 'ARY', 'ARZ', 'GRX', 'GRY', 'GRZ', 'ORL', 'ORR', 'OPR'};
% DCTFeatures = {'ARX', 'ARY', 'ARZ','EMG4R','EMG5R','EMG6R','EMG7R','GRX','GRY','GRZ','ORR','OPR'};
% PAAFeatures1 = {'GLX', 'GLY', 'GLZ', 'OYL'};
% PAAFeatures2 = {'ARX','ARY','ARZ','GRX','GRY','GRZ','OYL','ORR','OPR'};
% PAAFeatures3 = {'ALY','ALZ','ARX','ARZ','ORL','OPR','OPR','OYR'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Decide', subset, 'Combined',featureList);
% 
% %Father
% FFTFeatures = {'EMG1L','EMG2L','ORL','OYR','ALY','OYL'};
% PSDFeatures = {'EMG1L','EMG2L','ORL','OYR'};
% WavletFeatures = {'ALZ', 'GLX', 'GLY', 'GLZ'};
% DCTFeatures = {'EMG1L','EMG2L','ORL','OPL','OYL','OYR'};
% PAAFeatures1 = {'ALY', 'OYR'};
% PAAFeatures2 = {'ALY', 'ORL','OPL','OYL','OYR'};
% PAAFeatures3 = {'ALX','ALZ', 'GLX','GLY','GLZ','ORL','OPL','OYL','OYR'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Father', subset, 'Combined',featureList);
% 
% %Find
% FFTFeatures = {'EMG0L','EMG2L','EMG3L','EMG7L','GRX','GRY','GRZ','ALY','ARX'};
% PSDFeatures = {'EMG0L','EMG7L','GRX','GRY','GRZ','ALY'};
% WavletFeatures = {'ALY', 'ALZ'};
% DCTFeatures = { 'EMG2L','EMG0L','EMG7L','EMG3L','GRX','GRY','GRZ' };
% PAAFeatures1 = {'ARX','OYR'};
% PAAFeatures2 = {'ALY','ALZ','ARX'};
% PAAFeatures3 = { 'ARX','ARY'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Find', subset, 'Combined',featureList);
% 
% %'And','Cop','Deaf','Decide','Father','Find','Go Out','Hearing'
% %Go Out
% FFTFeatures = {'EMG3L','EMG5R','GLX','GLY','GLZ'};
% PSDFeatures = {'EMG3L','GLX','GLY','GLZ','ALY'};
% WavletFeatures = {'GLX', 'GLY', 'GLZ'};
% DCTFeatures = {'EMG3L','GLX','GLY','GLZ'};
% PAAFeatures1 = {'ARX','ARY','ARZ','GLX','GLY','GLZ','OPL','OPR','ORR'};
% PAAFeatures2 = {'ALY','ARY', 'GLX','GLY','GLZ','ORR'};
% PAAFeatures3 = {'ARZ','GLX','GLY','GLZ','ORR'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Go Out', subset, 'Combined',featureList);
% 
% %Hearing
% FFTFeatures = {'ALZ','EMG0L'};
% PSDFeatures = { 'ALZ','ARY','EMG0L'};
% WavletFeatures = {'GLX', 'GLY', 'GLZ'};
% DCTFeatures = {'ALZ','ARY'};
% PAAFeatures1 = {'ALZ','ARX', 'ARY', 'ORL', 'OPR'};
% PAAFeatures2 = {'GLX','GLY','GLZ','OYL','OPR'};
% PAAFeatures3 = {'ARX','ARY','GLX','GLY','GLZ','OYL','OPR'};
% featureList = [strcat(FFTFeatures(:),repmat('_MaxFFT',length(FFTFeatures),1));strcat(PSDFeatures(:),repmat('_PSD',length(PSDFeatures),1));strcat(WavletFeatures(:),repmat('_Wavelet',length(WavletFeatures),1));strcat(DCTFeatures(:),repmat('_MaxDCT',length(DCTFeatures),1));strcat(PAAFeatures1(:),repmat('_slice1_Paa',length(PAAFeatures1),1));strcat(PAAFeatures2(:),repmat('_slice2_Paa',length(PAAFeatures2),1));strcat(PAAFeatures3(:),repmat('_slice3_Paa',length(PAAFeatures3),1))].';
% subset = table2array(compiled_featureMatrix_Table(:,featureList));
% createBoxPlotForGesture('Hearing', subset, 'Combined',featureList);


function compiledfeatureMatrixTable = readCompiledfeatureMatrixTable(filename)
    delimiter = ',';
    startRow = 2;

    % Format for each line of text:

    formatSpec = '%C%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

    % Open the text file.
    fileID = fopen(filename,'r');

    % Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

    % Close the text file.
    fclose(fileID);

    % Post processing for unimportable data.
    % No unimportable data rules were applied during the import, so no post
    % processing code is included. To generate code which works for
    % unimportable data, select unimportable cells in a file and regenerate the
    % script.

    % Create output variable
    compiledfeatureMatrixTable = table(dataArray{1:end-1}, 'VariableNames', {'Gesture','ALX_MaxFFT','ALY_MaxFFT','ALZ_MaxFFT','ARX_MaxFFT','ARY_MaxFFT','ARZ_MaxFFT','EMG0L_MaxFFT','EMG1L_MaxFFT','EMG2L_MaxFFT','EMG3L_MaxFFT','EMG4L_MaxFFT','EMG5L_MaxFFT','EMG6L_MaxFFT','EMG7L_MaxFFT','EMG0R_MaxFFT','EMG1R_MaxFFT','EMG2R_MaxFFT','EMG3R_MaxFFT','EMG4R_MaxFFT','EMG5R_MaxFFT','EMG6R_MaxFFT','EMG7R_MaxFFT','GLX_MaxFFT','GLY_MaxFFT','GLZ_MaxFFT','GRX_MaxFFT','GRY_MaxFFT','GRZ_MaxFFT','ORL_MaxFFT','OPL_MaxFFT','OYL_MaxFFT','ORR_MaxFFT','OPR_MaxFFT','OYR_MaxFFT','ALX_Wavelet','ALY_Wavelet','ALZ_Wavelet','ARX_Wavelet','ARY_Wavelet','ARZ_Wavelet','EMG0L_Wavelet','EMG1L_Wavelet','EMG2L_Wavelet','EMG3L_Wavelet','EMG4L_Wavelet','EMG5L_Wavelet','EMG6L_Wavelet','EMG7L_Wavelet','EMG0R_Wavelet','EMG1R_Wavelet','EMG2R_Wavelet','EMG3R_Wavelet','EMG4R_Wavelet','EMG5R_Wavelet','EMG6R_Wavelet','EMG7R_Wavelet','GLX_Wavelet','GLY_Wavelet','GLZ_Wavelet','GRX_Wavelet','GRY_Wavelet','GRZ_Wavelet','ORL_Wavelet','OPL_Wavelet','OYL_Wavelet','ORR_Wavelet','OPR_Wavelet','OYR_Wavelet','ALX_slice1_Paa','ALX_slice2_Paa','ALX_slice3_Paa','ALY_slice1_Paa','ALY_slice2_Paa','ALY_slice3_Paa','ALZ_slice1_Paa','ALZ_slice2_Paa','ALZ_slice3_Paa','ARX_slice1_Paa','ARX_slice2_Paa','ARX_slice3_Paa','ARY_slice1_Paa','ARY_slice2_Paa','ARY_slice3_Paa','ARZ_slice1_Paa','ARZ_slice2_Paa','ARZ_slice3_Paa','EMG0L_slice1_Paa','EMG0L_slice2_Paa','EMG0L_slice3_Paa','EMG1L_slice1_Paa','EMG1L_slice2_Paa','EMG1L_slice3_Paa','EMG2L_slice1_Paa','EMG2L_slice2_Paa','EMG2L_slice3_Paa','EMG3L_slice1_Paa','EMG3L_slice2_Paa','EMG3L_slice3_Paa','EMG4L_slice1_Paa','EMG4L_slice2_Paa','EMG4L_slice3_Paa','EMG5L_slice1_Paa','EMG5L_slice2_Paa','EMG5L_slice3_Paa','EMG6L_slice1_Paa','EMG6L_slice2_Paa','EMG6L_slice3_Paa','EMG7L_slice1_Paa','EMG7L_slice2_Paa','EMG7L_slice3_Paa','EMG0R_slice1_Paa','EMG0R_slice2_Paa','EMG0R_slice3_Paa','EMG1R_slice1_Paa','EMG1R_slice2_Paa','EMG1R_slice3_Paa','EMG2R_slice1_Paa','EMG2R_slice2_Paa','EMG2R_slice3_Paa','EMG3R_slice1_Paa','EMG3R_slice2_Paa','EMG3R_slice3_Paa','EMG4R_slice1_Paa','EMG4R_slice2_Paa','EMG4R_slice3_Paa','EMG5R_slice1_Paa','EMG5R_slice2_Paa','EMG5R_slice3_Paa','EMG6R_slice1_Paa','EMG6R_slice2_Paa','EMG6R_slice3_Paa','EMG7R_slice1_Paa','EMG7R_slice2_Paa','EMG7R_slice3_Paa','GLX_slice1_Paa','GLX_slice2_Paa','GLX_slice3_Paa','GLY_slice1_Paa','GLY_slice2_Paa','GLY_slice3_Paa','GLZ_slice1_Paa','GLZ_slice2_Paa','GLZ_slice3_Paa','GRX_slice1_Paa','GRX_slice2_Paa','GRX_slice3_Paa','GRY_slice1_Paa','GRY_slice2_Paa','GRY_slice3_Paa','GRZ_slice1_Paa','GRZ_slice2_Paa','GRZ_slice3_Paa','ORL_slice1_Paa','ORL_slice2_Paa','ORL_slice3_Paa','OPL_slice1_Paa','OPL_slice2_Paa','OPL_slice3_Paa','OYL_slice1_Paa','OYL_slice2_Paa','OYL_slice3_Paa','ORR_slice1_Paa','ORR_slice2_Paa','ORR_slice3_Paa','OPR_slice1_Paa','OPR_slice2_Paa','OPR_slice3_Paa','OYR_slice1_Paa','OYR_slice2_Paa','OYR_slice3_Paa','ALX_PSD','ALY_PSD','ALZ_PSD','ARX_PSD','ARY_PSD','ARZ_PSD','EMG0L_PSD','EMG1L_PSD','EMG2L_PSD','EMG3L_PSD','EMG4L_PSD','EMG5L_PSD','EMG6L_PSD','EMG7L_PSD','EMG0R_PSD','EMG1R_PSD','EMG2R_PSD','EMG3R_PSD','EMG4R_PSD','EMG5R_PSD','EMG6R_PSD','EMG7R_PSD','GLX_PSD','GLY_PSD','GLZ_PSD','GRX_PSD','GRY_PSD','GRZ_PSD','ORL_PSD','OPL_PSD','OYL_PSD','ORR_PSD','OPR_PSD','OYR_PSD','ALX_MaxDCT','ALY_MaxDCT','ALZ_MaxDCT','ARX_MaxDCT','ARY_MaxDCT','ARZ_MaxDCT','EMG0L_MaxDCT','EMG1L_MaxDCT','EMG2L_MaxDCT','EMG3L_MaxDCT','EMG4L_MaxDCT','EMG5L_MaxDCT','EMG6L_MaxDCT','EMG7L_MaxDCT','EMG0R_MaxDCT','EMG1R_MaxDCT','EMG2R_MaxDCT','EMG3R_MaxDCT','EMG4R_MaxDCT','EMG5R_MaxDCT','EMG6R_MaxDCT','EMG7R_MaxDCT','GLX_MaxDCT','GLY_MaxDCT','GLZ_MaxDCT','GRX_MaxDCT','GRY_MaxDCT','GRZ_MaxDCT','ORL_MaxDCT','OPL_MaxDCT','OYL_MaxDCT','ORR_MaxDCT','OPR_MaxDCT','OYR_MaxDCT'});

    % Clear temporary variables
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end

function createBoxPlotForGesture(gesture, compiledFeatureMatrix, featurExtractionMethod,featureList)
    global folderName;
    global totalNumRecords
    global map_gesture_numRecords
    keySet = {'About','Can','And','Cop','Deaf','Decide','Father','Find','Go Out','Hearing'};
    map_gesture_gestureID = containers.Map(keySet,[1:length(keySet)]) ;
%     zReshapedIntoVector=reshape(compiledFeatureMatrix,[1,200*34]);
    
    x = [min(compiledFeatureMatrix,[],1);max(compiledFeatureMatrix,[],1)];
    b = bsxfun(@minus,compiledFeatureMatrix,x(1,:));
    b = bsxfun(@rdivide,b,diff(x,1,1));
%     b=compiledFeatureMatrix;
    zReshapedIntoVector=reshape(b,[1,totalNumRecords*length(featureList)]);
    %generic code to create final group for an action
    actId = map_gesture_gestureID(gesture);
    offset = map_gesture_numRecords(gesture);
    value=map_gesture_numRecords.values;
    last = sum([value{1:actId}]);
    first = sum([value{1:(actId-1)}])+1;
    finalGroups =[];
    [~,numSensors] = size(compiledFeatureMatrix);
    for i = 1:numSensors
        boxSensor = zeros(1,totalNumRecords);
        boxSensor(1,first:last) = (i*2)-1;
        boxSensor(1,1:first-1) = i*2;
        boxSensor(1,last+1:totalNumRecords)= i*2;
        finalGroups = [finalGroups,boxSensor];    
    end

    l1 = 1.25:1:length(featureList)+1;
    l2=1:length(featureList);
    positions = sort([l1,l2]);
    % positions = [1 1.25 2 2.25 3 3.25 4 4.25 5 5.25 6 6.25 7 7.25 8 8.25 9 9.25 10 10.25 11 11.25 12 12.25 13 13.25 14 14.25 15 15.25 16 16.25 17 17.25 18 18.25 19 19.25 20 20.25 21 21.25 22 22.25 23 23.25 24 24.25 25 25.25 26 26.25 27 27.25 28 28.25 29 29.25 30 30.25 31 31.25 32 32.25 33 33.25 34 34.25 35 35.25 36 36.25 37 37.25 38 38.25 39 39.25 40 40.25 41 41.25 42 42.25 43 43.25 44 44.25 45 45.25 46 46.25 47 47.25 48 48.25];
    boxplot(zReshapedIntoVector,finalGroups, 'positions', positions,'symbol','');

    xticksArray=[];
    for i=1:2:length(featureList)*2
        xticksArray = [xticksArray,mean(positions(i:i+1))];
    end
    set(gca,'xtick',xticksArray);
    % set(gca,'xtick',[mean(positions(1:2)) mean(positions(3:4)) mean(positions(5:6)) mean(positions(7:8)) mean(positions(9:10)) mean(positions(11:12)) mean(positions(13:14)) mean(positions(15:16)) mean(positions(17:18)) mean(positions(19:20)) mean(positions(21:22)) mean(positions(23:24)) mean(positions(25:26)) mean(positions(27:28)) mean(positions(29:30)) mean(positions(31:32)) mean(positions(33:34)) mean(positions(35:36)) mean(positions(37:38)) mean(positions(39:40)) mean(positions(41:42)) mean(positions(43:44)) mean(positions(45:46)) mean(positions(47:48)) mean(positions(49:50)) mean(positions(51:52)) mean(positions(53:54)) mean(positions(55:56)) mean(positions(57:58)) mean(positions(59:60)) mean(positions(61:62)) mean(positions(63:64)) mean(positions(65:66)) mean(positions(67:68)) mean(positions(69:70)) mean(positions(71:72)) mean(positions(73:74)) mean(positions(75:76)) mean(positions(77:78)) mean(positions(79:80)) mean(positions(81:82)) mean(positions(83:84)) mean(positions(85:86)) mean(positions(87:88)) mean(positions(89:90)) mean(positions(91:92)) mean(positions(93:94)) mean(positions(95:96)) ])
    set(gca,'xticklabel',string(featureList))
    xtickangle(90);

    colorArray=[];
    for i=1:2:length(featureList)*2
        colorArray = [colorArray,'c','y'];
    end
    % color = ['c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y'];
    h = findobj(gca,'Tag','Box');
    for j=1:length(h)
       patch(get(h(j),'XData'),get(h(j),'YData'),colorArray(j),'FaceAlpha',.5);
    end

    c = get(gca, 'Children');

    hleg1 = legend(c(1:2), gesture, strcat("Not ",gesture) );
    featureExtractionMethodValue = {"Boxplot comparing Maximum Frequencies given by FFT over all the sensors for ","Boxplot comparing PSD over all the sensors for ","Boxplot comparing DCT over all the sensors for ","Boxplot comparing Wavelet over all the sensors for ","Boxplot comparing PAA(Slice 1 mean) over all the sensorts for ","Boxplot comparing PAA(Slice 2 mean) over all the sensors for ","Boxplot comparing PAA(Slice 3 mean) over all the sensors for ","Boxplot showing distinguishing features "};
    featureExtractionMethodKey = {'MaxFFT','PSD','MaxDCT','Wavelet','PAA1','PAA2','PAA3','Combined'};
    titleMap = containers.Map(featureExtractionMethodKey,featureExtractionMethodValue);
    title(strcat(titleMap(featurExtractionMethod),gesture, " and Not ",gesture));
    xlabel("Sensors");
    ylabel("Maximum Frequency");
    savefig(strcat(folderName,featurExtractionMethod,"_",gesture,".fig"));
end

function CompiledDataTable = importfile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   ABOUTDM28 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   ABOUTDM28 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   AboutDM28 = importfile('About_DM28.csv', 2, 757);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/02/24 16:49:55

% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

% Format for each line of text:
%   column1: categorical (%C)
%	column2: double (%f)
%   column3: categorical (%C)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
%	column24: double (%f)
%   column25: double (%f)
%	column26: double (%f)
%   column27: double (%f)
%	column28: double (%f)
%   column29: double (%f)
%	column30: double (%f)
%   column31: double (%f)
%	column32: double (%f)
%   column33: double (%f)
%	column34: double (%f)
%   column35: double (%f)
%	column36: double (%f)
%   column37: double (%f)
%	column38: double (%f)
%   column39: double (%f)
%	column40: double (%f)
%   column41: double (%f)
%	column42: double (%f)
%   column43: double (%f)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%C%C%f%C%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';%f%f%f%f%f%f%f%f%

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

% Close the text file.
fclose(fileID);

% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

% Create output variable
CompiledDataTable = table(dataArray{1:end-1}, 'VariableNames', {'Folder','Action','ActionNumber','Sensors','Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13','Var14','Var15','Var16','Var17','Var18','Var19','Var20','Var21','Var22','Var23','Var24','Var25','Var26','Var27','Var28','Var29','Var30','Var31','Var32','Var33','Var34','Var35','Var36','Var37','Var38','Var39','Var40','Var41','Var42','Var43','Var44','Var45','Var46','Var47'});%,'Var48','Var49','Var50','Var51','Var52','Var53','Var54','Var55'

end