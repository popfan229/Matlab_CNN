function [ output_args ] = audioSpecImage( pluswave,sampleRate, widthFrame, overlap, showImage )
% UNTITLED Summary of this function goes here
% Detailed explanation goes here
x = pluswave;
s=length(x);
% w=round(widthFrame*sampleRate/1000);                 %窗长，取离44*sr/1000最近的整数
w = widthFrame;
n=w;                                 %fft的点数
% ov=overlap*w;                            %75%的重叠
ov = overlap;
h=w-ov;
win=hamming(n)';
c=1;
ncols=1+fix((s-n)/h);                %fix函数是将(s-n)/h的小数舍去
d=zeros((1+n/2),ncols);
for b=0:h:(s-n)
    u=win.*x((b+1):(b+n));
    t=fft(u);
    d(:,c)=t(1:(1+n/2))';
    c=c+1;
end

output_args = 20*log10(abs(d));

    if showImage==1
        tt=[0:h:(s-n)]/sampleRate;
        ff=[0:(n/2)]*sampleRate/n;
        imagesc(tt,ff/1000,20*log10(abs(d))); 
        colormap('default');               %黑白度对应于信号的能量，声道的谐振频率在图上就表示成为黑带，浊音部分则以出现条纹为其特征，这是因为时域波形有周期性，而浊音的时间间隔内图形显得很致密
        % colormap(gray);
        axis xy;
        xlabel('时间/s');
        ylabel('频率/kHz')  
    end

end

