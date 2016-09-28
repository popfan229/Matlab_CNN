%%%%%%%%% ����� imgtrain �� imgtest
%%%%%%%%% ���ڵ�ǰm�ļ����ڵġ�ȫ����Ŀ¼�£�results�����ɵ��ļ����оͰ�����������"_X.bmp'��X��Ϊ������
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ���� Yes %%%%%%%%%%%%%%%%%%%%
result = 3*ones(417,85);    %����pulse���ͽ��
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
    if label   % �ǿ�������label=1��
        yes_number = yes_number + 1;
    end
    
    result(fileID,pulseNum) = label;    %����pulse���
    
    disp([num2str(fi) '/' num2str(yesfileno) ' ' num2str(caffe_ft(1)) ' ' num2str(caffe_ft(2)) ' KF ��ǰ׼ȷ�� ' num2str(yes_number/fi)]);
    writepath = ['results\' FOLDER '\'];    %�ĳ�foler��ַ
    if ~exist(writepath,'dir')
        mkdir(writepath);
    end
    imwrite(im,[writepath '\' strrep(imagefiles(fi).name,'.bmp', ['_' num2str(label) '.bmp'])]);
    
end

xlswrite('CNNresult.xls', result, FOLDER);
disp(['']);
disp([ 'KF ��ȷ�� ' num2str(yes_number/yesfileno)]);


