%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Análise de incertezas da etapa de amostragem de entrada. Considera-se 
%incertezas nas resistências, capacitâncias, chaves e tensão de entrada e0.
%Presume que todas as incertezas são independentes.
%Desconsidera correntes de fuga, corrente de polarização, tensão de offset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

points = 10000;

Ti = 250e-6;
Ta = 250e-6;
timestep = 1e-6;

e0 = 5;
d_e0 = 0.1;

R1 = 82.5;
d_R1 = 17.5;

R2 = 82.5;
d_R2 = 17.5;

C = 47e-9;
d_C = 0.47e-9;

R = (R1+R2);
d_R = sqrt((d_R1)^2 + (d_R2)^2);

RC = R*C;
d_RC = sqrt((d_R/R)^2 + (d_C/C)^2)*RC;

e0_sim = normrnd(e0,d_e0,[points 1]);
R1_sim = normrnd(R1,d_R1,[points 1]);
R2_sim = normrnd(R2,d_R2,[points 1]);
C_sim = normrnd(C,d_C,[points 1]);

e0_sim = max(e0_sim,0);
R1_sim = max(R1_sim,0);
R2_sim = max(R2_sim,0);
C_sim = max(C_sim,0);


t = [0:timestep:Ti];

s_ = std(e0_sim.*(1-exp(-t./(C_sim.*(R1_sim+R2_sim)))));
sf_ = sqrt( (d_e0^2)*(1-exp(-t/RC)).^2 + ((d_RC^2)*(e0^2).*(t.^2).*(exp(-t/RC)).^2)/RC^4 ); %d_V
m_ = mean(e0_sim.*(1-exp(-t./(C_sim.*(R1_sim+R2_sim)))));

fprintf('R %.2f +- %.2f Ohm \n',R,d_R);
fprintf('RC %.2f +- %.2f ns \n',RC*1e9,d_RC*1e9);

fprintf('C_sim %.2f +- %.2f nF \n',mean(C_sim)*1e9,std(C_sim)*1e9);
fprintf('R1_sim %.2f +- %.2f Ohm \n',mean(R1_sim),std(R1_sim));
fprintf('R2_sim %.2f +- %.2f Ohm \n',mean(R2_sim),std(R2_sim));


%%

figure
plot(t,s_);
hold on
plot(t,sf_);
errorbar(t,m_,s_);
hold off
legend('Incerteza simulada','Incerteza calculada','Média e desvio padrão simulado')
grid;


