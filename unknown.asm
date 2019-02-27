;#make_COM#
CSEG segment
assume ss:CSEG, es:CSEG, ds:CSEG, cs: CSEG
ORG  100H  


START:  
	mov dx, offset mesLoad ;��������� ����
	mov ah, 09h	
	int 21h



	mov ah, 01h		;��� ������� �������
	int 21h

	cmp al, 32h		;���� ������ ���� � ���������� 
	je LoadKeyBoard		;��������� �� ����� LoadKeyBoard
;====================================================

	mov dx, offset endl	;������� ������
	mov ah, 09h	
	int 21h

	mov dx, offset mesNameFile;������ �� ���� ����� �����
	mov ah, 09h	
	int 21h

	mov dx, offset path;	;���� ��������� ��� �����
	mov ah, 0ah	
	int 21h

	mov bx, 0		;������ ���� ����� ������
	mov bl, [path+1]
	mov path[bx+2], '0'

	mov ax,3d00h   	 ; ��������� ��� ������
	lea dx,path + 2   	 ; DS:dx ��������� �� ��� �����
	int 21h     		 ; � ax ��c������� �����
	jnc FileOK        	; ���� �� ������ ���� �, �� ������ �������� ��� 

	mov dx, offset mesError 
	mov ah, 09h	;����� �������� �� ������
	int 21h		
       	MOV AH, 4Ch	;� �������
	INT 21h

	int 20h
	
FileOK:
	mov bx,ax      	 ; �������� � bx ��������� �����
	mov Handle,ax       	 ; �������� � Handle ��������� �����

    	xor cx,cx 		;��������� �� ������ �����
   	xor dx,dx  	;��������� �� ������ �����
   	mov ax,4200h
	int 21h     		; ���� � ������ �����

	mov bx, Handle	 ; �������� � bx ��������� �����

	call LoadFile  	;��������� �� ����� ������ �����
	mov n, ax		;� n
	call LoadFile	;��������� �� ����� ������ �����
	mov d, ax		;� d
	call LoadFile	;��������� �� ����� ������ �����
	mov m, ax		;� m
	call LoadFile	;��������� �� ����� �������� �����
	mov y, ax		;� y


	mov bx, Handle 	; �������� � bx ��������� �����
       	;close:          	; ��������� ����, ����� ������
      	mov ah,3eh
      	int 21h
;===================================================
	jmp formula
LoadKeyBoard:
	mov dx, offset endl
	mov ah, 09h	
	int 21h

        
;������ n===============
	LEA DX, nCout
        MOV AH, 9h
        INT 21h
;������ ������
	LEA DX, msg
        MOV AH, 0ah
        INT 21h
        
;������ ���� ����� ������
	mov bx, 0
	mov bl, [msg+1]
	mov msg[bx+2], '$'
	
	call IntegerIn
	mov n,ax	
	
	
	;��������� ������
	LEA DX, endl
        MOV AH, 9h
        INT 21h
	
;������ d===============
	LEA DX, dCout
        MOV AH, 9h
        INT 21h
;������ ������
	LEA DX, msg
        MOV AH, 0ah
        INT 21h
        
;������ ���� ����� ������
	mov bx, 0
	mov bl, [msg+1]
	mov msg[bx+2], '$'
	
	call IntegerIn
	mov d,ax	
	
	
	;��������� ������
	LEA DX, endl
        MOV AH, 9h
        INT 21h
  ;������ m==================
	LEA DX, mCout
        MOV AH, 9h
        INT 21h
;������ ������
	LEA DX, msg
        MOV AH, 0ah
        INT 21h
        
;������ ���� ����� ������
	mov bx, 0
	mov bl, [msg+1]
	mov msg[bx+2], '$'
	
	call IntegerIn
	mov m,ax	


;��������� ������
	LEA DX, endl
        MOV AH, 9h
        INT 21h

;������ y===============
	LEA DX, yCout
        MOV AH, 9h
        INT 21h
;������ ������
	LEA DX, msg
        MOV AH, 0ah
        INT 21h
        
;������ ���� ����� ������
	mov bx, 0
	mov bl, [msg+1]
	mov msg[bx+2], '$'
	
	call IntegerIn
	mov y,ax	
;========================================

 formula:
	cmp d, 15  	;
	jg Dgreate		;���� d>15, ����� �� Dgreate	

	mov ax, m		;m � ax
	imul n		;m*n
	mov a, ax		;��������� � a
	
	mov ax, y		;y � ax
	idiv n 		;y/n
	mov b, ax		;��������� � b
	mov ax, a		;m*n � ax
	sub ax, [b]	;m*n-y/b
	mov [z], ax	;Z
	jmp finish		;������� �� ����� finish
Dgreate:		
	mov ax, y		;y � ax
	sub ax, m		;(y-m)
	mov a, ax		;��������� � a
	
	mov ax, y		;y � ax
	sub ax, d		;(y-d)
	mov b, ax		;��������� � b	
	
	mov ax, a		;(y-m) � ax
	imul [b]		;(y-m)*(y-d)
	mov [z], ax	;Z

finish:

	mov dx, offset endl	;������� ������
	mov ah, 09h	
	int 21h

	mov dx, offset result	;Z = 
	mov ah, 09h	
	int 21h

	mov ax, [z]
	call IntegerOut	;������� ���������

       	 MOV AH, 4Ch	;�����
	 INT 21h

	int 20h



IntegerIn proc
	mov x,0
	mov ax,10		;�������� �� 10 ������ ����
	mov ch, 0		;�������� �������
	mov dh, 0		;� dl ����� �������� ����� � [bx]
	mov cl, [msg+1]	;����� ������
	lea bx, msg+2	;������ ������
	
	mov dl, [bx]	;������� � [dl]
	cmp dl, '-'		;���� -
	je GetInteger	;����� �����
loopGetUnsigned: 
	mul x		;�������� �� 10
	mov x, ax		;���������� ���������
	mov dl, [bx]	;������ � dl
	sub dl, '0'		;�������� �����
	add x, dx		;���������� � ����������
	inc bx		;��������� � ���������� �����
	mov ax,10		;��������������� ���������
loop loopGetUnsigned
	mov ax, x		;��������� � ax
	ret
GetInteger:


	mov ax,10		;�������� �� 10 ������ ����
	mov ch, 0		;�������� �������
	mov dh, 0		;� dl ����� �������� ����� � [bx]
	dec cl		;���������� '-'
	inc bx		;��������� � ���������� �����
loopGetInteger: 
	mul x		;�������� �� 10
	mov x, ax		;���������� ���������
	mov dl, [bx]	;������ � dl
	sub dl, '0'		;�������� �����
	add x, dx		;���������� � ����������
	inc bx		;��������� � ���������� �����
	mov ax,10		;��������������� ���������
loop loopGetInteger
	mov ax, x		;��������� � ax
	neg ax		;������ ����
	ret	
IntegerIn endp


IntegerOut proc
	xor cx,cx 		;�������� ������� ����
	mov bx,10	 ;� bx �������� ��������
	cmp ax,0 		;��������� ���� �����
	jge mIntegerOut 	;���� ��������������� � �� m
	neg ax 		;����� � ������ ���� �����
	push ax 		;��������� ����� ����� �������
			;�������, ������������ ax
	mov ah,2 		;�������� 02 ������� ���� '-'
	mov dl,'-'
	int 21h
	pop ax 		;��������������� ����� � ax
mIntegerOut: 
	inc cx 		;������� ����������
			;������������ ����
	xor dx,dx 		;����������� ������� � 32
			;��������
	div bx 		;�������� ��������� �����
	push dx 		;��������� �� � �����
	or ax,ax		 ;��������� ���� �� ��� �����
	jnz mIntegerOut 	;���� �� � �� ����� m
			;��� ������ �� ����� � ����� ����� �����, � cx � ��
			;����������
m1IntegerOut: pop dx	 ;��������� ����� �� �����
	add dx,'0' 		;����������� � ��� �������
	mov ah,2 		;�������� 02 ������� �� �����
	int 21h
	loop m1IntegerOut 	;��������� cx ���
	ret 		;������������ �� ���������
IntegerOut endp




LoadFile proc
	mov [x], 0		;�������������� ���������� ��� ����������� �������������� ����������
 	mov [zn], 0	;���� �����

	out_str:
	mov ah,3fh      	; ����� ������ �� �����
	mov cx,1        ; 1 ����
	    lea dx,buf      ; � ������ buf
	    int 21h         
	    cmp ax,cx       ; ���� ���������� EoF ��� ������ ������
	    jnz close       ; �� ��������� ���� ��������� ����
  
	    cmp [buf], 10      ;������� �������
	    je close       
	    cmp [buf], 13   	 ;������� �������
	    je trash     
	    cmp [buf], '-'        ;��������� ����
	    je znak  
	mov ax,	10             ;����� ��������� �� 10
	mov bx, 	[x]	;��������������� ������ ����
	mul bx		
	mov bx,	ax	;��������� � bx
	add bl, 	[buf]	;���������� ��������� �����
	sub bl,	 '0'	;�������� ��� '0'
	mov [x],	bx 	;��������� ������������� ��������

 trash:
	    mov bx, Handle      ; �������� � bx ��������� �����
	    jmp out_str
close: 
	cmp [zn], 1	;���� ����� �������������
	je chan	;������ ����
	mov ax, [x]	;��������� � ax
	ret
chan:
	mov ax, [x]	;��������� � ax
	neg ax		;������ ����
	ret
znak :
	mov zn, 1 		;��������, ��� ����� �������������
	jmp trash		;������������
LoadFile endp






;Data
mesNameFile db 'name of file: $'
Handle dw 0
mesLoad db '1-load from file',10,13, '2-load from keyboard',10,13,'$'
mesError db 10,13,'file not found$'
msg DB 255,?,255 dup(?)
endl DB 10,13,'$'
mCout DB 'm = $'
nCout DB 'n = $'
dCout DB 'd = $'
yCout DB 'y = $'
result DB 'Z = $'

a dw 0
b dw 0
x dw 0
m dw 0
n dw 0
y dw 0
d dw 0
z dw 0
zn db 0

;path db 'a.txt',0 ; ��� ����� ��� ��������
buf  db ?
path db 255,?,255 dup(0)



CSEG ends
end START