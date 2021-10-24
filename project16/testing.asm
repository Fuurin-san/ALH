assume cs:code

code segment
start:
        mov ah,1
        mov al,2
        int 7ch
        call tick

        mov ah,2
        mov al,1
        int 7ch
        call tick

        mov ah,3
        int 7ch
        call tick

        mov ah,0
        int 7ch
        call tick

        mov ax,4c00h
        int 21h

tick:   
        push cx


        mov cx,1000h
s1:
        push cx
        mov cx,1000h
s2:     
        loop s2
        pop cx
        loop s1
        pop cx
        ret

code ends
end start