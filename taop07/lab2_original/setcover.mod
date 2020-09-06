problem setcover;

param n; # Storleken på cellprovet
param d; # Storleken på mikroskopbilden

set B := 1..n-d+1;
set P := 1..n;

param b{k in P,l in P}; # De pixlar som ska övertäckas

var x{i in B, j in B} binary; # Anger om bildposition används

# målfunktionsvärdet ska döpas till antal_mikroskopbilder
