%% Sizing of Miller OTA
clear;
clc;
format short eng

%Design Parameters
SR = 70e6; %V/s
GBW = 100e6; %Hz
PM = 60; %º
AOL = 50; %dB
ICMRm = 0.2; %V
ICMRp = 0.8; %V
CL = 2e-12; %F
Cc = 0.22*CL; % F (60º Phase Margin)
L = 180e-9; %nm

display('-------------------')
display(sprintf('SR = %0.2f MV/s',SR*1e-6));
display(sprintf('GBW = %0.2f MHz',GBW*1e-6));
display(sprintf('PM = %0.2fº',PM));
display(sprintf('AOL = %0.2f dB',AOL));
display(sprintf('ICMR minus = %0.2f V',ICMRm));
display(sprintf('ICMR plus = %0.2f V',ICMRp));
display(sprintf('CL = %0.2f pF',CL*1e12));
display(sprintf('Cc = %0.2f fF',Cc*1e15));
display('-------------------')

%% M 1,2
%From plot: (L12 = 1.44um)
gmid12 = 20; %V^-1 (Weak Inversion)
idW12 = 0.074; %A/m

%Calculated:
gm12 = 2*pi*GBW*Cc; %S
id12 = gm12/gmid12; %A
w12 = id12/idW12; %m

display('-------------------')
display(sprintf('gmid_12 = %0.2f V^-1',gmid12));
display(sprintf('gm_12 = %0.2f \x03BCS',gm12*1e6));
display(sprintf('Id_12 = %0.2f \x03BC A',id12*1e6));
display(sprintf('W_12 = %0.2f \x03BCm',w12*1e6));
display('-------------------')

%% M 6

%From plot: (L6 = 1.44um)
gmid6 = 15; %V^-1 (Moderate Inversion)
idW6 = 0.76; %A/m

%Calculated:
gm6 = 10*gm12; %S
id6 = gm6/gmid6; %A
w6 = id6/idW6; %m

display('-------------------')
display(sprintf('gmid_6 = %0.2f V^-1',gmid6));
display(sprintf('gm_6 = %0.2f \x03BCS',gm6*1e6));
display(sprintf('Id_6 = %0.2f \x03BC A',id6*1e6));
display(sprintf('W_6 = %0.2f \x03BCm',w6*1e6));
display('-------------------')

%% M 3,4
%From plot: (L34 = 1.44um)
gmid34 = gmid6; %V^-1 (Equal to reduce offset)
idW34 = idW6; %A/m

%Calculated:
id34 = id12; %A
w34 = id34/idW34; %m

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
%% M 7
%From plot:
gmid7 = gmid85; %V^-1 (Strong Inversion)[to avoid offset and improve matching]
idW7 = idW85; %A/m

%Calculated:
id7 = id6; %A
w7 = id7/idW7; %m

display('-------------------')
display(sprintf('gmid_7 = %0.2f V^-1',gmid7));
display(sprintf('Id_7 = %0.2f \x03BC A',id7*1e6));
display(sprintf('W_7 = %0.2f \x03BCm',w7*1e6));
display('-------------------')

%%
display(sprintf('Calculated SR = %0.2f MV/s',(id85/Cc)*1e-6));
display(sprintf('Ibias  = %0.2f \x03BC A',id85*1e6));