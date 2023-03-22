%close all;
clear all;
clc;
warning('off','all')

R = 246.6e3 + 2.7e3;
C = 4.015e-12;
v_input = 65;


%theta_list = 25e-6-[24e-6 20e-6 16e-6 12e-6 8e-6 6.097593e-06 4e-6 1.549193e-06 0.3935979e-06 0.1e-6];
%theta_list = 25e-6-0.1e-6;
%theta_list = 25e-6-[24e-6 18e-6 12e-6 6e-6 0.1e-6]

%gain_list = 1+((theta_list)/(R*C));
%tau_exp = (1/(R*C));

load ('matlab.mat');

%sf,ss,nom,fs,ff,tt

aol_temperature = table2array(PVTOTAAOL(:,1:2:12));
aol_data = table2array(PVTOTAAOL(:,2:2:12));

gbw_temperature = table2array(PVTOTAGBW(:,1:2:12));
gbw_data = table2array(PVTOTAGBW(:,2:2:12));

sr_temperature = table2array(PVTOTASR(:,1:2:12));
sr_data = table2array(PVTOTASR(:,2:2:12));

pm_temperature = table2array(PVTOTAPM(:,1:2:12));
pm_data = table2array(PVTOTAPM(:,2:2:12));


%gain_frequency = fliplr(gain_frequency);
%gain_data = fliplr(gain_data);

%phase_frequency = fliplr(phase_frequency);
%phase_data = fliplr(phase_data);


%for j = 1:numel(theta_list)
    
%end

%% Plot

% figure (1)
% subplot(2,1,1);
% semilogx(gain_frequency,gain_data,'LineWidth',2);
% %title('\fontsize{15}{0} Ganho','Interpreter','Latex');
% ylabel('Ganho (dB)','FontSize',12)
% xlabel('Frequência (Hz)','FontSize',12)
% xlim([0 100e3])
% ylim([-20 40])
% grid
% 
% subplot(2,1,2);
% semilogx(phase_frequency,phase_data,'LineWidth',2);
% %title('\fontsize{15}{0} $\overline{\sigma_{V_{i}}}$','Interpreter','Latex');
% ylabel(['Fase (' char(176) ')'],'FontSize',12)
% xlabel('Frequência (Hz)','FontSize',12)
% xlim([0 1000e3])
% ylim([-400 100])
% 
% grid


figure (1)
t = tiledlayout('flow');

nexttile
plot(aol_temperature,aol_data,'LineWidth',1.5);
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel('$A_{OL}$ (dB)','Interpreter','Latex')
%xlabel(['Temperatura (' char(176) 'C)'],'FontSize',12)
%legend('sf','ss','nom','fs','ff','tt','Location','North','Orientation','horizontal','Box','on')
grid
xlim([-75 145])
%ylim([12 28])


nexttile
plot(gbw_temperature,gbw_data/1e6,'LineWidth',1.5);
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel('GBW (MHz)','Interpreter','Latex')
%xlabel(['Temperatura (' char(176) 'C)'],'FontSize',12)
%legend('sf','ss','nom','fs','ff','tt','Location','North','Orientation','horizontal','Box','on')
grid
xlim([-75 145])
%ylim([12 28])

nexttile
plot(sr_temperature,sr_data/1e6,'LineWidth',1.5);
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel('\it{Slew-rate} \rm(MV/s)','Interpreter','Latex')
%xlabel(['Temperatura (' char(176) 'C)'],'FontSize',12)
%legend('sf','ss','nom','fs','ff','tt','Location','North','Orientation','horizontal','Box','on')
grid
xlim([-75 145])
ylim([11 16.5])

nexttile
plot(pm_temperature,pm_data,'LineWidth',1.5);
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel(['Margem de Fase (' char(176) ')'],'Interpreter','Latex')
%xlabel(['Temperatura (' char(176) 'C)'],'FontSize',12)
%legend('sf','ss','nom','fs','ff','tt','Location','North','Orientation','horizontal','Box','on')
grid
xlim([-75 145])
%ylim([12 28])


legend('sf','ss','nom','fs','ff','tt','Location','North','Orientation','horizontal','Box','on','FontSize',10)
xlabel(t,['Temperatura (' char(176) 'C)'],'FontSize',12)
%set(gca,'FontSize',12)
set(gcf, 'Position',  [0, 1920, 523, 422])

% a2 = axes();
% a2.Position = [0.3200 0.6600 0.2 0.2]; % xlocation, ylocation, xsize, ysize
% plot(gain_temperature,gain_data,'LineWidth',1.5); axis tight
% grid
% xlim([-75 145])
% ylim([20.2 21])
% set(gca,'FontSize',10)
% %annotation('ellipse',[.2 .3 .2 .2])
% %annotation('arrow',[.1 .2],[.1 .2])

%pause
%exportgraphics(gcf,'OTA_corners_temperature.pdf','ContentType','vector')



