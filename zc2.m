function zcr=zc2(y,fn)
if size(y,2)~=fn, y=y'; end
wlen=size(y,1);                            % ����֡��
zcr=zeros(1,fn);                           % ��ʼ��
delta=0.01;                                % ����һ����С����ֵ
for i=1:fn
    yn=y(:,i);                             % ȡ��һ֡
    for k=1 : wlen                         % ���Ľط�����
        if yn(k)>=delta
            ym(k)=yn(k)-delta;
        elseif yn(k)<-delta
            ym(k)=yn(k)+delta;
        else
            ym(k)=0;
        end
    end
    zcr(i)=sum(ym(1:end-1).*ym(2:end)<0);  % ȡ�ô�����һ֡����Ѱ�ҹ�����
end