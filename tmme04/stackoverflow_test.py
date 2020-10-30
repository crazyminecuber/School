from sympy.vector import *
from sympy import * 

t, l = symbols("t l")
R = CoordSys3D('R')
eq1 = Eq(5*R.x + t*R.y, l*R.x + 4*R.y)
s = solve(eq1, t)
print(eq1)
print("")
print(s)
