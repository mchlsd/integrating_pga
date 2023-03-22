clear
clc

ta = (0:20:240)*1e-6;

load('monteC.mat')
G_std1 = G_std;
G_mean1 = G_mean;
Go1 = Go;
mVo21 = mVo2;
sVo21 = sVo2;
mVcs21 = mVcs;
sVcs21 = sVcs;

load('noCSNO.mat')
G_std2 = G_std;
G_mean2 = G_mean;
Go2 = Go;
mVo22 = mVo2;
sVo22 = sVo2;
mVcs22= mVcs;
sVcs22 = sVcs;

clear('G_std', 'G_mean', 'Go', 'mVo2', 'sVo2','mVcs', 'sVcs');


r = 10e3;
sr = 0;
rs = 82.5;
srs = 0;
mca = 1e-9;
sca = 0;
mvcs = 0.1;
svcs = 0.000208;


%{
r = 10e3;
sr = 0.05*r;
rs = 82.5;
srs = 0.21*rs;
mca = 1e-9;
sca = mca*0.05;
mvcs = 0.1;
svcs = 0.000208;
%}
ra = normrnd(r,sr,[1,10000])+normrnd(rs,srs,[1,10000]);
vcs = normrnd(mvcs,svcs,[1,10000]);
ca = normrnd(mca,sca,[1,10000]);


raca = ra.*ca;
sraca = std(raca);

G_mean = (G_mean2 + G_mean1)/2;

svo = sqrt( (std(vcs).^2).*(1+ta/mean(raca)).^2 + (((sraca^2).*(mean(vcs).^2).*(ta.^2))/(mean(raca)^4)));



figure(1)
plot(G_mean1,sVo21,'o',G_mean2,sVo22,'*','lineWidth',2);
legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(measured)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(measured)','\fontsize{10} \sigma_{\fontsize{6}{V_{C_S}}} \fontsize{7}(measured)');
h1 = ylabel('Uncertainty, $\sigma$ (mV)','Interpreter','Latex')
h2 = xlabel('Measured Gain, $G_m$ (V/V)','Interpreter','Latex')
h1.FontSize=11;
h2.FontSize=11;
grid

hold on
plot(G_mean,svo,'o','lineWidth',2);
%legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(predicted)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(measured)','\fontsize{10} \sigma_{\fontsize{6}{V_{C_S}}} \fontsize{7}(measured)');
%h1 = ylabel('Uncertainty, $\sigma$ (mV)','Interpreter','Latex')
%h2 = xlabel('Measured Gain, $G_m$ (V/V)','Interpreter','Latex')
%h1.FontSize=11;
%h2.FontSize=11;
%grid

r = 10e3;
rs = 82.5;
ra = r+rs;

sra = sqrt((10e3*0.05)^2+(82.5*0.21)^2);
G_mean = (G_mean2 + G_mean1)/2;

raca = 10e3*1e-9;
sraca = sqrt((sra/ra)^2+(0.05)^2)*raca;
svcs = ((sVcs22+sVcs21)/2)
mvcs = ((mVcs22+mVcs21)/2);
svo = sqrt( (((sraca^2).*(mvcs.^2).*(ta.^2))/(raca^4)));


plot(G_mean,svo,'o','lineWidth',2);
%legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(predicted)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(measured)','\fontsize{10} \sigma_{\fontsize{6}{V_{C_S}}} \fontsize{7}(measured)');
%h1 = ylabel('Uncertainty, $\sigma$ (mV)','Interpreter','Latex')
%h2 = xlabel('Measured Gain, $G_m$ (V/V)','Interpreter','Latex')
%h1.FontSize=11;
%h2.FontSize=11;
%grid
legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(simulated no io)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(simulated with io)','\fontsize{10} \sigma_{\fontsize{6}{V_{C_S}}} \fontsize{7}(matlab sim eq)','\fontsize{10} \sigma_{\fontsize{6}{V_{C_S}}} \fontsize{7}(sim eq)'     );
hold off