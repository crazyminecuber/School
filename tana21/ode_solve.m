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

   
%%
    %Initial values
    h = (b - a) / (n - 1);
    x = (a:h:b)';
    
    %Create diagonal matrix
    Dn1 = 1 + p( x(3:end-1) ) * h / 2;
    D0 = -2 - h^(2) * q(x(2:end-1));
    Dp1 = 1 - h / 2 * p( x( 2:end-2 ) );
    Dx = diag(Dp1,1) + diag(D0,0) + diag(Dn1,-1);
    
    %Create the right hand side of the equation system
    HL = zeros(length(x)-2,1);
    HL(1) = - (1 + p(x(2)) * h / 2) * alpha;
    HL(end) = - (1 - h / 2 * p( x(end-1) )) * beta;
    b = h^2 * r(x(2:end - 1)) + HL;
    
    %Solve the equation system using SOR
    y0 = x(2:end-1);
    tol = 10^(-9);
    %{ 
    %Remove this comment section to find omega wich solves the equation the fastest
    i = 1:100;
    omega = linspace(1,2,length(i));
    k = zeros(length(i),1);
    for t = i
        [y,k(t)] = SOR(Dx,b,y0,omega(t),10^-9);
    end
    figure
    plot(omega,k)
    xlabel('\omega')
    ylabel('Iterations')
    %}
    
    [y, k] = SOR(Dx,b,y0,1,10^-9); % Comment this out when solving with different omega
    k
    y = [alpha; y; beta];

end