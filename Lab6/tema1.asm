bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll 
import printf msvcrt.dll   ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    array dw 1231, 2312, 32123
    len equ ($-array)
    s1 times len db 0
    s2 times len db 0

; our code starts here
segment code use32 class=code
    start:
        mov esi, array
        cld
        mov ecx, len
        mov ebx, 0
        repeta:
            lodsw
          
            mov dx, 0
            
            test ah, 1
            jz: end_ah
            push ecx
            jmp loop_count_ah
            
            end_ah:
            
            test al, 1
            jz: end_al
            jmp loop_count_al
            end_al:
            
            cmp dh, dl
            ja greater
            je equal
            jb less
            
            increment:
            inc ebx
        loop repeta
        
        jmp sfarsit
        
        loop_count_ah:
        
            
        count_al:
   
        
        greater:
            mov [s1+ebx], dh
            mov [s2+ebx], al
            jmp increment
        equal:
            mov [s1+ebx], dh
            mov al, 0
            mov [s2+ebx], al
            jmp increment
        less:
            mov [s2+ebx], dh
            mov [s1+ebx], dl
            jmp increment
        sfarsit:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
