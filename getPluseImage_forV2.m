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
TYPE = 'A';


for fileID = 1:117
            
        fileNam   = [num2str(fileID) TYPE '.csv'];
        pathAll = ['..\RawDataRename_v2\' fileNam];
        data = csvread(pathAll);

        cuffPressure   = data(:,1);     % cuff pressure
        soundOutCuff   = data(:,6);     % brath
        sr = 2000;                      % sample rate
        % ----- End of load data 

        %% ----- Process cuffPressure
        cuffPressure     = (cuffPressure-1)*100;
        [v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure); 

        cuffFit = cuffPressure(tRange); % �ҳ�40mmHg-150mmHg��Χ
        cuffFitAva = cuffFit(v_T_Ft);   % �ҳ�cuff����
        Xi = 0:1:length(cuffFit)-1;
        cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear'); % ��ֵ��ԭ������
        cuffPr = cuffFit-cuffInterp';   % ��ȥ���ߵĵ�����ѹ��������
        % ----- End of process cuffPressure

        %% ----- plot image & analysis
        plusWave = zeros(100,2000);     % ����ÿ������plus����
        soundOut = soundOutCuff(tRange);% ȡ��40mmHg-150mmHg��Χ�ڵ�soundOut
        v_T_Ft = v_T_Ft;                % v_T_Ft����ÿ�����ѹ�������λ��

        for i=1:length(v_T_Ft)-1
%             wavDif(fileID, i) =  v_T_Ft(i+1) - v_T_Ft(i); % for debug
            wavDif(i) =  v_T_Ft(i+1) - v_T_Ft(i);
        end
        location = find(wavDif>=3200|wavDif<1000);  % ����ѹ�������֮��Ĳ�ҳ������
        v_T_Ft(location+1) = [];                    % remove��������ʼ��
%         subplot(2,1,1);plot(wavDif(fileID, :));
%         subplot(2,1,2);plot(cuffPr);
        % ----- End

        %% ---- save plus wave
        waveLocation = [];
        impath = '..\pluseImage_v3\';
        for i=1:length(v_T_Ft)-2
            Lstart = v_T_Ft(i+1)-800; Lend = v_T_Ft(i+1)+1199;
            waveLocation = [waveLocation Lstart Lend];
            plusWaveOut =  soundOut(Lstart : Lend)';   %��һ������Ҫ
            imageTout = audioSpecImage( plusWaveOut,2000,128, 112, 0); %��ôʵ��imagesc����������
                       
            maxV = max(max(imageTout));minV = min(min(imageTout));   % for sound Out
            imageGray = uint8(round(((imageTout-minV)./(maxV-minV))*255));
            imageGray = flipud(imageGray);
            imwrite(imageGray,['..\pluseImage_p2\' TYPE '\' num2str(fileID) '_' num2str(i) '.bmp']);
        end
        % ----- End
        
        %% ---- save plus wave location
%         waveLocation = [fileID length(v_T_Ft)-2 waveLocation];
%         xlswrite(['WaveLocation_v2.xls'], waveLocation,1, ['B' num2str(fileID+1)]);  
        % ----- End
        fileID
end
