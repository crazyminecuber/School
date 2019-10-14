n = 10;
a = 0;
b = 1;
%A = generateSPDmatrix(n,a,b);

A = rand(n);
A=A*A';

try chol(A);
    disp('Matrix is SPD')
catch ME
    disp('Matrix is not SPD')
end
b = rand(n,1);
x0 = ones(n,1);
tol = 10^(-9);
i = 1:100;
omega = linspace(1,2,length(i));
k = zeros(length(i),1);
for t = i
    [x,k(t)] = SOR(A,b,x0,omega(t),tol);
end
plot(omega,k)
xlabel('\omega')
ylabel('Iterations')