assume cs:code
data segment
    db 'conversation',0
data ends

code segment
start:

        mov ax,cs
        mov ds,ax
        mov si,offset d7c
        mov ax,0
        mov es,ax
        mov di,200h

        mov cx,offset d7c_end-offset d7c

        cld
        rep movsb

        mov ax,0
        mov es,ax
        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0



        mov ax,data
        mov ds,ax
        mov si,0
        mov ax,0b800h
        mov es,ax
        mov di,160*12+2*20

s:      cmp byte ptr ds:[si],0
        je ok
        mov al,ds:[si]
        mov es:[di],al
        inc si
        add di,2
        mov bx,offset s-offset ok
        int 7ch
ok:     mov ax,4c00h
        int 21h

d7c:
        push bp
        mov bp,sp
        add ss:[bp+2],bx
        pop bp
        iret
d7c_end:
        nop

code ends
end start