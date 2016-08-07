% //******************************************************************************
% //  MSP-FET430P140 Demo - Timer_A, Toggle P3.4, CCR0 Cont. Mode ISR, DCO SMCLK
% //
% //  Description: plus wave analysis, segment frame and plot specgram
% //
% //  Aaron
% //  YF Inc.
% //  Aug 2016
% //  Built with MATLAB
% //******************************************************************************

close all
% clear
clc
%% ----- Load data
% filePath = '001\1_R1.CSV';  % office
filePath = '..\..\RawData\001\1_R1.CSV';  % home
data = csvread(filePath);
% BPvalue = xlsread('TrueDataAll.xls');
        
cuffPressure      = data(:,1);     % cuff pressure
soundInCuff    = data(:,2);     % microphone
soundOutCuff      = data(:,3);     % brath
sr = 2000;
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

%% ---- cut plus wave
for i=1:length(v_T_Ft)-2
    plusWave(i,:) =  soundIn(v_T_Ft(i+1)-800:v_T_Ft(i+1)+1199)';   %第一个波不要
    imageT = audioSpecImage( plusWave(i,:),2000,128, 112, 1); %怎么实现imagesc的数据缩放
    maxV = max(max(imageT));minV = min(min(imageT));
    imageGray = uint8(round(((imageT-minV)./(maxV-minV))*255));
    imageGray = flipud(imageGray);
    imwrite(imageGray,['..\pluseImage\' num2str(i) '.bmp']);
%     imshow(imageGray);
%     subplot(2,1,1);audioSpecImage( plusWave(i,:),2000,128, 112);   %audioSpecImage( pluswave,sampleRate, widthFrame, overlap )
%     subplot(2,1,2);plot(plusWave(i,:));
    %     subplot(2,1,2);spectrogram(plusWave(i,:),hamming(128),112,256,2000,'yaxis'); 
%     figure(1)
%     imageT = audioSpecImage( plusWave(i,:),2000,128, 112); %怎么实现imagesc的数据缩放
%     maxV = max(max(imageT));minV = min(min(imageT));
%     imageTr = uint8(round(((imageT-minV)./(maxV-minV))*255));
%     figure(2)
%     imshow(imageTr);
%     imwrite(imageTr,'1.bmp');
end
% ----- End
%% ---- lable BP value on plus wave
repNum = str2num(filePath(8));
preNum = str2num(filePath(5));
subNum = str2num(filePath(1:3));

column = 2+(repNum-1)*2+(preNum-1)*6;
DBPin  = BPvalue(3+subNum, column);
SBPin  = BPvalue(38+subNum, column);
DBPout = BPvalue(3+subNum, column+1);
SBPout = BPvalue(38+subNum, column+1);
BP     = [DBPin SBPin DBPout SBPout];

Sin = find(cuffInterp<=SBPin);
Din = find(cuffInterp<=DBPin);
Sout = find(cuffInterp<=SBPout);
Dout = find(cuffInterp<=DBPout);

plot(soundIn);  % plot BP on the plus wave
hold on
plot([Sin(1) Sin(1)],[-5 5],'r');
plot([Din(1) Din(1)],[-5 5],'r');
hold off

figure()
plot(soundOut);  % plot BP on the plus wave
hold on
plot([Sout(1) Sout(1)],[-5 5],'r');
plot([Dout(1) Dout(1)],[-5 5],'r');
hold off


% x = largwave';
% s=length(x);
% w=round(80*sr/1000);                 %窗长，取离44*sr/1000最近的整数
% n=w;                                 %fft的点数
% ov=3*w/4;                            %75%的重叠
% h=w-ov;
% win=hamming(n)';
% c=1;
% ncols=1+fix((s-n)/h);                %fix函数是将(s-n)/h的小数舍去
% d=zeros((1+n/2),ncols);
% for b=0:h:(s-n)
%     u=win.*x((b+1):(b+n));
%     t=fft(u);
%     d(:,c)=t(1:(1+n/2))';
%     c=c+1;
% end
% tt=[0:h:(s-n)]/sr;
% ff=[0:(n/2)]*sr/n;
% imagesc(tt,ff/1000,20*log10(abs(d))); 
% % colormap('default');               %黑白度对应于信号的能量，声道的谐振频率在图上就表示成为黑带，浊音部分则以出现条纹为其特征，这是因为时域波形有周期性，而浊音的时间间隔内图形显得很致密
% colormap(gray);
% axis xy;
% xlabel('时间/s');
% ylabel('频率/kHz')     