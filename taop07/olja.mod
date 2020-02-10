set PRODUKTER;
set RAFFINADERIER;
set TERMINALER;

param ovre{p in PRODUKTER, t in TERMINALER};
param undre{p in PRODUKTER, t in TERMINALER};
param pris{p in PRODUKTER, t in TERMINALER};
param milkostn;
param avstand{r in RAFFINADERIER, t in TERMINALER};
param raffkostn{p in PRODUKTER, r in RAFFINADERIER};
param raffkap{r in RAFFINADERIER};

