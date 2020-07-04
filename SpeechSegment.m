function [zcr,amp,voiceseg,vsl,SF,NF]=SpeechSegment(x,wlen,inc,NIS)
x=x(:);                                 % 把x转换成列数组
maxsilence = 10;                        % 初始化（CHANGE!!!）
minspeech  = 20;    
status  = 0;
count   = 0;
silence = 0;
r1 = 1;
r2 = 2;
r3 = 2;
y=enframe(x,wlen,inc)';                 % 分帧
fn=size(y,2);                           % 帧数
amp=sum(y.^2);                          % 求取短时平均能量

zcr=zc2(y,fn);                          % 计算短时平均过零率

ampth=mean(amp(1:NIS));                 % 计算初始无话段区间能量和过零率的平均值               
zcrth=mean(zcr(1:NIS));
amp2=r1*ampth; amp1=r2*ampth;           % 设置能量和过零率的阈值(T1,T2)
zcr2=r3*zcrth;

%开始端点检测
xn=1;                                   % 假设最少一个语音片段
for n=1:fn
   switch status
   case {0,1}                           % 0 = 静音, 1 = 可能开始
      if amp(n) > amp1                  % 确信进入语音段
         x1(xn) = max(n-count(xn)-1,1); % 语音信号开始位置，starting point
         status  = 2;
         silence(xn) = 0;
         count(xn)   = count(xn) + 1;
      elseif amp(n) > amp2 | ...        % 可能处于语音段
         zcr(n) > zcr2
         status = 1;
         count(xn)  = count(xn) + 1;
      else                              % 静音状态
         status  = 0;
         count(xn)   = 0;
         x1(xn)=0;
         x2(xn)=0;
      end
   case 2,                              % 2 = 语音段
      if amp(n) > amp2 & ...            % 保持在语音段
         zcr(n) > zcr2
         count(xn) = count(xn) + 1;
         silence(xn) = 0;
      else                              % 语音将结束
         silence(xn) = silence(xn)+1;
         if silence(xn) < maxsilence    % 静音还不够长，语音尚未结束
            count(xn)  = count(xn) + 1;
         elseif count(xn) < minspeech   % 语音长度太短，认为是静音或噪声
            status  = 0;
            silence(xn) = 0;
            count(xn)   = 0;
         else                           % 语音结束
            status  = 3;
            x2(xn)=x1(xn)+count(xn);    %语音结束位置，end point
         end
      end
   case 3,                              % 语音结束，为下一个语音准备
        status = 0;          
        xn=xn+1; 
        count(xn) = 0;
        silence(xn) = 0;
        x1(xn)=0;
        x2(xn)=0;
   end
end 

el=length(x1);             
if x1(el)==0, el=el-1; end              % 获得x1的实际长度
if x2(el)==0                            % 如果x2最后一个值为0，对它设置为fn
    fprintf('Error: Not find endding point!\n');
    x2(el)=fn;
end
SF=zeros(1,fn);                         % 按x1和x2，对SF和NF赋值
NF=ones(1,fn);
for i=1 : el
    SF(x1(i):x2(i))=1;
    NF(x1(i):x2(i))=0;
end
speechIndex=find(SF==1);                % 计算voiceseg
voiceseg=SegmentInfo(speechIndex);
vsl=length(voiceseg);
