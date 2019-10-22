%Signal   AM_Noise.M
dt=0.01;                     %时间采样间隔　　　　　
fmax=1;                     %信源最高频率
fc=10;                      %载波中心频率
T=5;
N=T/dt;                    
t=[0:N-1]*dt;
mt=sqrt(2)*cos(2*pi*fmax*t);       %信源
N0=0.1;
%AM modulation
A=2;
am=(A+mt).*cos(2*pi*fc*t);
B=2*fmax;
Noise=GaussNB(fc,B,N0,t);
amt=am+Noise;
figure(1)
subplot(321);
plot(t,amt);hold on;
plot(t,A+mt,'r--');
title('AM信号');Xlabel('t');
%AM demodulation
amd=amt.*cos(2*pi*fc*t);          %相干解调
amd=amd-mean(amd);
[f,AMf]=FFT_SHIFT(t,amd);
[t,am_t]=RECT_LPF(f,AMf,B);     %低通滤波
subplot(322);
plot(t,amd);hold on;
plot(t,mt/2,'r--');
title('AM解调信号');Xlabel('t');

%DSB modulation
dsb=mt.*cos(2*pi*fc*t);
Noise=GaussNB(fc,B,N0,t);
dsb=dsb+Noise;
subplot(323);
plot(t,dsb);hold on;
plot(t,mt,'r--');
title('DSB信号');Xlabel('t');
%DSB demodulation
dsbd=dsb.*cos(2*pi*fc*t);
dsbd=dsbd-mean(dsbd);
[f,DSBf]=FFT_SHIFT(t,dsbd);
[t,dsb_t]=RECT_LPF(f,DSBf,B);
subplot(324);
plot(t,dsb_t);hold on;
plot(t,mt/2,'r--');
title('DSB解调信号');Xlabel('t');

%SSB modulation
ssb=real(hilbert(mt).*exp(j*2*pi*fc*t));
Noise=GaussNB(fc,B,N0,t);
ssb=ssb+Noise;
subplot(325);
plot(t,ssb);hold on;
plot(t,mt,'r--');
title('SSB信号');Xlabel('t');
%SSB demodulation
ssbd=ssb.*cos(2*pi*fc*t);
ssbd=ssbd-mean(ssbd);
B=2*fmax;
[f,SSBf]=FFT_SHIFT(t,ssbd);
[t,ssb_t]=RECT_LPF(f,SSBf,B);
subplot(326);
plot(t,ssb_t);hold on;
plot(t,mt/2,'r--');
title('SSB解调信号');Xlabel('t');