assume cs:codesg

data segment
        db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
        db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
        db '1993','1994','1995'
        ;以上是表示21年的21个字符串 （db型为1字节）

        dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
        dd 34589,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
        ;以上表示21年公司总收入的21个dword型数据 （dd型为4字节）

        dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
        dw 11542,14430,15257,17800
        ;以上是表示21年公司雇员人数的21个word型数据（dw型为2字节） 
data ends

table segment
        db 21 dup ('year summ ne ?? ')
table ends

stack segment
        db 32 dup (0)
stack ends

data1 segment
        db 10 dup (0)
data1 ends

codesg segment
start:
        ;初始化
        mov ax,stack
        mov ss,ax
        mov sp,32

        mov ax,table
        mov es,ax

        mov ax,data
        mov ds,ax
        mov dx,0

        call data_info
        call cls

        mov ax,data1
        mov ds,ax
        mov si,0

        mov cx,21
        mov dh,1

show:
        push cx

        ;显示年份，从第一行开始
        mov ax,es:[bx]
        mov ds:[si],ax
        mov ax,es:[bx+2]
        mov ds:[si+2],ax
        mov byte ptr ds:[si+4],0        ;末尾写入一个0，用于show_str结束

        mov dl,3
        mov cl,2
        mov ch,0

        call show_str

        ;显示总收入，从第一行开始
        push dx

        mov ax,es:[bx+5]
        mov dx,es:[bx+7]

        call dtoc

        pop dx

        mov dl,14
        mov cl,2
        mov ch,0
        call show_str


        ;写入雇员数
        push dx

        mov ax,es:[bx+10]
        mov dx,0

        call dtoc

        pop dx

        mov dl,28
        mov cl,2
        mov ch,0

        call show_str

        ;写入人均收入
        push dx

        mov ax,es:[bx+13]
        mov dx,0

        call dtoc

        pop dx

        mov dl,40
        mov cl,2
        mov ch,0
        call show_str

        add dh,1
        add bx,10h
        pop cx
        loop show

        mov ax,4c00h
        int 21h

data_info:

        push bx
        push ax
        push dx
        push ds
        push di
        push si
        push cx
        push bp
        
        mov bx,0        ;定位table中的行位置
        mov bp,0        ;定位data段雇员人数，0为第一年，每一年加2
        mov di,0        ;定位年份和收入的位置，0表示第一年

        mov cx,21

        ;最外层循环21次
s:      
        push cx
        mov si,0        ;定位data段年份与收入地址,每次都需要重置为0
        mov cx,4        ;按字节写入，共4字节
        ;修改table段中的年份
s1:     
        mov ax,0
        mov al,ds:0[di]
        mov ah,ds:84[di]
        mov es:[bx][si],al      ;写入年份
        mov es:[bx][si+5],ah    ;写入收入
        inc si
        inc di
        loop s1

        ;写入雇员数
        mov ax,0
        mov ax,ds:[bp].168
        mov es:10[bx],ax
        add bp,2

        ;写入人均收入
        mov ax,es:5[bx]
        mov dx,es:7[bx]
        div word ptr es:10[bx]
        mov es:[bx].13,ax

        add bx,0010h
        pop cx
        loop s

        pop bp
        pop cx
        pop si
        pop di
        pop ds
        pop dx
        pop ax
        pop bx

        ret

cls:
        push es
        push ax
        push di
        push cx

        mov ax,0b800h
        mov es,ax
        mov di,0

        mov cx,2000d
s_cls:
        mov byte ptr es:[di],' '
        mov byte ptr es:1[di],0
        add di,2
        loop s_cls

        pop cx
        pop di
        pop ax
        pop es

        ret

show_str:
        push ax
        push es
        push bx
        push dx
        push cx
        push si

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

        pop si
        pop cx
        pop dx
        pop bx
        pop es
        pop ax

        ret             ;返回

dtoc:
        push cx
        push dx
        push di
        push ax
        push si
        push bx
        mov di,0

dtoc_o:        
        mov cx,10       ;除数
        mov bx,0        
        mov bp,0

        call divdw

        push dx
        push ax

        add ax,dx
        mov cx,ax

        pop ax
        pop dx

        inc di          ;记录字符个数

        add bp,30h
        push bp         ;余数入栈，用于调整输出顺序
        jcxz outdtoc    ;判断，若商为0，则跳出
        
        jmp short dtoc_o

outdtoc:
dtoc_s:     
        
        mov cx,di       ;先将字符数量交给cx，用于判断循环次数
        dec di
        pop ds:[si]
        inc si
        loop dtoc_s
        mov byte ptr ds:[si],0   ;多输出一个0，用于之后的show_str程序跳出循环

        pop bx
        pop si
        pop ax
        pop di
        pop dx
        pop cx

        ret

divdw:

        push ax     ;先计算高位，利用栈暂存低位的值

        mov ax,dx
        mov dx,0    ;除数为16位，被除数必须为32位，将dx值写入ax，且将dx置为0

        div cx
        mov bx,ax   ;用bx来暂存ax（商）的值

        pop ax      ;上一次除法的商保存在dx中，将被除数的低16位弹出至ax，组成32位，
                    ;相当于将dx中值=余数*65536,弹出的被除数低16位的值相当于加上了dx
        div cx      ;第二次除法

        mov bp,dx   ;cx中写入余数
        mov dx,bx   ;高位写入,低位数据已经在ax中，无须再次写入
        

        ret

        



codesg ends
end start