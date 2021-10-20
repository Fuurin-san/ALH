assume cs:code

code segment
start:  ;0号中断（除法溢出）
        ;安装程序
        mov ax,cs
        mov ds,ax
        mov si,offset do0

        mov ax,0
        mov es,ax
        mov di,200h
        mov cx,offset do0end-offset do0
        cld
        rep movsb

        mov ax,4c00h
        int 21h

do0:
        jmp short do0start
        db "devide error!"
do0start:
        mov ax,cs
        mov ds,ax
        mov si,202h

        mov ax,0b800h
        mov es,ax
        mov di,160*12+2*36
        mov cx,13
s:      
        mov al,ds:[si]
        mov es:[di],al
        inc si
        add di,2
        loop s

        mov ax,4c00h
        int 21h
do0end:nop                  ;用来计算中断程序的字节数
code ends
end start