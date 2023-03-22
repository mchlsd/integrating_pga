%% Sizing of Folded Cascode OTA
clear;
clc;
format short eng

%Design Parameters
SR = 70e6; %V/s
GBW = 100e6; %Hz
PM = 60; %º
AOL = 80; %dB
ICMRm = 0.2; %V
ICMRp = 0.8; %V
CL = 2e-12; %F
L = 360e-9; %nm
lambda = 0.09;

display('-------------------')
display(sprintf('SR = %0.2f MV/s',SR*1e-6));
display(sprintf('GBW = %0.2f MHz',GBW*1e-6));
display(sprintf('PM = %0.2fº',PM));
display(sprintf('AOL = %0.2f dB',AOL));
display(sprintf('ICMR minus = %0.2f V',ICMRm));
display(sprintf('ICMR plus = %0.2f V',ICMRp));
display(sprintf('CL = %0.2f pF',CL*1e12));
display('-------------------')

%% M 1,2 (PMOS)
%From plot:
gmid12 = 10; %V^-1 (Moderate Inversion)
idW12 = 3.19; %A/m

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

%% M 3,4 (NMOS)
%From plot:
gmid34 = 10; %V^-1 (Moderate Inversion)
idW34 = 11.37; %A/m

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

%%
ISS = 2*id12;
I12 = id34;
ISS12 = ISS/2+I12;

display(sprintf('ISS  = %0.2f \x03BC A',ISS*1e6));
display(sprintf('I12  = %0.2f \x03BC A',I12*1e6));
display(sprintf('ISS12  = %0.2f \x03BC A',ISS12*1e6));

expected_GBW = gm12/(2*pi*CL)
expected_AOL = mag2db(gmid12*gmid34*(1/(2*0.09^2)))

gmgds12 = 101.509;
gmgds34 = 101.704;
gds12 = gm12/gmgds12;
gds34 = gm34/gmgds34;
%display(sprintf('Calculated Gain = %0.2f dB',mag2db(gm12/(gds12+gds34))));
