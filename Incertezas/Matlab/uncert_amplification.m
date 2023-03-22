%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Análise de incertezas do etapa de amplificação. Considera-se 
%incertezas nas resistências, capacitâncias e chaves. A tensão de entrada
%Vcs é um valor livre de incertezas
%Presume que todas as incertezas são independentes.
%Desconsidera correntes de fuga, corrente de polarização, tensão de offset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

points = 10000;

Ti = 250e-6;
Ta = 250e-6;
timestep = 1e-5;

Vcs = 5;
Ra = 10e3;
d_Ra = 0.1e3;

Rs = 82.5;
d_Rs = 17.5;

C = 1e-9;
d_C = 0.01e-9;

R = (Ra+Rs);
d_R = sqrt((d_Ra)^2 + (d_Rs)^2);

RC = R*C;

d_RC = sqrt((d_R/R)^2 + (d_C/C)^2)*RC;

Ra_sim = normrnd(Ra,d_Ra,[points 1]);
Rs_sim = normrnd(Rs,d_Rs,[points 1]);
C_sim = normrnd(C,d_C,[points 1]);

Ra_sim = max(Ra_sim,0);
Rs_sim = max(Rs_sim,0);
C_sim = max(C_sim,0);


t = [0:timestep:Ta];

s_ = std(Vcs*(1+t./(C_sim.*(Ra_sim+Rs_sim))));
sf_ = abs(-Vcs.*t./RC^2)*d_RC;
m_ = mean(Vcs*(1+t./(C_sim.*(Ra_sim+Rs_sim))));

fprintf('R %.2f +- %.2f Ohm \n',R,d_R);
fprintf('RC %.2f +- %.2f ns \n',RC*1e9,d_RC*1e9);

fprintf('C_sim %.2f +- %.2f nF \n',mean(C_sim)*1e9,std(C_sim)*1e9);
fprintf('Ra_sim %.2f +- %.2f Ohm \n',mean(Ra_sim),std(Ra_sim));
fprintf('Rs_sim %.2f +- %.2f Ohm \n',mean(Rs_sim),std(Rs_sim));


%%

figure
plot(t,s_);
hold on
plot(t,sf_);
errorbar(t,m_,s_);
hold off
legend('Incerteza simulada','Incerteza calculada','Média e desvio padrão simulado')
grid;



