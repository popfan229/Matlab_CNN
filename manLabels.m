% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: 手动标注分类柯氏音
% //
% //  Aaron
% //  YF Inc.
% //  Sep 26 2016
% //  Built with MATLAB
% //******************************************************************************

% pluseLocation = xlsread('WaveLocation_v2_417.xls');
% referenceBP = xlsread('deepLearnResult_v3.xls');

for fileID = 234:417
    
        fileNam   = [num2str(fileID) '.csv'];
        pathAll = ['..\RawDataRename_v2\' fileNam];
        data = csvread(pathAll);

        cuffPressure   = data(:,1);     % cuff pressure
        soundOutCuff   = data(:,6);     % brath
        sr = 2000;                      % sample rate
        % ----- End of load data 
       %% ----- Process cuffPressure
        cuffPressure     = (cuffPressure-1)*100;
        [v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure); 
        soundOut = soundOutCuff(tRange);% 取出40mmHg-150mmHg范围内的soundOut 
        cuffFit = cuffPressure(tRange); % 找出40mmHg-150mmHg范围
        cuffFitAva = cuffFit(v_T_Ft);   % 找出cuff基线
        Xi = 0:1:length(cuffFit)-1;
        cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear'); % 插值成原来长度
        % ----- End of process cuffPressure

        %% ----- plot image & analysis
        fileRow = fileID;
        pluseNum = 2*pluseLocation(fileRow,2);
        pluseLocationY = 3*ones(1,pluseNum);
        pluseLo = pluseLocation(fileRow,3:(pluseNum+2));
        refsbp = referenceBP(fileID,3);
        refdbp = referenceBP(fileID,4);
        if(refsbp>=150)
            continue;
        end
        [bpV1,bpL1] = find(cuffInterp>refsbp);
        [bpV2,bpL2] = find(cuffInterp>refdbp);
        bpL1 = max(bpL1);
        bpL2 = max(bpL2);
        
        figureHandle = figure(1);   % plot figure 2
        set(figureHandle,'Position',[100,200,2400,800], 'color','w')
        
        plot(soundOut,'k');
        hold on
        stem(pluseLo,pluseLocationY,'Marker','none');
        stem([bpL1 bpL2],[2 2]);
        title(fileID);
        [x,y] = ginput(2);  % get position
        [V1,L1] = find(pluseLo>x(1));
        [V2,L2] = find(pluseLo>x(2));
        L1 = min(L1);
        L2 = min(L2);
        aa = [pluseLo(L1) pluseLo(L1-1) pluseLo(L2) pluseLo(L2-1)];
        stem(aa, [3 3 3 3]);
        hold off
        
        sbpnum = L1/2;
        dbpnum = L2/2;
        
        pluseNum = [fileID sbpnum dbpnum];
        xlswrite('refBPnumber.xls', pluseNum,1, ['A' num2str(fileRow+1)]);
        
  
    
    
    
    
end