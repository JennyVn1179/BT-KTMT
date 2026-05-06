; Đếm số lượng và tính tổng các số chia hết cho 11 trong mảng
.Model Small
.Stack 100
.Data
    tb1 DB 10, 13, 'So luong cac so chia het cho 11: $'
    tb2 DB 10, 13, 'Tong cac so chia het cho 11: $'
    arr DW 22, 7, 33, 44, 5, 18, 121 ; mảng số nguyên (word)
    len DW 7                         ; số phần tử trong mảng
.Code
main proc
    MOV AX, @Data
    MOV DS, AX ; khởi tạo thanh ghi DS

    ; Khởi tạo biến đếm và tổng
    MOV CX, len
    LEA SI, arr
    MOV BX, 0   ; BX = count
    MOV DX, 0   ; DX = sum

    ; Vòng lặp duyệt mảng
    NEXT_ELEMENT:
        MOV AX, [SI]  ; AX = phần tử hiện tại
        MOV BP, AX    ; lưu tạm để cộng vào tổng nếu chia hết

        ; Kiểm tra chia hết cho 11
        MOV DI, 11
        XOR DX, DX
        DIV DI        ; AX / 11, dư trong DX
        CMP DX, 0
        JNE NOT_DIV11

        ; Nếu chia hết cho 11
        INC BX        ; tăng count
        ADD DX, BP    ; cộng vào sum

    NOT_DIV11:
        ADD SI, 2     ; sang phần tử tiếp theo
        LOOP NEXT_ELEMENT

    ; In kết quả
    ; In số lượng
    MOV AH, 9
    LEA DX, tb1
    INT 21h

    MOV AX, BX
    CALL PRINTNUM

    ; In tổng
    MOV AH, 9
    LEA DX, tb2
    INT 21h

    MOV AX, DX
    CALL PRINTNUM

    ; Kết thúc chương trình
    MOV AH, 4Ch
    INT 21h

main endp

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
