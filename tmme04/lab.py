#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sympy.vector import CoordSys3D
from sympy import * 

def print_as_eqn(thing):
    print(r"\begin{equation}")
    print(latex(thing))
    print(r"\end{equation}")

print(r"\documentclass[a3paper,7pt]{article}")
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

A = CoordSys3D('Sys')
phi, theta, beta,t = symbols('phi theta beta t')
m1,m2,g = symbols('m1, m2, g')
phi = Function('phi')(t)
theta = Function('theta')(t)
beta = Function('beta')(t)

B,Bx,By,l = symbols('B Bx By l')
Bx = l*(-cos(beta))
By = l*(-sin(beta))
B = Bx*A.i + By*A.j + 0*A.k

C,Cx,Cy = symbols('C Cx Cy')
Cx = l*(cos(beta))
Cy = l*(sin(beta))
C = Cx*A.i + Cy*A.j + 0*A.k

C_G2,C_G2x,C_G2y = symbols('C_G2 Cx_G2 Cy_G2')
C_G2x = (l / 2)*(sin(phi))
C_G2y = (l / 2)*(-cos(phi))
C_G2 = C_G2x*A.i + C_G2y*A.j + 0*A.k

B_G1,B_G1x,B_G1y = symbols('B_G1 B_G1x B_G1y')
B_G1x = (l / 2)*(sin(theta))
B_G1y = (l / 2)*(-cos(theta))
B_G1 = B_G1x*A.i + B_G1y*A.j + 0*A.k

a_g1, a_g2 = symbols("a_g1 a_g2")

print_as_eqn(B + B_G1)
print_as_eqn(C + C_G2)

print_as_eqn(Derivative(B + B_G1 , t, evaluate=True))
print_as_eqn(Derivative(C + C_G2 , t, evaluate=True))

a_g1 = Derivative(B + B_G1 , t,t, evaluate=True)
a_g2 = Derivative(C + C_G2 , t,t, evaluate=True)
print_as_eqn(a_g1)
print_as_eqn(a_g2)

kropp1 = Eq(-B_G1.cross(m1*g*A.j), ((m1 * l ** 2) / 12) * Derivative(theta, t,t)* A.k + B_G1.cross(m1*a_g1))

#kropp2 = Eq(-CG2.cross(m2*g*A.j), ((m2*l**2) / 12) * Derivative(phi,t,t)*A.k + C_G2.cross(m2 * a_g2))
print_as_eqn(kropp1)
print_as_eqn( B_G1.cross(m1*a_g1))
print_as_eqn( B_G1)
print_as_eqn( m1*a_g1)
print_as_eqn(Eq(sin(theta)/2 * (Derivative(-beta,t)*cos(beta)+(Derivative(beta,t))**2*sin(beta)+Derivative(theta,t,t)/2 *sin(theta)+(Derivative(theta,t))**2*cos(theta)) + cos(theta)/2*(Derivative(beta,t,t)*sin(beta)+(Derivative(beta,t))**2*cos(beta)+Derivative(theta,t,t)/2*cos(theta)+(Derivative(theta,t))**2*sin(theta)/2),51))
#print_as_eqn(solve(kropp1, l))
print(r"\end{document}")