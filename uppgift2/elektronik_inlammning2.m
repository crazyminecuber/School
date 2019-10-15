clear
r1 = 1000;
r2 = 1000;
r3 = 10;
c1 = 2 * 1e-6;
c2 = 1 * 1e-6;
l1 = 10 * 1e-3;
n1n2 = 10;
omega = 1000;
I0 = 10e-3;
zi = 100*exp(i*(pi/4));

U0 = zi * I0; 
Ae1 = 1/r1 + 1/(r2 + 1/(i*omega*c1)) + i * omega *c2;
At = 1/r3 + 1/(i * omega * l1);

ze1 = 1 / Ae1;
zt = 1/ At ;
ZT = zt;

z_prim_t = (n1n2 ^ 2 ) * zt;

z_e2 = (ze1 * z_prim_t) / (ze1 + z_prim_t);

u_ab = (z_e2*U0) / (z_e2 + zi);
U_ab = u_ab;

U = u_ab / n1n2;


disp("U = ");
disp(U);

%-------------------------------------------------------------------------------


Ie = abs(U/zt)/sqrt(2);

Q = imag(zt) * Ie ^ 2;
P = real(zt) * Ie ^ 2;


disp("Q = ");
disp(Q);
disp("P = ");
disp(P);






%-------------------------------------------------------------------------------


A_prim_i = 1 / (zi');

Ak = 1 / z_prim_t + 1 / (r2 + 1 / (i * omega * c1));
R1 = 1 / (real(A_prim_i) - real(Ak));
C2 = (imag(A_prim_i) - imag(Ak)) / (omega);

disp("R1 = ");
disp(R1);
disp("C2 = ");
disp(C2);

%-------------------------------------------------------------------------------

r_v = 0:5:400;
c_v = 0:1e-7:1e-4;

[C,R] = meshgrid(c_v,r_v);

Ae1 = 1./R + 1/(r2 + 1/(i*omega*c1)) + i * omega .* C;
At = 1/r3 + 1/(i * omega * l1);

ze1 = 1 ./ Ae1;
zt = 1 ./ At ;

z_prim_t = (n1n2 ^ 2 ) .* zt;

z_e2 = (ze1 .* z_prim_t) ./ (ze1 + z_prim_t);

u_ab = (z_e2.*U0) ./ (z_e2 + zi);





Ie = abs(u_ab./z_e2);

Q = imag(z_e2) .* (Ie .^ 2);
P = real(z_e2) .* (Ie .^ 2);

Z = P;
%Z = C + R;

surf(C,R, Z);

xlabel("Capacitance");
ylabel("Resistance");
zlabel("Power");