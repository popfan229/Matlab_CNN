% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: tranlate pulse number to BP value
% //
% //  Aaron
% //  YF Inc.
% //  Aug 23 2016
% //  Built with MATLAB
% //******************************************************************************
clc
% clear all
close all
filePath = '..\RawDataRename_v2\';
sr = 2000;   %sample rate
TYPE = 'B';
waveloc = xlsread('WaveLocation_v2.xls',TYPE);
pulseNum = xlsread('pulseNumV2.xls',TYPE);

sbpNumIn = pulseNum(:,2);
dbpNumIn = pulseNum(:,3);    % 8-30 results IN
for fileID = 1:117 
    if isnan(sbpNumIn(fileID))
        continue;
    end
    fileID
    data = csvread([filePath num2str(fileID) TYPE '.csv']);
    [cuffPressure, bpIn, bpOut] = datasegment(data);
    sbpLoc = waveloc(fileID,sbpNumIn(fileID)*2+2)-1200;
    dbpLoc = waveloc(fileID,dbpNumIn(fileID)*2+2)-1200;
    sbp = cuffPressure(sbpLoc);
    dbp = cuffPressure(dbpLoc);
    dpin(fileID,:) = [sbp dbp];
end

    xlswrite('deepLearnResult_v2_1.xls', dpin,TYPE);
