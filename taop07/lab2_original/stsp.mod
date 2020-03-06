problem stsp;

#set S1; # M�ngden som beskriver en subtur, definieras i stsp.dat
set NODES; # Antalet noder i handelsresandeproblemet (tsp)
set EDGES within (NODES cross NODES); # M�ngden m�jliga b�gar

param c {EDGES}; # B�gkostnad (avst�nd)
param Node_Pos{NODES, 1..2}; # Positioner f�r noder

var x {(i,j) in EDGES} >= 0, <=1; # Beslutsvariabler

minimize totallength: # L�gg till m�lfunktion h�r.

subject to valensvillkor {k in NODES}:
sum {(i,j) in EDGES: i==k || j==k} x[i,j] = 2;

# Modell f�r hur nya subtursf�rbjudande bivillkor kan adderas
#subject to subtur1:
#sum { i in S1, j in S1 : (i,j) in EDGES } x[i,j] <=  card(S1) - 1;
