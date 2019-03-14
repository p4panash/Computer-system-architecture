;Given the word A,obtain the doubleword B as follows:
;the bits 0-3 of B are the same as the bits 1-4 of the result A XOR 0Ah
;the bits 4-11 of B are the same as the bits 7-14 of A
;the bits 12-19 of B have the value 0
;the bits 20-25 of B have the value 1
;the bits 26-31 of C are the same as the bits 3-8 of A complemented

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0001110001110101b

; our code starts here
segment code use32 class=code
    start:
        
        mov ebx, 0 ; we compute the result in bx
        
        mov bx, 0
        mov ax, 0000001111110000b ;first 3 digits are 0
        or bx, ax ; the bits 20-25 have the value 1
        
        mov ax, [a]
        not ax ; complementing a
        and ax, 0000000111111000b ; isolating the bits 3-8 of A
        mov cl, 7
        rol ax, cl ; rotate ax 7 position to left
        or bx, ax ; we put the bits into the result
        
        mov cl, 16 
        rol ebx, cl ;moving the result into the first half of eax
        
        mov ax, [a]
        xor ax, 0Ah ; apling xor 0A on A        
        and ax, 0000000000011110b ; isolating 1-4 bits
        mov cl, 1
        ror ax, cl
        or bx, ax; moving the result in bx
        
        mov ax, [a]
        and ax, 0111111110000000b ; isolating 7-14 bits
        mov cl, 3 
        ror ax, cl ; move then 3 position back
        or bx, ax ; put result in bx
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
