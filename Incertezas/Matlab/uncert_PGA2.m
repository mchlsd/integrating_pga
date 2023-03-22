%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Análise de incertezas do PGA, considerando incertezas nas resistências,
%capacitâncias e chaves.
%
%Equações CONSIDERAM aspectos reais da operação do circuito, como o fato
%que cada capacitor já deve estar em regime permanente quando usado por
%outras etapas do circuito, o que acaba por simplificar algumas equações.
%Presume que todas as incertezas são independentes.
%Desconsidera correntes de fuga, corrente de polarização, tensão de offset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc


% Definição dos periodos, passo da simulação e número de pontos
points = 10000;
Ti = 250e-6;
Ta = 250e-6;
To = 20e-6;
timestep = 1e-6;
t = [0:timestep:Ti];

%% Amostragem de entrada
%Mu e Sigma da tensão de entrada do circuito
e0 = 0.1;
d_e0 = 0.001;

%Mu e Sigma do Ron da chave Si1
Rs1 = 82.5;
d_Rs1 = 17.5;

%Mu e Sigma do Ron da chave Si3
Rs3 = 82.5;
d_Rs3 = 17.5;

%Mu e Sigma do capacitor Cs 
Cs = 47e-9;
d_Cs = 0.47e-9;

%Rs = Soma dos valores de Ron para as chaves Si1 e Si3 e calculo de sua incerteza
Rs = (Rs1+Rs3);
d_Rs = sqrt((d_Rs1)^2 + (d_Rs3)^2);

%RsCs = produto de Rs por Cs e calculo de sua incerteza
RsCs = Rs*Cs;
d_RsCs = sqrt((d_Rs/Rs)^2 + (d_Cs/Cs)^2)*RsCs;

%Conjunto de dados gerados aleatóriamente com distribuição normal para
%comprovar calculosas. (fonte e0, resistores Ron e Capacitor Cs)
e0_sim = normrnd(e0,d_e0,[points 1]);
Rs1_sim = normrnd(Rs1,d_Rs1,[points 1]);
Rs3_sim = normrnd(Rs3,d_Rs3,[points 1]);
Cs_sim = normrnd(Cs,d_Cs,[points 1]);
%Certificando que não existam números negativos
e0_sim = max(e0_sim,0);
Rs1_sim = max(Rs1_sim,0);
Rs3_sim = max(Rs3_sim,0);
Cs_sim = max(Cs_sim,0);

RsCs_sim = Cs_sim.*(Rs1_sim + Rs3_sim);

%Relatório da amostragem de entrada
fprintf('Rs %.2f +- %.2f Ohm \n',Rs,d_Rs);
fprintf('RsCs %.2f +- %.2f ns \n',RsCs*1e9,d_RsCs*1e9);
fprintf('Cs_sim %.2f +- %.2f nF \n',mean(Cs_sim)*1e9,std(Cs_sim)*1e9);
fprintf('Rs1_sim %.2f +- %.2f Ohm \n',mean(Rs1_sim),std(Rs1_sim));
fprintf('Rs3_sim %.2f +- %.2f Ohm \n',mean(Rs3_sim),std(Rs3_sim));

%% Amplificação

%Mu e Sigma do Resistor R 
R = 10e3;
d_R = 0.1e3;

%Mu e Sigma do Ron da chave Sa1 
Ra1 = 82.5;
d_Ra1 = 17.5;

%Mu e Sigma do capacitor Ca
Ca = 1e-9;
d_Ca = 0.01e-9;

%Ra = Soma dos valores de Ron para as chaves Sa1 e Ra e calculo de sua incerteza
Ra = (Ra1+R);
d_Ra = sqrt((d_R)^2 + (d_Ra1)^2);

%RaCa = produto de R por Ca e calculo de sua incerteza
RaCa = Ra*Ca;
d_RaCa = sqrt((d_Ra/Ra)^2 + (d_Ca/Ca)^2)*RaCa;

%Conjunto de dados gerados aleatóriamente com distribuição normal para
%comprovar calculos. (Resistor R, resistor Ron e Capacitor Ca)
R_sim = normrnd(R,d_R,[points 1]);
Ra1_sim = normrnd(Ra1,d_Ra1,[points 1]);
Ca_sim = normrnd(Ca,d_Ca,[points 1]);
%Certificando que não existam números negativos
R_sim = max(R_sim,0);
Ra1_sim = max(Ra1_sim,0);
Ca_sim = max(Ca_sim,0);

RaCa_sim = Ca_sim.*(R_sim + Ra1_sim);

%Relatório da amplificação
fprintf('R %.2f +- %.2f Ohm \n',Ra,d_Ra);
fprintf('RCa %.2f +- %.2f ns \n',RaCa*1e9,d_RaCa*1e9);
fprintf('Ca_sim %.2f +- %.2f nF \n',mean(Ca_sim)*1e9,std(Ca_sim)*1e9);
fprintf('Ra_sim %.2f +- %.2f Ohm \n',mean(R_sim),std(R_sim));
fprintf('Rsa1_sim %.2f +- %.2f Ohm \n',mean(Ra1_sim),std(Ra1_sim));

%% Amostragem de saída

%Mu e Sigma do Ron da chave So
Ro = 82.5;
d_Ro = 17.5;

%Mu e Sigma do capacitor Co
Co = 22e-9;
d_Co = 0.22e-9;

%RoCo = produto de Rso por Co e calculo de sua incerteza
RoCo = Ro*Co;
d_RoCo = sqrt((d_Ro/Ro)^2 + (d_Co/Co)^2)*RoCo;

%Conjunto de dados gerados aleatóriamente com distribuição normal para
%comprovar calculos. (Resistencia Ron de So e Capacitor Co)
Ro_sim = normrnd(Ro,d_Ro,[points 1]);
Co_sim = normrnd(Co,d_Co,[points 1]);
%Certificando que não existam números negativos
Ro_sim = max(Ro_sim,0);
Co_sim = max(Co_sim,0);
RoCo_sim = Ro_sim.*Co_sim;

%Relatório da amostragem de saída
fprintf('Rso %.2f +- %.2f Ohm \n',Ro,d_Ro);
fprintf('RsoCo %.2f +- %.2f ns \n',RoCo*1e9,d_RoCo*1e9);
fprintf('Co_sim %.2f +- %.2f nF \n',mean(Co_sim)*1e9,std(Co_sim)*1e9);
fprintf('Rs_sim %.2f +- %.2f Ohm \n',mean(Ro_sim),std(Ro_sim));





%% Plot

%Calculo de :
% sf_ : desvio padrão pelas regras de propagação de incertezas
%  s_ : desvios padrão obtidos por simulação
%  m_ : valores médios obtidos por simulação

eq1 = e0_sim;
eq2 = 1+(t./RaCa_sim);
eq3 = 1;
eq = eq1.*eq2.*eq3;

uncertain = sqrt(d_e0.^2.*(1+t./RaCa).^2+d_RaCa.^2.*e0.^2.*t.^2./RaCa.^4);

sf_ = uncertain; %d_Vf
s_ = std(eq);
m_ = mean(eq);


figure
plot(t,s_);
hold on
plot(t,sf_);
errorbar(t,m_,s_);
hold off
legend('Incerteza simulada','Incerteza calculada','Média e desvio padrão simulado')
grid;


