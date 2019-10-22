function [t,st]=vsbmd(f,sf,B1,B2,fc)
%This function is a residual bandpass filter
%Inputs: f sanmpling frequency, sf:frequency spectrum data
%        B1 residual bandwidth, B2:highest freq of the basedband signal
%Outputs: t: sampling time, st:signal data
df=f(2)-f(1);
T=1/df;
hf=zeros(1,length(f));
bf1=[floor((fc-B1)/df):floor((fc+B1)/df)];
bf2=[floor((fc+B1)/df+1):floor((fc+B2)/df)];
f1=bf1+floor(length(f)/2);
f2=bf2+floor(length(f)/2);
stepf=1/length(f1);
hf(f1)=0:stepf:(1-stepf);
hf(f2)=1;
f3=-bf1+floor(length(f)/2);
f4=-bf2+floor(length(f)/2);
hf(f3)=0:stepf:(1-stepf);
hf(f4)=1;
yf=hf.*sf;
[t,st]=IFFT_SHIFT(f,yf);
st=real(st);