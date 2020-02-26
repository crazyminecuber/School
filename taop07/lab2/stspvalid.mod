problem stspvalid;

set NODESP := {i in NODES: i != 1}; # Noder utom 1:an
set EDGESP within (NODESP cross NODESP) := 
  { (i,j) in EDGES: i != 1 && j != 1}; # Bågar utan de som ansluter till nod 1 (Ingen i<j? /Oskar)

param cx {EDGES}; # Målfunktionskoefficienter för w

param k; # Fixerad nod

var w {(i,j) in EDGESP} >= 0, <=1; # Beslutsvariabel
var z {i in NODESP} >= 0, <=1; # Beslutsvariabel


# Låt målfunktionsvärdet i separationsproblemet heta Slack
maximize Slack: 1 + (sum {e in EDGESP} cx[e] * w[e]) - (sum {i in NODESP} z[i]);

subject to cond1{(i,j) in EDGESP}: w[(i,j)] <= z[i]; # Mer krav på antal vilkor?(i,j) /Oskar
subject to cond2{(i,j) in EDGESP}: w[(i,j)] <= z[j]; 
subject to cond3{(i,j) in EDGESP}: w[(i,j)] <= z[i] + z[j] - 1; 
subject to fixnod: z[k] == 1;
