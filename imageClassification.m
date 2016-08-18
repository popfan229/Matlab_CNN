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
pluseID    = 1;

pulseLocation = xlsread('pulseNum.xls');
firstPulse = pulseLocation(:,6);
secondPulse = pulseLocation(:,7);

for subNum = subRealNum
    for preNum = 1:3
        for repNum = 1:3
        
        fileNum = [num2str(fileID) '_'];
        subName = [num2str(subNum) '_'];
        fileName = [num2str(preNum) '_R'  num2str(repNum) '_'];
        
        if firstPulse(fileID)==0
            fileID = fileID + 1
            break;
        end
        for iPulse = firstPulse(fileID):secondPulse(fileID)           
            pulseName = [num2str(iPulse) '_'];
            pathIN = ['..\pluseImage\' fileNum subName fileName pulseName 'IN.bmp'];
            pathOUT = ['..\pluseImage\' fileNum subName fileName pulseName 'OUT.bmp'];
            movefile(pathIN, ['..\yes\' num2str(pluseID) '_in.bmp']);
            movefile(pathOUT, ['..\yes\' num2str(pluseID) '_out.bmp']);
            pluseID = pluseID+1;
        end


        fileID = fileID + 1
        % ----- End
        end
    end
end