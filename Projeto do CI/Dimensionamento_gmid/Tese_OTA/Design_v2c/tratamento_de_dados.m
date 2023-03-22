%%Ideal
clear
close all
%load('data.mat')
load('data.mat')
fs = 1e8;
num_eval_pts = 1;

type = 1;



Vout_time = table2array(millerotav2c(2:end,1));
Vout_data = table2array(millerotav2c(2:end,2));

Va_time = table2array(millerotav2c(2:end,3));
Va_data = table2array(millerotav2c(2:end,4));

Vcs_time = table2array(millerotav2c(2:end,5));
Vcs_data = table2array(millerotav2c(2:end,6));

    

%% Vout
for k = 1:num_eval_pts
    Vout_time_wo_nan = rmmissing(Vout_time(:,k));
    Vout_data_wo_nan = rmmissing(Vout_data(:,k));
    Va_time_wo_nan = rmmissing(Va_time(:,k));
    Va_data_wo_nan = rmmissing(Va_data(:,k));
    Vcs_time_wo_nan = rmmissing(Vcs_time(:,k));
    Vcs_data_wo_nan = rmmissing(Vcs_data(:,k));

    try t = Vout_time_wo_nan(1):1/fs:Vout_time_wo_nan(end);
    catch
        error(sprintf('A sampling rate of %f resulted in too much data (memory limits exceeded).\n\nTry a different sampling frequency using interpLTspcice(data_struct,fs);', fs));
    end
    Vout(:,k) =  interp1(Vout_time_wo_nan, Vout_data_wo_nan, t);
    Va(:,k) =  interp1(Va_time_wo_nan, Va_data_wo_nan, t);
    Vcs(:,k) =  interp1(Vcs_time_wo_nan, Vcs_data_wo_nan, t);
    time(:,k) = t;
end 
%% Display + Plot + Save
Vcs_ = Vcs(5000:end,:);
Va_ = Va(5000:end,:);
Vout_ = Vout(5000:end,:);
Time_ = time(5000:end,:);
gain = Vout_./Vcs_;
% fprintf("Média de Vcs: %f V \n", mean(Vcs_));
% fprintf("Desvio padrão de Vcs: %f \x03bcV \n", std(Vcs_)*1e6);
% 
% fprintf("Média de Vout: %f V \n", mean(Vout_));
% fprintf("Desvio padrão de Vout: %f \x03bcV \n", std(Vout_)*1e6);

%fprintf("Média do Ganho: %f V/V \n", mean(gain));
%fprintf("Desvio padrão do Ganho: %f V/V \n", std(gain));
%%
process;
%clearvars -except Vout_ideal Vcs_ideal Time_ideal

%save('ideal_treated.mat')