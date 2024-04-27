[org 0x0100]

jmp start

time: db '120', '$'
second: db 's', 0
liveScr: db ' Score: ', 0
score: db '0','$'
name: db ' C o i n  R u s h ', 0

obj1SX: dw 14
obj2SX: dw 28
obj3SX: dw 48
bombSX: dw 62
obj1SY: dw 1
obj2SY: dw 13
obj3SY: dw 7
bombSY: dw 18

obj1EX: dw 16
obj2EX: dw 30
obj3EX: dw 50
bombEX: dw 64
obj1EY: dw 3
obj2EY: dw 15
obj3EY: dw 9
bombEY: dw 20

bucketTop: db '|   |', 0
bucketBase: db '\___/', 0
bucketX: dw 31		;starting col of bucket
bucketX1: dw 35		;ending col of bucket

time_aux: dw 1
game_time: dw 0

randX: dw 0

reobj1:
	mov word[obj1SY], 0
	mov word[obj1EY], 2
	call randNo
	mov ax, word[randX]
	mov word[obj1SX], ax
	add ax, 2
	mov word[obj1EX], ax
	jmp l1
reobj2:
	mov word[obj2SY], 0
	mov word[obj2EY], 2
	call randNo
	mov ax, word[randX]
	mov word[obj2SX], ax
	add ax, 2
	mov word[obj2EX], ax
	jmp l1
reobj3:
	mov word[obj3SY], 0
	mov word[obj3EY], 2
	call randNo
	mov ax, word[randX]
	mov word[obj3SX], ax
	add ax, 2
	mov word[obj3EX], ax
	jmp l1
rebomb:
	mov word[bombSY], 0
	mov word[bombEY], 2
	call randNo
	mov ax, word[randX]
	mov word[bombSX], ax
	add ax, 2
	mov word[bombEX], ax
	jmp l1

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
	mov di, 0
topline:
	mov word [es:di], 0x0F20
	add di, 2
 	cmp di, 160
 	jne topline
	mov di, 3840
baseline:
	mov word [es:di], 0x6254
	add di, 2
 	cmp di, 4000
 	jne baseline
 	pop di
 	pop ax
 	pop es
 	ret

drawobject:
	push bp
	mov bp, sp
	mov ah, 06h		;function to scroll lines up
	mov al, byte[bp+4]	;amount to scroll
	mov bh, byte[bp+14]	;attribute
	mov ch, byte[bp+12]	;starting row
	mov cl, byte[bp+10]	;starting col
	mov dh, byte[bp+8]	;ending row
	mov dl, byte[bp+6]	;ending col
	int 10h			;execute the code
	pop bp
	ret 12

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

drawBucket:
		;Bucket

	mov ax, [bucketX]
 	push ax
 	mov ax, 23
 	push ax
 	mov ax, 0x30
 	push ax
 	mov ax, bucketBase
 	push ax
 	call printstr
	mov ax, [bucketX]
 	push ax
 	mov ax, 22
 	push ax
 	mov ax, 0x30
 	push ax
 	mov ax, bucketTop
 	push ax
 	call printstr
	ret

loadscr:
	call colorscr
	
		;Name

	mov ax, 30
 	push ax
 	mov ax, 0
 	push ax
 	mov ax, 0x70
 	push ax
 	mov ax, name
 	push ax
 	call printstr

	
		;Time
	mov ah, 02h	;set cursor position
	mov bh, 0	;set page num
	mov dh, 0	;set row
	mov dl, 74	;set col
	int 10h
	mov ah,09h
	lea dx, [time]
	int 21h		;print string from address stored in dx
	mov ax, 78
 	push ax
 	mov ax, 0
 	push ax
 	mov ax, 0x07
 	push ax
 	mov ax, second
 	push ax
 	call printstr

		;Score

	mov ah, 02h	;set cursor position
	mov bh, 0	;set page num
	mov dh, 0	;set row
	mov dl, 08h	;set col
	int 10h
	mov ah,09h
	lea dx, [score]
	int 21h		;print string from address stored in dx
	mov ax, 0
 	push ax
 	mov ax, 0
 	push ax
 	mov ax, 0x07
 	push ax
 	mov ax, liveScr
 	push ax
 	call printstr

	call drawBucket
	
		;Object 1

	mov ax, 20h		;color
	push ax
	mov ax, [obj1SY]	;start row
	push ax
	mov ax, [obj1SX]	;start col
	push ax
	mov ax, [obj1EY]	;end row
	push ax
	mov ax, [obj1EX]	;end col
	push ax
	mov ax, 3		;no of lines to scroll
	push ax
	call drawobject

		;Object 2

	mov ax, 40h
	push ax
	mov ax, [obj2SY]
	push ax
	mov ax, [obj2SX]
	push ax
	mov ax, [obj2EY]
	push ax
	mov ax, [obj2EX]
	push ax
	mov ax, 3
	push ax
	call drawobject
	
		;Object 3

	mov ax, 60h
	push ax
	mov ax, [obj3SY]
	push ax
	mov ax, [obj3SX]
	push ax
	mov ax, [obj3EY]
	push ax
	mov ax, [obj3EX]
	push ax
	mov ax, 3
	push ax
	call drawobject

		;Bomb

	mov ax, 00h
	push ax
	mov ax, [bombSY]
	push ax
	mov ax, [bombSX]
	push ax
	mov ax, [bombEY]
	push ax
	mov ax, [bombEX]
	push ax
	mov ax, 3
	push ax
	call drawobject

	ret

movebucket:
	in al,0x60
	mov bx, [bucketX1]
	mov dx, [bucketX]
	cmp al, 0x41
	jz scroll_left
	cmp al, 0x61
	jz scroll_left
	cmp al, 0x44
	jz scroll_right
	cmp al, 0x64
	jz scroll_right
	cmp al, 0x1b
	jz end
	jmp movebucket
	scroll_right:
		cmp bx, 79
		je movebucket
		inc dx
		inc bx
		mov [bucketX], dx
		mov [bucketX1], bx
		call drawBucket
		mov cx, dx
		dec cx
		mov ax, 30h
		push ax
		mov ax, 22
		push ax
		mov ax, cx
		push ax
		mov ax, 23
		push ax
		mov ax, cx
		push ax
		mov ax, 2
		push ax
		call drawobject
		
		jmp movebucket
	scroll_left:
		cmp dx, 0
		je movebucket
		dec dx
		dec bx
		mov [bucketX], dx
		mov [bucketX1], bx
		call drawBucket
		mov cx, bx
		inc cx
		mov ax, 30h
		push ax
		mov ax, 22
		push ax
		mov ax, cx
		push ax
		mov ax, 23
		push ax
		mov ax, cx
		push ax
		mov ax, 2
		push ax
		call drawobject
		jmp movebucket
	end:
	ret

timer:
	mov ah, 2ch		;get system time
	int 21h
	
	cmp dh, byte[time_aux]	;dh contains seconds
	je timer
	
	mov byte[time_aux], dh
	add word[obj1SY], 1
	add word[obj1EY], 1
	add word[obj2SY], 1
	add word[obj2EY], 1
	add word[obj3SY], 1
	add word[obj3EY], 1
	add word[bombSY], 1
	add word[bombEY], 1
	call loadscr

	cmp word[obj1EY], 23
	je reobj1		;create object from top again
	cmp word[obj2EY], 23
	je reobj2
	cmp word[obj3EY], 23
	je reobj3
	cmp word[bombEY], 23
	je rebomb
	l1:
	add byte[game_time], 1
	cmp byte[game_time], 121
	jne timer
	ret
randNo:
	call delay
	mov ah, 0
	int 1ah
	
	mov ax, dx
	mov dx, 0
	mov bx, 78
	div bx
	
	mov byte[randX], dl
	ret
delay:
	mov cx, 1
	startDelay:
		cmp cx,50000
		inc cx
		je endDelay
		inc cx
		jmp startDelay
	endDelay:
	ret
start:
	call clrscr
	call loadscr
	call timer
	;call movebucket
;int 9h in any oldisr
game_end:
	mov ah, 0x1		;To hide command line
	int 21h
	mov ax, 0x4c00		;Terminate code
	int 21h