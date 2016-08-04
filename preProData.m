function [ cuffPressureDownFilterReshape,  soundUnderCuffDownReshape, soundOutCuffDownReshape, ...
    cuffPressureDownFilter, soundUnderCuffDown, soundOutCuffDown] = preProData( data, plotFlag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cuffPressure             = (data(:,1)-1)*100;       %  cuff pressure        
soundUnderCuff      = data(:,2);                     %  sound under the cuff
soundOutCuff          = data(:,3);                    %   sound outside the cuff

cuffPressureDown        = downsample(cuffPressure, 2);
soundUnderCuffDown = resample(soundUnderCuff, 1000, 2000);
soundOutCuffDown     = resample(soundOutCuff, 1000, 2000);

%----- process cuffPressure
[v_T_Ft tRange] = SegmentOP(cuffPressureDown, 1000,cuffPressureDown);
cuffFit = cuffPressureDown(tRange);
cuffFitAva = cuffFit(v_T_Ft);
Xi = 0:1:length(cuffFit)-1;
cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear');

cuffPressureDownFilter = cuffInterp;
soundUnderCuffDown  = soundUnderCuffDown(tRange);
soundOutCuffDown     = soundOutCuffDown(tRange);
cuffPressureDown        = cuffPressureDown(tRange);

%------ end of process cuffPressure
cuffPressureMax = 150;  % max @ 150mmHg
cuffPressureMin = 40;     % min @ 40mmHg
[a,indMax]=find(cuffPressureDownFilter==max(cuffPressureDownFilter(find(cuffPressureDownFilter<cuffPressureMax))))
[b,indMin]=find(cuffPressureDownFilter==min(cuffPressureDownFilter(find(cuffPressureDownFilter>cuffPressureMin))))

cuffPressureDown            =  cuffPressureDown(indMax:indMin)';
cuffPressureDownFilter    =  cuffPressureDownFilter(indMax:indMin)';
soundUnderCuffDown     =  soundUnderCuffDown(indMax:indMin);
soundOutCuffDown        =  soundOutCuffDown(indMax:indMin);

if plotFlag==1
    plot(cuffPressureDown);
    hold on
    plot(cuffPressureDownFilter,'r');
    plot(soundUnderCuffDown,'r');
    plot(soundOutCuffDown,'b');
    hold off
end

row = 200;
col  = fix(length(cuffPressureDownFilter)/200);

cuffPressureDownFilter    =  cuffPressureDownFilter(1:row*col)';
soundUnderCuffDown     =  soundUnderCuffDown(1:row*col);
soundOutCuffDown        =  soundOutCuffDown(1:row*col);
%
cuffPressureDownFilterReshape = reshape(cuffPressureDownFilter, row, col)';     % 200*219 matrix
cuffPressureDownFilterReshape(2:2:end,:) = cuffPressureDownFilterReshape(2:2:end,end:-1:1);   % make connect from head to tail
%
soundUnderCuffDownReshape = reshape(soundUnderCuffDown, row, col)';     % 200*219 matrix
soundUnderCuffDownReshape(2:2:end,:) = soundUnderCuffDownReshape(2:2:end,end:-1:1);   % make connect from head to tail
%
soundOutCuffDownReshape = reshape(soundOutCuffDown, row, col)';     % 200*219 matrix
soundOutCuffDownReshape(2:2:end,:) = soundOutCuffDownReshape(2:2:end,end:-1:1);   % make connect from head to tail

end

