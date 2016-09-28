%%%%%%%%% 把你的 imgtrain 和 imgtest
%%%%%%%%% 放在当前m文件所在的“全部”目录下，results中生成的文件名中就包含分类结果，"_X.bmp'中X即为分类结果
clc;
clear all;
tic
width = 116;
height = 64;

model = 'D:\DPTest\yupu\Classification_Model_test\cifar10_full_relu_deploy.prototxt';
% model = 'cifar10_full_sigmoid_deploy.prototxt';

weights ='D:\DPTest\yupu\Classification_Model_test\model\PF_cifar10_full_relu_mulstep_0915_iter_300000.caffemodel';
% weights ='model\PF_cifar10_full_relu_mulstep_0912_iter_200000.caffemodel';
% weights ='model\PF_cifar10_full_0912_iter_200000.caffemodel';
% weights ='PF_cifar10_full_0910_iter_100000.caffemodel';
caffe.set_mode_gpu();
net = caffe.Net(model, weights, 'test');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 测试 Yes %%%%%%%%%%%%%%%%%%%%
result = 3*ones(417,85);    %保存pulse类型结果
FOLDER = '1';
imagepath = ['..\dpimage_v2\' FOLDER '\test\'];
% imagepath = 'D:\DPTest\yupu\pulseImage_v20\';
imagefiles = dir([ imagepath '*.bmp']);
yesfileno = length(imagefiles);
yes_number = 0;
yes_labels=zeros(yesfileno,1,'uint8');

if ~exist('results','dir')
    mkdir('results');
end

for fi=1:yesfileno
    filename = imagefiles(fi).name;
    loca = strfind(filename,'_');
    fileID = str2num(filename(1:loca-1));
    pulseNum = str2num(filename(loca+1:end-4));
    
    imfile = [imagepath imagefiles(fi).name];    
    im = imread(imfile);
    image = double(im');
    data(:,:,1,1)=0.00390625*image;
    %data(:,:,1,1)=image;
    net.forward({data});
    caffe_ft = net.blobs('ip1').get_data();
    label = abs(caffe_ft(1))<=abs(caffe_ft(2));
    yes_labels(fi,1)=label;
    if label   % 是柯氏音（label=1）
        yes_number = yes_number + 1;
    end
    
    result(fileID,pulseNum) = label;    %保存pulse结果
    
    disp([num2str(fi) '/' num2str(yesfileno) ' ' num2str(caffe_ft(1)) ' ' num2str(caffe_ft(2)) ' KF 当前准确率 ' num2str(yes_number/fi)]);
    writepath = ['results\' FOLDER '\'];    %改成foler地址
    if ~exist(writepath,'dir')
        mkdir(writepath);
    end
    imwrite(im,[writepath '\' strrep(imagefiles(fi).name,'.bmp', ['_' num2str(label) '.bmp'])]);
    
end

xlswrite('CNNresult.xls', result, FOLDER);
disp(['']);
disp([ 'KF 正确率 ' num2str(yes_number/yesfileno)]);


