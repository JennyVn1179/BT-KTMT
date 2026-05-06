; Tìm giá trị lớn nhất và nhỏ nhất trong một mảng số
.Model Small
.Stack 100
.Data
    tb1 DB 10, 13, 'Gia tri lon nhat: $'
    tb2 DB 10, 13, 'Gia tri nho nhat: $'
    arr DW 5, 12, 7, 25, 3, 18 ; mảng số nguyên (word)
    len DW 6                   ; số phần tử trong mảng
.Code
main proc
    MOV AX, @Data
    MOV DS, AX ; khởi tạo thanh ghi DS

    ; Khởi tạo giá trị ban đầu
    LEA SI, arr       ; trỏ đến phần tử đầu tiên
    MOV AX, [SI]      ; AX = phần tử đầu tiên
    MOV BX, AX        ; BX = MIN
    MOV DX, AX        ; DX = MAX
    MOV CX, len
    DEC CX            ; còn lại (len-1) phần tử để duyệt

    ; Vòng lặp duyệt mảng
    NEXT_ELEMENT:
        ADD SI, 2     ; sang phần tử tiếp theo (word = 2 byte)
        MOV AX, [SI]  ; AX = phần tử hiện tại

        ; So sánh với MIN
        CMP AX, BX
        JL UPDATE_MIN

        ; So sánh với MAX
        CMP AX, DX
        JG UPDATE_MAX

        LOOP NEXT_ELEMENT
        JMP DONE

    UPDATE_MIN:
        MOV BX, AX
        LOOP NEXT_ELEMENT

    UPDATE_MAX:
        MOV DX, AX
        LOOP NEXT_ELEMENT

    ; In kết quả
    DONE:
        ; In MAX
        MOV AH, 9
        LEA DX, tb1
        INT 21h

        MOV AX, DX    ; AX = MAX
        CALL PRINTNUM ; in số

        ; In MIN
        MOV AH, 9
        LEA DX, tb2
        INT 21h

        MOV AX, BX    ; AX = MIN
        CALL PRINTNUM ; in số

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
