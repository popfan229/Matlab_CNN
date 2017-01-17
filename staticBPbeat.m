% 统计 sbp/dbp beat 差异分布
sbp = bp(:,1);
dbp = bp(:,2);


tab1 = tabulate(dbp)
hist(dbp)

% reslut = zeros(417,2);
% for i = 1:417
%     [L,J,V]=find(beat(i,:)==1);
%     if(isempty(J))
%         continue;
%     end
%     reslut(i,:) = [J(1) J(end)];
% 
% end