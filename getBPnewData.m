% read BP values from xls for new 100 subject
bpdata = [];
height = [];
for fileID = 1:100
    file = num2str(fileID);
    if fileID<10
        sheet = ['00' file]
    elseif (fileID>=10)&&(fileID<100)
        sheet = ['0' file]
    else
        sheet = file
    end

    [ndata,text,alldata]=xlsread('Clinical Information 100+subjects.xls',sheet);
    bpdata = [bpdata; ndata(8,:)']
    height(fileID) = ndata(1,1);
    weight(fileID) = ndata(2,1);
    armcir(fileID) = ndata(3,1);
    age(fileID) = ndata(4,2);
    gender(fileID) = text(6,2);
end
sbpstep = 1:2:length(bpdata);
dbpstep = 2:2:length(bpdata);
sbp = bpdata(sbpstep);
dbp = bpdata(dbpstep);
height = height';
weight = weight';
armcir = armcir';
age = age';
gender = gender';
