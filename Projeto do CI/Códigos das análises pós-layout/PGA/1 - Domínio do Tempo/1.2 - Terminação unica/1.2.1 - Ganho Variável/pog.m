%close all;
clear all;
clc;
warning('off','all')

R = 246.6e3 + 2.7e3;
C = 4.015e-12;
v_input = 65;

load ('pog.mat');

theta_list = (25e-6-(table2array(se65mvvariableGain2500cyclesmeanConsumption(:,1))));
power = 1.8*table2array(se65mvvariableGain2500cyclesmeanConsumption(:,2))*-1e6;

gain_list = 1+((theta_list)/(R*C));
tau_exp = (1/(R*C));

%% Plot

figure (1)
plot(gain_list,power,'LineWidth',2,'color','k');
%set ( gca, 'xdir', 'reverse' )
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel('Potência ({\mu}W)','FontSize',12)
xlabel('Ganho (V/V)','FontSize',12)
%xlim([0 20e3])
%ylim([-20 40])
grid

