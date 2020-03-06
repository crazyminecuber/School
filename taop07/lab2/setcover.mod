problem setcover;

param n; # Storleken på cellprovet
param d; # Storleken på mikroskopbilden

set B := 1..n-d+1;
set P := 1..n;

param b{k in P,l in P}; # De pixlar som ska övertäckas

var x{i in B, j in B} binary; # Anger om bildposition används
minimize antal_mikroskopbilder: sum {i in B}( sum {j in B} x[i,j]);
subject to cond {k in P, l in P: b[k,l] == 1}: sum {i in B: k-d<i && i<=k}( sum {j in B: l - d < j && j <= l} x[i,j]) >= 1;
