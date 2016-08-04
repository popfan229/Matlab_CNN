% result = xlsread('D:\NCL Data\2013-04 Effect of position on BP\Data Analysis\2016-01 Deep Learning\TrueDataAll.xls');
savePath    = ['E:\Project\2016-01 Deep Learning\AnalysisData3\'];
SourcePath  = ['E:\Project\2016-01 Deep Learning\AnalysisData2\'];
row = 0;
% subRealNum = [1 2 3 4 5 6 7 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 31 32 33];
i = 1;

for loop = 1:20 % 20*200 = 4000 = 4s = 8-12mmHg
    
for subNum = 1:30
    for preNum = 1:3
        for repNum = 1:3
            
            if(subNum == 16)
                if repNum == 3
                    if preNum == 2
                        break;
                    end
                end
            end
            
            if(subNum == 29)
                if repNum == 2
                    if preNum == 3
                        break;
                    end
                end
            end
            
            saveFileNam   = [num2str(preNum) '_R'  num2str(repNum)];
            Pres = csvread([SourcePath num2str(subNum) '_' saveFileNam '_Pres.csv']);
            In   = csvread([SourcePath num2str(subNum) '_' saveFileNam '_In.csv']);
            Out  = csvread([SourcePath num2str(subNum) '_' saveFileNam '_Out.csv']);
            BP   = csvread([SourcePath num2str(subNum) '_' saveFileNam '_BP.csv']);
            %csvwrite([SourcePath num2str(subNum) '_' saveFileNam '_BP.csv'], BP);

            insertDataIn  = In(1:loop,:);
            insertDataOut = Out(1:loop,:);
            In(1:loop,:)  = [];
            Out(1:loop,:) = [];
            In  = [In;insertDataIn];
            Out = [Out;insertDataOut];
            BP = BP+0.5*loop; % 200 samples = 0.5mmHg
            
            
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_'  num2str(loop) '_Pres.csv'],Pres);
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_'  num2str(loop) '_In.csv'], In);
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_'  num2str(loop) '_Out.csv'], Out);
            csvwrite([savePath num2str(subNum) '_' saveFileNam '_'  num2str(loop) '_BP.csv'], BP);
            [m1(i),n1(i)]=size(Pres);
            
            
            %i=i+1
            loop = loop


        end
    end
end
end

