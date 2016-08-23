% //******************************************************************************
% //  BP measurement using CNN
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

        cuffPressure   = data(:,1);     % cuff pressure
        soundInCuff    = data(:,2);     % microphone
        soundOutCuff   = data(:,3);     % brath
        sr = 2000;                      % sample rate
        % ----- End of load data 

        %% ----- Process cuffPressure
        cuffPressure     = (cuffPressure-1)*100;
        [v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure); 

        cuffFit = cuffPressure(tRange); % 找出40mmHg-150mmHg范围
        cuffFitAva = cuffFit(v_T_Ft);   % 找出cuff基线
        Xi = 0:1:length(cuffFit)-1;
        cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear'); % 插值成原来长度
        cuffPr = cuffFit-cuffInterp';   % 减去基线的到单纯压力波波形
        % ----- End of process cuffPressure

        %% ----- plot image & analysis
        plusWave = zeros(100,2000);     % 保存每个单独plus波形
        soundIn = soundInCuff(tRange);  % 取出40mmHg-150mmHg范围内的soundIn
        soundOut = soundOutCuff(tRange);% 取出40mmHg-150mmHg范围内的soundOut
        v_T_Ft = v_T_Ft;                % v_T_Ft保存每个袖带压力波起点位置

        for i=1:length(v_T_Ft)-1
            wavDif(i) =  v_T_Ft(i+1) - v_T_Ft(i);
        end
        location = find(wavDif>=2800|wavDif<1000);  % 根据压力波起点之间的差，找出错误的
        v_T_Ft(location+1) = [];                    % remove掉错误起始点
        % subplot(2,1,1);plot(wavDif);
        % subplot(2,1,2);plot(cuffPr);
        % ----- End

        %% ---- save plus wave
        waveLocation = [];
        impath = '..\pluseImage\';
        for i=1:length(v_T_Ft)-2
            Lstart = v_T_Ft(i+1)-800; Lend = v_T_Ft(i+1)+1199;
            waveLocation = [waveLocation Lstart Lend];
            plusWaveIn =  soundIn(Lstart : Lend)';   %第一个波不要
            plusWaveOut =  soundOut(Lstart : Lend)';   %第一个波不要
%             imageTin = audioSpecImage( plusWaveIn,2000,128, 112, 0); %怎么实现imagesc的数据缩放
%             imageTout = audioSpecImage( plusWaveOut,2000,128, 112, 0); %怎么实现imagesc的数据缩放
%             
%             maxV = max(max(imageTin));minV = min(min(imageTin));    % for sound In
%             imageGray = uint8(round(((imageTin-minV)./(maxV-minV))*255));
%             imageGray = flipud(imageGray);
% %             sprintf('%s%d_%d_%d_R%d_%d_IN.bmp',impath,fileID,subNum,preNum,repNum)
%             imwrite(imageGray,['..\pluseImage\' num2str(fileID) '_' num2str(subNum) '_' num2str(preNum) '_R'  num2str(repNum) '_' num2str(i) '_IN.bmp']);
%             
%             maxV = max(max(imageTout));minV = min(min(imageTout));   % for sound Out
%             imageGray = uint8(round(((imageTout-minV)./(maxV-minV))*255));
%             imageGray = flipud(imageGray);
%             imwrite(imageGray,['..\pluseImage\' num2str(fileID) '_' num2str(subNum) '_' num2str(preNum) '_R'  num2str(repNum) '_' num2str(i) '_OUT.bmp']);
        end
        % ----- End
        
        %% ---- save plus wave location
        waveLocation = [fileID length(v_T_Ft)-2 waveLocation];
        xlswrite(['..\BPresult\' 'WaveLocation.xls'], waveLocation,1, ['B' num2str(fileID+1)]);  
        fileID = fileID + 1
        % ----- End
        end
    end
end