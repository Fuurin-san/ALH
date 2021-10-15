assume cs:code

data segment
        db 'Welcome to masm!',0
data ends

code segment
start:  mov dh,8
        mov dl,3
        mov cl,2
        mov ax,data
        mov ds,ax
        mov si,0

        call show_str

        mov ax,4c00h
        int 21h

show_str:
        push dx
        push si
        push cx

        mov ax,0b800h
        mov es,ax       ;定位显示缓冲区的段地址

        mov al,2
        mul dl
        mov bx,ax       ;定位显示缓冲区的列地址

        mov al,00a0h
        mul dh
        add ax,bx
        mov bx,ax       ;定位显示缓冲区的行地址

        mov dh,cl       ;降代表颜色的值写入dx寄存器的高位

input:  
        mov cl,ds:[si]
        mov ch,0        ;将data段数据读入cx，用于jcxz判断是否结束循环
        jcxz Outinput

        mov dl,ds:[si]  ;将字符的ASCII码写入dx的低位
        mov es:[bx],dx  ;将dx中代表字符的低位与代表颜色的高位一并写入目标显存缓冲区

        inc si          ;si每轮+1，指向data段下一个字符
        add bx,2        ;bx每次+2，指向显示缓冲区下一个写入数据的位置

        jmp short input 


Outinput:     
        pop cx
        pop si
        pop dx
        ret             ;返回

code ends
end start