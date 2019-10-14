function fprim = c_diff(N,f,a,b)
%C_DIFF Summary of this function goes here
%   Detailed explanation goes here

    h = 1/N;
    xi = 0:1/N:1;
    fv = f(xi');
    D = (1/(2*h))*ones([N,1]);
    Dx = diag(D,1)+diag(-D,-1);
    Dx(1,1) = -1/h;
    Dx(1,2) = 1/h;
    Dx(N+1,N+1) = 1/h;
    Dx(N+1,N) = -1/h;
    fprim = Dx*fv;
end

