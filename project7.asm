assume cs:codesg,ss:stack,ds:data,es:table

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
        dw 8 dup (0)
stack ends

codesg segment
start:
        ;初始化
        mov ax,stack
        mov ss,ax
        mov sp,16

        mov ax,table
        mov es,ax

        mov ax,data
        mov ds,ax
        mov dx,0

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
        mov es:[bx].5[si],ah    ;写入收入
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

        mov ax,4c00h
        int 21h
codesg ends
end start       ;注意寻址表达式的书写