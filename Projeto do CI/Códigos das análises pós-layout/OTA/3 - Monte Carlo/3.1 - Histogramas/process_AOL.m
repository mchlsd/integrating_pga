close all;
clear all;
clc;
warning('off','all')


load ('data/AOL.mat');

%x = VarName2; yh = []; ar = []; bo = []; bgo = [0]; xlimo = []; ylimo = []; labels = Gainpass_X;
%t = barmod(x,yh,ar,bo,bgo,xlimo,ylimo,labels);

bar(AOLpass_X,VarName2,'histc')
xlabel( '$A_{OL}$ (dB)','Interpreter','Latex')
ylabel('Número de Amostras','Interpreter','Latex')
set(gca,'FontSize',13)
set(gcf, 'Position',  [0, 1920, 523, 422])
grid
str = {{'\mu = 71,29 dB'},'\sigma = 0,52 dB'};
text([69.5 69.5],[250 230],str,'FontSize',13)
%pause
exportgraphics(gcf,'OTA_AOL.pdf','ContentType','vector')
