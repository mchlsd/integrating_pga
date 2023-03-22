close all;
clear all;
clc;
warning('off','all')


load ('mc_mismatch.mat');

%x = VarName2; yh = []; ar = []; bo = []; bgo = [0]; xlimo = []; ylimo = []; labels = Gainpass_X;
%t = barmod(x,yh,ar,bo,bgo,xlimo,ylimo,labels);

bar(Gainpass_X,VarName2,'histc')
xlabel( 'Ganho (V/V)','Interpreter','Latex')
ylabel('Número de Amostras','Interpreter','Latex')
set(gca,'FontSize',13)
set(gcf, 'Position',  [0, 1920, 523, 422])
grid
str = {{'\mu = 10,79 V/V'},'\sigma = 1,16 V/V'};
text([22.5 22.5],[250 230],str,'FontSize',12)
pause
exportgraphics(gcf,'PGA_g21_hist.pdf','ContentType','vector')