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
rs = 82.5;
ra = r+rs;
ca = 1e-9;

sra = sqrt((r*0.05)^2+(rs*0.21)^2);
sca = ca*0.05;

raca = ra*ca;
sraca = sqrt((sra/ra)^2+((sca/ca)^2))*raca;
sraca = raca*0.05;


svcs = ((sVcs22+sVcs21)/2)
mvcs = ((mVcs22+mVcs21)/2);

svo1 = sqrt( (svcs.^2).*((1+(ta./raca)).^2) + ( ((sraca.^2).*(mvcs.^2).*(ta.^2))/(raca.^4) ) )
svo2 = (1+(ta./(raca))).*svcs
svo3 = sVo22
svo4 = sVo21

figure
hold on
plot(svo1)
plot(svo2)
plot(svo3)
plot(svo4)
hold off