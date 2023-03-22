clear
clc

ta = (0:20:240)*1e-6;

load('full.mat')
G_std1 = G_std;
G_mean1 = G_mean;
Go1 = Go;
mVo1 = mVo;
sVo1 = sVo;
mVcs1 = mVcs;
sVcs1 = sVcs;

load('noCSNO.mat')
G_std2 = G_std;
G_mean2 = G_mean;
Go2 = Go;
mVo2 = mVo;
sVo2 = sVo;
mVcs2= mVcs;
sVcs2 = sVcs;

G_mean = (G_mean2 + G_mean1)/2
%clear('G_std', 'G_mean', 'Go', 'mVo2', 'sVo2','mVcs', 'sVcs');


r = 10e3;
rs = 82.5;
ra = r+rs;
ca = 1e-9;

sra = sqrt((r*0.05)^2+(rs*0.21)^2);
sca = ca*0.05;

raca = ra*ca;
sraca = sqrt((sra/ra)^2+((sca/ca)^2))*raca;
%sraca = raca*0.05;


svcs = ((sVcs2+sVcs1)/2);
mvcs = ((mVcs2+mVcs1)/2);

sVo1(9) = (sVo1(8)+sVo1(10))/2;

svo1 = sqrt( (svcs.^2).*((1+(ta./raca)).^2) + ( ((sraca.^2).*(mvcs.^2).*(ta.^2))/(raca.^4) ) )*1e3
svo2 = (1+(ta./(raca))).*svcs*1e3
svo3 = sVo2*1e3;
svo4 = sVo1*1e3;
svcs = svcs*1e3;

%figure(1)
plot(Go,svo1,'-',G_mean,svo3,'o',G_mean,svo4,'*',G_mean,svcs,':','lineWidth',2.5);
legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(predicted)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(simulation A)','\fontsize{10} \sigma_{\fontsize{6}{V_{O}}} \fontsize{7}(simulation B)','\fontsize{10} \sigma_{\fontsize{6}{V_{C_S}}} \fontsize{7}(simulations)');
h1 = ylabel('Uncertainty, $\sigma$ (mV)','Interpreter','Latex')
h2 = xlabel('Measured Gain, $G_m$ (V/V)','Interpreter','Latex')
h1.FontSize=11;
h2.FontSize=11;
grid
