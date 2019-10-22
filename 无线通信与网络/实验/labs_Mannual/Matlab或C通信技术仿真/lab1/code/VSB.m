%显示模拟调制的波形及解调方法VSB，文件VSB.m
%Signal
dt=0.001;
fmax=5;
fc=20;
T=5;
N=T/dt;
t=[0:N-1]*dt;
mt=sqrt(2)*(cos(2*pi*fmax*t)+sin(2*pi*0.5*fmax*t));
%VSB modulation
s_vsb=mt.*cos(2*pi*fc*t);
B=1.2*fmax;
[f,sf]=FFT_SHIFT(t,s_vsb);
[t,s_vsb]=vsbmd(f,sf,0.2*fmax,1.2*fmax,fc);
%Power Spectrum Density
[f,sf]=FFT_SHIFT(t,s_vsb);
PSD=(abs(sf).^2)/T;
%plot VSB and PSD      
figure(1)
subplot(211)
plot(t,s_vsb);hold on;
plot(t,mt,'r--');
title('VSB调制信号');
xlabel('t');
subplot(212)
plot(f,PSD);
axis([-2*fc 2*fc 0 max(PSD)]);
title('VSB信号功率谱');
xlabel('f');