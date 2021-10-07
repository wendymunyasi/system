procedure PCREPLSP
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "PCREPLSP.qbe"
EOFpcreplin = .f.
EOFpcrepls = .F.
PRIVATE PLINES,PAMT
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:")  
PRMT = .T.
ELSE
PRMT = .F.  
ENDIF
PSPRINTER = ""  && PRINTER SELECTION
PTYPE = ""  && PAPER SIZE


SELECT FGCOY
GO TOP
IF (PRMT .AND. AUTHNAME = "LX 300 USB") .OR. (.NOT. PRMT .AND. AGENAME = "LX 300 USB")
PTYPE = "LX300USB"
ENDIF
IF (PRMT .AND. AUTHNAME = "LX 300 LPT1") .OR. (.NOT. PRMT .AND. AGENAME = "LX 300 LPT1")
PTYPE = "LX300"
ENDIF
IF (PRMT .AND. AUTHNAME = "LASER DESKJET") .OR. (.NOT. PRMT .AND. AGENAME = "LASER DESKJET")
PTYPE = "LASER"
ENDIF
select  fgprint
go top
if  prmt  && romte printer in use
PSPRINTER = printer_2   && remote printer selection
else
PSPRINTER = printer_1   && server printer selection
endif
   

_plength = 50.6

IF PTYPE = "LX300" .OR. PTYPE = "LPT1" .OR. PTYPE = "LX300USB"
IF PTYPE = "LX300" .OR. PTYPE = "LPT1" 
SET PRINTER TO LPT1
ELSE
IF  PSPRINTER = "CHOOSE"
Newprinter=CHOOSEPRINTER()
ELSE
IF PSPRINTER = "DEFAULT"
SET PRINTER TO
ELSE
SET PRINTER TO  LPT1
ENDIF
ENDIF
ENDIF
SET PRINTER ON
_pspacing=1
_padvance="LINEFEEDS"
*if PTYPE = "LX300USB"
*_ppitch = "ELITE"
*else
_PPITCH = "PICA"
*endif
ELSE
_pcopies=1         && 3 copies
_peject="none"     && no page eject before or after
_plineno=0         && initialized to 0
_ppitch = "ELITE"
*_ppitch = "CONDENSED"
SET PRINTER ON
if PSPRINTER = "DEFAULT"
SET PRINTER TO
else
IF  PSPRINTER = "CHOOSE"
Newprinter=CHOOSEPRINTER()
ELSE
SET PRINTER TO LPT1
endif
ENDIF
SET MARGIN TO 5
ENDIF
IF .NOT. PTYPE = "LX300" .AND. .NOT.  PTYPE = "LPT1" .AND. .NOT. PTYPE = "LX300USB"
PRINTJOB
?
?
*?
SET HEADINGS OFF

SELECT pcreplin
GO TOP
IF .NOT. EOF()
select pcrepls
go top
if .not. eof()
   do PCREPLSP_rtn1
    endif
   ENDIF
   EOFpcreplin = .f.
EOFpcrepls = .F.
DO NEW_LINES
SELECT pcreplin
GO TOP
IF .NOT. EOF()
select pcrepls
go top
if .not. eof()
   do PCREPLSP_rtn1
    endif
   ENDIF
ENDPRINTJOB
else
SET HEADINGS OFF
SELECT pcreplin
GO TOP
IF .NOT. EOF()
select pcrepls
go top
if .not. eof()
   do PCREPLSP_rtn1
    endif
   ENDIF
   endif

SET PRINTER OFF
CLOSE PRINTER
CLOSE DATABASES
procedure PCREPLSP_rtn1  
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = pcrepls->order_no
EOFpcreplin = .f.
    do fgcon_new_page_rtn
    SELECT pcreplin
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFpcreplin
      endif
      do fgcon_end_rtn
 
    
procedure fgcon_new_page_rtn      
   ? fgcoy->name  AT 3
   ? fgcoy->street  AT 3
   ? fgcoy->address AT 3, "Tel. "+fgcoy->phone at 35
   ? "PIN  NO.:" AT 3, FGCOY->PIN AT 15
   ? "VAT. NO.:" AT 3, FGCOY->VAT AT 15
     ? "FLOAT REPLENISHMENT"  AT 35,   "No. "+pcrepls->ORDER_NO  AT 60
    ? "==================="  AT 35
   ? "PAYEE:" AT 3, VENDOR->NAME AT 18, "A/C NO: "+pcrepls->VSRCE+pcrepls->VTYP+;
   pcrepls->VPMOD+pcrepls->VENDOR_N AT 60
   ? "PAYMENT VOUCHER NO.: "+PCREPLS->SERIALNO AT 18
   ? 
   ? "         DATE:" AT 3,  pcrepls->ORDER_DATE AT 18, pcrepls->DDE_TIME AT 30, ;
    "CASH & BANK:" at 40, pcrepls->BNAME+"/REF: "+LPO AT 54
    ? 
   ? "NO." AT 1, "PAYMENT METHOD" AT 12, "REF" AT 42, "BANK  DATE" AT 50,;
     "TOTAL (KSHS.)" AT 65
       ? "---" AT 1, "--------------" AT 12, "---" AT 42, "----------" AT 50,;
     "-------------" AT 65

   
Procedure fgcon_detail_rtn
select pcreplin
    PLINES = PLINES + 1
    PCNT = PCNT+1
   PAMT = PAMT + TOTAL
   ? LTRIM(STR(PCNT)) PICTURE "99" AT 1, pcrepls->PAY_METHOD AT 12, pcrepls->LPO AT 42, pcrepls->RECDATE AT 50, ;
   TOTAL PICTURE "999,999,999.99" AT 65
   select   pcreplin
   skip
   if eof()
  EOFpcreplin = .t.
   endif
procedure  fgcon_end_rtn   
  ?
? "TOTAL (KSHS.)" AT 12, PAMT PICTURE "999,999,999.99" AT 30
?
       ? "SERVED BY:" AT 12, FGOFF->NAME AT 49
      
Procedure new_lines
if _plineno < 17
do lines_17
else
if _plineno < 18
do lines_16
else
if _plineno < 19
do lines_15
else
if _plineno < 20
do lines_14
else
if _plineno < 21
do lines_13
else
if _plineno < 22
do lines_12
else
if _plineno < 23
do lines_11
else
if _plineno < 24
do lines_10
else
if _plineno < 25
do lines_9
else
if _plineno < 26
do lines_8
else
if _plineno < 27
do lines_7
else
if _plineno < 28
do lines_6
else
if _plineno < 29
do lines_5
else
if _plineno < 30
do lines_4
else
if _plineno < 31
do lines_3
else
if _plineno < 32
do lines_2
else
if _plineno < 33
do lines_1
else
if _plineno < 34
do lines_1
else
if _plineno < 35
do lines_1
else
do lines_1
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif

PROCEDURE LINES_1
?

PROCEDURE LINES_2
?
?
PROCEDURE LINES_3
?
?
?
PROCEDURE LINES_4
?
?
?
?
PROCEDURE LINES_5
?
?
?
?
?
PROCEDURE LINES_6
?
?
?
?
?
?

PROCEDURE LINES_7
?
?
?
?
?
?
?
PROCEDURE LINES_8
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
*? && 9
*? && 10
*? && 11
*? && 12
*? && 13
PROCEDURE LINES_9
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
*? && 10
*? && 11
*? && 12
*? && 13

PROCEDURE LINES_10
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
*? && 11
*? && 12
*? && 13

PROCEDURE LINES_11
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
*? && 12
*? && 13

PROCEDURE LINES_12
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
*? && 13

PROCEDURE LINES_13
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13

PROCEDURE LINES_14
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13
? && 14
PROCEDURE LINES_15
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13
? && 14
? && 15

PROCEDURE LINES_16
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13
? && 14
? && 15
? && 16

PROCEDURE LINES_17
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13
? && 14
? && 15
? && 16
? && 17

PROCEDURE LINES_18
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13
? && 14
? && 15
? && 16
? && 17
? && 18

PROCEDURE LINES_19
? && 1
? && 2
? && 3
? && 4
? && 5
? && 6
? && 7
? && 8
? && 9
? && 10
? && 11
? && 12
? && 13
? && 14
? && 15
? && 16
? && 17
? && 18
? && 19