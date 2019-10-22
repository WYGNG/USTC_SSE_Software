% Demodule.M
%Signal
dt=0.01;                     %时间采样间隔　　　　　
fmax=1;                     %信源最高频率
fc=10;                      %载波中心频率
B=2*fmax;
T=5;
N=floor(T/dt);                    
t=[0:N-1]*dt;
mt=sqrt(2)*cos(2*pi*fmax*t);       %信源
%AM modulation
A=2;
am=(A+mt).*cos(2*pi*fc*t);
amd=am.*cos(2*pi*fc*t);          %相干解调
amd=amd-mean(amd);
[f,AMf]=FFT_SHIFT(t,amd);
B=2*fmax;
[t,am_t]=RECT_LPF(f,AMf,B);     %低通滤波
%DSB modulation
dsb=mt.*cos(2*pi*fc*t);
dsbd=dsb.*cos(2*pi*fc*t);
dsbd=dsbd-mean(dsbd);
[f,DSBf]=FFT_SHIFT(t,dsbd);
[t,dsb_t]=RECT_LPF(f,DSBf,B);
%SSB modulation
ssb=real(hilbert(mt).*exp(j*2*pi*fc*t));
ssbd=ssb.*cos(2*pi*fc*t);
ssbd=ssbd-mean(ssbd);
B=2*fmax;
[f,SSBf]=FFT_SHIFT(t,ssbd);
[t,ssb_t]=RECT_LPF(f,SSBf,B);
%VSB modulation
vsb=mt.*cos(2*pi*fc*t);
[f,vsbf]=FFT_SHIFT(t,vsb);
[t,vsb]=vsbmd(f,vsbf,0.2*fmax,1.2*fmax,fc);
vsbd=vsb.*cos(2*pi*fc*t);
vsbd=vsbd-mean(vsbd);
[f,VSBf]=FFT_SHIFT(t,vsbd);
[t,vsb_t]=RECT_LPF(f,VSBf,2*fmax);
% plot m(t),am(t),dsb(t),ssb(t),vsb(t)
subplot(511);
plot(t,mt);
title('相干解调后的信号与输入信号的比较');
ylabel('m(t)');
xlabel('t');
subplot(512);
plot(t,am_t);
ylabel('am(t)');
xlabel('t');
subplot(513);
plot(t,dsb_t);
ylabel('dsb(t)');
xlabel('t');
subplot(514);
plot(t,ssb_t);
ylabel('ssb(t)');
xlabel('t');
subplot(515);
plot(t,vsb_t);
ylabel('vsb(t)');
xlabel('t');