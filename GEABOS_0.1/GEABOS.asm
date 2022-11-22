;VERSION 0.1 OF GEABOS: UNDER GPLv3 LICENSE
BITS 16
[org 0x7c00] 
boot:
mov ah, 0x0e
mov si, welcome
call printf

mov bp, 0x8000
mov sp, bp
mov dl, 0

mov ah, 0x0e
mov al, '>'
int 0x10

jmp main


printf:
    mov al, [si]
    cmp al, 0
    je done
    int 0x10
    inc si
    jmp printf
done:
ret





main:
mov ah, 0
int 0x16

cmp al, 0DH
je newlprint

mov ah, 0x0e
int 0x10

cmp al, 4CH
je adL

cmp al, 53H
je adshut

cmp al, 43H
je adclr

cmp al, 55H
je adpus

cmp al, 4FH
je adpop

cmp al, 4DH
je adcomp

cmp al, 2FH
je swdl

mov bl, 0
jmp main



newlprint:

cmp bl, 4CH
je showlist

cmp bl, 43H
je clearscr

cmp bl, 55H
call printnew
je push

cmp bl, 4FH
call printnew
je pop

cmp bl, 53H
je shutdown

cmp bl, 4DH
je compare

donefun:
mov ah, 0x0e
mov si, newln
call printf
mov ah, 0x0e
mov al, '>'
int 0x10


jmp main


adL:
mov bl, 4CH
jmp main

adclr:
mov bl, 43H
jmp main

adpus:
mov bl, 55H
jmp main

adpop:
mov bl, 4FH
jmp main


adshut:
mov bl, 53H
jmp main

adcomp:
mov bl, 4DH
jmp main

swdl:
cmp dl, 0
je dln
mov dl, 0
jmp main
dln:
mov dl, 1
jmp main

showlist:

mov ah, 0x0e
mov si, newln
call printf

mov ah, 0x0e
mov si, list
call printf

jmp donefun

clearscr:
mov ah,0
mov al,13h
int 10h

mov al,03h
int 10h

mov ah, 0x0e
mov al, '>'
int 0x10

jmp main




compare:
pop ax
mov cl, al
pop ax
cmp cl, al
mov al,0
mov cl,0
mov ah, 0x0e
je yesd
mov si, newln
call printf
mov si, no
call printf
jmp donefun
yesd:
mov si, newln
call printf
mov si, yes
call printf
jmp donefun


push:
cmp dl, 1
je nonepri
mov ah, 0x0e
mov si, newln
call printf
nonepri:

mov ah, 0
int 0x16

push ax


mov ah, 0x0e
int 0x10


mov ah, 0x0e
cmp dl, 1
je donedl1

jmp donefun
donedl1:
cmp al, 0DH
je donefun
jne push


pop:
cmp dl, 1
je nonepri2
mov ah, 0x0e
mov si, newln
call printf
nonepri2:

pop ax

mov ah, 0x0e
int 0x10


cmp dl, 1
je donedl2

jmp donefun

donedl2:
cmp al, 00H
je donefun
jne pop


printnew:

cmp dl, 1
jne noneprinew
mov ah, 0x0e
mov si, newln
call printf
noneprinew:

ret


shutdown:
mov ax, 0x1000
mov ax, ss
mov sp, 0xf000
mov ax, 0x5307
mov bx, 0x0001
mov cx, 0x0003
int 0x15

end:
    jmp $
    
welcome: db "Welcome to Gunnars epic and based OS",0x0D,0xA,"Run commands using prompt below (L to list commands)",0x0D,0xA,0
list: db "S: shutdown",0x0D,0xA,"U: push",0x0D,0xA,"O: pop",0x0D,0xA,"C: clear",0
yes: db "yes",0
no: db "no",0
newln: db 0x0D,0xA,0


times 510-($-$$) db 0
dw 0xaa55