procedure APOGRNSR
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "APOGRNSR.qbe"
EOFFGNFPUR = .f.
EOFFGNFPUR = .F.
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
*_ppitch = 'condensed'
*else
_PPITCH = 'condensed'
*endif
ELSE
_pcopies=1         && 3 copies
_peject="none"     && no page eject before or after
_plineno=0         && initialized to 0
_ppitch = 'condensed'
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
SET MARGIN TO 3
ENDIF
IF .NOT. PTYPE = "LX300" .AND. .NOT.  PTYPE = "LPT1" .AND. .NOT. PTYPE = "LX300USB"
PRINTJOB
?
?
*?
SET HEADINGS OFF
SELECT FGNFPUR
GO TOP
IF .NOT. EOF()
   do APOGRNSR_rtn1
   ENDIF
   EOFFGNFPUR = .f.
EOFFGNFPUR = .F.

DO NEW_LINES
SELECT FGNFPUR
GO TOP
IF .NOT. EOF()
   do APOGRNSR_rtn1
   endif
ENDPRINTJOB
ELSE
SET HEADINGS OFF
SELECT FGNFPUR
GO TOP
IF .NOT. EOF()
   do APOGRNSR_rtn1
    endif
   ENDIF
   SET PRINTER OFF

CLOSE PRINTER
*close databases

procedure APOGRNSR_rtn1  
pdriver = ""
       PAMT = 0
      PVAT = 0
      _ppitch = 'condensed'
      PGROSS = 0
      pnonvat = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = fgnfpur->order_NO
     
     
EOFFGNFPUR = .f.
    do fgcon_new_page_rtn
    SELECT FGNFPUR
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFFGNFPUR
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
     ? fgcoy->street  AT 3  STYLE "B"
*  ? fgcoy->address AT 3
*  ? "Tel. "+fgcoy->phone at 10
  
* ?  "PIN.: "+FGCOY->PIN AT 3,"VAT: "+FGCOY->VAT AT 25
  * ? "-----------------------------------------------------------------------------------------------" at 1
*   ?
endif
         ? "DUPLICATE PURCHASE ORDER "  AT 33 STYLE 2
    ? "P.O. No:" AT 40, ltrim(PDOC+FGNFPUR->ORDER_NO)  AT 52
    ? "Date/Time:" AT 40, FGNFPUR->ORDER_DATE AT 52, FGNFPUR->DDE_TIME AT 67
    ?  "Driver:" AT 40, FGNFPUR->DRIVER AT 52
    ? "Veh/DN No:" AT 40, left(FGNFPUR->REG,12) AT 52, FGNFPUR->SERIALNO   AT 67
    ? "Pay Mode/Ref:" AT 40, FGNFPUR->pay_method AT 54, FGNFPUR->lpo   AT 66
 **
      ?  "SHIFT NO. :"+FGNFPUR->shift_no+FGNFPUR->shift_id at 28 STYLE "B", "Inv No:" at 52 STYLE "B",;
      FGNFPUR->inv_no at 61  STYLE "B"
 
  ? VENDOR->VSRCE+VENDOR->VTYP+VENDOR->VPMOD+VENDOR->VENDOR_N+" -- "+VENDOR->NAME AT 3 STYLE "B"

   ? "   Quantity" AT 03 STYLE "B", "Item Description" AT 15 STYLE "B",  "Unit Price" AT 47 STYLE "B",;
   'VAT%' at 60 style 'B', "   Gross Amount" AT 67 STYLE "B", "  VAT Amount" AT 87  STYLE "B",;
   '  Non-VAT' style 'b' at 104, 'Total Amount' AT 120 STYLE 'B'  
    ? "-----------" AT 03 STYLE "B", "----------------" AT 15 STYLE "B",  "----------" AT 47 STYLE "B",;
   '----' at 60 style 'B', "---------------" AT 67 STYLE "B", "------------" AT 87  STYLE "B",;
   '---------' style 'b' at 104, '------------' AT 120 STYLE 'B'

Procedure fgcon_detail_rtn
select FGNFPUR
    PLINES = PLINES + 1
    PCNT = PCNT+1
   PAMT = PAMT + TOTAL
   PVAT = PVAT + TAX_AMT
   PGROSS = PGROSS+GROSS_AMT
   pnonvat = pnonvat + NEW_BAL
     ? QTY PICTURE "9999,999.99" at 3,;
   left(fgCOD->name,30) AT 15, LIST_PRICE PICTURE "9999,999.99" AT 46, tax_rate picture '99' at 62, ;
   gross_amt PICTURE "9999,999,999.99" AT 67, TAX_AMT PICTURE "99999,999.99" AT 87, new_bal picture '99,999,999.99'at 100,;
     total PICTURE "9999,999,999.99" AT 117

   select   FGNFPUR
   skip
   if eof()
  EOFFGNFPUR = .t.
   endif
procedure  fgcon_end_rtn 
   ? "-----------" AT 03 STYLE "B", "----------------" AT 15 STYLE "B",  "----------" AT 47 STYLE "B",;
   '----' at 60 style 'B', "---------------" AT 67 STYLE "B", "------------" AT 87  STYLE "B",;
   '---------' style 'b' at 104, '------------' AT 120 STYLE 'B'
?  "Total Gross Amount" AT 90 STYLE "B", PGROSS PICTURE "9999,999,999.99" AT 117 STYLE "B"
?  "Total Tax Amount" AT 90 STYLE "B", PVAT PICTURE "9999,999,999.99" AT 117 STYLE "B"
?  "Total Non Tax Amount" AT 90 STYLE "B", Pnonvat PICTURE "9999,999,999.99" AT 117 STYLE "B"
*?
?  "---------------" AT 117 STYLE "B"
?  "Total Amount" AT 90 STYLE "B", PAMT PICTURE "9999,999,999.99" AT 117 STYLE "B"
? "===============" AT 117 STYLE "B"

  

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