problem stspvalid;

set NODESP := {i in NODES: i != 1}; # Noder utom 1:an
set EDGESP within (NODESP cross NODESP) := 
  { (i,j) in EDGES: i != 1 && j != 1}; # B�gar utan de som ansluter till nod 1

param cx {EDGES}; # M�lfunktionskoefficienter f�r w

param k; # Fixerad nod

var w {(i,j) in EDGESP} >= 0, <=1; # Beslutsvariabel
var z {i in NODESP} >= 0, <=1; # Beslutsvariabel


# L�t m�lfunktionsv�rdet i separationsproblemet heta Slack
