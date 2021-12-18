;Source code for TXTCAL.100 by Mo Budlong, which is used in EXTRA.100 AND DATADO.100 by Carmen Paone [72677,42]
;This source code is not needed to load either program.
;-----------------------------------------------------------------------
;TXTCAL.ASM
;
;A routine to allow the Model 100/102 TEXT editor to be called
;from within BASIC. The routine returns to BASIC when the user
;exits from TEXT.
;When called from BASIC, the HL register must contain a varptr
;to a variable containing the name of the file to edit. The file
;must already exist which is achieved most simply by opening
;the file in append mode first.
;
;Syntax:
;10 FN$="FILE.DO"
;20 OPEN FN$ FOR APPEND AS 1: CLOSE 1
;30 CALL 62750,,VARPTR(FN$)
;40 PRINT "BACK IN BASIC HERE"
;-----------------------------------------------------------------------



;MODEL 100/102 ROUTINES IN THIS CODE ARE
POPALL:    EQU     014EDH      ;POPS ALL REGISTERS AND DOES A RETURN
PRSNAM:    EQU     04C0BH      ;PARSES A FILE NAME "FILE.DO" POINTED TO
                               ;BY HL INTO FC93H SYSTEM FILE NAME AREA.
                               ;ON ENTRY, THE LENGTH OF THE FILE NAME
                               ;MUST BE IN REGISTER E
FNDFIL     EQU     020AFH      ;SEARCH DIRECTORY FOR FILE NAMED AT FC93H
                               ;ON EXIT HL POINTS TO DIRECTORY OR Z
                               ;IS SET IF FILE NOT FOUND
BK2SK:     EQU     06C9CH      ;COPIES THE BASIC FUNCTION KEY TABLE
                               ;TO THE SYSTEM FUNCTION KEY TABLE.
                               ;USED TO RESTORE BASIC TABLE ON EXIT.
TXTENT     EQU     05F71H      ;AN ENTRY INTO THE TEXT EDITOR IN THE
                               ;MIDDLE OF THE INIT ROUTINES

;MODEL 100/102 ADDRESSES IN THIS CODE ARE
FILOFF:    EQU     0F6E7H      ;OFFSET FROM THE BEGINNING OF THE
                               ;TEXT FILE CURRENTLY BEING EDITED
                               ;SO THAT THE EDITOR SCREEN ROUTINE
                               ;KNOWS WHERE TO POSITION ITSELF.
STKTOP:    EQU     0FB9DH      ;HOLDS THE BEGINNING ADDRESS OF THE
                               ;STACK. TEXT CLEARS THE STACK
                               ;BY SETTING IT TO THE VALUE HELD IN
                               ;FB9DH. TO PRESERVE THE STACK THIS
                               ;MUST BE SAVED AND A NEW DUMMY VALUE
                               ;INSERTED.
FKCTRL:    EQU     0F650H      ;HOLDS 0 OR 80H. WHEN SET TO 0, F1-F8
                               ;RETURN THE STRING ASSOCIATED WITH THAT
                               ;KEY IN THE SYSTEM KEY TABLE.
                               ;WHEN SET TO 80 (WHICH THE EDITOR INIT
                               ;CODE DOES) F1-F8 SKIP THE FIRST
                               ;4 CHARACTERS OF THE STRING IN THE TABLE
                               ;AND RETURN WHATEVER IS LEFT. MUST BE
                               ;RESET TO 0 ON EXIT FROM THE EDITOR
LBENBL:    EQU     0FAADH      ;SET TO FFH TO ENABLE THE LABEL LINE.
                               ;MUST BE ENABLED ON EXIT.

          ORG      62750

START:    PUSH     H           ;SAVE ALL REGISTERS ON ENTRY
          PUSH     D           ;IN OPPOSITE ORDER TO POPALL
          PUSH     B           ;ROUTINE
          PUSH     PSW
          MOV      A,M         ;H POINTS TO STRING LENGTH IN VAR TABLE
          INX      H           ;MOVE UP TO POINTER TO STRING
          MOV      E,M         ;GRAB POINTER TO STRING INTO
          INX      H           ;DE
          MOV      D,M
          XCHG                 ;POINTER TO STRING INTO HL
          MOV      E,A         ;LENGTH INTO E
          CALL     PRSNAM      ;FILENAME INTO FC93H
          CALL     FNDFIL      ;LOCATE DIRECTORY ENTRY FOR FILE AT FC93H
          JZ       POPALL      ;QUIT IF NOT FOUND
          INX      H           ;MOVE TO POINTER TO FILE START
          MOV      E,M         ;START OF FILE INTO DE
          INX      H
          MOV      D,M
SAVESTACK:
          LHLD     STKTOP      ;SAVE THE STACK TOP
          PUSH     H           ;ON THE STACK
          LXI      H,0         ;OFFSET TO START OF
          SHLD     FILOFF      ;FILE TO EDIT IS SAVED HERE
NEWSTACK:
          DAD      SP          ;GET STACK POINTER
          SHLD     STKTOP      ;SAVE IT AT STACK TOP POINTER
          PUSH     D           ;FILE START ON STACK FOR TEXT
          MVI      A,1         ;A=1 STANDARD EDIT, A=0 BASIC EDIT
SETEXIT:
          LXI      H,EXIT      ;RETURN FROM THE EDITOR
          JMP      TXTENT      ;JUMP TO THE EDITOR
EXIT:
          POP      H           ;EXTRA PUSH LEFT BY THE EDITOR
          POP      H           ;RESTORE EDITOR STACK
          SHLD     STKTOP
          CALL     BK2SK       ;COPY BASIC F-KEY TABLE TO SYS TABLE
          XRA      A           ;TURN OFF SPECIAL F-KEY HANDLING
          STA      FKCTRL      ;SPECIAL F-KEY BYTE
          DCR      A           ;ENABLE LABEL KEYS WITH FFH
          STA      LBENBL      ;LABEL LINE ENABLE BYTE
          JMP      POPALL      ;AND EXIT
          END
