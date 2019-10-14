function [x,k] = SOR(A,b,x0,omega,tol)
%%
%  Successive Over-relaxation iterative method to approximate the solution of a
%  linear system Ax=b up to a user defined tolerance
%
%  INPUT: 
%    A   - n by n square, non-singular matrix
%    b   - n by 1 right hand side vector
%    x0  - n by 1 vector containing that initial guess for the iteration
%    omega - Over-relaxation parameter
%    tol - user set tolerance for the stopping condition in the iteration 
%
%  OUTPUT:
%    x - n by 1 vector containing the iterative solution
%    k - number of iterations
%%
%  get the system size
   n = length(A);
   max_iter = 10^4;
   x = x0;
   xpre = x0;
   


%%
%  Gauss-Seidel iteration which overwrites the current approximate solution
%  with the new approximate solution
   for k = 1:max_iter
       for i = 1:n
           sum = 0;
           for j = 1:n
               if j ~= i
                   sum = sum + A(i,j) * x(j);
               end
           end
           % update the information in the solution vector
           x(i) = (1-omega) * x(i) + (omega/A(i,i)) * (b(i)-sum); 
       end
       r = b - A*x;
       if norm(r,2) < tol * norm(b,2)
           break
       end
   end
%
end