
% 1. IS
% 2. amp1,amp2
% 2. zrc2
clear all; clc; close all;

% MMSE Filter Denoising
%--- desired signal-------------------
[s,fs]= audioread('bluesky1.wav');
T= 4; % time duration to denoise (less than the duration of input signal)
T_start= 0;
N= T*fs;
n1= max(T_start*fs,1);
n=0:1:(N-1); n= n';
time=(0:N-1)/fs;  
s=s/max(abs(s));                        % Normalization
s= s(n1:(n1+N-1));

%----LTI system setting-------
delay= 0.01;  
h= [ zeros(delay*fs,1); 4];
L= length(h);

%--- noise signals------------
[v,fs]= audioread('crowdtalking2_16k.wav');
v= v(n1:(n1+N+L-1));

v1= conv(h,v); v1= v1((L+1):(L+N));
v2= v((L+1):(L+N));

%---the primary input and reference signals-------
x= v2;
d= s + v1;

%---- optimal filter---------------------------
M= 500;     %change the filter size
mu= 0.1;    %change the iterate parameter

e= zeros(N,1);
y= zeros(N,1);
w= zeros(M,1);
x_vec= zeros(M,1);

for i=1:N
    x_vec= [ x(i); x_vec(1:M-1) ];
    y(i)= w'*x_vec;
    e(i)= d(i)- y(i);
    w= w + mu*e(i)*x_vec;
end
fprintf('%4d   %4d   \n',db(snr(d,v1)),db(snr(e,v1)));

% Visuluzation-----------------------------------------
figure(1)
subplot 211;plot(time,d); % 带有噪音的语音信号
subplot 212;plot(time,e); % 通过MMSE Filter后的语音信号
figure(2)
plot(time,e,'b');         
title('Speech Signal End Point Detection');
ylabel('Amplitude'); axis([0 max(time) -1 1]); grid;
xlabel('Time/s');



% Endpoint Detection
wlen=500; inc=100;                      % 分帧参数
IS=0.2; overlap=wlen-inc;               % 设置IS
NIS=fix((IS*fs-wlen)/inc +1);           % 计算NIS
fn=fix((N-wlen)/inc)+1;                 % 求帧数
frameTime=frame2time(fn, wlen, inc, fs);% 计算每帧对应的时间
ss=enframe(e,wlen,inc)';                % 对消噪后语音信号进行分帧

[zcr,amp,voiceseg,vsl,SF,NF]=SpeechSegment(e,wlen,inc,NIS);  % 端点检测

for k=1 : vsl                           % 画出语音信号起止点位置
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    fprintf('%4d   %4d   %4d   %4d\n',k,nx1,nx2,nxl);
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','r','LineStyle','--');
end

figure(3);
subplot 211; plot(amp);title('Short-time Energy per frame')
subplot 212; plot(zcr);title('Short-time Zero Crossing Rate per frame');





