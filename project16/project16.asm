assume cs:code

code segment
start:      
        mov ax,cs
        mov ds,ax

        mov ax,0
        mov es,ax

        mov si,offset new_int7ch
        mov di,200h
        mov cx,offset int7ch_end - offset new_int7ch  
        cld
        rep movsb

        cli
        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0
        sti

        mov ax,4c00h
        int 21h

new_int7ch:
        jmp short set_int7ch
        table   dw offset int7ch_0 - offset new_int7ch + 200h
                dw offset int7ch_1 - offset new_int7ch + 200h
                dw offset int7ch_2 - offset new_int7ch + 200h
                dw offset int7ch_3 - offset new_int7ch + 200h

set_int7ch:
        push bx
        cmp ah,3
        ja out_new_7ch
        mov bl,ah
        mov bh,0
        add bx,bx
        call word ptr cs:[bx+202h]
out_new_7ch:
        pop bx
        iret

int7ch_0:
        push bx
        push es
        push cx
        mov bx,0b800h                   ;尽量不用ax寄存器，al中保存了颜色值
        mov es,bx
        mov bx,0
        mov cx,2000
int7ch_0_s:
        mov byte ptr es:[bx],' '
        add bx,2
        loop int7ch_0_s
        pop cx
        pop es
        pop bx
        ret

int7ch_1:
        push bx
        push es
        push cx 

        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
int7ch_1_s:
        and byte ptr es:[bx],11111000b
        or es:[bx],al                   ;只设置前景色
        add bx,2
        loop int7ch_1_s
        pop cx
        pop es
        pop bx
        ret

int7ch_2:
        push bx
        push es
        push cx

        mov cl,4
        shl al,cl

        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
int7ch_2_s:
        and byte ptr es:[bx],10001111b
        or es:[bx],al                   ;只设置背景色
        add bx,2
        loop int7ch_2_s
        pop cx
        pop es
        pop bx
        ret

int7ch_3:
        push bx
        push es
        push ds
        push di
        push si
        push cx

        mov bx,0b800h
        mov es,bx
        mov ds,bx
        mov di,0
        mov si,160
        cld
        mov cx,24
int7ch_3_s:
        push cx
        mov cx,160
        rep movsb
        pop cx
        loop int7ch_3_s

        mov cx,80
        mov si,0
int7ch_3_s1:
        mov byte ptr es:[160*24+si],' '
        add si,2
        loop int7ch_3_s1

        pop cx
        pop si
        pop di
        pop ds
        pop es
        pop bx
        ret
int7ch_end:
        nop

code ends
end start