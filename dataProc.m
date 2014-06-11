close all; clear all; clc;

load training.mat;

ch=[1:4,9,14,17,20,22,30];
chNum=numel(ch);
sIdx=strcmp(label,'s');
bIdx=~sIdx;
sId=id(sIdx);
bId=id(~sIdx);
N=length(S);

disp(['Preproccessing...']);
winSz=3;
centerPt=round(winSz+1);
medKernPts=1;
for i=11:N-10
  for k=ch
    temp=sort(S(i-winSz:i+winSz));
    S(i,k)=mean(temp(centerPt-medKernPts:centerPt+medKernPts));
  end
end

disp(['Searching middle points...']);
sAvPoint=zeros(chNum,1);
bAvPoint=zeros(chNum,1);
idx=1;
for i=ch
  sAvPoint(idx)=mean(S(sIdx,i));
  bAvPoint(idx)=mean(S(bIdx,i));
  idx=idx+1;
end

midPoint=(sAvPoint+bAvPoint)/2;

disp(['Calculating distances for all points...']);

R=zeros(N,1);
for i=1:N
  idx=1;
  for k=ch
    R(i)=R(i)+(S(i,k)-sAvPoint(idx))^2;
    idx=idx+1;
  end
  R(i)=sqrt(R(i));
end

temp=R(sIdx);
maxR=mean(temp)/2;
disp(['maxR = ',num2str(maxR)]);

disp(['Sorting data...']);
data=cell(N,3);
data{1,1}=id;
[B,I]=sort(R);
for i=1:N
  if (rem(i,25000)==0)
    disp(num2str(i));
  end
  data{i,1}=id(i);
  rIdx=find(I==i);
  data{i,2}=rIdx;
  if (R(rIdx)<=maxR)
    data{i,3}='s';
  else
    data{i,3}='b';
  end
end

figure
boxplot(S(sIdx,ch)); grid on;

figure
boxplot(S(bIdx,ch)); grid on;

figure
hs(1)=subplot(1,2,1);
boxplot(R(sIdx)); title('R(sIdx)'); grid on;
hs(2)=subplot(1,2,2);
boxplot(R(bIdx)); title('R(bIdx)'); grid on;
linkaxes(hs,'y');

fid = fopen('training_submission.csv','wt');  % Note the 'wt' for writing in text mode
fprintf(fid,'EventId,RankOrder,Class\n');
for i=1:N
  fprintf(fid,'%.0f,%.0f,%s\n',data{i,1},data{i,2},data{i,3});  % The format string is applied to each element of a
end
fclose(fid);

s=0; % true positive
b=0; % false positive
ns=0; % false negative
nb=0; % true negative
for i=1:N
  if (strcmp(data{i,3},'s') && strcmp(label(i),'s'))
    s=s+1;
  end
  if (strcmp(data{i,3},'s') && strcmp(label(i),'b'))
    b=b+1;
  end
  if (strcmp(data{i,3},'b') && strcmp(label(i),'s'))
    ns=ns+1;
  end
  if (strcmp(data{i,3},'b') && strcmp(label(i),'b'))
    nb=nb+1;
  end
end

br=10;
AMS=sqrt(2*((s+b+br)*log(1+s/(b+br))-s));
disp(['AMS = ',num2str(AMS)]);
disp(['s when ref. s number = ',num2str(s)]);
disp(['s when ref. b number = ',num2str(b)]);
disp(['b when ref. s number = ',num2str(ns)]);
disp(['b when ref. b number = ',num2str(nb)]);
figure
bar([s,b,ns,nb],'r');
set(gca,'XTickLabel',{'True Pos.', 'False Pos.', 'False Neg.', 'True Neg.'});

%%
load test.mat;
disp(['Calculating distances for all points...']);
N=length(S);
R=zeros(N,1);
for i=1:N
  idx=1;
  for k=1:ch
    R(i)=R(i)+(S(i,k)-sAvPoint(idx))^2;
    idx=idx+1;
  end
  R(i)=sqrt(R(i));
end

temp=R(sIdx);
maxR=mean(temp);

disp(['Sorting data...']);
data=cell(N,3);
data{1,1}=id;
[B,I]=sort(R);
for i=1:N
  if (rem(i,25000)==0)
    disp(num2str(i));
  end
  data{i,1}=id(i);
  rIdx=find(I==i);
  data{i,2}=rIdx;
  if (R(rIdx)<=maxR)
    data{i,3}='s';
  else
    data{i,3}='b';
  end
end

fid = fopen('submission.csv','wt');  % Note the 'wt' for writing in text mode
fprintf(fid,'EventId,RankOrder,Class\n');
for i=1:N
  fprintf(fid,'%.0f,%.0f,%s\n',data{i,1},data{i,2},data{i,3});  % The format string is applied to each element of a
end
fclose(fid);
