close all;
clear all;
clc;
warning('off','all')

% R = 246.6e3 + 2.7e3;
% C = 4.015e-12;
% v_input = 65;


%theta_list = 25e-6-[24e-6 20e-6 16e-6 12e-6 8e-6 6.097593e-06 4e-6 1.549193e-06 0.3935979e-06 0.1e-6];
%theta_list = 25e-6-[24e-6 16e-6 12e-6 8e-6 6.097593e-06 4e-6 1.549193e-06 0.3935979e-06 0.1e-6];
%theta_list = 25e-6-[0.1e-6 0.3935979e-06 1.549193e-06 4e-6 6.097593e-06 8e-6 12e-6 16e-6 20e-6 24e-6];

% gain_list = 1+((theta_list)/(R*C));
% tau_exp = (1/(R*C));


% ts = 1e-7; %MSPS
% pbc = 50e-6/ts; %points by cycle
% cycle=[0:2499]*pbc; % number of points in one cycle
% discard_cycle = 1;
% 
% t1=2; %transitory discard
% t2=0; %transitory discard
% t3=1; %transitory discard
% t4=1; %transitory discard

%%nom,ss,sf,fs,ff

load ('cg21_t4.mat')

Va_time = [table2array(Corner1cycletemperature1(2:end,1:2:6))];
Va_data = [table2array(Corner1cycletemperature1(2:end,2:2:6))];

Vout_time = [table2array(Corner1cycletemperature1(2:end,7:2:12))];
Vout_data = [table2array(Corner1cycletemperature1(2:end,8:2:12))];

Vcs_time = [table2array(Corner1cycletemperature1(2:end,13:2:18))];
Vcs_data = [table2array(Corner1cycletemperature1(2:end,14:2:18))];


% Va_time = fliplr(Va_time);
% Va_data = fliplr(Va_data);
% 
% Vout_time = fliplr(Vout_time);
% Vout_data = fliplr(Vout_data);
% 
% Vcs_time = fliplr(Vcs_time);
% Vcs_data = fliplr(Vcs_data);


% for j = 1:numel(theta_list)
%     
%     % Load dataset
%     theta = theta_list(j);%u
%     
%     % Prepare current data for processing       
%     a = round(pbc/2+cycle+t1); %amplification start
%     b = round(((theta+25e-6)/ts)+cycle-t2); %amplification stop
%     c = round(((theta+25e-6)/ts)+cycle+t3); %output sampling start
%     d = round(pbc+cycle-t4);%output sampling stop
%     
%     % Extract relevant data
%     % '2' means only selected part
%     tt2 = [];
%     Vi2 = [];
%     Vo2 = [];
%     rcs = [];
%     time = Va_time(:,j)';
%     Va = Va_data(:,j)';
%     Vo = Vout_data(:,j)';
%     Vi = Vcs_data(:,j)';
%     
%     %Descartando os primeiros 10 ciclos por conta da presença de RO no
%     %circuito
%     if discard_cycle>0
%     Vo = Vo(discard_cycle*pbc:end); 
%     Vi = Vi(discard_cycle*pbc:end);
%     time = time(discard_cycle*pbc:end);
%     end
%     for i=1:numel(cycle)-discard_cycle
%         %rcs(:,i) = Vi(round(pbc/2+cycle(i)))+cumtrapz((Vi(round(pbc/2+cycle(i)):round(((theta+25e-6)./ts)+cycle(i))))*(tau_exp*1e-6)./ts);
%         tt2(:,i) = [time(a(i):b(i))];
%         Vi2 = [Vi2 Vi(a(i):b(i))];
%         Vo2 = [Vo2 Vo(c(i):d(i))];
%     end
%         %rcs(:,i+1) = Vi(round(pbc/2+cycle(i+1)))+cumtrapz((Vi(round(pbc/2+cycle(i+1)):round((theta*rate)+cycle(i+1))))/(rate*1e6*tau_exp*1e-6));
%     
%     %Experimental gain previously obtained
%     expGain(j) = 1+((theta)*(tau_exp));
%     
%     %time
%     x = tt2(:,1)-tt2(1,1);
%     
%     expVo(:,j) = expGain(j)*Vi*1e3;
%     
%    
%     mVi(:,j) = mean(Vi)*1000;
%     sVi(:,j) = std(Vi)*1000;
%          
%     mVi2(:,j) = mean(Vi2*1e3);
%     sVi2(:,j) = std(Vi2*1e3);
%     
%     mVo(:,j) = mean(Vo*1e3);
%     sVo(:,j) = std(Vo*1e3);
%     
%     mVo2(:,j) = mean(Vo2*1e3);
%     sVo2(:,j) = std(Vo2*1e3);
%     
%     
%     % Calculating mean and std
%     mGain(j) = mean(Vo./Vi);
%     sGain(j) = std(Vo./Vi);
%     sGain_calc(j) = (sqrt((sVo(:,j)/mVo(:,j))^2 + (sVi(:,j)/mVi(:,j))^2))*mGain(:,j);
%     
%     mVo_calc(:,j) = mean(mGain(j)*Vi*1e3);
%     sVo_calc(:,j) = (sqrt((sGain(:,j)/mGain(j))^2 + (sVi(j)/mVi(j))^2))*mVo_calc(:,j);
%     
%     mExpVo(j) = mean(expVo(:,j));
%     sExpVo(j) = std(expVo(:,j));
%     
%     %mRcs(:,j) = mean(rcs(end,:)*1e3);
%     %sRcs(:,j) = std(rcs(end,:)*1e3);
% 
%     %Vi - Tensão diferencial sobre o capacitor de entrada
%     %Vi2 - Tensão diferencial sobre o capacitor de entrada, apenas no
%     %momento da integração
%     %Vo - Tensão de saída
%     %Vo2 - tensão de saída, entre o fim da integração e o inicio de um novo
%     %ciclo
%     %expVo - tensão de saída prevista pela equação de ganho usando o valor obtido
%     %experimentalmente para tau
%     %Vo_calc - tensão de saída usando 
%     %rcs - integração feita com os valores de Vi% Use regstats to calculate Cook's Distance
% 
%     
%     display(sprintf('Theta = %d', theta))
%     display(sprintf('Gain = %0.1f', gain_list(j)))
%     display(sprintf('Vi = %.4f +- %.4f mV',mVi(:,j), sVi(:,j)))
%     display(sprintf('Vi2 = %.4f +- %.4f mV',mVi2(:,j), sVi2(:,j)))
%     display(sprintf('Vo = %.4f +- %.4f mV',mVo(:,j), sVo(:,j)))
%     display(sprintf('Vo2 = %.4f +- %.4f mV',mVo2(:,j), sVo2(:,j)))
%     display(sprintf('expVo = %.4f +- %.4f mV',mExpVo(j), sExpVo(j)*1e3))
%     display(sprintf('Vo_calc = %.4f +- %.4f mV',mVo_calc(:,j), sVo_calc(:,j)*1e3))
%     display(sprintf('G = %.4f +- %.4f V/V',mGain(:,j), sGain(:,j)))
%     display(sprintf('G_calc = %.4f +- %.4f V/V\n\n',mGain(:,j), sGain_calc(:,j)))
%     %display(sprintf('rcs = %.4f +- %.4f mV\n\n',mRcs(:,j), sRcs(:,j)*1e3))    
%     %hold on
%     %plot(Vo)W
% end

%% Plot

% figure (1)
% subplot(2,2,[1 2]);
% errorbar(gain_list(1:end),mVi(1:end),sVi(1:end));
% title('\fontsize{15}{0} $\overline{V_{i}}$','Interpreter','Latex');
% ylabel('mV','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% 
% subplot(2,2,4);
% plot(gain_list(1:end),sVi(1:end));
% title('\fontsize{15}{0} $\overline{\sigma_{V_{i}}}$','Interpreter','Latex');
% ylabel('mV','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% 
% 
% subplot(2,2,3);
% plot(gain_list(1:end),((mVi(1:end)/v_input)-1)*100);
% title('\fontsize{15}{0} $\overline{V_{i}}$ Error (\%)','Interpreter','Latex');
% ylabel('%','FontSize',15)
% xlabel('Gain','FontSize',15)
% savefig(gcf,'Figure1.fig')
% 
% figure (2)
% 
% subplot(2,2,[1 2]);
% errorbar(gain_list(1:end),mVo(1:end),sVo(1:end));
% title('\fontsize{15}{0} $\overline{V_{o}}$','Interpreter','Latex');
% ylabel('mV','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% 
% subplot(2,2,3);
% plot(gain_list(1:end),((mVo(1:end)./(gain_list(1:end)*v_input))-1)*100);
% title('\fontsize{15}{0} $\overline{V_{o}}$ Error (\%)','Interpreter','Latex');
% ylabel('%','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% 
% subplot(2,2,4);
% plot(gain_list(1:end),sVo(1:end));
% title('\fontsize{15}{0} $\overline{\sigma_{V_{o}}}$','Interpreter','Latex');
% ylabel('mV','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% savefig(gcf,'Figure2.fig')
% 
% 
% figure (3)
% subplot(2,1,1);
% errorbar(gain_list(1:end),mGain(1:end),sGain(1:end));
% title('\fontsize{15}{0} $\overline{Gain}$ (Vo/Vi)','Interpreter','Latex');
% ylabel('V/V','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% 
% subplot(2,1,2);
% plot(gain_list(1:end),sGain(1:end));
% title('\fontsize{15}{0} $\overline{\sigma_{Gain}}$ (Vo/Vi)','Interpreter','Latex');
% ylabel('V/V','FontSize',15)
% xlabel('Gain','FontSize',15)
% grid
% 
% savefig(gcf,'Figure3.fig')

%save("vo_vi.mat")

%%ff,ss,tt
figure (1)
plot(Va_time(:,1)*1e6,Va_data(:,1),'-',Vout_time(:,1)*1e6,Vout_data(:,1),'--','LineWidth',1.5);
hold on
plot(Va_time(:,2)*1e6,Va_data(:,2),'-',Vout_time(:,2)*1e6,Vout_data(:,2),'--','LineWidth',1.5);
%plot(Va_time(:,3)*1e6,Va_data(:,3),'-',Vout_time(:,3)*1e6,Vout_data(:,3),'--','LineWidth',1.5,'Color','b');
%plot(Va_time(:,4)*1e6,Va_data(:,4),'-',Vout_time(:,4)*1e6,Vout_data(:,4),'--','LineWidth',1.5,'Color','y');
plot(Va_time(:,3)*1e6,Va_data(:,3),'-',Vout_time(:,3)*1e6,Vout_data(:,3),'--','LineWidth',1.5);
plot(Vcs_time(:,3)*1e6,Vcs_data(:,3),'-.','LineWidth',1.5);
hold off
legend('V_A ff @ 75{\circ}C','V_O ff @ 75{\circ}C','V_A ss @ -55{\circ}C','V_O ss @ -55{\circ}C','V_A tt @ 27{\circ}C','V_O tt @ 27{\circ}C','V_{Cs} = 65 mV','Location','North','Orientation','horizontal','Box','on','NumColumns',4,'FontSize',8)
ylabel('Tensão (V)','Interpreter','Latex')
xlabel('Tempo ($\mu$s)','Interpreter','Latex')
grid
set(gca,'FontSize',12)
set(gcf, 'Position',  [0, 1920, 523, 422])

%exportgraphics(gcf,'PGA_corners_g21.pdf','ContentType','vector')
