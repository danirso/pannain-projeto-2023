TITLE - ATIVIDADE - ALUNO: Daniel Scanavini Rossi RA:22000787 | ALUNO: VINICIUS BORGES DE GODOY RA:22006132
.model small
LINHA MACRO
   PUSH AX
   PUSH DX
   MOV DL,10
   MOV AH,02
   INT 21H
   POP DX
   POP AX
ENDM
LIMPA MACRO
   MOV AH,00
   INT 10H
ENDM
LIMPA_REG  MACRO
   XOR AX,AX
   XOR BX,BX
   XOR CX,CX
   XOR DX,DX
   XOR SI,SI
   XOR DI,DI
ENDM
.stack 100h
.data

PESO1 EQU 3
PESO2 EQU 4

ALUNOS DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?

NOME_ALUNO DB 'INSIRA O NOME DO ALUNO:$'
P1 DB 10,13,'INSIRA A NOTA DA P1:$'
P2 DB 10,13,'INSIRA A NOTA DA P2:$'
P3 DB 10,13,'INSIRA A NOTA DA P3:$'
MEDIA DB 10,13,'MEDIA DO ALUNO:$'
.code
    MAIN PROC
     LIMPA       ;LIMPA A TELA ANTES DA EXECUCAO DO PROGRAMA
     MOV AX,@DATA
     MOV DS,AX
     MOV ES,AX
     CALL READ_NAME
     CALL READ_GRADES
     
     MOV AH,4CH  ;FINALIZA O PROGRAMA
     INT 21H
   MAIN ENDP
   ;LE O NOME DOS ALUNOS
   READ_NAME PROC
     LEA DX,NOME_ALUNO
     MOV AH,09
     INT 21H
     LIMPA_REG
     MOV CX,10
     MOV AH,01
LE_NOME:
     INT 21H
     CMP AL,0DH
     JE SEGUE
     MOV ALUNOS[BX + SI],AL
     INC SI
     LOOP LE_NOME
SEGUE:
     RET
   READ_NAME ENDP
   ;LE AS NOTAS DOS ALUNOS
   READ_GRADES PROC
    XOR CX,CX
    LEA DX,P1
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX+SI],AL
    MOV DL,PESO1
    MUL DL
    ADD CL,AL
    
    INC SI

    LEA DX,P2
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX+SI],AL
    MOV DL,PESO1
    MUL DL
    ADD CL,AL
    
    INC SI

    LEA DX,P3
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX+SI],AL
    MOV DL,PESO2
    MUL DL
    ADD CL,AL
    
    INC SI
    
    MOV AH,0
    MOV AL,CL
    MOV CX,10
    DIV CX
    MOV DL,AL
    ADD DL,30H
    MOV AH,02
    INT 21H
    MOV ALUNOS[BX+SI],AL
    RET
   READ_GRADES ENDP
   END MAIN