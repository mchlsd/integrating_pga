%clear
%clc
%close all

r = 9.99e3;
rs = 82.5;
ra = r+rs;
ca = 1.01e-9;

ta = (5:5:240)*1e-6;

Go = 1+(ta/(r*ca));

%load('vo_vi.mat')

Go = Go(1:2:end);
mGain = mGain(1:2:end);
sGain = sGain(1:2:end);
sVi = sVi(1:2:end);
sVo = sVo(1:2:end);

sVoEq = sVi.*mGain;

pol = polyfit(mGain,sVo,1);
f1 = polyval(pol,mGain);

figure(1)
plot(Go,sVoEq,'-',mGain,sVo,'o',mGain,f1,':',mGain,sVi,':','lineWidth',2.5);
legend('\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(predicted)','\fontsize{10} \sigma_{\fontsize{6}{V_O}} \fontsize{7}(experimental)','\fontsize{10} \sigma_{\fontsize{6}{V_{O}}} \fontsize{7}(1st order fit)','\fontsize{10} \sigma_{\fontsize{6}{V_{i}}} \fontsize{7}(experimental)');
h1 = ylabel('Uncertainty, $\sigma$ (mV)','Interpreter','Latex')
h2 = xlabel('Measured Gain, $G_m$ (V/V)','Interpreter','Latex')
h1.FontSize=11;
h2.FontSize=11;
grid



pol = polyfit(Go,mGain,1);
f2 = polyval(pol,Go);
figure(2)
plot(Go,f2,':','color','red','linewidth',1);
txt = {sprintf('G_m = %0.1fG_o + %0.1f',pol(1), pol(2))};
text(1,25,txt)
ylabel('Measured gain, $G_m$','Interpreter','Latex');
xlabel(sprintf('Desired gain, $G_o$ ($V_{I}$ = %d mV)',mean(mVi)),'Interpreter','Latex');
hold on
errorbar(Go,mGain,sGain,'color','black','linewidth',1);
grid
hold off

figure(3);
plot(f2,100*(f2-mGain)./f2,'ko','linewidth',2);
grid
xlabel( sprintf('Adjusted gain (\\itV_i\\rm = %0.1f mV)',mean(mVi)),'Interpreter','Latex')
ylabel('Measured gain error (%)','Interpreter','Latex')
%set(f1,'position',[1*(wid + 10) 30+1*(hei + 90) wid hei])

