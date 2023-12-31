TITLE - ATIVIDADE - ALUNO: Daniel Scanavini Rossi RA:22000787 | ALUNO: VINICIUS BORGES DE GODOY RA:22006132
.model small

;Macro para pular linha
LINHA MACRO
   PUSH AX
   PUSH DX
   MOV DL,10
   MOV AH,02
   INT 21H
   POP DX
   POP AX
ENDM

;Macro Limpa a tela para o usuário
LIMPA MACRO
   PUSH AX
   MOV AX,03
   INT 10H
   POP AX
ENDM

;Macro zera os registradores
LIMPA_REG  MACRO
   XOR AX,AX
   XOR BX,BX
   XOR CX,CX
   XOR DX,DX
   XOR DI,DI
   XOR SI,SI
ENDM

.stack 100h
.data

;Definições das variáveis e strings para organização do programa

PESO1 EQU 3
PESO2 EQU 4

ESCOLHA DB 10 DUP(' ')

ALUNOS DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?
       DB 10 DUP(' '),?,?,?,?

GERENCIA DB 'PROGRAMA GERENCIADOR DE SALA DE AULA!$'
NOME_ALUNO DB'INSIRA O NOME DO ALUNO:$'

P1 DB 10,13,'INSIRA A NOTA DA P1:$'
P2 DB 10,13,'INSIRA A NOTA DA P2:$'
P3 DB 10,13,'INSIRA A NOTA DA P3:$'

PROMPT DB 10,13,'INSIRA O QUE DESEJA REALIZAR:',10,13,'1-ALTERAR NOTAS   2-SAIR DO PROGRAMA',10,13,'>$'
CHOICE DB 10,13,'INSIRA O NOME DO ALUNO QUE DESEJA ALTERAR O DADO:$'
NOTA DB 10,13,'INSIRA A NOTA QUE DESEJA ALTERAR',10,13,'1-P1   2-P2   3-P3',10,13,'>$'
NOTA1 DB 10,13,'INSIRA A NOVA NOTA DA PROVA:$'
ACABA DB 10,13,'PROGRAMA FINALIZADO$'

.code

;Função principal do programa onde chamamos as outras funções como Nome e Notas
    MAIN PROC
    LIMPA
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX
    MOV CX,5

REPETE:
    PUSH CX
    CALL READ_NAME
    CALL READ_GRADES
    CALL CALC_MEDIA
    LIMPA
    ADD BX,14
    XOR SI,SI
    POP CX
    LOOP REPETE
    LINHA
    CALL IMPRIME_MATRIZ
PERGUNTA:
    CALL MENU
    CMP AL,'2'
    JE FIM
    JMP ALTERA_NOTA
ALTERA_NOTA:
    CALL CHANGE_GRADES
    CALL CALC_MEDIA
    CALL IMPRIME_MATRIZ
    JMP PERGUNTA
FIM:
    LEA DX,ACABA
    MOV AH,09
    INT 21H
    MOV AH,4CH  ;FINALIZA O PROGRAMA
    INT 21H
   MAIN ENDP

   ;Procedimento que LE O NOME DOS ALUNOS
   READ_NAME PROC
    LEA DX,NOME_ALUNO
    MOV AH,09
    INT 21H
    XOR SI,SI
    MOV CX,10
    MOV AH,01
LE_NOME:
    INT 21H
    CMP AL,0DH
    JE SEGUE
    MOV ALUNOS[BX][SI],AL
    INC SI
    LOOP LE_NOME
SEGUE:
    RET
   READ_NAME ENDP
   ;LE AS NOTAS DOS ALUNOS
   READ_GRADES PROC
    MOV SI,10
    LEA DX,P1
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX][SI],AL
    INC SI 
    
    LEA DX,P2
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX][SI],AL
    INC SI 

    LEA DX,P3
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX][SI],AL
    RET
   READ_GRADES ENDP

   ;Procedimento que realiza o calculo da média do aluno com as notas das 3 provas digitadas
   CALC_MEDIA PROC
    XOR AX,AX
    XOR DX,DX
    XOR CX,CX
    MOV SI,10
    MOV AL,ALUNOS[BX][SI]
    MOV DL,PESO1
    MUL DL
    MOV CL,AL
    INC SI

    MOV AL,ALUNOS[BX][SI]
    MOV DL,PESO1
    MUL DL
    ADD CL,AL
    INC SI

    MOV AL,ALUNOS[BX][SI]
    MOV DL,PESO2
    MUL DL
    ADD CL,AL
    XCHG CL,AL
    XOR AH,AH
    MOV CL,10
    DIV CL
    INC SI

    MOV ALUNOS[BX][SI],AL
    RET   
   CALC_MEDIA ENDP

   ;Procedimento que imprime a matriz onde está os 5 alunos e suas informações como notas e média
IMPRIME_MATRIZ PROC
    LIMPA
    LEA DX,GERENCIA
    MOV AH,09
    INT 21H
    LIMPA_REG
    MOV CX,5
FUNC:    
    PUSH CX
    LINHA
    MOV CX,9
    MOV AH,02
IMP:
    MOV DL,ALUNOS[BX][SI]
    INT 21H
    INC SI
    LOOP IMP
    MOV CX,4;
    INC SI
SEGUIR:
    MOV DL,20H
    INT 21H
    MOV DL,ALUNOS[BX][SI]
    ADD DL,30H
    INT 21H
    INC SI
    LOOP SEGUIR
    ADD BX,14
    XOR SI,SI
    POP CX
    LOOP FUNC
    RET
   IMPRIME_MATRIZ ENDP

   ;Procedimento feito para a ambientação do menu para um melhor conforto ao usuário
   MENU PROC
    LIMPA_REG
    MOV AH,09
    LEA DX,PROMPT
    INT 21H
    MOV AH,01
    INT 21H
    RET
   MENU ENDP

   ;Procedimento que realiza a alteração na nota por meio de busca de nome, alterando o valor na matriz e recalculando a média
   CHANGE_GRADES PROC
    LIMPA_REG
    LEA DX,CHOICE
    MOV AH,09
    INT 21H
    MOV CX,10
    MOV AH,01
LER:
    INT 21H
    CMP AL,0DH
    JE FIM2
    MOV ESCOLHA[DI],AL
    INC DI
    LOOP LER
FIM2:
    XOR DI,DI
    MOV CX,9
    LEA DI,ESCOLHA
COMPARA:
    MOV AL,ALUNOS[BX][SI]
    MOV DL,ESCOLHA[DI]
    CMP AL,DL
    JNE NAO_IGUAL
    INC SI
    INC DI
    JMP VEM
NAO_IGUAL:
    ADD BX,14
    XOR SI,SI
    XOR DI,DI
VEM:
    LOOP COMPARA
    LEA DX,NOTA
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    MOV SI,10
    CMP AL,'2'
    JE P_2
    CMP AL,'3'
    JE P_3
    JMP ALTERA
P_2:
    INC SI
    JMP ALTERA
P_3:
    ADD SI,2
    JMP ALTERA
ALTERA:
    LEA DX,NOTA1
    MOV AH,09
    INT 21H
    MOV AH,01
    INT 21H
    SUB AL,30H
    MOV ALUNOS[BX][SI],AL
    RET
   CHANGE_GRADES ENDP
   END MAIN
