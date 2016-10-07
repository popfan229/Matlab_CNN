% //  Description: 论文绘图
% //
% //  Aaron
% //  YF Inc.
% //  Sep 3 2016
% //  Built with MATLAB
% //******************************************************************************
% 
% data = csvread('..\RawDataRename\2.csv');
% cuffPressure   = data(:,1);     % cuff pressure
% soundInCuff    = data(:,2);     % microphone
% soundOutCuff   = data(:,3);     % brath
% sr = 2000;                      % sample rate
% %% ----- Process cuffPressure
% cuffPressure     = (cuffPressure-1)*100;
% [v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure); 
% 
% cuffFit = cuffPressure(tRange); % 找出40mmHg-150mmHg范围
% cuffFitAva = cuffFit(v_T_Ft);   % 找出cuff基线
% Xi = 0:1:length(cuffFit)-1;
% cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear'); % 插值成原来长度
% cuffPr = cuffFit-cuffInterp';   % 减去基线的到单纯压力波波形
% % ----- End of process cuffPressure
% 
% %% ----- plot figure 1
% soundIn = soundInCuff(tRange);  % 取出40mmHg-150mmHg范围内的soundIn
% soundOut = soundOutCuff(tRange);% 取出40mmHg-150mmHg范围内的soundOut
% 
% cuffWave = cuffPr(39000:80000);
% soundInPlot = soundIn(39000:80000);
% 
% t = [1/2000:1/2000:length(soundInPlot)/2000]; % Fs = 2000Hz
% time = length(soundInPlot)/2000;
% hold on
% plot(t,cuffWave);  
% plot(t,soundInPlot,'r');  
% xlim([0 time]);
% ylim([-5 5]);
% xlabel('time (s)');
% ylabel('amptitude');
% set (gcf,'Position',[400,100,900,400])
% hold off
% %% ----- plot figure 2 : use the 27 pulse of 2 file cuffIn
% fileID = 2;
% pulseCounter = 27;
% waveloc = xlsread('WaveLocation.xls');
% 
% start = waveloc(fileID,pulseCounter*2+1);
% last  = waveloc(fileID,pulseCounter*2+2);
% pulseWaveIn  = soundIn(start : last)';
% imageTin = audioSpecImage( pulseWaveIn,2000,128, 112, 0); %怎么实现imagesc的数据缩放
% maxVin = max(max(imageTin));minVin = min(min(imageTin));    % for sound In
% imageGrayin = uint8(round(((imageTin-minVin)./(maxVin-minVin))*255));
% imageGrayin = flipud(imageGrayin);
% subplot(2,1,1);imshow(imageGrayin);
% subplot(2,1,2);plot(pulseWaveIn);
% 
% %% ---- plot figure 6
% fileID = 2;
% pulseNum = waveloc(fileID,2);
% pointLoc = waveloc(fileID,3:pulseNum*2+2);
% figure();
% 
% t = [1/2000:1/2000:length(soundIn)/2000]; % Fs = 2000Hz
% time = length(soundIn)/2000;
% subplot(2,1,2);plot(t,soundIn);  
% xlim([0 45]);
% ylim([-5 5]);
% xlabel('time (s)');
% ylabel('amptitude');
% set (gcf,'Position',[400,100,900,400])
% hold on
% for i = 1:pulseNum*2
% %     plot([pointLoc(i) pointLoc(i)],[1 -1],'r');
%     
%     if ((mod(i,2) == 0) && (i/2>=22) && (i/2 <= 39))
%         bar((pointLoc(i)-1000)/2000,1,1);
%     end
% 
% end
% 
% hold off
% subplot(2,1,1);plot(t,cuffInterp);
% xlim([0 45]);
% ylabel('cuff pressure(mmHg)');

%% -------plot for figure 7 Results
% results = xlsread('deepLearnResult_v3.xls','results');
sbpnum = 1:2:20;
dbpnum = 2:2:20;
sbpL  = results(3,sbpnum);
dbpL  = results(3,dbpnum);
sbpSL = results(4,sbpnum);
dbpSL = results(4,dbpnum);

sbpM  = results(7,sbpnum);
dbpM  = results(7,dbpnum);
sbpSM = results(8,sbpnum);
dbpSM = results(8,dbpnum);

sbpF  = results(11,sbpnum);
dbpF  = results(11,dbpnum);
sbpSF = results(12,sbpnum);
dbpSF = results(12,dbpnum);
%% ----


