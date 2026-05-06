; Kiểm tra xem chuỗi B có phải là xâu con của chuỗi A
.Model Small
.Stack 100
.Data
    tb1 DB 10, 13, 'Xau B la xau con cua A tai vi tri: $'
    tb2 DB 10, 13, 'Xau B khong phai la xau con cua A.$'
    A   DB 'HELLOASSEMBLY$', '$' ; chuỗi A
    B   DB 'ASSE$', '$'          ; chuỗi B
.Code
main proc
    MOV AX, @Data
    MOV DS, AX ; khởi tạo thanh ghi DS

    ; Khởi tạo con trỏ
    LEA SI, A     ; trỏ đến chuỗi A
    LEA DI, B     ; trỏ đến chuỗi B

    MOV CX, 0     ; CX = vị trí trong A
    MOV BX, 0     ; BX = cờ tìm thấy (0 = chưa, 1 = có)

SEARCH_LOOP:
    MOV AL, [SI]  ; lấy ký tự từ A
    CMP AL, '$'
    JE NOT_FOUND  ; nếu hết A mà chưa tìm thấy → không phải xâu con

    ; Kiểm tra chuỗi con bắt đầu tại vị trí SI
    PUSH SI
    PUSH DI
    CALL CHECK_SUBSTRING
    CMP BX, 1
    JE FOUND

    ; Nếu không khớp, tiếp tục duyệt A
    POP DI
    POP SI
    INC SI
    INC CX
    JMP SEARCH_LOOP

FOUND:
    ; In thông báo tìm thấy
    MOV AH, 9
    LEA DX, tb1
    INT 21h

    ; In vị trí (CX)
    MOV AX, CX
    CALL PRINTNUM
    JMP DONE

NOT_FOUND:
    ; In thông báo không tìm thấy
    MOV AH, 9
    LEA DX, tb2
    INT 21h

DONE:
    MOV AH, 4Ch
    INT 21h

main endp

; Thủ tục kiểm tra chuỗi con
CHECK_SUBSTRING proc
    PUSH AX
    PUSH CX
    PUSH DX

    MOV BX, 1     ; giả định tìm thấy
COMPARE_LOOP:
    MOV AL, [DI]
    CMP AL, '$'
    JE END_CHECK  ; hết chuỗi B → khớp

    CMP AL, [SI]
    JNE FAIL      ; ký tự không khớp

    INC SI
    INC DI
    JMP COMPARE_LOOP

FAIL:
    MOV BX, 0     ; không khớp
END_CHECK:
    POP DX
    POP CX
    POP AX
    RET
CHECK_SUBSTRING endp

; Thủ tục in số thập phân từ AX
PRINTNUM proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0
    MOV BX, 10

    CONVERT_LOOP:
        XOR DX, DX
        DIV BX        ; chia AX cho 10
        PUSH DX       ; dư
        INC CX
        CMP AX, 0
        JNE CONVERT_LOOP

    PRINT_LOOP:
        POP DX
        ADD DL, '0'
        MOV AH, 2
        INT 21h
        LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINTNUM endp

end main
