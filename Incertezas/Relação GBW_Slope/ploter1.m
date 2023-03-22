clear 
clc
clf

wt = 6.28319e9;
Ao = 100000;
wo = 62.83191;
wc = 1000000;
vi = 0.1;


dt = 0.01e-6;
t = 0:dt:10e-6 - dt;
u = vi+t*0;

voi = vi+cumtrapz(u)*dt*wc;

H = tf([wt wt*wc],[1 wc+wt 0])

A = tf([wt*wc],[(wc+wt) 0])
B = tf([wt^2/(wt+wc)],[1 wc+wt])

voh = lsim(ss(H),u,t);
voa = lsim(ss(A),u,t);
vob = lsim(ss(B),u,t);

t = t*1e6;
figure(1);
plot(t,voh,'--',t,voa,':',t,vob,'-.','LineWidth',2);
grid;
legend('H','A','B')
axis([0 10 0 0.6])
title('Circuit Subsystems')
xl1 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl1 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl1,'FontSize',13);
set(yl1,'FontSize',13);

figure(2);
plot(t,voa+vob,t,voi,':','LineWidth',2);
grid
legend('Circuit Response','Ideal Integrator')
axis([0 10 0 0.6])
title('Circuit and Ideal Integrator Comparison')
xl2 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl2 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl2,'FontSize',13);
set(yl2,'FontSize',13);

format short eng;
slope=mean(diff(voa(length(voa)/2+10:end)))/dt
ideal_slope=mean(diff(voi(length(voi)/2+10:end)))/dt

