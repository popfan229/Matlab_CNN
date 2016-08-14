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
subRealNum = [1 2 3 4 5 6 7 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 31 32 33];
fileID     = 1;


for subNum = subRealNum
    for preNum = 1:3
        for repNum = 1:3
            
        pathNam = num2str(subNum);
        fileNam   = [num2str(preNum) '_R'  num2str(repNum) '.csv'];
        if subNum < 10
            pathAll    = ['..\..\RawData\00' pathNam '\' fileNam]
        else
            pathAll    = ['..\..\RawData\0' pathNam '\' fileNam]
        end

%         filePath = '..\..\RawData\001\1_R1.CSV';  % home
        data = csvread(pathAll);
        copyfile(pathAll, ['..\RawDataRename\' num2str(fileID) '.csv']);
  
        fileID = fileID + 1
        % ----- End
        end
    end
end