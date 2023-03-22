close all;
clear all;
clc;
warning('off','all')

R = 246.6e3 + 2.7e3;
C = 4.015e-12;
v_input = 65;


%theta_list = 25e-6-[24e-6 20e-6 16e-6 12e-6 8e-6 6.097593e-06 4e-6 1.549193e-06 0.3935979e-06 0.1e-6];
%theta_list = 25e-6-0.1e-6;
theta_list = 25e-6-[24e-6 18e-6 12e-6 6e-6 0.1e-6]

gain_list = 1+((theta_list)/(R*C));
tau_exp = (1/(R*C));

load ('data_corner.mat');

gain_frequency = table2array(cornergainOTA(:,1:2:10));
gain_data = table2array(cornergainOTA(:,2:2:10));

phase_frequency = table2array(cornerphaseOTA(:,1:2:10));
phase_data = table2array(cornerphaseOTA(:,2:2:10));


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


h1 = figure (1)
yyaxis left
set(gca,'YColor','k')
hold on
semilogx(gain_frequency(:,1),gain_data(:,1),'-','LineWidth',2,'Color',"#0072BD");
semilogx(gain_frequency(:,2),gain_data(:,2),'-','LineWidth',2,'Color',"#D95319");
semilogx(gain_frequency(:,3),gain_data(:,3),'-','LineWidth',2,'Color',"#EDB120");
semilogx(gain_frequency(:,4),gain_data(:,4),'-','LineWidth',2,'Color',"#7E2F8E");
semilogx(gain_frequency(:,5),gain_data(:,5),'-','LineWidth',2,'Color',"#77AC30");
hold off
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel('Ganho (dB)','FontSize',12)
xlabel('Frequência (Hz)','FontSize',12)
%legend('ss','sf','fs','ff','tt','Location','North','Orientation','horizontal','Box','on','AutoUpdate','off')
legend('tt','ss','sf','fs','ff','Location','North','Box','on','AutoUpdate','off')
grid
xlim([0 1e9])
%ylim([12 28])
set(gca, 'XScale', 'log')
ax = gca;

a1 = axes();
a1.Position = [0.2200 0.2200 0.2 0.2]; % xlocation, ylocation, xsize, ysize
semilogx(gain_frequency,gain_data,'LineWidth',1.5); axis tight
grid
xlim([0 1e4])
ylim([69.5 73.5])
set(gca,'FontSize',10)
%annotation('ellipse',[.2 .3 .2 .2])
%annotation('arrow',[.1 .2],[.1 .2])

axes(ax)
yyaxis right
set(gca,'YColor','k')
hold on
semilogx(phase_frequency(:,1),phase_data(:,1),'-','LineWidth',2,'Color',"#0072BD");
semilogx(phase_frequency(:,2),phase_data(:,2),'-','LineWidth',2,'Color',"#D95319");
semilogx(phase_frequency(:,3),phase_data(:,3),'-','LineWidth',2,'Color',"#EDB120");
semilogx(phase_frequency(:,4),phase_data(:,4),'-','LineWidth',2,'Color',"#7E2F8E");
semilogx(phase_frequency(:,5),phase_data(:,5),'-','LineWidth',2,'Color',"#77AC30");
hold off
%title('\fontsize{15}{0} $\overline{\sigma_{V_{i}}}$','Interpreter','Latex');
ylabel(['Fase (' char(176) ')'],'FontSize',12)
xlabel('Frequência (Hz)','FontSize',12)
set(gca, 'XScale', 'log')
xlim([0 1e9])
ylim([-200 100])
%grid
set(gca,'FontSize',12)
set(gcf, 'Position',  [0, 1920, 598, 430])
axes(a1)


%pause
%exportgraphics(gcf,'OTA_bode_corners.pdf','ContentType','vector')

% figure(2)
% r1 = [1:100]'.*rand(100,1);
% figure;
% a1 = axes();
% plot(a1,r1);
% a2 = axes();
% a2.Position = [0.3200 0.6600 0.2 0.2]; % xlocation, ylocation, xsize, ysize
% plot(a2,r1(50:70)); axis tight
% annotation('ellipse',[.2 .3 .2 .2])
% annotation('arrow',[.1 .2],[.1 .2])
% legend(a1,'u')
