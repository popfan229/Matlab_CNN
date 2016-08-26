% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: 直接通过waveLocation文件的到pulse image，编号统一为文件名编号
% //
% //  Aaron
% //  YF Inc.
% //  Aug 26 2016
% //  Built with MATLAB
% //******************************************************************************

clc
clear all
close all
filePath = '..\RawDataRename\';
sr = 2000;   %sample rate
waveloc = xlsread('WaveLocation.xls');
pulseNum = waveloc(:,2);

pulsepulseWaveOutloc = xlsread('pulseNum.xls');
firstPulse = pulsepulseWaveOutloc(:,6);
lastPulse = pulsepulseWaveOutloc(:,7);


for fileID = 180:180 
    data = csvread([filePath num2str(fileID) '.csv']);
    [cuffPressure, bpIn, bpOut] = datasegment(data);
    firstPulseNum = firstPulse(fileID);
    lastPulseNum = lastPulse(fileID);
    fileID
    for pulseCounter = 1:pulseNum(fileID)
        start = waveloc(fileID,pulseCounter*2+1);
        last  = waveloc(fileID,pulseCounter*2+2);
        pulseWaveIn  = bpIn(start : last)';
        pulseWaveOut = bpOut(start : last)';
        imageTin = audioSpecImage( pulseWaveIn,2000,128, 112, 0); %怎么实现imagesc的数据缩放
        imageTout = audioSpecImage( pulseWaveOut,2000,128, 112, 0); %怎么实现imagesc的数据缩放

        maxVin = max(max(imageTin));minVin = min(min(imageTin));    % for sound In
        imageGrayin = uint8(round(((imageTin-minVin)./(maxVin-minVin))*255));
        imageGrayin = flipud(imageGrayin);
        
        maxVout = max(max(imageTout));minVout = min(min(imageTout));   % for sound Out
        imageGrayout = uint8(round(((imageTout-minVout)./(maxVout-minVout))*255));
        imageGrayout = flipud(imageGrayout);
        if (pulseCounter >= firstPulseNum)&&(pulseCounter <= lastPulseNum)
            imwrite(imageGrayout,['..\pluseImage\yes\' num2str(fileID) '_' num2str(pulseCounter) '_out.bmp']);
            imwrite(imageGrayin,['..\pluseImage\yes\' num2str(fileID) '_' num2str(pulseCounter) '_in.bmp']);    
        else
            imwrite(imageGrayout,['..\pluseImage\no\' num2str(fileID) '_' num2str(pulseCounter) '_out.bmp']);
            imwrite(imageGrayin,['..\pluseImage\no\' num2str(fileID) '_' num2str(pulseCounter) '_in.bmp']);            
        end
        
    end
end