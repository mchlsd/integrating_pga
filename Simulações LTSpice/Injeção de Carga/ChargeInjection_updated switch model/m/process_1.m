%close all;
clear all;
clc;

warning('off','all')

txtfile = "TextOutput.txt";
fid = fopen(txtfile,'w');

v_cm = [0:0.1:4];
v_diff = [0:0.1:3];
theta = 450;

pbc = 10000; %points by cycle
cycle=[0]*pbc;
t1=100; %transitory discard

 for j=1:numel(v_cm)
    
    % Load dataset
    %load (sprintf('../sim/%du.mat',theta));
    load (sprintf('../sim/Vcm = %0.1f.mat',v_cm(j)));
    
    % Prepare current data for processing
    s0 = cycle+t1;
    s1 = pbc/2+cycle-t1;
    a = pbc/2+cycle+t1; %amplification start
    b = cycle+pbc-t1; %amplification stop

    
    if theta == 250
        b = a;
    end
    
    Vcs = Vcp-Vcn;
    %Vcs = Vcs(1:numel(v_diff),:);
    Vo = Vo*1e3;
    Vcs = Vcs*1e3;
    % Extract relevant data
    tt2 = [];
    Va2 = [];
    Vo2 = [];
    Vp2 = [];
    Vcs1 = [];
    Vcs2 = [];
    for i=1:numel(cycle)
        tt2 = [t(a(i):b(i),:)];
        Va2 = [Va(a(i):b(i),:)];
        Vcs1 = [Vcs(s0(i):s1(i),:)];
        Vcs2 = [Vcs(a(i):b(i),:)];
    end

    
    mVcs(:,j) = mean(Vcs2)-mean(Vcs1);
    sVcs(:,j) = sqrt(std(Vcs2).^2+std(Vcs1).^2);
    
 end
 
 %%
figure(1)
[vx,vy]=meshgrid(v_cm,v_diff);
mesh(vx',vy',mVcs);
%title('$\bar{vi2 - vi1}$','Interpreter','Latex');
xlabel('\it V_{cm} \rm(V)')
ylabel('\it V_{diff} \rm(V)')

figure(2)
[vx,vy]=meshgrid(v_cm,v_diff);
mesh(vx,vy,sVcs);
%title('$\bar{vi2 - vi1}$','Interpreter','Latex');
xlabel('\it V_{cm} \rm(V)')
ylabel('\it V_{diff} \rm(V)')

