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
waveloc = xlsread('..\BPresult\WaveLocation');
pulseNum = xlsread('..\BPresult\pulseNum');
sbpNum = pulseNum(:,3);
dbpNum = pulseNum(:,5);
for fileID = 1:270 
    data = csvread([filePath num2str(fileID) '.csv']);
    [cuffPressure, bpIn, bpOut] = datasegment(data);
    sbpLoc = waveloc(fileID,sbpNum(fileID)+2);
    dbpLoc = waveloc(fileID,dbpNum(fileID)+2);
    sbp = cuffPressure(sbpLoc)
    dbp = cuffPressure(dbpLoc)    
end