
clc
clear all
close all



data     = load('H:\My Data\microphone array\Data\on body\2013-03-13\09_R3.csv');
cuff     = data(:,1);     % cuff pressure
cuff     = (cuff-1)*100;
soundUnderCuff    = data(:,4);     % microphone
soundOutCuff      = data(:,5);     % brath
% ecg      = data(:,2);     % ECG
% steo     = data(:,3);     % microphone
% brath    = data(:,5);     % brath
% steo3m   = data(:,6);     % 3M sound

Fs = 2000;
str = 'cuff';

[v_T_Ft t] = SegmentOP(cuff, Fs, cuff);

cuffFit = cuff(t);
cuffFitAva = cuffFit(v_T_Ft);

Xi = 0:1:length(cuffFit)-1;
cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear');


showPressure = [106.97	56.479	110.068	53.976...
;112.189	58.203	112.28	57.974...
;110.6998942	55.89900707	109.020852	57.41993813...
];


for j = 1:3
plot(cuffInterp,'r');
hold on 
plot(soundUnderCuff(t)+100);
plot(soundOutCuff(t)+100,'k');

i = zhidao_nearest(cuffInterp,showPressure(j,1));
plot([i i],[150 40],'C');
i = zhidao_nearest(cuffInterp,showPressure(j,2));
plot([i i],[150 40],'b');
i = zhidao_nearest(cuffInterp,showPressure(j,3));
plot([i i],[150 40],'r');
i = zhidao_nearest(cuffInterp,showPressure(j,4));
plot([i i],[150 40],'k');

pause;
close all

end
    
    


