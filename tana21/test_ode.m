%% Initial values
close all
p = @(x) -2./x;
q = @(x) 2./(x.^2);
r = @(x) sin( log(x) )./(x.^2);
a = 1;
alpha = 1;
b = 2;
beta = 2;
c2 = 1 / 70 * (8 - 12*sin( log(2) ) - 4*cos( log(2) ));
c1 = 11 / 10 - c2;
y_exact = @(x) c1 * x + c2 ./ x.^(2) - 3 / 10 * sin( log(x) ) - ... 
          1 / 10 * cos( log(x));
nodes = [10,20,40,80];
%% Calculations 
y = zeros(1,length(nodes));
x = zeros(1,length(nodes));    
er = zeros(1,length(nodes));
figure(1);
for n = 1:length(nodes)
    [y, x] = ode_solve(a,b,alpha,beta,p,q,r,nodes(n)); %Solve for y(x)

    er(n) = norm(y - y_exact(x),2); %calculate error
    %{ & 
    h{n} = subplot(2,2,n);
    hLine{n} = plot(x, y_exact(x),'-b',x,y, '--*r');
    xlabel('x')
    ylabel('y')
    numerical_legend=(['Numerical solution with ',num2str(nodes(n)), ...
        ' nodes']);
    legend('Exact solution',numerical_legend, 'location','northwest')
    %}
end
err =  er(1:end-1) ./ er(2:end)