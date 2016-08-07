function [ output_args ] = audioSpecImage( pluswave,sampleRate, widthFrame, overlap, showImage )
% UNTITLED Summary of this function goes here
% Detailed explanation goes here
x = pluswave;
s=length(x);
% w=round(widthFrame*sampleRate/1000);                 %������ȡ��44*sr/1000���������
w = widthFrame;
n=w;                                 %fft�ĵ���
% ov=overlap*w;                            %75%���ص�
ov = overlap;
h=w-ov;
win=hamming(n)';
c=1;
ncols=1+fix((s-n)/h);                %fix�����ǽ�(s-n)/h��С����ȥ
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
        colormap('default');               %�ڰ׶ȶ�Ӧ���źŵ�������������г��Ƶ����ͼ�Ͼͱ�ʾ��Ϊ�ڴ��������������Գ�������Ϊ��������������Ϊʱ�����������ԣ���������ʱ������ͼ���Եú�����
        % colormap(gray);
        axis xy;
        xlabel('ʱ��/s');
        ylabel('Ƶ��/kHz')  
    end

end

