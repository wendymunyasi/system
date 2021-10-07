procedure ARQUTEPT
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "ARCINVPT.qbe"
EOFarciline = .f.
EOFarcinvs = .F.
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
   

_plength = 50.6

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
select arcinvup
set order to mkey
set filter to .not. empty(post_date)
SELECT arciline
GO TOP
IF .NOT. EOF()
select arcinvs
go top
if .not. eof()
   do arcinvup_rtn1
   ENDIF
   endif
   EOFarciline = .f.
EOFarcinvs = .F.
DO NEW_LINES
select arcinvup
set order to mkey
set filter to .not. empty(post_date)
SELECT arciline
GO TOP
IF .NOT. EOF()
select arcinvs
go top
if .not. eof()
   do arcinvup_rtn1
   ENDIF
   endif

    ENDPRINTJOB
    ELSE
    SET HEADINGS OFF
select arcinvup
set order to mkey
set filter to .not. empty(post_date)
SELECT arciline
GO TOP
IF .NOT. EOF()
select arcinvs
go top
if .not. eof()
   do arcinvup_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
close databases

procedure arcinvup_rtn1  
pdriver = ""
poff = ''
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = arcinvs->order_no
     
EOFarciline = .f.
    do fgcon_new_page_rtn
    SELECT arciline
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFarciline
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
   ? fgcoy->name  AT 3 STYLE "B"
     ? fgcoy->street  AT 3 STYLE "B"
  ? fgcoy->address AT 3
  ? "Tel. "+fgcoy->phone at 3
 ?  left(fgcoy->country,3)+": "+FGCOY->PIN AT 3,"VAT: "+FGCOY->VAT AT 25
 * * ? "-----------------------------------------------------------------------------------------------" at 1
   ?
      ? "PROFORMA INVOICE/QUOTATION"  AT 40 STYLE 2
  *   ?
     ? "Quo. No:" AT 3, ltrim(PDOC+arcinvs->ORDER_NO)  AT 13, "LPO No:" AT 30, arcinvs->LPO AT 40
     ? "Date   :" AT 3, arcinvs->dde_date AT 13,            "TIME  :" AT 30, arcinvs->DDE_TIME AT 40
   
  *  ? "Veh. No:" AT 3, arcinvs->REG AT 13 STYLE "B",          "KMS   :" at 30, ltrim(str(arcinvs->mileage)) at 40
  *  ?
      ?  "SHIFT NO. :"+arcinvs->shiftno+arcinvs->shiftid at 35 STYLE "B"
  ? arcinvs->CNAME AT 3 STYLE "B"
?  
  ? "NO." AT 1 STYLE "B", "QTY" AT 12 STYLE "B", "ITEM DESCRIPTION" AT 17 STYLE "B",  "%VAT" AT 44 STYLE "B",;
   " PRICE " AT 57 STYLE "B", " AMOUNT" AT 71 STYLE "B"
 ? "---" AT 1 STYLE "B", "---" AT 12 STYLE "B", "----------------" AT 17 STYLE "B",  "----" AT 44 STYLE "B",;
   "------" AT 57 STYLE "B", "-------" AT 71 STYLE "B"
ELSE  
      **
       ? "QUOTATION"  AT 40 STYLE 2
    ? "Quo. No:" AT 54, ltrim(PDOC+arcinvs->ORDER_NO)  AT 62
    ? "Date   :" AT 54, arcinvs->dde_date AT 62, LEFT(arcinvs->DDE_TIME,5) AT 73
   ? "LPO No :" AT 54, arcinvs->LPO AT 62
  *? "Veh. No:" AT 54, left(arcinvs->REG,12) AT 62 STYLE "B"
 
 **
      ?  "SHIFT NO. :"+arcinvs->shiftno+arcinvs->shiftid at 34 STYLE "B"
  ? arcinvs->CNAME AT 3 STYLE "B"
 *    ? LEFT(UPPER(arcinvs->CUSTOMER),20)  AT 3 STYLE "B"
    ? "-----------------------------------------------------------------------------" AT 1 STYLE "B"
  ? "NO." AT 1 STYLE "B", "QTY" AT 12 STYLE "B", "ITEM DESCRIPTION" AT 17 STYLE "B",  "%VAT" AT 44 STYLE "B",;
   " PRICE " AT 57 STYLE "B", " AMOUNT" AT 71 STYLE "B"
 ? "-----------------------------------------------------------------------------" AT 1 STYLE "B"
* ? "---" AT 1 STYLE "B", "---" AT 12 STYLE "B", "----------------" AT 17 STYLE "B",  "----" AT 44 STYLE "B",;
   "-------" AT 57 STYLE "B", "-------" AT 71 STYLE "B"

ENDIF
 
 
Procedure fgcon_detail_rtn
select arcinvup
seek arciline->order_no+dtos(arcinvs->order_date)+arciline->stock_no+arciline->DDE_TIME
if found()
select arciline
    PLINES = PLINES + 1
    PCNT = PCNT+1
   PAMT = PAMT + TOTAL
   PVAT = PVAT + TAX_AMT
   PGROSS = PGROSS+GROSS_AMT
   pdriver = ndriver
   poff = offname
   IF .NOT. QTY = 0
   PPRICE = ROUND(GROSS_AMT/QTY,2)
   ELSE
   PPRICE = 0
   ENDIF
   if gross_amt = total .and. typ = "00"
   pprice = list_price
   endif
   ? LTRIM(STR(PCNT)) PICTURE "99" AT 2, QTY PICTURE "999,999.99" at 5, LEFT(FGCOD->NAME,30) AT 17,;
   TAX_RATE PICTURE "99" AT 46,   PPRICE PICTURE "999,999.99" AT 53,;
   GROSS_AMT PICTURE "9999,999,999.99" AT 63
  select arcinvup
   replace print_date with date()
  endif
   select   arciline
   skip
   if eof()
  EOFarciline = .t.
   endif
procedure  fgcon_end_rtn   
  
? 
*
?  "SUB TOTAL" AT 50, PGROSS PICTURE "9999,999,999.99" AT 63
?"Login User/Cashr:" at 1, left(pluser,10) at 19, LEFT(POFF,15) AT 31, "VAT" AT 50, PVAT PICTURE "9999,999,999.99" AT 63

? "---------------" AT 63 STYLE "B"
? "NET AMOUNT" AT 50 STYLE "B", PAMT PICTURE "9999,999,999.99" AT 63 STYLE "B"
? "===============" AT 63  STYLE "B"
   
*?
? "APPROVED BY:______________________" AT 3


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
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "arcinvpt.qbe"
EOFarciline = .f.
EOFarcinvs = .F.
PRIVATE PLINES,PAMT
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:")  
PRMT = .T.
ELSE
PRMT = .F.  
ENDIF
PTYPE = ""  && NO TYPE YET
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
   
select fgprint
go top
IF EMPTY(PTYPE)
ptype = printer_1  && ptype
ENDIF
_plength = 50.6
IF PTYPE = "LX300" .OR. PTYPE = "LPT1" .OR. PTYPE = "LX300USB"
*_pdriver = "winspool,Epson LX-300+"
IF PTYPE = "LX300" .OR. PTYPE = "LPT1" 
SET PRINTER TO LPT1
ELSE
SET PRINTER TO
ENDIF
SET PRINTER ON
_padvance="LINEFEEDS"
_PPITCH = "PICA"
ELSE
_pcopies=1         && 3 copies
_peject="none"     && no page eject before or after
_plineno=0         && initialized to 0
_ppitch = "ELITE"
*_ppitch = "CONDENSED"
SET PRINTER ON
SET PRINTER TO
SET MARGIN TO 5
ENDIF
IF .NOT. PTYPE = "LX300" .AND. .NOT.  PTYPE = "LPT1" .and. .not.  PTYPE = "LX300USB"
PRINTJOB
?
?
SET HEADINGS OFF
select arcinvup
set order to mkey
set filter to .not. empty(post_date)
SELECT arciline
GO TOP
IF .NOT. EOF()
select arcinvs
go top
if .not. eof()
   do arcinvpt_rtn1
   ENDIF
   endif
   EOFarciline = .f.
EOFarcinvs = .F.
DO NEW_LINES
select arcinvup
set order to mkey
set filter to .not. empty(post_date)
SELECT arciline
GO TOP
IF .NOT. EOF()
select arcinvs
go top
if .not. eof()
   do arcinvpt_rtn1
   ENDIF
   endif
    ENDPRINTJOB
    ELSE
    SET HEADINGS OFF
select arcinvup
set order to mkey
set filter to .not. empty(post_date)
SELECT arciline
GO TOP
IF .NOT. EOF()
select arcinvs
go top
if .not. eof()
   do arcinvpt_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
close databases

procedure arcinvpt_rtn1  
pdriver = ""
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = arcinvs->order_no
     
EOFarciline = .f.
    do fgcon_new_page_rtn
    SELECT arciline
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFarciline
      endif
      do fgcon_end_rtn
    select arcinvsd
    go top
    if eof()
    append blank
    endif
    replace order_no with arcinvs->order_no
    replace order_date with arcinvs->order_date
    replace print_date with {}
    REPLACE PMOD WITH ""
    
       
    
procedure fgcon_new_page_rtn      
  *   ? "-----------------------------------------------------------------------------------------------" at 1 
   ? fgcoy->name  AT 15
   if fgcoy->stream = "Yes"
   ? fgcoy->street  AT 20 
   endif
  *   _ppitch="CONDENSED"
   ? fgcoy->address AT 1, "Tel. "+fgcoy->phone at 35
 ?  "PIN.: "+FGCOY->PIN AT 01,"VAT: "+FGCOY->VAT AT 20
    ? " QUOTATION "  AT 15,   "No. "+ltrim("C"+arcinvs->ORDER_NO)  AT 40
    ? " ========= "  AT 15 
     ? "DATE:" AT 3,  date() AT 10, time() AT 23
     ? "VEHICLE NO.: "+arcinvs->REG AT 3, "MILEAGE:" at 35, arcinvs->mileage at 45, ;
     "ORDER NO.: " AT 60, arcinvs->LPO AT 72
   ? "M/S:" AT 3, FRIGHTER->NAME AT 10, "A/C NO." AT 50, FRIGHTER->SOURCE+FRIGHTER->FTYP+;
  FRIGHTER->PMOD+FRIGHTER->FRIGHTER_N AT 60
   ? FRIGHTER->ADDRESS1 AT 3, "SHIP TO: "+FRIGTMES->NAME AT 36
    ? "NO." AT 1, "   QTY  " AT 06, "ITEM DESCRIPTION" AT 16,  "%VAT" AT 50,;
   " PRICE " AT 59, "AMNT(KSHS)" AT 69
    ? "---" AT 1, "--------" AT 06, "----------------" AT 16,  "----" AT 50,;
   "-----" AT 60, "---------" AT 69
Procedure fgcon_detail_rtn
   select arcinvup
   seek arciline->order_no+dtos(arcinvs->order_date)+arciline->stock_no+arciline->dde_time
  if found()
     select arciline
     PLINES = PLINES + 1
     PCNT = PCNT+1
     PAMT = PAMT + TOTAL
     PVAT = PVAT + TAX_AMT
     PGROSS = PGROSS+GROSS_AMT
     pdriver = ndriver
     IF .NOT. QTY = 0
        PPRICE = ROUND(GROSS_AMT/QTY,2)
     ELSE
        PPRICE = 0
     ENDIF
     if tax_amt = 0
        pprice = list_price
     endif
   ? LTRIM(STR(PCNT)) PICTURE "99" AT 2, QTY PICTURE "9,999.99" at 5, FGCOD->NAME AT 16,;
   TAX_RATE PICTURE "999.99" AT 48,   PPRICE PICTURE "99,999.99" AT 56,;
   GROSS_AMT PICTURE "9,999,999.99" AT 66
   select arcinvup
   replace print_date with date()
  endif
   select   arciline
   skip
   if eof()
  EOFarciline = .t.
   endif
procedure  fgcon_end_rtn   
  
? "--------------" AT 66
? "SUB TOTAL" AT 50, PGROSS PICTURE "999,999,999.99" AT 64
? "VAT" AT 50, PVAT PICTURE "999,999,999.99" AT 64
? "--------------" AT 66
? "TOTAL" AT 50, PAMT PICTURE "999,999,999.99" AT 64
? "==============" AT 66
*?
? "CUSTOMER" AT 47
? "Served by: " at 02, pdriver at 15,  "SIGNATURE ----------------------" AT 47
  
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