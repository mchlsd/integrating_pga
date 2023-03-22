%close all;
clear all;
clc;
warning('off','all')

txtfile = "Va_Vo_TextOutput.txt";
fid = fopen(txtfile,'w');

theta_list = [265:5:490];
gain_list = 1+((theta_list-250)*1e-6/(10e3*1e-9));

rate = 0.5;%MSPS
pbc = 500*rate; %points by cycle
cycle=[0:24999]*pbc;% number of points in one cycle
discard_cycle = 10;
t1=3; %transitory discard
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
    tt2 = [];
    Va2 = [];
    Vo2 = [];
    time = time/1e6;
    %Descartando os primeiros 10 ciclos por conta da presença de RO no
    %circuito
    Va = Va(discard_cycle*pbc:end); 
    Vo = Vo(discard_cycle*pbc:end);
    time = time(discard_cycle*pbc:end);
    
    %Vo = Vo*0.96;
    
    for i=1:numel(cycle)-discard_cycle
        tt2(:,i) = [time(a(i):b(i))];
        Va2(:,i) = [Va(a(i):b(i))];
        Vo2 = [Vo2 Vo(c(i):d(i))];
        %plot(Vo(a(i):b(i)))
        %hold on
        %pause
    end
    
    % Compute inclination and offset of the slopes
    
    %time
    x = tt2(:,1)-tt2(1,1);
    
    %ideal slope
    po = polyfit(0:10e-6:250e-6 , 0.1:0.1:2.6 , 1);
    
    for i=1:numel(Va2(1,:))
        %data slope
        y = Va2(:,i);
        p = polyfit(x,y,1);
        slope(i) = p(1);
        %offset(i) = p(2);
        time_for_offset = -(t1:-1:0)*1e-6;
        f = polyval(p,time_for_offset);
        offset(i) = f(1);
        %First order 'f' difference to data 'y'
        %S = f-y;
        %max_NL_gain(i) = max(abs(S));
    end
    
    
    
    % Calculating mean and std
    mGslope(:,j) = mean(slope);
    sGslope(:,j) = std(slope);
    
    mGoffset(:,j) = mean(offset);
    sGoffset(:,j) = std(offset);
    
    mVo(:,j) = mean(Vo*1e3);
    sVo(:,j) = std(Vo*1e3);
    
    mVo2(:,j) = mean(Vo2*1e3);
    sVo2(:,j) = std(Vo2*1e3);
    

    
    display(sprintf('Theta = %d', theta))
    display(sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV',po(1)/1e3, (po(2)*1e3)))
    display(sprintf('Gslope = %.2f +- %.2f V/ms',mGslope(:,j)/1e3, sGslope(:,j)/1e3))
    display(sprintf('Goffset = %.2f +- %.2f mV', mGoffset(:,j)*1e3, sGoffset(:,j)*1e3))
    display(sprintf('EGslope = %.2f V/ms (%.3f%%)',(mGslope(:,j)-po(1))/1e3,((po(1)-mGslope(:,j))/po(1))*100))
    display(sprintf('EGoffset = %.2f mV (%.2f%%)',(mGoffset(:,j)-po(2))*1e3,((po(2)-mGoffset(:,j))/po(2))*100))
    display(sprintf('Vo = %.2f +- %.2f mV',mVo(:,j), sVo(:,j)))
    display(sprintf('Vo2 = %.2f +- %.2f mV\n\n',mVo2(:,j), sVo2(:,j)))
    
    fid = fopen(txtfile,'a+');
    fprintf(fid,sprintf('Theta = %d\n', theta));
    fprintf(fid,sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV\n',po(1)/1e3, (po(2)*1e3)));
    fprintf(fid,sprintf('Gslope = %.2f +- %.2f V/ms\n',mGslope(:,j)/1e3, sGslope(:,j)/1e3));
    fprintf(fid,sprintf('Goffset = %.2f +- %.2f mV\n', mGoffset(:,j)*1e3, sGoffset(:,j)*1e3));
    fprintf(fid,sprintf('EGslope = %.2f V/ms (%0.2f percent) \n',(mGslope(:,j)-po(1))/1e3,((po(1)-mGslope(:,j))/po(1))*100));
    fprintf(fid,sprintf('EGoffset = %.2f mV (%0.2f percent) \n',(mGoffset(:,j)-po(2))*1e3,((po(2)-mGoffset(:,j))/po(2))*100));
    fprintf(fid,sprintf('Vo = %.2f +- %.2f mV\n',mVo(:,j), sVo(:,j)));
    fprintf(fid,sprintf('Vo2 = %.2f +- %.2f mV\n\n',mVo2(:,j), sVo2(:,j)));
    fclose(fid);

end
%display(sprintf('Experimental RCa %.2f us\n\n',mean(RCa)));
%fid = fopen(txtfile,'a+');
%fprintf(fid,sprintf('Experimental RCa %.2f us\n\n',mean(RCa)));
%fclose(fid);
%% Plot

figure(1)
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
savefig(gcf,'Figure1.fig')

figure (2)
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
savefig(gcf,'Figure2.fig')
