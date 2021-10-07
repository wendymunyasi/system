procedure artrecsp
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "artrecsp.qbe"
EOFartrecln = .f.
EOFartrecs = .F.
PRIVATE PLINES,PAMT,plhd,PDOC
PDOC = ""
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:")  .OR. VALIDDRIVE("X:")  
PRMT = .T.
ELSE
PRMT = .F.  
ENDIF
PSPRINTER = ""  && PRINTER SELECTION
PTYPE = ""  && PAPER SIZE


SELECT FGCOY
GO TOP
if purtname ="Yes"
plhd = .t.
else
plhd = .f.
endif
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
   

*_plength = 50.6

IF PTYPE = "LX300" .OR. PTYPE = "LPT1" .OR. PTYPE = "LX300USB"
IF (PTYPE = "LX300" .OR. PTYPE = "LPT1") .AND. .NOT. PSPRINTER = "CHOOSE"
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
Newprinter=CHOOSEPRINTER()
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
select artrecup
set order to mkey
set filter to .not. empty(post_date)
SELECT artrecln
GO TOP
IF .NOT. EOF()
select artrecs
go top
if .not. eof()
   do artrecsp_rtn1
   ENDIF
   endif
   EOFartrecln = .f.
EOFartrecs = .F.
do new_lines
select artrecup
set order to mkey
set filter to .not. empty(post_date)
SELECT artrecln
GO TOP
IF .NOT. EOF()
select artrecs
go top
if .not. eof()
   do artrecsp_rtn1
   ENDIF
   endif
 ENDPRINTJOB
 ELSE
 SET HEADINGS OFF
select artrecup
set order to mkey
set filter to .not. empty(post_date)
SELECT artrecln
GO TOP
IF .NOT. EOF()
select artrecs
go top
if .not. eof()
   do artrecsp_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
CLOSE DATABASES
procedure artrecsp_rtn1  
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = artrecs->order_no
EOFartrecln = .f.
    do fgcon_new_page_rtn
    SELECT artrecln
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFartrecln
      endif
      do fgcon_end_rtn
        
    
procedure fgcon_new_page_rtn      
 
  IF PLHD
  ? && new
   ? fgcoy->street  AT 30  STYLE "B"
   ?
   ?
   ?
   ?
   ?
   ?
   *?
   *?
   endif
   if .not. plhd
   ? fgcoy->name at  3 STYLE "B"
      ? fgcoy->street  AT 3  STYLE "B"
  ? fgcoy->address AT 3
  ? "Tel. "+fgcoy->phone at 10
  
*?  "PIN.: "+FGCOY->PIN AT 3,"VAT: "+FGCOY->VAT AT 25
  * ? "-----------------------------------------------------------------------------------------------" at 1
   ?
endif
    ? " RECEIPT "  AT 40 STYLE 2
    ? "Receipt No :" AT 50, ltrim(PDOC+artrecs->ORDER_NO)  AT 64
    ? "Date/Time  :" AT 50, artrecs->order_date AT 64, LEFT(artrecs->dde_time,5) AT 76
    ?  "Pay Method:" AT 50, artrecs->pay_method AT 64
    ? "Payment For:" AT 50, artrecs->paytype AT 64
      ?  "SHIFT NO. :"+artrecs->shiftno+artrecs->shiftid at 35 STYLE "B"
 
  ? FRIGHTER->SOURCE+FRIGHTER->FTYP+FRIGHTER->PMOD+FRIGHTER->FRIGHTER_N+" -- "+FRIGHTER->NAME AT 3 STYLE "B"

*   ? "-------------------------------------------------------------------------------------------------------" AT 1
   ? "NO." AT 1 STYLE "B", "REFERENCE" AT 16 STYLE "B", "   AMOUNT" AT 69 STYLE "B"
*     ? "-----------------------------------------------------------------------------------------------------" AT 1
 
Procedure fgcon_detail_rtn
select artrecup
seek artrecln->order_no+dtos(artrecS->order_date)+artrecln->stock_no+artrecln->dde_time
if found()
select artrecln
    PLINES = PLINES + 1
    PCNT = PCNT+1
   PAMT = PAMT + TOTAL
   ? LTRIM(STR(PCNT)) PICTURE "99" AT 2, REF AT 16, TOTAL PICTURE "9999,999,999.99" AT 63
    select artrecup
   replace print_date with date()
  endif
   select   artrecln
   skip
   if eof()
  EOFartrecln = .t.
   endif
procedure  fgcon_end_rtn   
  
  
*? "--------------" AT 66
*
*
*? "--------------" AT 66
? "TOTAL AMOUNT" AT 50 STYLE "B", PAMT PICTURE "9999,999,999.99" AT 63 STYLE "B"
* "==============" AT 66
*
? "Login User:" at 3, pluser at 15,  "Served by:" at 27, artrecS->ANAME at 40
*
? "THANK YOU" AT 3

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