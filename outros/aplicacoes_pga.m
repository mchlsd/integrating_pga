%Frequency x Gain Steps

clear;
close all;

% --wireless applications--
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% leeWidebandCMOSVariable2007
vga(2).gain_range = 94.1;
vga(2).bandwidth = 900e6;
vga(2).power = 20.53e-3;
vga(2).citation = 38;

%liu5GbAutomaticGain2012
vga(3).gain_range = 40;
vga(3).bandwidth = 7.5e9;
vga(3).power = 72e-3;
vga(3).citation = 121;

%otakaLowpowerLownoiseAccurate2000
vga(4).gain_range = 70;
vga(4).bandwidth = 500e6;
vga(4).power = 36e-3;
vga(4).citation = 122;

%wangDesignLowPower2012
vga(5).gain_range = 60;
vga(5).bandwidth = 2.2e9;
vga(5).power = 2.5e-3;
vga(5).citation = 46;

%leeKaBandPhaseCompensatedVariableGain2019
vga(6).gain_range = 20.8;
vga(6).bandwidth = 4.5e9;
vga(6).power = 26.7e-3;
vga(6).citation = 110;

%zhengCMOSVGADC2009
vga(7).gain_range = 60;
vga(7).bandwidth = 2.87e6;
vga(7).power = -1;
vga(7).citation = 112;


% kumar9mW6GHzDigitally2012
pga(1).gain_range = 23;
pga(1).bandwidth = 5.6e9;
pga(1).power = 7.9e-3;
pga(1).citation = 120;

%wei35GHzProgrammable2017
pga(2).gain_range = 20;
pga(2).bandwidth = 1.35e9;
pga(2).power = 9.8e-3;
pga(2).citation = 25;

%zhangKaBandCMOSVariable2020
pga(3).gain_range = 29.4;
pga(3).bandwidth = 5e9;
pga(3).power = -1;
pga(3).citation = 58;

%liWidebandHighLinearity2016
pga(4).gain_range = 20;
pga(4).bandwidth = 6e9;
pga(4).power = 11.78e-3;
pga(4).citation = 118;

%severo36PGACombining2018
pga(5).gain_range = 18.2;
pga(5).bandwidth = 0.98e6;
pga(5).power = 15.4e-6;
pga(5).citation = 117;

% kumar35mW30dBGain2014
pga(18).gain_range = 31.6;
pga(18).bandwidth = 1.8e9;
pga(18).power = 35.3e-3;
pga(18).citation = 100;

% kumarTemperatureCompensatedDBlinearDigitally2013
pga(19).gain_range = 18.4;
pga(19).bandwidth = 1.9e9;
pga(19).power = 12.2e-3;
pga(19).citation = 123;

% kumar9mW6GHzDigitally2012
pga(26).gain_range = 23;
pga(26).bandwidth = 5.6e9;
pga(26).power = 7.9e-3;
pga(26).citation = 120;

% wangLinearindBAnalogBaseband2013
pga(20).gain_range = 34;
pga(20).bandwidth = 980e6;
pga(20).power = 48e-3;
pga(20).citation = 124;

% kitamura84DBgainrangeGHzbandwidth2013
pga(21).gain_range = 84.3;
pga(21).bandwidth = 1e9;
pga(21).power = 21.9e-3;
pga(21).citation = 125;

% gianniniFlexibleBasebandAnalog2007
pga(22).gain_range = 39;
pga(22).bandwidth = 200e6;
pga(22).power = 13.5e-3;
pga(22).citation = 99;

% alegreperezHighPerformanceCMOSFeedforward2010
pga(23).gain_range = 22;
pga(23).bandwidth = 100e6;
pga(23).power = 2.4e-3;
pga(23).citation = 115;

% sanzMOSCurrentDivider2005
pga(27).gain_range = 36;
pga(27).bandwidth = 16e6;
pga(27).power = 8e-3;
pga(27).citation = 61;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--bio applications--
% abushawishProgrammableGainBandwidth2021
pga(6).gain_range = 16.8;
pga(6).bandwidth = 10e3;
pga(6).power = 3.28e-6;
pga(6).citation = 83;

% abushawishDigitallyProgrammableGain2021
pga(7).gain_range = 29.2;
pga(7).bandwidth = 7e3;
pga(7).power = 44e-6;
pga(7).citation = 84;

% huangFrontendAmplifierLownoise2008
pga(8).gain_range = 27.79;
pga(8).bandwidth = -1;
pga(8).power = 142.4e-6;
pga(8).citation = 70;

 % martinsClassProgrammableGain2021
 pga(15).gain_range = 15.5;
 pga(15).bandwidth = 7.1e6;
 pga(15).power = 2.8e-3;
 pga(15).citation = 85;

% rauVariableGainBandwidth2020
pga(9).gain_range = 13.5;
pga(9).bandwidth = 40e3;
pga(9).power = 54.6e-6;
pga(9).citation = 86;

% riegerVariableGainLowNoiseAmplification2011
pga(10).gain_range = 52;
pga(10).bandwidth = 20e3;
pga(10).power = 280e-6;
pga(10).citation = 60;

% ratametha64MuMathrmW2020
pga(11).gain_range = 25;
pga(11).bandwidth = 10e3;
pga(11).power = 280e-6;
pga(11).citation = 131;

% pandeyLowPower54mWAdaptive2021
pga(25).gain_range = 70;
pga(25).bandwidth = 10e3;
pga(25).power = 54e-6;
pga(25).citation = 88;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--Hearing-Aid

% deligozMEMSBasedPowerScalableHearing2011
pga(12).gain_range = 40;
pga(12).bandwidth = 10e3;
pga(12).power = 67.2e-6;
pga(12).citation = 67;

% gebara900mVProgrammableGain2004
 pga(17).gain_range = 82;
 pga(17).bandwidth = 20e3;
 pga(17).power = 45e-6;
 pga(17).citation = 148;

% medeirosFullyAnalogLowpower2013
pga(13).gain_range = 75;
pga(13).bandwidth = 20e3;
pga(13).power = 2.15e-6;
pga(13).citation = 62;

% qi1V25uWLownoise2014
pga(14).gain_range = 15;
pga(14).bandwidth = 20e3;
pga(14).power = 25e-6;
pga(14).citation = 147;

% su6V8mWAutomatic2008
vga(8).gain_range = 52;
vga(8).bandwidth = 10e3;
vga(8).power = 1.8e-6;
vga(8).citation = 146;

%bhattacharyyaMicropowerAnalogHearing1996
pga(24).gain_range = 20;
pga(24).bandwidth = 20e3;
pga(24).power = 172e-6;
pga(24).citation = 145;

% mautheMicropowerCMOSCircuit1990
pga(16).gain_range = 30;
pga(16).bandwidth = 10e3;
pga(16).power = -1;
pga(16).citation = 144;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--Magnetic Drives--

% harjaniLowpowerCMOSVGA1995
vga(9).gain_range = 25;
vga(9).bandwidth = 75e6;
vga(9).power = 10e-3;
vga(9).citation = 52;

% gomez50MHzCMOSVariable1992
vga(1).gain_range = 35;
vga(1).bandwidth = 50e6;
vga(1).power = 150e-3;
vga(1).citation = 97;


%%
%VGA PLOT
figure(1)
semilogx([vga(:).bandwidth],[vga(:).gain_range],'d','color','r','markerfacecolor','r','markersize',12)
xlabel('Largura de Banda (Hz)') 
ylabel('Faixa de Ganho (dB)')
ylim([0 inf])
xlim([0 inf])
zlim([0 inf])
grid
for i=1:9
    text(vga(i).bandwidth,vga(i).gain_range,compose("  [%d]",vga(i).citation))
end
hold on
%PGA PLOT
semilogx([pga(:).bandwidth],[pga(:).gain_range],'d','color','b','markerfacecolor','b','markersize',12)
for i=1:27
    text(pga(i).bandwidth,pga(i).gain_range,compose("  [%d]",pga(i).citation))
end
hold off

legend('VGA','PGA')

%%
figure(2)
loglog([vga(:).bandwidth],[vga(:).power],'s','color','k','markerfacecolor','r','markersize',12)
xlabel('Largura de Banda (Hz)') 
ylabel('Energia Dissipada (W)')
%ylim([0 inf])
%xlim([0 inf])
%zlim([0 inf])
grid
xpos = [];
ypos = [];
labels = [];
for i=1:9
    xpos = [xpos vga(i).bandwidth];
    ypos = [ypos vga(i).power];
    labels = [labels compose("  [%d]",vga(i).citation)];
end
labelpoints(xpos,ypos,labels,'SE', 'FontSize', 9,'adjust_axes',1)
hold on
%PGA PLOT
loglog([pga(:).bandwidth],[pga(:).power],'d','color','k','markerfacecolor','b','markersize',12)
xpos = [];
ypos = [];
labels = [];
for i=1:27
    xpos = [xpos pga(i).bandwidth];
    ypos = [ypos pga(i).power];
    labels = [labels compose("  [%d]",pga(i).citation)];
end
labelpoints(xpos,ypos,labels,'SE', 'FontSize', 9,'adjust_axes',1)
hold off
legend('VGA','PGA')

%%
figure(3)
semilogy([vga(:).gain_range],[vga(:).power],'d','color','r','markerfacecolor','r','markersize',12)
xlabel('Faixa de Ganho (dB)') 
ylabel('Energia Dissipada (W)')
ylim([0 inf])
xlim([0 inf])
zlim([0 inf])
grid
for i=1:9
    text(vga(i).gain_range,vga(i).power,compose("  [%d]",vga(i).citation))
end
hold on
%PGA PLOT
semilogy([pga(:).gain_range],[pga(:).power],'d','color','b','markerfacecolor','b','markersize',12)
for i=1:27
    text(pga(i).gain_range,pga(i).power,compose("  [%d]",pga(i).citation))
end
hold off
legend('VGA','PGA')

%%

%VGA PLOT
figure(4)
plot3([vga(:).bandwidth],[vga(:).gain_range],[vga(:).power],'d','color','r','markerfacecolor','r','markersize',12)
xlabel('Largura de Banda (Hz)') 
ylabel('Faixa de Ganho (dB)') 
zlabel('Power (W)')
ylim([0 inf])
xlim([0 inf])
zlim([0 inf])
set(gca,'XScale','log')
set(gca,'ZScale','log')
grid
for i=1:9
    text(vga(i).bandwidth,vga(i).gain_range,vga(i).power,compose("  [%d]",vga(i).citation))
end
hold
%PGA PLOT
plot3([pga(:).bandwidth],[pga(:).gain_range],[pga(:).power],'d','color','b','markerfacecolor','b','markersize',12)
for i=1:27
    text(pga(i).bandwidth,pga(i).gain_range,pga(i).power,compose("  [%d]",pga(i).citation))
end
hold
legend('VGA','PGA')
saveas(gcf,'all_3e','eps')