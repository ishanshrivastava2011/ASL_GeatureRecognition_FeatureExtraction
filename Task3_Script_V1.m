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

%SUBTASK 2: Running PCA on the feature Matrix:
[coeff,score,latent,tsquared,explained,mu] = pca(table2array(compiled_featureMatrix_Table(:,2:width(compiled_featureMatrix_Table)))); 
disp("PCA Done");

%Creating the orginal data back into the transformed dimensional space of
%the eigen vectors.
gesturesInNewReducedDimSpace = [compiled_featureMatrix_Table(:,1),array2table(score)];
writetable(gesturesInNewReducedDimSpace,strcat(folderName,'gesturesInReducedDimSpace.csv'));

% %SUBTASK 2: Creating a Table for All Eigen Vectors:
eigenVectors_Columnar_Table = array2table(coeff);
eigenVectors_Columnar_Table.Row = compiled_featureMatrix_Table.Properties.VariableNames(1,2:length(coeff)+1);
writetable(eigenVectors_Columnar_Table,strcat(folderName,'eigenVectors_Columnar_Table.csv'));

%SUBTASK 2: Ploting 10 Eigen Vectors:
listOfPC = [1:10];
plotEigenVectors(eigenVectors_Columnar_Table,listOfPC);


%SUBTASK 2: Ploting All Eigen Vectors:
[~,numEigenVectors]=size(coeff);
listOfPC = [1:numEigenVectors];
plotEigenVectors(eigenVectors_Columnar_Table,listOfPC);

%SUBTASK 4: Plotting each Gesture Vs Not Gesture plots comparing top 10
%Principal Components
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},score(:,1:10), 'PC1_to_10');
end

function plotEigenVectors(eigenVectors_Columnar_Table,listOfPC)
    global folderName
    plot(table2array(eigenVectors_Columnar_Table(:,listOfPC)));
    
    legend(strcat(repmat('PC',length(listOfPC),1),num2str(listOfPC(:))))
    set(gcf, 'Position', [3000, 1500,2000, 5500]);
    xlim([0 width(eigenVectors_Columnar_Table)])
    xticks([1:width(eigenVectors_Columnar_Table)]);
    xticklabels(string(eigenVectors_Columnar_Table.Row));
    xtickangle(90);
    title("Eigen Vector Plot");
    xlabel("Original Features");
    ylabel("Weights given by Eigen Vectors");
    savefig(strcat(folderName,num2str(length(listOfPC)),"_EigenVectors.fig"));
end

%FUNCTION TO CREATE A BOX PLOT FOR ONE GESTURE:
%This will create and save a plot for the given gesture, comparing the
%spread of Principal Component values for the gesture and for anything 'NOT of gesture'
function createBoxPlotForGesture(gesture, compiledFeatureMatrix, featurExtractionMethod)
    global folderName;
    global totalNumRecords
    global map_gesture_numRecords
    keySet = {'About','Can','And','Cop','Deaf','Decide','Father','Find','Go Out','Hearing'};
    map_gesture_gestureID = containers.Map(keySet,[1:length(keySet)]) ;
%     zReshapedIntoVector=reshape(compiledFeatureMatrix,[1,200*34]);
    
%     x = [min(compiledFeatureMatrix,[],1);max(compiledFeatureMatrix,[],1)];
%     b = bsxfun(@minus,compiledFeatureMatrix,x(1,:));
%     b = bsxfun(@rdivide,b,diff(x,1,1));
%     b=compiledFeatureMatrix;
%     zReshapedIntoVector=reshape(b,[1,totalNumRecords*length(featureList)]);
    zReshapedIntoVector=reshape(compiledFeatureMatrix,[1,totalNumRecords*10]);
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

    positions = [1 1.25 2 2.25 3 3.25 4 4.25 5 5.25 6 6.25 7 7.25 8 8.25 9 9.25 10 10.25 ];
    
    boxplot(zReshapedIntoVector,finalGroups, 'positions', positions);

    set(gca,'xtick',[mean(positions(1:2)) mean(positions(3:4)) mean(positions(5:6)) mean(positions(7:8)) mean(positions(9:10)) mean(positions(11:12)) mean(positions(13:14)) mean(positions(15:16)) mean(positions(17:18)) mean(positions(19:20)) ])
    set(gca,'xticklabel',{"PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10"})

    color = ['c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y','c', 'y','c', 'y','c', 'y','c', 'y', 'c', 'y'];
    h = findobj(gca,'Tag','Box');
    for j=1:length(h)
       patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.5);
    end

    c = get(gca, 'Children');

    hleg1 = legend(c(1:2), gesture, strcat("Not ",gesture) );
    title(strcat("Boxplot comparing first 10 Principal Components for ",gesture, " and Not ",gesture));
    xlabel("Principal Components");
    ylabel("Eigen Vectors");
    savefig(strcat(folderName,featurExtractionMethod,"_",gesture,".fig"));
end


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