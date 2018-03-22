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


compiled_Paa_Table3 = readCompiledPerFeatureTable(strcat(folderName,'compiled_Paa_Table.csv'),"PAA3");
compiled_Paa_Matrix3 = table2array(compiled_Paa_Table3(:,2:width(compiled_Paa_Table3)));
sensors_paa=[];
for i=1:length(sensors)
        sensors_paa = [sensors_paa,strcat(sensors(i),'_slice1'),strcat(sensors(i),'_slice2'),strcat(sensors(i),'_slice3')];
end

compiled_Paa_Table2 = readCompiledPerFeatureTable(strcat(folderName,'compiled_Paa_Table.csv'),'PAA2');
compiled_Paa_Matrix2 = table2array(compiled_Paa_Table2(:,2:width(compiled_Paa_Table2)));
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_Paa_Matrix3, 'PAA3',sensors_paa(3:3:102));
end

compiled_Paa_Table1 = readCompiledPerFeatureTable(strcat(folderName,'compiled_Paa_Table.csv'),'PAA1');
compiled_Paa_Matrix1 = table2array(compiled_Paa_Table1(:,2:width(compiled_Paa_Table1)));
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_Paa_Matrix2, 'PAA2',sensors_paa(2:3:102));
end
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_Paa_Matrix1, 'PAA1',sensors_paa(1:3:102));
end

compiled_MaxFFT_Table = readCompiledPerFeatureTable(strcat(folderName,'compiled_MaxFFT_Table.csv'),'MaxFFT');
compiled_MaxFFT_Matrix = table2array(compiled_MaxFFT_Table(:,2:width(compiled_MaxFFT_Table)));
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_MaxFFT_Matrix, 'MaxFFT',sensors);
end

compiled_DCT_Table = readCompiledPerFeatureTable(strcat(folderName,'compiled_DCT_Table.csv'),'MaxDCT');
compiled_DCT_Matrix = table2array(compiled_DCT_Table(:,2:width(compiled_DCT_Table)));
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_DCT_Matrix, 'MaxDCT',sensors);
end

compiled_PSD_Table = readCompiledPerFeatureTable(strcat(folderName,'compiled_PSD_Table.csv'),'PSD');
compiled_PSD_Matrix = table2array(compiled_PSD_Table(:,2:width(compiled_PSD_Table)));
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_PSD_Matrix, 'PSD',sensors);
end

compiled_Wavelet_Table = readCompiledPerFeatureTable(strcat(folderName,'compiled_Wavelet_Table.csv'),'Wavelet');
compiled_Wavelet_Matrix = table2array(compiled_Wavelet_Table(:,2:width(compiled_Wavelet_Table)));
for i=1:length(listOfActions)
    createBoxPlotForGesture(listOfActions{i},compiled_Wavelet_Matrix, 'Wavelet',sensors);
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%FUNCTION TO CREATE A BOX PLOT FOR ONE GESTURE:
%This will create and save a plot for the given gesture, comparing the
%spread of feature values for the gesture and for anything 'NOT of gesture

%Options for featurExtractionMethod :: 'MaxFFT','PSD','MaxDCT','Wavelet','PAA1','PAA2','PAA3','Combined'
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

function compiledfeatureMatrixTable = readCompiledPerFeatureTable(filename, featureExtractionMethod)
    global sensors
    delimiter = ',';
    startRow = 2;

    % Format for each line of text:

    formatSpec = '%C%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

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
    sensors_paa=[];
    columnNames=[];
    for i=1:length(sensors)
            sensors_paa = [sensors_paa,strcat(sensors(i),'_slice1'),strcat(sensors(i),'_slice2'),strcat(sensors(i),'_slice3')];
    end
    if string(featureExtractionMethod) == "PAA3"
           columnNames = ['Gesture',sensors_paa(3:3:102)];
    elseif string(featureExtractionMethod) == 'PAA2'
           columnNames = ['Gesture',sensors_paa(2:3:102)];
    elseif string(featureExtractionMethod) == 'PAA1'
            s1 = sensors_paa(1:3:102);
           columnNames = ['Gesture',s1];
    else
        columnNames = ['Gesture',strcat(cellstr(sensors),strcat('_',featureExtractionMethod) )];
    end
    compiledfeatureMatrixTable = table(dataArray{1:end-1}, 'VariableNames', cellstr(columnNames));

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
