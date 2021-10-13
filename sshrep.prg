procedure sshrep
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
Set view to "sshrep.qbe"
EOFst15f = .f.
PRIVATE PLINES,PAMT,plhd,pdoc,psname
psname = shifts->name
PSPRINTER = ""  && PRINTER SELECTION
PTYPE = ""  && PAPER SIZE

select st15f
SET FILTER TO .NOT. EMPTY(SHIFT_POST)
go top
if .not.  eof()  && no errors
wait 'Check Errors in Shift!'
quit
endif
SELECT FGCOY
GO TOP
if purtname ="Yes"
plhd = .t.
else
plhd = .f.
endif
_porientation="LANDSCAPE"

PPL = _plength && DEFAULT PAGE LENGTH
_pageno=1
_plineno=0 && set to zero
_padvance="LINEFEEDS"

_pcopies=1         && 3 copies
_peject="none"     && no page eject before or after
_ppitch = 'CONDENSED'

*SET PRINTER TO
Newprinter=CHOOSEPRINTER()

SET PRINTER ON
PRINTJOB
?
?
*?
SET HEADINGS OFF

SELECT st15f
set filter to
go top
PSHDATE = SHIFT_DATE
PSHID = SHIFT_ID
PSHNO = SHIFT_NO
if .not. eof()
   do sshrep_rtn1
   endif 
    ENDPRINTJOB
    
SET PRINTER OFF
CLOSE PRINTER
 close databases
 do sshrepp.prg with pluser, _pageno
 close databases
procedure sshrep_rtn1  
PML = 0
PEL = 0
PVL = 0
PTL = 0
PRL = 0
PSL = 0
PSA = 0
PMA = 0
PRA = 0
PES =0
PVA = 0
pos=0
pqr=0
pas=0
pss=0
pcs=0
ppd=0
psg=0
** Totals for stock calculations
poss=0
pqrs=0
pass=0
psss=0
pcss=0
ppds=0
psgs=0
pmgs=0
**
pitems =0
pmg=0
PAGOQ = 0
PAGOA = 0
PPMSQ = 0
PPMSA = 0
PRMSQ = 0
PRMSA = 0
PIKQ = 0
PIKA = 0
PTQ = 0
PTA = 0
pprd=''
PPNAME =''
pfirst =.t.

      PAMT = 0
      PVAT = 0
      PGROSS = 0
      PLINES = 0
      _plineno = 0
      _pageno=1
      PCNT = 0
      pserved = ""
      PSREP = ""
      poff =""
EOFst15f = .f.
SELECT st15f
    set order to MKEY
    SET FILTER TO TYP='00' 
    GO TOP
    if .not. EOF()
    do mtr_mvnt_new_header 
           do
         do fgcon_detail_rtn
         until  EOFst15f
              do fgcon_end_rtn
            do sale_mtr_summ
   eofshiftcla = .f.
   select shiftcla
   SET FILTER TO TYP='00' 
   set order to skey
   go top
   if .not. eof()
    do stkcal_new_header
   do
      do stkcal_detail_rtn
      until eofshiftcla
   do stkcal_end_rtn
   ENDIF
   ENDIF
   
   eofst15f = .f.
   ptsales = 0
   ptcrsales = 0
   ptcsales = 0
   prtsales = 0
   prtcrsales = 0
   prtcsales = 0
      PSALES = 0
    PFCJC = 0
    PINV = 0
    PPOS = 0
    PBBK =0
    PTCRS = 0
    PRECS = 0
    PPYMTS =0
    PCHQS = 0
    PEXPCAS = 0
    PACAS = 0
    PCASOU = 0
    PRSALES = 0
    PRFCJC = 0
    PRINV = 0
    PRPOS = 0
    PRBBK =0
    PRTCRS = 0
    PRRECS = 0
    PRPYMTS =0
    PRCHQS = 0
    PREXPCAS = 0
    PRACAS = 0
    PRCASOU = 0
    
    eofscashrec = .f.
    select scashrec
    set order to off
    set relation to off into fgoffs
    go top
    if .not. eof()
    if _plineno > PPL - 7
    do print_page
    endif
       do cashier_hd_rtn
      do
        do cashier_recons_rtn
      until eofscashrec
   *   ?
      ? 'TOTAL' at 3 STYLE 'B',  prsales picture '99999,999.99' at 20 STYLE 'B',;
      prfcjc picture '99999,999.99' at 34 STYLE 'B',prinv  picture '99999,999.99' at 48 STYLE 'B',;
      prpos  picture '99999,999.99' at 63 STYLE 'B', prbbk picture '99999,999.99'at 77 STYLE 'B',;
prtcrs picture '99999,999.99'at 91 STYLE 'B', prrecs picture '99999,999.99' at 105 STYLE 'B',;
prpymts picture '99999,999.99' at 119 STYLE 'B',prchqs picture '99999,999.99' at 133 STYLE 'B',;
prexpcas picture '99999,999.99' at 147 STYLE 'B', pracas picture '99999,999.99' at 161 STYLE 'B',;
prcasou picture '99999999.99' at 175 STYLE 'B'
ENDIF
?
  if _plineno > PPL - 7
    do print_page
    else
    ? 'Page No.: '+STR(_PAGENO) AT 160 STYLE 'B'
    endif
 
procedure cashier_recons_rtn
   psales = psales + exp_sales - fc_sales
   pfcjc = pfcjc + fc_sales
   pinv = pinv + non_cash
   ppos = ppos + coyvisa
   pbbk = pbbk + genvisa+bbkvisa
   ptcrs = ptcrs + non_cash + coyvisa+ genvisa+bbkvisa
   precs = precs + recepts
   ppymts = ppymts + paymnts + purch
   pchqs = pchqs + chqs + dbcredits
   pexpcas = pexpcas+exp_sales-fc_sales+fc_sales+recepts-(paymnts+purch)-non_cash-(coyvisa+genvisa+bbkvisa)-(chqs + dbcredits)
   pacas = pacas + a_cash
   pcasou = pcasou+a_cash-(exp_sales-fc_sales+fc_sales+recepts-(paymnts+purch)-non_cash-(coyvisa+genvisa+bbkvisa)-(chqs+dbcredits))
   pcname = fgoffs->name
   prsales = prsales + exp_sales - fc_sales
   prfcjc = prfcjc + fc_sales
   prinv = prinv + non_cash
   prpos = prpos + coyvisa
   prbbk = prbbk + genvisa+bbkvisa
   prtcrs = prtcrs + non_cash + coyvisa+ genvisa+bbkvisa
   prrecs = prrecs + recepts
   prpymts = prpymts + paymnts + purch
   prchqs = prchqs + chqs + dbcredits
   prexpcas = prexpcas+exp_sales-fc_sales+fc_sales+recepts-(paymnts+purch)-non_cash-(coyvisa+genvisa+bbkvisa)-(chqs + dbcredits)
   pracas = pracas + a_cash
   prcasou = prcasou+a_cash-(exp_sales-fc_sales+fc_sales+recepts-(paymnts+purch)-non_cash-(coyvisa+genvisa+bbkvisa)-(chqs+dbcredits))
  
   poff = off
   select scashrec
   skip
   if .not. off = poff
   do cashier_print_rtn
    PSALES = 0
    PFCJC = 0
    PINV = 0
    PPOS = 0
    PBBK =0
    PTCRS = 0
    PRECS = 0
    PPYMTS =0
    PCHQS = 0
    PEXPCAS = 0
    PACAS = 0
    PCASOU = 0
    endif
    if eof()
    eofscashrec = .t.
    endif
procedure cashier_print_rtn
? left(pcname,15) at 3, psales picture '99999,999.99' at 20,pfcjc picture '99999,999.99' at 34,;
pinv  picture '99999,999.99' at 48, ppos  picture '99999,999.99' at 63, pbbk picture '99999,999.99'at 77,;
ptcrs picture '99999,999.99'at 91, precs picture '99999,999.99' at 105, ppymts picture '99999,999.99' at 119,;
pchqs picture '99999,999.99' at 133, pexpcas picture '99999,999.99' at 147, pacas picture '99999,999.99' at 161,;
pcasou picture '99999999.99' at 175
if _plineno > PPL-7
    do print_page
    endif
procedure cashier_hd_rtn
 if _plineno > PPL-10
    do print_page
    endif
? "SECTION C. CASHIERS' SUMMARY RECONCILIATION SHEET"  AT 3 STYLE 'B'
? "-------------------------------------------------"  AT 3 STYLE 'B'
 ? 'CASHIER' AT 3 STYLE 'B', 'SALES' AT 28 STYLE 'B',  'FC JCADS' AT 39 STYLE 'B',;
 'INVOICES' AT 53 STYLE 'B', 'POS CARD' AT 67 STYLE 'B','BBK/VISA' AT 81 STYLE 'B',;
 'TOTAL CREDITS' AT 90 STYLE 'B', 'RECEIPTS' AT 109 STYLE 'B', 'PAYMENTS' AT 123 STYLE 'B', ;
  'CHQS/CRDRNTS' AT 133 STYLE 'B', 'EXPECTED CASH' AT 147 STYLE 'B',;
  'ACTUAL CASH' AT 161 STYLE 'B', 'OVER(UNDER)' AT 175 STYLE 'B'
   ? '<----->' AT 3 STYLE 'B', '<--->' AT 28 STYLE 'B',  '<------>' AT 39 STYLE 'B',;
 '<------>' AT 53 STYLE 'B', '<------>' AT 67 STYLE 'B','<------>' AT 81 STYLE 'B',;
 '<----------->' AT 90 STYLE 'B', '<------>' AT 109 STYLE 'B', '<------>' AT 123 STYLE 'B', ;
  '<---------->' AT 133 STYLE 'B', '<----------->' AT 147 STYLE 'B',;
  '<--------->' AT 161 STYLE 'B', '<--------->' AT 175 STYLE 'B'



procedure sale_mtr_summ

    if _plineno > PPL - 10
do print_page
endif
    ? "FUEL METERS SALES SUMMARY"  AT 3 STYLE 'B'
    ? "-------------------------"  AT 3 STYLE 'B'
    ? 'PRODUCT DESCRIPTION' AT 3 STYLE 'B', 'SALES QUANTITY' AT 48 STYLE 'B', 'EXPECTED SALES AMOUNT' AT 80 STYLE 'B'
    ? '<----------------->' AT 3 STYLE 'B', '<------------>' AT 48 STYLE 'B', '<------------------->' AT 80 STYLE 'B'
    ? 'Unleaded Premium' AT 3, PPMSQ PICTURE '999,999,999.99' AT 48, PPMSA PICTURE'99,999,999,999,999.99' AT 80
    ? 'Low Sulphur Diesel' AT 3, PAGOQ PICTURE '999,999,999.99' AT 48, PAGOA  PICTURE '99,999,999,999,999.99' AT 80
    ? 'Unleaded Regular' AT 3, PRMSQ PICTURE '999,999,999.99' AT 48, PRMSA  PICTURE '99,999,999,999,999.99' AT 80
    ? 'Kerosene' AT 3, PIKQ PICTURE '999,999,999.99' AT 48, PIKA  PICTURE     '99,999,999,999,999.99' AT 80
    ? 'TOTAL' AT 3 STYLE 'B', PTQ PICTURE '999,999,999.99' AT 48 STYLE 'B',;
    PTA  PICTURE '99,999,999,999,999.99' AT 80 STYLE 'B'
    if _plineno > PPL - 7
do print_page
endif
procedure mtr_mvnt_new_header      

      if _plineno > PPL - 10
do print_page
endif
   ?'User: '+pluser at 3 STYLE 'I', DATE() AT 25 STYLE 'I', TIME() AT 35 STYLE 'I', fgcoy->name  AT 60 STYLE "B"
     ? fgcoy->street  AT 60 STYLE "B"
 *   ?
    ?  'SHIFT REPORTS FOR: ' AT 43  STYLE 'B','SHIFT DATE: ' AT 65 STYLE 'B', PSHDATE AT 80 STYLE 'B',;
 "SHIFT NO./ID : "+PSHNO+'/'+PSHID+' - '+ psname at 95 STYLE "B"
   ? '========================================================================================' AT 43 STYLE 'B'
 ? "SECTION A. FUEL METER MOVEMENTS"  AT 3 STYLE 'B'
 ? "-------------------------------"  AT 3 STYLE 'B'
 ? 'PUM' AT 3 STYLE 'B', 'MANUAL METER' AT 07 STYLE 'B', 'MAN LITERS' AT 20 STYLE 'B','ELEC.  METER' AT 31 STYLE 'B',;
 'ELEC LTRS' AT 45 STYLE 'B','VAR(LTRS)' AT 56 STYLE 'B','THROUGPUT' AT 66 STYLE 'B','RTT(LTRS)' AT 76 STYLE 'B',;
 'SOLD LTRS' AT 87 STYLE 'B', 'PUM PRICE' AT 98 STYLE 'B', 'SOLD QTY AMT' AT 109 STYLE 'B',;
 'SHS   METER' AT 123 STYLE 'B', 'SHS MTR AMOUNT' AT 136 STYLE 'B', 'RTT SHS AMT' AT 153 STYLE 'B',;
 'EXPECTED SALES' AT 165 STYLE 'B', '  VAR(AMT)' AT 181 STYLE 'B'
 ? '<->' AT 3 STYLE 'B', '<---------->' AT 07 STYLE 'B', '<-------->' AT 20 STYLE 'B','<---------->' AT 31 STYLE 'B',;
 '<------->' AT 45 STYLE 'B','<------->' AT 56 STYLE 'B','<------->' AT 66 STYLE 'B','<------->' AT 76 STYLE 'B',;
 '<------->' AT 87 STYLE 'B', '<------->' AT 98 STYLE 'B', '<---------->' AT 109 STYLE 'B',;
 '<---------->' AT 123 STYLE 'B', '<------------>' AT 136 STYLE 'B', '<--------->' AT 153 STYLE 'B',;
 '<------------>' AT 165 STYLE 'B', '<-------->' AT 181 STYLE 'B'
      if _plineno > PPL - 7
do print_page
endif

Procedure print_page
?
? 'Page No.: '+STR(_PAGENO) AT 160 STYLE 'B'
EJECT PAGE
   ?  'SHIFT REPORTS FOR: ' AT 43  STYLE 'B','SHIFT DATE: ' AT 65 STYLE 'B', PSHDATE AT 80 STYLE 'B',;
 "SHIFT NO./ID : "+PSHNO+'/'+PSHID+' - '+ psname at 95 STYLE "B"
   ? '========================================================================================' AT 43 STYLE 'B'
*   ?
Procedure fgcon_detail_rtn
    if _plineno > PPL - 7
do print_page
endif
? STO AT 3, CL_MM_QTY PICTURE '999999999.99' AT 08,MM_SOLD PICTURE '99,999.99' AT 21,;
CL_M_Q PICTURE '9999999999.999' AT 30, TOTAL_QTY PICTURE '99,999.99' AT 45,;
MM_QTY_VAR PICTURE '999,999.99' AT 55,(SOLD_QTY + TEST_QTY) PICTURE '99,999.99' AT 66,;
TEST_QTY PICTURE '99,999.9' AT 77, SOLD_QTY PICTURE '99,999.99' AT 87, ;
SALE_PRICE PICTURE '99,999.99' AT 98, SOLD_QTY * SALE_PRICE PICTURE '999,999,999.99' AT 107, CL_M_A PICTURE '9999999999.999' AT 122,;
(meter_amt-TEST_AMT) PICTURE '999,999,999.99' AT 136,TEST_AMT PICTURE '999,999,999.99' AT 150,;
EXP_SALES PICTURE '999,999,999.99' AT 165, (METER_AMT-TEST_AMT - SOLD_QTY*SALE_PRICE) PICTURE '99999,999.99' AT 179
IF .NOT. (EMPTY(DATE_AMEND) .OR.  EMPTY(USER_AMEND) .OR.  EMPTY(TIME_AMEND))
? 'OP M' AT 3 STYLE 'B', OP_MM_QTY PICTURE '999999999.99' AT 08 STYLE 'B', OP_M_Q PICTURE '9999999999.999' AT 30 STYLE 'B',;
'METER CHANGED BY: ' AT 45 STYLE 'B', USER_AMEND AT 66 STYLE 'B', DATE_AMEND AT 80 STYLE 'B', TIME_AMEND AT 100 STYLE 'B',;
OP_M_A PICTURE '9999999999.999' AT 122 STYLE 'B'
ENDIF

PML = PML + MM_SOLD
PEL = PEL + TOTAL_QTY
PTL = PTL + SOLD_QTY + TEST_QTY
PVL = PVL + MM_QTY_VAR
PRL = PRL + TEST_QTY
PSL = PSL + SOLD_QTY
PSA = PSA + SOLD_QTY * SALE_PRICE
PMA = PMA + (METER_AMT - TEST_AMT)
PRA = PRA + TEST_AMT
PES = PES + EXP_SALES
PVA = PVA + (METER_AMT-TEST_AMT - SOLD_QTY*SALE_PRICE)
IF CLA='00' .OR. CLA ='10'  && PMS UNL
PPMSQ = PPMSQ + SOLD_QTY
PPMSA = PPMSA + EXP_SALES
ENDIF
IF CLA='30' .OR. CLA ='50'  && LSD DIS
PAGOQ = PAGOQ + SOLD_QTY
PAGOA = PAGOA + EXP_SALES
ENDIF
IF CLA='20'  && RMS
PRMSQ = PRMSQ + SOLD_QTY
PRMSA = PRMSA + EXP_SALES
ENDIF
IF CLA='40'  && IK
PIKQ = PIKQ + SOLD_QTY
PIKA = PIKA + EXP_SALES
ENDIF
PTQ = PPMSQ+PAGOQ+PRMSQ+PIKQ
PTA = PPMSA+PAGOA+PRMSA+PIKA

   select   st15f
   skip
   if eof()
  EOFst15f = .t.
   endif
procedure  fgcon_end_rtn 
  if _plineno > PPL - 7
do print_page
endif
? 'TOTAL' STYLE 'B' AT 3, PML PICTURE '99,999.99' AT 21 STYLE 'B', PEL PICTURE '99,999.99' AT 45 STYLE 'B',;
PVL PICTURE '999,999.99' AT 55 STYLE 'B',PTL PICTURE '99,999.99' AT 66 STYLE 'B',;
PRL PICTURE '99,999.9' AT 77 STYLE 'B', PSL PICTURE '99,999.99' AT 87 STYLE 'B', ;
PSA PICTURE '999,999,999.99' AT 107 STYLE 'B',PMA PICTURE '999,999,999.99' AT 136 STYLE 'B',;
PRA PICTURE '99999,999.99' AT 150 STYLE 'B',PES PICTURE '999,999,999.99' AT 164 STYLE 'B',;
PVA PICTURE '99999,999.99' AT 179 STYLE 'B'
  if _plineno > PPL - 7
do print_page
endif

procedure stkcal_new_header  
  if _plineno > PPL-7
do print_page
endif
 ? "SECTION B. STOCK CALCULATIONS"  AT 3 STYLE 'B'
? "------------------------------"  AT 3 STYLE 'B'
 ? 'PRODUCT DESCRIPTION' AT 3 STYLE 'B', 'TANK' AT 38 STYLE 'B', 'OPENING STOCK' AT 48 STYLE 'B', ;
 'QTY RECEIVED' AT 65 STYLE 'B', 'AVAILABLE STOCK' AT 80 STYLE 'B',;
 'SHIFT SALES(LTRS)' AT 97 STYLE 'B','CLOSING STOCK' AT 115 STYLE 'B',;
 'PHY DIPPING' AT 130 STYLE 'B', 'SHIFT GAIN(LOSS)' AT 145 STYLE 'B', 'MONTH GAIN(LOSS)' AT 165 STYLE 'B',
  
 ? '<----------------->' AT 3 STYLE 'B', '<-->' AT 38 STYLE 'B', '<----------->' AT 48 STYLE 'B', ;
 '<---------->' AT 65 STYLE 'B', '<------------->' AT 80 STYLE 'B',;
 '<--------------->' AT 97 STYLE 'B','<----------->' AT 115 STYLE 'B',;
 '<--------->' AT 130 STYLE 'B', '<-------------->' AT 145 STYLE 'B', '<-------------->' AT 165 STYLE 'B'
procedure stkcal_new_header  
  if _plineno > PPL - 7
do print_page
endif
 
 * ? 
Procedure stkcal_detail_rtn
if pfirst
pprd = typ+cla+cod
pfirst = .f.
pitems =  0
endif
POS = POS + BBF
PQR = PQR + ADJS+PURCHASES
PAS = PAS + BBF+ADJS+PURCHASES
PSS = PSS + SOLD_QTY 
PCS = PCS + ON_HAND 
PPD = PPD + PHY
PSG = PSG + SHIFT_VAR
PMG = PMG + PHY-ON_HAND
POSS = POSS + BBF
PQRS = PQRS + ADJS+PURCHASES
PASS = PASS + BBF+ADJS+PURCHASES
PSSS = PSSS + SOLD_QTY 
PCSS = PCSS + ON_HAND 
PPDS = PPDS + PHY
PSGS = PSGS + SHIFT_VAR
PMGS = PMGS + PHY-ON_HAND
if pprd = typ+cla+cod
pitems = pitems + 1
endif
PPNAME = NAME
  if _plineno > PPL - 7
do print_page
endif
? NAME AT 3, STO AT 40, BBF PICTURE '9,999,999.99' AT 48, (ADJS+PURCHASES) PICTURE '9,999,999.99' AT 65,;
(BBF+ADJS+PURCHASES) PICTURE '9,999,999.99' AT 83, SOLD_QTY PICTURE '9,999,999.99' AT 102,;
ON_HAND PICTURE '9,999,999.99' AT 116, PHY PICTURE '9,999,999.99' AT 129, SHIFT_VAR PICTURE '9,999,999.99' AT 149,;
(PHY-ON_HAND) PICTURE '9,999,999.99' AT 169

   select   shiftcla
   skip
   if .not. pprd = typ+cla+cod 
do stkcal_sub_total
pfirst =.t.
pos=0
pqr=0
pas=0
pss=0
pcs=0
ppd=0
psg=0
pmg=0
endif
   if eof()
  eofshiftcla = .t.
   endif
procedure stkcal_sub_total
if pitems > 1
if _plineno > PPL - 7
do print_page
endif
      ? LEFT(PPNAME,25) AT 3 STYLE 'B', 'SUB TOTAL' AT 30 STYLE 'B',pos PICTURE '9,999,999.99' AT 48 STYLE 'B',;
      pqr PICTURE '9,999,999.99' AT 65 STYLE 'B',pas PICTURE '9,999,999.99' AT 83 STYLE 'B',;
      pss PICTURE '9,999,999.99' AT 102 STYLE 'B',;
pcs PICTURE '9,999,999.99' AT 116 STYLE 'B', ppd PICTURE '9,999,999.99' AT 129 STYLE 'B',;
psg PICTURE '9,999,999.99' AT 149 STYLE 'B',pmg PICTURE '9,999,999.99' AT 169 STYLE 'B'
endif
pfirst=.t.
procedure stkcal_end_rtn
  if _plineno > PPL - 7
do print_page
endif
  ?  'TOTAL ALL TANKS' AT 3 STYLE 'B',poss PICTURE '9,999,999.99' AT 48 STYLE 'B',;
      pqrs PICTURE '9,999,999.99' AT 65 STYLE 'B',pass PICTURE '9,999,999.99' AT 83 STYLE 'B',;
      psss PICTURE '9,999,999.99' AT 102 STYLE 'B',;
pcss PICTURE '9,999,999.99' AT 116 STYLE 'B', ppds PICTURE '9,999,999.99' AT 129 STYLE 'B',;
psgs PICTURE '9,999,999.99' AT 149 STYLE 'B',pmgs PICTURE '9,999,999.99' AT 169 STYLE 'B'
