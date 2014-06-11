%% Converting training.csv 
file=fopen('training.csv');

formatSpec='%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s';
data=textscan(file,formatSpec,'delimiter',',',...
      'headerLines',1,'EndOfLine','\r\n');

id=data{1,1};
S=[];
for i=1:30
  S=[S,data{1,i+1}];
end
weight=data{1,32};
label=data{1,33};

save training.mat id S weight label;
fclose(file);

N=50000;
id=id(1:N);
S=S(1:N,:);
weight=weight(1:N);
label=label(1:N);
save mini_training.mat id S weight label;

%% Converting test.csv 
file=fopen('test.csv');

formatSpec='%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
data=textscan(file,formatSpec,'delimiter',',',...
      'headerLines',1,'EndOfLine','\r\n');

id=data{1,1};
S=[];
for i=1:30
  S=[S,data{1,i+1}];
end

save test.mat id S weight label;
fclose(file);

