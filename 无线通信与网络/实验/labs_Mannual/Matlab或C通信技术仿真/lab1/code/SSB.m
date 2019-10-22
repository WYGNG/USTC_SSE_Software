%显示模拟调制的波形及解调方法SSB，文件SSB.m
%Signal
dt=0.001;                         %时间采样间隔        
fmax=1;                          %信源最高频率
fc=10;                            %载波中心频率
T=5;                             %信号时长
t=0:dt:T;
mt=sqrt(2)*cos(2*pi*fmax*t);         %信源
%SSB modulation
s_ssb=real(hilbert(mt).*exp(j*2*pi*fc*t));
%Power Spectrum Density
[f,sf]=FFT_SHIFT(t,s_ssb);       %单边带信号频谱
PSD=(abs(sf).^2)/T;                 %单边带信号功率谱
figure(1)
subplot(211)
plot(t,s_ssb);hold on;                %画出SSB信号波形
plot(t,mt,'r--');                      %标示mt的包络
%axis([0 5 -max(mt) max(mt)]);
title('SSB调制信号');   
xlabel('t');
subplot(212)
plot(f,PSD);
axis([-2*fc 2*fc 0 max(PSD)+1]);
title('SSB信号功率谱');
xlabel('f');