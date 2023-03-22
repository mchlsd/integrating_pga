%close all;
clear all;
clc;

theta_list = [250:10:490];
pbc = 10000; %points by cycle
cycle=[0:4]*pbc;
t1=50; %transitory discard
t2=10; %transitory discard

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
        Vcs = [Vcs Vcp(a(i):d(i),:)-Vcn(a(i):d(i),:)];
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
    
    
    % Calculating mean and std
    mGslope(:,j) = mean(slope);
    sGslope(:,j) = std(slope);
    
    mGoffset(:,j) = mean(offset);
    sGoffset(:,j) = std(offset);
    
    Vo2_col = reshape(Vo2', [], 1);
    mVo2(:,j) = mean(Vo2_col);
    sVo2(:,j) = std(Vo2_col);
    
    mMax_NL_gain(:,j) = mean(max_NL_gain);
    sMax_NL_gain(:,j) = mean(max_NL_gain);
    
    Vp2_col = reshape(Vp2', [], 1);
    mVp2(:,j) = mean(Vp2_col);
    sVp2(:,j) = std(Vp2_col);
    
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

figure
errorbar(theta_list(2:end),mVo2(2:end),sVo2(2:end));
title('$\overline{V_{p}}$','Interpreter','Latex');
ylabel('V')
xlabel('\theta')
grid
