% data = csvread('..\RawDataRename\1.csv');
% wavelocation = xlsread('..\BPresult\WaveLocation.xls');

cuffPressure   = data(:,1);     % cuff pressure
soundInCuff    = data(:,2);     % microphone
soundOutCuff   = data(:,3);     % brath
sr = 2000;                      % sample rate
% ----- End of load data 

%% ----- Process cuffPressure
cuffPressure     = (cuffPressure-1)*100;
[v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure); 
soundIn = soundInCuff(tRange);  % 取出40mmHg-150mmHg范围内的soundIn
soundOut = soundOutCuff(tRange);% 取出40mmHg-150mmHg范围内的soundOut
%% ---

pulseNumber = wavelocation(1,2);
for i = 1:pulseNumber
    start = wavelocation(1,i*2+1);
    last = wavelocation(1,i*2+2);
    pulse = soundIn(start:last);
    spectrogram(pulse,hamming(128),112,128,2000,'yaxis'); 
    axis off;
    colorbar('off');
    set(gcf,'position',[100,100,138,108]);
    f = getframe(gcf);
    f.cdata = imcrop(f.cdata,[25,10,113,76]);
    imwrite(f.cdata,'a.bmp')
end


