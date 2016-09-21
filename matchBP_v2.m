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
filePath = 'D:\DPTest\yupu\RawDataRename_v2\';
sr = 2000;   %sample rate
waveloc = xlsread('WaveLocation_v2.xls');
pulseNum = xlsread('pulseNumV2.xls');

sbpNumIn = pulseNum(:,2);
dbpNumIn = pulseNum(:,3);    % 8-30 results IN
for fileID = 1:117 
    if isnan(sbpNumIn(fileID))
        continue;
    end
    fileID
    data = csvread([filePath num2str(fileID) 'A.csv']);
    [cuffPressure, bpIn, bpOut] = datasegment(data);
    sbpLoc = waveloc(fileID,sbpNumIn(fileID)*2+2);
    dbpLoc = waveloc(fileID,dbpNumIn(fileID)*2+2);
    sbp = cuffPressure(sbpLoc);
    dbp = cuffPressure(dbpLoc);
    dpin(fileID,:) = [sbp dbp];
end

    xlswrite('deepLearnResult_v2.xls', dpin,'in');
