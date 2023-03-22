%close all;
clear all;
clc;


theta_list = [470 490];%250 + [0:20:240];
pbc = 10000; %points by cycle
cycle=[0]*pbc;
t1=50; %transitory discard
t2=10; %transitory discard

Go = 1+(((theta_list-250)*1e-6)/(10e3*1e-9));

for j = 1:numel(theta_list)
    
    % Load dataset
    theta = theta_list(j);%u
    load (sprintf('../sim/%du.mat',theta));
    
    % Prepare current data for processing       
    a = 5000+cycle+t1; %amplification start
    b = (theta*20)+cycle-t1; %amplification stop
    c = (theta*20)+cycle+t2; %output sampling start
    d = pbc+cycle-t2;%output sampling stop
    
    if theta == 250
        b = a;
    end
    
    % Extract relevant data
    tt2 = [];
    Va2 = [];
    Vo2 = [];
    Vp2 = [];
    Vcs = [];
    for i=1:numel(cycle)
        tt2 = [tt2 t(a(i):b(i),:)];
        Va2 = [Va2 Va(a(i):b(i),:)];
        Vo2 = [Vo2 Vo(c(i):d(i),:)];
        Vp2 = [Vp2 Vp(a(i):d(i),:)];
        Vcs = [Vcs Vcp(a(i):b(i),:)-Vcn(a(i):b(i),:)];
    end
    
    
    
    % Compute inclination and offset of the slopes
    
    %time
    x = tt2(:,1)-1.25e-3;
    
    %ideal slope
    po = polyfit(0:0.01e-3:0.25e-3,0.1:0.1:2.6,1);
    
    for i=1:numel(Va2(1,:))
        %data slope
        y = Va2(:,i);
        p = polyfit(x,y,1);
        slope(i) = p(1);
        offset(i) = p(2);
        f = polyval(p,x);
        
        %First order 'f' difference to data 'y'
        S = f-y;
        max_NL_gain(i) = max(abs(S));
        %     display(sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV',po(1)/1e3, (po(2)*1e3)))
        %     display(sprintf('Gslope = %.2f V/ms | Goffset %.2f mV',p(1)/1e3, (p(2)*1e3)))
        %     display(sprintf('EGslope = %.2f V/ms (%.3f%%)',(p(1)-po(1))/1e3,((po(1)-p(1))/po(1))*100))
        %     display(sprintf('EGoffset = %.2f mV (%.2f%%)',(p(2)-po(2))*1e3,((po(2)-p(2))/po(2))*100))
        %     display(sprintf('Max Nonlinearity = %.2f uV\n\n',max_NL_gain(i)*1e6))
    end
    
    G = mean(Vo2)./mean(Vcs);
    G_mean(:,j) = mean(G);
    G_std(:,j) = std(G);
    
    % Calculating mean and std
    mGslope(:,j) = mean(slope);
    sGslope(:,j) = std(slope);
    
    mGoffset(:,j) = mean(offset);
    sGoffset(:,j) = std(offset);
    
    Vo2_col = reshape(Vo2', [], 1);
    mVo2(:,j) = mean(Vo2_col);
    sVo2(:,j) = std(Vo2_col);
    
    Vo_col = reshape(Vo', [], 1);
    mVo(:,j) = mean(Vo_col);
    sVo(:,j) = std(Vo_col);
    
    mMax_NL_gain(:,j) = mean(max_NL_gain);
    sMax_NL_gain(:,j) = mean(max_NL_gain);
    
    Vp2_col = reshape(Vp2', [], 1);
    mVp2(:,j) = mean(Vp2_col);
    sVp2(:,j) = std(Vp2_col);
    
    Vcs_col = reshape(Vcs', [], 1);
    mVcs(:,j) = mean(Vcs_col);
    sVcs(:,j) = std(Vcs_col);
    
    display(sprintf('Theta = %d', theta))
    display(sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV',po(1)/1e3, (po(2)*1e3)))
    display(sprintf('Gslope = %.2f +- %.2f V/ms',mGslope(:,j)/1e3, sGslope(:,j)/1e3))
    display(sprintf('Goffset = %.2f +- %.2f mV', mGoffset(:,j)*1e3, sGoffset(:,j)*1e3))
    display(sprintf('EGslope = %.2f V/ms (%.3f%%)',(mGslope(:,j)-po(1))/1e3,((po(1)-mGslope(:,j))/po(1))*100))
    display(sprintf('EGoffset = %.2f mV (%.2f%%)',(mGoffset(:,j)-po(2))*1e3,((po(2)-mGoffset(:,j))/po(2))*100))
    display(sprintf('Max Nonlinearity (mean in this theta) = %.2f uV',mMax_NL_gain(:,j)*1e6))
    display(sprintf('Max Nonlinearity (std in this theta) = %.2f uV\n\n',sMax_NL_gain(:,j)*1e6))
end

%% Plot
%{
subplot(3,2,1);
errorbar(theta_list(2:end),mGslope(2:end)/1e3,sGslope(2:end)/1e3);
title('$\overline{Gain_{slope}}$','Interpreter','Latex');
ylabel('V/ms')
xlabel('\theta')
grid

subplot(3,2,2);
errorbar(theta_list(2:end),mGoffset(2:end)*1e3,sGoffset(2:end)*1e3);
title('$\overline{Gain_{offset}}$','Interpreter','Latex');
ylabel('mV')
xlabel('\theta')
grid

subplot(3,2,3);
plot(theta_list(2:end),((po(1)-mGslope(2:end))/po(1))*100);
title('$\overline{Gain_{slope}} Error (\%)$','Interpreter','Latex');
ylabel('%')
xlabel('\theta')
grid

subplot(3,2,4);
plot(theta_list(2:end),((po(2)-mGoffset(2:end))/po(2))*100);
title('$\overline{Gain_{offset}} Error (\%) $','Interpreter','Latex');
ylabel('%')
xlabel('\theta')
grid

subplot(3,2,5);
errorbar(theta_list(2:end),mMax_NL_gain(2:end)*1e6,mMax_NL_gain(2:end)*1e6);
title('\it Max nonlinearity','FontWeight','Normal');
ylabel('\muV')
xlabel('\theta')
grid

subplot(3,2,6);
errorbar(theta_list(2:end),mVp2(2:end)*1e3,sVp2(2:end)*1e3);
title('$\overline{V_{p}}$','Interpreter','Latex');
ylabel('mV')
xlabel('\theta')
grid
%%

pol = polyfit(Go,G_mean,1);
slope(i) = pol(1);
offset(i) = pol(2);
f = polyval(pol,Go);



figure
errorbar(Go,G_mean,G_std,'color','black');
hold on
plot(Go,f,'color','black');
txt = {sprintf('G_m = %0.2fG_o + %0.2f',pol(1), pol(2))};
text(1,25,txt)
ylabel('Measured gain, $G_m$','Interpreter','Latex');
xlabel('Desired gain, $G_o$ ($V_{I}$ = 100 mV)','Interpreter','Latex');
grid
hold off



figure
plot(Go,G_std./G_mean,'color','black');

figure
plot(Go,G_std,'color','black');
%}
save('noCSNO.mat', 'G_std', 'G_mean', 'Go', 'mVo2', 'sVo2','mVo', 'sVo','mVcs', 'sVcs')
ta = (theta_list-250).*1e-6;

ra = 10; %KOhm 2/10
cs = 100; %nF
ca = 1; %nF
co = 10; %nF

r_tol = 0.05;
c_tol = 0.05;

sra = ra*r_tol;
scs = cs*c_tol; %nF
sca = ca*c_tol; %nF
sco = co*c_tol; %nF



R = ra*1e3;
C = ca*1e-9;
sRp = R*(1+r_tol);
sRn = R*(1-r_tol);
sCp = C*(1+c_tol);
sCn = C*(1-c_tol);

raca = R*C;
sraca = sqrt(r_tol^2+c_tol^2)*raca;

maxRCa = sRp*sCp;
minRCa = sRn*sCn;

maxVo = 0.1.*(1+(ta./minRCa))
idVo =  0.1.*(1+(ta./10e-06))
minVo = 0.1.*(1+(ta./maxRCa))

sigmaEq = sqrt((sVcs.^2).*(1+(ta./raca)).^2+(sraca^2*mVcs.^2.*ta.^2)/(raca).^4)

sVo
%sP = maxVo -idVo
%sN = idVo - minVo

plot(Vo2)