%include "hamiltonian.inc"
default rel

extern printf
extern ExitProcess

section .data
    msg_orb db "Spin-orbitals: %d",13,10,0
    msg_E   db "Computed <psi|H|psi> = %.6f Ha",13,10,0

section .bss
    ham       resb Hamiltonian_size
    occ       resq 1

section .text
global main
main:
    sub rsp, 40

    mov dword [ham + Hamiltonian.M], 4
    mov dword [ham + Hamiltonian.N], 2
    lea rax, [h1_data]
    mov [ham + Hamiltonian.h1], rax
    lea rax, [h2_data]
    mov [ham + Hamiltonian.h2], rax
    mov rax, [E_nuc]
    mov [ham + Hamiltonian.E_nuc], rax

    lea rcx, [msg_orb]
    mov edx, [ham + Hamiltonian.M]
    call printf

    mov qword [occ], 3             ; |0011>

    call compute_energy

    lea rcx, [msg_E]
    mov rdx, rax
    call printf

    add rsp, 40
    xor ecx, ecx
    call ExitProcess

compute_energy:
    vxorpd xmm0, xmm0, xmm0
    mov r8, [ham + Hamiltonian.h1]
    mov r9, 0
outer_p:
    mov r10, 0
outer_q:
    ; h_pq = h1[p*4 + q] — row-major
    mov rax, r9
    imul rax, 4
    add rax, r10
    shl rax, 3
    vmovsd xmm1, [r8 + rax]

    bt [occ], r9
    setc al
    movzx eax, al
    cvtsi2sd xmm2, rax

    bt [occ], r10
    setc al
    movzx eax, al
    cvtsi2sd xmm3, rax

    vmulsd xmm2, xmm2, xmm3
    vmulsd xmm1, xmm1, xmm2
    vaddsd xmm0, xmm0, xmm1        

    inc r10
    cmp r10, 4
    jl outer_q
    inc r9
    cmp r9, 4
    jl outer_p

    vmovsd xmm1, [ham + Hamiltonian.E_nuc]
    vaddsd xmm0, xmm0, xmm1
    movq rax, xmm0
    ret