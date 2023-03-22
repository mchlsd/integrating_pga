%clear
%clc
%close all

r = 246.6e3;
rs = 2.7e3;
ra = r+rs;
ca = 4.015e-12;

% r = 250e3;
% rs = 0;
% ra = r+rs;
% ca = 4e-12;

%ta = (5:5:240)*1e-6;
ta = theta_list(1:end)

Go = 1+(ta/(ra*ca));

%load('vo_vi.mat')

Go = Go(1:end-1);
mGain = mGain(1:end-1);
sGain = sGain(1:end-1);
sVi = sVi(1:end-1);
sVo = sVo(1:end-1);

sVoEq = sVi.*mGain;

pol = polyfit(mGain,sVo,1);
f1 = polyval(pol,mGain);

%%

figure(1)
plot(Go,sVoEq,'-',mGain,sVo,'o',mGain,f1,':',mGain,sVi,':','lineWidth',2.5);
legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(previsto)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(experimental)','\fontsize{10} \sigma_{\fontsize{6}{V_{O}}} \fontsize{7}(ajuste de 1ª ordem)','\fontsize{10} \sigma_{\fontsize{6}{V_{i}}} \fontsize{7}(experimental)');
h1 = ylabel('Incerteza, $\sigma$ (mV)','Interpreter','Latex')
h2 = xlabel('Ganho Medido, $G_m$ (V/V)','Interpreter','Latex')
h1.FontSize=11;
h2.FontSize=11;
grid
set(gca,'FontSize',12)
set(gcf, 'Position',  [0, 1920, 523, 422])
pause
exportgraphics(gcf,'1.pdf','ContentType','vector')



pol = polyfit(Go,mGain,1);
f2 = polyval(pol,Go);
figure(2)
plot(Go,f2,':','color','red','linewidth',1);
txt = {sprintf('G_m = %0.2fG_o + %0.1f',pol(1), pol(2))};
text(1,25,txt)
ylabel('Ganho Medido, $G_m$','Interpreter','Latex');
xlabel(sprintf('Ganho Desejado, $G_o$ ($V_{I}$ = %0.1f mV)',mean(mVi)),'Interpreter','Latex');
hold on
errorbar(Go,mGain,sGain,'color','black','linewidth',1);
grid
hold off
set(gca,'FontSize',12)
set(gcf, 'Position',  [522, 1920, 523, 422])
pause
exportgraphics(gcf,'2.pdf','ContentType','vector')

figure(3);
plot(f2,100*(f2-mGain)./f2,'ko','linewidth',2);
grid
xlabel( sprintf('Ganho Ajustado ($V_{I}$ = %0.1f mV)',mean(mVi)),'Interpreter','Latex')
ylabel('Erro de Ganho (%)','Interpreter','Latex')
%set(f1,'position',[1*(wid + 10) 30+1*(hei + 90) wid hei])
set(gca,'FontSize',12)
set(gcf, 'Position',  [1045, 1920, 523, 422])
pause
exportgraphics(gcf,'3.pdf','ContentType','vector')

figure(4);
plot(f2,(sGain./mGain)*100,'ko','linewidth',2);
grid
xlabel( sprintf('Ganho Ajustado ($V_{I}$ = %0.1f mV)',mean(mVi)),'Interpreter','Latex')
ylabel('Incerteza de Ganho (%)','Interpreter','Latex')
%set(f1,'position',[1*(wid + 10) 30+1*(hei + 90) wid hei])
ylim([0 0.5]);
set(gca,'FontSize',12)
set(gcf, 'Position',  [1568, 1920, 523, 422])
pause
exportgraphics(gcf,'4.pdf','ContentType','vector')

