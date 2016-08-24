imagepath = 'results\yes3\';
imagefiles = dir([ imagepath '*.bmp']);
yesfileno = length(imagefiles);

resultsOut = zeros(270,15);
resultsIn = zeros(270,15);

for fi=1:yesfileno
    filename = imagefiles(fi).name;
    loca = strfind(filename,'_');
    fileID = str2num(filename(1:loca(1)-1));
    pulseNum = str2num(filename(loca(1)+1:loca(2)-1));
    type = (filename(loca(2)+1:loca(3)-1));
    if strcmp(type,'out')
        resultsOut(fileID,1) = fileID;
        resultsOut(fileID,2) = resultsOut(fileID,2)+1;
        cow = resultsOut(fileID,2)+2;
        resultsOut(fileID,cow) = pulseNum;
    else
        resultsIn(fileID,1) = fileID;
        resultsIn(fileID,2) = resultsIn(fileID,2)+1;
        cow = resultsIn(fileID,2)+2;
        resultsIn(fileID,cow) = pulseNum;
    end
    

%     pulseNums = [pulseNums pulseNum]
     csvwrite('fulseResultIn.xls', resultsIn); 
     csvwrite('fulseResultOut.xls', resultsOut);
%     fileID = fileID+1;
    
end