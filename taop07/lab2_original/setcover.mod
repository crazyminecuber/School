problem setcover;

param n; # Storleken p� cellprovet
param d; # Storleken p� mikroskopbilden

set B := 1..n-d+1;
set P := 1..n;

param b{k in P,l in P}; # De pixlar som ska �vert�ckas

var x{i in B, j in B} binary; # Anger om bildposition anv�nds

# m�lfunktionsv�rdet ska d�pas till antal_mikroskopbilder
