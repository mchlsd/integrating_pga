%close all;
clear all;
clc;

warning('off','all')

txtfile = "TextOutput.txt";
fid = fopen(txtfile,'w');

theta_list = [250:20:490];
gain_list = 1+((theta_list-250)*1e-6/(10e3*1e-9));

pbc = 10000; %points by cycle
cycle=[0:4]*pbc;
t1=50; %transitory discard
t2=10; %transitory discard

for j = 1:numel(theta_list)
    
    % Load dataset
    theta = theta_list(j);%u
    load (sprintf('../sim/%du.mat',theta));
    
    % Prepare current data for processing       
    a = pbc/2+cycle+t1; %amplification start
    b = (theta*20)+cycle-t1; %amplification stop
    c = (theta*20)+cycle+t2; %output sampling start
    d = pbc+cycle-t2;%output sampling stop
    
    if theta == 250
        b = a;
    end
    
    Vcs = Vcp-Vcn;
    Vo = Vo*1e3;
    Vcs = Vcs*1e3;
    % Extract relevant data
    tt2 = [];
    Va2 = [];
    Vo2 = [];
    Vp2 = [];
    Vcs2 = [];
    for i=1:numel(cycle)
        tt2 = [tt2 t(a(i):b(i),:)];
        Va2 = [Va2 Va(a(i):b(i),:)];
        Vo2 = [Vo2 Vo(c(i):d(i),:)];
        Vcs2 = [Vcs2 Vcs(a(i):b(i),:)];
    end
    
    % Compute inclination and offset of the slopes
    
    %time
    x = tt2(:,1)-tt2(1,1);
    
    %ideal slope
    po = polyfit(0:0.01e-3:0.25e-3,0.1:0.1:2.6,1);
    
    for i=1:numel(Va2(1,:))
        %data slope
        y = Va2(:,i);
        p = polyfit(x,y,1);
        slope(i) = p(1);
        offset(i) = p(2);
        f = polyval(p,x);
    end
    
    
    % Calculating mean and std
    mGslope(:,j) = mean(slope);
    sGslope(:,j) = std(slope);
    
    mGoffset(:,j) = mean(offset);
    sGoffset(:,j) = std(offset);

    Vo_col = reshape(Vo', [], 1);
    mVo(:,j) = mean(Vo_col);
    sVo(:,j) = std(Vo_col);

    Vo2_col = reshape(Vo2', [], 1);
    mVo2(:,j) = mean(Vo2_col);
    sVo2(:,j) = std(Vo2_col);
    
    Vcs2_col = reshape(Vcs2', [], 1);
    mVcs2(:,j) = mean(Vcs2_col);
    sVcs2(:,j) = std(Vcs2_col);

    Vcs_col = reshape(Vcs', [], 1);
    mVcs(:,j) = mean(Vcs_col);
    sVcs(:,j) = std(Vcs_col);

    mGain(:,j) = mean(Vo_col./Vcs_col);
    sGain(:,j) = std(Vo_col./Vcs_col);
    
    display(sprintf('Theta = %d', theta))
    display(sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV',po(1)/1e3, (po(2)*1e3)))
    display(sprintf('Gslope = %.2f +- %.2f V/ms',mGslope(:,j)/1e3, sGslope(:,j)/1e3))
    display(sprintf('Goffset = %.2f +- %.2f mV', mGoffset(:,j)*1e3, sGoffset(:,j)*1e3))
    display(sprintf('EGslope = %.2f V/ms (%.3f%%)',(mGslope(:,j)-po(1))/1e3,((po(1)-mGslope(:,j))/po(1))*100))
    display(sprintf('EGoffset = %.2f mV (%.2f%%)',(mGoffset(:,j)-po(2))*1e3,((po(2)-mGoffset(:,j))/po(2))*100))
    display(sprintf('G = %.4f +- %.4f V/V',mGain(:,j), sGain(:,j)))
    display(sprintf('Vcs = %.2f +- %.2f mV',mVcs(:,j), sVcs(:,j)))
    display(sprintf('Vcs2 = %.2f +- %.2f mV',mVcs2(:,j), sVcs2(:,j)))
    display(sprintf('Vo = %.2f +- %.2f mV',mVo(:,j), sVo(:,j)))
    display(sprintf('Vo2 = %.2f +- %.2f mV\n\n',mVo2(:,j), sVo2(:,j)))
    
    fid = fopen(txtfile,'a+');
    fprintf(fid,sprintf('Theta = %d\n', theta));
    fprintf(fid,sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV\n',po(1)/1e3, (po(2)*1e3)));
    fprintf(fid,sprintf('Gslope = %.2f +- %.2f V/ms\n',mGslope(:,j)/1e3, sGslope(:,j)/1e3));
    fprintf(fid,sprintf('Goffset = %.2f +- %.2f mV\n', mGoffset(:,j)*1e3, sGoffset(:,j)*1e3));
    fprintf(fid,sprintf('EGslope = %.2f V/ms (%0.2f percent) \n',(mGslope(:,j)-po(1))/1e3,((po(1)-mGslope(:,j))/po(1))*100));
    fprintf(fid,sprintf('EGoffset = %.2f mV (%0.2f percent) \n',(mGoffset(:,j)-po(2))*1e3,((po(2)-mGoffset(:,j))/po(2))*100));
    fprintf(fid,sprintf('G = %.4f +- %.4f V/V\n',mGain(:,j), sGain(:,j)));
    fprintf(fid,sprintf('Vcs = %.2f +- %.2f mV\n',mVcs(:,j), sVcs(:,j)));
    fprintf(fid,sprintf('Vcs2 = %.2f +- %.2f mV\n',mVcs2(:,j), sVcs2(:,j)));
    fprintf(fid,sprintf('Vo = %.2f +- %.2f mV\n',mVo(:,j), sVo(:,j)));
    fprintf(fid,sprintf('Vo2 = %.2f +- %.2f mV\n\n',mVo2(:,j), sVo2(:,j)));
    fclose(fid);
end

%% Plot

figure(6)
subplot(2,2,1);
errorbar(theta_list(1:end),mGslope(1:end)/1e3,sGslope(1:end)/1e3);
title('\fontsize{15}{0} $\overline{Gain_{slope}}$','Interpreter','Latex');
ylabel('V/ms','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
errorbar(theta_list(1:end),mGoffset(1:end)*1e3,sGoffset(1:end)*1e3);
title('\fontsize{15}{0} $\overline{Gain_{offset}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,2);
plot(theta_list(1:end),(mGslope(1:end)/po(1)-1)*100);
title('\fontsize{15}{0} $\overline{Gain_{slope}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),(mGoffset(1:end)/po(2)-1)*100);
title('\fontsize{15}{0} $\overline{Gain_{offset}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure6.fig')

figure (7)
subplot(2,2,1);
errorbar(theta_list(1:end),mVcs(1:end),sVcs(1:end));
title('\fontsize{15}{0} $\overline{V_{cs}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,2);
plot(theta_list(1:end),((mVcs(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{cs}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
errorbar(theta_list(1:end),mVcs2(1:end),sVcs2(1:end));
title('\fontsize{15}{0} $\overline{V_{cs2}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),((mVcs2(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{cs2}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure7.fig')

figure (8)
subplot(2,2,1);
errorbar(theta_list(1:end),mVo(1:end),sVo(1:end));
title('\fontsize{15}{0} $\overline{V_{o}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,2);
plot(theta_list(1:end),((mVo(1:end)./(gain_list(1:end)*100)-1))*100);
title('\fontsize{15}{0} $\overline{V_{o}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
errorbar(theta_list(1:end),mVo2(1:end),sVo2(1:end));
title('\fontsize{15}{0} $\overline{V_{o2}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),((mVo2(1:end)./(gain_list(1:end)*100))-1)*100);
title('\fontsize{15}{0} $\overline{V_{o2}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure8.fig')

figure (9)

subplot(2,2,[1 2]);
errorbar(theta_list(1:end),mVo(1:end),sVo(1:end));
title('\fontsize{15}{0} $\overline{V_{o}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
plot(theta_list(1:end),((mVo(1:end)./(gain_list(1:end)*100))-1)*100);
title('\fontsize{15}{0} $\overline{V_{o}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),mVo(1:end)-(gain_list(1:end)*100));
title('\fontsize{15}{0} $\overline{V_{o}}$ Error (mV)','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure9.fig')

figure (10)
plot(t(1:pbc*2),Vcs(1:pbc*2)/1e3);
title('\fontsize{15}{0} $V_{Cs}$ Error (mV)','Interpreter','Latex');
ylabel('Voltage','FontSize',15)
xlabel('time','FontSize',15)
grid
savefig(gcf,'Figure10.fig')

%% Plot
figure (1)
subplot(2,2,[1 2]);
errorbar(theta_list(1:end),mVcs(1:end),sVcs(1:end));
title('\fontsize{15}{0} $\overline{V_{cs}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),sVcs(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{V_{cs}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid


subplot(2,2,3);
plot(theta_list(1:end),((mVcs(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{cs}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
savefig(gcf,'Figure1.fig')


figure(2)
subplot(2,2,[1 2]);
errorbar(theta_list(1:end),mVcs2(1:end),sVcs2(1:end));
title('\fontsize{15}{0} $\overline{V_{C_{S2}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),sVcs2(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{V_{C_{S2}}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
plot(theta_list(1:end),((mVcs2(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{C_{S2}}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
savefig(gcf,'Figure2.fig')


figure (3)

subplot(2,2,[1 2]);
errorbar(theta_list(1:end),mVo(1:end),sVo(1:end));
title('\fontsize{15}{0} $\overline{V_{o}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
plot(theta_list(1:end),((mVo(1:end)./(gain_list(1:end)*100))-1)*100);
title('\fontsize{15}{0} $\overline{V_{o}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),sVo(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{V_{o}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure3.fig')

figure (4)

subplot(2,2,[1 2]);
errorbar(theta_list(1:end),mVo2(1:end),sVo2(1:end));
title('\fontsize{15}{0} $\overline{V_{o2}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
plot(theta_list(1:end),((mVo2(1:end)./(gain_list(1:end)*100))-1)*100);
title('\fontsize{15}{0} $\overline{V_{o2}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),sVo2(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{V_{o2}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure4.fig')

figure (5)
subplot(2,1,1);
errorbar(theta_list(1:end),mGain(1:end),sGain(1:end));
title('\fontsize{15}{0} $\overline{Gain}$ (Vo/Vi)','Interpreter','Latex');
ylabel('V/V','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,1,2);
plot(theta_list(1:end),sGain(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{Gain}}$ (Vo/Vcs)','Interpreter','Latex');
ylabel('V/V','FontSize',15)
xlabel('\theta','FontSize',15)
grid

savefig(gcf,'Figure5.fig')