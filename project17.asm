assume cs:code

code segment
start:
        ;安装程序
        mov ax,cs
        mov ds,ax
        mov si,offset int7ch_s

        sub ax,ax
        mov es,ax
        mov di,200h

        mov cx,offset int7ch_end - offset int7ch_s
        cld
        rep movsb

        cli
        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0h
        sti

        mov ax,4c00h
        int 21h

int7ch_s:
        push dx
        push cx
        push bx
        push ax

        push ax                     ;保存输入的参数al、ah

        cmp ah,1
        ja out_int7ch

        ;计算面号
        mov ax,dx
        mov dx,0
        mov cx,1440                 ;除数
        div cx
        push ax                      ;面号入栈
        ;计算磁道号
        mov cx,18
        mov ax,dx
        mov dx,0
        div cx
        push ax
        ;计算扇区号
        inc dx
        push dx

        pop ax
        mov cl,al                   ;扇区号
        pop ax
        mov ch,al                   ;磁道号
        pop ax
        mov dh,al                   ;磁头号
        mov dl,0                    ;驱动器号

        pop ax
        mov al,1                    ;写入的扇区
        cmp ah,0
        je read

    write:                          ;功能号
        mov ah,3                
        jmp short ok
    read:
        mov ah,2
        jmp short ok
          
    ok: 
        int 13h
out_int7ch:
        pop ax
        pop bx
        pop cx
        pop dx

        iret
int7ch_end:
        nop
