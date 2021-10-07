procedure FG12P
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "FG12P.qbe"
EOFxodrline = .f.
EOFxorders = .F.
PRIVATE PLINES,PAMT
IF VALIDDRIVE("Y:")  .OR. VALIDDRIVE("Z:")  .OR. VALIDDRIVE("W:")   .OR. VALIDDRIVE("X:")  
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
*plength = 50.6
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
select xodupd
set order to mkey
set filter to .not. empty(post_date)
SELECT xodrline
GO TOP
IF .NOT. EOF()
select xorders
go top
if .not. eof()
   do FG12P_rtn1
   ENDIF
   endif
   ENDPRINTJOB
   ELSE
   SET HEADINGS OFF
select xodupd
set order to mkey
set filter to .not. empty(post_date)
SELECT xodrline
GO TOP
IF .NOT. EOF()
select xorders
go top
if .not. eof()
   do FG12P_rtn1
   ENDIF
   endif
   ENDIF
SET PRINTER OFF
CLOSE PRINTER
 close databases
procedure FG12P_rtn1  
      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      porder = xorders->order_no
      pserved = ""
EOFxodrline = .f.
    do fgcon_new_page_rtn
   
    SELECT xodrline
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFxodrline
      endif
      do fgcon_end_rtn
    
    
procedure fgcon_new_page_rtn      
     ? fgcoy->street  AT 20 
     ? " STOCK TRANSFERS (FROM FORECOURT TO STORE)"  AT 15,   "No. "+xorders->ORDER_NO  AT 60
    ? " ======================================== "  AT 15 
   ? "FROM:" AT 3, FGCEN->NAME AT 10
    ? "DATE:" AT 3,  date() AT 10, time() AT 23
   ? "NO." AT 1, "   QTY  " AT 06, "ITEM DESCRIPTION" AT 16,  "RECEIVING CENTRE" AT 52
    ? "---" AT 1, "--------" AT 06, "----------------" AT 16, "-----------------" AT 52
Procedure fgcon_detail_rtn
select xodupd
seek xodrline->order_no+dtos(xorders->order_date)+xodrline->stock_no+xodrline->dde_time
if found()
select xodrline
    PLINES = PLINES + 1
    PSERVED = FGOFF->NAME
    PCNT = PCNT+1
    ? LTRIM(STR(PCNT)) PICTURE "99" AT 2, QTY PICTURE "9,999.99" at 5, fgcod->NAME AT 16,;
   FGCEN2->NAME AT 52
   select xodupd
   replace print_date with date()
  endif
   select   xodrline
   skip
   if eof()
  EOFxodrline = .t.
   endif
procedure  fgcon_end_rtn   
? "Served by: " at 05, pserved at 17
  
if _plineno < 17
do lines_12
else
if _plineno < 18
do lines_11
else
if _plineno < 19
do lines_10
else
if _plineno < 20
do lines_9
else
if _plineno < 21
do lines_8
else
if _plineno < 22
do lines_7
else
if _plineno < 23
do lines_6
else
if _plineno < 24
do lines_5
else
if _plineno < 25
do lines_4
else
if _plineno < 26
do lines_3
else
if _plineno < 27
do lines_2
else
if _plineno < 29
do lines_1
else
if _plineno < 29
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
? && 13?