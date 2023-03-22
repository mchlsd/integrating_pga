%%
clear
fclose('all');
close('all')
tic;

%%


pathname = fileparts('../sim/');
asc_file = sprintf('../asc/sim_gbw.asc');
tname = sprintf('sim.gbw_tmp');


%circuit

    % Cria e modifica circuito
    fid = fopen(strcat(tname,'.asc'),'w');
    if(fid <= 0)
        error(sprintf('This function needs to be able to write to the folder in which the LTspice asc file exists. \nCopy the file %s to a folder you can write to and try again. ', asc_file));
    end

    

            try
                resp = runLTspice(strcat(tname,'.asc'), 'V(va), V(vai)');
                res = interpLTspice(resp, 1);
                run = 1;
            catch
                run = 0;
                display ('Something went wrong, Trying again\n');
            end
        
        t(:,iy) = res.time_vec(1,:);
        Va(:,iy) = res.data{1,1}(1,:);
        Vai(:,iy) = res.data{1,2}(1,:);
        it = it +1;
        tt = toc;
        
    
    sname = sprintf('%du.mat',teta);
    sname = fullfile(pathname,sname);
    save(sname, 't', 'Va', 'Vai')
    
close(h);
delete(strcat(tname,'.*'));
