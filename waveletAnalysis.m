% data = csvread('..\RawDataRename_v2\2.csv');
% cuffPressure = data(:,1);     % cuff pressure
% korSound     = data(:,6);     % microphone
close all
s1=92000;
s2=s1+7000;
data = korSound(s1:end);


%----陷波器
f0=10;fs=2000;r=0.96;
w0=2*pi*f0/fs;
b=[1 -2*cos(w0) 1];
a=[1 -2*r*cos(w0) r*r];
y=dlsim(b,a,data);%陷波器滤波处理

plot(data);
hold on
plot(y,'r');
%----



x= data;
lx=length(x);
t=[0:1:length(x)-1]'; 
%% 绘制监测所得信号
subplot(2,2,1);
plot(t,x);
title('原始信号');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)
%% 用db1小波对原始信号进行3层分解并提取小波系数
[c,l]=wavedec(x,3,'db1');%sym8
ca3=appcoef(c,l,'db1',3);%低频部分
cd3=detcoef(c,l,3);%高频部分
cd2=detcoef(c,l,2);%高频部分
cd1=detcoef(c,l,1);%高频部分
%% 对信号进行强制去噪处理并图示
cdd3=zeros(1,length(cd3));
cdd2=zeros(1,length(cd2));
cdd1=zeros(1,length(cd1));
c1=[ca3',cdd3,cdd2,cdd1]';
x1=waverec(c1,l,'db1');
subplot(2,2,2);
plot(x1);
title('强制去噪后信号');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)
%% 默认阈值对信号去噪并图示
%用ddencmp( )函数获得信号的默认阈值，使用wdencmp( )函数实现去噪过程
[thr,sorh,keepapp]=ddencmp('den','wv',x);
x2=wdencmp('gbl',c,l,'db1',3,thr,sorh,keepapp);
subplot(2,2,3);
plot(x2);
title('默认阈值去噪后信号');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)
%% 给定的软阈值进行去噪处理并图示
cd1soft=wthresh(x,'s',0.0465);%经验给出软阈值数
cd2soft=wthresh(x,'s',0.0823); %经验给出软阈值数
cd3soft=wthresh(x,'s',0.0768); %经验给出软阈值数
c2=[ca3',cd3soft',cd2soft',cd1soft']';
x3=waverec(c2,l,'db1');
subplot(2,2,4);
plot(x3);
title('给定软阈值去噪后信号');
grid on
set(gcf,'color','w')  
set(gca,'fontsize',14.0)