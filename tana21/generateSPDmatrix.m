function A = generateSPDmatrix(n,a,b)
    if ~ exist('a','var') && ~ exist('b','var')
        a=0;
        b=1;
    end
    % Generate a dense n x n symmetric, positive definite matrix

    A =  a + (b-a).*rand(n,n); % generate a random n x n matrix

    % construct a symmetric matrix using either
    A = 0.5*(A*A');
    %A = A*A';
    % since A(i,j) < 1 by construction and a symmetric diagonally dominant matrix
    %   is symmetric positive definite, which can be ensured by adding nI
    A = A + a + (b-a).*0.1*n*eye(n);

end