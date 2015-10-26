EXTERN text,bss,end,InitKernel
mboot: 
dd 0x1BADB002 ; Sygnatura 
dd 0x10001 ; Flagi dla bootloadera 
dd -(0x1BADB002+0x10001) ; suma kontrolna nagłówka 
dd mboot ; Pozycja nagłówka w pliku 
dd text
dd bss 
dd end 
dd _start

_start:
xchg bx,bx
cli 
hlt
 



