close all
clear
load('OTALinearity.mat')
fs = 1e7;
num_eval_pts = 180;

R = 1e6;
C = 1e-12;
tau = 1/(R*C);

VI = linspace(0,1.8,num_eval_pts);

%Separando os dados e descartando pontos iniciais
Vi_time = table2array(OTALinearity(2:end,1:2:360));
Vi_data = table2array(OTALinearity(2:end,2:2:360));

Vout_time = table2array(OTALinearity(2:end,361:2:720));
Vout_data = table2array(OTALinearity(2:end,362:2:720));


%num_eval_pts = 100;
for i=1:num_eval_pts
    %Detecta o fim da integração
    dVout = diff(Vout_data(:,i));
    max_dVout =max(dVout);
    ind(i) = find(dVout<=0.8805*max_dVout,1);

    %Interpola
    y = Vout_data(1:ind(i),i);
    x = Vout_time(1:ind(i),i);
    p = polyfit(x,y,1);
    slope(i) = p(1);
    offset(i) = p(2);
end

% figure
% plot(dVout);
% xlim([0 100])

int_rate_over_vi = smoothdata(slope./VI)/1e6;

figure
plot(VI,(tau+0*VI)/1e6,VI,int_rate_over_vi,'--','LineWidth',1.5)
%title('OTA')
xlabel('{\it V_{in}} [V]')
ylabel('MV/s')
ylim([0.9 1.03])
xlim([0 1.4])
%legend('\tau','Taxa de Integração/ V_{in}')
grid
hold on

% i = find(int_rate_over_vi>=max(int_rate_over_vi),1);
% %Fit de 1ª ordem
% y = Vout_data(1:ind(i),i);
% x = Vout_time(1:ind(i),i);
% p = polyfit(x,y,1);
% f = polyval(p,x);
% error = f-y;
% 
% figure
% plot(x*1e6,error*1e3,'LineWidth',1.5)
% title('Linearity Error in Best Range')
% xlabel('{\it Time} [\mus]')
% ylabel('Error [mV]')
% grid
Linearity_Pre_Layout