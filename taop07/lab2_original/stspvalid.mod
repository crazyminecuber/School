problem stspvalid;

set NODESP := {i in NODES: i != 1}; # Noder utom 1:an
set EDGESP within (NODESP cross NODESP) := 
  { (i,j) in EDGES: i != 1 && j != 1}; # Bågar utan de som ansluter till nod 1

param cx {EDGES}; # Målfunktionskoefficienter för w

param k; # Fixerad nod

var w {(i,j) in EDGESP} >= 0, <=1; # Beslutsvariabel
var z {i in NODESP} >= 0, <=1; # Beslutsvariabel


# Låt målfunktionsvärdet i separationsproblemet heta Slack
