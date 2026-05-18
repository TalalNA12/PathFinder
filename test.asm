.model small
.stack 100h

.data
    msg db 'Status: Assembly Environment Online', 13, 10, '$'

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Output the message
    lea dx, msg
    mov ah, 09h
    int 21h

    ; Terminate and exit to DOS
    mov ax, 4c00h
    int 21h
main endp
end main
