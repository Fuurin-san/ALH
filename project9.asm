assume cs:code,ds:data,ss:stack

data segment
        db 'welcome to masm!'
        db 00000010b    ;绿色
        db 00100100b    ;绿底白字
        db 01110001b    ;白底蓝字
data ends

stack segment
        db 16 dup (0)   ;设置栈
stack ends

code segment
start:  
        ;初始化
        mov ax,stack
        mov ss,ax
        mov sp,16

        mov ax,data
        mov ds,ax
        mov dx,0
        mov ax,0b800h   
        mov es,ax       ;es定位显示缓冲区行的段地址

        mov bp,32h      ;定位显示缓冲器中间列数，每轮加2
        mov si,32h      ;定位显示缓冲区中间列数，从第32h列开始，每轮++
        mov di,0        ;定位data段中字符串位置，每轮++

        mov cx,16
s:      
        ;写入显示缓冲区第12行
        mov al,ds:[di]
        mov ah,ds:[10h]
        mov es:06e0h[bp],ax

        ;写入显示缓冲区第13行
        mov ah,ds:[11h]
        mov es:780h[bp],ax

        ;写入显示缓冲区第14行
        mov ah,ds:[12h]
        mov es:820h[bp],ax

        inc di
        add bp,2
        loop s

        mov ax,4c00h
        int 21h
code ends
end start


