function [ cuffInterp,soundIn,soundOut ] = datasegment( data )
    cuffPressure   = data(:,1);     % cuff pressure
    soundInCuff    = data(:,2);     % microphone
    soundOutCuff   = data(:,3);     % brath

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


end

