global suffix
global folderName
global sensors
global listOfActions
global map_gesture_numRecords
global totalNumRecords

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

%Extracting Different Features from the sensors
compiled_MaxFFT_Matrix = featureExtraction_MaxFFT();
compiled_MaxFFT_Table = formateAndCreateFeatureTable(compiled_MaxFFT_Matrix, 'MaxFFT');
writetable(compiled_MaxFFT_Table,strcat(folderName,'compiled_MaxFFT_Table.csv'));

compiled_Wavelet_Matrix = featureExtraction_Wavelet();
compiled_Wavelet_Table = formateAndCreateFeatureTable(compiled_Wavelet_Matrix, 'Wavelet');
writetable(compiled_Wavelet_Table,strcat(folderName,'compiled_Wavelet_Table.csv'));

compiled_Paa_Table = featureExtraction_paa();
compiled_Paa_Matrix = table2array(compiled_Paa_Table(:,2:width(compiled_Paa_Table)));
writetable(compiled_Paa_Table,strcat(folderName,'compiled_Paa_Table.csv'));

compiled_PSD_Matrix = PowerSpectralDensity();
compiled_PSD_Table = formateAndCreateFeatureTable(compiled_PSD_Matrix, 'PSD');
writetable(compiled_PSD_Table,strcat(folderName,'compiled_PSD_Table.csv'));

compiled_DCT_Matrix = featureExtraction_DCT();
compiled_DCT_Table = formateAndCreateFeatureTable(compiled_DCT_Matrix, 'MaxDCT');
writetable(compiled_DCT_Table,strcat(folderName,'compiled_DCT_Table.csv'));

%SUBTASK 1: Creating the feature Matrix:
compiled_featureMatrix_Table = [compiled_MaxFFT_Table,compiled_Wavelet_Table(:,2:width(compiled_Wavelet_Table)),compiled_Paa_Table(:,2:width(compiled_Paa_Table)),compiled_PSD_Table(:,2:width(compiled_PSD_Table)),compiled_DCT_Table(:,2:width(compiled_DCT_Table))];
writetable(compiled_featureMatrix_Table,strcat(folderName,'compiled_featureMatrix_Table.csv'));
disp("Compiled Feature Matrix Created and Saved");




%Feature Extraction Function Definition:
%It will take list of actions and sensors as an input. Reason for this is
%that in this assignment we are just using few actions and sensors. We
%might use others in the subsequent assignments. 
    
function compiled_MaxFFT_Matrix = featureExtraction_MaxFFT()
    %compiled_MaxFFT_Matrix will be 200 X 34 matrix (200 X (34*3) for Bhagya) 
    %each row will be an observation(20 obs per gesture) of some gesture(10 gestures) so 200 rows.
    %each column will be a featue extracted by the respective feature
    %extraction method for the corresponding sensor
    
    %NOTE:
    %Please maintain the order of the actions in rows( Eg: 1st 20 rows for About, 2nd 20 rows for Can and so on,
    %and the order of sensors in columns as well since I will be assuming the sam order
    
    global suffix
    global folderName
    global sensors
    global listOfActions
    global map_gesture_numRecords
    global totalNumRecords
    compiled_MaxFFT_Matrix = zeros(totalNumRecords,length(sensors));
    offset=0;
    for i=1:length(listOfActions)

        currGesture = listOfActions{i};
        CompiledDataTable = importfile(strcat(folderName,currGesture,suffix),2,30000);
        numOfActionsInCurGesture=map_gesture_numRecords(currGesture);
        for k=1:length(sensors)


            row=CompiledDataTable.Sensors == sensors{k};
            CompiledDataTable_ALX = CompiledDataTable(row, 5:width(CompiledDataTable));
            ALX_Array = table2array(CompiledDataTable_ALX);
            L = width(CompiledDataTable_ALX);
            n = 2^nextpow2(L);
            fft_ALX = fft(ALX_Array,n,2);
          
            for j=1:numOfActionsInCurGesture
        %         z(j,i)=max(P1(j,:));
                compiled_MaxFFT_Matrix(j+offset,k)=max(abs(fft_ALX(j,:)));
            end


        end
        offset = offset+numOfActionsInCurGesture;
    end
end

function compiled_Wavelet_Matrix = featureExtraction_Wavelet()
    global suffix
    global folderName
    global sensors
    global listOfActions
    global totalNumRecords
    global map_gesture_numRecords
    z = zeros(totalNumRecords,length(sensors));
    for k=1:length(sensors)
        count = 1;
        for i=1:length(listOfActions)
            currGesture = listOfActions{i};
            CompiledDataTable = importfile(strcat(folderName,currGesture,suffix),2,30000);
            row=CompiledDataTable.Sensors == sensors{k};
            CompiledDataTable_ALX = CompiledDataTable(row, 5:width(CompiledDataTable));
            ALX_Array = table2array(CompiledDataTable_ALX);
            numOfActionsInCurGesture=map_gesture_numRecords(currGesture);
            for j = 1 : numOfActionsInCurGesture
                [c,l] = wavedec(ALX_Array(j,:),6,'haar');
                [~, ~, ~, ~,~,cd6] = detcoef(c,l,[1 2 3 4 5 6]);
                z(count,k) = cd6;
                count = count + 1;
            end

        end
    compiled_Wavelet_Matrix = z;
    end
end

function paa_Table = featureExtraction_paa()
    global suffix
    global folderName
    global sensors
    global listOfActions
    global map_gesture_numRecords
    paa_Table = [];
    for j = 1:length(sensors)
        allActions=[];
        for i=1:length(listOfActions)
            
            currGesture = listOfActions{i};
            CompiledDataTable = importfile(strcat(folderName,currGesture,suffix),2,3000);
            row=CompiledDataTable.Sensors == sensors{j};
            CompiledDataTable_ALX = CompiledDataTable(row, 5:width(CompiledDataTable));
            currGesture_currSensor_Means = rowfun(@doPAAPerRow,CompiledDataTable_ALX,'OutputVariableNames',{strcat(sensors{j},'_slice1_Paa') strcat(sensors{j},'_slice2_Paa') strcat(sensors{j},'_slice3_Paa')});
            Gesture = repmat(convertCharsToStrings(listOfActions{i}),map_gesture_numRecords(listOfActions{i}),1);
            Gesture = array2table(Gesture);
            gestureMeans = [Gesture currGesture_currSensor_Means];
            allActions=[allActions;gestureMeans];
        end
        paa_Table = [ paa_Table allActions(:,2:4) ] ;
    end
    paa_Table = [array2table(allActions.Gesture) paa_Table];
end
 
function [mean1,mean2,mean3] = doPAAPerRow(Var1,Var2,Var3,Var4,Var5,Var6,Var7,Var8,Var9,Var10,Var11,Var12,Var13,Var14,Var15,Var16,Var17,Var18,Var19,Var20,Var21,Var22,Var23,Var24,Var25,Var26,Var27,Var28,Var29,Var30,Var31,Var32,Var33,Var34,Var35,Var36,Var37,Var38,Var39,Var40,Var41,Var42,Var43,Var44,Var45,Var46,Var47)
   currentRow =[Var1,Var2,Var3,Var4,Var5,Var6,Var7,Var8,Var9,Var10,Var11,Var12,Var13,Var14,Var15,Var16,Var17,Var18,Var19,Var20,Var21,Var22,Var23,Var24,Var25,Var26,Var27,Var28,Var29,Var30,Var31,Var32,Var33,Var34,Var35,Var36,Var37,Var38,Var39,Var40,Var41,Var42,Var43,Var44,Var45,Var46,Var47];
    [~,wdth] = size(currentRow);
    n = ceil(wdth/3);
    mean1=mean(currentRow(1,1:n));
    mean2=mean(currentRow(1,n+1:2*n));
    mean3=mean(currentRow(1,2*n + 1:wdth));
end


function aggregatedFeatureMatrix = PowerSpectralDensity()
    global suffix
    global folderName
    global listOfActions
    global map_gesture_numRecords
    inputFiles = listOfActions + suffix;
    aggregatedFeatureMatrix = [];
    for i = 1:10
        currGesture = listOfActions{i};
        matrix = csvread(strcat(folderName,inputFiles(i)),1,4);
        transpose_matrix = transpose(matrix);
        pxx_transpose_matrix = pwelch(transpose_matrix);
        rms_psd = rms(pxx_transpose_matrix);
        [m,n] = size(rms_psd);
        reshape_rms = reshape(rms_psd,[34,n/34]);
        transpose_reshape_rms = transpose(reshape_rms);
%         transpose_reshape_rms(:,35:36) = [];
        transpose_reshape_rms = transpose_reshape_rms(1:map_gesture_numRecords(currGesture),:);
        aggregatedFeatureMatrix = [aggregatedFeatureMatrix; transpose_reshape_rms];
    end
end

function compiled_DCT_Matrix = featureExtraction_DCT()
    %compiled_MaxFFT_Matrix will be 200 X 34 matrix (200 X (34*3) for Bhagya) 
    %each row will be an observation(20 obs per gesture) of some gesture(10 gestures) so 200 rows.
    %each column will be a featue extracted by the respective feature
    %extraction method for the corresponding sensor
    
    %NOTE:
    %Please maintain the order of the actions in rows( Eg: 1st 20 rows for About, 2nd 20 rows for Can and so on,
    %and the order of sensors in columns as well since I will be assuming the sam order
    
    global suffix
    global folderName
    global sensors
    global listOfActions
    global totalNumRecords
    global map_gesture_numRecords
    compiled_DCT_Matrix = zeros(totalNumRecords,length(sensors));
    offset=0;
    for i=1:length(listOfActions)

        currGesture = listOfActions{i};
        CompiledDataTable = importfile(strcat(folderName,currGesture,suffix),2,30000);
        numOfActionsInCurGesture=map_gesture_numRecords(currGesture);
        for k=1:length(sensors)


            row=CompiledDataTable.Sensors == sensors{k};
            CompiledDataTable_ALX = CompiledDataTable(row, 5:width(CompiledDataTable));
            ALX_Array = table2array(CompiledDataTable_ALX);
            L = width(CompiledDataTable_ALX);
            n = 2^nextpow2(L);
            fft_ALX = dct(ALX_Array,n,2);
          
            for j=1:numOfActionsInCurGesture
        %         z(j,i)=max(P1(j,:));
                compiled_DCT_Matrix(j+offset,k)=max(abs(fft_ALX(j,:)));
            end


        end
        offset = offset+numOfActionsInCurGesture;
    end
end

function formatedFeatureTable = formateAndCreateFeatureTable(compiled_feature_Matrix, featurExtractionMethod )
    global sensors
    global listOfActions
    global map_gesture_numRecords
    action=[];
    for i=1:length(listOfActions)
        action = [action;repmat(convertCharsToStrings(listOfActions{i}),map_gesture_numRecords(listOfActions{i}),1)];
    end
    columnNames = ['Gesture',strcat(cellstr(sensors),strcat('_',featurExtractionMethod) )];

    formatedFeatureTable = array2table(compiled_feature_Matrix);
    formatedFeatureTable = [array2table(action),formatedFeatureTable];
    formatedFeatureTable.Properties.VariableNames = columnNames;
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