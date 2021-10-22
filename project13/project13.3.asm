assume cs:code

code segment
start:
        mov ax,cs
        mov ds,ax
        mov si,offset circlulates
        mov ax,0
        mov es,ax
        mov di,200h

        mov cx,offset circlulates_out - offset circlulates

        cld
        rep movsb

        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0
        
        mov ax,0b800h
        mov es,ax
        mov di,160*12+8*2
        mov bx,offset s - offset se
        mov cx,80
s:      mov byte ptr es:[di],'!'
        add di,2
        int 7ch
se:     nop
        mov ax,4c00h
        int 21h


circlulates:
        push bp
        mov bp,sp
        dec cx
        jcxz ok
        add ss:[bp+2],bx
ok:
        pop bp
        iret
circlulates_out:
        nop

code ends
end start