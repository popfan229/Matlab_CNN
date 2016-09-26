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
clc
%% ----- Load data
% pulseLocation = xlsread('refBPnumber.xls');
% firstPulse = pulseLocation(:,2);
% secondPulse = pulseLocation(:,3);

for fileID = 1:417
        if isnan(firstPulse(fileID))
            continue;
        end
        for iPulse = firstPulse(fileID):secondPulse(fileID)           
            fileName = [num2str(fileID) '_' num2str(iPulse) '.bmp'];
            pathIN = ['..\pulseImage_v2\' fileName];
            movefile(pathIN, ['..\dpimage_v2\yes\' fileName]);
        end
        % ----- End
        fileID
end