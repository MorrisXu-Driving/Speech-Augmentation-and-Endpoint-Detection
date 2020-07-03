function [zcr,amp,voiceseg,vsl,SF,NF]=SpeechSegment(x,wlen,inc,NIS)
x=x(:);                                 % ��xת����������
maxsilence = 10;                        % ��ʼ����CHANGE!!!��
minspeech  = 20;    
status  = 0;
count   = 0;
silence = 0;
r1 = 1;
r2 = 2;
r3 = 2;
y=enframe(x,wlen,inc)';                 % ��֡
fn=size(y,2);                           % ֡��
amp=sum(y.^2);                          % ��ȡ��ʱƽ������

zcr=zc2(y,fn);                          % �����ʱƽ��������

ampth=mean(amp(1:NIS));                 % �����ʼ�޻������������͹����ʵ�ƽ��ֵ               
zcrth=mean(zcr(1:NIS));
amp2=r1*ampth; amp1=r2*ampth;             % ���������͹����ʵ���ֵ(T1,T2)
zcr2=r3*zcrth;

%��ʼ�˵���
xn=1;                                   % ��������һ������Ƭ��
for n=1:fn
   switch status
   case {0,1}                           % 0 = ����, 1 = ���ܿ�ʼ
      if amp(n) > amp1                  % ȷ�Ž���������
         x1(xn) = max(n-count(xn)-1,1); % �����źſ�ʼλ�ã�starting point
         status  = 2;
         silence(xn) = 0;
         count(xn)   = count(xn) + 1;
      elseif amp(n) > amp2 | ...        % ���ܴ���������
         zcr(n) > zcr2
         status = 1;
         count(xn)  = count(xn) + 1;
      else                              % ����״̬
         status  = 0;
         count(xn)   = 0;
         x1(xn)=0;
         x2(xn)=0;
      end
   case 2,                              % 2 = ������
      if amp(n) > amp2 & ...            % ������������
         zcr(n) > zcr2
         count(xn) = count(xn) + 1;
         silence(xn) = 0;
      else                              % ����������
         silence(xn) = silence(xn)+1;
         if silence(xn) < maxsilence    % ��������������������δ����
            count(xn)  = count(xn) + 1;
         elseif count(xn) < minspeech      % ��������̫�̣���Ϊ�Ǿ���������
            status  = 0;
            silence(xn) = 0;
            count(xn)   = 0;
         else                           % ��������
            status  = 3;
            x2(xn)=x1(xn)+count(xn);    %��������λ�ã�end point
         end
      end
   case 3,                              % ����������Ϊ��һ������׼��
        status = 0;          
        xn=xn+1; 
        count(xn) = 0;
        silence(xn) = 0;
        x1(xn)=0;
        x2(xn)=0;
   end
end 

el=length(x1);             
if x1(el)==0, el=el-1; end              % ���x1��ʵ�ʳ���
if x2(el)==0                            % ���x2���һ��ֵΪ0����������Ϊfn
    fprintf('Error: Not find endding point!\n');
    x2(el)=fn;
end
SF=zeros(1,fn);                         % ��x1��x2����SF��NF��ֵ
NF=ones(1,fn);
for i=1 : el
    SF(x1(i):x2(i))=1;
    NF(x1(i):x2(i))=0;
end
speechIndex=find(SF==1);                % ����voiceseg
voiceseg=SegmentInfo(speechIndex);
vsl=length(voiceseg);