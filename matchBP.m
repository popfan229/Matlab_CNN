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
filePath = '..\RawDataRename\';
sr = 2000;   %sample rate
waveloc = xlsread('WaveLocation.xls');
pulseNum = xlsread('pulseNum.xls');
sbpNum = pulseNum(:,10);
dbpNum = pulseNum(:,11);
for fileID = 1:270 
    data = csvread([filePath num2str(fileID) '.csv']);
    [cuffPressure, bpIn, bpOut] = datasegment(data);
    sbpLoc = waveloc(fileID,sbpNum(fileID)*2+2);
    dbpLoc = waveloc(fileID,dbpNum(fileID)*2+2);
    sbp = cuffPressure(sbpLoc);
    dbp = cuffPressure(dbpLoc);
    dp = [sbp dbp];
    xlswrite(['deepLearnResult.xls'], dp,1, ['B' num2str(fileID+1)]);
end