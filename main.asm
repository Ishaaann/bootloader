; ORG(directive) tells the assembler to start assembling the code at the specified address.
; It tells the assembler where we expect our code to be loaded in memory.
; bios loads first 512 bytes of the disk into memory at 0x7c00, so we need to start our code at 0x7c00

; BITS(directive) tells the assembler to generate 16-bit code.

; directives give a clue to the assembler that will affect how the program gets compiled
; instuctions are blocks of code that are executed by the CPU and that get translated into machine code

org 0x7C00
bits 16

%define ENDL_CR 0x0D
%define ENDL_LF 0x0A

start:        ;making sure main is the entry point of the program 
    jmp main   


;prints a string to the screen
; params: 
;     ds:si points to the string 
prints:
    push si;
    push ax;

.loop:
    lodsb 
    or al,al
    jz .done

    mov ah,0x0E
    mov bh,0x00
    int 0x10

    jmp .loop


.done:
    pop ax
    pop si
    ret 


main:
;setting up data segements 
    mov ax,0
    mov ds,ax
    mov es,ax

;setup stack
;stack grows downwards, so we set the stack pointer to the beginning of the OS
;if we put it at the end, it will overwrite our OS
    mov ss,ax
    mov sp,0x7C00  ;stack will grow downwards from 0x7C00

    ;print hello world
    mov si, string_hello
    call prints

    hlt
;halt stops cpu from executing any more instructions

string_hello: db 'Hello, Kanu!', ENDL_CR, ENDL_LF, 0

.halt:
    jmp .halt

;the bios requires the last two bytes of the boot sector to be 0x55 and 0xAA

times 510-($-$$) db 0
dw 0xAA55