procedure apcrntst
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "apcrntst.qbe"
EOFAPOCRLIN  = .f.
EOFapcrnts = .F.
PRIVATE PLINES,PAMT,plhd,PDOC,pgrss
PDOC = ""
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:")  .OR. VALIDDRIVE("X:")  
PRMT = .T.
ELSE
PRMT = .F.  
ENDIF
PTYPE = ""  && NO TYPE YET
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
IF .NOT. PTYPE = "LX300" .AND. .NOT.  PTYPE = "LPT1" .and. .not.  PTYPE = "LX300USB"

PRINTJOB
?
?
SET HEADINGS OFF
select APOCRLUP
set order to mkey
set filter to .not. empty(post_date)
SELECT APOCRLIN
GO TOP
IF .NOT. EOF()
select apcrnts
go top
if .not. eof()
   do apcrntst_rtn1
   ENDIF
   endif
   EOFAPOCRLIN  = .f.
EOFapcrnts = .F.
DO NEW_LINES
select APOCRLUP
set order to mkey
set filter to .not. empty(post_date)
SELECT APOCRLIN
GO TOP
IF .NOT. EOF()
select apcrnts
go top
if .not. eof()
   do apcrntst_rtn1
   ENDIF
   endif
ENDPRINTJOB
ELSE
SET HEADINGS OFF
select APOCRLUP
set order to mkey
set filter to .not. empty(post_date)
SELECT APOCRLIN
GO TOP
IF .NOT. EOF()
select apcrnts
go top
if .not. eof()
   do apcrntst_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
close databases

procedure apcrntst_rtn1  
pdriver = ""
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      pgrss = 0
      porder = apcrnts->GRN_NO
     
EOFAPOCRLIN = .f.
    do fgcon_new_page_rtn
    SELECT APOCRLIN
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFAPOCRLIN
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
  ? fgcoy->address AT 30, "Tel. "+fgcoy->phone at 75
* ?
 ?  "PIN.: "+FGCOY->PIN AT 40,"VAT: "+FGCOY->VAT AT 59
  * ? "-----------------------------------------------------------------------------------------------" at 1
   ?
endif
      **
       ? "GOODS RETURNED ADVICE (REVERSAL)"  AT 40 STYLE 2
     ? "GRA(REV) No:" AT 47, ltrim(PDOC+APCRNTS->GRN_NO)  AT 59
    ? "GRA Date:" AT 47, APCRNTS->GRN_date AT 59
    ?  "Driver:" AT 47, APCRNTS->SHIPNAME AT 59
    ? "P.O. NO/DATE:" AT 47, APCRNTS->O_ORDER AT 63, APCRNTS->O_DATE   AT 70
 
 **
      ?  "SHIFT NO. :"+APCRNTS->shiftno+APCRNTS->shiftid at 35 STYLE "B", "Inv No:" at 59, APCRNTS->inv_no at 68
 
  ? VENDOR->VSRCE+VENDOR->VTYP+VENDOR->VPMOD+VENDOR->VENDOR_N+" -- "+VENDOR->NAME AT 3 STYLE "B"

   ? "-------------------------------------------------------------------------------" AT 1
   ? "NO." AT 1 STYLE "B", "   QTY  " AT 06 STYLE "B", "ITEM DESCRIPTION" AT 16 STYLE "B",  "%VAT" AT 46 STYLE "B",;
   " PRICE " AT 57 STYLE "B", "   AMOUNT" AT 69 STYLE "B"
     ? "-------------------------------------------------------------------------------" AT 1
  
Procedure fgcon_detail_rtn
select APOCRLUP
seek APOCRLIN->GRN_NO+dtos(apcrnts->GRN_DATE)+APOCRLIN->GRN_STK_NO+APOCRLIN->dde_time
if found()
select APOCRLIN
    PLINES = PLINES + 1
     pgrss = gross_amt
  if pvat = 0
  pgrss = total
  endif
    PCNT = PCNT+1
   PAMT = PAMT + TOTAL
   PVAT = PVAT + TAX_AMT
   PGROSS = PGROSS+pgrss
 
   ? LTRIM(STR(PCNT)) PICTURE "99" AT 1, QTY PICTURE "999999.99" at 4,;
   left(FGCOD->NAME,27) AT 15, TAX_RATE PICTURE "99.99" AT 45, ;
   LIST_PRICE PICTURE "9999999.99" AT 52, pgrss PICTURE "9999999,999.99" AT 63
   select APOCRLUP
   replace print_date with date()
  endif
   select   APOCRLIN
   skip
   if eof()
  EOFAPOCRLIN = .t.
   endif
procedure  fgcon_end_rtn 
  
*? "--------------" AT 66
?  "GROSS AMOUNT" AT 50 STYLE "B", PGROSS PICTURE "9999999,999.99" AT 63 STYLE "B"
? "Prepared By:" at 3, pluser at 15, "VAT" AT 50, PVAT PICTURE "9999999,999.99" AT 63
*?
?  "---------------" AT 65  STYLE "B"
? "Attendant:" at 3, left(APCRNTS->offname,15) at 15, "TOTAL AMOUNT" AT 50 STYLE "B", PAMT PICTURE "9999999,999.99" AT 63 STYLE "B"
? "===============" AT 65 STYLE "B"
*?   
*?
? "Authorised By:______________________" AT 3

  
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