problem stsp;

set S1; # Mängden som beskriver en subtur, definieras i stsp.dat
set S2; # Mängden som beskriver en subtur, definieras i stsp.dat
set S3; # Mängden som beskriver en subtur, definieras i stsp.dat
set S4; # Mängden som beskriver en subtur, definieras i stsp.dat
set NODES; # Antalet noder i handelsresandeproblemet (tsp)
set EDGES within (NODES cross NODES); # Mängden möjliga bågar

param c {EDGES}; # Bågkostnad (avstånd)
param Node_Pos{NODES, 1..2}; # Positioner för noder

var x {(i,j) in EDGES} >= 0, <=1; # Beslutsvariabler

minimize totallength: sum {i in NODES, j in NODES: (i,j) in EDGES} c[i,j] * x[i,j];

subject to valensvillkor {k in NODES}:
sum {(i,j) in EDGES: i==k || j==k} x[i,j] = 2;

# Modell för hur nya subtursförbjudande bivillkor kan adderas
#subject to subtur1:
#sum { i in S1, j in S1 : (i,j) in EDGES } x[i,j] <=  card(S1) - 1;

#Bivilkor för uppgift 1
#subject to subtur1:
#sum { i in S1, j in S1 : (i,j) in EDGES } x[i,j] <=  card(S1) - 1;

#subject to subtur2:
#sum { i in S2, j in S2 : (i,j) in EDGES } x[i,j] <=  card(S2) - 1;

#subject to subtur3:
#sum { i in S3, j in S3 : (i,j) in EDGES } x[i,j] <=  card(S3) - 1;

#Bivilkor för uppgift 2

subject to subtur1:
sum { i in S1, j in S1 : (i,j) in EDGES } x[i,j] <=  card(S1) - 1;

subject to subtur2:
sum { i in S2, j in S2 : (i,j) in EDGES } x[i,j] <=  card(S2) - 1;

subject to subtur3:
sum { i in S3, j in S3 : (i,j) in EDGES } x[i,j] <=  card(S3) - 1;

subject to x68: x[6,8] = 0;

subject to subtur4:
sum { i in S4, j in S4 : (i,j) in EDGES } x[i,j] <=  card(S4) - 1;
