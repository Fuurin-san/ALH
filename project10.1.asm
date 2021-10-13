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
        mov bx,ax

        mov dh,cl

input:  
        mov cl,ds:[bx]
        mov ch,0
        jcxz ok

        mov dl,ds:[si]
        mov es:[bx],dx

        inc si
        add bx,2

        jmp short input


ok:     
        pop cx
        pop si
        pop dx
        ret

code ends
end start