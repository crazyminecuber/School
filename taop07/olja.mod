set PRODUKTER;
set RAFFINADERIER;
set TERMINALER;

param ovre{p in PRODUKTER, t in TERMINALER};        # u_pt
param undre{p in PRODUKTER, t in TERMINALER};       # l_pt
param pris{p in PRODUKTER, t in TERMINALER};        # f_pt
param milkostn;                                     # k
param avstand{r in RAFFINADERIER, t in TERMINALER}; # d_rt
param raffkostn{p in PRODUKTER, r in RAFFINADERIER};# q_pr
param raffkap{r in RAFFINADERIER};                  # K_r

var x_pr{p in PRODUKTER, r in RAFFINADERIER} >= 0;
var z_prt{p in PRODUKTER, r in RAFFINADERIER, TERMINALER} >= 0;

maximize z: sum {sum { sum{pris[p,t] - milkostn * avstand[r,t] t in TERMINALER} r in RAFFINADERIER} in p in PRODUKTER} -
sum { sum{raffkostn[p,r]*x_pr[p,r] in PRODUKTER} in RAFFINADERIER};

subject to efterfragadkvantitet {p in PRODUKTER, t in TERMINALER}:
undre[p,t] <= sum {z[p,r,t] in RAFFINADERIER} <= ovre[p,t];

subject to inlikaut {p in PRODUKTER, r in RAFFINADERIER}:
x[p,r] = sum { z[p,r,t], in TERMINALER};

subject to inteover {r in RAFFINADERIER}:
sum {x[p,r] in PRODUKTER} <= raffkap[r];
