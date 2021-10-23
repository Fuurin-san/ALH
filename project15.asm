assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
start:
        mov ax,stack
        mov ss,ax
        mov sp,128
        mov ax,cs
        mov ds,ax

        mov ax,0
        mov es,ax

        mov si,offset int9
        mov di,204h
        mov cx,offset int9_end_char - offset int9
        cld
        rep movsb

        push es:[9*4]
        pop es:[200h]
        push es:[9*4+2]
        pop es:[202h]

        cli
        mov word ptr es:[9*4],204h
        mov word ptr es:[9*4+2],0
        sti

        mov ax,4c00h
        int 21h



int9:
        push ax
        push cx
        push bx
        push es

        in al,60h
        pushf
        call dword ptr cs:[200h]        ;模拟原int9中断
        cmp al,9eh
        jne int_end                     ;检测到A的断码就开始写入A

        mov ax,0b800h
        mov es,ax
        mov bx,0
        mov cx,2000
circulate_s:
        mov byte ptr es:[bx],41h
        mov byte ptr es:[bx+1],00000110b
        add bx,2
        loop circulate_s

int_end:      
        pop es
        pop bx
        pop cx
        pop ax

        iret
int9_end_char:
        nop
        
code ends
end start