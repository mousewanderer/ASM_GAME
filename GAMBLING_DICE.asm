                            ASSUME CS:CODE,DS:DATA   
                            
                            
;BETTING SYSTEM  -----------------   MEL WINDZEIL R. YAP
INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H



; DATA AREA
DATA SEGMENT
	COUNT DB 0
	CHOICE DB ?
    RINT DB ?
	MSG1 DB 10,13,"                                    BET $"   
	msg12 db 10,13, " $"
	
	MSG2 DB 10,13," $"
	MSG3 DB 10,13,"                                    RESULT: $"
	MSG4 DB 10,13,"                                -------EXIT !!!!------$"
	MSG5 DB 10,13,"                                    BINGO$"  
	
	msgprint  DB 10,13, "                                    BET (1-6):  $" 
	msgspace  DB 10,13, "     $"
	
	
	
    winMsg db 13,10,'                                    You WIN!$'
    loseMsg db 13,10,'                                    You LOSE!$'
    input db ?
    
    
	REC DB 100 DUP(0)   
	
	
	
	; BETTING 
	 money dw 1000        ; equivalent to int money = 1000 
	 betamount dw ?
    msgbet1 db '                                Initial money: $', '$'
    
    msgbet2 db 13,10, '                                    Enter bet: $', '$'
    msgbet3 db 13,10, '                                    Not enough money!',13,10, '$'
    msgbet4 db 13,10, '                                    Money left: $', '$'   
    
    msgbet6 db 13,10, '                                    You WON! +$','$'
   
    buffer db 6, ?, 5 dup(0)  ; for input buffer (5 digits max) 
                                  
                                  
                                  
 ; -------------- DICE ANIMATION   
    ; Set this at the beginning of your data segment
OriginalMode db ?

; At program start, save original video mode
MOV AH, 0Fh      ; Get current video mode
INT 10h
MOV OriginalMode, AL  ; Save it      
    
    
   
	
      
	

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
	
	
	LEA DX, msg12         
	MOV AH,09H
	INT 21H
	
	LEA DX,MSG2        ;To add spacing
	MOV AH,09H
	INT 21H	
	
	
	LEA DX,msgspace
	MOV AH,09H
	INT 21H	   
	  ;----------------- GAMBLE START-----------------
	                                                  ;
	                                                  ;
                                                      ;
    ; --- Display Initial Money ---                   ;
    lea dx, msgbet1                                   ; 
    call print_string                                 ;
    mov ax, money                                     ;
    call print_number                                 ;
                                                      ;
    ; --- Check if money is zero ---                  ;
    mov ax, money                                     ;
    cmp ax, 0                                         ;
    je game_over  
    
  
     ; --- Ask for bet ---
    lea dx, msgbet2
    call print_string
    call get_number   
    
    ; CHANGE TO 
    mov betamount, ax   ; bet amount in CX      
    
    
    
	 ; --- Check if bet is valid ---                  ;
    mov ax, money                                     ;
    cmp betamount, ax                                 ;
    ja not_enough                                     ;
                                                      ;
     ; --- Deduct bet from money ---                  ;
    sub ax, betamount                                 ;
    mov money, ax                                     ;
                                                      ;
                                                      ;
	                                                  ;
	                                                  ;
	                                                  ;
	                                                  ;
	                                                  ;
	  ; --------------- GAMBLE END  -------------------
	                                           
	                                           
	                                           
	                                           
	                                           
	  
	
	   ; --------------------------------------------------------------- PICK NUMBER ON ---------------------
	
	LEA DX,msgprint        ; To display to put on:
	MOV AH,09H
	INT 21H  
	     
	
	
	MOV AH,01H         ;To read the choice  
	
	INT 21H
	MOV CHOICE,AL      ; To Store the value of choice  
	
	
    
    
     
	; ZERO if decided to exit
	CMP AL,'0'         ; Compare the entered choice with ASCII value of 0 
	JE EXIT            ; If equal to 0 then Exit 
	
	;----------------------------------------------------------------------------- RANDOM GENERATION
	
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
	
	
  
	
	 ; ------------------------ PICK NUMBER OFF ------------------

	
	;--------------------- COMPARE WIN OR LOSE -------------------
	mov bl, RINT
	mov al, CHOICE 
	
    cmp al, bl
    jz won
    jmp lost            ; Otherwise, jump to lost  
    
    
    

    ; --------------- Show remaining money ------------
    lea dx, msg4
    call print_string
    mov ax, money
    call print_number
   
    
    

	
	
;--------------------- FOR LOOPING PURPOSES----------------------	
NEXT1: 

    mov al, RINT   
    cmp al, '1' 
    jz losediceone 
    
    
    mov al, RINT   
    cmp al, '2'
    jz losedicetwo  
    
    
    mov al, RINT   
    cmp al, '3'
    jz losedicethree 
    
    
    mov al, RINT   
    cmp al, '4'
    jz losedicefour  
    
    
    
    mov al, RINT   
    cmp al, '5'
    jz losedicefive 
    
    
    
    mov al, RINT   
    cmp al, '6'
    jz losedicesix
    
    
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
	
	
     ; ------------------ Deduct bet from money ------------
    sub ax, cx
    mov money, ax    
    
    
     
    
   
    

	
	INC COUNT;  
    jmp up              ; Go back up (to your game loop maybe)


         
         
         
won:     


   
    
         
    
    ; --------------------------  WIN ANIMATION AREA --------------------------------- 
    
   
    
    
    

    ; Convert RINT from ASCII to numeric value for comparison
    mov al, RINT
    sub al, '0'      ; Convert ASCII digit to numeric value
    
    cmp al, RINT; 6         ; Compare numeric value
    jne regular_win   ; Not a special 6 win
    
    ; Special case: won with 6 (give 4x the bet)
    mov ax, betamount        ; bet is stored in CX
    shl ax, 2         ; AX = bet * 4
    shl ax, 2
    shl ax, 2  
 
    add money, ax     ; add winnings to money
    
    ; Display special win message
    lea dx, msgbet6
    call print_string
    mov ax, betamount        ; Show the amount won (bet * 5x)
    shl ax, 2 
    shl ax, 2
    shl ax, 2 
    
    
    
    mov ah, 09h
    lea dx, winMsg
    int 21h 
    
    mov al, RINT   
    cmp al, '1' 
    jz windiceone 
    
    
    mov al, RINT   
    cmp al, '2'
    jz windicetwo  
    
    
    mov al, RINT   
    cmp al, '3'
    jz windicethree 
    
    
    mov al, RINT   
    cmp al, '4'
    jz windicefour  
    
    
    
    mov al, RINT   
    cmp al, '5'
    jz windicefive 
    
    
    
    mov al, RINT   
    cmp al, '6'
    jz windicesix
    
    
     

    call print_number
    
    jmp continue_game

regular_win:      



    ; Regular win (give back the bet + same amount as winnings)
    mov ax, betamount        ; bet amount
    add money, ax     ; give back the bet
    add money, ax     ; add same amount as winnings (total 5x)  
    add money, ax
    add money, ax
    add money, ax

continue_game:  


    
    ; Show remaining money
    lea dx, msgbet4
    call print_string
    mov ax, money
    call print_number
    
    
     
    mov ah, 09h
    lea dx, winMsg
    int 21h 
    
    mov al, RINT   
    cmp al, '1' 
    jz windiceone 
    
    
    mov al, RINT   
    cmp al, '2'
    jz windicetwo  
    
    
    mov al, RINT   
    cmp al, '3'
    jz windicethree 
    
    
    mov al, RINT   
    cmp al, '4'
    jz windicefour  
    
    
    
    mov al, RINT   
    cmp al, '5'
    jz windicefive 
    
    
    
    mov al, RINT   
    cmp al, '6'
    jz windicesix
    
    
    
    
    inc COUNT
    jmp UP
    

    
    
    
    
;------------------- BANKING and back end LOGIC ----------------------  MEL WINDZEIL YAP
  
not_enough:
    lea dx, msg3
    call print_string  
    jmp Rolling

game_over:
    lea dx, msg5
    call print_string
    mov ah, 4ch
    int 21h

; --- Subroutine: print_string ---
print_string:
    mov ah, 09h
    int 21h
    ret

; --- Subroutine: get_number ---
get_number:
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    xor ax, ax
    xor bx, bx
    mov cl, buffer+1
    xor ch, ch
    lea si, buffer+2
convert_loop:
    mov bl, [si]
    sub bl, '0'
    mov bh, 0
    mov dx, 10
    mul dx
    add ax, bx
    inc si
    loop convert_loop
    ret

; --- Subroutine: print_number ---
print_number:
    ; AX contains number
    xor cx, cx
.next_digit:
    xor dx, dx
    mov bx, 10
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .next_digit
.print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop .print_loop
    ret  
 
; __________________________________ FRANCIS RAINER CUTAMORA DESIGN


; ----------------------------------------------------------------- WIN SCREEN DICE ONE
windiceone:     ; 1  

; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H      
    
    ; 6
    MOV AX,0600H
    MOV BH,0F0H
    MOV CH,5   
    MOV CL,5
    MOV DH,16
    MOV DL,25
    INT 10H 
    
    MOV AX,0600H
    MOV BH,00H
    MOV CH,13   
    MOV CL,18
    MOV DH,14
    MOV DL,20
    INT 10H 
    MOV AX,0600H
    MOV BH,00H
    MOV CH,13   
    MOV CL,10
    MOV DH,14
    MOV DL,12
    INT 10H     
    MOV AX,0600H
    MOV BH,00H
    MOV CH,7   
    MOV CL,18
    MOV DH,8
    MOV DL,20
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,7   
    MOV CL,10
    MOV DH,8
    MOV DL,12
    INT 10H
     
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,10
    MOV DH,11
    MOV DL,12
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,18
    MOV DH,11
    MOV DL,20
    INT 10H
    
    ; 2
    MOV AX,0600H
    MOV BH,0F0H
    MOV CH,5   
    MOV CL,5
    MOV DH,16
    MOV DL,25
    INT 10H
    
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,10
    MOV DH,11
    MOV DL,12
    INT 10H  
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,18
    MOV DH,11
    MOV DL,20
    INT 10H 
    
    ; 3
    MOV AX,0600H
    MOV BH,0F0H
    MOV CH,5   
    MOV CL,5
    MOV DH,16
    MOV DL,25
    INT 10H
    
    MOV AX,0600H
    MOV BH,00H
    MOV CH,13   
    MOV CL,10
    MOV DH,14
    MOV DL,12
    INT 10H  
    MOV AX,0600H
    MOV BH,00H
    MOV CH,7   
    MOV CL,18
    MOV DH,8
    MOV DL,20
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H     
    
    ; 4
    MOV AX,0600H
    MOV BH,0F0H
    MOV CH,5   
    MOV CL,5
    MOV DH,16
    MOV DL,25
    INT 10H 
    
    MOV AX,0600H
    MOV BH,00H
    MOV CH,13   
    MOV CL,18
    MOV DH,14
    MOV DL,20
    INT 10H 
    MOV AX,0600H
    MOV BH,00H
    MOV CH,13   
    MOV CL,10
    MOV DH,14
    MOV DL,12
    INT 10H     
    MOV AX,0600H
    MOV BH,00H
    MOV CH,7   
    MOV CL,18
    MOV DH,8
    MOV DL,20
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,7   
    MOV CL,10
    MOV DH,8
    MOV DL,12
    INT 10H   
    
    
    
    ; 1
    MOV AX,0600H
    MOV BH,0A0H
    MOV CH,5   
    MOV CL,5
    MOV DH,16
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H
    

; Roll to 1 
    
    ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h
    

    
    ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
       
     inc COUNT
    jmp UP
          
; ----------------------------------------------------------------- WIN SCREEN DICE TWO
windicetwo: 
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    
    
    ; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H     

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H


; 2
MOV AX,0600H
MOV BH,0A0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

    ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h
    
    
     ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
      
    
    inc COUNT
    jmp UP
    
; ----------------------------------------------------------------- WIN SCREEN DICE THREE
windicethree:

         
    ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H     
    
    
    ; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H     

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H


; 3
MOV AX,0600H
MOV BH,0A0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H  
; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h
    
    
     ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h

    
     inc COUNT
    jmp UP 
    
; ----------------------------------------------------------------- WIN SCREEN DICE FOUR    
windicefour:  
                
                
                
                
                     
    ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________
    
    ; 1
    
    
    ; 1
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H      

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 1
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H

; 4
MOV AX,0600H
MOV BH,0A0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H



; Roll to 4 
MOV AX,0600H
MOV BH,0F0H

MOV CH,5
MOV CL,50
MOV DH,5
MOV DL,70
INT 10H


MOV AH, 02H
MOV BH, 00
MOV DH, 5
MOV DL, 50
INT 10H



    ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h





  
    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    inc COUNT
    jmp UP
    
 ; ----------------------------------------------------------------- WIN SCREEN DICE FIVE  
windicefive:


                 
    ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________
    
    ; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H     

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H

; 5
MOV AX,0600H
MOV BH,0A0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H    

; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
 
    
     inc COUNT
    jmp UP
; ----------------------------------------------------------------- WIN SCREEN DICE SIX    
windicesix:   

              
    ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________  
    
    ; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H

; 5
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H 

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H 

; 6
MOV AX,0600H
MOV BH,0A0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP
    
    
    
; LOSE PART ________________________________________________________________________________________________________________

; -----------------------------------------------------------------LOSE SCREEN DICE ONE 
 losediceone:    
 
 
 ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________ 
    
    ; 1
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H      

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H

; 1
MOV AX,0600H
MOV BH,0C0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H
 
    
    
    
    
    
    
    
 
 ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP
     
    
 ; -----------------------------------------------------------------LOSE SCREEN DICE TWO
 losedicetwo:
 ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________ 
    
    ; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H     

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H


; 2
MOV AX,0600H
MOV BH,0C0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 
    
    
    
    
    
    
    
 
 ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP
    
    
      
; -----------------------------------------------------------------LOSE SCREEN DICE THREE  

losedicethree:
 ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________  
    
     ; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H     

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H


; 3
MOV AX,0600H
MOV BH,0C0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H 
    
    
    
    
    
 
 ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP 
    
; -----------------------------------------------------------------LOSE SCREEN DICE FOUR     

losedicefour: 
 ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________ 
    
    MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H      

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 1
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H

; 4
MOV AX,0600H
MOV BH,0C0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H



 
    
    
    
    
    
    
    
 
 ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP
    
     
; -----------------------------------------------------------------LOSE SCREEN DICE FIVE    
    
losedicefive:  
 ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________ 
    
    
    ; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H     

; 6
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

; 2
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H 

; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H

; 5
MOV AX,0600H
MOV BH,0C0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H 
    
    
    
    
    
    
    
 
 ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP
    
; -----------------------------------------------------------------LOSE SCREEN DICE SIX    
losedicesix:    

 ; Save current cursor position if needed
    ; 1         
    
    ; Save current cursor position if needed
    MOV AH, 03h
    INT 10h
    PUSH DX      ; Save cursor position        
    
    
    
    
     ;Clear screen
    mov ax, 3
    int 10h
    
     ; BLACK OUT FUNC   
    MOV AX,0600H
    MOV BH,000H
    MOV CH,0   
    MOV CL,5
    MOV DH,25
    MOV DL,25
    INT 10H
    MOV AX,0600H
    MOV BH,00H
    MOV CH,10   
    MOV CL,14
    MOV DH,11
    MOV DL,16
    INT 10H   
    
    ; CODE ___________  
    
    
    ; 3
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H  
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H     

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H

; 5
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,14
MOV DH,11
MOV DL,16
INT 10H 

; 4
MOV AX,0600H
MOV BH,0F0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H 

; 6
MOV AX,0600H
MOV BH,0C0H
MOV CH,5   
MOV CL,5
MOV DH,16
MOV DL,25
INT 10H 

MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,18
MOV DH,14
MOV DL,20
INT 10H 
MOV AX,0600H
MOV BH,00H
MOV CH,13   
MOV CL,10
MOV DH,14
MOV DL,12
INT 10H     
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,18
MOV DH,8
MOV DL,20
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,7   
MOV CL,10
MOV DH,8
MOV DL,12
INT 10H
 
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,10
MOV DH,11
MOV DL,12
INT 10H
MOV AX,0600H
MOV BH,00H
MOV CH,10   
MOV CL,18
MOV DH,11
MOV DL,20
INT 10H

    
    
    
    
    
    
    
 
 ; Wait for keypress (optional)
    MOV AH, 00h
    INT 16h



    


 ; Restore text mode
    MOV AX, 0003h  ; 80x25 text mode
    INT 10h
    
    ; Restore cursor position
    POP DX
    MOV AH, 02h
    INT 10h
   
    
    inc COUNT
    jmp UP

 
    
      
    
    
    
    
      
 







CODE ENDS
END ROLLING
	