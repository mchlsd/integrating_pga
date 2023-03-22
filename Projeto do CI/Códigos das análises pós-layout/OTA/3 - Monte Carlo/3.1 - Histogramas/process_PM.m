close all;
clear all;
clc;
warning('off','all')


load ('data/PM.mat');

%x = VarName2; yh = []; ar = []; bo = []; bgo = [0]; xlimo = []; ylimo = []; labels = Gainpass_X;
%t = barmod(x,yh,ar,bo,bgo,xlimo,ylimo,labels);

bar(PhaseMarginpass_X,VarName2,'histc')
xlabel( ['Margem de Fase (' char(176) ')'],'Interpreter','Latex')
ylabel('Número de Amostras','Interpreter','Latex')
set(gca,'FontSize',13)
set(gcf, 'Position',  [0, 1920, 523, 422])
grid
str = {['\mu = 64,54' char(176)],['\sigma = 1,75' char(176)]};
text([60 60],[220 200],str,'FontSize',13)
%pause
exportgraphics(gcf,'OTA_PM.pdf','ContentType','vector')
