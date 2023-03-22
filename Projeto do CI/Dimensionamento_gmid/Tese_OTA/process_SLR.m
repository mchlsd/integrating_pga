theta = 45;
pbc = 5000; %points by cycle
cycle=[0:199]*pbc;
t1=0; %transitory discard
t2=0; %transitory discard


for j = 1:numel(SLR)

    % Load dataset
    
    % Prepare current data for processing       
    a = 2500+cycle+t1; %amplification start
    b = (theta*100)+cycle-t1; %amplification stop
    c = (theta*100)+cycle+t2; %output sampling start
    d = pbc+cycle-t2;%output sampling stop
       
    % Extract relevant data
    tt2 = [];
    Va2 = [];
    Vcs2 = [];
    for i=1:numel(cycle)
        tt2 = [tt2 time(a(i):b(i),j)];
        Va2 = [Va2 Va(a(i):b(i),j)];
        Vcs2 =[Vcs2 Vcs(a(i):b(i),j)];
    end
    
    % Compute inclination and offset of the slopes
    
   
    
    %time
    tt2 = tt2-tt2(1,:);
    
    
    
    for i=1:numel(Va2(1,:))
        mvcs = mean(Vcs2(:,i));
        %ideal slope
        po = polyfit(0:1e-6:25e-6,mvcs:mvcs:(mvcs*26),1);
        
        %data slope
        y = Va2(3:end,i);
        x = tt2(3:end,i);
        p = polyfit(x,y,1);
        slope(i) = p(1);
        offset(i) = p(2);
        f = polyval(p,x);
        
        %First order 'f' difference to data 'y'
        %S = f-y;
        %max_NL_gain(i) = max(abs(S));
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
    
    
    display(sprintf('SLR = %0.1f', SLR(j)))
    display(sprintf('Goslope = %.2f V/ms | GoOffset %.2f mV',po(1)/1e3, (po(2)*1e3)))
    display(sprintf('Gslope = %.2f +- %.4f V/ms',mGslope(:,j)/1e3, sGslope(:,j)/1e3))
    display(sprintf('Goffset = %.2f +- %.4f mV', mGoffset(:,j)*1e3, sGoffset(:,j)*1e3))
    display(sprintf('EGslope = %.2f V/ms (%.4f%%)',(mGslope(:,j)-po(1))/1e3,((mGslope(:,j)-po(1))/po(1))*100))
    display(sprintf('EGoffset = %.2f mV (%.4f%%)',(mGoffset(:,j)-po(2))*1e3,((mGoffset(:,j)-po(2))/po(2))*100))
end

%% Plot

h = figure
plot(SLR, ((mGslope-po(1))/po(1))*100,'LineWidth',1.5,'color','k')
xlabel('{\it Slew-Rate} (MV/s)')
ylabel('Erro Médio de Ganho (%)')
grid
set_fig_position(h,0,0,420,560)

h = figure
plot(SLR,sGslope,'k.', 'markers', 30,'LineWidth', 1)
xlabel('{\it Slew-Rate} (MV/s)')
ylabel('Incerteza de Ganho (V/V)')
xlim([0 105])
grid
set_fig_position(h,0,561,420,560)


h = figure
plot(SLR, (mGoffset - mvcs)*1e3,'LineWidth',1.5,'color','k')
xlabel('{\it Slew-Rate} (MV/s)')
ylabel('Média do Offset (mV)')
grid
set_fig_position(h,421,0,420,560)

h = figure
plot(SLR,sGoffset*1e6,'k.', 'markers', 30,'LineWidth', 1)
xlabel('{\it Slew-Rate} (MV/s)')
ylabel(['Incerteza do Offset (',char(181),'V)'], 'interpreter', 'tex')
xlim([0 105])
grid
set_fig_position(h,421,561,420,560)