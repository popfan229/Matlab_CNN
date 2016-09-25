% //******************************************************************************
% //  MSP-FET430P140 Demo - Timer_A, Toggle P3.4, CCR0 Cont. Mode ISR, DCO SMCLK
% //
% //  Description: plus wave analysis, segment frame and plot specgram
% //
% //  Aaron
% //  YF Inc.
% //  Aug 7 2016
% //  Built with MATLAB
% //******************************************************************************

close all
clear
clc
%% ----- Load data
fileID     = 1;
% path = '..\..\2016-09 Data for Pan\';
path = '..\RawData_v2\';

for subNum = 1:39
        for repNum = 1:3
            
        pathNam = num2str(subNum);
        fileNam   = ['A'  num2str(repNum) '.csv'];
        if subNum < 10
            pathAll    = [path '00' pathNam '\' '00' pathNam fileNam]
        elseif (subNum < 100)&&(subNum >= 10)
            pathAll    = [path '0' pathNam '\' '0' pathNam fileNam]
        else
            pathAll    = [path pathNam '\' pathNam fileNam]
        end

%         filePath = '..\..\RawData\001\1_R1.CSV';  % home
        data = csvread(pathAll);
        copyfile(pathAll, ['..\RawDataRename_v2\' num2str(fileID) '.csv']);
  
        fileID = fileID + 1
        % ----- End
    end
end