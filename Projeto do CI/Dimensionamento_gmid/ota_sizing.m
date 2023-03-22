%% Sizing of Miller OTA
clear;
clc;

%Design Parameters
SR = 70e6; %V/s
GBW = 100e6; %Hz
PM = 60; %º
AOL = 50; %dB
ICMRm = 0.2; %V
ICMRp = 0.8; %V
CL = 2e-12; %F
L = 180e-9; %nm

display('-------------------')
display(sprintf('SR = %0.2f MV/s',SR*1e-6));
display(sprintf('GBW = %0.2f MHz',GBW*1e-6));
display(sprintf('PM = %0.2fº',PM));
display(sprintf('AOL = %0.2f dB',AOL));
display(sprintf('ICMR minus = %0.2f V',ICMRm));
display(sprintf('ICMR plus = %0.2f V',ICMRp));
display(sprintf('CL = %0.2f pF',CL*1e12));
display('-------------------')

%% M 1,2
%From plot:
gmid12 = 15; %V^-1 (Moderate Inversion)
idW12 = 2.92; %A/m

%Calculated:
gm12 = 2*pi*GBW*CL; %S
id12 = gm12/gmid12; %A
w12 = id12/idW12; %m

display('-------------------')
display(sprintf('gmid_12 = %0.2f V^-1',gmid12));
display(sprintf('gm_12 = %0.2f \x03BCS',gm12*1e6));
display(sprintf('Id_12 = %0.2f \x03BC A',id12*1e6));
display(sprintf('W_12 = %0.2f \x03BCm',w12*1e6));
display('-------------------')

%% M 3,4
%From plot:
gmid34 = 15; %V^-1 (Moderate Inversion)
idW34 = 9.27; %A/m

%Calculated:
id34 = id12; %A
w34 = id34/idW34; %m

%Extra
gm34 = gmid34*id34;

display('-------------------')
display(sprintf('gmid_34 = %0.2f V^-1',gmid34));
display(sprintf('Id_34 = %0.2f \x03BC A',id34*1e6));
display(sprintf('W_34 = %0.2f \x03BCm',w34*1e6));
display('-------------------')

%% M 8,5
%From plot:
gmid85 = 10; %V^-1 (Strong Inversion)[to avoid offset and improve matching]
idW85 = 9; %A/m

%Calculated:
id85 = 2*id12; %A
w85 = id85/idW85; %m

display('-------------------')
display(sprintf('gmid_85 = %0.2f V^-1',gmid85));
display(sprintf('Id_85 = %0.2f \x03BC A',id85*1e6));
display(sprintf('W_85 = %0.2f \x03BCm',w85*1e6));
display('-------------------')


%%
display(sprintf('Calculated SR = %0.2f MV/s',(id85/CL)*1e-6));
display(sprintf('Ibias  = %0.2f \x03BC A',id85*1e6));

gmgds12 = 42.19;
gmgds34 = 37.7;
gds12 = gm12/gmgds12;
gds34 = gm34/gmgds34;
display(sprintf('Calculated Gain = %0.2f dB',mag2db(gm12/(gds12+gds34))));
