assume cs:code

code segment
start:
        mov ax,4240h
        mov dx,000fh
        mov cx,0ah
        call divdw

divdw:
        push ax     ;先计算高位，利用栈暂存低位的值

        mov ax,dx
        mov dx,0    ;除数为16位，被除数必须为32位，将dx值写入ax，且将dx置为0

        div cx
        mov bx,ax   ;用bx来暂存ax（商）的值

        pop ax      ;上一次除法的商保存在dx中，将被除数的低16位弹出至ax，组成32位，
                    ;相当于将dx中值=余数*65536,弹出的被除数低16位的值相当于加上了dx
        div cx      ;第二次除法

        mov dx,bx   ;高位写入,低位数据已经在ax中，无须再次写入
        mov cx,ax   ;cx中写入余数
        

        ret

code ends
end start