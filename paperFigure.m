% //  Description: 论文绘图
% //
% //  Aaron
% //  YF Inc.
% //  Sep 3 2016
% //  Built with MATLAB
% //******************************************************************************
% 
% data = csvread('..\RawDataRename\6.csv');
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
% fileID = 6;
% pulseCounter = 23;
% waveloc = xlsread('WaveLocation.xls');
% %---- korotkoff beat
% start = waveloc(fileID,pulseCounter*2+1);
% last  = waveloc(fileID,pulseCounter*2+2);
% pulseWaveIn  = soundIn(start : last)';
% imageTin = audioSpecImage( pulseWaveIn,2000,128, 112, 0); %怎么实现imagesc的数据缩放
% maxVin = max(max(imageTin));minVin = min(min(imageTin));    % for sound In
% imageGrayin = uint8(round(((imageTin-minVin)./(maxVin-minVin))*255));
% imageGrayin = flipud(imageGrayin);
% t = [1/2000:1/2000:length(pulseWaveIn)/2000]; % Fs = 2000Hz
% subplot(2,2,1);plot(t,pulseWaveIn);
% subplot(2,2,3);imshow(imageGrayin);axis on
% %---- non-korotkoff beat
% pulseCounter = 1;
% start = waveloc(fileID,pulseCounter*2+1);
% last  = waveloc(fileID,pulseCounter*2+2);
% pulseWaveIn  = soundIn(start : last)';
% imageTin = audioSpecImage( pulseWaveIn,2000,128, 112, 0); %怎么实现imagesc的数据缩放
% maxVin = max(max(imageTin));minVin = min(min(imageTin));    % for sound In
% imageGrayin = uint8(round(((imageTin-minVin)./(maxVin-minVin))*255));
% imageGrayin = flipud(imageGrayin);
% t = [1/2000:1/2000:length(pulseWaveIn)/2000]; % Fs = 2000Hz
% subplot(2,2,2);plot(t,pulseWaveIn);
% subplot(2,2,4);imshow(imageGrayin);axis on

% 
% %% ---- plot figure 4
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
% ylabel('Korotkoff sound');
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
% ylabel('Cuff pressure(mmHg)');

%% -------plot for figure 7 Results
% results = xlsread('deepLearnResult_v3.xls','results');
% sbpnum = 1:2:20;
% dbpnum = 2:2:20;
% sbpL  = results(3,sbpnum);
% dbpL  = results(3,dbpnum);
% sbpSL = results(4,sbpnum);
% dbpSL = results(4,dbpnum);
% 
% sbpM  = results(7,sbpnum);
% dbpM  = results(7,dbpnum);
% sbpSM = results(8,sbpnum);
% dbpSM = results(8,dbpnum);
% 
% sbpF  = results(11,sbpnum);
% dbpF  = results(11,dbpnum);
% sbpSF = results(12,sbpnum);
% dbpSF = results(12,dbpnum);
%% ---- plot figure 7
% results = xlsread('deepLearnResult_v3.xls','Analysis');
% sbpDiff = results(:,7);
% dbpDiff = results(:,8);
% 
% m = sbpDiff;
% a(8) = numel(m(m<=0&m>=-2));
% a(7) = numel(m(m<-2&m>=-4));
% a(6) = numel(m(m<-4&m>=-6));
% a(5) = numel(m(m<-6&m>=-8));
% a(4) = numel(m(m<-8&m>=-10));
% a(3) = numel(m(m<-10&m>=-12));
% a(2) = numel(m(m<-12&m>=-14));
% a(1) = numel(m(m<-14&m>=-16));
% 
% a(9) = numel(m(m>=0&m<=2));
% a(10) = numel(m(m>2&m<=4));
% a(11) = numel(m(m>4&m<=6));
% a(12) = numel(m(m>6&m<=8));
% a(13) = numel(m(m>8&m<=10));
% a(14) = numel(m(m>10&m<=12));
% a(15) = numel(m(m>12&m<=14));
% a(16) = numel(m(m>14&m<=16));
% 
% m = dbpDiff;
% b(8) = numel(m(m<=0&m>=-2));
% b(7) = numel(m(m<-2&m>=-4));
% b(6) = numel(m(m<-4&m>=-6));
% b(5) = numel(m(m<-6&m>=-8));
% b(4) = numel(m(m<-8&m>=-10));
% b(3) = numel(m(m<-10&m>=-12));
% b(2) = numel(m(m<-12&m>=-14));
% b(1) = numel(m(m<-14&m>=-16));
% 
% b(9) = numel(m(m>=0&m<=2));
% b(10) = numel(m(m>2&m<=4));
% b(11) = numel(m(m>4&m<=6));
% b(12) = numel(m(m>6&m<=8));
% b(13) = numel(m(m>8&m<=10));
% b(14) = numel(m(m>10&m<=12));
% b(15) = numel(m(m>12&m<=14));
% b(16) = numel(m(m>14&m<=16));
% 
% a=(a'./402)*100;
% b=(b'./402)*100;

%% ---- plot figure 7-2
% results = xlsread('deepLearnResult_v3.xls','Analysis');
% sbpDiff = results(:,7);
% dbpDiff = results(:,8);
% 
% m = sbpDiff;
% a(8) = numel(m(m<=1&m>=-1));
% a(7) = numel(m(m<-1&m>=-3));
% a(6) = numel(m(m<-4&m>=-5));
% a(5) = numel(m(m<-5&m>=-7));
% a(4) = numel(m(m<-7&m>=-9));
% a(3) = numel(m(m<-9&m>=-11));
% a(2) = numel(m(m<-11&m>=-13));
% a(1) = numel(m(m<-13&m>=-15));
% 
% a(9) = numel(m(m>=1&m<=3));
% a(10) = numel(m(m>3&m<=5));
% a(11) = numel(m(m>5&m<=7));
% a(12) = numel(m(m>7&m<=9));
% a(13) = numel(m(m>9&m<=11));
% a(14) = numel(m(m>11&m<=13));
% a(15) = numel(m(m>13&m<=15));
% 
% m = dbpDiff;
% b(8) = numel(m(m<=1&m>=-1));
% b(7) = numel(m(m<-1&m>=-3));
% b(6) = numel(m(m<-4&m>=-5));
% b(5) = numel(m(m<-5&m>=-7));
% b(4) = numel(m(m<-7&m>=-9));
% b(3) = numel(m(m<-9&m>=-11));
% b(2) = numel(m(m<-11&m>=-13));
% b(1) = numel(m(m<-13&m>=-15));
% 
% b(9) = numel(m(m>=1&m<=3));
% b(10) = numel(m(m>3&m<=5));
% b(11) = numel(m(m>5&m<=7));
% b(12) = numel(m(m>7&m<=9));
% b(13) = numel(m(m>9&m<=11));
% b(14) = numel(m(m>11&m<=13));
% b(15) = numel(m(m>13&m<=15));
% 
% a=(a'./402)*100;
% b=(b'./402)*100;

%% ------ 激活函数绘图
x = -20:0.1:20;
sigmiod = 1./(1+exp(-x));
tanh = (exp(x) - exp(-x))./(exp(x) + exp(-x));
relu = [zeros(1,200) 0:0.1:20];
subplot(1,3,1);plot(x,sigmiod);xlabel('Sigmoid');grid on;
subplot(1,3,2);plot(x,tanh);xlabel('Tanh');grid on;
subplot(1,3,3);plot(x,relu);xlabel('Relu');grid on;


%%


