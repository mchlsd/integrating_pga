close all;
clear all;
clc;
warning('off','all')


load ('data/SR.mat');

%x = VarName2; yh = []; ar = []; bo = []; bgo = [0]; xlimo = []; ylimo = []; labels = Gainpass_X;
%t = barmod(x,yh,ar,bo,bgo,xlimo,ylimo,labels);

bar(SRpass_X/1e6,VarName2,'histc')
xlabel( '\it{Slew-Rate} \rm(MV/s)','Interpreter','Latex')
ylabel('Número de Amostras','Interpreter','Latex')
set(gca,'FontSize',13)
set(gcf, 'Position',  [0, 1920, 523, 422])
grid
str = {{'\mu = 14,32 MV/s'},'\sigma = 0,49 MV/s'};
text([12.3 12.3],[220 200],str,'FontSize',13)
%pause
exportgraphics(gcf,'OTA_SR.pdf','ContentType','vector')
