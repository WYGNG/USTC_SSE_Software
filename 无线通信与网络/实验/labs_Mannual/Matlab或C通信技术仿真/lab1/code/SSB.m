%��ʾģ����ƵĲ��μ��������SSB���ļ�SSB.m
%Signal
dt=0.001;                         %ʱ��������        
fmax=1;                          %��Դ���Ƶ��
fc=10;                            %�ز�����Ƶ��
T=5;                             %�ź�ʱ��
t=0:dt:T;
mt=sqrt(2)*cos(2*pi*fmax*t);         %��Դ
%SSB modulation
s_ssb=real(hilbert(mt).*exp(j*2*pi*fc*t));
%Power Spectrum Density
[f,sf]=FFT_SHIFT(t,s_ssb);       %���ߴ��ź�Ƶ��
PSD=(abs(sf).^2)/T;                 %���ߴ��źŹ�����
figure(1)
subplot(211)
plot(t,s_ssb);hold on;                %����SSB�źŲ���
plot(t,mt,'r--');                      %��ʾmt�İ���
%axis([0 5 -max(mt) max(mt)]);
title('SSB�����ź�');   
xlabel('t');
subplot(212)
plot(f,PSD);
axis([-2*fc 2*fc 0 max(PSD)+1]);
title('SSB�źŹ�����');
xlabel('f');