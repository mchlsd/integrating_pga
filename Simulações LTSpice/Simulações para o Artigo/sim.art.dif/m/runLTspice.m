% runLTspice is a function which can be used to read/obtain the voltage and/or
% current waveforms produced when an LTspice schematic (.asc file) is
% run/simulated.
%
% The function also allows you to replace the voltage and current sources
% which are used in the LTspice schematic (.asc file) with signals created in matlab.
%
% obtaining data usage:
%   volt_curr_list =  runLTspice('filename.asc'); %returns a list of all voltages and currents in the schematic.
%   results = runLTspice('filename.asc', volt_curr_list); %returns the data of the voltages and currents specified in parameter 2 (parameter 2 is a comma separated list of voltages and currents that the user wants returned)
%   plot(results.time_vec, results.data{1}); % plot the first set of data received
%   xlabel('Time (seconds)')
%   title(results.data_name{1})
%
% alter source data usage:
%  [volt_curr_list sources_list] = runLTspice('filename.asc');
%  fs = 100; %100 Hz sampling rate
%  step_input = [zeros(1, fs*1) ones(1, fs*10)]; % unit step input of duration 11 seconds 
%  first_source = sources_list(1: findstr(',',sources_list)-1);
%  if(~length(first_source))
%      first_source = sources_list;
%  end
%  results = runLTspice('filename.asc', volt_curr_list, first_source, step_input, fs);
%
% Written by: David Dorran (david.dorran@dit.ie)
%
% Acknowledgements:
% This function uses the LTspice2Matlab function written by Paul Wagner to capture data from a raw LTspice file.
% see - http://www.mathworks.com/matlabcentral/fileexchange/23394-fast-import-of-compressed-binary-raw-files-created-with-ltspice-circuit-simulator
 
function [varargout] = runLTspice(asc_file, varargin)
if(~exist('LTspice2Matlab'))
    error(sprintf('This function requires the function LTspice2Matlab written by Paul Wagner \n- Download from: http://www.mathworks.com/matlabcentral/fileexchange/23394-fast-import-of-compressed-binary-raw-files-created-with-ltspice-circuit-simulator'))
end
read_data = 0;
display_LTspice_variables = 0;
incorrect_output_parameters = 0;
incorrect_input_parameters = 0;
num_sources = 0;
if(nargin == 1)
    % just need to let the user know what voltages/currents can specified
    % in parameter 2 (parameter 2  is a comma separated list of
    % voltage/currents the the user requires) and what voltage current
    % sources can be modified with user specified data.
    if(nargout == 0)
        display_LTspice_variables = 1;
    elseif( nargout > 2)
        error(sprintf('You must specify either none, 1 or 2 return parameters when obtaining the voltage/current wavforms and sources from an LTspice asc file.\n\nE.g.\n\trunLTspice(''filename.asc'');\nor\n\tvolt_curr_list = runLTspice(''filename.asc'');\nor\n\t[volt_curr_list sources_list] = runLTspice(''filename.asc'');'))
    end
elseif(nargin == 2)
    % No need to modify the asc file with voltage/current pwl sources as
    % the user just wants to be able to capture data from the asc file
    read_data = 1;
 
    if(~isstr(varargin{1}))
        error(sprintf('The second parameter must be string containing a comma separated list of LTspice voltage/currents you would like returned. \n\nType ''runLTspice(''%s'')'' to get a list of valid values. \n\nType ''help runLTspice'' for usage examples. ', asc_file));
    end
    if(nargout  > 1)
        incorrect_output_parameters = 1;
    end
elseif(nargin > 2)
    read_data = 1;
    if(nargout  > 1)
        incorrect_output_parameters = 1;
    end
    mynargin = nargin - 2;
    if(mod(mynargin, 3))
        incorrect_input_parameters = 1;
    else
        num_sources = mynargin/3;
        for k = 1 : num_sources;
            if ~isstr(varargin{1+(k-1)*3+1}) || isstr(varargin{1+(k-1)*3+2}) || isstr(varargin{1+(k-1)*3+3}) || length(varargin{1+(k-1)*3+3}) > 1
                incorrect_input_parameters = 1;
            end
            sources2update{k} = varargin{1+(k-1)*3+1};
        end
    end
end
 
if(incorrect_output_parameters)
    error(sprintf('You can only specify one output parameter when retrieving data\n\nType ''help runLTspice'' for example usage.'))
end
 
if(incorrect_input_parameters)
    error(sprintf('When specifying data for either a supply voltage or current source three parameters are required for each source \ni.e. the source name (a string), the data (a vector/array of numbers), the sampling rate (a number).\n\ne.g. \n\tresults = runLTspice(''%s'', ''V(n002), V(n005) '', ''V1'', [0:0.1:10], 2, ''V2'', ones(1, 20), 4);\n\nNOTE: The values voltages V(n002), V(n005) and sources V1 and V2 must exist in ''%s''.\n\nTo determine the valid voltage/currents and sources in your LTspice asc file run the following command:\n\t runLTspice(''%s'')', asc_file,asc_file, asc_file))
end
 
if(~exist(asc_file))
    error(['Could not find the LTspice file ' asc_file ])
end
 
asc_path = fileparts(asc_file);
if(~length(asc_path))
    asc_path = pwd;
end
asc_path(end+1) = '\';
 
raw_file = regexprep(asc_file, '.asc$', '.raw');
 
this_file_path = which('runLTspice');
this_dir_path = this_file_path(1:end-length('runLTspice.m'));
 
config_file = [this_dir_path 'runLTspice_config.txt'];
if(exist(config_file))
    ltspice_path = fileread(config_file);
else
    ltspice_path = '/home/michel/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx86.exe';
end
 
% See if the LTspice exe can be found in the path ltspice_path. If not get
% the user to enter the path. Once a valid path is entered then store it
% in the config file
exe_file = [ltspice_path ];
path_needs_updating = 0;
while ~exist(exe_file)
    disp(['The LTspice executable file could not be found. ']);
    if(~path_needs_updating)
        disp('Once the correct location is entered it will be recorded for future use of this function.')
        disp('     Example location 1: C:\Program Files\LTC\LTspiceIV\scad3.exe')
        disp('     Example location 2: C:\Program Files\LTC\LTspiceXVII\XVIIx86.exe')
    end
    disp(' ')
    ltspice_path = input('Please enter the location where the executable exists => ','s');
    ltspice_path= strtrim(ltspice_path);
    if(ltspice_path(end) == '/')
        ltspice_path(end) ='\';
    end
 
    %exe_file = [ltspice_path ]
    %exe_file = '"wine /home/michel/.wine/drive_c/Program\ Files/LTC/LTspiceXVII/XVIIx86.exe"';
    path_needs_updating = 0;
end
 
if(path_needs_updating)
    disp('Updating LTspice exe location ...');
    try fp = fopen(config_file,'w');
        fprintf(fp, '%s',ltspice_path );
        fclose(fp);
        disp('Update Complete.')
    catch
        disp(['Could not open the configuration file ' config_file ' to record the exe location.']);
        disp('You will need to enter the path to the LTspice manually every time you use this function')
    end
end
 
exe_file = '"wine /home/michel/.wine/drive_c/Program\ Files/LTC/LTspiceXVII/XVIIx86.exe"';
% Parse the .asc file to idenitfy the current and voltage sources in the
% schematic. Also sote the line numbers where the values of these sources
% are located - these values will be updated with pwl files in the event
% that the user wishes to update the sources in the schematic
fid = fopen(asc_file);
k=1;
tline{k} = fgetl(fid);
voltage_found = 0;
current_found = 0;
voltage_names = {};
current_names = {};
symbol_num = 0;
voltage_symbol_nums = [];
current_symbol_nums = [];
while ischar(tline{k})
    k = k + 1;
    tline{k} = fgetl(fid);
 
    if(length(findstr('SYMBOL ',tline{k})))
        voltage_found = 0;
        current_found = 0;
        symbol_num = symbol_num + 1;
    end
    if(length(findstr('SYMATTR Value',tline{k})))
        symbol_value_line(symbol_num) = k;
    end
    if(length(findstr('SYMBOL voltage',tline{k})) || length(findstr('SYMBOL Misc\\signal ',tline{k}))|| length(findstr('SYMBOL Misc\\cell ',tline{k}))|| length(findstr('SYMBOL Misc\\battery ',tline{k})))
        voltage_found = 1;
    end
    if(length(findstr('SYMBOL current',tline{k})))
        current_found = 1;
    end
    if(voltage_found && length(findstr('SYMATTR InstName', tline{k})))
        voltage_names{end+1} = tline{k}(length('SYMATTR InstName')+2:end);
        voltage_symbol_nums(end+1) = symbol_num;
    end
    if(current_found && length(findstr('SYMATTR InstName', tline{k})))
        current_names{end+1} = tline{k}(length('SYMATTR InstName')+2:end);
        current_symbol_nums(end+1) = symbol_num;
    end
end
num_asc_file_lines = k;
source_names = [voltage_names current_names];
source_symbol_nums  = [voltage_symbol_nums  current_symbol_nums] ;
fclose(fid);
 
%% Just need to let the user know what sources can be used and the voltages/currents that can be read. No need to update the asc file
if(read_data == 0)
 
    sim_result = test_asc_simulation(asc_file,raw_file);
    if(sim_result == 0)
        error(sprintf('There was a problem running the LTspice file %s. \n\n Please open the file in LTspice and verify that it can be simulated', asc_file));
    end 
    raw_data = LTspice2Matlab(raw_file);
    voltage_current_list = '';
    for k = 1: raw_data.num_variables
        voltage_current_list = [voltage_current_list raw_data.variable_name_list{k} ', '];
    end
    voltage_current_list(end-1:end) = []; %remove trailing comma
     
    source_list = '';
    for k = 1: length(source_names)
        source_list = [source_list source_names{k} ', '];
    end
    source_list(end-1:end) = [];
     
    if(nargout)
        varargout{1} = voltage_current_list;
        if(nargout ==2)
            varargout{2} = source_list;
        end
    else
      disp(sprintf('List of voltage and currents that can be read:\n\t%s\n\nList of voltage and/or current sources that can be written to:\n\t%s', voltage_current_list, source_list))
    end
         
    return;
end
 
%identify the variables the user wants returned
vars2read = strtrim(strread(varargin{1}, '%s','delimiter',','));
if(~length(vars2read))
    error('The list of voltages and currents to read must be contained in a comma separated string.');
end
     
%% no need to change the pwl file so just run the specified asc file and return the results
if(num_sources == 0)
    sim_result = test_asc_simulation(asc_file,raw_file);
    if(sim_result == 0)
        error(sprintf('There was a problem running the LTspice file %s. \n\n Please open the file in LTspice and verify that it can be simulated', asc_file));
    end 
    raw_data = LTspice2Matlab(raw_file);
     
    varargout = grab_specified_data(vars2read, raw_data);
     
    return;
end
 
%% Need to update asc file and create pwl files for each source specified if you reach this stage
 
% calculate the simulation duration so as to match the duration of the longest
%(in time) source signal
sim_duration = 0;
for k = 1: num_sources
  duration = length(varargin{1+(k-1)*3+2})/varargin{1+(k-1)*3+3}; % = length(data)/fs  
  if(duration > sim_duration)
      sim_duration = duration;
  end
  source_found = 0;
    for m = 1: length(source_names)
        if strcmp(sources2update{k}, source_names{m})
            sources2update_value_line(k) = symbol_value_line(source_symbol_nums(m));
            source_found = 1;
        end
    end
    if(~source_found)
        error(sprintf('Unable to find the source %s in the schematic.\n\nType runLTspice(''%s''); at the command line to see a list of valid sources', sources2update{k}, asc_file));
    end
end
 
%ceate pwl files for each souce
fs = 0;
for k = 1: num_sources
    % create pwl files to use to drive the voltage sources
    tmp_pwl_file{k} = [asc_path 'runLTspice_tmp_pwl_' num2str(k) '.txt'];
    create_pwl(varargin{1+(k-1)*3+2},varargin{1+(k-1)*3+3}, tmp_pwl_file{k});
    fs = varargin{1+(num_sources-1)*3+3};
end
 
% create a temporary file which will basically be a copy of the asc file passed
% to the function with voltage and current sources updated with pwl files.
% Also the simulation duration will be updated.
 
tmp_asc_file = [asc_path 'runLTspice_tmp_asc.asc'];
tmp_raw_file = [asc_path 'runLTspice_tmp_asc.raw'];
 
 
% update the temporary file with pwl files and the duration the simulation
% is to run.
f_op_id = fopen(tmp_asc_file,'w');
if(f_op_id <= 0)
    error(sprintf('This function needs to be able to write to the folder in which the LTsppice asc file exists. \nCopy the file %s to a folder you can write to and try again. ', asc_file));
end
k = 0;
trans_found = 0;
while( k < num_asc_file_lines - 1)
    k = k + 1;
    res = findstr('!.tran ', tline{k});
    if(length(res))
        trans_found = 1;
        res2 = regexp(tline{k}, '.tran (?.*?)(?(steady|startup|nodiscard|uic|$).*)', 'names');
        res_info = res2(1).info;
        tran_settings = res2(1).settings;
        num_spaces = length(findstr(' ', res_info) );
        if(num_spaces == 1 || num_spaces == 0)
            tran_info = [num2str(sim_duration) ' '];
        else
            sim_duration
            tran_info = regexprep(res_info, ' .+? ',  [' ' num2str(sim_duration) ' ']  ,'once')
             
        end
        tline{k}(res(1)+length('!.tran '):end) = [];
        tline{k} = [tline{k} tran_info tran_settings];
    end
     
    index = find(sources2update_value_line==k);
    if(length(index))
            fwrite(f_op_id, ['SYMATTR Value PWL file="' tmp_pwl_file{index} '"' ]);
            fprintf(f_op_id, '\n');
    else
        fwrite(f_op_id, tline{k});
        fprintf(f_op_id, '\n');
    end
end
 
fclose(f_op_id);
sim_result = test_asc_simulation(tmp_asc_file,tmp_raw_file);
if(sim_result == 0)
    error(sprintf('There was a problem running the LTspice file %s. \n\n Please open the file in LTspice and verify that it can be simulated', asc_file));
end 
if(~trans_found)
    error(['The simulation must be run in transient mode (rather than AC analysis for example). Select the Transient tab by first selecting Simulate->Edit Simulation Cmd in LTSpice'])
end
raw_data = LTspice2Matlab(tmp_raw_file);
 
varargout = grab_specified_data(vars2read, raw_data);
if(fs)
    varargout{1} = interpLTspice(varargout{1},fs);
end
%delete([asc_path 'runLTspice_tmp_*'])
 
return;
 
    function result = test_asc_simulation(test_filename,test_rawfile)
        % Will need to check if a raw file was created/updated to make sure
        % that the simulation ran successfully
        orig_timestamp =0;
        if(exist(test_rawfile))
            d = dir(test_rawfile);
            orig_timestamp = datenum(d.date);
        end
        % run/simulate the spice file
        system_command = ['"' exe_file '" -b -run -ascii "' test_filename '"'];
        %system_command = ['"' exe_file '" -b -run  "' test_filename '"'];
        system(system_command);
        result = 1;
        if(exist(test_rawfile))
            d = dir(test_rawfile);
            if( datenum(d.date) < orig_timestamp)
                result = 0; %unsuccessful simulation
            end
        else
            result = 0;; %unsuccessful simulation
        end
    end
 
 
    function create_pwl(data, fs, filename)
 
        file_id = fopen(filename,'w');
        if(file_id < 1)
            error(sprintf('This function needs to be able to write to the folder in which the LTspioce asc file exists. \nCopy the file %s to a folder you can write to and try again. ', asc_file));
        end
        for k = 1: length(data)
           fprintf(file_id, '%6.6f %6.6f ' , (k-1)/fs, data(k)); 
        end  
        fclose(file_id);
    end
 
    function data_details = grab_specified_data(vars, raw_info)
            for k = 1: length(vars)
                found(k) = 0;
                for m = 1:raw_info.num_variables
                    if(strcmp(vars{k},raw_info.variable_name_list{m}))
                        found(k) = m;
                    end
                end
                if(found(k))
                    data_details{1}.data_name{k} = vars{k};
                    data_details{1}.data{k} = raw_info.variable_mat(found(k),:);
                else
                    error( [ vars{k} ' not found! Check that you spelled the variable correctly. '])
                    data_details{1}.data_name{k} = [vars{k} ' not found!'];
                    data_details{1}.data{k} = [];
                end
            end
            data_details{1}.time_vec = raw_info.time_vect;
    end
 
end
