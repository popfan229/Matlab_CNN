function [ cuffInterp,soundIn,soundOut ] = datasegment( data )
    cuffPressure   = data(:,1);     % cuff pressure
    soundInCuff    = data(:,2);     % microphone
    soundOutCuff   = data(:,3);     % brath

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


end

