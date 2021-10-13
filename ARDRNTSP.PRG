procedure ardrntsp
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "ardrntsp.qbe"
EOFARDRNLN = .f.
EOFardrnts = .F.
PRIVATE PLINES,PAMT,plhd,PDOC
PDOC = ""
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:") .OR. VALIDDRIVE("X:")   
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
select ardrnupd
set order to mkey
set filter to .not. empty(post_date)
SELECT ARDRNLN
GO TOP
IF .NOT. EOF()
select ardrnts
go top
if .not. eof()
   do ardrntsp_rtn1
   ENDIF
   endif
   EOFARDRNLN = .f.
EOFardrnts = .F.
do  new_lines
select ardrnupd
set order to mkey
set filter to .not. empty(post_date)
SELECT ARDRNLN
GO TOP
IF .NOT. EOF()
select ardrnts
go top
if .not. eof()
   do ardrntsp_rtn1
   ENDIF
   endif
   ENDPRINTJOB
   ELSE
   SET HEADINGS OFF
select ardrnupd
set order to mkey
set filter to .not. empty(post_date)
SELECT ARDRNLN
GO TOP
IF .NOT. EOF()
select ardrnts
go top
if .not. eof()
   do ardrntsp_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
CLOSE DATABASES
procedure ardrntsp_rtn1  
      PAMT = 0
      PVAT = 0
      PNETT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = ardrnts->order_no
EOFARDRNLN = .f.
    do fgcon_new_page_rtn
    SELECT ARDRNLN
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFARDRNLN
      endif
      do fgcon_end_rtn
     
procedure fgcon_new_page_rtn      
  *   ? "-----------------------------------------------------------------------------------------------" at 1 
 
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
  ? fgcoy->address AT 30
  ?  "Tel. "+fgcoy->phone at 52
 ?  "PIN.: "+FGCOY->PIN AT 40,"VAT: "+FGCOY->VAT AT 60
  * ? "-----------------------------------------------------------------------------------------------" at 1
   ?
endif
    ? "CUST. DEBIT NOTE "  AT 35 STYLE "B"
    ? "Dr. Note No:" AT 50, ltrim(PDOC+ARDRNTS->ORDER_NO)  AT 64
    ? "Date/Time:  " AT 50, ARDRNTS->order_date AT 64, ARDRNTS->DDE_TIME AT 76
    ? "Ref. No:" AT 50, ARDRNTS->LPO AT 64
    ? "Pay Method:" AT 50, ARDRNTS->pay_method AT 64
    ? "SHIFT NO. :"+ARDRNTS->shiftno+ARDRNTS->shiftid at 35 STYLE "B", "Payment For:" AT 50, ARDRNTS->PAYTYPE AT 64
   *?
    *  
   *?
  ? "VENDOR: "+ ARDRNTS->VSRCE+ARDRNTS->VTYP+ARDRNTS->VPMOD+ARDRNTS->VENDOR_N+" -- "+ARDRNTS->VNAME AT 3
*
 
  ? FRIGHTER->SOURCE+FRIGHTER->FTYP+FRIGHTER->PMOD+FRIGHTER->FRIGHTER_N+" -- "+FRIGHTER->NAME AT 3 STYLE "B"

   ? "-------------------------------------------------------------------------------------------------------" AT 1
 *  ?
   ? "TOTAL RECEIPTS/INVOICES:" AT 10, ARDRNLn->REC_TOTAL PICTURE "9999,999,999.99" AT 45
*  ?
   ? "CHARGE/CAPITAL A/C:" AT 10, fgcods->NAME AT 45
  * ?
   ? "GROSS CHARGE            " AT 10, ARDRNLn->SVC_TOTAL PICTURE "9999,999,999.99"  AT 45
   *?
   ? "VAT RATE ON CHARGE (%): " AT 10, ARDRNLn->VAT_RATE  PICTURE "9999,999,999.99" AT 45
   *?
   ? "VAT TOTAL AMOUNT:       " AT 10, ARDRNLn->VAT_TOTAL  PICTURE "9999,999,999.99" AT 45
   ?
   ? "NETT AMOUNT:            " AT 10, ARDRNLn->TOTAL  PICTURE "9999,999,999.99" AT 45
 * ?
   ? "-----------------------------------------------------------------------------------------------------" AT 1
 
 
Procedure fgcon_detail_rtn
select ardrnupd
seek ARDRNLN->order_no+dtos(ardrnts->order_date)+ARDRNLN->stock_no+ARDRNLN->DDE_TIME
if found()
select ARDRNLN
    PLINES = PLINES + 1
    PCNT = PCNT+1
   PAMT = PAMT + REC_TOTAL
   PNETT = PNETT + TOTAL
*  ? LTRIM(STR(PCNT)) PICTURE "99" AT 2, ardrnts->LPO AT 16, REC_TOTAL PICTURE "9999,999,999.99" AT 31,;
   SVC_TOTAL PICTURE "99,999,999.99" AT 54,VAT_TOTAL PICTURE "9999,999,999.99" AT 65
    select ardrnupd
   replace print_date with date()
  endif
   select   ARDRNLN
   skip
   if eof()
  EOFARDRNLN = .t.
   endif
procedure  fgcon_end_rtn   
  
*?
*
? "Login User:" at 3, pluser at 15,  "Served by:" at 27, ARDRNTS->ANAME at 40


  
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