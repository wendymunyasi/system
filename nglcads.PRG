**************************************************************************
*  PROGRAM:      NGLCADS
*
*******************************************************************************

Procedure NGLCADS
 PARAMETER BUSER,BLEVEL
create session
set talk off
set ldCheck off
set decimals to 4
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting CREDIT CARDS to the GL and CB in progress... ",MDI .F.,;
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
      
    set view to "NGLCADS.qbe"
PRIVATE EOFfgvistrn,PYEAR,PPERIOD,PCOY,PCCENTRE,PACTYP,PACCLASS,PACC,psys,pshdate,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,ptyp,pcla,pcod,ppwk,eofwkprices,pcwk,PPRICE,;
pcashbook,eofnlbankc
 PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
    SELECT FGSUMSLS
    SET ORDER TO MKEY
SELECT NGLYEARS
   SET ORDER TO MKEY
   
   EOFfgvistrn = .F.
   select fgtyp
   
   EOFfgvistrn = .F.
   SELECT ngltran
   SET ORDER TO TKEY
         SELECT nglMAST
   SET ORDER TO MKEY
         SELECT NGPERIOD
       SET ORDER TO TKEY  
      SELECT fgvistrn
   set filter to empty(gl_post) .AND. (doctype = "16" .or. doctype = "28");
   .and. (system = "AR" .or. system = "CD") .and. .not. total = 0 ;
   .and. .not. empty(coy)   .and. .not. empty(div) .and. .not. empty(cen);
         .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod)
  
      GO TOP
      IF .NOT. EOF()
         DO 
            DO RTN2
            UNTIL EOFfgvistrn
            endif
            
        
            
                progreps.close()
    CLOSE DATABASES
    CLEAR PROGRAM

 PROCEDURE RTN2
     local ldd,lmm
    ldd = dtos(fgvistrn->order_date)  && yyyymmdd
    lmm = right(left(ldd,6),2)
    pyear = left(ldd,4)
    pperiod = lmm
 pcoy = "1"
      pccentre = "5" && profit centre
      ppcentre = '1'
      pactype = "4"    && current assets
      pacclass = "C0"
      pacc = "1000"
      psys = fgvistrn->system
      pshdate = fgvistrn->order_date
      pdoc = fgvistrn->doctype
       pserial = fgvistrn->order_no
      pamt = fgvistrn->total 
      pqty = 0
        SELECT NGLYEARS
      SEEK "1"+PYEAR
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE COY WITH "1"
      REPLACE YEAR WITH PYEAR
      ENDIF
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
      do PAY_DR_RTN  && total payments debited
      else
      if pamt < 0
      pamt = pamt * -1
      do PAY_CR_RTN
      endif
      endif
     endif
    
      pactype = "1"
      pcoy = fgvistrn->coy
      pccentre = fgvistrn->div  && credit a/c   
      ppcentre = fgvistrn->cen  && credit a/c   
      pacclass = fgvistrn->typ
      pacc = fgvistrn->cla+fgvistrn->cod
      psys = fgvistrn->system
      pshdate = fgvistrn->order_date
      pdoc = fgvistrn->doctype
      pamt = (fgvistrn->total - fgvistrn->tax_amt) * -1
      pqty = fgvistrn->qty 
      if  .not. pamt = 0
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
      
 pactype = "6"
      pcoy = "1"
      pccentre = "5"   
      ppcentre = '1'
      pacclass = "L0"
      pacc = "4000"
      psys = fgvistrn->system
      pshdate = fgvistrn->order_date
      pdoc = fgvistrn->doctype
      pamt = fgvistrn->tax_amt * -1
      pqty = 0 
      if  .not. pamt = 0
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
         
       select fgvistrn     
       replace gl_post   with date()   
       if .not. eof()
      SKIP
      endif
     IF EOF()
     EOFfgvistrn = .T.
     ENDIF
   
      PROCEDURE FGSUMSLS_RTN
    PCOY = FGVISTRN->COY
    PDIV = FGVISTRN->DIV
    PCEN = FGVISTRN->CEN
    PTYP = FGVISTRN->TYP
    PCLA = FGVISTRN->CLA
    PCOD = FGVISTRN->COD
    PDAT = FGVISTRN->ORDER_DATE
    PQTY = FGVISTRN->QTY
    PLIS = FGVISTRN->LIST_PRICE
    PTOT = FGVISTRN->TOTAL
    PTAX = FGVISTRN->TAX_RATE
    PTAXA = FGVISTRN->TAX_AMT
    PNONV = FGVISTRN->TOTAL_AMT
    IF PNONV = 100
    PNONV = 0
    ENDIF
    PMOB = 0
    PINV = 0
    PPOS = 0
    PVIS = 0
    PNONVA = PNONV * PQTY * -1
    IF FGVISTRN->SOURCE = '3' .AND. FGVISTRN->FRIGHTER_N = '0001'
    PPOS = FGVISTRN->TOTAL
    ELSE
    PVIS = FGVISTRN->TOTAL
    ENDIF
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
       REPLACE ZERO_AMT WITH 0
       REPLACE POS WITH 0
       ENDIF
       REPLACE TOTAL WITH TOTAL + PTOT
       REPLACE QTY WITH QTY + PQTY
      *REPLACE CASH WITH CASH + PTOT
       REPLACE TAX_AMT WITH TAX_AMT + PTAXA
       IF PTAX = 0 .AND. PTAXA = 0
       REPLACE ZERO_AMT WITH ZERO_AMT + PTOT
       ENDIF
       REPLACE NONVAT_AMT WITH NONVAT_AMT + PNONVA
       REPLACE VISA WITH VISA + PVIS
       REPLACE POS WITH POS + PPOS
       
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
        
 
