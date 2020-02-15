#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sympy.physics.vector import *
from sympy import * 

def print_as_eqn(thing, word=""):
    print("")
    print(word)
    print(r"\begin{equation}")
    print(latex(thing))
    print(r"\end{equation}")
    print("")

print(r"\documentclass[a3paper,2pt]{article}")
print(r"\usepackage[utf8]{inputenc}")
print(r"\usepackage{pdfpages}")
print(r"\usepackage[swedish]{babel}")
print(r"\usepackage[T1]{fontenc}")
print(r"\usepackage{float}")
print(r"\usepackage{mathtools}")
print(r"\usepackage{amsmath}")
print(r"\usepackage[margin=0.1cm]{geometry}")
print(r"\begin{document}")
print(" ")

R = ReferenceFrame('R')
phi, theta, beta,t = symbols('phi theta beta t')
m1,m2,g = symbols('m1, m2, g')
phi = Function('phi')(t)
theta = Function('theta')(t)
beta = Function('beta')(t)

B,Bx,By,l = symbols('B Bx By l')
Bx = l*(-cos(beta))
By = l*(-sin(beta))
B = Bx*R.x + By*R.y + 0*R.z

C,Cx,Cy = symbols('C Cx Cy')
Cx = l*(cos(beta))
Cy = l*(sin(beta))
C = Cx*R.x + Cy*R.y + 0*R.z

C_G2,C_G2x,C_G2y = symbols('C_G2 Cx_G2 Cy_G2')
C_G2x = (l / 2)*(sin(phi))
C_G2y = (l / 2)*(-cos(phi))
C_G2 = C_G2x*R.x + C_G2y*R.y + 0*R.z

B_G1,B_G1x,B_G1y = symbols('B_G1 B_G1x B_G1y')
B_G1x = (l / 2)*(sin(theta))
B_G1y = (l / 2)*(-cos(theta))
B_G1 = B_G1x*R.x + B_G1y*R.y + 0*R.z

a_g1, a_g2 = symbols("a_g1 a_g2")

r_g1= (B + B_G1)
r_g2= (C + C_G2)

v_g1 = (B + B_G1).diff(t,R)
v_g2 = (C + C_G2).diff(t,R)

a_g1 = (B + B_G1).diff(t,R).diff(t,R)
a_g2 = (C + C_G2).diff(t,R).diff(t,R)
print_as_eqn(r_g1, "rg1")
print_as_eqn(r_g2, "rg2")
print_as_eqn(v_g1, "vg1")
print_as_eqn(v_g2, "vg2")
print_as_eqn(a_g1, "ag1")
print_as_eqn(a_g2, "ag2")

print_as_eqn(v_g1.magnitude(), "absvg1")
print_as_eqn(v_g2.magnitude(), "absvg2")

print_as_eqn(v_g1.magnitude().simplify(), "Simple absvg1")
print_as_eqn(v_g2.magnitude().simplify(), "Simple absvg2")

print(r"\newpage")
kropp11 = (-B_G1).cross(m1*g*R.y)
kropp11_sim = kropp11.simplify()
kropp12 = ((m1 * l ** 2) / 12) * theta.diff(t).diff(t) * R.z + B_G1.cross(m1*a_g1)
kropp12_sim = kropp12.simplify()
kropp1 = Eq(dot(kropp11_sim,R.z),dot(kropp12_sim, R.z))
kropp1_sim = kropp1.simplify()

print_as_eqn(kropp11,'VL kropp 1')
print_as_eqn(kropp12,'HL kropp 1')
print_as_eqn(kropp11_sim,'simple VL kropp 1')
print_as_eqn(kropp12_sim,'simple HL kropp 1')
print_as_eqn(kropp1,'kropp1')
print_as_eqn(kropp1_sim,'simple kropp1')

kropp21 = -C_G2.cross(m2*g*R.y).simplify()
kropp21_sim = kropp21.simplify()
kropp22 = ((m2 * l **2) / 12) * phi.diff(t).diff(t)*R.z + C_G2.cross(m2 * a_g2).simplify()
kropp22_sim = kropp22.simplify()
kropp2 = Eq(dot(kropp21_sim,R.z),dot(kropp22_sim, R.z))
kropp2_sim = kropp2.simplify()

print_as_eqn(kropp21,'VL kropp 2')
print_as_eqn(kropp22,'HL kropp 2')
print_as_eqn(kropp21_sim,'simple VL kropp 2')
print_as_eqn(kropp22_sim,'simple HL kropp 2')
print_as_eqn(kropp2,'kropp2')
print_as_eqn(kropp2_sim,'simple kropp2')

hela1 = ((-B).cross(m1*g*R.y) - C.cross(m2*g*R.y))
hela2 = (B.cross(m1*a_g1) + C.cross(m2*a_g2))
hela1_sim = hela1.simplify() 
hela2_sim = hela2.simplify() 

hela = Eq(dot(hela1_sim,R.z),dot(hela2_sim, R.z))
hela_sim = hela.simplify()

print_as_eqn(hela1,'VL hela')
print_as_eqn(hela2,'HL hela')
print_as_eqn(hela1_sim,'simple VL hela')
print_as_eqn(hela2_sim,'simple HL hela')
print_as_eqn(hela,'hela')
print_as_eqn(hela_sim,'simple hela')


T1, T2, Vg1, Vg2 = symbols("T1 T2 Vg1 Vg2")
T1 = m1/8 * l**(2)* abs(4*sin(beta-theta)*beta.diff(t)*theta.diff(t) + 4*(beta.diff(t)**2 + theta.diff(t)**2)) + m1/24*l**2*theta.diff(t)**2;
T2 = m2/8 * l**2* abs(-4*sin(beta - phi)*beta.diff(t)*phi.diff(t) + 4*(beta.diff(t)**2+phi.diff(t)**2)) +m2/24*l**2*phi.diff(t)**2;
Vg1 = m1 * g * (-l*sin(beta) - (1 / 2)*l*cos(theta));
Vg2 = m2 * g * (l*sin(beta) - (1 / 2)*l*cos(phi));

energi = T1 + T2 + Vg1 + Vg2;

print_as_eqn(T1,'T1')
print_as_eqn(T2,'T2')
print_as_eqn(Vg1,'Vg1')
print_as_eqn(Vg2,'Vg2')

print_as_eqn(energi, "energi")

A = Matrix([[sin(beta-theta),0,2/3],
    [-sin(beta-phi),2/3,0],
    [2*(m1+m2),-m2*sin(beta-phi),m1*sin(beta-theta)]])
b = Matrix([-g/l * sin(theta) - cos(beta-theta) * (beta.diff(t))**2,
    -g/l * sin(phi) + cos(beta-phi) * (beta.diff(t))**2,
    2* g/l * (m1-m2) * cos(beta) + m1 * cos(beta-theta) * theta.diff(t)**2 - m2 * cos(beta-phi) * (phi.diff(t))**2])
print_as_eqn(A, "A") 
print_as_eqn(b, "b") 
#solved = solve((kropp1,kropp2,hela),phi.diff(t).diff(t), theta.diff(t).diff(t), beta.diff(t).diff(t))

print(r"\end{document}")