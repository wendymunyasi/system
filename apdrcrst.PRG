procedure apdrcrst
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "apdrcrst.qbe"
EOFapdrcrln = .f.
EOFapdrcrs = .F.
PRIVATE PLINES,PAMT
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")   .OR. VALIDDRIVE("X:")   .OR. VALIDDRIVE("W:")  
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
select APDRCRUP
set order to mkey
set filter to .not. empty(post_date)
SELECT apdrcrln
GO TOP
IF .NOT. EOF()
select apdrcrs
go top
if .not. eof()
   do apdrcrst_rtn1
   ENDIF
   endif
   EOFapdrcrln = .f.
EOFapdrcrs = .F.
DO NEW_LINES
select APDRCRUP
set order to mkey
set filter to .not. empty(post_date)
SELECT apdrcrln
GO TOP
IF .NOT. EOF()
select apdrcrs
go top
if .not. eof()
   do apdrcrst_rtn1
   ENDIF
   endif
   ENDPRINTJOB
ELSE
SET HEADINGS OFF
select APDRCRUP
set order to mkey
set filter to .not. empty(post_date)
SELECT apdrcrln
GO TOP
IF .NOT. EOF()
select apdrcrs
go top
if .not. eof()
   do apdrcrst_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
close databases

procedure apdrcrst_rtn1  
pdriver = ""
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = apdrcrs->GRN_NO
     
EOFapdrcrln = .f.
    do fgcon_new_page_rtn
    SELECT apdrcrln
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFapdrcrln
      endif
      do fgcon_end_rtn
    select apdrcrsd
    go top
    if eof()
    append blank
    endif
    replace GRN_NO with apdrcrs->GRN_NO
    replace GRN_DATE with apdrcrs->GRN_DATE
    replace print_date with {}
    
       
procedure page_brk      
    ? "VENDOR DEBIT/CREDIT NOTE"  AT 15,   "No. "+apdrcrs->GRN_NO  AT 40
    ? "======================= "  AT 15 
   
procedure fgcon_new_page_rtn      
   ? fgcoy->name  AT 15
   if fgcoy->stream = "Yes"
 *  ? fgcoy->street  AT 20 
   ? FGCENS->NAME AT 20
   endif
   ? fgcoy->address AT 1, "Tel. "+fgcoy->phone at 35
    ? "VENDOR DEBIT/CREDIT NOTE"  AT 15,   "No. "+apdrcrs->GRN_NO  AT 40
    ? "======================= "  AT 15 
      ? "DATE:" AT 3,  date() AT 10, time() AT 23, "PAYMENT MODE: "+apdrcrs->PAY_METHOD AT 40
     ? "VEH. NO.: "+apdrcrs->REG AT 3, "D/NOTE:" at 30, apdrcrs->SERIALNO at 45, ;
     "INV. NO.: " AT 55, apdrcrs->INV_NO AT 66
  ? "M/S:" AT 3, VENDOR->NAME AT 10, "A/C NO." AT 50, VENDOR->VSRCE+VENDOR->VTYP+;
  VENDOR->VPMOD+VENDOR->VENDOR_N AT 60
   ? "NO." AT 1, "   QTY  " AT 06, "ITEM DESCRIPTION" AT 16,  "%VAT" AT 45,;
   " PRICE " AT 56, "AMNT(KSHS)" AT 69
   ? "-- " AT 1,  "--------" AT 06, "----------------" AT 16,  "-----" AT 45,;
   "------" AT 56, "---------------" AT 64
 * ? 
Procedure fgcon_detail_rtn
select APDRCRUP
seek apdrcrln->GRN_NO+dtos(apdrcrs->GRN_DATE)+apdrcrln->GRN_STK_NO+apdrcrln->dde_time
if found()
select apdrcrln
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
 * ?
   ? LTRIM(STR(PCNT)) PICTURE "99" AT 1, QTY PICTURE "999,999.99" at 4,;
   left(FGCOD->NAME,27) AT 15, TAX_RATE PICTURE "99.99" AT 45, ;
   PPRICE PICTURE "999,999.99" AT 52, GROSS_AMT PICTURE "999,999,999.99" AT 64
   
* IF _PLINENO = 0
*   DO page_brk
 
 *  ENDIF
   select APDRCRUP
   replace print_date with date()
  endif
   select   apdrcrln
   skip
   if eof()
  EOFapdrcrln = .t.
   endif
procedure  fgcon_end_rtn 
  
? "--------------" AT 64
? "SUB TOTAL" AT 50, PGROSS PICTURE "999,999,999.99" AT 64
? "VAT" AT 50, PVAT PICTURE "999,999,999.99" AT 64
? "--------------" AT 64
? "TOTAL" AT 50, PAMT PICTURE "999,999,999.99" AT 64
? "==============" AT 64
*?
? "Served by: " at 02,   "SIGNATURE ----------------------" AT 20

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