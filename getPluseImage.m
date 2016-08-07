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
clear
clc
%% ----- Load data
subRealNum = [1 2 3 4 5 6 7 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 31 32 33];


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

        cuffFit = cuffPressure(tRange); % �ҳ�40mmHg-150mmHg��Χ
        cuffFitAva = cuffFit(v_T_Ft);   % �ҳ�cuff����
        Xi = 0:1:length(cuffFit)-1;
        cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear'); % ��ֵ��ԭ������
        cuffPr = cuffFit-cuffInterp';   % ��ȥ���ߵĵ�����ѹ��������
        % ----- End of process cuffPressure

        %% ----- plot image & analysis
        plusWave = zeros(100,2000);     % ����ÿ������plus����
        soundIn = soundInCuff(tRange);  % ȡ��40mmHg-150mmHg��Χ�ڵ�soundIn
        soundOut = soundOutCuff(tRange);% ȡ��40mmHg-150mmHg��Χ�ڵ�soundOut
        v_T_Ft = v_T_Ft;                % v_T_Ft����ÿ�����ѹ�������λ��

        for i=1:length(v_T_Ft)-1
            wavDif(i) =  v_T_Ft(i+1) - v_T_Ft(i);
        end
        location = find(wavDif>=2800|wavDif<1000);  % ����ѹ�������֮��Ĳ�ҳ������
        v_T_Ft(location+1) = [];                    % remove��������ʼ��
        % subplot(2,1,1);plot(wavDif);
        % subplot(2,1,2);plot(cuffPr);
        % ----- End

        %% ---- save plus wave
        for i=1:length(v_T_Ft)-2
            plusWave(i,:) =  soundIn(v_T_Ft(i+1)-800:v_T_Ft(i+1)+1199)';   %��һ������Ҫ
            imageT = audioSpecImage( plusWave(i,:),2000,128, 112, 0); %��ôʵ��imagesc����������
            maxV = max(max(imageT));minV = min(min(imageT));
            imageGray = uint8(round(((imageT-minV)./(maxV-minV))*255));
            imageGray = flipud(imageGray);
            imwrite(imageGray,['..\pluseImage\' num2str(subNum) '_' num2str(preNum) '_R'  num2str(repNum) '_' num2str(i) '.bmp']);
        end
        % ----- End
        end
    end
end