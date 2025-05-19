                            ASSUME CS:CODE,DS:DATA   
                            
                            

;BANKING SYSTEM
INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H



; DATA AREA
DATA SEGMENT
	COUNT DB 0
	CHOICE DB ?
    RINT DB ?
	MSG1 DB 10,13,"ENTER (1-6), 7 for odd, 8 for even $"   
	msg12 db 10,18, " 9 - first 3 and last 3 (0) N-EXIT$"
	
	MSG2 DB 10,13,"--------------------------------- $"
	MSG3 DB 10,13,"RESULT: $"
	MSG4 DB 10,13,"-------EXIT !!!!------$"
	MSG5 DB 10,13,"BINGO$"  
	
	msgprint  DB 10,13, "BET:  $" 
	
	
	
	msgguess db 'BET (1-6): $'
    winMsg db 13,10,'You WIN!$'
    loseMsg db 13,10,'You lose. Better luck next time!$'
    input db ?
    
    
	REC DB 100 DUP(0)  
	
	; BANKING DATA
	
	FNAME1 DB "ACCOUNT.txt",0
    FNAME2 DB "BALANCE.txt",0
    ACCOUNT DB 25 DUP('$')
    BALANCE DB 10 DUP('$')
    TEST_CASE DB 25 DUP('$')
    FHAND DW ? 
    CHAR DB ?
    FLAG DB 0
    TEMP DB 0
    COUNTMONEY DB 0         ; WAS COUNT
    LENGTH DB 10
    STR_LEN DB 0
    TMP DW 0
    SUM DW 0
    NUM DW 0
    TOTAL DW 0
    N DW 0
    AMOUNT DW ?
    
      
	

;  ROLLING SYSTEM	
	
DATA ENDS
CODE SEGMENT
ROLLING:
    MOV AX,DATA
	MOV DS,AX
	LEA SI,REC
	INC SI
	INC SI
	INC SI
    UP:
	LEA DX,MSG1        ;To display message intro
	MOV AH,09H
	INT 21H 
	
	LEA DX, msg12         
	MOV AH,09H
	INT 21H
	
	LEA DX,MSG2        ;To add spacing
	MOV AH,09H
	INT 21H	 
	
	LEA DX,msgprint        ; To display BET:
	MOV AH,09H
	INT 21H  
	     
	
	
	MOV AH,01H         ;To read the choice  
	
	INT 21H
	MOV CHOICE,AL      ; To Store the value of choice  
	
	
    
    
     
	; ZERO if decided to exit
	CMP AL,'0'         ; Compare the entered choice with ASCII value of 0 
	JE EXIT            ; If equal to 0 then Exit ( Terminate the program ) 
	
	; RANDOM GENERATION
	
	LEA DX,MSG3        ; To display message MSG3
	MOV AH,09H
	INT 21H
	MOV AH,2CH
	INT 21H            ; Interrupt used to get the system time
	
	 
	MOV AX,DX 
	MOV DX,0
	MOV CX,6
	DIV CX             ; Divide the value of AX with 6 in order to get remainder between 0 to 5
	ADD DL,'0'         ; Add the ASCII value 30 to convert value to ASCII
	ADD DL,1 			; Since obtained random integer is between 0 to 5 add 1 to make it display between 1 to 6 to simulate rolling of dice.
	
	
    ; RESULT
    MOV RINT,DL  	
	MOV [SI],DL
	INC SI
	MOV AH,02H         ;To display the Random value generated
	INT 21H   
	
	

	
	; COMPARE WIN OR LOSE
	mov bl, RINT
	mov al, CHOICE
    cmp al, bl
    jz won
    jmp lost            ; Otherwise, jump to lost
    
    

	
	
;--------------------- FOR LOOPING PURPOSES----------------------	
NEXT1:
	MOV BL,[SI]
	CMP BL,[SI-1]
	JNE EX
	CMP BL,[SI-2]
	JE NEXT
	EX:
	CMP COUNT,3
	;JE NEXT
	JMP UP             ; Continue till the user enters 0
	
NEXT:
	LEA DX,MSG5
	MOV AH,09H
	INT 21H
	JMP EXIT
EXIT:
	LEA DX,MSG4       ; To display message MSG1
	MOV AH,09H
	INT 21H
	MOV AH,4CH
	INT 21H  
	            
	            
;------------------------ EXTRA FUNCTIONS -------------	            
	            
lost:
    mov ah, 09h
    lea dx, loseMsg
    int 21h   
    
    CMP DL,'6'
	JNE NEXT1      
	
	
	INC COUNT;  
    jmp up              ; Go back up (to your game loop maybe)

won:
    mov ah, 09h
    lea dx, winMsg
    int 21h 
    CMP DL,'6'
	JNE NEXT1      
	
	
	INC COUNT;  
    jmp up              ; Go back up
    


CODE ENDS
END ROLLING
	