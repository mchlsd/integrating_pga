clear 
clc
clf

GBW = 1e6;
R = 1e3;
C = 1e-9;

wt = 2*pi*GBW
Ao = 1e5;
wo = wt/Ao;
wc = 1/(R*C);
vi = 0.1;


dt = 0.01e-6;
t = 0:dt:10e-6 - dt;
u1 = vi*(heaviside(t)-heaviside(t-0.5e-5));
u2 = vi*(heaviside(t-0.5e-5));

H1 = tf([wt],[1 wt])
H2 = tf([wt wt*wc],[1 wc+wt 0])
H = lsim(H1,u1,t) + lsim(H2,u2,t)

A = tf([wt*wc],[(wc+wt) 0])
B = tf([wt^2/(wt+wc)],[1 wc+wt])

vo1 = lsim(H1,u1,t);
vo2 = lsim(H2,u2,t);
voa = lsim(A,u2,t);
vob = lsim(B,u2,t);
vof = vo1+voa+vob;
voi = vi+cumtrapz(u2)*dt*wc;

t = t*1e6;
f1 = figure(1);
plot(t,vo1,'--',t,vo2,t,voa,':',t,vob,'-.','LineWidth',2);
movegui(f1,[300 600]);
grid;
legend('H1','H2','A','B')
axis([0 10 0 0.6])
%title('Circuit Subsystems')
xl1 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl1 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl1,'FontSize',13);
set(yl1,'FontSize',13);

f2 = figure(2);
plot(t,vof,t,voi,':','LineWidth',2);
movegui(f2,[900 600]);
grid
legend('Circuit Response','Ideal Integrator')
axis([0 10 0 0.6])
%title('Circuit and Ideal Integrator Comparison')
xl2 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl2 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl2,'FontSize',13);
set(yl2,'FontSize',13);

f3 = figure(3);
plot(t,((voi-voi(1))*0.8)+vi,t,voi,':','LineWidth',2);
movegui(f3,[000 000]);
grid;
legend('Circuit Simulation','Ideal Integrator')
axis([0 10 0 0.6])
%title('Circuit Subsystems')
xl1 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
yl1 = ylabel({'Voltage (V)'},'Interpreter','latex')
set(xl1,'FontSize',13);
set(yl1,'FontSize',13);
 
% f4 = figure(4);
% plot(t,((voi-voi(1))*0.8)+vi,t,voi,':','LineWidth',2);
% movegui(f3,[900 900]);
% grid;
% 
% axis([0 10 0 0.6])
% %title('Circuit Subsystems')
% xl1 = xlabel({'Time ($\mu$s)'},'Interpreter','latex')
% yl1 = ylabel({'Voltage (V)'},'Interpreter','latex')
% set(xl1,'FontSize',13);
% set(yl1,'FontSize',13);
% hold on
% plot(t,((voi-voi(1))*0.50)+vi,t,voi,':','LineWidth',2);
% plot(t,((voi-voi(1))*0.65)+vi,t,voi,':','LineWidth',2);
% plot(t,((voi-voi(1))*0.95)+vi,t,voi,':','LineWidth',2);
% legend('Ideal','Simulation')

%%
format short eng;
slope=mean(diff(voa(length(voa)/2+10:end)))/dt
ideal_slope=mean(diff(voi(length(voi)/2+10:end)))/dt
error = (wc^2./(wt+wc))*vi

