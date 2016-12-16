data = csvread('..\RawDataRename_v2\2.csv');
cuffPressure = data(:,1);     % cuff pressure
korSound     = data(:,6);     % microphone
sr = 2000;                      % sample rate
Fs = 2000;
%% ----- Process cuffPressure
cuffPressure     = (cuffPressure-1)*100;

[v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure);

cuffFit = cuffPressure(tRange); % 找出40mmHg-150mmHg范围
cuffFitAva = cuffFit(v_T_Ft);   % 找出cuff基线
Xi = 0:1:length(cuffFit)-1;
cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear'); % 插值成原来长度
cuffPr = cuffFit-cuffInterp';   % 减去基线的到单纯压力波波形

z=find(~isnan(cuffPr));
cp=cuffPr(z);
% cp = cuffFit;
% cp = cuffPr;
n      = 6; Wn = 20/Fs/2;
[b, a] = butter(n, Wn);
xL     = filtfilt(b, a, cp);
Wn     = 0.5/Fs/2;
[d, c] = butter(4, Wn, 'high');
x      = filtfilt(d, c, xL);

v_T_Ft = v_T_Ft-1116;
figure(2)
plot(v_T_Ft,x(v_T_Ft),'*' );
P=polyfit(v_T_Ft,x(v_T_Ft),20);
xi=0:length(x)-1;  
yi=polyval(P,xi);
hold on
plot(xi,yi);  
plot(x,'r');
hold off

figure(3)
plot(x-yi');

figure(4)
subplot(211);
hold on
plot(xi,yi,'r');  
plot(x);
plot(v_T_Ft,x(v_T_Ft),'or' );
hold off
subplot(212);plot(x-yi');

filterSignal = x-yi';


plot(diff(x,1)*10)
hold on
plot(x,'r')