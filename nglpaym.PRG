**************************************************************************
*  PROGRAM:      NGLPAYM
*
*******************************************************************************

Procedure NGLPAYM
PARAMETER BUSER,BLEVEL

create session
set talk off
set ldCheck off
set century on
set date to british
set decimals to 4
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Payments to the GL and CB in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 12,;
    ColorNormal "b+/Btnface"
PROGREPS.OPEN()
      
    set view to "NGLPAYM.qbe"
PRIVATE EOFFGNFPUR,PYEAR,PPERIOD,PCOY,PCCENTRE,PACTYP,PACCLASS,PACC,psys,pshdate,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,ptyp,pcla,pcod,ppwk,eofwkprices,pcwk,PPRICE,;
pcashbook,eofnlbankc
 PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
SELECT NGLYEARS
   SET ORDER TO MKEY
   EOFFGNFPUR = .F.
   select fgtyp
   set order to typ
    select nlbank
set order to bank
select nlcash
set order to cash
select nlbankC
set order to bank
select nlcashC
set order to cash
   EOFFGNFPUR = .F.
   SELECT ngltran
   SET ORDER TO TKEY
         SELECT nglMAST
   SET ORDER TO MKEY
         SELECT NGPERIOD
       SET ORDER TO TKEY  
      SELECT FGNFPUR
   set filter to empty(gl_post) .AND. doctype = "54"  .and. system = "AP" .and. .not. total = 0;
        .and. (pay_method = "Cash" .or. pay_method = "Cheque";
        .or. left(pay_method,6) = "Direct"  .or. pay_method = "Capital" .or. left(pay_method,6) = "Credit" ;
        .or. pay_method = "FC Cash" .OR. PAY_METHOD = "Float Cash" .OR. PAY_METHOD = "Bank Debit" ;
         .OR. PAY_METHOD = "M-Money") ;
         .and. .not. empty(typ)  .and. .not. empty(coy) ;
          .and. .not. empty(div) .and. .not. empty(cen) .and. .not. empty(sto) .and. .not. empty(order_date) ;
           .and. .not. empty(btyp) .and. .not. empty(bcla) .and. .not. empty(bcod) .and. .not. empty(bcoy) ;
          .and. .not. empty(bdiv) .and. .not. empty(bcen) .and. .not. empty(bsto) .and. .not. empty(vendor_n)
      GO TOP
      IF .NOT. EOF()
         DO 
            DO RTN2
            UNTIL EOFFGNFPUR
            endif
            
        eofnlbankc = .f.
            select nlbankc
            go top
            if .not. eof()
            do
            do NLbankcs_rtn
            until eofnlbankc
            endif
            eofnlbank = .f.
            select nlbank
            go top
            if .not. eof()
            do
            do NLbanks_rtn
            until eofnlbank
            endif
            
                progreps.close()
    CLOSE DATABASES
    CLEAR PROGRAM

 PROCEDURE RTN2
     local ldd,lmm,lper
     if empty(fgnfpur->inv_date)
     ldd = dtos(FGNFPUR->order_date)  && yyyymmdd
     else
     ldd = dtos(FGNFPUR->inv_date)
     endif
    lmm = right(left(ldd,6),2)
    pyear = left(ldd,4)
    pperiod = lmm
    lper =.f.
    if fgnfpur->typ > "9Z" .or.  fgnfpur->typ <"00"  && not purchase of stock items
    select fgtyp
    seek fgnfpur->typ
    if .not. found()  .or. empty(fgtyp->actype)
    lper = .t.
    endif
    endif
    
    select fgtyp
    seek fgnfpur->btyp
    if .not. found()  .or. empty(fgtyp->actype)
    lper = .t.
    endif
    
    if .not. lper
      pcoy = "1"   && debit purchases
      pccentre = fgnfpur->div && profit centre
      ppcentre = fgnfpur->cen && profit centre
      if fgnfpur->typ <= "9Z" .and. fgnfpur->typ >="00"
      pactype = "7"    && purchases
      else
      select fgtyp
      seek fgnfpur->typ
      pactype = fgtyp->actype
      endif
      
      pacclass = FGNFPUR->typ 
      pacc = FGNFPUR->cla+ FGNFPUR->cod
      psys = FGNFPUR->system
      if empty(fgnfpur->inv_date)
      pshdate = FGNFPUR->order_date
      else
      pshdate = FGNFPUR->inv_date
      endif
      pdoc = FGNFPUR->doctype
       pserial = FGNFPUR->order_no
      pamt = FGNFPUR->total  - FGNFPUR->TAX_AMT && NET PURCHASES LESS vat
      pqty = 0
        SELECT NGLYEARS
      SEEK "1"+PYEAR
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE COY WITH "1"
      REPLACE YEAR WITH PYEAR
      ENDIF
      if .not. pamt = 0
      select ngltran
      seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+DTOS(PSHDATE)+psys+pdoc
      if .not. found()
      append blank
      replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace transdate with pshdate
      replace system with psys
      replace doctype with pdoc
      replace qty with 0
      replace price with 0
      replace amount with 0
      replace debitamt with 0
      replace creditamt with 0
      replace period with pperiod
      endif
      select nglmast
      seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc
      if .not. found()
      append blank
       replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace a_open_bal with 0
       replace q_open_bal with 0
        replace a_ytd_bal with 0
         replace q_ytd_bal with 0
         replace a_1 with 0
         replace a_2 with 0
         replace a_3 with 0
         replace a_4 with 0
         replace a_5 with 0
         replace a_6 with 0
         replace a_7 with 0
         replace a_8 with 0
         replace a_9 with 0
         replace a_10 with 0
         replace a_11 with 0
         replace a_12 with 0
         replace a_13 with 0
         replace a_14 with 0
         
         replace q_1 with 0
         replace q_2 with 0
         replace q_3 with 0
         replace q_4 with 0
         replace q_5 with 0
         replace q_6 with 0
         replace q_7 with 0
         replace q_8 with 0
         replace q_9 with 0
         replace q_10 with 0
         replace q_11 with 0
         replace q_12 with 0
         replace q_13 with 0
         replace q_14 with 0
         endif
         
         
      if pamt > 0
      do PAY_DR_RTN  && total purchases debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
      endif
      pcoy = "1"   && debit VAT IN  
      pccentre = "5"
      ppcentre = '1'
      pactype = "6"    && purchases
      
      pacclass = "L0" 
      pacc = "4000"  && VAT IN
      psys = FGNFPUR->system
      if empty(fgnfpur->inv_date)
      pshdate = FGNFPUR->order_date
      else
      pshdate = FGNFPUR->inv_date
      endif
      pdoc = FGNFPUR->doctype
       pserial = FGNFPUR->order_no
      pamt =  FGNFPUR->TAX_AMT && VAT AMOUNT
      pqty = 0
      if .not. pamt = 0
      select ngltran
      seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+DTOS(PSHDATE)+psys+pdoc
      if .not. found()
      append blank
      replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace transdate with pshdate
      replace system with psys
      replace doctype with pdoc
      replace qty with 0
      replace price with 0
      replace amount with 0
      replace debitamt with 0
      replace creditamt with 0
      replace period with pperiod
      endif
      select nglmast
      seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc
      if .not. found()
      append blank
       replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace a_open_bal with 0
       replace q_open_bal with 0
        replace a_ytd_bal with 0
         replace q_ytd_bal with 0
         replace a_1 with 0
         replace a_2 with 0
         replace a_3 with 0
         replace a_4 with 0
         replace a_5 with 0
         replace a_6 with 0
         replace a_7 with 0
         replace a_8 with 0
         replace a_9 with 0
         replace a_10 with 0
         replace a_11 with 0
         replace a_12 with 0
         replace a_13 with 0
         replace a_14 with 0
         
         replace q_1 with 0
         replace q_2 with 0
         replace q_3 with 0
         replace q_4 with 0
         replace q_5 with 0
         replace q_6 with 0
         replace q_7 with 0
         replace q_8 with 0
         replace q_9 with 0
         replace q_10 with 0
         replace q_11 with 0
         replace q_12 with 0
         replace q_13 with 0
         replace q_14 with 0
         endif
         
         
      if pamt > 0
      do PAY_DR_RTN  && VAT AMOUNT debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
      endif
 
      ** CREDIT ACCOUNTS
      select fgtyp
      seek FGNFPUR->btyp
      pactype = fgtyp->actype
      pcoy = FGNFPUR->BCOY
      pccentre = FGNFPUR->Bdiv  && profit centre
      ppcentre = fgnfpur->bcen
      pacclass = FGNFPUR->Btyp
      pacc = FGNFPUR->Bcla+FGNFPUR->Bcod
      psys = FGNFPUR->system
       if empty(fgnfpur->inv_date)
      pshdate = FGNFPUR->order_date
      else
      pshdate = FGNFPUR->inv_date
      endif
      pdoc = FGNFPUR->doctype
      pamt = FGNFPUR->total * -1
      pqty = 0
      if  .not. pamt = 0
      select ngltran
      seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+DTOS(PSHDATE)+psys+pdoc
      if .not. found()
      append blank
      replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace transdate with pshdate
      replace system with psys
      replace doctype with pdoc
      replace qty with 0
      replace price with 0
      replace amount with 0
      replace debitamt with 0
      replace creditamt with 0
      replace period with pperiod
      endif
      select nglmast
      seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc
      if .not. found()
      append blank
       replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace a_open_bal with 0
       replace q_open_bal with 0
        replace a_ytd_bal with 0
         replace q_ytd_bal with 0
         replace a_1 with 0
         replace a_2 with 0
         replace a_3 with 0
         replace a_4 with 0
         replace a_5 with 0
         replace a_6 with 0
         replace a_7 with 0
         replace a_8 with 0
         replace a_9 with 0
         replace a_10 with 0
         replace a_11 with 0
         replace a_12 with 0
         replace a_13 with 0
         replace a_14 with 0
         
         replace q_1 with 0
         replace q_2 with 0
         replace q_3 with 0
         replace q_4 with 0
         replace q_5 with 0
         replace q_6 with 0
         replace q_7 with 0
         replace q_8 with 0
         replace q_9 with 0
         replace q_10 with 0
         replace q_11 with 0
         replace q_12 with 0
         replace q_13 with 0
         replace q_14 with 0
         endif
         
         
      if pamt > 0
      do PAY_DR_RTN  && a/c debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
      
       IF fgnfpur->BTYP = "C0" .AND. fgnfpur->BCLA = "00"   && CASH AND BANK A/CS
          IF fgnfpur->BCOD = "01" .or. fgnfpur->BCOD = "11"   && CASH/float A/C
         DO NLCASH_RTN
         ELSE
        do nlbank_rtn  && bank a/c
        ENDIF
      endif
         
       select FGNFPUR     
       replace gl_post   with date()  
       endif
       endif
       select fgnfpur
       if .not. eof()
      SKIP
      endif
     IF EOF()
     EOFFGNFPUR = .T.
     ENDIF
 Procedure PAY_DR_RTN
         select ngltran
      replace amount with amount + pamt
      replace qty with qty + pqty
      if amount > 0
      replace debitamt with amount
      replace creditamt with 0
      else
      replace creditamt with amount * -1
      replace debitamt with 0
      endif
      IF .NOT. QTY = 0 .AND. .NOT. AMOUNT = 0
      REPLACE PRICE WITH AMOUNT / QTY
      ENDIF
      select nglmast
      
          replace a_ytd_bal with a_ytd_bal + PAMT
           if PPERIOD = "01"
           replace a_1 with a_1 + PAMT
           endif
           if PPERIOD = "02"
           replace a_2 with a_2 + PAMT
           endif
           if PPERIOD = "03"
           replace a_3 with a_3 + PAMT
           endif
           if PPERIOD = "04"
           replace a_4 with a_4 + PAMT
           endif
           if PPERIOD = "05"
           replace a_5 with a_5 + PAMT
           endif
           if PPERIOD = "06"
           replace a_6 with a_6 + PAMT
           endif
           if PPERIOD = "07"
           replace a_7 with a_7 + PAMT
           endif
           if PPERIOD = "08"
           replace a_8 with a_8 + PAMT
           endif
           if PPERIOD = "09"
           replace a_9 with a_9 + PAMT
           endif
           if PPERIOD = "10"
           replace a_10 with a_10 + PAMT
           endif
           if PPERIOD = "11"
           replace a_11 with a_11 + PAMT
           endif
           if PPERIOD = "12"
           replace a_12 with a_12 + PAMT
           endif
           
replace q_ytd_bal with q_ytd_bal + PQTY
           if PPERIOD = "01"
           replace q_1 with q_1 + PQTY
           endif
           if PPERIOD = "02"
           replace q_2 with q_2 + PQTY
           endif
           if PPERIOD = "03"
           replace q_3 with q_3 + PQTY
           endif
           if PPERIOD = "04"
           replace q_4 with q_4 + PQTY
           endif
           if PPERIOD = "05"
           replace q_5 with q_5 + PQTY
           endif
           if PPERIOD = "06"
           replace q_6 with q_6 + PQTY
           endif
           if PPERIOD = "07"
           replace q_7 with q_7 + PQTY
           endif
           if PPERIOD = "08"
           replace q_8 with q_8 + PQTY
           endif
           if PPERIOD = "09"
           replace q_9 with q_9 + PQTY
           endif
           if PPERIOD = "10"
           replace q_10 with q_10 + PQTY
           endif
           if PPERIOD = "11"
           replace q_11 with q_11 + PQTY
           endif
           if PPERIOD = "12"
           replace q_12 with q_12 + PQTY
           endif
      SELECT NGPERIOD
         SEEK PSHDATE
         IF .NOT. FOUND()
         APPEND BLANK
         REPLACE DEBITS WITH 0
         REPLACE TRANS_DATE WITH PSHDATE
         REPLACE CREDITS WITH 0
         REPLACE ACCOUNTS WITH 0
         ENDIF
         REPLACE DEBITS WITH DEBITS + PAMT
       *  REPLACE CREDITS WITH CREDITS + PAMT
         REPLACE accounts WITH accounts + 1
   
   
  Procedure PAY_CR_RTN
  pamt =  pamt * -1
      select ngltran
      replace amount with amount + pamt 
      replace qty with qty + pqty
      if amount > 0
      replace debitamt with amount
      replace creditamt with 0
      else
      replace creditamt with amount * -1
      replace debitamt with 0
      endif
      IF .NOT. QTY = 0 .AND. .NOT. AMOUNT = 0
      REPLACE PRICE WITH AMOUNT / QTY
      ENDIF
      select nglmast
      
          replace a_ytd_bal with a_ytd_bal + PAMT
           if PPERIOD = "01"
           replace a_1 with a_1 + PAMT
           endif
           if PPERIOD = "02"
           replace a_2 with a_2 + PAMT
           endif
           if PPERIOD = "03"
           replace a_3 with a_3 + PAMT
           endif
           if PPERIOD = "04"
           replace a_4 with a_4 + PAMT
           endif
           if PPERIOD = "05"
           replace a_5 with a_5 + PAMT
           endif
           if PPERIOD = "06"
           replace a_6 with a_6 + PAMT
           endif
           if PPERIOD = "07"
           replace a_7 with a_7 + PAMT
           endif
           if PPERIOD = "08"
           replace a_8 with a_8 + PAMT
           endif
           if PPERIOD = "09"
           replace a_9 with a_9 + PAMT
           endif
           if PPERIOD = "10"
           replace a_10 with a_10 + PAMT
           endif
           if PPERIOD = "11"
           replace a_11 with a_11 + PAMT
           endif
           if PPERIOD = "12"
           replace a_12 with a_12 + PAMT
           endif
           
replace q_ytd_bal with q_ytd_bal + PQTY
           if PPERIOD = "01"
           replace q_1 with q_1 + PQTY
           endif
           if PPERIOD = "02"
           replace q_2 with q_2 + PQTY
           endif
           if PPERIOD = "03"
           replace q_3 with q_3 + PQTY
           endif
           if PPERIOD = "04"
           replace q_4 with q_4 + PQTY
           endif
           if PPERIOD = "05"
           replace q_5 with q_5 + PQTY
           endif
           if PPERIOD = "06"
           replace q_6 with q_6 + PQTY
           endif
           if PPERIOD = "07"
           replace q_7 with q_7 + PQTY
           endif
           if PPERIOD = "08"
           replace q_8 with q_8 + PQTY
           endif
           if PPERIOD = "09"
           replace q_9 with q_9 + PQTY
           endif
           if PPERIOD = "10"
           replace q_10 with q_10 + PQTY
           endif
           if PPERIOD = "11"
           replace q_11 with q_11 + PQTY
           endif
           if PPERIOD = "12"
           replace q_12 with q_12 + PQTY
           endif
         SELECT NGPERIOD
        SEEK PSHDATE
        
         IF .NOT. FOUND()
         APPEND BLANK
         REPLACE DEBITS WITH 0
         REPLACE TRANS_DATE WITH PSHDATE
         REPLACE CREDITS WITH 0
         REPLACE ACCOUNTS WITH 0
         ENDIF
         REPLACE CREDITS WITH CREDITS + PAMT * -1
         REPLACE accounts WITH accounts + 1
        
 
 Procedure NLBANKCs_rtn
   pcoy = nlbankc->coy
   pyear = nlbankc->year
   pccentre = nlbankc->ccentre
   ppcentre = nlbankc->pcentre
   pactype = nlbankc->actype
   pacclass = nlbankc->acclass
   pacc = nlbankc->acc
   pperiod = nlbankc->period
   select nglmast
    seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc
    if found()
 if pperiod = "01"
          REPLACE nlbankc->close_BAL WITH nglmast->a_1
      endif
       if pperiod = "02"
        REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2
      endif
      
      if pperiod = "03"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3
      endif
      if pperiod = "04"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4
      endif
    if pperiod = "05"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5
      endif
       if pperiod = "06"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6      
      endif
      
       if pperiod = "07"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7    
      endif
       if pperiod = "08"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8  
      endif
       if pperiod = "09"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9
      endif
      if pperiod = "10"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
      +nglmast->a_9
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9+nglmast->a_10
      endif
      
      if pperiod = "11"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
      +nglmast->a_9+nglmast->a_10
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9+nglmast->a_10+nglmast->a_11
      endif
       if pperiod = "12"
      REPLACE nlbankc->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
      +nglmast->a_9+nglmast->a_10+nglmast->a_11
          REPLACE nlbankc->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9+nglmast->a_10+nglmast->a_11+nglmast->a_12
      endif
      endif
      select nlbankc
      skip
      if eof()
      eofnlbankc = .t.
      endif
      
  
   Procedure NLBANKs_rtn
   pcoy = NLBANK->coy
   pyear = NLBANK->year
   pccentre = NLBANK->ccentre
   ppcentre = nlbank->pcentre
   pactype = NLBANK->actype
   pacclass = NLBANK->acclass
   pacc = NLBANK->acc
   pperiod = NLBANK->period
   select nglmast
    seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc
    if found()
 if pperiod = "01"
          REPLACE NLBANK->close_BAL WITH nglmast->a_1
      endif
       if pperiod = "02"
        REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2
      endif
      
      if pperiod = "03"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3
      endif
      if pperiod = "04"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4
      endif
    if pperiod = "05"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5
      endif
       if pperiod = "06"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6      
      endif
      
       if pperiod = "07"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7    
      endif
       if pperiod = "08"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8  
      endif
       if pperiod = "09"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9
      endif
      if pperiod = "10"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
      +nglmast->a_9
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9+nglmast->a_10
      endif
      
      if pperiod = "11"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
      +nglmast->a_9+nglmast->a_10
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9+nglmast->a_10+nglmast->a_11
      endif
       if pperiod = "12"
      REPLACE NLBANK->OPEN_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
      +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
      +nglmast->a_9+nglmast->a_10+nglmast->a_11
          REPLACE NLBANK->close_BAL WITH nglmast->a_1+nglmast->a_2+nglmast->a_3+nglmast->a_4;
            +nglmast->a_5+nglmast->a_6+nglmast->a_7+nglmast->a_8;
            +nglmast->a_9+nglmast->a_10+nglmast->a_11+nglmast->a_12
      endif
      endif
      select NLBANK
      skip
      if eof()
      eofNLBANK = .t.
      endif
      
      
Procedure nlcash_rtn
            select nlbankc
            seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+pperiod
            if .not. found()
            append blank
            replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace period with pperiod
      replace payments with 0
      replace receipts with 0
      replace adjusts with 0
      REPLACE nlbankc->OPEN_BAL with 0
      REPLACE nlbankc->close_BAL with 0
      replace deposits with 0
      endif
      replace PAYMENTS with PAYMENTS + FGNFPUR->total
        
       pcashbook = "P"   && PAYMENTS
        
      select nlcashc
        seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+pperiod+pcashbook+dtos(pshdate)+psys+pdoc+pserial
            if .not. found()
            append blank
            replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace system with psys
      replace doctype with pdoc
      replace serialno with pserial
      replace acc with pacc
      replace period with pperiod
      replace total with 0
      replace cashbook with pcashbook
      replace trans_date with pshdate
        endif
       replace total with total - FGNFPUR->total
       
Procedure nlBANK_rtn
    
            select NLBANK
            seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+pperiod
            if .not. found()
            append blank
            replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      replace acc with pacc
      replace period with pperiod
      replace payments with 0
      replace receipts with 0
      replace adjusts with 0
      REPLACE NLBANK->OPEN_BAL with 0
      REPLACE NLBANK->close_BAL with 0
      replace deposits with 0
      endif
      replace PAYMENTS with PAYMENTS + FGNFPUR->total
        
       pcashbook = "P"   && PAYMENTS
      select nlcash
        seek pyear+pcoy+pccentre+ppcentre+pactype+pacclass+pacc+pperiod+pcashbook;
        +dtos(pshdate)+psys+pdoc+pserial
            if .not. found()
            append blank
            replace year with pyear
      replace coy with pcoy
      replace ccentre with pccentre
      replace pcentre with ppcentre
      replace actype with pactype
      replace acclass with pacclass
      REPLACE SYSTEM WITH PSYS
      replace acc with pacc
      replace period with pperiod
      replace total with 0
      replace cashbook with pcashbook
      replace serialno with pserial
      replace trans_date with pshdate
      replace doctype with pdoc
       endif
       
       replace total with total - FGNFPUR->total
        