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
% waveloc = xlsread('WaveLocation.xls');
% pulseNum = xlsread('pulseNum.xls');

sbpNumIn = pulseNum(:,12);
dbpNumIn = pulseNum(:,13);    % 8-30 results IN

sbpNumOut = pulseNum(:,15);
dbpNumOut = pulseNum(:,16);    % 8-30 results OUT
for fileID = 1:270 
    if isnan(sbpNumIn(fileID))
        continue;
    end
    fileID
    data = csvread([filePath num2str(fileID) '.csv']);
    [cuffPressure, bpIn, bpOut] = datasegment(data);
    sbpLoc = waveloc(fileID,sbpNumIn(fileID)*2+2);
    dbpLoc = waveloc(fileID,dbpNumIn(fileID)*2+2);
    sbp = cuffPressure(sbpLoc);
    dbp = cuffPressure(dbpLoc);
    dpin(fileID,:) = [sbp dbp];
    
    sbpLoc = waveloc(fileID,sbpNumOut(fileID)*2+2);
    dbpLoc = waveloc(fileID,dbpNumOut(fileID)*2+2);
    sbp = cuffPressure(sbpLoc);
    dbp = cuffPressure(dbpLoc);
    dpout(fileID,:) = [sbp dbp];
    

end

    xlswrite(['deepLearnResult08302.xls'], dpin,'in');
    xlswrite(['deepLearnResult08302.xls'], dpout,'out');