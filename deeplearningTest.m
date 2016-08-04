% result = xlsread('D:\NCL Data\2013-04 Effect of position on BP\Data Analysis\2016-01 Deep Learning\TrueDataAll.xls');
savePath = ['E:\Project\2016-01 Deep Learning\AnalysisData2\'];
row = 0;
subRealNum = [1 2 3 4 5 6 7 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 31 32 33];


for subNum = subRealNum
    for preNum = 1:3
        for repNum = 1:3
            
     
            
            pathNam = num2str(subRealNum(subNum));
            fileNam   = [num2str(preNum) '_R'  num2str(repNum) '.csv'];
            if subRealNum(subNum) < 10
                pathAll    = ['.\00' pathNam '\' fileNam]
            else
                pathAll    = ['.\0' pathNam '\' fileNam]
            end

            data = csvread(pathAll);

            [cuffPressureShape, soundUnderCuffShape, soundOutCuffShape, ...
                cuffPressure, soundUnderCuff, soundOutCuff] = preProData(data, 0);

            column = 2+(repNum-1)*2+(preNum-1)*6;
            DBPin   = result(3+subNum, column);
            SBPin   = result(38+subNum, column);
            DBPout = result(3+subNum, column+1);
            SBPout = result(38+subNum, column+1);
            BP = [DBPin SBPin DBPout SBPout];
            row = row+1;
            
            saveFileNam   = [num2str(preNum) '_R'  num2str(repNum)];
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_Pres.csv'], cuffPressureShape);
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_In.csv'], soundUnderCuffShape);
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_Out.csv'], soundOutCuffShape);
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_BP.csv'], BP);


        end
    end
end

