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
    e dw 4
    h dw 6
; our code starts here
segment code use32 class=code
    start:
        ;100/(e+h-3*a)
        
        ;CX = e + h
        mov CX, [e]
        add CX, [h]
        
        ;AL = 3 * a
        mov AL, 3
        mul byte[a]
        
        ;CX = CX - AX
        sub CX, AX
        
        ;AX = 100/ CX
        mov DX, 0
        mov AX, 100
        div CX
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
