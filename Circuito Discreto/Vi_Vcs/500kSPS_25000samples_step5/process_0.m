%close all;
clear all;
clc;
warning('off','all')

txtfile = "Vi_Vcs_TextOutput.txt";
fid = fopen(txtfile,'w');

theta_list = [255:5:490];
rate = 0.5;%MSPS
pbc = 500*rate; %points by cycle
cycle=[0:24999]*pbc;% number of points in one cycle
discard_cycle = 1;
t1=2*rate+2; %transitory discard
t2=0; %transitory discard
t3=2*rate; %transitory discard
t4=2*rate; %transitory discard
Vcs3 = [];
for j = 1:numel(theta_list)
    
    % Load dataset
    theta = theta_list(j);%u
    load (sprintf('exp0/%d.mat',theta));
    
    % Prepare current data for processing       
    a = round(pbc/2+cycle+t1); %amplification start
    b = round((theta*rate)+cycle-t2); %amplification stop
    c = round((theta*rate)+cycle+t3); %output sampling start
    d = round(pbc+cycle-t4);%output sampling stop
    %e = [1 round(pbc+cycle-1)];
    e = [1 round(pbc/2+cycle-1)];
    
    if theta == 250
        b = a;
    end
    
    % Extract relevant data
    tt2 = [];
    Vi2 = [];
    Vcs2 = [];
    time = time/1e6;
    %Descartando os primeiros 10 ciclos por conta da presença de RO no
    %circuito
    Vi = Vi(discard_cycle*pbc:end); 
    Vcs = Vcs(discard_cycle*pbc:end);
    time = time(discard_cycle*pbc:end);
    
    Vi = Vi*0.96;
    
    for i=1:numel(cycle)-discard_cycle
        tt2(:,i) = [time(a(i):b(i))];
        Vi2 = [Vi2 Vi(e(i):a(i))];
        Vcs2 = [Vcs2 Vcs(a(i):b(i))];
    end
    
    %time
    x = tt2(:,1)-tt2(1,1);   
    
    % Calculating mean and std
    mVcs(:,j) = mean(Vcs*1e3);
    sVcs(:,j) = std(Vcs*1e3);
         
    mVcs2(:,j) = mean(Vcs2*1e3);
    sVcs2(:,j) = std(Vcs2*1e3);
    
    mVi(:,j) = mean(Vi*1e3);
    sVi(:,j) = std(Vi*1e3);
    
    mVi2(:,j) = mean(Vi2*1e3);
    sVi2(:,j) = std(Vi2*1e3);
    
    samples_over_theta_Vcs2(j) = numel(Vcs2);
    samples_over_theta_Vi2(j) = numel(Vi2);
    samples_over_theta_Vcs(j) = numel(Vcs);
    samples_over_theta_Vi(j) = numel(Vi);
    

    
    %Vcs - Tensão diferencial sobre o capacitor de entrada
    %Vcs2 - Tensão diferencial sobre o capacitor de entrada, apenas no
    %momento da integração
    %Vi - Tensão de entrada
    %Vi2 - tensão de entrada, durante a amostragem de entrada
    
    display(sprintf('Theta = %d', theta))
    display(sprintf('Vcs = %.4f +- %.4f mV',mVcs(:,j), sVcs(:,j)))
    display(sprintf('Vcs2 = %.4f +- %.4f mV',mVcs2(:,j), sVcs2(:,j)))
    display(sprintf('Vi = %.4f +- %.4f mV',mVi(:,j), sVi(:,j)))
    display(sprintf('Vi2 = %.4f +- %.4f mV \n\n',mVi2(:,j), sVi2(:,j)))
    
    fid = fopen(txtfile,'a+');
    fprintf(fid,sprintf('Theta = %d\n', theta));
    fprintf(fid,sprintf('Vcs = %.4f +- %.4f mV\n',mVcs(:,j)*1e3, sVcs(:,j)*1e3));
    fprintf(fid,sprintf('Vcs2 = %.4f +- %.4f mV\n',mVcs2(:,j)*1e3, sVcs2(:,j)*1e3));
    fprintf(fid,sprintf('Vi = %.4f +- %.4f mV\n',mVi(:,j)*1e3, sVi(:,j)*1e3));
    fprintf(fid,(sprintf('Vi2 = %.4f +- %.4f mV \n\n',mVi2(:,j)*1e3, sVi2(:,j)*1e3)));
    fclose(fid);
    %Vcs3 = [Vcs3 Vcs2];
end
%% Plot
figure(1)
subplot(2,2,1);
errorbar(theta_list(1:end),mVi(1:end),sVi(1:end));
title('\fontsize{15}{0} $\overline{V_{i}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,2);
plot(theta_list(1:end),((mVi(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{i}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
errorbar(theta_list(1:end),mVi2(1:end),sVi2(1:end));
title('\fontsize{15}{0} $\overline{V_{i2}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),((mVi2(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{i2}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure1.fig')

figure (2)
subplot(2,2,1);
errorbar(theta_list(1:end),mVcs(1:end),sVcs(1:end));
title('\fontsize{15}{0} $\overline{V_{C_{S}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,2);
plot(theta_list(1:end),((mVcs(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{C_{S}}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,3);
errorbar(theta_list(1:end),mVcs2(1:end),sVcs2(1:end));
title('\fontsize{15}{0} $\overline{V_{C_{S2}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),((mVcs2(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{C_{S2}}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
grid
savefig(gcf,'Figure2.fig')
% figure (3)
% subplot(2,2,1);
% plot(theta_list(1:end),samples_over_theta_Vi);
% title('\fontsize{15}{0} $V_i$','Interpreter','Latex');
% ylabel('samples')
% xlabel('\theta')
% grid
% 
% subplot(2,2,2);
% plot(theta_list(1:end),samples_over_theta_Vi2);
% title('\fontsize{15}{0} $V_{i2}$','Interpreter','Latex');
% ylabel('samples')
% xlabel('\theta')
% grid
% 
% subplot(2,2,3);
% plot(theta_list(1:end),samples_over_theta_Vcs);
% title('\fontsize{15}{0} $V_{C_{S}}$','Interpreter','Latex');
% ylabel('samples')
% xlabel('\theta')
% grid
% 
% subplot(2,2,4);
% plot(theta_list(1:end),samples_over_theta_Vcs2);
% title('\fontsize{15}{0} $V_{C_{S2}}$','Interpreter','Latex');
% ylabel('samples')
% xlabel('\theta')
% grid
