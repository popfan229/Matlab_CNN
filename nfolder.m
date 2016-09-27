% //******************************************************************************
% //  BP measurement using CNN
% //
% //  Description: n folder ·ÖÀà
% //
% //  Aaron
% //  YF Inc.
% //  Sep 27 2016
% //  Built with MATLAB
% //******************************************************************************

yesimagepath = '..\dpimage_v2\yes\';
noimagepath = '..\dpimage_v2\no\';
yesimagefiles = dir([ yesimagepath '*.bmp']);
noimagefiles = dir([ noimagepath '*.bmp']);
yesfileno = length(yesimagefiles);
nofileno = length(noimagefiles);

groupTest = 1:42;    % subject 1:14;

for groupNum = 1:10
    groupNum
    for fi = 1:yesfileno

        filename = yesimagefiles(fi).name;
        loca = strfind(filename,'_');
        fileID = str2num(filename(1:loca-1));

        sourcePath = [yesimagepath filename];
        destTestPath   = ['..\dpimage_v2\' num2str(groupNum) '\test\yes\'];
        destTrainPath   = ['..\dpimage_v2\' num2str(groupNum) '\train\yes\'];
        if(sum(fileID == groupTest)>=1)
             copyfile(sourcePath, destTestPath);
        else
             copyfile(sourcePath, destTrainPath);
        end
    end
    %%---- no file 
    for fi = 1:nofileno

        filename = noimagefiles(fi).name;
        loca = strfind(filename,'_');
        fileID = str2num(filename(1:loca-1));

        sourcePath = [noimagepath filename];
        destTestPath   = ['..\dpimage_v2\' num2str(groupNum) '\test\no\'];
        destTrainPath   = ['..\dpimage_v2\' num2str(groupNum) '\train\no\'];
        if(sum(fileID == groupTest)>=1)
             copyfile(sourcePath, destTestPath);
        else
             copyfile(sourcePath, destTrainPath);
        end
    end
    groupTest = groupTest+42;
end