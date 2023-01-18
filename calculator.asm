org 100h

.DATA
    msg1 DB 0AH,0DH, "Enter first  Number :  $"        ;0AH is equivalent to 10 in decimal and to linefeed ('\n') in ASCII
                                                       ;which moves the cursor to the next row of the screen but maintaining the same column
                                                       
                                                       
    msg2 DB 0AH,0DH, "Enter second Number :  $"        ;0DH is equivalent to 13 in decimal and to return ('\r') in ASCII 
                                                       ;which moves the cursor to the beginning of the current row   
                                                       
    msg3 DB 0AH,0DH, "Enter your choice: (1. addition(+), 2. subtraction (-) , 3. multiplication (*), 4. diviion (/), 5. modulus (%) , 6. power (^) , 7. AND(&) , 8. OR(||) , 9. NOT(!)):  $"
    result DB 0AH,0DH, "Result is : $"
    proj  DB 0AH,0DH,   "                   -------- COA PROJECT - CALCULATOR -------$" 
    myname  DB 0AH,0DH, "                   -------------- TEAM-26 ---------------$"
    section  DB 0AH,0DH,"                   ---------------- CSE - A -----------------$" 
    done  DB 0AH,0DH, "---------------------------------$" 
    done2  DB 0AH,0DH, "********************************************************************************$"
    invalid_message DB 0AH,0DH, "INVALID INPUT$"    
    num1 dw 00h
    num2 dw 00h
    overflow db 00h    
    MSG_1 DB  "ENTER THE FRST NUMBER: 0x$"
    MSG_2 DB  "ENTER THE SCND NUMBER: 0x$"
    MSG_3 DB  "ENTER YOUR CHOICE", 13, 10, "[1:AND, 2:OR, 3:NOT, 4:XOR]: $"
    MSG_4 DB  "RESULT IS: 0x$"


    NEWLINE_MSG DB 13,10,"$"

    NUM_1 DW  ?
    NUM_2  DW  ?
    OP_NUM DW  ?

   
.CODE       
            include 'emu8086.inc'
            LEA DX,done2            ;to print done2 string
            MOV AH,09H              ;To display character string
            INT 21H                 ;call DOS function
            LEA DX,proj             ;to print proj string
            MOV AH,09H              ;To display character string
            INT 21H                 ;call DOS function
            LEA DX,myname           ;to print name string
            MOV AH,09H              ;To display character string
            INT 21H                 ;call DOS function
            LEA DX,section          ;to print section string
            MOV AH,09H              ;To display character string
            INT 21H                 ;call DOS function
            LEA DX,done2            ;to print done2 string
            MOV AH,09H              ;To display character string
            INT 21H                 ;call DOS function
            
            
 calculator:
            MOV AX,@DATA            ;to move the address of DATA in AX 
            MOV DS,AX               ;initializing data segment(DS)  
     
            CALL input              ;calling input procedure
    
            CALL parser             ;calling parser procedure
    
            CALL operation          ;calling operation procedure
            
            MOV [SI],'&'            ;To label the end of result in Data Segment 
            
            call reverse_parser     ;calling reverse_parser procedure
            
            call print_result       ;calling print_result procedure
   
 
 
 input  PROC                        ;/////////////////////////////// input procedure /////////////////////////////////;
                
                MOV [SI],'&'        ;To mark end of input1 in segment
                LEA DX,msg1         ;to print message1
                MOV AH,09H          ;To display character string
                INT 21H             ;call DOS function
                
       
                         
        input1:          
                MOV AH,01H          ;to read from the keyboard
                INT 21H             ;call DOS function
                CMP AL,13d          ;To check wether enter is pressed or not
                JZ  print_message2  ;Jump to second input if enter is pressed
                MOV AH,AL
                SUB AH,'0'          ;Comparing entered number (should be greater than 0 and less than 9)
                JC invalid          ;jump to invalid if number operator is NOT between 0 to 9
                MOV AH,AL 
                MOV DH,'9'
                SUB DH,AH           ;Comparing entered number (should be greater than 0 and less than 9)
                JC invalid          ;jump to invalid if number operator is NOT between 0 to 9
                SUB AL,'0'          ;Subtract ASCII of 0 to convert from character to number
                INC SI              ;SI=SI+1
                MOV [SI],AL         ;Store at incremented SI
                JMP input1          ;Jump to input1 if enter is not pressed   
                
               
                
        print_message2:
                INC SI              ;SI=SI+1
                MOV [SI],'&'        ;To mark end of input2 in segment
                LEA DX,msg2         ;to print message2
                MOV AH,09H          ;To display character string
                INT 21H             ;call DOS function
                                   
        input2:
                MOV AH,01H          ;to read from the keyboard
                INT 21H             ;call DOS function 
                CMP AL,13d          ;To check wether enter is pressed or not
                JZ exit             ;Jump to exit if enter is pressed
                MOV AH,AL
                SUB AH,'0'          ;Comparing entered number (should be greater than 0 and less than 9)
                JC invalid          ;jump to invalid if number operator is NOT between 0 to 9
                MOV AH,AL 
                MOV DH,'9'
                SUB DH,AH           ;Comparing entered number (should be greater than 0 and less than 9)
                JC invalid          ;jump to invalid if number operator is NOT between 0 to 9
                SUB AL,'0'          ;Subtract ASCII of 0 to convert from character to number
                INC SI              ;SI=SI+1
                MOV [SI],AL         ;Store at incremented SI
                JMP input2          ;Jump to input2 if enter is not pressed
        exit:              
                ret
                
       invalid: LEA DX,invalid_message;To display invaid message (If number entered is NOT between 0 to 9)
                MOV AH,09H          ;To display character string
                INT 21H             ;call DOS function
                hlt
 ENDP                               ;//////////////////////////// END of input procedure //////////////////////////////;
 


 parser PROC                        ;////////////////////////////// parser procedure //////////////////////////////////;
  
                MOV CX,01d          ;initializing CX by 01d
                MOV BX,00H          ;initializing BX by 00H  
                
        parse2:  
                MOV AX,00H          ;initializing AX by 00H
                MOV AL,[SI]         ;Copy the digit stored at SI to AL 
                MUL CX              ;Multiplying AX by CX(decimal position)
                ADD BX,AX           ;Storing the result of multiplication in BX
                MOV AX,CX           ;copy CX into AX (for increamenting decimal position)
                MOV CX,10d          ;moving value 10 in CX (for increamenting decimal position)
                MUL CX              ;Multiplying AX by CX  (for increamenting decimal position)
                MOV CX,AX           ;copy AL into CX (for increamenting decimal position
                DEC SI              ;SI=SI-1
                CMP [SI],'&'        ;If reached end of number2 (input2)
                JNZ parse2          ;Jump to parse1 if not reached at the end of number2 (input2)
                
                MOV [num2],BX       ;store the parsed number2 at num2
                MOV BX,00H          ;initializing BX by 00H          
                MOV DX,00h          ;initializing BX by 00H
                DEC SI              ;SI=SI-1
                MOV CX,01d          ;initializing CL by 01d
                
         parse1:  
                MOV AX,00H          ;initializing AX by 00H
                MOV AL,[SI]         ;Copy the digit stored at SI to AL
                MUL CX              ;Multiplying AX by CX(decimal position)
                ADD BX,AX           ;Storing the result of multiplication in BX
                MOV AX,CX           ;copy CX into AX (for increamenting decimal position)
                MOV CX,10d          ;moving value 10 in CX (for increamenting decimal position)
                MUL CX              ;Multiplying AX by CX  (for increamenting decimal position)
                MOV CX,AX           ;copy AX into CX (for increamenting decimal position
                DEC SI              ;SI=SI-1
                CMP [SI],'&'        ;If reached end of number1 (input1)
                JNZ parse1          ;Jump to parse2 if not reached at the end of number1 (input1)
                
                MOV [num1],BX       ;store the parsed number1 at num1
                MOV AX,[num1]       ;store the parsed number1 in BX
                MOV BX,[num2]       ;store the parsed number2 in BX 
                 
                
        ret                                                                                                     
 ENDP                               ;/////////////////////////////// END of parser procedure ///////////////////////////;
          
       
 operation proc                     ;//////////////////////////////// operation procedure //////////////////////////////;
               MOV CX,AX            ;storing the value of AX in CX
               LEA DX,msg3          ;to print message3
               MOV AH,09H           ;To display character string
               INT 21H              ;call DOS function
                
                
               MOV AH,01H           ;to read from the keyboard
               INT 21H              ;call DOS function
               
               CMP AL,'+'           ;Comparing entered operator with '+'
               JZ addition          ;jump to addition if entered operator is '+'
               
               CMP AL,'-'           ;Comparing entered operator with '-'
               JZ subtraction       ;jump to subtraction if entered operator is '-'
               
               CMP AL,'*'           ;Comparing entered operator with '*'
               JZ multiplication    ;jump to multiplication if entered operator is '*'
               
               CMP AL,'/'           ;Comparing entered operator with '/'
               JZ division          ;jump to division if entered operator is '/'
               
               CMP AL,'%'           ;Comparing entered operator with '%'
               JZ mod               ;jump to mod if entered operator is '%' 
               
               CMP AL,'^'           ;Comparing entered operator with '^'
               JZ pow               ;jump to pow if entered operator is '^' 
               
               CMP AL,'&'           ;Comparing entered operator with '^'
               JZ AND_OP            ;jump to pow if entered operator is '^'
               
               CMP AL,'|'          ;Comparing entered operator with '^'
               JZ OR_OP             ;jump to pow if entered operator is '^'
               
               CMP AL,'!'           ;Comparing entered operator with '^'
               JZ NOT_OP            ;jump to pow if entered operator is '^'
               

           
               LEA DX,invalid_message;To display invaid message (If operatot entered is NOT '+' OR '-' OR '*' OR '/' OR '^')
               MOV AH,09H           ;To display character string
               INT 21H              ;call DOS function
           hlt
       
       addition:
                MOV AX,CX           ;copy number1 to AX from CX
                MOV DX,00h          ;moving 00h in DX
                ADD AX,BX           ;adding with number2 and storing the result in AX
                ADC AX,DX           ;adding CF to AX and storing the result in AX
                RET  
                
       subtraction:
                MOV AX,CX           ;copy number1 to AX from CX
                SUB AX,BX           ;subtracting number2 from number1 and storing the result in AX 
                JC ov 
                JNC nov
             ov:NEG AX
                MOV [overflow],01h
                RET
            nov:RET 
                
       multiplication:
                MOV AX,CX           ;copy number1 to AX from CX
                MOV DX,00H          ;moving 00h in DX
                MUL BX              ;multiplying number1 by number2 and storing the result in AX
                RET     
                
       division:
                MOV AX,CX           ;copy number1 to AX from CX
                MOV DX,00H          ;moving 00h in DX 
                ADD BX,DX
                JZ DbyZ
                DIV BX              ;dividing number1 by number2 and storing the result in AX
                RET
         DbyZ:  print '   ERROR : DIVIDE BY ZERO'
                JMP calculator 
                
                
       mod:
                MOV AX,CX           ;copy number1 to AX from CX
                MOV DX,00H          ;moving 00h in DX
                ADD BX,DX
                JZ DbZ
                DIV BX              ;dividing number1 by number2 and storing the result in AX
                MOV AX,DX           ;moving remainder in AX from DX
           DbZ: RET    
           
       pow:
                MOV AX,CX           ;copy number1 to AX from CX
                MOV CX,BX           ;initializing CX with BX(number2)
                ADD CX,00h          ;
                JZ Lc   
                SUB CX,01h          ;CX=CX-1; 
                JZ La               ;if CX = 0 ,jump to La
                JNZ Lb              ;if CX != 0 ,jump to Lb
           La:  ret                 ;                      
           Lb:  MOV BX,AX           ;moving value of AX in BX
                MOV DX,00h          ;moving 00h in DX
           L1:  MUL BX              ;multiplying number1 by number1 and storing the result in AX
                LOOP L1             ;jump to L1 untill CX != 0
                ret
           Lc:  MOV AX,01h
                ret       
                  
        PRINTF MSG_1                                         ; GET THE FIRST NUMBER
        SCANF NUM_1, L1, L2, NN1, HN1, SH1                   ; READ THE FIRST NUMBER

        CALL NEWLINEP                                        ; PRINT NEW LINE


        ; GET THE OPERATION BEFORE SECOND NUMBER
        PRINTF MSG_3                                         ; GET THE OPERATION
        SCANF OP_NUM, L5, L6, NN2, HN2, SH2                  ; READ THE OPERATION NUMBER

        CALL NEWLINEP                                        ; PRINT NEW LINE


        CMP OP_NUM, 03H                                    ; IF OPERATION IS NOT 
        JE NOT_OP                                          ; SKIP SCANNING SECOND NUMBER

        PRINTF MSG_2                                        ; GET THE SECOND NUMBER
        SCANF NUM_2, L3, L4, NN3, HN3, SH3                  ; READ THE SECOND NUMBER

        CALL NEWLINEP                                       ; PRINT NEW LINE

        MOV AX, NUM_1                                       ; PUT FIRST NUMBER IN AX

        CMP OP_NUM, 01H                                     ; CHECK IF AND OPERATION
        JE AND_OP
        CMP OP_NUM, 02H                                     ; CHECK IF OR OPERATION
        JE OR_OP
        CMP OP_NUM, 04H                                     ; CHECK IF XOR OPERATION
        JE XOR_OP


        AND_OP:                                             ; AND SECOND NUMBER WITH FIRST NUMBER 
        AND AX, NUM_2
        JMP NEXT

        OR_OP:                                              ; OR SECOND NUMBER WITH FIRST NUMBER 
        OR AX, NUM_2
        JMP NEXT

        NOT_OP:                                             ; NOT THE FIRST NUMBER
        MOV AX, NUM_1                                       ; PUT FIRST NUMBER IN AX
        NOT AX
        JMP NEXT

        XOR_OP:                                             ; XOR SECOND NUMBER WITH FIRST NUMBER 
        XOR AX, NUM_2
        JMP NEXT

        NEXT: 
        MOV BX, 0010H                                       ; PUT 16D IN BX
        MOV CX, 0000H                                       ; ZERO CX

        PUT_NUMBER_IN_STACK:
        MOV DX, 0000H                                       ; ZERO DX
        DIV BX                                              ; DIVIDE BY 10D & PUT (NUMBER) REMINDER IN DX
        PUSH DX                                             ; PUSH DX (NUMBER) INTO STACK
        INC CX                                              ; INCREMENT CX TO KNOW SIZE OF NUMBER (WILL BE USED LATER IN LOOP)

        CMP CX, 0004H                                       ; LOOP UNTIL AX IS EMPTY
        JNE PUT_NUMBER_IN_STACK                             ; IF NOT EMPTY, REPEAT
            
        PRINTF MSG_4                                        ; PRINT THE RESULT
      
        DISPLAY_RESULT:
        POP DX                                              ; GET THE MOST LEFT NUMBER FROM STACK
        ADD DL, 30H                                         ; ADD 30H TO PRINT ASCII CHAR
        CMP DL, 39H                                         ; IF THE CHAR IS < 39H (IS A NUMBER)
        JB  SKIP_ADDING                                     ; SKIP ADDING 07H (FOR CHAR FROM [A-F]H)
        ADD DL, 07H                                         ; ADD 07H TO CONVERT IT TO LETTER [A-F]H
        
        SKIP_ADDING:                                        ; EVENTUALLY IT WILL GET HERE TO PRINT THE CHAR WHATEVER IT IS
        
        MOV AH, 02H                                         ; MODE OUTPUT FOR 1 CHAR
        INT 21H                                             ; PRINT THE CHAR
        LOOP DISPLAY_RESULT                                 ; LOOP UNTIL CX IS ZERO (PREVIOUSLY SET)

        CALL NEWLINEP                                       ; PRINT THE FINAL MESSAGE

        MOV AX, 4C00H                                       ; RETURN TO OS
        INT 21H                                                         

        NEWLINEP PROC                                       ; PROCEDURE TO PRINT NEW LINE
            MOV DX, OFFSET NEWLINE_MSG
            MOV AH, 09H                                     ; OUTPUT MODE FOR STRING
            INT 21H                                         ; PRINT THE STRING

            RET                                             ; RETURN TO WHERE IT'S CALLED
        NEWLINEP ENDP

                                
 ENDP                               ;///////////////////////////// END OF operation procedure ////////////////////////////;
                  
              
 reverse_parser PROC                ;//////////////////////////// reverse_parser procedure ///////////////////////////////;
     
        r_parse:
                MOV DX,00h          ;initailizing DX by 00h;
                MOV BX,10d          ;Dividing value in AX by 10  
                DIV BX              ;to get single digits in DL  
                ADD DL,'0'          ;Adding ASCII of 0 to convert from number to character   

                INC SI             
                MOV [SI],DL         ;Store in Data Segment   
                ADD AX,00h          ;If AX still has some value( if remainder != 0 )   
                JNZ r_parse         ;repeat the reverse_parse       
                           
            
 ENDP                               ;///////////////////////// END of reverse_parser procedure ///////////////////////////;   
 
 
 
 print_result PROC                  ;//////////////////////////// print_result procedure /////////////////////////////////;
              
              LEA DX,result         ;to print result
              MOV AH,09H            ;To display character string
              INT 21H               ;call DOS function
              MOV CL,01h            ;initailizing CL with 01h
              CMP CL,[overflow]     ;to check the overflow  
              MOV [overflow],00h
              JZ print_minus        ;jump to print_minus if overflow
              JNZ print             ;jump to print if no overflow
 print_minus: MOV DL,'-'            ;Loads ascii of '-' 
              MOV AH,02H            ;To display value in DL
              INT 21H               ;call DOS function
 
       print: 
              MOV DL,[SI]           ;Loads ascii of digit from DS:[SI]
              MOV AH,02H            ;To display value in DL
              INT 21H               ;call DOS function
              DEC SI                ;SI=SI-1
              CMP [SI],'&'          ;If reached end of result (stored in DS)
              JNZ print             ;jump to print if not reached to the end of result (stored in DS) 
     
              LEA DX,done           ;to print done string
              MOV AH,09H            ;To display character string
              INT 21H               ;call DOS function
    
              JMP calculator        ;Restarting the calculator 
 
  ENDP                              
