**************************************************************************
*  PROGRAM:      NGLJOBS
*
*******************************************************************************

Procedure NGLJOBS
 PARAMETER BUSER,BLEVEL
create session
set talk off
set ldCheck off
set decimals to 4
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting JobCards to the GL and CB in progress... ",MDI .F.,;
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
      
    set view to "NGLJOBS.qbe"
*PRIVATE EOFFGJOBCAD,PYEAR,PPERIOD,PCOY,PCCENTRE,PACTYP,PACCLASS,PACC,psys,pshdate,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,ptyp,pcla,pcod,ppwk,eofwkprices,pcwk,PPRICE,;
pcashbook,eofnlbankc,PPCENTRE
 PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
    SELECT FGSUMSLS
    SET ORDER TO MKEY
    SELECT NGLYEARS
   SET ORDER TO MKEY

   EOFFGJOBCAD = .F.
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
   EOFFGJOBCAD = .F.
   SELECT ngltran
   SET ORDER TO TKEY
         SELECT nglMAST
   SET ORDER TO MKEY
         SELECT NGPERIOD
       SET ORDER TO TKEY  
      SELECT FGJOBCAD
   set filter to empty(gl_post) ;
   .and. .not. total = 0  .and. .not. empty(coy)  .and. .not. empty(div) .and. .not. empty(cen);
         .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .AND. .NOT. EMPTY(ORDER_DATE)
  
      GO TOP
      IF .NOT. EOF()
         DO 
            DO RTN2
            UNTIL EOFFGJOBCAD
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
     local ldd,lmm
    ldd = dtos(FGJOBCAD->order_date)  && yyyymmdd
    lmm = right(left(ldd,6),2)
    pyear = left(ldd,4)
    pperiod = lmm
 pcoy = "1"
      pccentre = "5" && profit centre
      ppcentre = "1" && profit centre
      pactype = "4"    && current assets
      pacclass = "C0"
      pacc = "0001"
      psys = FGJOBCAD->system
      pshdate = FGJOBCAD->order_date
      pdoc = FGJOBCAD->doctype
       pserial = ""
      pamt = FGJOBCAD->total 
      pqty = 0
        SELECT NGLYEARS
      SEEK "1"+PYEAR
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE COY WITH "1"
      REPLACE YEAR WITH PYEAR
      ENDIF
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
      if pamt > 0
      do PAY_DR_RTN  && total payments debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
         DO NLCASH_RTN
    
      pactype = "1"
      pcoy = FGJOBCAD->coy
      pccentre = FGJOBCAD->div  && credit a/c   
      ppcentre = FGJOBCAD->cen  && credit a/c   
      pacclass = FGJOBCAD->typ
      pacc = FGJOBCAD->cla+FGJOBCAD->cod
      psys = FGJOBCAD->system
      pshdate = FGJOBCAD->order_date
      pdoc = FGJOBCAD->doctype
      pamt = (FGJOBCAD->total - fgjobcad->tax_amt) * -1
      pqty = FGJOBCAD->qty 
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
         
      if pamt > 0
      do PAY_DR_RTN  && a/c debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
      
  pactype = "6"
      pcoy = "1"
      pccentre = "5" 
      ppcentre = '1'
      pacclass = "L0"
      pacc = "4000"
      psys = FGJOBCAD->system
      pshdate = FGJOBCAD->order_date
      pdoc = FGJOBCAD->doctype
      pamt = fgjobcad->tax_amt * -1
      pqty = 0 
      if .not. pamt = 0
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
         
      if pamt > 0
      do PAY_DR_RTN  && a/c debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
      endif
      DO FGSUMSLS_RTN
         
       select FGJOBCAD     
       replace gl_post   with date()   
        select FGJOBCAD  
       if .not. eof()
      SKIP
      endif
     IF EOF()
     EOFFGJOBCAD = .T.
     ENDIF
 PROCEDURE FGSUMSLS_RTN
    PCOY = FGJOBCAD->COY
    PDIV = FGJOBCAD->DIV
    PCEN = FGJOBCAD->CEN
    PTYP = FGJOBCAD->TYP
    PCLA = FGJOBCAD->CLA
    PCOD = FGJOBCAD->COD
    PDAT = FGJOBCAD->ORDER_DATE
    PQTY = FGJOBCAD->QTY
    PLIS = FGJOBCAD->LIST_PRICE
    PTOT = FGJOBCAD->TOTAL
    PTAX = FGJOBCAD->TAX_RATE
    PTAXA = FGJOBCAD->TAX_AMT
    PNONV = FGJOBCAD->SPRICE
    IF PNONV = 100
    PNONV = 0
    ENDIF
    PNONVA = PNONV * PQTY * -1
    SELECT FGSUMSLS
    SEEK PCOY+PDIV+PCEN+PTYP+PCLA+PCOD+DTOS(PDAT)
    IF .NOT. FOUND()
       APPEND BLANK
       REPLACE COY WITH PCOY
       REPLACE DIV WITH PDIV
       REPLACE CEN WITH PCEN
       REPLACE TYP WITH PTYP
       REPLACE CLA WITH PCLA
       REPLACE COD WITH PCOD
       REPLACE ORDER_DATE WITH PDAT
       REPLACE LIST_PRICE WITH PLIS
       REPLACE QTY WITH 0
       REPLACE TOTAL WITH 0
       REPLACE CASH WITH 0
       REPLACE MOBILE WITH 0
       REPLACE VISA WITH 0
       REPLACE INVOICE WITH 0
       REPLACE ZERO_AMT WITH 0
       REPLACE OTHER WITH 0
       REPLACE TAX_RATE WITH PTAX
       REPLACE TAX_AMT WITH 0
       REPLACE NONVAT WITH PNONV
       REPLACE NONVAT_AMT WITH 0
       REPLACE POS WITH 0
       ENDIF
       REPLACE TOTAL WITH TOTAL + PTOT
       REPLACE QTY WITH QTY + PQTY
       REPLACE CASH WITH CASH + PTOT
       REPLACE TAX_AMT WITH TAX_AMT + PTAXA
       IF PTAX = 0 .AND. PTAXA = 0
       REPLACE ZERO_AMT WITH ZERO_AMT + PTOT
       ENDIF
          REPLACE NONVAT_AMT WITH NONVAT_AMT + PNONVA
   
       
       
 Procedure PAY_DR_RTN
     
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
      replace RECEIPTS with RECEIPTS + FGJOBCAD->total
        
       pcashbook = "R"   && RECEIPTS
        
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
       replace total with total + FGJOBCAD->total
       
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
      replace DEPOSITS with DEPOSITS + FGJOBCAD->total
        
       pcashbook = "D"   && DEPOSITS
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
       
       replace total with total + FGJOBCAD->total
        