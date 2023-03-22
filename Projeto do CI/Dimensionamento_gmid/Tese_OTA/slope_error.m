GBW2 = 10e6:10:120e6;
Ra = 1e6;
Ca = 1e-12;

wt = 2*pi*GBW2;
wc = 1/(Ra*Ca);

error = -wc^2./(wt+wc);
ideal = wc+0*wt;
alpha = (wt*wc)./(wt+wc);
percent_error = (error./ideal)*100;

h = figure
plot(GBW2/1e6,percent_error,'LineWidth',1.5,'color','red')
xlabel('{\it GBW} (MHz)')
ylabel('Erro médio de ganho (%)')
grid
set_fig_position(h,0,0,420,560)
