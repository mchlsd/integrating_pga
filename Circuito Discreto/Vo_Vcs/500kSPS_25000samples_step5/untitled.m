clear all
a = 9.97;
b = 0.1;
x = 0:0.01:0.25;
an = a + normrnd(0,0.02,[1 numel(x)]);
bn = b + normrnd(0,0.004,[1 numel(x)]);
%y = an.*x+bn

for i=1:1000
    an = a + normrnd(0,0.02,[1 numel(x)]);
    bn = b + normrnd(0,0.004,[1 numel(x)]);
    y(:,i) = an.*x+bn;
end