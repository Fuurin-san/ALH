assume cs:code

data segment
    db "welcome to masm!",0
data ends

code segment
start:
        mov ax,cs
        mov ds,ax
        mov si,offset wordout
        mov ax,0
        mov es,ax
        mov di,200h

        mov cx,offset wordout_end - offset wordout

        cld
        rep movsb

        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0

        mov dh,10
        mov dl,10
        mov cl,2
        mov ax,data
        mov ds,ax
        mov si,0
        int 7ch
        mov ax,4c00h
        int 21h

wordout:

        mov ax,0b800h
        mov es,ax
        mov al,dh
        mov ah,160
        mul ah
        mov dh,0
        add ax,dx
        add ax,dx
        mov di,ax
        mov ah,00000010b
s:      cmp byte ptr ds:[si],0
        je ok
        mov al,ds:[si]
        mov es:[di],ax
        inc si
        add di,2
        jmp short s
ok:
        iret
wordout_end:
        nop

code ends
end start