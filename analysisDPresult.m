
% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: ͳ�Ʒ�������������ת��ΪѪѹֵ��������xls
% //
% //  Aaron
% //  YF Inc.
% //  Aug 30 2016
% //  Built with MATLAB
% //******************************************************************************

clc
close all

[a,yesResult] = xlsread('yesResult.xls');
[a,noResult] = xlsread('noResult.xls');
yesnum = length(yesResult);
nonum = length(noResult);

resultsOut = 9*ones(270,75);
resultsIn = 9*ones(270,75);

for subno = 1:yesnum
    filename = char(yesResult(subno));
    loca = strfind(filename,'_');
    fileID = str2num(filename(1:loca(1)-1));
    pulseNum = str2num(filename(loca(1)+1:loca(2)-1));
    type = (filename(loca(2)+1:loca(3)-5));
    yesno = str2num(filename(loca(3)+1));
    
    if strcmp(type,'in')
        resultsIn(fileID, pulseNum) = yesno; % cuff in results
    else
        resultsOut(fileID, pulseNum) = yesno; % cuff out results
    end    
end

for subno = 1:nonum
    filename = char(noResult(subno));
    loca = strfind(filename,'_');
    fileID = str2num(filename(1:loca(1)-1));
    pulseNum = str2num(filename(loca(1)+1:loca(2)-1));
    type = (filename(loca(2)+1:loca(3)-5));
    yesno = str2num(filename(loca(3)+1));
    yesno = abs(yesno-1);   % Ϊ�˺�KS�ź�ͳһ��noise�źŷ�תһ�£�1ΪKS�źţ�0Ϊnoise
    
    if strcmp(type,'in')
        resultsIn(fileID, pulseNum) = yesno; % cuff in results
    else
        resultsOut(fileID, pulseNum) = yesno; % cuff out results
    end    
end

xlswrite('dpResult.xls', resultsIn,'in'); 
xlswrite('dpResult.xls', resultsOut,'out');

resultsOut = xlsread('dpResult.xls','out');
resultsOut = xlsread('dpResult.xls','out');


