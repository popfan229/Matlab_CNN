% DWT experiment
close all
Fs = 2000;

data = csvread('E:\Project\2016-01 Deep Learning\RawData\004\3_R2.CSV');

cuffPressure      = data(:,1);     % cuff pressure
soundUnderCuff    = data(:,2);     % microphone
soundOutCuff      = data(:,3);     % brath

% plot(soundUnderCuff);

%------- plot specgram
% [S,F,T,P] = spectrogram(soundUnderCuff); 
% surf(T,F,10*log10(abs(P)));
% axis tight;
% view(0,90);
spectrogram(soundUnderCuff,kaiser(256,5),220,1024,2000,'yaxis');

%------- End of plot specgram

s = soundUnderCuff;
Len = length(s);
% [ca1, cd1] = dwt(s, 'db1'); % ����db1С�����ֽ�
% a1 = upcoef('a', ca1, 'db1', 1, Len); % ��ϵ���õ������ź�
% d1 = upcoef('d', cd1, 'db1', 1, Len); % ��ϵ���õ�ϸ���ź�
% s1 = a1+d1; % �ع��ź�
% figure;
% subplot(2, 2, 1); plot(s); title('��ʼ��Դ�ź�');
% subplot(2, 2, 2); plot(ca1); title('һ��С���ֽ�ĵ�Ƶ��Ϣ');
% subplot(2, 2, 3); plot(cd1); title('һ��С���ֽ�ĸ�Ƶ��Ϣ');
% subplot(2, 2, 4); plot(s1, 'r-'); title('һ��С���ֽ���ع��ź�');
[c,l] = wavedec(s,4,'db1');

% subplot(4,1,1);plot(s);
% subplot(4,1,2);plot(c(1:10000/1));
A=appcoef(c,l,'db1',1);%��ȡ��1-4��ƽ�ϵ��
subplot(5,1,1);plot(A);
A=appcoef(c,l,'db1',2);
subplot(5,1,2);plot(A);
A=appcoef(c,l,'db1',3);
subplot(5,1,3);plot(A);
A=appcoef(c,l,'db1',4);
subplot(5,1,4);plot(A);
subplot(5,1,5);plot(s);

figure()
A=detcoef(c,l,1);%��ȡ��1-4��ϸ��ϵ��
subplot(5,1,1);plot(A);
A=detcoef(c,l,2);
subplot(5,1,2);plot(A);
A=detcoef(c,l,3);
subplot(5,1,3);plot(A);
A=detcoef(c,l,4);
subplot(5,1,4);plot(A);
subplot(5,1,5);plot(s);

figure()
a4 = wrcoef('a',c,l,'db1',4);%�ع���1-4��ƽ�ϵ��
subplot(5,1,1);plot(a4);
a3 = wrcoef('a',c,l,'db1',3);
subplot(5,1,2);plot(a3);
a2 = wrcoef('a',c,l,'db1',2);
subplot(5,1,3);plot(a2);
a1 = wrcoef('a',c,l,'db1',1);
subplot(5,1,4);plot(a1);
subplot(5,1,5);plot(s);

figure()
b4 = wrcoef('d',c,l,'db1',4);%�ع���1-4��ϸ��ϵ��
subplot(5,1,1);plot(a4);
b3 = wrcoef('d',c,l,'db1',3);
subplot(5,1,2);plot(a3);
b2 = wrcoef('d',c,l,'db1',2);
subplot(5,1,3);plot(a2);
b1 = wrcoef('d',c,l,'db1',1);
subplot(5,1,4);plot(a1);
subplot(5,1,5);plot(s);


