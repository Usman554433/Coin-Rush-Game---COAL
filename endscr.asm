[org 0x0100] 
jmp start
dash: db '-------------------------', 0
plus: db '+                       +', 0
m0: db 'Enter to Play again', 0
m3: db 'Press Esc to Exit', 0
m1: db 'Your Score Is :', 0
m2: db '5 0', 0
clrscr:
	push es
	push ax
	push di
	mov ax, 0xb800 
 	mov es, ax
 	mov di, 0
nextloc: 
	mov word [es:di], 0x0720 
	add di, 2
 	cmp di, 4000
 	jne nextloc
 	pop di 
 	pop ax 
 	pop es 
 	ret
colorscr:
	push es
	push ax 
	push di
	mov ax, 0xb800 
 	mov es, ax
 	mov di, 0
nextarea: 
	mov word [es:di], 0x3820
	add di, 2
 	cmp di, 4000
 	jne nextarea
 	pop di
 	pop ax
 	pop es
 	ret
printstr: 
	push bp 
 	mov bp, sp 
 	push es 
 	push ax 
 	push cx 
 	push si 
 	push di 
 	push ds 
 	pop es
 	mov di, [bp+4]
 	mov cx, 0xffff 
 	xor al, al
 	repne scasb 
 	mov ax, 0xffff
 	sub ax, cx 
 	dec ax  
 	jz exit 
 	mov cx, ax  
 	mov ax, 0xb800 
 	mov es, ax 
 	mov al, 80 
 	mul byte [bp+8] 
 	add ax, [bp+10] 
 	shl ax, 1 
 	mov di, ax 
 	mov si, [bp+4] 
 	mov ah, [bp+6] 
 	cld 
nextchar: 
	lodsb 
 	stosw  
 	loop nextchar
exit:
	pop di 
 	pop si 
 	pop cx 
 	pop ax 
 	pop es
 	pop bp
 	ret 8
	

start: 
	call clrscr
	call colorscr
 	mov ax, 28
 	push ax
 	mov ax, 9
 	push ax
 	mov ax, 0x36
 	push ax
 	mov ax, m1
 	push ax
 	call printstr
	
	mov ax, 45
 	push ax
 	mov ax, 9
 	push ax
 	mov ax, 0xB6
 	push ax
 	mov ax, m2
 	push ax
	call printstr

	mov ax, 26
 	push ax
 	mov ax, 11
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, dash
 	push ax
	call printstr

	mov ax, 26
 	push ax
 	mov ax, 13
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, dash
 	push ax
	call printstr

	mov ax, 26
 	push ax
 	mov ax, 12
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, plus
 	push ax
	call printstr

	mov ax, 29
 	push ax
 	mov ax, 12
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, m0
 	push ax
	call printstr

	mov ax, 26
 	push ax
 	mov ax, 14
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, dash
 	push ax
	call printstr
	
	mov ax, 26
 	push ax
 	mov ax, 15
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, plus
 	push ax
	call printstr

	mov ax, 26
 	push ax
 	mov ax, 16
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, dash
 	push ax
	call printstr

	mov ax, 29
 	push ax
 	mov ax, 15
 	push ax
 	mov ax, 0x36
 	push ax
	mov ax, m3
 	push ax
	call printstr
mov ah,0x1
int 21h

mov ax, 0x4c00
int 0x21