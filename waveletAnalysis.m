data = csvread('..\RawDataRename_v2\2.csv');
cuffPressure = data(:,1);     % cuff pressure
korSound     = data(:,6);     % microphone
close all
s1=92000+30000;
s2=s1+10000;
data = korSound(s1:s2);


f1=50;  %�������Ҳ���Ƶ�ʣ����޸ģ�
f2=15;
fs=2000; %����Ƶ��
N=10001;%��������
n=0:N-1;
t=n/fs; %ʱ������
y=0.06*sin(2*pi*f1*t);
sound = data+y';

aaa = func_denoise_dw1d(sound);
subplot(211);plot(sound)
subplot(212);plot(aaa);
xlable('ʱ�� (s)')


h1 = openfig('untitled.fig','reuse'); % open figure  

cuffPressure = (cuffPressure(75000:180000)-1)*100;
plot(cuffPressure)
% stem()

%----�ݲ���
f0=10;fs=2000;r=0.96;
w0=2*pi*f0/fs;
b=[1 -2*cos(w0) 1];

a=[1 -2*r*cos(w0) r*r];
y=dlsim(b,a,data);%�ݲ����˲�����

plot(data);
hold on
plot(y,'r');
%----

x= data;
lx=length(x);
t=[0:1:length(x)-1]'; 
%% ���Ƽ�������ź�
subplot(2,2,1);
plot(t,x);
title('ԭʼ�ź�');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)
%% ��db1С����ԭʼ�źŽ���3��ֽⲢ��ȡС��ϵ��
[c,l]=wavedec(x,3,'db1');%sym8
ca3=appcoef(c,l,'db1',3);%��Ƶ����
cd3=detcoef(c,l,3);%��Ƶ����
cd2=detcoef(c,l,2);%��Ƶ����
cd1=detcoef(c,l,1);%��Ƶ����
%% ���źŽ���ǿ��ȥ�봦��ͼʾ
cdd3=zeros(1,length(cd3));
cdd2=zeros(1,length(cd2));
cdd1=zeros(1,length(cd1));
c1=[ca3',cdd3,cdd2,cdd1]';
x1=waverec(c1,l,'db1');
subplot(2,2,2);
plot(x1);
title('ǿ��ȥ����ź�');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)
%% Ĭ����ֵ���ź�ȥ�벢ͼʾ
%��ddencmp( )��������źŵ�Ĭ����ֵ��ʹ��wdencmp( )����ʵ��ȥ�����
[thr,sorh,keepapp]=ddencmp('den','wv',x);
x2=wdencmp('gbl',c,l,'db1',3,thr,sorh,keepapp);
subplot(2,2,3);
plot(x2);
title('Ĭ����ֵȥ����ź�');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)
%% ����������ֵ����ȥ�봦��ͼʾ
cd1soft=wthresh(x,'s',0.0465);%�����������ֵ��
cd2soft=wthresh(x,'s',0.0823); %�����������ֵ��
cd3soft=wthresh(x,'s',0.0768); %�����������ֵ��
c2=[ca3',cd3soft',cd2soft',cd1soft']';
x3=waverec(c2,l,'db1');
subplot(2,2,4);
plot(x3);
title('��������ֵȥ����ź�');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)