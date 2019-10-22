function [out]=GaussNB(fc,B,N0,t)
dt=t(2)-t(1);
Fmax=1/dt;
N=length(t);
p=N0*Fmax;
rn=sqrt(p)*randn(1,N);
[f,rf]=FFT_SHIFT(t,rn);
[t,out]=BPF(f,rf,fc-B/2,fc+B/2);