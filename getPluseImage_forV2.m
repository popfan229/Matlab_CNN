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
% TYPE = 'A';
specialNumB = [7,8,9,10,11,12,65,66,121,122,123,125,155,156,181,182,183,337,338];
specialNumS = [40,41,42,190,191,192,371,372,385,386,387,391,392,393];

for fileID = 1:417
            
        fileNam   = [num2str(fileID) '.csv'];
        pathAll = ['..\RawDataRename_v2\' fileNam];
        data = csvread(pathAll);

        cuffPressure   = data(:,1);     % cuff pressure
        soundOutCuff   = data(:,6);     % brath
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
        soundOut = soundOutCuff(tRange);% 取出40mmHg-150mmHg范围内的soundOut


        if(sum(fileID == specialNumB)>=1)
            [pks,locs] = findpeaks(cuffPr,'minpeakdistance',1700,'minpeakheight',0.15);
        elseif(sum(fileID == specialNumS)>=1)
            [pks,locs] = findpeaks(cuffPr,'minpeakdistance',1000,'minpeakheight',0.15);
        else
            [pks,locs] = findpeaks(cuffPr,'minpeakdistance',1300,'minpeakheight',0.15);
        end
        
        v_T_Ft = [];
        v_T_Ft = locs;  %重新复值cuff波定点位置
%         plot(cuffPr);
%         hold on
%         plot(locs,pks,'*');
%         hold off
        % ----- End

        %% ---- save plus wave
        waveLocation = [];
        for i=1:length(v_T_Ft)-2
            Lstart = v_T_Ft(i+1)-1199; Lend = v_T_Ft(i+1)+800;
            waveLocation = [waveLocation Lstart Lend];
            plusWaveOut =  soundOut(Lstart : Lend)';   %第一个波不要
            imageTout = audioSpecImage( plusWaveOut,2000,128, 112, 0); %怎么实现imagesc的数据缩放
            imageTout = flipud(imageTout);
            imageTout(1,:) = [];
            imageTout(:,1:2) = [];   %remove some data to make sure image size 116*64                   
            maxV = max(max(imageTout));minV = min(min(imageTout));   % for sound Out
            imageGray = uint8(round(((imageTout-minV)./(maxV-minV))*255));
%             imageGray = flipud(imageGray);
%             imageGray(1,:) = [];
%             imageGray(:,1:2) = [];
            imwrite(imageGray,['..\pulseImage_v2\' num2str(fileID) '_' num2str(i) '.bmp']);
        end
      %  ----- End
        
        %% ---- save plus wave location
        waveLocation = [fileID length(v_T_Ft)-2 waveLocation];
        xlswrite(['WaveLocation_v2_417.xls'], waveLocation,1, ['B' num2str(fileID+1)]);  
        % ----- End
        fileID
end
