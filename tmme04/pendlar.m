clear;
close all;
g = 9.81;
m1 = 1;
m2 = 4;
l = 1;
beta_0 = deg2rad(0);
beta_dot_0 = 0;
phi_0 = deg2rad(160);
phi_dot_0 = 0;
theta_0 = 0;
theta_dot_0 = 0;

t_max=40;

options = odeset("RelTol",1e-6,"AbsTol",1e-10);

[t_vec,Y] = ode45(@ekvationer, [0 t_max], [beta_0 beta_dot_0 phi_0 phi_dot_0 theta_0 theta_dot_0], options, l, g, m1, m2);
bet = Y(:,1);
bet_dot = Y(:,2);
phi = Y(:,3);
phi_dot = Y(:,4);
theta = Y(:,5);
theta_dot = Y(:,6);
% Uppgift 4
figb = figure(1);
figb.Position= [1 1 1920 1080];
title("Beta angle plot")
xlabel("time (s)")
ylabel("Angel (deg)")
hold on
h1=plot(t_vec,(180/pi)*bet,"r");  %x1
lgd1 = legend("\beta");
lgd1.FontSize = 16;

figp = figure(2);
figp.Position= [1 1 1920 1080];
title("Phi angle plot")
xlabel("time (s)")
ylabel("Angel (deg)")
hold on
h3=plot(t_vec,(180/pi)*phi,"b");  %x2
lgd2 = legend("\phi");
lgd2.FontSize = 16;

figt = figure(3);
figt.Position= [1 1 1920 1080];
title("Theta angle plot")
xlabel("time (s)")
ylabel("Angel (deg)")
hold on
h3=plot(t_vec,(180/pi)*theta,"k");  %x3
lgd3 = legend("\theta");
lgd3.FontSize = 16;



%energi
T1 = m1/2 * l^(2).* ...
    (bet_dot.^2 + theta_dot.^(2)/4 + bet_dot.* theta_dot.*sin(bet - theta) ) ...
    + m1/24*l^2.*theta_dot.^2;
T2 = m2/2 * l^2.* ...
    (bet_dot.^2 + phi_dot.^(2)/4 + bet_dot.* phi_dot.*sin(phi - bet) ) ...
    + m2/24*l^2.*phi_dot.^2;
Vg1 = m1 * g * (-l*sin(bet) - (1 / 2)*l*cos(theta));
Vg2 = m2 * g * (l*sin(bet) - (1 / 2)*l*cos(phi));
energi = T1 + T2 + Vg1 + Vg2;

fige = figure(4);
fige.Position= [1 1 1920 1080];
title("Energy plot")
xlabel("time (s)")
ylabel("Energy")
hold on
h4 = plot(t_vec,energi);
lgd4 = legend("Energy");
lgd4.FontSize = 16;

saveas(figb,"beta_angle_plot.png");
saveas(figp,"phi_angle_plot.png");
saveas(figt,"theta_angle_plot.png");
saveas(fige,"energy_plot.png");

options = odeset();

[t_vec,Y] = ode45(@ekvationer, [0 t_max], [beta_0 beta_dot_0 phi_0 phi_dot_0 theta_0 theta_dot_0], options, l, g, m1, m2);
bet = Y(:,1);
bet_dot = Y(:,2);
phi = Y(:,3);
phi_dot = Y(:,4);
theta = Y(:,5);
theta_dot = Y(:,6);

T1 = m1/2 * l^(2).* ...
    (bet_dot.^2 + theta_dot.^(2)/4 + bet_dot.* theta_dot.*sin(bet - theta) ) ...
    + m1/24*l^2.*theta_dot.^2;
T2 = m2/2 * l^2.* ...
    (bet_dot.^2 + phi_dot.^(2)/4 + bet_dot.* phi_dot.*sin(phi - bet) ) ...
    + m2/24*l^2.*phi_dot.^2;
Vg1 = m1 * g * (-l*sin(bet) - (1 / 2)*l*cos(theta));
Vg2 = m2 * g * (l*sin(bet) - (1 / 2)*l*cos(phi));
energi = T1 + T2 + Vg1 + Vg2;

fige_d = figure(5);
fige_d.Position= [1 1 1920 1080];
title("Energy plot with default options")
xlabel("time (s)")
ylabel("Energy")
hold on
h4 = plot(t_vec,energi);
lgd5 = legend("Energy");
lgd5.FontSize = 16;

saveas(fige_d,"energy_plot_d.png");
