% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: 统计分析分类结果，并绘图
% //
% //  Aaron
% //  YF Inc.
% //  Aug 30 2016
% //  Built with MATLAB
% //******************************************************************************


% bpdiff = 0;
number1 = 0;
number2 = 0;
number3 = 0;
number4 = 0;
number5 = 0;
number6 = 0;
number7 = 0;
number8 = 0;

for i = 1:length(bpdiff(:,1))
    if (bpdiff(i,1)>=0 && bpdiff(i,1)<=2) 
        number1 = number1+1;
    elseif (bpdiff(i,1)>2 && bpdiff(i,1)<=4)
        number2 = number2+1;
    elseif (bpdiff(i,1)>4 && bpdiff(i,1)<=6)
        number3 = number3+1;
    elseif (bpdiff(i,1)>6) 
        number4 = number4+1;
    elseif (bpdiff(i,1)<0 && bpdiff(i,1)>=-2) 
        number5 = number5+1;
    elseif (bpdiff(i,1)<-2 && bpdiff(i,1)>=-4) 
        number6 = number6+1;
    elseif (bpdiff(i,1)<-4 && bpdiff(i,1)>=-6) 
        number7 = number7+1;
    elseif (bpdiff(i,1)<-6) 
        number8 = number8+1;
    end

end
allnumber = number1+number2+number3+number4+number5+number6+number7+number8
alldata = [number4 number3 number2 number1 number5 number6 number7 number8];
alldata = alldata./90;
x = [-7 -5 -3 -1 1 3 5 7]
bar(x, alldata)