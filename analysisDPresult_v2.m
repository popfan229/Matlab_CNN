
% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: 统计分析分类结果，并转化为血压值保存结果到xls,针对2批数据
% //
% //  Aaron
% //  YF Inc.
% //  Aug 30 2016
% //  Built with MATLAB
% //******************************************************************************

clc
close all

imagepath = 'D:\DPTest\yupu\Classification_Model_test\results\yes\';
imagefiles = dir([ imagepath '*.bmp']);
fileno = length(imagefiles);

results = 6*ones(117,100);

for subno = 1:fileno
    filename = imagefiles(subno).name;
    loca = strfind(filename,'_');
    fileID = str2num(filename(1:loca(1)-1));
    pulseNum = str2num(filename(loca(1)+1:loca(2)-1));
    yesno = str2num(filename(loca(2)+1));
    
    results(fileID, pulseNum) = yesno; % cuff in results
    subno
end

xlswrite('dpResult_v2.xls', results,'A'); 


