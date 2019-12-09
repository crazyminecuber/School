from sympy.solvers import solve
from sympy import Symbol, Eq, latex, sympify, sin
from sympy.parsing.latex import parse_latex

def print_eq_order(vl,hl):
    eq = Eq(sympify(vl), sympify(hl))
    VL = ""
    HL = ""

    for word in vl.split(" "):
        if(word in ["+", "-"]):
            VL += " " + word + " "
            continue
        if(word in ["*"]):
            continue
        VL += latex(sympify(word, evaluate=False))

    for word in hl.split(" "):
        if(word in ["+", "-"]):
            HL += " " + word + " "
            continue
        if(word in ["*"]):
            continue
        HL += latex(sympify(word, evaluate=False))
    print(VL + " = " + HL + r"\\")
    return eq

v_R_G1 = 10**6
v_R_G2 = 10**6
v_R_D2 = 100
v_R_S1 = 200
v_R_S2 = 2*10**3
v_R_1 = 10*10**3
v_R_L = 2*10**3
v_E = 12
v_g_m = 4*10**-4
v_B = 100
v_h_11 = 2*10**3
v_I_CQ = 1 * 10**-3
v_U_CEQ = 4
v_U_DSQ = 5
v_I_DQ = 5 * 10**-3
t = Symbol('t')
v_u_in = sin(10**3 * sin(t))
v_U_BE = 0.7 
v_h_21 = 100
print(latex(v_u_in))



# Variabler för båda stegen
R_G1 = Symbol('R_G1')
R_D1 = Symbol('R_D1')
R_S1 = Symbol('R_S1')
R_1 = Symbol('R_1')
R_2 = Symbol('R_2')
R_3 = Symbol('R_3')
R_G2 = Symbol('R_G2')
R_D2 = Symbol('R_D2')
R_S2 = Symbol('R_S2')
R_L = Symbol('R_L')
E_1 = Symbol('E_1')
B = Symbol('B')

# Variabler för arbetspuktsbestämmning
I_G = Symbol('I_G')
I_3 = Symbol('I_3')
I_E = Symbol('I_E')
I_DQ = Symbol('I_DQ')
U_DSQ = Symbol('U_DSQ')
U_BE = Symbol('U_BE')
U_CEQ = Symbol('U_CEQ')
I_CQ = Symbol('I_CQ')
I_B = Symbol('I_B')
I_1 = Symbol('I_1')
I_2 = Symbol('I_2')

# Variabler för småsignalscheman
u_in = Symbol('u_in')
g_m = Symbol('g_m')
u_gs1 = Symbol('u_gs1')
i_1 = Symbol('i_1')
i_b = Symbol('i_b')
h_11 = Symbol('h_11')
u_1= Symbol('u_1')
h_21 = Symbol('h_21')
R_p1 = Symbol('R_p1')
R_p2 = Symbol('R_p2')
u_gs2 = Symbol('u_gs2')
v_2 = Symbol('v_2')
v_3 = Symbol('v_3')
v_1 = Symbol('v_1')
u_ut = Symbol('u_ut')
i_2 = Symbol('i_2')
u_2 = Symbol('u_2')
R_p3 = Symbol('R_p3')

values = {R_G1:v_R_G1, R_G2:v_R_G2, R_D2:v_R_D2, R_S1:v_R_S1, R_S2:v_R_S2, R_1:v_R_1, R_L:v_R_L, E_1:v_E, g_m:v_g_m, B:v_B, h_11:v_h_11, I_CQ:v_I_CQ, U_CEQ:v_U_CEQ, U_DSQ:v_U_DSQ, I_DQ:v_I_DQ, U_BE:v_U_BE, h_21:v_h_21}

# För R2
print()
print(r"För $r_2$")
print()
print(r"\begin{align}")
eq1 = print_eq_order("-R_1 * I_1 - U_BE - U_DSQ - I_DQ * R_S1","0")
eq2 = print_eq_order("I_CQ", "I_B * B")
eq3 = print_eq_order("E_1 - I_2 * R_2 + R_1 * I_1", "0")
eq4 = print_eq_order("I_B", "I_1 + I_2")
print(r"\end{align}")
print()

# För R3
print(r"För $R_3$")
print()
print(r"\begin{align}")
eq5 = print_eq_order("E_1 - R_3 * I_CQ - U_CEQ - U_DSQ - R_S1 * I_DQ", "0")
print(r"\end{align}")
print()

# För R_D1
print(r"För $R_D1$")
print()
print(r"\begin{align}")
eq6 = print_eq_order("E_1 - R_D1 * I_3 - U_DSQ - R_S1 * I_DQ", "0")
eq7 = print_eq_order("I_3 + I_E", "I_DQ")
eq8 = print_eq_order("I_E", "I_B + I_CQ")

print(r"\end{align}")
print()
print(r"För $u_ut$")
print()
print(r"\begin{align}")
eq9 = print_eq_order("R_p1", "(R_3*R_G2)/(R_3+R_G2)")
eq10 = print_eq_order("R_p2", "(R_S2*R_L)/(R_S2+R_L)")
eq11 = print_eq_order("u_gs1", "u_in")
eq12 = print_eq_order("u_1", "((h_11*R_D1)/(h_11+R_D1))*i_2")
#eq12 = print_eq_order("u_1", "R_p3 * i_2")
eq13 = print_eq_order("i_2", "g_m * u_gs1 - h_21 * i_b")
eq14 = print_eq_order("i_b", "- u_1/h_11")
eq15 = print_eq_order("u_2", "R_p1 * h_21 * i_b")
eq16 = print_eq_order("u_gs2", "-u_ut - u_2")
eq17 = print_eq_order("u_ut", "R_p2 * g_m * u_gs2")
eq18 = print_eq_order("i_2", "i_1 + i_b")

print(r"\end{align}")
print()
print("Solves")
print()
print(r"\begin{math}")

solved_r2 = solve((eq1,eq2,eq3,eq4), R_2,I_1, I_B, I_2)
solved_r3 = solve(eq5, R_3)
solved_r_d1 = solve((eq6, eq7, eq8, eq2), R_D1, I_3, I_E, I_B)
solved_u_ut = solve((eq9,eq10,eq11, eq12, eq13, eq14, eq15, eq16, eq17,eq18), u_ut,R_p1,R_p2, u_gs1, i_1, i_b, u_1, i_2, u_2, u_gs2)
#solved_u_ut = solve((eq11, eq14, eq13, eq12), u_gs1, i_b, i_2, u_1)
print(latex(solved_r2[0][0]) + r"\\")
print(latex(solved_r3[0]) + r"\\")
print(latex(solved_r_d1[0][0]) + r"\\")
print(latex(solved_u_ut[0][0]) + r"\\")
print(r"\end{math}")
print()

print("Evaluated")
print()
print(r"\begin{math}")
v_R_2 = float(latex(solved_r2[0][0].evalf(subs=values)))
v_R_3 = float(latex(solved_r3[0].evalf(subs=values)))
v_R_D1 = float(latex(solved_r_d1[0][0].evalf(subs=values)))
print("R_2 = " + str(v_R_2))
print("R_3 = " + str(v_R_3))
print("R_D1 = " + str(v_R_D1))
values = {R_G1:v_R_G1, R_G2:v_R_G2, R_D2:v_R_D2, R_S1:v_R_S1, R_S2:v_R_S2, R_1:v_R_1, R_L:v_R_L, E_1:v_E, g_m:v_g_m, B:v_B, h_11:v_h_11, I_CQ:v_I_CQ, U_CEQ:v_U_CEQ, U_DSQ:v_U_DSQ, I_DQ:v_I_DQ, U_BE:v_U_BE, h_21:v_h_21, R_2:v_R_2, R_3:v_R_3, R_D1:v_R_D1}
print("u_ut / u_in = " + latex(solved_u_ut[0][0].subs(values)))
print(r"\end{math}")