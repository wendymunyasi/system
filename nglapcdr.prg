**************************************************************************
*  PROGRAM:      nglapcdr
*
*******************************************************************************

Procedure nglapcdr
    PARAMETER BUSER,BLEVEL
   clear program
create session
set talk off
set ldCheck off
set decimals to 4
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Vendor debit/credit notes to the GL in progress... ",MDI .F.,;
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
    MousePointer 11,;
    ColorNormal "n+"
PROGREPS.OPEN()
    
   set view to "nglapcdr.qbe"
PRIVATE EOFFGNFPUR,PYEAR,PPERIOD,PCOY,PCCENTRE,PACTYP,PACCLASS,PACC,psys,pshdate,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,ptyp,;
pcla,pcod,ppwk,eofwkprices,pcwk,PPRICE,per,pcashbook,PSERIALNO,eofnlbankc
   EOFFGNFPUR = .F.
   pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
SELECT NGLYEARS
   SET ORDER TO MKEY
   select fgtyp
   set order to typ
   SELECT ngltran
   SET ORDER TO TKEY
        
        SELECT nglMAST
   SET ORDER TO MKEY
         SELECT NGPERIOD
       SET ORDER TO TKEY
        
      SELECT FGNFPUR
      set filter to (doctype = "15" .or. doctype = "16") .and.  system = "AP" ;
      .AND. EMPTY(gl_post) .AND. .NOT. EMPTY(BTYP) .AND. ;
       .NOT. EMPTY(BCLA) .AND. .NOT. EMPTY(BCOD) .and. (pay_method = "Debit note" .or. ;
        pay_method = "Credit note" .OR. pay_method = "Debit/Credit")  ;
        .AND. .NOT. EMPTY(TYP) .AND.  .NOT. EMPTY(CLA) .and. .not. empty(cod)  ;
         .and. .not. empty(coy) .and. .not. empty(div) .and. .not. empty(cen) .and. .not. empty(sto) ;
         .and. .not. empty(bcoy) .and. .not. empty(bdiv) .and. .not. empty(bcen)
 GO TOP
      IF .NOT. EOF()
         DO 
            DO RTN2
            UNTIL EOFFGNFPUR
            endif
     
             progreps.close()
        CLOSE DATABASES
 PROCEDURE RTN2
 per = .f.
  local ldd,lmm
  if empty(fgnfpur->inv_date)
    ldd = dtos(FGNFPUR->order_date)  && yyyymmdd
    else
    ldd = dtos(FGNFPUR->inv_date)
    endif
    lmm = right(left(ldd,6),2)
    pyear = left(ldd,4)
    pperiod = lmm
   IF FGNFPUR->TYP <  "00" .OR. FGNFPUR->TYP > "9Z"  && NOT STOCK/SALES ITEMS
    select fgtyp
    seek FGNFPUR->typ
    if .not. found() .OR. EMPTY(ACTYPE)
    per = .t.
    endif
    ENDIF
      SELECT NGLYEARS
      SEEK "1"+PYEAR
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE COY WITH "1"
      REPLACE YEAR WITH PYEAR
      ENDIF
    select fgtyp
    seek FGNFPUR->btyp
    if .not. found() .OR. EMPTY(ACTYPE)
    per = .t.
    endif
    if .not. per
        pcoy = "1"
        pactype = "7"  && PURCHASES/COST OF SALES
    IF  FGNFPUR->TYP <  "00" .OR. FGNFPUR->TYP > "9Z"
   select fgtyp
   seek FGNFPUR->typ 
   pactype = fgtyp->actype
   ENDIF
   
   PACCLASS = FGNFPUR->typ
   PACC = FGNFPUR->cla+FGNFPUR->cod    && debit a/c
   PCCENTRE = fgnfpur->div
   PPCENTRE = fgnfpur->cen
      psys = FGNFPUR->system
       if empty(fgnfpur->inv_date)
      pshdate = FGNFPUR->order_date
      else
      pshdate = FGNFPUR->inv_date
      endif
      pdoc = FGNFPUR->doctype
      pamt = FGNFPUR->total * -1
      pserialno = FGNFPUR->order_no
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
      do REC_DR_RTN  && total receipts debited
      else
      if pamt < 0
      pamt = pamt * -1
      do REC_CR_RTN
      endif
      endif
      endif
      
      pccentre = fgnfpur->bdiv  && control centre
      PPCENTRE = fgnfpuur->bcen
      select fgtyp
      seek FGNFPUR->btyp
      pactype = fgtyp->actype    && current assets
      pacclass = FGNFPUR->btyp
      pacc = FGNFPUR->bcla+FGNFPUR->bcod
      psys = FGNFPUR->system
       if empty(fgnfpur->inv_date)
      pshdate = FGNFPUR->order_date
      else
      pshdate = FGNFPUR->inv_date
      endif
      pdoc = FGNFPUR->doctype
      pamt = FGNFPUR->total   && REVERSE THE SIGN
      pqty = 0
      if   .not. pamt = 0
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
      do REC_DR_RTN  && a/c debited
      else
      if pamt < 0
      pamt = pamt * -1
      do REC_CR_RTN
      endif
      endif
     ENDIF
     
       select FGNFPUR     
       replace gl_post with date()   
       if .not. eof()
      SKIP
      endif
     IF EOF()
     EOFFGNFPUR = .T.
     ENDIF
     else
     select FGNFPUR
     skip
     if eof()
     eofFGNFPUR = .t.
     endif
     endif
 Procedure REC_DR_RTN
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
   
   
  Procedure REC_CR_RTN
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
     
         

