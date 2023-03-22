%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Análise de incertezas do etapa de amostragem de saída. Considera-se 
%incertezas nas resistências, capacitâncias e chaves. A tensão de entrada
%Va é um valor livre de incertezas
%Presume que todas as incertezas são independentes.
%Desconsidera correntes de fuga, corrente de polarização, tensão de offset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

points = 10000;

To = 15e-6;
timestep = 1e-7;

Va = 5;
R = 82.5;
d_R = 17.5;

C = 22e-9;
d_C = 0.22e-9;

RC = R*C;

d_RC = sqrt((d_R/R)^2 + (d_C/C)^2)*RC;

R_sim = normrnd(R,d_R,[points 1]);
C_sim = normrnd(C,d_C,[points 1]);

R_sim = max(R_sim,0);
C_sim = max(C_sim,0);


t = [0:timestep:To];

s_ = std(Va*(1-exp(-t./(C_sim.*(R_sim)))));
sf_ = abs(-Va.*t.*exp(-t/RC)/RC^2)*d_RC;
m_ = mean(Va*(1-exp(-t./(C_sim.*(R_sim)))));

fprintf('R %.2f +- %.2f Ohm \n',R,d_R);
fprintf('RC %.2f +- %.2f ns \n',RC*1e9,d_RC*1e9);

fprintf('C_sim %.2f +- %.2f nF \n',mean(C_sim)*1e9,std(C_sim)*1e9);
fprintf('Rs_sim %.2f +- %.2f Ohm \n',mean(R_sim),std(R_sim));


%%

figure
plot(t,s_);
hold on
plot(t,sf_);
errorbar(t,m_,s_);
hold off
legend('Incerteza simulada','Incerteza calculada','Média e desvio padrão simulado')
grid;



