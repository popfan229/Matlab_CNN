%%%%%%%%% ����� imgtrain �� imgtest
%%%%%%%%% ���ڵ�ǰm�ļ����ڵġ�ȫ����Ŀ¼�£�results�����ɵ��ļ����оͰ�����������"_X.bmp'��X��Ϊ������
clc;
clear all;
tic
width = 118;
height = 65;
model = 'cifar10_full_sigmoid_deploy.prototxt';
% weights = 'cifar10_full_sigmoid_iter_60000.caffemodel';
%weights = 'PF_cifar10_full_iter_130000.caffemodel';
%weights ='//192.168.1.188/g/Caffe/PF_Snapshot_mirror/PF_cifar10_full_iter_200000.caffemodel';
%weights ='//192.168.1.188/g/Caffe/PF_Snapshot/PF_cifar10_full_iter_200000.caffemodel';
weights ='PF_cifar10_full_iter_200000.caffemodel';
caffe.set_mode_cpu();
net = caffe.Net(model, weights, 'test');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ���� Yes %%%%%%%%%%%%%%%%%%%%
imagepath = '..\..\yes2\';
imagefiles = dir([ imagepath '*.bmp']);
yesfileno = length(imagefiles);
yes_number = 0;
yes_labels=zeros(yesfileno,1,'uint8');

if ~exist('results','dir')
    mkdir('results');
end

for fi=1:yesfileno
    imfile = [imagepath imagefiles(fi).name];
    im = imread(imfile);
    image = double(im');
    data(:,:,1,1)=0.00390625*image;
    %data(:,:,1,1)=image;
    net.forward({data});
    caffe_ft = net.blobs('ip1').get_data();
    label = abs(caffe_ft(1))<=abs(caffe_ft(2));
    yes_labels(fi,1)=label;
    if label
        yes_number = yes_number + 1;
    end   
    disp([num2str(fi) '/' num2str(yesfileno) ' ' num2str(caffe_ft(1)) ' ' num2str(caffe_ft(2)) ' yes ��ǰ׼ȷ�� ' num2str(yes_number/fi)]);
    writepath = 'results\yes3';
    if ~exist(writepath,'dir')
        mkdir(writepath);
    end
    if label==0
    imwrite(im,[writepath '\' strrep(imagefiles(fi).name,'.bmp', ['_' num2str(label) '.bmp'])]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ���� No %%%%%%%%%%%%%%%%%%%%
imagepath = '..\imgtest\no\';
imagefiles = dir([ imagepath '*.bmp']);
nofileno = length(imagefiles);
no_number = 0;
no_labels=zeros(nofileno,1,'uint8');
for fi=1:nofileno
    imfile = [imagepath imagefiles(fi).name];
    image = imread(imfile);
    image = double(image');
    data(:,:,1,1)=0.00390625*image;
    %data(:,:,1,1)=image;
    net.forward({data});
    caffe_ft = net.blobs('ip1').get_data();
    label = abs(caffe_ft(1))>=abs(caffe_ft(2));   
    no_labels(fi,1)=label;
    if label
        no_number = no_number + 1;
    end
%     disp([num2str(fi) '/' num2str(nofileno) ' ' num2str(caffe_ft(1)) ' ' num2str(caffe_ft(2)) ' no ��ǰ׼ȷ�� ' num2str(no_number/fi)]);
%     writepath = 'results\no';
%     if ~exist(writepath,'dir')
%         mkdir(writepath);
%     end
%     imwrite(im,[writepath '\' strrep(imagefiles(fi).name,'.bmp', ['_' num2str(label) '.bmp'])]);
end

disp(['']);
disp([ 'Yes ��ȷ�� ' num2str(yes_number/yesfileno)]);
disp([ 'No ��ȷ�� ' num2str(no_number/nofileno)]);
disp([ '������ȷ�� ' num2str((yes_number+no_number)/(yesfileno+nofileno))]);


