;A string of words is given. Build two strings of bytes, s1 and s2, in the following way: for each word,
;if the number of bits 1 from the high byte of the word is larger than the number of bits 1 from its low byte, then s1 will contain the high byte and s2 will contain the low byte of ;the word
;if the number of bits 1 from the high byte of the word is equal to the number of bits 1 from its low byte, then s1 will contain the number of bits 1 from the low byte and s2 will ;contain 0
;otherwise, s1 will contain the low byte and s2 will contain the high byte of the word.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    array dw 1231, 2312, 6565
    len equ ($-array) / 2
    s1 times len db 0
    s2 times len db 0
    
    ;1231 decimal -> 04CF hexa -> 0000 0100 1100 1111 -> ah = 1 al = 6
    ;2312 decimal -> 0908 hexa -> 0000 1001 0000 1000 -> ah = 2 al = 0
    ;6565 decimal -> 19A5 hexa -> 0001 1001 1010 0101 -> ah = 3 al = 4
    ;S1 = CF, 09, A5
    ;S2 = 04, 08, 19

; our code starts here
segment code use32 class=code
    start:
        mov esi, array
        cld ;go through the array from left to right
        mov ecx, len
        mov ebx, 0
        rpt:
            lodsw
 
            push ebx ;keeping the counter on stack
            mov ebx, 0 ;initializing ebx in order to count the number of apparitions for the 1 bit
            mov edx, 0 ;initializing edx in order to count the number of apparitions for the 1 bit
            
            push ecx ;keeping the number of remaining loops on stack
            mov ecx, 8 ;count_al will have 8 loops
            count_al:
                rol al, 1
                jnc next
                inc ebx
                next:
            loop count_al
            
            mov ecx, 8 ;count_ah will have 8 loops
            count_ah:
                rol ah, 1
                jnc next2
                inc edx
                next2:
            loop count_ah
            
            pop ecx
            cmp edx, ebx ;comparing the number of bits 1
            ja greater
            je equal
            jb smaller
            
            greater:
                pop ebx
                mov [s1+ebx], ah
                mov [s2+ebx], al
                jmp increment
            equal:
                mov edx, ebx
                pop ebx
                mov [s1+ebx], dl
                mov dl, 0
                mov [s2+ebx], dl
                jmp increment
            smaller:
                pop ebx
                mov [s1+ebx], al
                mov [s2+ebx], ah
                jmp increment
            increment:
                add ebx, 1
        loop rpt         
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
