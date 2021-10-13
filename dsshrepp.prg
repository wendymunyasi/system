procedure dsshrepp
parameter buser,bpageno
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


_porientation="PORTRAIT"

PPL = _plength  && DEFAULT PAGE SIZE
_pageno=bpageno+1
_plineno=0 && set to zero
*_padvance="LINEFEEDS"

_pcopies=1         && 3 copies
*_peject="none"     && no page eject before or after
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
  Set view to "dsshrepp.qbe"
  
SELECT FGCOY
GO TOP
if purtname ="Yes"
plhd = .t.
else
plhd = .f.
endif

SELECT st15f
go top
if .not. eof()
   do dsshrepp_rtn1
   endif 
    ENDPRINTJOB
    
SET PRINTER OFF
CLOSE PRINTER
 close databases
procedure dsshrepp_rtn1  
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
       PCNT = 0
      pserved = ""
      PSREP = ""
      poff =""

   eofst15f = .f.
   ptsales = 0
   ptcrsales = 0
   ptcsales = 0
   ptsalesqty = 0
   ptrecsqty = 0
   ptopenqty = 0
   ptcloseqty = 0
   prtsales = 0
   prtcrsales = 0
   prtcsales = 0
   select st15f
     go top
   if .not. eof()
       do fc_stks_hd_rtn
    do
        do fc_stks
       until eofst15f
         ? 'TOTAL' AT 3 STYLE 'B', prtsales PICTURE '99999,999.99' AT 80 STYLE 'B',;
prtcrsales PICTURE '99999,999.99' AT 94 STYLE 'B', prtcsales  PICTURE '99999,999.99' AT 108 STYLE 'B'

    endif
    
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
  
 
    select shiftbk
go bottom
    if .not. eof()
        do cash_summ_rtn
          endif
         ?
    ? 'Page No.: '+STR(_PAGENO) AT 100 STYLE 'B'
procedure cash_summ_rtn
PCEXSPSAL = CASH_MOTOR + CASH_STAFF
PCFCLUBES = C_SH_WORK + RESERVED5
PCLIABILE = CASH_WITHD+CASH_GEN
PCLPGS = RESERVED4+C_SH_CANT
PTRECS = C_SH_FUELS+C_SH_WORK+RESERVED5+RESERVED4+C_SH_CANT+CASH_CARDS+CASH_WORK+CASH_DEBT+C_SH_CARDS+;
CASH_CANT+CASH_SHOP+CASH_SODA+CHQS_SALE+VS_OTHERS+C_SH_SHOP+FC_C_SALES
PTPYMTS = CASH_MOTOR+CASH_STAFF+CASH_WITHD+CASH_GEN+CASH_COY+CASH_FOOD+CASH_LUBES
PTCASH = OP_C_HAND + C_SH_FUELS+C_SH_WORK+RESERVED5+RESERVED4+C_SH_CANT+CASH_CARDS+CASH_WORK+CASH_DEBT+C_SH_CARDS+;
CASH_CANT+CASH_SHOP+CASH_SODA+CHQS_SALE+VS_OTHERS+C_SH_SHOP+FC_C_SALES - cash_merch-dbcredits
PEXPCASH = OP_C_HAND + C_SH_FUELS+C_SH_WORK+RESERVED5+RESERVED4+C_SH_CANT+CASH_CARDS+CASH_WORK+CASH_DEBT+C_SH_CARDS+;
CASH_CANT+CASH_SHOP+CASH_SODA+CHQS_SALE+VS_OTHERS+C_SH_SHOP+FC_C_SALES - ;
(CASH_MOTOR+CASH_STAFF+CASH_WITHD+CASH_GEN+CASH_COY+CASH_FOOD+CASH_LUBES) - cash_merch-dbcredits

if _plineno > PPL-48
do print_page
endif

 ? "SECTION E. DAILY CASH SUMMARY"  AT 3 STYLE 'B'
 ? "-----------------------------"  AT 3 STYLE 'B'
 ? 'a. CASH BROUGHT FORWARD FROM PREVIOUS SHIFT' AT 3 STYLE 'B', OP_C_HAND PICTURE '999,999,999.99' AT 60 STYLE 'B'
 ? 'b. RECEIPTS' AT 03 STYLE 'B'
 ? '   <------>' AT 03 STYLE 'B'
 ? '1.  FUEL CASH SALES' AT 10, C_SH_FUELS PICTURE '999,999,999.99' AT 40
 ? '2.  FC LUBES CASH SALES' AT 10, PCFCLUBES PICTURE '999,999,999.99' AT 40
 ? '3.  FC LPG CASH SALES' AT 10, PCLPGS PICTURE '999,999,999.99' AT 40
 ? '4.  PITSTOP CASH SALES' AT 10, CASH_WORK PICTURE '999,999,999.99' AT 40
 ? '5.  SHOP CASH SALES' AT 10, CASH_CANT PICTURE '999,999,999.99' AT 40
 ? '6.  TYRE CENTRE CASH SALES' AT 10, CASH_SHOP PICTURE '999,999,999.99' AT 40
 ? '7.  STAFF RECOVERIES(SHORTS)' AT 10, CASH_CARDS PICTURE '999,999,999.99' AT 40
 ? '8.  CAFE CASH SALES' AT 10, CASH_SODA PICTURE '999,999,999.99' AT 40
 ? '9.  FC PHONE CARDS(AIRTIME)' AT 10, C_SH_CARDS PICTURE '999,999,999.99' AT 40
 ? '10. COLLECTIONS FROM DEBTORS' AT 10, CASH_DEBT PICTURE '999,999,999.99' AT 40
 ? '11. FC SHOP CASH SALES' AT 10, C_SH_SHOP PICTURE '999,999,999.99' AT 40
 ? '12. TYRES & TUBES CASH SALES' AT 10, VS_OTHERS PICTURE '999,999,999.99' AT 40
 ? '13. CAR WASHINGS CASH SALES' AT 10, CHQS_SALE PICTURE '999,999,999.99' AT 40
 ? '14. FC JOB CARDS CASH SALES' AT 10, FC_C_SALES PICTURE '999,999,999.99' AT 40
 ? 'TOTAL RECEIPTS' AT 10 STYLE 'B', PTRECS PICTURE '999,999,999.99' AT 40 STYLE 'B'
 ? 'c. CHEQUES RECEIVED' AT 3 STYLE 'B', CASH_MERCH PICTURE '999,999,999.99' AT 40 STYLE 'B'
 ? 'd. CREDIT (DEBIT) NOTES' AT 3 STYLE 'B', DBCREDITS PICTURE '999,999,999.99' AT 40 STYLE 'B'
 ? 'e. TOTAL CASH AVAILABLE (a+b-c-d)' AT 3 STYLE 'B', PTCASH PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'f. CASH PAYMENTS' AT 3 STYLE 'B'
? '   <----------->' AT 3 STYLE 'B'
? '1. EXPENSES/SALARIES' AT 10, PCEXSPSAL PICTURE '999,999,999.99' AT 60
? '2. LIABILITIES' AT 10, PCLIABILE PICTURE '999,999,999.99' AT 60
? '3. SUSPENSE ACCOUNTS/FLOAT REPLENISH' AT 10, CASH_COY PICTURE '999,999,999.99' AT 60
? '4. SHORTTERM DEBTORS AND DISCOUNTS' AT 10, CASH_FOOD PICTURE '999,999,999.99' AT 60
? '5. PURCHASES' AT 10, CASH_LUBES PICTURE '999,999,999.99' AT 60
? 'TOTAL CASH PAYMENTS' AT 10 STYLE 'B', PTPYMTS PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'g. EXPECTED CASH (e-f)' AT 3 STYLE 'B', PEXPCASH PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'h. ACTUAL CASH IN HAND' AT 3 STYLE 'B', (A_C_INHAND+A_CASH) PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'i. CASH EXCESS/SHORT (h-j)' AT 3 STYLE 'B', CASH_SHORT PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'j. CASH BANKED' AT 3 STYLE 'B', CASH_BANK PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'k. CASH CARRIED FORWARD TO THE NEXT SHIFT (f-h)' AT 3 STYLE 'B', CL_C_HAND PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'l. CHEQUES BANKED' AT 3 STYLE 'B', CASH_MERCH PICTURE '999,999,999.99' AT 60 STYLE 'B'
? 'm. FLOAT CASH MOVEMENT' AT 3 STYLE 'B', BATCHAMT PICTURE '999,999,999.99' AT 60 STYLE 'B'


Procedure fc_stks
*if _plineno > PPL-8
*do print_page
*endif
? LEFT(fgcens->name,7) at 3, LEFT(fgcods->name,21) at 12, BBF picture '999999.99' AT 35,;
(cs_purch+cr_purch+trans_in+adj_in-trans_out-adj_out) PICTURE '999999.99' AT 46,;
(cs_sales+cr_sales) PICTURE '999999.99' AT 57,;
SALE_PRICE PICTURE '999,999.99' AT 68, (cs_sales*sale_price+cr_sales*sale_price) PICTURE '99999,999.99' AT 80, ;
cr_sales*sale_price PICTURE '99999,999.99' AT 94, cs_sales*sale_price PICTURE '99999,999.99' AT 108,;
on_hand PICTURE '99999.99' AT 122
ptsales = ptsales + cs_sales*sale_price+cr_sales*sale_price
ptcrsales = ptcrsales + cr_sales*sale_price
ptcsales = ptcsales + cs_sales*sale_price
ptsalesqty = ptsalesqty + cs_sales + cr_sales
ptrecsqty = ptrecsqty +cs_purch+cr_purch+trans_in+adj_in-trans_out-adj_out
ptopenqty = ptopenqty + bbf
ptcloseqty = ptcloseqty + on_hand
prtsales = prtsales + cs_sales*sale_price+cr_sales*sale_price
prtcrsales = prtcrsales + cr_sales*sale_price
prtcsales = prtcsales + cs_sales*sale_price
pcen = cen
pcen = cen
SELECT ST15F
SKIP
if .not. cen = pcen
do fc_stks_subtotal
ptsales = 0
ptcrsales = 0
ptcsales = 0
ptsalesqty = 0
ptrecsqty = 0
ptopenqty = 0
ptcloseqty = 0
endif
IF EOF()
EOFST15F =.T.
endif

*else
*if _plineno > PPL-8
*do print_page
*?'CENTRE' STYLE 'B' AT 3, 'PRODUCT DESCRIPTION' AT 12 STYLE 'B',  '  OPENING' AT 35 STYLE 'B',;
 '  RECEIVD' AT 46 STYLE 'B', '    SALES' AT 57 STYLE 'B','     PRICE' AT 68 STYLE 'B',;
 '   SALES AMT' AT 80 STYLE 'B', '  CREDIT AMT' AT 94 STYLE 'B', '    CASH AMT' AT 108 STYLE 'B', ;
  ' CLOSING' AT 122 STYLE 'B'  
 * ?'<---->' STYLE 'B' AT 3, '<----------------->' AT 12 STYLE 'B',  '<------->' AT 35 STYLE 'B',;
 '<------->' AT 46 STYLE 'B', '<------->' AT 57 STYLE 'B','<-------->' AT 68 STYLE 'B',;
 '<---------->' AT 80 STYLE 'B', '<---------->' AT 94 STYLE 'B', '<---------->' AT 108 STYLE 'B', ;
  '<------>' AT 122 STYLE 'B'

* endif
*ENDIF
procedure fc_stks_subtotal
*if _plineno > PPL-8
*do print_page
*endif
? 'SUB TOTAL' AT 3 STYLE 'B', ptopenqty picture '999999.99' AT 35  STYLE 'B',ptrecsqty PICTURE '999999.99' AT 46  STYLE 'B',;
ptsalesqty PICTURE '999999.99' AT 57  STYLE 'B', ptsales PICTURE '99999,999.99' AT 80 STYLE 'B',;
ptcrsales PICTURE '99999,999.99' AT 94 STYLE 'B', ptcsales  PICTURE '99999,999.99' AT 108 STYLE 'B', ptcloseqty PICTURE '99999.99' AT 122 STYLE 'B'
? '--------------------------------------------------------------------------------------------------------------------------------------------'
*if _plineno > PPL-8
*do print_page
*endif
procedure fc_stks_hd_rtn
*if _plineno > PPL-10
*do print_page
*endif
  ?'User: '+pluser at 3 STYLE 'I', DATE() AT 25 STYLE 'I', TIME() AT 35 STYLE 'I', fgcoy->name  AT 60 STYLE "B"
     ? fgcoy->street  AT 60 STYLE "B"

     ?  'COMBINED DSSR FOR : ' AT 43  STYLE 'B', shSUM->SHIFT_DATE AT 80 STYLE 'B'
   ? '===========================================================================' AT 43 STYLE 'B'

 ? "SECTION D. SALES AND STOCK OF ALL ITEMS"  AT 3 STYLE 'B'
 ? "---------------------------------------------"  AT 3 STYLE 'B'
?'CENTRE' STYLE 'B' AT 3, 'PRODUCT DESCRIPTION' AT 12 STYLE 'B',  '  OPENING' AT 35 STYLE 'B',;
 '  RECEIVD' AT 46 STYLE 'B', '    SALES' AT 57 STYLE 'B','     PRICE' AT 68 STYLE 'B',;
 '   SALES AMT' AT 80 STYLE 'B', '  CREDIT AMT' AT 94 STYLE 'B', '    CASH AMT' AT 108 STYLE 'B', ;
  ' CLOSING' AT 122 STYLE 'B'  
  ?'<---->' STYLE 'B' AT 3, '<----------------->' AT 12 STYLE 'B',  '<------->' AT 35 STYLE 'B',;
 '<------->' AT 46 STYLE 'B', '<------->' AT 57 STYLE 'B','<-------->' AT 68 STYLE 'B',;
 '<---------->' AT 80 STYLE 'B', '<---------->' AT 94 STYLE 'B', '<---------->' AT 108 STYLE 'B', ;
  '<------>' AT 122 STYLE 'B'
*  if _plineno > PPL-8
*do print_page
*endif
  

Procedure print_page
?
? 'Page No.: '+STR(_PAGENO) AT 100 STYLE 'B'
EJECT PAGE
       ?  'COMBINED DSSR FOR : ' AT 43  STYLE 'B', shSUM->SHIFT_DATE AT 80 STYLE 'B'
   ? '=========================================================================' AT 43 STYLE 'B'

