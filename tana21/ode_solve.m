function [y,x] = ode_solve(a,b,alpha, beta, p, q, r, n)
%%
%  Solves a general ODE in the form y''(x) = p(x)y'(x) + q(x)y(x) + r(x)
%  
%
%  INPUT: 
%    a   - scalar, start of intervall
%    b   - scalar, end of intervall
%    alpha  - scalar, y(a)
%    beta - scalar, y(b)
%     p - function p(x)
%     q - function q(x)
%     r - function r(x)
%     n - scalar, number points in intervall


%
%  OUTPUT:
%    x - n by 1 vector containing x-values
%    y - n by 1 vector containing x-values

h = (b - a) / (n -1);
    D = (1/(2*h))*ones([N,1]);
    Dx = diag(D,1)+diag(-D,-1)
    Dx(1,1) = -1/h;
    Dx(1,2) = 1/h;
    Dx(N+1,N+1) = 1/h;
    Dx(N+1,N) = -1/h;

%%
%  get the system size


end