procedure dsshrep
parameter buser
pluser = buser
create session 
set lock off
set safety off
CLEAR
SET TALK OFF
EOFst15f = .f.
PRIVATE PLINES,PAMT,plhd,pdoc
PSPRINTER = ""  && PRINTER SELECTION
PTYPE = ""  && PAPER SIZE

_porientation="LANDSCAPE"

PPL = _plength
_pageno=1
_plineno=0 && set to zero
_padvance="LINEFEEDS"

_pcopies=1         && 3 copies
_peject="none"     && no page eject before or after
_ppitch = 'CONDENSED'
Newprinter=CHOOSEPRINTER()
SET PRINTER ON
*SET PRINTER TO
*SET MARGIN TO 3
PRINTJOB
?
?
*?
SET HEADINGS OFF
    Set view to "dsshrep.qbe"
        sELECT FGCOY
GO TOP
if purtname ="Yes"
plhd = .t.
else
plhd = .f.
endif
SELECT st15f
go top
if .not. eof()
   do dsshrep_rtn1
   else
   quit
   endif 
    ENDPRINTJOB
    
SET PRINTER OFF
CLOSE PRINTER
 close databases
 do dsshrepp.prg with pluser,_pageno
procedure dsshrep_rtn1  
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
    do mtr_mvnt_new_header 
    SELECT st15f
    GO TOP
    if .not. EOF()
         do
         do fgcon_detail_rtn
         until  EOFst15f
      endif
      do fgcon_end_rtn
      eofshiftbk = .f.
            do sale_mtr_summ
   do stkcal_new_header
   eofshiftcla = .f.
   select shiftcla
      GO TOP
   go top
   if .not. eof()
   do
      do stkcal_detail_rtn
      until eofshiftcla
      endif
   do stkcal_end_rtn
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
set filter to   shSUM->Shift_date  = shift_date 
    set order to OFF
    set relation to off into fgoffs
    go top
    if .not. eof()
    if _plineno > PPL-7
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
prcasou picture '99,999,999.99' at 178 STYLE 'B'
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
? left(pcname,15) at 3, psales picture '99999,999.99' at 21,pfcjc picture '99999,999.99' at 35,;
pinv  picture '99999,999.99' at 49, ppos  picture '99999,999.99' at 63, pbbk picture '99999,999.99' at 77,;
ptcrs picture '99999,999.99' at 91, precs picture '99999,999.99' at 105, ppymts picture '99999,999.99' at 119,;
pchqs picture '99999,999.99' at 133, pexpcas picture '99,999,999.99' at 146, pacas picture '99,999,999.99' at 160,;
pcasou picture '99,999,999.99' at 178
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
  'ACTUAL CASH' AT 161 STYLE 'B', 'OVER(UNDER)' AT 178 STYLE 'B'
   ? '<----->' AT 3 STYLE 'B', '<--->' AT 28 STYLE 'B',  '<------>' AT 39 STYLE 'B',;
 '<------>' AT 53 STYLE 'B', '<------>' AT 67 STYLE 'B','<------>' AT 81 STYLE 'B',;
 '<----------->' AT 90 STYLE 'B', '<------>' AT 109 STYLE 'B', '<------>' AT 123 STYLE 'B', ;
  '<---------->' AT 133 STYLE 'B', '<----------->' AT 147 STYLE 'B',;
  '<--------->' AT 161 STYLE 'B', '<--------->' AT 178 STYLE 'B'


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
  ?  'COMBINED DSSR FOR: ' AT 43  STYLE 'B', shSUM->SHIFT_DATE AT 80 STYLE 'B'
   ? '===============================================' AT 43 STYLE 'B'
  ? "SECTION A. FUEL METER MOVEMENTS"  AT 3 STYLE 'B'
 ? "-------------------------------"  AT 3 STYLE 'B'
 ? 'PUM' AT 3 STYLE 'B', 'MANUAL MTR' AT 09 STYLE 'B', 'MAN LITRS' AT 20 STYLE 'B','ELEC.  METER' AT 31 STYLE 'B',;
 'ELEC LTRS' AT 45 STYLE 'B','VAR(LTRS)' AT 56 STYLE 'B','THROUGPUT' AT 66 STYLE 'B','RTT(LTR)' AT 76 STYLE 'B',;
 'SOLD LTRS' AT 86 STYLE 'B', 'PUM PRICE' AT 97 STYLE 'B', 'SOLD QTY AMT' AT 109 STYLE 'B',;
 'SHS   METER' AT 124 STYLE 'B', 'SHS MTR AMNT' AT 138 STYLE 'B', 'RTT SHS AMT' AT 153 STYLE 'B',;
 'EXPECTED SALES' AT 165 STYLE 'B',  '  VAR(AMT)' AT 180 STYLE 'B'
 ? '<->' AT 3 STYLE 'B', '<-------->' AT 09 STYLE 'B', '<------->' AT 20 STYLE 'B','<---------->' AT 31 STYLE 'B',;
 '<------->' AT 45 STYLE 'B','<------->' AT 56 STYLE 'B','<------->' AT 66 STYLE 'B','<------>' AT 76 STYLE 'B',;
 '<------->' AT 86 STYLE 'B', '<------->' AT 97 STYLE 'B', '<---------->' AT 109 STYLE 'B',;
 '<--------->' AT 124 STYLE 'B', '<---------->' AT 138 STYLE 'B', '<--------->' AT 153 STYLE 'B',;
 '<------------>' AT 165 STYLE 'B',  '<-------->' AT 180 STYLE 'B'
     if _plineno > PPL - 7
do print_page
endif

Procedure print_page
? 'Page No.: '+STR(_PAGENO) AT 160 STYLE 'B'
EJECT PAGE
   ?  'COMBINED DSSR FOR: ' AT 43  STYLE 'B', shSUM->SHIFT_DATE AT 80 STYLE 'B'
   ? '===============================================' AT 43 STYLE 'B'
   ?
Procedure fgcon_detail_rtn
   if _plineno > PPL - 7
do print_page
endif
? shift_no+shift_id+sto AT 3, CL_MM_QTY PICTURE '999999999.99' AT 08,ROUND((CL_MM_QTY  - OP_MM_QTY),2) PICTURE '99,999.99' AT 20,;
CL_M_Q PICTURE '9999999999.999' AT 30, ROUND((CL_M_Q-OP_M_Q),2) PICTURE '99,999.99' AT 45,;
(ROUND((CL_M_Q-OP_M_Q),2) - ROUND((CL_MM_QTY  - OP_MM_QTY),2))  PICTURE '999,999.99' AT 55, ;
(SOLD_QTY + TEST_QTY) PICTURE '99,999.99' AT 66,;
TEST_QTY PICTURE '99,999.9' AT 76, SOLD_QTY PICTURE '99,999.99' AT 86, ;
SALE_PRICE PICTURE '99,999.99' AT 97, (SOLD_QTY * SALE_PRICE) PICTURE '999,999,999.99' AT 107,;
CL_M_A PICTURE '9999999999.999' AT 122,;
(CL_M_A-OP_M_A-test_qty*sale_price) PICTURE '999,999,999.99' AT 136,(TEST_QTY*SALE_PRICE) PICTURE '999,999,999.99' AT 150,;
EXP_SALES PICTURE '999999,999.99' AT 166,;
((SOLD_QTY * SALE_PRICE) - (CL_M_A-OP_M_A)+(TEST_QTY*SALE_PRICE))*-1 PICTURE '9999999.99' AT 180
IF .NOT. (EMPTY(DATE_AMEND) .OR.  EMPTY(USER_AMEND) .OR.  EMPTY(TIME_AMEND))
? 'OP M' AT 3 STYLE 'B', OP_MM_QTY PICTURE '999999999.99' AT 08 STYLE 'B', OP_M_Q PICTURE '9999999999.999' AT 30 STYLE 'B',;
'METER CHANGED BY: ' AT 45 STYLE 'B', USER_AMEND AT 66 STYLE 'B', DATE_AMEND AT 80 STYLE 'B', TIME_AMEND AT 100 STYLE 'B',;
OP_M_A PICTURE '9999999999.999' AT 122 STYLE 'B'
ENDIF
PML = PML + ROUND((CL_MM_QTY  - OP_MM_QTY),2)
PEL = PEL + ROUND((CL_M_Q-OP_M_Q),2)
PTL = PTL + SOLD_QTY + TEST_QTY
PVL = PVL + (ROUND((CL_M_Q-OP_M_Q),2) - ROUND((CL_MM_QTY  - OP_MM_QTY),2))
PRL = PRL + TEST_QTY
PSL = PSL + SOLD_QTY
PSA = PSA + (SOLD_QTY * SALE_PRICE)
PMA = PMA + (CL_M_A-OP_M_A) - test_qty*sale_price
PRA = PRA + (TEST_QTY*SALE_PRICE)
PES = PES + EXP_SALES
PVA = PVA + ((SOLD_QTY * SALE_PRICE) - (CL_M_A-OP_M_A)+(TEST_QTY*SALE_PRICE))*-1
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
If _plineno > PPL-7
do print_page
endif
   select   st15f
   skip
   if eof()
  EOFst15f = .t.
   endif
procedure  fgcon_end_rtn  
  if _plineno > PPL - 7
do print_page
endif
? 'TOTAL' STYLE 'B' AT 3, PML PICTURE '99,999.99' AT 20 STYLE 'B', PEL PICTURE '99,999.99' AT 45 STYLE 'B',;
PVL PICTURE '999,999.99' AT 55 STYLE 'B',PTL PICTURE '99,999.99' AT 66 STYLE 'B',;
PRL PICTURE '99,999.9' AT 76 STYLE 'B', PSL PICTURE '99,999.99' AT 86 STYLE 'B', ;
PSA PICTURE '999,999,999.99' AT 107 STYLE 'B',PMA PICTURE '999,999,999.99' AT 136 STYLE 'B',;
PRA PICTURE '999999,999.99' AT 150 STYLE 'B',PES PICTURE '999,999,999.99' AT 164 STYLE 'B',;
PVA PICTURE '999999999.99' AT 179 STYLE 'B'
?
If _plineno > PPL-7
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
 'PHY DIPPING' AT 130 STYLE 'B', 'MONTH GAIN(LOSS)' AT 165 STYLE 'B',
  
 ? '<----------------->' AT 3 STYLE 'B', '<-->' AT 38 STYLE 'B', '<----------->' AT 48 STYLE 'B', ;
 '<---------->' AT 65 STYLE 'B', '<------------->' AT 80 STYLE 'B',;
 '<--------------->' AT 97 STYLE 'B','<----------->' AT 115 STYLE 'B',;
 '<--------->' AT 130 STYLE 'B',  '<-------------->' AT 165 STYLE 'B'

 if _plineno > PPL-7
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
PQR = PQR + cs_purch+cr_purch+trans_in-trans_out+adj_in-adj_out
PAS = PAS + BBF+cs_purch+cr_purch+trans_in-trans_out+adj_in-adj_out
padpu = cs_purch+cr_purch+trans_in-trans_out+adj_in-adj_out
pbfadpu = BBF+cs_purch+cr_purch+trans_in-trans_out+adj_in-adj_out
psoldqty = cs_sales+cr_sales
PSS = PSS + cs_sales+cr_sales
PCS = PCS + ON_HAND 
PPD = PPD + PHY
PSG = 0
PMG = PMG + PHY-ON_HAND
POSS = POSS + BBF
PQRS = PQRS + cs_purch+cr_purch+trans_in-trans_out+adj_in-adj_out
PASS = PASS + BBF+cs_purch+cr_purch+trans_in-trans_out+adj_in-adj_out
PSSS = PSSS + cs_sales+cr_sales
PCSS = PCSS + ON_HAND 
PPDS = PPDS + PHY
PSGS = 0
PMGS = PMGS + PHY-ON_HAND
if pprd = typ+cla+cod
pitems = pitems + 1
endif
  if _plineno > PPL - 7
do print_page
endif
? fgcods2->NAME AT 3, STO AT 40, BBF PICTURE '9,999,999.99' AT 48, padpu PICTURE '9,999,999.99' AT 65,;
pbfadpu PICTURE '9,999,999.99' AT 83, psoldqty PICTURE '9,999,999.99' AT 102,;
ON_HAND PICTURE '9,999,999.99' AT 116, PHY PICTURE '9,999,999.99' AT 129, (PHY-ON_HAND) PICTURE '9,999,999.99' AT 169
PPNAME = fgcods2->NAME
If _plineno > PPL-7
do print_page
endif
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
      ? LEFT(PPNAME,25) AT 3 STYLE 'B', 'SUB TOTAL' AT 30 STYLE 'B',pos PICTURE '9,999,999.99' AT 48 STYLE 'B',;
      pqr PICTURE '9,999,999.99' AT 65 STYLE 'B',pas PICTURE '9,999,999.99' AT 83 STYLE 'B',;
      pss PICTURE '9,999,999.99' AT 102 STYLE 'B',;
pcs PICTURE '9,999,999.99' AT 116 STYLE 'B', ppd PICTURE '9,999,999.99' AT 129 STYLE 'B',pmg PICTURE '9,999,999.99' AT 169 STYLE 'B'
if _plineno > PPL-7
do print_page
endif
endif
pfirst=.t.
procedure stkcal_end_rtn
*?
  ?  'TOTAL ALL TANKS' AT 3 STYLE 'B',poss PICTURE '9,999,999.99' AT 48 STYLE 'B',;
      pqrs PICTURE '9,999,999.99' AT 65 STYLE 'B',pass PICTURE '9,999,999.99' AT 83 STYLE 'B',;
      psss PICTURE '9,999,999.99' AT 102 STYLE 'B',;
pcss PICTURE '9,999,999.99' AT 116 STYLE 'B', ppds PICTURE '9,999,999.99' AT 129 STYLE 'B',pmgs PICTURE '9,999,999.99' AT 169 STYLE 'B'
  if _plineno > PPL-7
do print_page
endif