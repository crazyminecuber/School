problem stsp;

#set S1; # Mängden som beskriver en subtur, definieras i stsp.dat
set NODES; # Antalet noder i handelsresandeproblemet (tsp)
set EDGES within (NODES cross NODES); # Mängden möjliga bågar

param c {EDGES}; # Bågkostnad (avstånd)
param Node_Pos{NODES, 1..2}; # Positioner för noder

var x {(i,j) in EDGES} >= 0, <=1; # Beslutsvariabler

minimize totallength: # Lägg till målfunktion här.

subject to valensvillkor {k in NODES}:
sum {(i,j) in EDGES: i==k || j==k} x[i,j] = 2;

# Modell för hur nya subtursförbjudande bivillkor kan adderas
#subject to subtur1:
#sum { i in S1, j in S1 : (i,j) in EDGES } x[i,j] <=  card(S1) - 1;
