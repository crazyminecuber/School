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

% Loser for frekvensen 10
[t_vec,Y] = ode45(@ekvationer, [0 t_max], [beta_0 beta_dot_0 phi_0 phi_dot_0 theta_0 theta_dot_0], options, l, g, m1, m2);
bet = Y(:,1);
bet_dot = Y(:,2);
phi = Y(:,3);
phi_dot = Y(:,4);
theta = Y(:,5);
theta_dot = Y(:,6);
% Uppgift 4
figure(1)
title("Angle plot")
xlabel("time (s)")
ylabel("Angel (deg)")
hold on
h1=plot(t_vec,(180/pi)*bet,"r");  %x1
h2=plot(t_vec,(180/pi)*phi,"g") ; %x1_dot
h3=plot(t_vec,(180/pi)*theta,"b") ; %x2
legend([h1,h2,h3],"\beta","\phi", "\theta");

%energi
T1 = m1/2 * l^(2).* ...
    ( abs(sin(bet).*bet_dot + cos(theta).*theta_dot/2) + abs(sin(theta).*theta_dot/2 - cos(bet).*bet_dot)).^2 ...
    + m1/24*l^2.*theta_dot.^2;
T2 = m2/2 * l^2.* ...
    ( abs(-sin(bet).*bet_dot + cos(phi).*phi_dot/2) + abs(sin(phi).*phi_dot/2 + cos(bet).*bet_dot) ).^2 ...
    + m2/24*l^2.*phi_dot.^2;
Vg1 = m1 * g * (-l*sin(bet) - (1 / 2)*l*cos(theta));
Vg2 = m2 * g * (l*sin(bet) - (1 / 2)*l*cos(phi));
energi = T1 + T2 + Vg1 + Vg2;

figure(2)
title("Energy plot")
xlabel("time (s)")
ylabel("Energi")
hold on
h4 = plot(t_vec,energi);
legend("Energi");