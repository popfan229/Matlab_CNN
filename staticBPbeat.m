% 统计 sbp/dbp beat 差异分布
% sbp = bp(:,1);
% dbp = bp(:,2);


% tabS = tabulate(sbp);
% tabD = tabulate(dbp);

% reslut = zeros(417,2);
% for i = 1:417
%     [L,J,V]=find(beat(i,:)==1);
%     if(isempty(J))
%         continue;
%     end
%     reslut(i,:) = [J(1) J(end)];
% 
% end

% for f=1:10
%     sbpT = [];
%     dbpT = [];
%     for i = 1:42
%         fileid = (f-1)*42+i;
%         sbpT = [sbpT sbp(fileid)];
%         dbpT = [dbpT dbp(fileid)];
%     end
%     tabS = tabulate(sbpT)
%     tabD = tabulate(dbpT)
% end

%------------------ 统计分类精度
%-------- 2014-01-21
% alldata = xlsread('E:\Deep Learning\2016-01 Deep Learning\CNN\Matlab_CNN\CNNresult_org.xls','all');
% refBP = xlsread('E:\Deep Learning\2016-01 Deep Learning\CNN\Matlab_CNN\refBPnumber.xls','Sheet1');
% beatsNum = xlsread('E:\Deep Learning\2016-01 Deep Learning\CNN\Matlab_CNN\WaveLocation_v2_417.xls');
manSBP = refBP(:,2);
manDBP = refBP(:,3);
bNum = beatsNum(:,2);

result = zeros(10,16);
nanNum = 0;

for f=1:10
    for i = 1:42
        fileid = (f-1)*42+i;
        cowS = manSBP(fileid);
        cowD = manDBP(fileid);
        if(isnan(cowS))
            nanNum = nanNum+1;
            result(f,4) = result(f,4) +1;
            result(f,12) = result(f,12) +1;
            continue;
        end
        if((cowS-1)<=0)
            continue;
        end
        if((cowS-2)<=0)
            continue;
        end
        if((cowS-3)<=0)
            continue;
        end

        result(f,1) = result(f,1) + alldata(fileid,cowS-3);
        result(f,2) = result(f,2) + alldata(fileid,cowS-2);
        result(f,3) = result(f,3) + alldata(fileid,cowS-1);
        result(f,4) = result(f,4) + alldata(fileid,cowS);
        result(f,5) = result(f,5) + alldata(fileid,cowS+1);
        result(f,6) = result(f,6) + alldata(fileid,cowS+2);
        result(f,7) = result(f,7) + alldata(fileid,cowS+3);
        
        result(f,8) = result(f,8) + alldata(fileid,cowD-4);
        result(f,9) = result(f,9) + alldata(fileid,cowD-3);
        result(f,10) = result(f,10) + alldata(fileid,cowD-2);
        result(f,11) = result(f,11) + alldata(fileid,cowD-1);
        result(f,12) = result(f,12) + alldata(fileid,cowD);
        result(f,13) = result(f,13) + alldata(fileid,cowD+1);
        result(f,14) = result(f,14) + alldata(fileid,cowD+2);
        result(f,15) = result(f,15) + alldata(fileid,cowD+3);
        result(f,16) = result(f,16) + alldata(fileid,cowD+4);
    end
end

% for f=1:10
%     for i = 1:42
%         fileid = (f-1)*42+i;
%         cowS = manSBP(fileid);
%         cowD = manDBP(fileid);
%         if(isnan(cowS))
%             nanNum = nanNum+1;
%             continue;
%         end
%         if((cowS-1)<=0)
%             continue;
%         end
%         if((cowS-2)<=0)
%             continue;
%         end
%         if((cowS-3)<=0)
%             continue;
%         end
% 
%         result(f,1) = result(f,1) + alldata(fileid,cowS-3);
%         result(f,2) = result(f,2) + alldata(fileid,cowD+4);
%         if(alldata(fileid,cowD+4)==3)
%             a=1;
%         end
%     end
% end


