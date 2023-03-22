%close all;
clear all;
clc;
warning('off','all')

R = 246.6e3 + 2.7e3;
C = 4.015e-12;
theta = 25e-6-[16e-6];

v_input_list = linspace(18,153,6);

tau_exp = (1/(R*C));
gain = 1+((theta)*tau_exp);

Vo_ideal = gain*v_input_list;


ts = 1e-7; %MSPS
pbc = 50e-6/ts; %points by cycle
cycle=[0:999]*pbc; % number of points in one cycle
discard_cycle = 1;

t1=2; %transitory discard
t2=0; %transitory discard
t3=1; %transitory discard
t4=1; %transitory discard

load ('diffg10.mat');

Va_time = [table2array(diffg1018180(2:end,1:2:14))];
Va_data = [table2array(diffg1018180(2:end,2:2:14))];

Vout_time = [table2array(diffg1018180(2:end,15:2:28))];
Vout_data = [table2array(diffg1018180(2:end,16:2:28))];

Vcs_time = [table2array(diffg1018180(2:end,29:2:42))];
Vcs_data = [table2array(diffg1018180(2:end,30:2:42))];


for j = 1:numel(v_input_list)
    
    % Load dataset
    v_input = v_input_list(j);%u
    
    % Prepare current data for processing       
    a = round(pbc/2+cycle+t1); %amplification start
    b = round(((theta+25e-6)/ts)+cycle-t2); %amplification stop
    c = round(((theta+25e-6)/ts)+cycle+t3); %output sampling start
    d = round(pbc+cycle-t4);%output sampling stop
    
    % Extract relevant data
    % '2' means only selected part
    tt2 = [];
    Vi2 = [];
    Vo2 = [];
    rcs = [];
    time = Va_time(:,j)';
    Va = Va_data(:,j)';
    Vo = Vout_data(:,j)';
    Vi = Vcs_data(:,j)';
    
    %Descartando os primeiros 10 ciclos por conta da presença de RO no
    %circuito
    if discard_cycle>0
    Vo = Vo(discard_cycle*pbc:end); 
    Vi = Vi(discard_cycle*pbc:end);
    time = time(discard_cycle*pbc:end);
    end
    for i=1:numel(cycle)-discard_cycle
        rcs(:,i) = Vi(round(pbc/2+cycle(i)))+cumtrapz((Vi(round(pbc/2+cycle(i)):round(((theta+25e-6)./ts)+cycle(i))))*(tau_exp*1e-6)./ts);
        tt2(:,i) = [time(a(i):b(i))];
        Vi2 = [Vi2 Vi(a(i):b(i))];
        Vo2 = [Vo2 Vo(c(i):d(i))];
    end
        %rcs(:,i+1) = Vi(round(pbc/2+cycle(i+1)))+cumtrapz((Vi(round(pbc/2+cycle(i+1)):round((theta*rate)+cycle(i+1))))/(rate*1e6*tau_exp*1e-6));
    
    %Experimental gain previously obtained
    expGain(j) = 1+((theta)*(tau_exp));
    
    %time
    x = tt2(:,1)-tt2(1,1);
    
    expVo(:,j) = expGain(j)*Vi*1e3;
    
   
    mVi(:,j) = mean(Vi)*1000;
    sVi(:,j) = std(Vi)*1000;
         
    mVi2(:,j) = mean(Vi2*1e3);
    sVi2(:,j) = std(Vi2*1e3);
    
    mVo(:,j) = mean(Vo*1e3);
    sVo(:,j) = std(Vo*1e3);
    
    mVo2(:,j) = mean(Vo2*1e3);
    sVo2(:,j) = std(Vo2*1e3);
    
    
    % Calculating mean and std
    mGain(j) = mean(Vo./Vi);
    sGain(j) = std(Vo./Vi);
    sGain_calc(j) = (sqrt((sVo(:,j)/mVo(:,j))^2 + (sVi(:,j)/mVi(:,j))^2))*mGain(:,j);
    
    mVo_calc(:,j) = mean(mGain(j)*Vi*1e3);
    sVo_calc(:,j) = (sqrt((sGain(:,j)/mGain(j))^2 + (sVi(j)/mVi(j))^2))*mVo_calc(:,j);
    
    mExpVo(j) = mean(expVo(:,j));
    sExpVo(j) = std(expVo(:,j));
    
    mRcs(:,j) = mean(rcs(end,:)*1e3);
    sRcs(:,j) = std(rcs(end,:)*1e3);

    %Vi - Tensão diferencial sobre o capacitor de entrada
    %Vi2 - Tensão diferencial sobre o capacitor de entrada, apenas no
    %momento da integração
    %Vo - Tensão de saída
    %Vo2 - tensão de saída, entre o fim da integração e o inicio de um novo
    %ciclo
    %expVo - tensão de saída prevista pela equação de ganho usando o valor obtido
    %experimentalmente para tau
    %Vo_calc - tensão de saída usando 
    %rcs - integração feita com os valores de Vi% Use regstats to calculate Cook's Distance

    
    display(sprintf('Theta = %d', theta))
    display(sprintf('Gain = %0.1f', gain))
    display(sprintf('Vi = %.4f +- %.4f mV',mVi(:,j), sVi(:,j)))
    display(sprintf('Vi2 = %.4f +- %.4f mV',mVi2(:,j), sVi2(:,j)))
    display(sprintf('Vo = %.4f +- %.4f mV',mVo(:,j), sVo(:,j)))
    display(sprintf('Vo2 = %.4f +- %.4f mV',mVo2(:,j), sVo2(:,j)))
    display(sprintf('expVo = %.4f +- %.4f mV',mExpVo(j), sExpVo(j)*1e3))
    display(sprintf('Vo_calc = %.4f +- %.4f mV',mVo_calc(:,j), sVo_calc(:,j)*1e3))
    display(sprintf('G = %.4f +- %.4f V/V',mGain(:,j), sGain(:,j)))
    display(sprintf('G_calc = %.4f +- %.4f V/V',mGain(:,j), sGain_calc(:,j)))
    display(sprintf('rcs = %.4f +- %.4f mV\n\n',mRcs(:,j), sRcs(:,j)*1e3))    
    %hold on
    %plot(Vo)
end

%% Plot

% figure (1)
% subplot(2,2,[1 2]);
% errorbar(v_input_list(1:end),mVi(1:end),sVi(1:end));
% title('\fontsize{15}{0} $\overline{V_{i}}$','Interpreter','Latex');
% ylabel('Tensão Diferencial Medida (mV)','FontSize',10)
% xlabel('Tensão Diferencial Ideal (mV)','FontSize',10)
% grid
% 
% subplot(2,2,4);
% plot(v_input_list(1:end),sVi(1:end));
% title('\fontsize{15}{0} $\overline{\sigma_{V_{i}}}$','Interpreter','Latex');
% ylabel('Incerteza da Tensão Diferencial Medida (mV)','FontSize',10)
% xlabel('Tensão Diferencial Ideal(mV)','FontSize',10)
% grid
% 
% 
% subplot(2,2,3);
% plot(v_input_list,((mVi./v_input_list)-1)*100);
% title('\fontsize{15}{0} $\overline{V_{i}}$ Error (\%)','Interpreter','Latex');
% ylabel('Erro da Tensão Diferencial Medida (%)','FontSize',10)
% xlabel('Tensão Diferencial Ideal(mV)','FontSize',10)
% savefig(gcf,'Figure1.fig')
% 
% figure (2)
% 
% subplot(2,2,[1 2]);
% errorbar(v_input_list(1:end),mVo(1:end),sVo(1:end));
% title('\fontsize{15}{0} $\overline{V_{o}}$','Interpreter','Latex');
% ylabel('Tensão de Saída (mV)','FontSize',10)
% xlabel('Tensão Diferencial de Entrada(mV)','FontSize',10)
% grid
% 
% subplot(2,2,3);
% plot(v_input_list(1:end),((mVo(1:end)./(v_input_list(1:end)*gain))-1)*100);
% title('\fontsize{15}{0} $\overline{V_{o}}$ Error (\%)','Interpreter','Latex');
% ylabel('Erro da tensão de saída (%)','FontSize',10)
% xlabel('Tensão Diferencial de Entrada(mV)','FontSize',10)
% grid
% 
% subplot(2,2,4);
% plot(v_input_list(1:end),sVo(1:end));
% title('\fontsize{15}{0} $\overline{\sigma_{V_{o}}}$','Interpreter','Latex');
% ylabel('Incerteza da Tensão de Saída (mV)','FontSize',10)
% xlabel('Tensão Diferencial de Entrada(mV)','FontSize',10)
% grid
% savefig(gcf,'Figure2.fig')
% 
% 
% figure (3)
% subplot(2,1,1);
% errorbar(v_input_list(1:end),mGain(1:end),sGain(1:end));
% title('\fontsize{15}{0} $\overline{Gain}$ (Vo/Vi)','Interpreter','Latex');
% ylabel('Ganho (V/V)','FontSize',10)
% xlabel('Tensão Diferencial de Entrada(mV)','FontSize',10)
% grid
% 
% subplot(2,1,2);
% plot(v_input_list(1:end),sGain(1:end));
% title('\fontsize{15}{0} $\overline{\sigma_{Gain}}$ (Vo/Vi)','Interpreter','Latex');
% ylabel('Incerteza de Ganho (V/V)','FontSize',10)
% xlabel('Tensão Diferencial de Entrada(mV)','FontSize',10)
% grid
% 
% savefig(gcf,'Figure3.fig')
% 
% %save("vo_vi.mat")


%%
figure (1)

plot(v_input_list, gain+0*v_input_list,"--",'LineWidth',1.5,'Color','r');
hold on
errorbar(v_input_list(1:end),mGain(1:end),sGain(1:end),'LineWidth',1.5,'Color','k');
hold off
%title('\fontsize{15}{0} $\overline{Gain}$ (Vo/Vi)','Interpreter','Latex');
ylabel('Ganho (V/V)','FontSize',12)
xlabel('Tensão Diferencial de Entrada(mV)','FontSize',12)
legend('Ideal','Medido')
ylim([9.5 10.5])
grid
set(gca,'FontSize',12)
set(gcf, 'Position',  [0, 1920, 522, 422])
%set(gcf,'Resize','off')
pause
exportgraphics(gcf,'G10_diff.pdf','ContentType','vector')



pol = polyfit(Vo_ideal,mVo,1);
f2 = polyval(pol,Vo_ideal);

figure (2)
plot(v_input_list(1:end),f2,':','LineWidth',3,'Color','r');
txt = {sprintf('V_{O_{Medido}} = %0.2fV_{O_{Ideal}} + %0.1f',pol(1), pol(2))};
text(1,25,txt)
hold on
errorbar(v_input_list(1:end),mVo(1:end),sVo(1:end),'LineWidth',1.5,'Color','b');
hold off
%title('\fontsize{15}{0} $\overline{V_{o}}$','Interpreter','Latex');
ylabel('Tensão de Saída (mV)','FontSize',10)
xlabel('Tensão Diferencial de Entrada(mV)','FontSize',10)
legend('Ideal', 'Medido')
grid
set(gca,'FontSize',12)
set(gcf, 'Position',  [522, 1920, 523, 422])
pause
exportgraphics(gcf,'Vo_G10_diff.pdf','ContentType','vector')
