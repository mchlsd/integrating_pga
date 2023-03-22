mu = 0;
sigma = 0.5;
%truncate at 0 and 1920
pd = truncate(makedist('Normal',mu,sigma),-1,1);
% take some (10) samples
samples = random(pd,100000,1);

%not truncated
time = 0:1e-8:3.5e-3;
dist = normrnd(1.7,0.0005,[1 numel(time)]);
dlmwrite('random_data_p.txt',[time' dist'],'delimiter',' ')

dist = normrnd(1.6,0.0005,[1 numel(time)]);
dlmwrite('random_data_n.txt',[time' dist'],'delimiter',' ')

dist = normrnd(0,0.001,[1 numel(time)]);
dlmwrite('random_data_cm.txt',[time' dist'],'delimiter',' ')