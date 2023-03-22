%%
clear
fclose('all');
close('all')
tic;

%%


%parametros modificaveis
ra = 10; %KOhm 2/10
cs = 100; %nF
ts = 50; %ns
ca = 1; %nF
v_vn = 1.6;
v_vp = 1.7;
num_of_sim = 1;

pathname = fileparts('../sim/');
asc_file = sprintf('../asc/PGA_Montecarlo_di_pwl_noMC.asc');
tname = sprintf('montecarlo_tmp');

display(sprintf('Ra=%.d Cs=%.d ts=%.d',ra,cs,ts));
log = strcat('log_',tname,'.txt')
tname = fullfile(pathname,tname);
log = fullfile(pathname,log);
fid = fopen(log,'a');
fprintf(fid,strcat('\n',datestr(now),'\n'));
fprintf(fid,'Ra=%.d Cs=%.d ts=%.d\n',ra,cs,ts);
fclose(fid);
fid = fopen(asc_file);

if(fid <= 0)
    error(sprintf('This function needs to be able to write to the folder in which the LTspioce asc file exists. \nCopy the file %s to a folder you can write to and try again. ', asc_file));
end

k=1;
i_tran = 0; i_theta = 0;
tline{k} = fgetl(fid);
while ischar(tline{k})
    k = k + 1;
    tline{k} = fgetl(fid);
    
    if(findstr('!.tran',tline{k})) %find SH clock
        i_tran = k;
    end
    if(findstr('!.param theta',tline{k})) %find SH clock
        i_theta = k;
    end
    
end
fclose(fid);
if (i_theta==0)
    error('Source or amplifier not found');
end

%%

%circuit

tau = ra*ca*1e-6;
gmax = 248e-6/tau+1;
v_teta = [250:20:490];
%sim
fs = 1e9/ts;
tsim = 126; %ms
tsave = 1; %ms
num_sample_ipl = fs*(tsim-tsave)*1e-3-10;

v_Go = (v_teta-250)*1e-6/tau + 1;
niter = length(v_teta);
itotal = niter*length(v_teta);
it = 0;
h = waitbar(0);
for ix=1:length(v_teta)
    teta = v_teta(ix);
    % Cria e modifica circuito
    fid = fopen(strcat(tname,'.asc'),'w');
    if(fid <= 0)
        error(sprintf('This function needs to be able to write to the folder in which the LTspice asc file exists. \nCopy the file %s to a folder you can write to and try again. ', asc_file));
    end
    
    tline{i_theta} = sprintf('TEXT -968 944 Left 2 !.param theta=%du',teta);
    res = findstr('!.tran ', tline{i_tran});
    tline{i_tran} = strcat(tline{i_tran}(1:res), sprintf('.tran 0 %.3fm %.3fm %.1fn startup', tsim, tsave, ts));
    
    for i=1:k-1
        fprintf(fid,tline{i});
        fprintf(fid,'\n');
    end
    
    fclose(fid);
    for iy=1:num_of_sim
        waitbar(((ix+iy/num_of_sim)/length(v_teta)*num_of_sim/100),h,sprintf('Theta = %du | Iteração: %d',teta,iy))
        run=0;
        while run == 0
            try
                resp = runLTspice(strcat(tname,'.asc'), 'V(va), V(vo), V(vp), V(vn), V(vcp), V(vcn), V(vip), V(vin)');
                res = interpLTspice(resp, fs);
                run = 1;
            catch
                run = 0;
                display ('Something went wrong, Trying again\n');
            end
        end
        t(:,iy) = res.time_vec(1,1:num_sample_ipl);
        Va(:,iy) = res.data{1,1}(1,1:num_sample_ipl);
        Vo(:,iy) = res.data{1,2}(1,1:num_sample_ipl);
        Vp(:,iy) = res.data{1,3}(1,1:num_sample_ipl);
        Vn(:,iy) = res.data{1,4}(1,1:num_sample_ipl);
        Vcp(:,iy) = res.data{1,5}(1,1:num_sample_ipl);
        Vcn(:,iy) = res.data{1,6}(1,1:num_sample_ipl);
        Vip(:,iy) = res.data{1,7}(1,1:num_sample_ipl);
        Vin(:,iy) = res.data{1,8}(1,1:num_sample_ipl);
%        Vnoise(:,iy) = res.data{1,9}(1,1:num_sample_ipl);
        it = it +1;
        tt = toc;
    end
    fid = fopen(log,'a');
    fprintf(fid,'i=%d/%d, teta=%d, t=%d:%d s\n', ...
        it, itotal, teta, floor(tt/60), round(mod(tt,60)) );
    fclose(fid);
    
    sname = sprintf('%du.mat',teta);
    sname = fullfile(pathname,sname);
    save(sname, 't', 'Va', 'Vo', 'Vp', 'Vn', 'Vcp', 'Vcn', 'Vip', 'Vin')
    
end
close(h);
delete(strcat(tname,'.*'));
