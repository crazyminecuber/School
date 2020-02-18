function ydot=ekvationer(t,y,l,g,m1,m2)
bet=y(1);
bet_dot=y(2);
phi=y(3);
phi_dot=y(4);
theta=y(5);
theta_dot=y(6);

A = [sin(bet-theta),0,2/3;
    -sin(bet-phi),2/3,0;
    2*(m1+m2),-m2*sin(bet-phi),m1*sin(bet-theta)];
b = [-g/l * sin(theta) - cos(bet-theta) * bet_dot^2;
    -g/l * sin(phi) + cos(bet-phi) * bet_dot^2;
    2* g/l * (m1-m2) * cos(bet) + m1 * cos(bet-theta) * theta_dot^2 - m2 * cos(bet-phi) * phi_dot^2];

z = A \ b;

ydot=zeros(6,1);
ydot(1)=bet_dot;
ydot(2)=z(1);
ydot(3)=phi_dot;
ydot(4)=z(2);
ydot(5)=theta_dot;
ydot(6)=z(3);