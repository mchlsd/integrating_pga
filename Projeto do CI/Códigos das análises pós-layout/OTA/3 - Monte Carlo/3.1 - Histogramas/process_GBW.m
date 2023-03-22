close all;
clear all;
clc;
warning('off','all')


load ('data/GBW.mat');

%x = VarName2; yh = []; ar = []; bo = []; bgo = [0]; xlimo = []; ylimo = []; labels = Gainpass_X;
%t = barmod(x,yh,ar,bo,bgo,xlimo,ylimo,labels);

bar(GBWpass_X/1e6,VarName2,'histc')
xlabel( 'GBW (MHz)','Interpreter','Latex')
ylabel('Número de Amostras','Interpreter','Latex')
set(gca,'FontSize',13)
set(gcf, 'Position',  [0, 1920, 523, 422])
grid
str = {{'\mu = 21,82 MHz'},'\sigma = 0,84 MHz'};
text([23 23],[270 250],str,'FontSize',13)
%pause
exportgraphics(gcf,'OTA_GBW.pdf','ContentType','vector')
