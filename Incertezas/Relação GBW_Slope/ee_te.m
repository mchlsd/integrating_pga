clear 
clc
clf

wt = 6.28319e6;
Ao = 100000;
wo = 62.8319;
wc = 1000000;
vi = 0.1;


dt = 0.01e-6;
t = 0:dt:10e-6 - dt;
u1 = vi*(heaviside(t));
u2 = vi*(heaviside(t-0.5e-5));

H1 = tf([wt],[1 wt])
H2 = tf([wt wt*wc],[1 wc+wt 0])

A = tf([wt*wc],[(wc+wt) 0])
B = tf([wt^2/(wt+wc)],[1 wc+wt])

vo1 = lsim(ss(H1),u1,t,vi /ss(H1).C);
vo2 = lsim(ss(H2),u2,t);
voa = lsim(ss(A),u2,t);
vob = lsim(ss(B),u2,t);

t = t*1e6;
figure(1);
plot(t,vo1,'--',t,vo2,t,voa,':',t,vob,'-.','LineWidth',2);
grid;
legend('H1','H2','A','B')
axis([0 10 0 0.6])
title('Circuit Subsystems')
xl1 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl1 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl1,'FontSize',13);
set(yl1,'FontSize',13);

figure(2);
plot(t,voa+vob+vo1,t,voa+vi,':','LineWidth',2);
grid
legend('Circuit Response','Ideal Integrator')
axis([0 10 0 0.6])
title('Circuit and Ideal Integrator Comparison')
xl2 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl2 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl2,'FontSize',13);
set(yl2,'FontSize',13);

slope=mean(diff(voa(length(voa)/2+10:end)))/dt

