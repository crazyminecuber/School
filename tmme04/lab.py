#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sympy.physics.vector import *
from sympy import * 

def print_as_eqn(thing, word=""):
    print(word)
    print(r"\begin{equation}")
    print(latex(thing))
    print(r"\end{equation}")

print(r"\documentclass[a1paper,2pt]{article}")
print(r"\usepackage[utf8]{inputenc}")
print(r"\usepackage{pdfpages}")
print(r"\usepackage[framed, numbered]{matlab-prettifier}")
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

print_as_eqn(B + B_G1)
print_as_eqn(C + C_G2)

print_as_eqn((B + B_G1).diff(t,R))
print_as_eqn((C + C_G2).diff(t,R))

a_g1 = (B + B_G1).diff(t,R).diff(t,R)
a_g2 = (C + C_G2).diff(t,R).diff(t,R)
print_as_eqn(a_g1)
print_as_eqn(a_g2)

kropp11 = (-B_G1).cross(m1*g*R.y).simplify()
kropp12 = ((m1 * l ** 2) / 12) * theta.diff(t).diff(t) * R.z + B_G1.cross(m1*a_g1).simplify()
kropp1 = Eq(dot(kropp11,R.z),dot(kropp12, R.z)).simplify()
kropp21 = -C_G2.cross(m2*g*R.y).simplify()
kropp22 = ((m2 * l **2) / 12) * phi.diff(t).diff(t)*R.z + C_G2.cross(m2 * a_g2).simplify()
kropp2 = Eq(dot(kropp21,R.z),dot(kropp22, R.z)).simplify()

hela1 = ((-B).cross(m1*g*R.y) - C.cross(m2*g*R.y)).simplify()
hela2 = (B.cross(m1*a_g1) + C.cross(m2*a_g2)).simplify()


hela = Eq(dot(hela1,R.z),dot(hela2, R.z)).simplify()

print_as_eqn(kropp11,'VL kropp 1')
print_as_eqn(kropp12,'HL kropp 1')
print_as_eqn(kropp21,'VL kropp 2')
print_as_eqn(kropp22,'HL kropp 2')
print_as_eqn(kropp1,'Kropp 1')
print_as_eqn(kropp2,'Kropp 2')
print_as_eqn(hela1,'Hela kroppen VL')
print_as_eqn(hela2,'Hela kroppen HL')
solved = solve((kropp1,kropp2,hela),phi.diff(t).diff(t), theta.diff(t).diff(t), beta.diff(t).diff(t))
print_as_eqn(solved["Derivative(beta(t), (t, 2))"].simplify(), "phi dd")
#print_as_eqn(theta_dd.simplify(), "theta dd")
#print_as_eqn(beta_dd.simplify(), "beta dd")
#print_as_eqn(a_g1.dot(3*R.y))
#print_as_eqn(sin(theta)/2 * (Derivative((beta),t,t)*(-cos(beta))+(Derivative(beta,t))**2*sin(beta)+Derivative(theta,t,t)/2 *(sin(theta)/2)+(Derivative(theta,t))**2*cos(theta)) + cos(theta)/2*(Derivative(beta,t,t)*sin(beta)-(Derivative(beta,t))**2*cos(beta)+Derivative(theta,t,t)/2*cos(theta)+(Derivative(theta,t))**2*sin(theta)/2))
#print_as_eqn(solve(kropp1, l))
print(solved)
print(r"\end{document}")