struc Hamiltonian
    .M       resd 1
    .N       resd 1
    .h1      resq 1
    .h2      resq 1
    .E_nuc   resq 1
endstruc

section .data
align 32
; From OpenFermion + Psi4 (STO-3G, R = 0.74 Å)
; h_pq[p][q] — row-major, symmetric
h1_data:
    dq -0.766136, -0.116189,  0.000000,  0.000000
    dq -0.116189, -0.766136,  0.000000,  0.000000
    dq  0.000000,  0.000000, -1.112495, -0.116189
    dq  0.000000,  0.000000, -0.116189, -1.112495

h2_data:
    times 16 dq 0.0

E_nuc dq 0.715104