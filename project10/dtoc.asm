assume cs:code

data segment
        db 10 dup (0)
data ends

code segment
start:
        mov ax,12666
        mov bx,data
        mov ds,bx
        mov si,0
        call dtoc

        mov dh,8
        mov dl,3
        mov cl,2
        call show_str

        mov ax,4c00h
        int 21h

dtoc:
        mov bx,10       ;除数
        mov dx,0        ;除数储存在bx中，占据16位，被除数应为32位
        
        div bx
        inc di          ;记录字符个数
        mov cx,ax
        add dx,30h
        push dx         ;余数入栈，用于调整输出顺序
        jcxz outdtoc    ;判断，若商为0，则跳出
        
        jmp short dtoc

outdtoc:
s1:     
        
        mov cx,di       ;先将字符数量交给cx，用于判断循环次数
        dec di
        pop ds:[si]
        inc si
        loop s1
        mov byte ptr ds:[si],0   ;多输出一个0，用于之后的show_str程序跳出循环

        ret

show_str:
        mov si,0
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
        jcxz ok

        mov dl,ds:[si]  ;将字符的ASCII码写入dx的低位
        mov es:[bx],dx  ;将dx中代表字符的低位与代表颜色的高位一并写入目标显存缓冲区

        inc si          ;si每轮+1，指向data段下一个字符
        add bx,2        ;bx每次+2，指向显示缓冲区下一个写入数据的位置

        jmp short input 


ok:     
        ret             ;返回





code ends
end start