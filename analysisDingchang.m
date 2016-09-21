% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: analyais data from Dingchang
% //
% //  Aaron
% //  YF Inc.
% //  Sep 19 2016
% //  Built with MATLAB
% //******************************************************************************

data = csvread('D:\BaiduYunDownload\Data for Panfan\004\004A2.csv');

cuffPressure   = data(:,1);     % cuff pressure
sound          = data(:,6);     % microphone
% ecg            = data(:,4);     % ECG
sr             = 2000;          % sample rate

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
soundIn = sound(tRange);  % 取出40mmHg-150mmHg范围内的soundIn
v_T_Ft = v_T_Ft;                % v_T_Ft保存每个袖带压力波起点位置
subplot(2,1,1);plot(cuffFit);
subplot(2,1,2);plot(soundIn);

for i=1:length(v_T_Ft)-1
    wavDif(i) =  v_T_Ft(i+1) - v_T_Ft(i);
end
location = find(wavDif>=3800|wavDif<1000);  % 根据压力波起点之间的差，找出错误的
v_T_Ft(location+1) = [];                    % remove掉错误起始点
hold on
plot(v_T_Ft,ones(1,33),'+');
hold off
% subplot(2,1,1);plot(wavDif);
% subplot(2,1,2);plot(cuffPr);
%% ---- save plus wave
waveLocation = [];
impath = '..\pluseImage\';
for i=1:length(v_T_Ft)-2
    Lstart = v_T_Ft(i+1)-800; Lend = v_T_Ft(i+1)+1199;
    waveLocation = [waveLocation Lstart Lend];
    plusWaveIn =  soundIn(Lstart : Lend)';   %第一个波不要
    imageTin = audioSpecImage( plusWaveIn,2000,128, 112, 0); %怎么实现imagesc的数据缩放

    maxV = max(max(imageTin));minV = min(min(imageTin));    % for sound In
    imageGray = uint8(round(((imageTin-minV)./(maxV-minV))*255));
    imageGray = flipud(imageGray);
    imwrite(imageGray,['D:\DPTest\yupu\pluseImage_v3\' num2str(i) '_IN.bmp']);
end
