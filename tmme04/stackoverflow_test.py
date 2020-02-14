from sympy.physics.vector import *
from sympy import * 

t,l = symbols("t l")
R = ReferenceFrame('R')
Eq(5*R.x + t*R.y, l*R.x + 4*R.y)