%close all;
clear all;
clc;
warning('off','all')

txtfile = "Vo_Vi_TextOutput.txt";
fid = fopen(txtfile,'w');

theta_list = [255:5:490];
gain_list = 1+((theta_list-250)*1e-6/(10e3*1e-9));
tau_exp = 9.97;

rate = 0.5; %MSPS
pbc = 500*rate; %points by cycle
cycle=[0:2499]*pbc; % number of points in one cycle
discard_cycle = 10;

t1=2*rate; %transitory discard
t2=2*rate; %transitory discard
t3=2*rate; %transitory discard
t4=2*rate; %transitory discard

for j = 1:numel(theta_list)
    
    % Load dataset
    theta = theta_list(j);%u
    load (sprintf('exp0/%d.mat',theta));
    
    % Prepare current data for processing       
    a = round(pbc/2+cycle+t1); %amplification start
    b = round((theta*rate)+cycle-t2); %amplification stop
    c = round((theta*rate)+cycle+t3); %output sampling start
    d = round(pbc+cycle-t4);%output sampling stop
    
    if theta == 250
        b = a;
    end
    
    % Extract relevant data
    % '2' means only selected part
    tt2 = [];
    Vi2 = [];
    Vo2 = [];
    rcs = [];
    time = time/1e6;
    %Descartando os primeiros 10 ciclos por conta da presença de RO no
    %circuito
    Vo = Vo(discard_cycle*pbc:end); 
    Vi = Vi(discard_cycle*pbc:end);
    time = time(discard_cycle*pbc:end);
    
    for i=1:numel(cycle)-discard_cycle
        rcs(:,i) = Vi(round(pbc/2+cycle(i)))+cumtrapz((Vi(round(pbc/2+cycle(i)):round((theta*rate)+cycle(i))))/(rate*1e6*tau_exp*1e-6));
        tt2(:,i) = [time(a(i):b(i))];
        Vi2 = [Vi2 Vi(a(i):b(i))];
        Vo2 = [Vo2 Vo(c(i):d(i))];
    end
        %rcs(:,i+1) = Vi(round(pbc/2+cycle(i+1)))+cumtrapz((Vi(round(pbc/2+cycle(i+1)):round((theta*rate)+cycle(i+1))))/(rate*1e6*tau_exp*1e-6));
    
    %Experimental gain previously obtained
    expGain(j) = 1+((theta-250)/(tau_exp));
    
    %time
    x = tt2(:,1)-tt2(1,1);
    
    expVo(:,j) = expGain(j)*Vi*1e3;
    
   
    mVi(:,j) = mean(Vi)*1000;
    sVi(:,j) = std(Vi)*1000;
         
    mVi2(:,j) = mean(Vi2*1e3);
    sVi2(:,j) = std(Vi2*1e3);
    
    mVo(:,j) = mean(Vo*1e3);
    sVo(:,j) = std(Vo*1e3);
    
    mVo2(:,j) = mean(Vo2*1e3);
    sVo2(:,j) = std(Vo2*1e3);
    
    
    % Calculating mean and std
    mGain(j) = mean(Vo./Vi);
    sGain(j) = std(Vo./Vi);
    sGain_calc(j) = (sqrt((sVo(:,j)/mVo(:,j))^2 + (sVi(:,j)/mVi(:,j))^2))*mGain(:,j);
    
    mVo_calc(:,j) = mean(mGain(j)*Vi*1e3);
    sVo_calc(:,j) = (sqrt((sGain(:,j)/mGain(j))^2 + (sVi(j)/mVi(j))^2))*mVo_calc(:,j);
    
    mExpVo(j) = mean(expVo(:,j));
    sExpVo(j) = std(expVo(:,j));
    
    mRcs(:,j) = mean(rcs(end,:)*1e3);
    sRcs(:,j) = std(rcs(end,:)*1e3);

    %Vi - Tensão diferencial sobre o capacitor de entrada
    %Vi2 - Tensão diferencial sobre o capacitor de entrada, apenas no
    %momento da integração
    %Vo - Tensão de saída
    %Vo2 - tensão de saída, entre o fim da integração e o inicio de um novo
    %ciclo
    %expVo - tensão de saída prevista pela equação de ganho usando o valor obtido
    %experimentalmente para tau
    %Vo_calc - tensão de saída usando 
    %rcs - integração feita com os valores de Vi% Use regstats to calculate Cook's Distance

    
    display(sprintf('Theta = %d', theta))
    display(sprintf('Vi = %.4f +- %.4f mV',mVi(:,j), sVi(:,j)))
    display(sprintf('Vi2 = %.4f +- %.4f mV',mVi2(:,j), sVi2(:,j)))
    display(sprintf('Vo = %.4f +- %.4f mV',mVo(:,j), sVo(:,j)))
    display(sprintf('Vo2 = %.4f +- %.4f mV',mVo2(:,j), sVo2(:,j)))
    display(sprintf('expVo = %.4f +- %.4f mV',mExpVo(j), sExpVo(j)*1e3))
    display(sprintf('Vo_calc = %.4f +- %.4f mV',mVo_calc(:,j), sVo_calc(:,j)*1e3))
    display(sprintf('G = %.4f +- %.4f V/V',mGain(:,j), sGain(:,j)))
    display(sprintf('G_calc = %.4f +- %.4f V/V',mGain(:,j), sGain_calc(:,j)))
    display(sprintf('rcs = %.4f +- %.4f mV\n\n',mRcs(:,j), sRcs(:,j)*1e3))

    fid = fopen(txtfile,'a+');
    fprintf(fid,sprintf('Theta = %d\n', theta));
    fprintf(fid,sprintf('Vi = %.4f +- %.4f mV\n',mVi(:,j), sVi(:,j)));
    fprintf(fid,sprintf('Vi2 = %.4f +- %.4f mV\n',mVi2(:,j), sVi2(:,j)));
    fprintf(fid,sprintf('Vo = %.4f +- %.4f mV\n',mVo(:,j), sVo(:,j)*1e3));
    fprintf(fid,sprintf('Vo2 = %.4f +- %.4f mV\n',mVo2(:,j), sVo2(:,j)*1e3));
    fprintf(fid,sprintf('expVo = %.4f +- %.4f mV\n',mExpVo(j), sExpVo(j)*1e3));
    fprintf(fid,sprintf('Vo_calc = %.4f +- %.4f mV\n',mVo_calc(:,j), sVo_calc(:,j)*1e3));
    fprintf(fid,sprintf('G = %.4f +- %.4f V/V\n',mGain(:,j), sGain(:,j)));
    fprintf(fid,sprintf('G_calc = %.4f +- %.4f V/V\n',mGain(:,j), sGain_calc(:,j)));
    fprintf(fid,sprintf('rcs = %.4f +- %.4f mV\n\n',mRcs(:,j), sRcs(:,j)*1e3));
    fclose(fid);
    
    %hold on
    %plot(Vo)
end

%% Plot

figure (1)
subplot(2,2,[1 2]);
errorbar(theta_list(1:end),mVi(1:end),sVi(1:end));
title('\fontsize{15}{0} $\overline{V_{i}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,2,4);
plot(theta_list(1:end),sVi(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{V_{i}}}$','Interpreter','Latex');
ylabel('mV','FontSize',15)
xlabel('\theta','FontSize',15)
grid


subplot(2,2,3);
plot(theta_list(1:end),((mVi(1:end)/100)-1)*100);
title('\fontsize{15}{0} $\overline{V_{i}}$ Error (\%)','Interpreter','Latex');
ylabel('%','FontSize',15)
xlabel('\theta','FontSize',15)
savefig(gcf,'Figure1.fig')

figure (2)

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
savefig(gcf,'Figure2.fig')


figure (3)
subplot(2,1,1);
errorbar(theta_list(1:end),mGain(1:end),sGain(1:end));
title('\fontsize{15}{0} $\overline{Gain}$ (Vo/Vi)','Interpreter','Latex');
ylabel('V/V','FontSize',15)
xlabel('\theta','FontSize',15)
grid

subplot(2,1,2);
plot(theta_list(1:end),sGain(1:end));
title('\fontsize{15}{0} $\overline{\sigma_{Gain}}$ (Vo/Vi)','Interpreter','Latex');
ylabel('V/V','FontSize',15)
xlabel('\theta','FontSize',15)
grid

savefig(gcf,'Figure3.fig')

save("vo_vi.mat")