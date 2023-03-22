%close all;
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

load ('diff_bode.mat');

gain_frequency = table2array(diff_bode(:,1:4:20));
gain_data = table2array(diff_bode(:,2:4:20));

phase_frequency = table2array(diff_bode(:,3:4:20));
phase_data = table2array(diff_bode(:,4:4:20));


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
semilogx(gain_frequency,db2mag(gain_data),'LineWidth',2);
%title('\fontsize{15}{0} Ganho','Interpreter','Latex');
ylabel('Ganho (V/V)','FontSize',12)
xlabel('Frequência (Hz)','FontSize',12)
xlim([0 10e3])
ylim([-20 40])
grid

set(gca,'FontSize',12)
set(gcf, 'Position',  [0, 1920, 523, 422])
pause
exportgraphics(gcf,'PGA_freq_diff.pdf','ContentType','vector')
