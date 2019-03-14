; Ne propunem ca programul de mai jos sa citeasca de la tastatura un numar si sa afiseze pe ecran valoarea numarului citit impreuna cu un mesaj.
bits 32
global start        

; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf
                          
segment  data use32 class=data
	text times 200 db 0      ; in aceasta variabila se va stoca valoarea citita de la tastatura
    message  db "n=", 0
	format db "%s", 0  ; %d <=> un numar decimal (baza 10)
    print_format db "Ana are %s mere", 0
    
segment  code use32 class=code
    start:
                                               
       
        ; vom apela printf(message) => se va afisa "n="
        ; punem parametrii pe stiva
        push dword message ; ! pe stiva se pune adresa string-ului, nu valoarea
        call [printf]      ; apelam functia printf pentru afisare
        add esp, 4*1       ; eliberam parametrii de pe stiva ; 4 = dimensiunea unui dword; 1 = nr de parametri
                                                   
        ; vom apela scanf(format, n) => se va citi un numar in variabila n
        ; punem parametrii pe stiva de la dreapta la stanga
        push dword text       ; ! adresa lui n, nu valoarea
        push dword format
        call [scanf]       ; apelam functia scanf pentru citire
        add esp, 4 * 2     ; eliberam parametrii de pe stiva
                           ; 4 = dimensiunea unui dword; 2 = nr de parametri
                           
        push dword text
        push dword print_format
        call [printf]
        add esp, 4*2
        
        ; exit(0)
        push  dword 0     ; punem pe stiva parametrul pentru exit
        call  [exit]       ; apelam exit pentru a incheia programul