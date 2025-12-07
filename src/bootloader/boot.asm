org 0x7C00
bits 16

; define MACRO
%define ENDL 0x0d, 0x0a


start:
	jmp main

puts:
;prints a string to the screen
;Params
;ds:si points to string

	push si
	push ax
.loop:
	lodsb ; puts mext cjar and stack++
	or al, al ; verify if next char is null
	jz .done

	mov ah, 0x0e
	mov bh, 0x00
	int 0x10

	jmp .loop
	
	

.done:
	pop bx
	pop ax
	pop si
	ret

main:
	;setting up data segments
	mov ax, 0 
	mov ds,ax
	mov es, ax
	
	;setting up stack
	mov ss, ax
	mov sp, 0x7C00
	
	mov si, msg_hello_world
	call puts


	hlt

.halt 
	jmp .halt

msg_hello_world:  db "Hello! World from the POOKY_OS!!", ENDL, 0

times 510-($-$$) db 0
dw 0AA55h


