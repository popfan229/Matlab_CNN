% read BP values from xls for new 100 subject
bpdata = [];
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
end
sbpstep = 1:2:length(bpdata);
dbpstep = 2:2:length(bpdata);
sbp = bpdata(sbpstep);
dbp = bpdata(dbpstep);
