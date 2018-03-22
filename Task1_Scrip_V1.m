%Helps you choose the Data Folder you want to work on.
dname = uigetdir('','Select a the CSE572_A2_data Folder');
[~,name] = fileparts(dname);

% We make a folder named : 'transformedDataFolder' inside the folder chosen,
%where all the new compiled files will be saved
if ismac || isunix
    % Code to run on Mac plaform or Unix System
    transformedDataFolder = fileparts(dname)+"/"+name+"/transformedDataFolder";
    curDir = fileparts(dname)+"/"+name;
elseif ispc
    % Code to run on Windows platform
    transformedDataFolder = fileparts(dname)+"\"+name+"\transformedDataFolder";
    curDir = fileparts(dname)+"\"+name;
else
    disp('Platform not supported')
end

cd(curDir.char);
mkdir transformedDataFolder;
%number of folders to take
numOfGroups_folder = 1;

%The folder to start from.
startingFolder = 28;
groups = [startingFolder:startingFolder+numOfGroups_folder-1];
groups = sprintfc('%02d', groups);
groupFolderNames = strcat(repmat('DM',numOfGroups_folder,1),groups(:));


%List of Gestures to be considered
listOfActions = ["About","Can","And","Cop","Deaf","Decide","Father","Find","Go Out","Hearing"];

%Iterate over the list of gestures looking for the specific files per 
%gesture and then concatenate them in a single file

varNums = [1:47];
v=sprintfc('%01d', varNums);
vN=strcat(repmat('Var',length(varNums),1),v(:));
varNames = ['Folder','Action','ActionNumber','Sensors',vN.'];
for i=1:length(listOfActions)
    action = listOfActions{i};
    transformedTable = array2table(zeros(0,length(varNames)), 'VariableNames',varNames);
    for k=1:length(groupFolderNames)
        
        groupFolder= groupFolderNames{k};
        files = dir(fullfile(strcat(dname,'/',groupFolder,'/'), '*.csv'));

        %Contains the list of all the csv files present in the folder chosen by the
        %user
        listOfFiles = {files.name};
        actionNumber=1;
        for j=1:length(listOfFiles)

            action;
            actionNumber;
            if contains(listOfFiles{j},action,'IgnoreCase',true)
                if ismac || isunix
                    % Code to run on Mac plaform or Unix System
                    filename = strcat(dname,'/',groupFolder)+"/"+listOfFiles{j};
                elseif ispc
                    % Code to run on Windows platform
                    filename = strcat(dname,'\',groupFolder)+"\"+listOfFiles{j};
                else
                    disp('Platform not supported')
                end

                tempTable = transform(readCSVFile(filename),action,actionNumber,groupFolder);
                if width(tempTable)>length(varNames)
                    disp("Discarding Action number '"+actionNumber+"' for gesture '"+ action+"' from the folder '"+groupFolder+"' because the sample size is "+(width(tempTable)-1));
                else
                    %The nested If Condition below are being used to nullify 
                    %the effect of unequal number of columns between the current action
                    %number and the previous action number. As of now, the
                    %extra columns are just not being considered here at all.
%                     if width(tempTable) ~= width(transformedTable)
%                         diff = width(tempTable) - width(transformedTable);
%                         if diff >0
%                             tempTable = tempTable(:,1:width(tempTable)-diff);
%                         else
%                             transformedTable = transformedTable(:,1:width(transformedTable)+diff);
%                         end
%                     end
                    if width(tempTable) == length(varNames)
                        transformedTable=[transformedTable;tempTable];
                        actionNumber=actionNumber+1;
                    else
                        numColsToAdd = length(varNames)-width(tempTable);
                        tempTable = [tempTable,array2table(zeros(height(tempTable),numColsToAdd),'VariableNames',varNames(width(tempTable)+1:length(varNames)))];
                        transformedTable=[transformedTable;tempTable];
                        actionNumber=actionNumber+1;
                    end
                    
                        
                end
%                 transformedTable=[transformedTable;tempTable];
%                 actionNumber=actionNumber+1;
            end
        end
        
        if k ==1
            transformedTable1=transformedTable;
        end
        if k ~= 1
            transformedTable1=[transformedTable1;transformedTable];
        end
        
    end
    
    %folder_fileName = fullfile([transformedDataFolder+"/",action+"_"+name+".csv"]);
    if ismac  || isunix
        % Code to run on Mac plaform or Unix System
        writetable(transformedTable,transformedDataFolder+"/"+action+"_"+name+".csv");
    elseif ispc
        % Code to run on Windows platform
        writetable(transformedTable,transformedDataFolder+"\"+action+"_"+name+".csv");
    else
        disp('Platform not supported')
    end
    
end

function dataTable = readCSVFile(filename)
delimiter = ',';
startRow = 2;

% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
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
%	column48: double (%f)
%   column49: double (%f)
%	column50: double (%f)
%   column51: double (%f)
%	column52: double (%f)
%   column53: double (%f)
%	column54: double (%f)
%   column55: double (%f)
%	column56: double (%f)
%   column57: double (%f)
%	column58: double (%f)
%   column59: double (%f)
%	column60: double (%f)
%   column61: double (%f)
%	column62: double (%f)
%   column63: double (%f)
%	column64: double (%f)
%   column65: double (%f)
%	column66: double (%f)
%   column67: double (%f)
%	column68: categorical (%C)
%   column69: categorical (%C)
%	column70: categorical (%C)
%   column71: categorical (%C)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%C%C%C%C%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

% Create output variable
dataTable = table(dataArray{1:end-1}, 'VariableNames', {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR','LHNX','LHNY','LHNZ','RHNX','RHNY','RHNZ','HX','HY','HZ','LTX','LTY','LTZ','RTX','RTY','RTZ','SpineMidX','SpineMidY','SpineMidZ','SpineBaseX','SpineBaseY','SpineBaseZ','ShoulderLeftX','ShoulderLeftY','ShoulderLeftZ','ShoulderRightX','ShoulderRightY','ShoulderRightZ','ElbowLeftX','ElbowLeftY','ElbowLeftZ','ElbowRightX','ElbowRightY','ElbowRightZ','Myo_Pose_left','Myo_Pose_Right','Kinect_pose_left','Kinect_pose_right'});

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end

%Creates the Transposed Final Individual Action Table
function actionFileTrans = transform(dataTable,action,actionNumber,groupFolder)

%Removing the Columns which aren't supposed to be considered in this assignment        
dataTable_Sub = dataTable(:,1:34);

%Converting the Table into an Array and transposing and converting it back to a Table.
dataTable_SubArray = table2array(dataTable_Sub);
dataTable_SubTable = array2table(dataTable_SubArray.');
dataTable_SubTableTemp = dataTable_SubTable;
dataTable_SubTableTemp.Properties.RowNames = dataTable_Sub.Properties.VariableNames;

%Creating "Action" Column to be added late
%Action = repmat(action+" "+int2str(actionNumber),width(dataTable_Sub),1);
Action = repmat(action,width(dataTable_Sub),1);

Folder = repmat(groupFolder,width(dataTable_Sub),1);

%Creating "ActionNumber" Column to be added late
ActionNumber = repmat(actionNumber,width(dataTable_Sub),1);

%Creating "Action 1" Column to be added late
Sensors = dataTable_SubTableTemp.Properties.RowNames;

%Adds Action, Sensors etc columns to the data
actionFileTrans = [table(Folder),table(Action),table(ActionNumber),table(Sensors),dataTable_SubTable];

end