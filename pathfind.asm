.model small
.stack 100h

MAX_NODES equ 5

.data
    adj_matrix db MAX_NODES * MAX_NODES dup(0)
    visited db MAX_NODES dup(0)
    
    ; Terminal UI Strings
    msg_boot db 'PathFinder Engine: Online.', 13, 10, '$'
    msg_prompt db 'Enter Starting Node (0-4): $'
    msg_path db 'DFS Traversal Sequence: $'
    msg_arrow db ' -> $'
    msg_error db 13, 10, 'FATAL: Invalid Node. System Halted.', 13, 10, '$'

; ---------------------------------------------------------
; MACRO: ADD_EDGE
; ---------------------------------------------------------
ADD_EDGE MACRO src, dest
    push ax
    push bx
    push si

    mov al, src
    mov bl, MAX_NODES
    mul bl
    add al, dest
    mov ah, 0
    mov si, ax
    
    mov adj_matrix[si], 1

    pop si
    pop bx
    pop ax
ENDM

.code
; ---------------------------------------------------------
; PROCEDURE: EXECUTE_DFS
; ---------------------------------------------------------
EXECUTE_DFS proc
    push ax
    push bx
    push cx
    push si
    push dx

    ; Mark current node as visited
    mov bl, al
    mov bh, 0
    mov si, bx
    mov visited[si], 1

    ; Output current node
    mov dl, al
    add dl, 30h
    mov ah, 02h
    int 21h

    ; Print arrow
    lea dx, msg_arrow
    mov ah, 09h
    int 21h

    ; Scan adjacent nodes
    mov cx, 0

scan_loop:
    cmp cx, MAX_NODES
    jge traversal_return

    ; Offset calc
    push ax
    mov al, bl
    push bx
    mov bl, MAX_NODES
    mul bl
    add al, cl
    mov ah, 0
    mov si, ax
    pop bx
    pop ax

    cmp adj_matrix[si], 1
    jne next_target

    mov si, cx
    cmp visited[si], 0
    jne next_target

    push ax
    mov al, cl
    call EXECUTE_DFS
    pop ax

next_target:
    inc cx
    jmp scan_loop

traversal_return:
    pop dx
    pop si
    pop cx
    pop bx
    pop ax
    ret
EXECUTE_DFS endp

; ---------------------------------------------------------
; MAIN LOOP: UI & INPUT HANDLING
; ---------------------------------------------------------
main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg_boot
    mov ah, 09h
    int 21h

    ; Deploy Topology
    ADD_EDGE 0, 1
    ADD_EDGE 0, 2
    ADD_EDGE 1, 3
    ADD_EDGE 2, 4
    ADD_EDGE 4, 1

    ; 1. Request User Input
    lea dx, msg_prompt
    mov ah, 09h
    int 21h

    mov ah, 01h             ; Interrupt to read single character
    int 21h                 ; AL now holds the ASCII keystroke

    ; 2. Convert ASCII to Integer
    sub al, 30h             ; Example: ASCII '2' (32h) - 30h = Integer 2

    ; 3. Validation Firewall
    cmp al, 0
    jl trigger_error        ; If input < 0, error
    cmp al, MAX_NODES - 1
    jg trigger_error        ; If input > 4, error

    ; 4. Input Valid - Prepare for Execution
    mov cl, al              ; Temporarily store integer in CL
    
    ; Print Line Breaks for clean formatting
    mov dl, 13              ; Carriage Return
    mov ah, 02h
    int 21h
    mov dl, 10              ; Line Feed
    mov ah, 02h
    int 21h

    lea dx, msg_path
    mov ah, 09h
    int 21h

    ; 5. Execute DFS Traversal
    mov al, cl              ; Move integer back to AL for EXECUTE_DFS
    call EXECUTE_DFS
    jmp terminate_sys

trigger_error:
    lea dx, msg_error
    mov ah, 09h
    int 21h

terminate_sys:
    mov ax, 4c00h
    int 21h
main endp
end main