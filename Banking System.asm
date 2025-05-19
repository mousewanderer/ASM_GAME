INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H
.DATA

    FNAME1 DB "ACCOUNT.txt",0
    FNAME2 DB "BALANCE.txt",0
    ACCOUNT DB 25 DUP('$')
    BALANCE DB 10 DUP('$')
    TEST_CASE DB 25 DUP('$')
    FHAND DW ? 
    CHAR DB ?
    FLAG DB 0
    TEMP DB 0
    COUNT DB 0
    LENGTH DB 10
    STR_LEN DB 0
    TMP DW 0
    SUM DW 0
    NUM DW 0
    TOTAL DW 0
    N DW 0
    AMOUNT DW ?

.CODE
    MAIN PROC
        
        MOV AX,@DATA
        MOV DS,AX
        
        PRINTN "                        *** BANKING SYSTEM ***"
        PRINTN
        PRINTN
        
        ;SCANNING NUMBER OF BILL
        PRINT "ENTER NUMBER OF BILLS: "
        CALL DECIMAL_INPUT
        MOV AX,NUM
        MOV N,AX
        PRINTN
        PRINTN
        
        ;CHECKING IF NUMBER OF BILL IS VALID OR NOT
        CMP N,0
        JE NO_BILL
        JMP SCANNING_BILLS
        
        NO_BILL:
        PRINTN "*** YOU HAVEN'T PURCHASED ANYTHING YET ***"
        JMP EXIT
        
        ;SCANNING THE BILLS
        SCANNING_BILLS:
        PRINTN "ENTER THE BILLS ONY BY ONE:"
  
        MOV BX,1
        
        INPUT:
        CMP BX,N
        JG INPUT_END
        CALL DECIMAL_INPUT
        MOV AX,NUM
        ADD TOTAL,AX
        INC BX
        PRINTN
        JMP INPUT
        
        INPUT_END:
        PRINTN
        MOV AX,TOTAL                     
        MOV NUM,AX
        PRINT "TOTAL BILL: "
        CALL DECIMAL_OUTPUT
        PRINTN
        PRINTN
        
        ;CHECKING IF TOTAL BILL IS GREATER THAN ZERO OR NOT
        CMP TOTAL,0
        JE NO_BILL
        
        ;ASKING FOR ACCOUNT NO
        ACCOUNT_INPUT:
        PRINT "ENTER YOUR 10 DIGIT (XXX-XX-XXX) ACCOUNT NO: "
        CALL STRING_IN
        PRINTN
        
        ;VALIDIFYING ACCOUNT NO
        CMP STR_LEN,10
        JNE INVALID_ACCOUNT        
        
        ;READING DATA FROM ACCOUNT FILE
        CALL READ_ACCOUNT_FILE
        
        ;CHECKING IF ACCOUNT IS FOUND IN THE FILE OR NOT
        CMP FLAG,1
        JE NOT_FOUND       
        PRINTN
        
        ;RETRIVING BALANCE DATA FOR DESIRED ACCOUNT
        CALL READ_BALANCE_FILE
        
        ;CONVERTING STRING TYPE BALANCE DATA TO DECIMAL TYPE
        CALL DECIMAL_CONVERT
        MOV AX,NUM
        MOV AMOUNT,AX
        CALL DECIMAL_OUTPUT
        PRINTN " BDT WAS FOUND IN THAT ACCOUNT"
        PRINTN
        
        ;CHECKING IF USER HAS ENOUGH BALANCE OR NOT
        MOV AX,AMOUNT
        SUB AX,TOTAL
        CMP AX,0
        JGE SUCCESSFUL
        JMP NOT_SUCCESSFUL
        
        NOT_SUCCESSFUL:
        PRINTN "*** SORRY NOT ENOUGH MONEY ***"
        JMP EXIT
        
        SUCCESSFUL:
        PRINTN "*** TRANSACTION SUCCESSFUL ***"
        PRINTN
        MOV NUM,AX
        CALL DECIMAL_OUTPUT
        PRINTN " BDT REMINING IN THE ACCOUNT"
        JMP EXIT
        
        NOT_FOUND:
        PRINTN
        PRINTN "*** ACCOUNT NOT FOUND IN THE DATABASE ***"
        JMP EXIT
        
        INVALID_ACCOUNT:
        PRINTN
        PRINTN "*** INVALID ACCOUNT. TRY AGAIN ***"
        PRINTN
        JMP ACCOUNT_INPUT 
        
        EXIT:
        MOV AH,4CH
        INT 21H
        
    MAIN ENDP
    
    ;DECIMAL INPUT FUNCTION
    
    DECIMAL_INPUT PROC
        
        MOV TMP,0
        MOV SUM,0
        
        LOOP1:
        MOV AH,1
        INT 21H
        CMP AL,13
        JE LOOP1_END
        SUB AL,48
        XOR AH,AH
        MOV TMP,AX
        MOV AX,SUM
        MOV CX,10
        MUL CX
        ADD AX,TMP
        MOV SUM,AX
        JMP LOOP1
       
        LOOP1_END:
        MOV AX,SUM
        MOV NUM,AX
        RET
       
    DECIMAL_INPUT ENDP
    
    ;DECIMAL OUTPUT FUNCTION
    
    DECIMAL_OUTPUT PROC
        
        CMP NUM,0
        JLE ZERO
        MOV BP,SP
       
        LOOP2:
        XOR AX,AX
        XOR DX,DX
        CMP NUM,0
        JE LOOP3
        MOV AX,NUM
        MOV BX,10
        DIV BX
        MOV NUM,AX
        ADD DX,48
        PUSH DX
        JMP LOOP2
       
        LOOP3:
        POP DX
        MOV AH,2
        INT 21H
        CMP SP,BP
        JNE LOOP3
       
        RET
        
        ZERO:
        MOV DL,48
        MOV AH,2
        INT 21H
        
        RET
       
    DECIMAL_OUTPUT ENDP   
    
    ;SCANNING ACCOUNT NO
    
    STRING_IN PROC
       
        MOV STR_LEN,0
        MOV SI,0
       
        LOOP4:
        MOV AH,1
        INT 21H
        CMP AL,13
        JE LOOP4_END 
        MOV TEST_CASE[SI],AL
        INC SI
        INC STR_LEN
        JMP LOOP4
       
        LOOP4_END:
        RET
       
    STRING_IN ENDP
    
    ;FUNCTION FOR STRING OUTPUT
    
    STRING_OUT PROC
       
        MOV SI,0
       
        LOOP22:
        MOV DL,BALANCE[SI]
        CMP DL,'$'
        JE LOOP22_END
        MOV AH,2
        INT 21H
        INC SI
        JMP LOOP22
       
        LOOP22_END:
        RET
       
    STRING_OUT ENDP
    
    ;READ ACCOUNT DATA FROM FILE
        
    READ_ACCOUNT_FILE PROC
        
        MOV FLAG,0
        MOV TEMP,0
        MOV ES,AX 
        
        ;OPEN FILE FOR READ
        MOV AH,3DH     
        MOV AL,0         
        LEA DX,FNAME1   
        INT 21H          
        MOV FHAND,AX    
       
        NEW_LINE_01: 
        MOV SI,0 
          
        READ_LINE_01:
        MOV AH,3FH
        MOV BX,FHAND
        MOV CX,1
        LEA DX,CHAR
        INT 21H 
        
        ;END OF FILE CHECK
        CMP AX,0
        JE SET_FLAG_01 
        
        MOV AL,CHAR
        
        ;END OF LINE CHECK
        CMP AL,10
        JE COMPARE_ACCOUNT
               
        ;ADD EACH CHARACTER TO TEXT ARRAY       
        MOV ACCOUNT[SI],AL
        INC SI
        JMP READ_LINE_01
    
        COMPARE_ACCOUNT:
        MOV BYTE PTR ACCOUNT[SI],'$'       
        
        ;COMPARE STRINGS
        INC TEMP 
        LEA SI,TEST_CASE     
        LEA DI,ACCOUNT
        MOV CL,LENGTH                   
        MOV SI,0
        
        REPEAT:
        MOV AL,ACCOUNT[SI]
        MOV BL,TEST_CASE[SI]
        CMP AL,BL
        JNE REPEAT_END
        INC SI
        LOOP REPEAT        
        JMP EQUAL_ACCOUNT
        
        REPEAT_END: 
        CMP FLAG,1
        JE FILE_EXIT_01          
        JMP NEW_LINE_01
        
        ;SETTING END OF FILE FLAG
        SET_FLAG_01:
        MOV FLAG,1
        JMP COMPARE_ACCOUNT          
        
        ;PRINTING MATCH FOUND FOR ACCOUNT                   
        EQUAL_ACCOUNT:
        MOV BL,TEMP
        MOV COUNT,BL
        MOV FLAG,0
        JMP FILE_EXIT_01          
         
        ;CLOSING THE FILE 
        FILE_EXIT_01:
        MOV AH,3EH
        MOV BX,FHAND
        INT 21H
        
        RET
    
    READ_ACCOUNT_FILE ENDP
    
    ;READ BALANCE FILE
    
    READ_BALANCE_FILE PROC
        
        MOV FLAG,0
        MOV TEMP,0
        MOV ES,AX 
        
        ;OPEN FILE FOR READ
        MOV AH,3DH     
        MOV AL,0         
        LEA DX,FNAME2   
        INT 21H          
        MOV FHAND,AX    
       
        NEW_LINE_02: 
        MOV SI,0 
          
        READ_LINE_02:
        MOV AH,3FH
        MOV BX,FHAND
        MOV CX,1
        LEA DX,CHAR
        INT 21H 
        
        ;END OF FILE CHECK
        CMP AX,0
        JE CHECK_BALANCE 
        
        MOV AL,CHAR
        
        ;END OF LINE CHECK
        CMP AL,10
        JE CHECK_BALANCE
               
        ;ADD EACH CHARACTER TO TEXT ARRAY       
        MOV BALANCE[SI],AL
        INC SI
        JMP READ_LINE_02
    
        CHECK_BALANCE:
        MOV BYTE PTR BALANCE[SI],'$'
        INC TEMP
        MOV BL,TEMP
        CMP COUNT,BL
        JE FILE_EXIT_02
        JMP NEW_LINE_02                                           
        
        FILE_EXIT_02:
        MOV AH,3EH
        MOV BX,FHAND
        INT 21H
        
        RET
    
    READ_BALANCE_FILE ENDP
    
    ;CONVERT STRING NUMBER INTO DECIMAL
    
    DECIMAL_CONVERT PROC
        
        MOV TMP,0
        MOV SUM,0
        MOV SI,0
        
        LOOP5:
        MOV AL,BALANCE[SI]
        CMP AL,'$'
        JE LOOP5_END
        SUB AL,48
        CMP AL,0
        JL IGNORE
        XOR AH,AH
        MOV TMP,AX
        MOV AX,SUM
        MOV CX,10
        MUL CX
        ADD AX,TMP
        MOV SUM,AX
        INC SI
        JMP LOOP5
        
        IGNORE:
        INC SI
        JMP LOOP5
       
        LOOP5_END:
        MOV AX,SUM
        MOV NUM,AX
        RET
        
    DECIMAL_CONVERT ENDP
    
END MAIN
