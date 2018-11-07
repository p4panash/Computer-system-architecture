bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2
    b db 1
    c db 3
    d dw 4
    

; our code starts here
segment code use32 class=code
    start:
        ;[(a-b)*5+d]-2*c = 3
        ;AX=(a-b)*5
        mov AL, [a]
        sub AL, [b]
        mov CL, 5
        mul CL
        
        ;BX=AX+d
        mov BX, AX
        add BX, [d]
        
        ;AX=c*2
        mov AL, [c]
        mov CL, 2
        mul CL
        
        ;DX = AX
        ;AX = BX
        mov DX, AX
        mov AX, BX
        
        ;AX = AX - DX
        sub AX, DX
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
