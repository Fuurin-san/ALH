assume cs:code
code segment
start:
        mov bx,0b800h
        mov es,bx
        mov bl,0ah
        mov bh,0
        ;mov bp,ax                  ;定位年月日时分秒
        mov si,40                   ;第20列开始

        mov al,2fh
        mov ah,000001110b
        mov es:[si+160*12+4],ax
        mov es:[si+160*12+10],ax
        mov al,0h
        mov es:[si+160*12+16],ax
        mov al,3ah
        mov es:[si+160*12+22],ax
        mov es:[si+160*12+28],ax

        mov ax,0
        mov cx,6
s:    
        push cx
        mov al,bl
        out 70h,al
        in al,71h

        mov ah,al
        mov cl,4
        shr ah,cl
        and al,00001111b

        add ah,30h
        add al,30h

        mov byte ptr es:[160*12+si],ah
        mov byte ptr es:[160*12+si+2],al

        add si,6
        sub bx,2
        pop cx


        loop s

        mov ax,4c00h
        int 21h
code ends
end start