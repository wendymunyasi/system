procedure APOGRNSF
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "APOGRNST.qbe"
if apogrns->job_order = "00"
do  cont_rtn
endif
 *  close databases
procedure cont_rtn
EOFAPOGRLIN = .f.
EOFAPOGRNS = .F.
PRIVATE PLINES,PAMT,plhd,PDOC
PDOC = ""
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:")   .OR. VALIDDRIVE("X:")  
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
IF PTYPE = "LX300" .OR. PTYPE = "LPT1" 
SET PRINTER TO LPT1
ELSE
IF  PSPRINTER = "CHOOSE"
Newprinter=CHOOSEPRINTER()
ELSE
IF PSPRINTER = "DEFAULT"
SET PRINTER TO
ELSE
Newprinter=CHOOSEPRINTER()
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
SELECT APOGRLIN
GO TOP
IF .NOT. EOF()
select APOGRNS
go top
if .not. eof()
   do APOGRNST_rtn1
   ENDIF
   endif
 *  EOFAPOGRLIN = .f.
*EOFAPOGRNS = .F.

*DO NEW_LINES
*SELECT APOGRLIN
*set filter to GRN_NO = APOGRNSL->GRN_NO .and. .NOT. qty = 0  .and. .not. empty(post_date) .AND. TYP = "00"
*GO TOP
*IF .NOT. EOF()
*select APOGRNS
*go top
*if .not. eof()
 *  do APOGRNST_rtn1
 *  ENDIF
 *  endif
ENDPRINTJOB
ELSE
SET HEADINGS OFF
SELECT APOGRLIN
GO TOP
IF .NOT. EOF()
select APOGRNS
go top
if .not. eof()
   do APOGRNST_rtn1
   ENDIF
   endif
   ENDIF
   SET PRINTER OFF

CLOSE PRINTER
*close databases

procedure APOGRNST_rtn1  
pdriver = ""
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = APOGRNS->GRN_NO
     
EOFAPOGRLIN = .f.
    do fgcon_new_page_rtn
    SELECT APOGRLIN
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFAPOGRLIN
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
 * ?
  *?
   endif
   if .not. plhd
   ? fgcoy->name  AT 30 STYLE "B"
     ? fgcoy->street  AT 30  STYLE "B"
*  ? fgcoy->address AT 30
*  ?  "Tel. "+fgcoy->phone at 52
* ?  "PIN.: "+FGCOY->PIN AT 40,"VAT: "+FGCOY->VAT AT 59
  * ? "-----------------------------------------------------------------------------------------------" at 1
   ?
endif
      **
       ? "FUEL RECEIVED NOTE "  AT 40 STYLE "B"
     ? "GRN. No:" AT 47, ltrim(PDOC+APOGRNS->GRN_NO)  AT 59
    ? "Date/Time:" AT 47, APOGRNS->GRN_DATE AT 59, APOGRNS->ORDER_STAT AT 72
    ?  "Driver:" AT 47, APOGRNS->SHIPNAME AT 59
    ? "Veh/DN No:" AT 47, left(APOGRNS->REG,12) AT 59, APOGRNS->SERIALNO   AT 72
 
 **
      ?  "SHIFT NO. :"+APOGRNS->shiftno+APOGRNS->shiftid at 35 STYLE "B", "Inv No:" at 59, APOGRNS->inv_no at 68
 
  ? VENDOR->VSRCE+VENDOR->VTYP+VENDOR->VPMOD+VENDOR->VENDOR_N+" -- "+VENDOR->NAME AT 3 STYLE "B"

   ? "-------------------------------------------------------------------------------" AT 1 STYLE "B"
   ? "CODE" AT 1 STYLE "B", "TANK NAME" AT 6 STYLE "B", "DIP BEFORE" AT 21 STYLE "B",;
   "EXPECTED QTY" AT 32 STYLE "B", "EXPECTED DIP" AT 45 STYLE "B",;
    "ACTUAL DIP" AT 59 STYLE "B", "VARIANCE" AT 72 STYLE "B"
   ? "-------------------------------------------------------------------------------" AT 1 STYLE "B"
 
Procedure fgcon_detail_rtn
select APOGRLIN
if typ = "00"
    PLINES = PLINES + 1
    PCNT = PCNT+1
   PAMT = PAMT + TOTAL
   PVAT = PVAT + TAX_AMT
   PGROSS = PGROSS+GROSS_AMT
    IF .NOT. QTY = 0
   PPRICE = ROUND(GROSS_AMT/QTY,2)
   ELSE
   PPRICE = 0
   ENDIF
   ? STSTOS->STO AT 2, STSTOS->NAME AT 6, APOGRLIN->SUPPLY_TOT PICTURE "9999,999.99" AT 20,;
   APOGRLIN->RETURN_QTY PICTURE "999,999.99" AT 34, ;
   (APOGRLIN->RETURN_QTY + APOGRLIN->SUPPLY_TOT) PICTURE "999,999.99" AT 47,;
   (APOGRLIN->RETURN_AMT + apogrlin->volume) PICTURE "999,999.99" AT 59, APOGRLIN->LEVY_AMT PICTURE "999,999.99" AT 70
  endif
   select   APOGRLIN
   skip
   if eof()
  EOFAPOGRLIN = .t.
   endif
procedure  fgcon_end_rtn 
*? "--------------" AT 66
? "-------------------------------------------------------------------------------" AT 1
 
? "Attendant:" at 3, left(apogrns->offname,15) at 15,  "Offloading Officer Signature:________________" AT 35
?
* "==============" AT 66
?   "Login User:" at 3, pluser at 15,
?
? "Checked By:__________________" AT 3, "Driver Signature: _____________________" AT 35

  

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