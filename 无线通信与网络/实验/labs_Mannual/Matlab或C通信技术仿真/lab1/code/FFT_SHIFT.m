function[f,sf]=FFT_SHIFT(t,st)
%This function is FFT to calculate a signal's Fourier transform
%Input: t sampleing time, st:signal data. time length must greater than 2
%Outputs: f: sampling frequency, sf: frequen
%Output is the frequency and the signal spectrum
dt=t(2)-t(1);
T=t(end);
df=1/T;
N=length(t);
f=[-N/2:N/2-1]*df;
sf=fft(st);
sf=T/N*fftshift(sf);