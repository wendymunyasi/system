**************************************************************************
*  PROGRAM:      fgshcat.prg
*
*
*******************************************************************************

procedure fgshcat
  PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Extracting Sales Records in progress...Wait!",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePOinter 11,;
    ColorNormal "b+/Btnface"
    PROGREPS.OPEN()
  create session
set talk off
set ldCheck off
set escape off
set decimals to 4
SET CENTURY ON
set view to "fgshcat.qbe"
PLUSER = BUSER
PLEVEL = BLEVEL
set reprocess to 10000

  SELECT DACATSAL 
      
       
       SET ORDER TO MKEY
   
  SELECT MONPURCH
  
  SET ORDER TO MKEY
   SELECT MONSALES
   
  SET ORDER TO MKEY
   select fgdasal
   
       set order to mkey
        select fgmonsal
        
       set order to mkey
  
       eofshcatsum = .f.
       select fgdacash
       
       set order to mkey
       select fgmocash
       
       set order to mkey
       SELECT FGCEN
       SET ORDER TO MKEY
       SELECT FGCENALL
       
       SET ORDER TO  MKEY
       SELECT FGCOD
       SET ORDER TO MKEY
       SELECT DACATSUM 
      
       
       SET ORDER TO MKEY
        SELECT DACATPUR 
       
       
       SET ORDER TO MKEY
      *  SELECT fgmmperf
       
       
      * SET ORDER TO MKEY
       
      * SELECT fgddperf2
      
     *   SET ORDER TO MKEY
      
      *   SELECT fgddperf
       
       
      * SET ORDER TO MKEY
       
      * SELECT fgmmperf2
       
      *  SET ORDER TO MKEY
      
      
       
       SELECT mocatSUM
       
        SET ORDER TO MKEY
        SELECT mocatPUR
       
        SET ORDER TO MKEY
              select mocoysum
       
       set order to mkey
             
      
        select fgshupsl
go top
if .not. eof() .AND. .NOT. EMPTY(SHIFT_DATE)
quit
endif
IF EOF()
append blank
ENDIF
replace shift_date with date()
replace dde_user with pluser
replace dde_time with time()
DO fgdasal_new_rtn
   EOFSHCATSUM = .F.
       select shcatsum
                 set filter to empty(post_date) 
          GO TOP
    if .not. eof()
       do
       do shcatsum_rtn0
       until eofshcatsum
      SELECT FGCENALL
      REPLACE ALL C_OFF WITH N_OFF
      REPLACE ALL N_OFF WITH ""
      REPLACE ALL CS_DATE WITH NS_DATE
      REPLACE ALL NS_DATE WITH {}
       select dshiftbk
       go bottom
     *  if .not. empty(shift_date) .and. empty(post_date)
     *  do fgddperf_rtn
     *  endif
       SET SAFETY OFF
      select shcatsum
      set filter to empty(post_date)
      go top
      if  eof()
     ZAP
     SET SAFETY OFF
     endif
        do fgdsal_rtn
       pcoysh = fgcoy->shipname
       PWRCOD = FGCOY->WARE_COD
       endif
   
         
   
      set safety off
      select fgshupsl
      zap
      SET SAFETY OFF
         close databases
            close databases
        SET SAFETY ON
      progreps.close()
       

procedure fgdasal_new_rtn
eofshcatsum = .f.
select shcatsum
set filt to typ >='00' .and. typ <='9Z'
go top
if .not. eof()
do 
do fgdasal_new_rtn1
until eofshcatsum
endif

Procedure fgdasal_new_rtn1
         pnshdate = shcatsum->shift_date
         pyyn = str(year(shcatsum->shift_date),4)
      pmmn  = str(month(shcatsum->shift_date),2)
      IF VAL(PMMN) < 10
      PMMN = "0"+STR(VAL(PMMN),1)
      ENDIF
     pcoy = shcatsum->coy
    ptyp = shcatsum->typ
    pcla = shcatsum->cla
     
  select fgdasal
  seek pcoy+PTYP+PCLA+DTOS(pnshdate)
    if .not. found()
    APPEND BLANK
       replace coy with pcoy
          replace typ with ptyp
         replace cla with pcla
         replace shift_date with pnSHDATE
         replace cs_sal_qty with 0
         replace cr_sal_qty with 0
         replace cs_sal_shs with 0
         replace cr_sal_shs with 0
          REPLACE YY WITH PYYN
          REPLACE MM WITH PMMN
      replace mmcr_sal_q WITH 0
      replace mmcr_sal_a WITH 0
      replace mmcs_sal_q WITH 0
      replace mmcs_sal_a WITH 0
     endif
      
      select shcatsum
      skip
      if eof()
      eofshcatsum = .t.
      endif
      
procedure fgdsal_rtn
pcsq = 0
pcrq = 0
pcsa = 0
pcra = 0
select fgdasal
set filter to
set order to mkey
go top
eoffgdasal = .f.
pfirst =.t.
select fgdasal
go top
pctypcla = typ+cla
pcsmm = month(shift_date)
pcsyy = year(shift_date)
if .not. eof()
do
   do fgdsal_rtn1
until eoffgdasal
endif
procedure fgdsal_rtn1
if pfirst
pfirst =.f.
replace mmcs_sal_q with cs_sal_qty
replace mmcr_sal_q with cr_sal_qty
replace mmcs_sal_a with cs_sal_shs
replace mmcr_sal_a with cr_sal_shs
pcsq = mmcs_sal_q
pcrq = mmcr_sal_q
pcsa = mmcs_sal_a
pcra = mmcr_sal_a
do skip2_rtn
else
do check_status
endif


Procedure skip2_rtn
   select fgdasal
   skip
   if eof()
   eoffgdasal = .t.
   endif
  
procedure check_status
   if typ+cla = pctypcla .and. month(shift_date) = pcsmm .and. year(shift_date) = pcsyy && same product same period
   replace mmcs_sal_q with cs_sal_qty + pcsq
   replace mmcr_sal_q with cr_sal_qty + pcrq
   replace mmcs_sal_a with cs_sal_shs + pcsa
   replace mmcr_sal_a with cr_sal_shs + pcra
   pcsq = mmcs_sal_q
   pcrq = mmcr_sal_q
   pcsa = mmcs_sal_a
   pcra = mmcr_sal_a
   do skip2_rtn
   else
   do skip3_rtn && new product or new period
   endif
   
Procedure skip3_rtn
   pfirst =.t.
pctypcla = typ+cla
pcsmm = month(shift_date)
pcsyy = year(shift_date)

        
procedure fgddperf_rtn
      pshdate = dshiftbk->shift_date
      psd = dtos(pshdate) && yyyymmdd
      psy = left(psd,4) && yyyy
      psm = left(psd,6)  && YYYYMM
      psm = right(psm,2) && mm
      psd = right(psd,2) && dd
      eoffgmmperf = .f.
      select fgmmperf
      set filter to yy = psy .and. mm = psm
      go top
      if .not. eof()
         do
            do fgmmperf_rtn
            until eoffgmmperf
         endif
         SELECT DSHIFTBK
         replace post_date with date()
procedure fgmmperf_rtn
    pcoy = fgmmperf->coy
    ptyp = fgmmperf->typ
    pcla = fgmmperf->cla
    PCOD = fgmmperf->COD
    pshdate = dshiftbk->shift_date
      pyy = str(year(dshiftbk->shift_date),4)
      pmm  = str(month(dshiftbk->shift_date),2)
      IF VAL(PMM) < 10
      PMM = "0"+STR(VAL(PMM),1)
      ENDIF
      ppdate = dshiftbk->shift_date - 1
      pndate = dshiftbk->shift_date + 1
      ppyy = str(year(ppdate),4)
       l1 = val(pmm)
      pqtr = "9"
      ppqtr = "9"
      pnqtr = "9"
      if l1 = 1  .or. l1 = 2 .or. l1 = 3
      pqtr = "1"
      ppqtr = "4"
      pnqtr = "2"
      endif
       if l1 = 4  .or. l1 = 5 .or. l1 = 6
      pqtr = "2"
      ppqtr = "1"
      pnqtr = "3"
      endif
       if l1 = 7  .or. l1 = 8 .or. l1 = 9
      pqtr = "3"
      ppqtr = "2"
      pnqtr = "4"
      endif
       if l1 = 10 .or. l1 = 11 .or. l1 = 12
      pqtr = "4"
      ppqtr = "3"
      pnqtr = "1"
      endif
      
      if pmm = "12"
      pnmm = "01"
      pnyy = str(val(pyy)+1,4)
      else
      pnmm = str(val(pmm)+1,2)
      pnyy = pyy
      endif
      if pmm = "01"
      ppmm = "12"
      ppyy = str(val(pyy)-1,4)
      else
      ppmm = str(val(pmm)-1,2)
      ppyy = pyy
      endif
      IF VAL(PPMM) < 10
      PPMM = "0"+STR(VAL(PPMM),1)
      ENDIF
        IF VAL(PNMM) < 10
      PNMM = "0"+STR(VAL(PNMM),1)
      ENDIF
        IF VAL(PMM) < 10
      PMM = "0"+STR(VAL(PMM),1)
      ENDIF
      
             LOCAL Ll1,L2,L3,L4,L5,L6,LPMM1,LPYY1,LPMM2,LPYY2
   Ll1 = DAY(pshdate)
   L2 = MONTH(pshdate)
   L3 = YEAR(pshdate)
   IF L2 = 1
   L2 = 12
   L3 = L3 - 1
   ELSE
   L2 = L2 - 1
   ENDIF
   L6 = STR(Ll1,2)+"/"+STR(L2,2)+"/"+STR(L3,4)
   IF L2 < 10
   LPMM1 = "0"+STR(L2,1)
   ELSE
   LPMM1 = STR(L2,2)
   ENDIF
   LPYY1 = STR(L3,4)
   

         
                 select fgmmperf2 && next  month
 seek pcoy+PTYP+PCLA+PCOD+pnyy+pnmm 
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace MM with pnmm 
         REPLACE YY WITH pnyy 
               REPLACE PREV_MM WITH pmm   
         REPLACE PREV_YY WITH pyy   
         replace sal_qty with 0
         replace sal_shs with 0
         replace sal_cr_qty with 0
         replace sal_cr_shs with 0
         endif
                  select fgmmperf2 && previous month
 seek pcoy+PTYP+PCLA+PCOD+lpyy1+lpmm1
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace MM with lpmm1
         REPLACE YY WITH lpyy1
               REPLACE PREV_MM WITH mm    
         REPLACE PREV_YY WITH yy    
         replace sal_qty with 0
         replace sal_shs with 0
          replace sal_cr_qty with 0
         replace sal_cr_shs with 0
         endif
         
             
             LOCAL Ll1,L2,L3,L4,L5,L6,LPMM1,LPYY1,LPMM2,LPYY2,LPDD1
   Ll1 = DAY(pshdate)
   L2 = MONTH(pshdate)
   L3 = YEAR(pshdate)
   IF L2 = 1
   L2 = 12
   L3 = L3 - 1
   ELSE
   L2 = L2 - 1
   ENDIF
   L6 = STR(Ll1,2)+"/"+STR(L2,2)+"/"+STR(L3,4)
   IF L2 < 10
   LPMM1 = "0"+STR(L2,1)
   ELSE
   LPMM1 = STR(L2,2)
   ENDIF
   LPYY1 = STR(L3,4)
   LPDD1 = "00" && NULL NO PREVIOUS DATE
   
   ** PREVIOUS DATE INFORMATION
   
   LOCAL LP1,LP2,LP3,LP4,LP5,LP6,LP7
   LP1 = DTOS(PSHDATE) && YYYYMMDD
   LP1 = RIGHT(LP1,2) && DD  CURRENT DAY
   LP2 = LPMM1 && PREVIOUS MONTH MM
   LP3 = LPYY1 && PREVIOUS YEAR YYYY
   IF LP2 = "01" .OR. LP2 = "03" .OR. LP2 = "05" .OR. LP2 = "07" .OR. LP2 = "08" ;
    .OR. LP2 = "10" .OR. LP2 = "12"   
    LPDD1 = LP1  && 31 DAYS MONTH
    ENDIF
   IF LP1 = "31" .AND. (LP2 = "02" .OR. LP2 = "04" .OR. LP2 = "06" .OR. LP2 = "11" ;
    .OR. LP2 = "09")
    LPDD1 = "00" && NO PREVIOUS DATE
    ENDIF
     IF LP1 < "31" .AND. (LP2 = "04" .OR. LP2 = "06" .OR. LP2 = "11" ;
    .OR. LP2 = "09")
    LPDD1 = LP1  && 30 DAYS MONTHS
    ENDIF
    
     IF LP1 < "29" .AND. LP2 = "02"
    LPDD1 = LP1  && 28 DAYS FEBRUARY
    ENDIF
   
   LOCAL LX1,LX2,LX3,LX4,l6
   LX1 = "28"
   l6 = lx1+"/"+lp2+"/"+lp3
   LX2 = CTOD(l6)
   LX3 = LX2+1 && NEXT DATE
   LX4 = DTOS(LX3) && YYYYMMDD
   LX4 = RIGHT(LX4,2) && DD
   IF LP1 = "29" .AND. LP2 = "02" .AND. LX4 = "29"
   LPDD1 = LP1 && LEAP YEAR
   ENDIF
   IF LPDD1 = "00" && NULL NO PREVIOUS DATE
   LPDATE = {}
   ELSE
   l6 = lpdd1+"/"+lpmm1+"/"+lpyy1
   LPDATE = CTOD(L6)
   ENDIF
   
 select fgddperf && current date
 seek pcoy+PTYP+PCLA+PCOD+dtos(pshdate)
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace shift_date with pshdate
 replace shift_date with pshdate
         replace cr_sal_qty with 0
         replace cr_sal_shs with 0
         replace mmcs_sal_a with 0
         replace mmcs_sal_q with 0
         replace mmcr_sal_a with 0
         replace mmcr_sal_q with 0
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace lm_sal_qty with 0
         replace cr_sal_qty with 0
         replace cr_sal_shs with 0
           REPLACE LM_SAL_SHS WITH 0
         REPLACE PREV_DATE WITH LPDATE
*         endif
        replace mmcs_sal_q with fgmmperf->sal_qty - fgmmperf->sal_cr_qty
        replace mmcs_sal_a with fgmmperf->sal_shs - fgmmperf->sal_cr_shs
         replace mmcr_sal_q with  fgmmperf->sal_cr_qty
        replace mmcr_sal_a with fgmmperf->sal_cr_shs
      
     replace lm_sal_qty with fgmmperf2->sal_qty
       REPLACE LM_SAL_SHS WITH FGMMPERF2->SAL_SHS
     IF .NOT. EMPTY(LPDATE)
         select fgddperf2 && previous date
 seek pcoy+PTYP+PCLA+PCOD+DTOS(LPDATE)
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace SHIFT_DATE WITH LPDATE
         replace cr_sal_qty with 0
         replace cr_sal_shs with 0
         replace mmcs_sal_a with 0
         replace mmcs_sal_q with 0
         replace mmcr_sal_a with 0
         replace mmcr_sal_q with 0
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace lm_sal_qty with 0
           REPLACE LM_SAL_SHS WITH 0
            LOCAL LNX1N,LNX2N,LNX3N,LNX4N,LCDATEN
 LCDATEN = SHIFT_DATE
 LCYMD = DTOS(LCDATEN) && YYYYMMDD
 LCY =  LEFT(LCYMD,4) && YYYY
 LCM = LEFT(LCYMD,6)  && YYYYMM
 LCM = RIGHT(LCM,2) && MM
 LCD = RIGHT(LCYMD,2) && DD
 IF LCM = "01"  && January
    LLY = VAL(LCY)-1  && previous year
    LLM = 12 && December
    ELSE
    LLY = VAL(LCY) && same year
    LLM = VAL(LCM) - 1  && last month
  ENDIF
  LLY = STR(LLY,4) && YYYY - LAST YEAR
  IF LLM < 10
  LLM = "0"+STR(LLM,1)
  ELSE
  LLM = STR(LLM,2)
  ENDIF
   LNX6N = LCD+"/"+lLM+"/"+LLY
   LPXDATE = CTOD(LNX6N)
IF .NOT. DAY(LPXDATE) = VAL(LCD)
LPXDATE = {}
ENDIF

         REPLACE PREV_DATE WITH LPXDATE
         endif
     ENDIF
     
     *** NEXT DATE INFORMATION START
     LOCAL LP1,LP2,LP3,LP4,LP5,LP6,LP7
     LNDD1 = "00"
   LP1 = DTOS(PSHDATE) && YYYYMMDD
   LP1 = RIGHT(LP1,2) && DD  CURRENT DAY
   LP2 = PNMM && NEXT MONTH MM
   LP3 = PNYY  && NEXT YEAR YYYY
   
   IF LP2 = "01" .OR. LP2 = "03" .OR. LP2 = "05" .OR. LP2 = "07" .OR. LP2 = "08" ;
    .OR. LP2 = "10" .OR. LP2 = "12"   
    LNDD1 = LP1  && 31 DAYS MONTH
    ENDIF
   IF LP1 = "31" .AND. (LP2 = "02" .OR. LP2 = "04" .OR. LP2 = "06" .OR. LP2 = "11" ;
    .OR. LP2 = "09")
    LNDD1 = "00" && NO PREVIOUS DATE
    ENDIF
     IF LP1 < "31" .AND. (LP2 = "04" .OR. LP2 = "06" .OR. LP2 = "11" ;
    .OR. LP2 = "09")
    LNDD1 = LP1  && 30 DAYS MONTHS
    ENDIF
    
     IF LP1 < "29" .AND. LP2 = "02"
    LNDD1 = LP1  && 28 DAYS FEBRUARY
    ENDIF
   
   LOCAL LX1,LX2,LX3,LX4,l6
   LX1 = "28"
   l6 = lx1+"/"+lp2+"/"+lp3
   LX2 = CTOD(L6)
   LX3 = LX2+1 && NEXT DATE
   LX4 = DTOS(LX3) && YYYYMMDD
   LX4 = RIGHT(LX4,2) && DD
   IF LP1 = "29" .AND. LP2 = "02" .AND. LX4 = "29"
   LNDD1 = LP1 && LEAP YEAR
   ENDIF
   IF LNDD1 = "00" && NULL NO PREVIOUS DATE
   LnDATE = {}
   ELSE
   l6 = lndd1+"/"+pnmm+"/"+pnyy
   LNDATE = CTOD(l6)
   ENDIF
   
     
     *** NEXT DATE INFORMATION END
   
 endif
 
 select fgmmperf
 skip
 if eof()
    eoffgmmperf = .t.
    endif
    
Procedure shcatsum_rtn0
    pcoy = shcatsum->coy
    PDIV = SHCATSUM->DIV
    PCEN = SHCATSUM->CEN
    ptyp = shcatsum->typ
    pcla = shcatsum->cla
    PCOD = SHCATSUM->COD
    SELECT FGCOD
    SEEK PTYP+PCLA+PCOD
    PMATCODE = FGCOD->MAT_CODE
       SELECT FGCEN
    SEEK PCOY+PDIV+PCEN
   pshdate = shcatsum->shift_date
    pshno = shcatsum->shift_no 
      pyy = str(year(SHCATSUM->shift_date),4)
      pmm  = str(month(SHCATSUM->shift_date),2)
      IF VAL(PMM) < 10
      PMM = "0"+STR(VAL(PMM),1)
      ENDIF
     
      
      if pmm = "12"
      pnmm = "01"
      pnyy = str(val(pyy)+1,4)
      else
      pnmm = str(val(pmm)+1,2)
      pnyy = pyy
      endif
      if pmm = "01"
      ppmm = "12"
      ppyy = str(val(pyy)-1,4)
      else
      ppmm = str(val(pmm)-1,2)
      ppyy = pyy
      endif
      IF VAL(PPMM) < 10
      PPMM = "0"+STR(VAL(PPMM),1)
      ENDIF
        IF VAL(PNMM) < 10
      PNMM = "0"+STR(VAL(PNMM),1)
      ENDIF
        IF VAL(PMM) < 10
      PMM = "0"+STR(VAL(PMM),1)
      ENDIF
      
             LOCAL Ll1,L2,L3,L4,L5,L6,LPMM2,LPYY2
   Ll1 = DAY(pshdate)
   if ll1 < 10
   pday  = "0"+str(ll1,1)
   else
   pday = str(ll1,2)
   endif
   PDD = PDAY
   pndate = pday+"/"+pnmm+"/"+pnyy  && next month date
   ppdate = pday+"/"+ppmm+"/"+ppyy  && previous month date
   pPDATE = CTOD(ppdate) && prev monnth date
   pndate = ctod(pndate) && next month date
   if .not. month(ppdate) = val(ppmm)
   ppdate = {}
   endif
    if .not. month(pndate) = val(pnmm)
   pndate = {}
   endif
   pok = .t.
    IF .NOT. (SHCATSUM->CS_PUR_QTY = 0 .AND.  SHCATSUM->CS_PUR_SHS = 0 ;
      .AND. SHCATSUM->CR_PUR_QTY = 0 .AND. SHCATSUM->CR_PUR_SHS = 0)
      DO DACATPUR_RTN
      ENDIF
      IF .NOT. (SHCATSUM->CS_SAL_QTY = 0 .AND.  SHCATSUM->CS_SAL_SHS = 0 ;
      .AND. SHCATSUM->CR_SAL_QTY = 0 .AND. SHCATSUM->CR_SAL_SHS = 0)
   DO SALES_RTN
      ENDIF
      
           select shcatsum
        replace post_date with date()
        skip
        if eof()
        eofshcatsum = .t.
        endif
 PROCEDURE SALES_RTN
 lt1 = dtos(shcatsum->shift_date) && yyyymmdd
 pdd = right(lt1,2) && dd
 lt1 = left(lt1,6) && yyyymm
 pmm = right(lt1,2) && mm
 pyy = left(lt1,4) && yyyy
    pcoy = shcatsum->coy
    PDIV = SHCATSUM->DIV
    PCEN = SHCATSUM->CEN
    ptyp = shcatsum->typ
    pcla = shcatsum->cla
    PCOD = SHCATSUM->COD
    pshdate = shcatsum->shift_date
      select fgmonsal
 seek pcoy+PTYP+PCLA+pyy+pmm
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
          replace MM with pMM
         REPLACE YY WITH PYY
        replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with SHCATSUM->cs_sal_qty
         replace cs_sal_shs with SHCATSUM->cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs
         replace cr_sal_qty with SHCATSUM->cr_sal_qty
            ELSE
         replace cs_sal_qty with SHCATSUM->cs_sal_qty + cs_sal_qty
         replace cs_sal_shs with SHCATSUM->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs + cr_sal_shs
         replace cr_sal_qty with SHCATSUM->cr_sal_qty + cr_sal_qty
  ENDIF
  
 select fgdasal
    seek pcoy+PTYP+PCLA+DTOS(pshdate)
    if .not. found()
    APPEND BLANK
      replace coy with pCOY
          replace shift_date with pshdate
         replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with SHCATSUM->cs_sal_qty
         replace cs_sal_shs with SHCATSUM->cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs
         replace cr_sal_qty with SHCATSUM->cr_sal_qty
         REPLACE MM WITH PMM
            replace  mmcs_sal_q with 0
         replace  mmcs_sal_a with 0
         replace  mmcr_sal_a with 0
         replace  mmcr_sal_q with 0
         REPLACE YY WITH PYY
         
         ELSE
          replace cs_sal_qty with SHCATSUM->cs_sal_qty + cs_sal_qty
         replace cs_sal_shs with SHCATSUM->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs + cr_sal_shs
         replace cr_sal_qty with SHCATSUM->cr_sal_qty + cr_sal_qty
  ENDIF
 
  replace mmcr_sal_q WITH fgmonsal->cr_sal_qty
      replace mmcr_sal_a WITH fgmonsal->cr_sal_shs
      replace mmcs_sal_q WITH fgmonsal->cs_sal_qty
      replace mmcs_sal_a WITH fgmonsal->cs_sal_shs
   
       select mocatsum
 seek pcoy+PDIV+PCEN+PTYP+PCLA+PCOD+pyy+pmm
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
       REPLACE DIV WITH PDIV
       replace cen with pcen
       replace cod with pcod
         replace MM with pMM
         REPLACE YY WITH PYY
               REPLACE PREV_MM WITH ppmm
         REPLACE PREV_YY WITH ppyy
         
        replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with SHCATSUM->cs_sal_qty
         replace cs_sal_shs with SHCATSUM->cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs
         replace cr_sal_qty with SHCATSUM->cr_sal_qty
         
          
     
             ELSE
               
          
         replace cs_sal_qty with SHCATSUM->cs_sal_qty + cs_sal_qty
         replace cs_sal_shs with SHCATSUM->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs + cr_sal_shs
         replace cr_sal_qty with SHCATSUM->cr_sal_qty + cr_sal_qty
  ENDIF
   select DACATSAL
    seek pcoy+PDIV+PCEN+PTYP+PCLA+PCOD+DTOS(pshdate)
    if .not. found()
    APPEND BLANK
      replace coy with pCOY
      REPLACE DIV WITH PDIV
      replace cen with pcen
      replace cod with pcod
         replace shift_date with pshdate
         replace prev_date with ppdate
        replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace cr_sal_shs with 0
         replace cr_sal_qty with 0
         REPLACE MM WITH PMM
            replace  mmcs_sal_q with 0
         replace  mmcs_sal_a with 0
        replace  mmcr_sal_a with 0
       replace  mmcr_sal_q with 0
   
         replace gross_amt with 0
         replace tax_amt with 0
         replace nonvat_amt with 0
         replace nonvat with shcatsum->nonvat
         replace tax_rate with shcatsum->tax_rate
         replace cost_price with shcatsum->cost_price
         replace list_price with shcatsum->list_price
         REPLACE YY WITH PYY
         
         ENDIF 
         replace gross_amt with gross_amt + shcatsum->gross_amt
         replace tax_amt with tax_amt  + shcatsum->tax_amt
         replace nonvat_amt with nonvat_amt  + shcatsum->nonvat_amt
         replace cs_sal_qty with shcatsum->cs_sal_qty + cs_sal_qty
         replace cs_sal_shs with shcatsum->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with shcatsum->cr_sal_shs + cr_sal_shs
         replace cr_sal_qty with shcatsum->cr_sal_qty + cr_sal_qty
       replace mmcr_sal_q WITH mocatsum->cr_sal_qty
      replace mmcr_sal_a WITH mocatsum->cr_sal_shs
      replace mmcs_sal_q WITH mocatsum->cs_sal_qty
      replace mmcs_sal_a WITH mocatsum->cs_sal_shs
    select DAcatsum
    seek pcoy+PDIV+PCEN+PTYP+PCLA+PCOD+DTOS(pshdate)
    if .not. found()
    APPEND BLANK
      replace coy with pCOY
      REPLACE DIV WITH PDIV
      replace cen with pcen
      replace cod with pcod
         replace shift_date with pshdate
         replace prev_date with ppdate
        replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace cr_sal_shs with 0
         replace cr_sal_qty with 0
         REPLACE MM WITH PMM
            replace  mmcs_sal_q with 0
         replace  mmcs_sal_a with 0
         replace  mmcr_sal_a with 0
         replace  mmcr_sal_q with 0
   
          REPLACE YY WITH PYY
         
         ENDIF
          replace cs_sal_qty with cs_sal_qty + shcatsum->cs_sal_qty
         replace cs_sal_shs with cs_sal_shs + shcatsum->cs_sal_shs
         replace cr_sal_shs with cr_sal_shs + shcatsum->cr_sal_shs
         replace cr_sal_qty with cr_sal_qty + shcatsum->cr_sal_qty
          replace mmcr_sal_q WITH mocatsum->cr_sal_qty
           local wk1,wk2,wk3,wk4,wk5,wk6
           wk6 = shcatsum->nonvat_amt
         wk1 = shcatsum->cr_sal_qty+shcatsum->cs_sal_qty && total qty sold
         wk2 = shcatsum->cr_sal_shs+shcatsum->cs_sal_shs && total shs sold
         wk3 = fgcod->vat && vat rate applicable
         if .not. wk1 = 0
         wk4 = wk2/wk1 && sale price
         else
         wk4 = 0
         endif
         if .not. wk3 = 0
         wk5 = (wk2-wk6)/(100+wk3)*100 && net excluding vat
         else
         wk5 = wk2
         endif
         replace net_vat with net_vat + wk5
         replace sale_price with wk4
      replace mmcr_sal_a WITH mocatsum->cr_sal_shs
      replace mmcs_sal_q WITH mocatsum->cs_sal_qty
      replace mmcs_sal_a WITH mocatsum->cs_sal_shs
              
          select mocoysum
         seek pyy+pmm+pcoy
         if .not. found()
         append blank
         replace yy with pyy
         replace mm with pmm
         replace coy with pcoy
         replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0
         endif
         replace cs_sal_shs with SHCATSUM->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with SHCATSUM->cr_sal_shs + cr_sal_shs
          replace cs_pur_shs with shcatsum->cs_pur_shs + cs_pur_shs
         replace cr_pur_shs with shcatsum->cr_pur_shs + cr_pur_shs
         
 *   DO FGMMPERF_RTN
      DO MONSALES_RTN
Procedure fgmmperf_rtn   
 select fgmmperf && current month
 seek pcoy+PTYP+PCLA+PCOD+pyy+pmm
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace MM with pMM
         REPLACE YY WITH PYY
               REPLACE PREV_MM WITH ppmm 
         REPLACE PREV_YY WITH ppyy
         replace sal_qty with 0
         replace sal_shs with 0
          replace sal_cr_qty with 0
         replace sal_cr_shs with 0
         endif
         
         replace sal_qty with sal_qty + shcatsum->cs_sal_qty+shcatsum->cr_sal_qty
         replace sal_shs with sal_shs + shcatsum->cs_sal_shs+shcatsum->cr_sal_shs
          replace sal_cr_qty with sal_cr_qty + shcatsum->cr_sal_qty
          replace sal_cr_shs with sal_cr_shs + shcatsum->cr_sal_shs
          
         local lwk1,lwk2,lwk3,lwk4
         lwk1 = sal_qty
         lwk2 = sal_shs
         
  
         
                          select fgmmperf2 && next  month
 seek pcoy+PTYP+PCLA+PCOD+pnyy+pnmm 
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace MM with pnmm 
         REPLACE YY WITH pnyy 
               REPLACE PREV_MM WITH pmm   
         REPLACE PREV_YY WITH pyy   
         replace sal_qty with 0
         replace sal_shs with 0
         replace sal_cr_qty with 0
         replace sal_cr_shs with 0
         endif
         
         
         
          
         select fgmmperf2 && previous month
 seek pcoy+PTYP+PCLA+PCOD+ppyy+ppmm 
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace MM with ppmm 
         REPLACE YY WITH ppyy
               REPLACE PREV_MM WITH mm    
         REPLACE PREV_YY WITH yy    
         replace sal_qty with 0
         replace sal_shs with 0
          replace sal_cr_qty with 0
         replace sal_cr_shs with 0
         endif
         
         
    
   
 select fgddperf && current date
 seek pcoy+PTYP+PCLA+PCOD+dtos(pshdate)
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace shift_date with pshdate
        replace cr_sal_qty with 0
         replace cr_sal_shs with 0
         replace mmcs_sal_a with 0
         replace mmcs_sal_q with 0
         replace mmcr_sal_a with 0
         replace mmcr_sal_q with 0
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace lm_sal_qty with 0
         replace cr_sal_qty with 0
         replace cr_sal_shs with 0
           REPLACE LM_SAL_SHS WITH 0
        
         REPLACE PREV_DATE WITH ppdate
         endif
         
         replace mmcs_sal_q with fgmmperf->sal_qty - fgmmperf->sal_cr_qty
        replace mmcs_sal_a with fgmmperf->sal_shs - fgmmperf->sal_cr_shs
         replace mmcr_sal_q with  fgmmperf->sal_cr_qty
        replace mmcr_sal_a with fgmmperf->sal_cr_shs
      
        
         replace cr_sal_qty with cr_sal_qty + shcatsum->cr_sal_qty
         replace cr_sal_shs with cr_sal_shs + shcatsum->cr_sal_shs
            replace cs_sal_qty with cs_sal_qty + shcatsum->cs_sal_qty
         replace cs_sal_shs with cs_sal_shs + shcatsum->cs_sal_shs
     replace lm_sal_qty with fgmmperf2->sal_qty
       REPLACE LM_SAL_SHS WITH FGMMPERF2->SAL_SHS
     
     
     IF .NOT. EMPTY(ppdate)
         select fgddperf2 && previous date
 seek pcoy+PTYP+PCLA+PCOD+DTOS(ppdate)     
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace SHIFT_DATE WITH ppdate
          replace cr_sal_qty with 0
         replace cr_sal_shs with 0
         replace mmcs_sal_a with 0
         replace mmcs_sal_q with 0
         replace mmcr_sal_a with 0
         replace mmcr_sal_q with 0
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace lm_sal_qty with 0
         replace cr_sal_qty with 0
         replace cr_sal_shs with 0
          REPLACE LM_SAL_SHS WITH 0
         endif
     ENDIF
        IF .NOT. EMPTY(pndate)
         select fgddperf2 && next date
 seek pcoy+PTYP+PCLA+PCOD+DTOS(pndate)     
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
         replace typ with ptyp
         replace CLA with pcla
       replace cod with pcod
         replace SHIFT_DATE WITH pndate
          replace cr_sal_qty with 0
         replace cr_sal_shs with 0
         replace mmcs_sal_a with 0
         replace mmcs_sal_q with 0
         replace mmcr_sal_a with 0
         replace mmcr_sal_q with 0
         replace cs_sal_qty with 0
         replace cs_sal_shs with 0
         replace lm_sal_qty with 0
         replace cr_sal_qty with 0
         replace cr_sal_shs with 0
          REPLACE LM_SAL_SHS WITH 0
         endif
     ENDIF
     
PROCEDURE MONSALES_RTN

 select MONSALES
  seek pyy+pcoy+ptyp+pcla+pcod
  if .not.  found()
  append blank
  replace year with pyy
  replace coy with pcoy
  replace typ with ptyp
  replace cla with pcla
  replace cod with pcod
  replace jan_q with 0
  replace jan_a with 0
  replace feb_q with 0
  replace feb_a with 0
  replace mar_q with 0
  replace mar_a with 0
  replace apr_q with 0
  replace apr_a with 0
  replace may_q with 0
  replace may_a with 0
  replace jun_a with 0
  replace jun_q with 0
  replace jul_q with 0
  replace jul_a with 0
  replace aug_q with 0
  replace aug_a with 0
  replace sep_q with 0
  replace sep_a with 0
  replace oct_q with 0
  replace oct_a with 0
  replace nov_q with 0
  replace nov_a with 0
  replace dec_a with 0
  replace dec_q with 0
  endif
  PVMM = VAL(PMM)
  DO CASE
CASE PVMM =  1
   REPLACE JAN_A WITH JAN_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE JAN_Q WITH JAN_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
   
CASE PVMM =  2
   REPLACE FEB_A WITH FEB_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE FEB_Q WITH FEB_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  3
   REPLACE MAR_A WITH MAR_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE MAR_Q WITH MAR_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  4
   REPLACE APR_A WITH APR_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE APR_Q WITH APR_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  5
   REPLACE MAY_A WITH MAY_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE MAY_Q WITH MAY_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  6
   REPLACE JUN_A WITH JUN_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE JUN_Q WITH JUN_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  7
   REPLACE JUL_A WITH JUL_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE JUL_Q WITH JUL_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty   
CASE PVMM =  8
   REPLACE AUG_A WITH AUG_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE AUG_Q WITH AUG_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  9
   REPLACE SEP_A WITH SEP_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE SEP_Q WITH SEP_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  10
   REPLACE OCT_A WITH OCT_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE OCT_Q WITH OCT_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  11
   REPLACE NOV_A WITH NOV_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE NOV_Q WITH NOV_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
CASE PVMM =  12
   REPLACE DEC_A WITH DEC_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE DEC_Q WITH DEC_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
  OTHERWISE
  REPLACE DEC_A WITH DEC_A + SHCATSUM->cs_sal_shs + SHCATSUM->cr_sal_shs
   REPLACE DEC_Q WITH DEC_Q + SHCATSUM->cs_sal_qty + SHCATSUM->cr_sal_qty
ENDCASE

       do update_pos_rtn
         
       
    
      PCOY = SHCATSUM->COY
      PDIV = SHCATSUM->DIV
      PCEN = SHCATSUM->CEN
      IF (SHCATSUM->TYP = "10" .OR. (SHCATSUM->TYP = "20" .AND. SHCATSUM->CLA = "00")) ;
       .AND. SHCATSUM->DIV = "1" .AND. (SHCATSUM->CEN = "7" .OR. SHCATSUM->CEN = "6" ;
        .or. shcatsum->cen = "8" .or. shcatsum->cen = "5"  .or. shcatsum->cen = "4") ;
      .AND. .NOT. SHCATSUM->CS_SAL_QTY = 0
      DO FGFCSALS_RTN
      ENDIF
       IF  SHCATSUM->typ > "20"  .AND. SHCATSUM->DIV = "1"  .AND. FGCOD->COMM_RATE > 0 ;
      .AND. .NOT.  SHCATSUM->CS_SAL_QTY = 0
      DO FGFILTER_RTN
      ENDIF
   
   
         
        PROCEDURE FGFILTER_RTN  
      SELECT FGCENALL  && OBTAIN OFF & SHIFT_DATE C_OFF N_OFF
            SEEK PCOY+PDIV+PCEN
               IF FOUND()
               DO FGFILTER_RTN2
            ENDIF
PROCEDURE FGFILTER_RTN2
            PDRATE = FGCEN->DAY_RATE
            PNRATE = FGCEN->NIGHT_RATE
            PVOL = FGCOD->VOLUME
            PQTYSOLD = SHCATSUM->CS_SAL_QTY && VOL SOLD
            IF SHCATSUM->SHIFT_DATE = FGCENALL->CS_DATE ;&& CURRENT SHIFT DATE
             .AND. SHCATSUM->SHIFT_NO = FGCENALL->CS_NO ;
              .AND. SHCATSUM->SHIFT_ID = FGCENALL->CS_ID
            DO FGFILTER_RTN3
            ELSE
            DO FGFILTER_RTN4
         ENDIF


PROCEDURE FGFILTER_RTN3  && CURRENT SHIFT
          IF SHCATSUM->SHIFT_NO = "0" && DAY SHIFT
          PRATE = FGCOD->COMM_RATE
          ELSE
          PRATE = FGCOD->COMM_RATE
          ENDIF
          SELECT FGFILTER
          APPEND BLANK
          REPLACE SHIFT_DATE WITH SHCATSUM->SHIFT_DATE
          REPLACE SHIFT_NO WITH SHCATSUM->SHIFT_NO
          REPLACE SHIFT_ID WITH SHCATSUM->SHIFT_ID
          REPLACE DIVCEN WITH SHCATSUM->DIV+SHCATSUM->CEN
          REPLACE TYP WITH SHCATSUM->TYP
          REPLACE CLA WITH SHCATSUM->CLA
          REPLACE COD WITH SHCATSUM->COD
          REPLACE QTY_SOLD WITH PQTYSOLD
          REPLACE COMM_RATE WITH PRATE
          REPLACE OFF WITH FGCENALL->C_OFF
          
PROCEDURE FGFILTER_RTN4  && NEXT SHIFT
          IF SHCATSUM->SHIFT_NO = "0" && DAY SHIFT
          PRATE = FGCOD->COMM_RATE
          ELSE
          PRATE = FGCOD->COMM_RATE
          ENDIF
         SELECT FGFILTER
          APPEND BLANK
          REPLACE SHIFT_DATE WITH SHCATSUM->SHIFT_DATE
          REPLACE SHIFT_NO WITH SHCATSUM->SHIFT_NO
          REPLACE SHIFT_ID WITH SHCATSUM->SHIFT_ID
          REPLACE DIVCEN WITH SHCATSUM->DIV+SHCATSUM->CEN
          REPLACE TYP WITH SHCATSUM->TYP
          REPLACE CLA WITH SHCATSUM->CLA
          REPLACE COD WITH SHCATSUM->COD
          REPLACE QTY_SOLD WITH PQTYSOLD
          REPLACE COMM_RATE WITH PRATE
          REPLACE OFF WITH FGCENALL->N_OFF


PROCEDURE FGFCSALS_RTN
         SELECT FGCEN  && OBTAIN DAY_RATE & NIGHT_RATE
         SEEK PCOY+PDIV+PCEN
            IF FOUND()
               DO FGFCSALS_RTN1
         ENDIF
PROCEDURE FGFCSALS_RTN1
      SELECT FGCENALL  && OBTAIN OFF & SHIFT_DATE C_OFF N_OFF
            SEEK PCOY+PDIV+PCEN
               IF FOUND()
               DO FGFCSALS_RTN2
            ENDIF
PROCEDURE FGFCSALS_RTN2
            PDRATE = FGCEN->DAY_RATE
            PNRATE = FGCEN->NIGHT_RATE
            PVOL = FGCOD->VOLUME
            PQTYSOLD = PVOL*SHCATSUM->CS_SAL_QTY && VOL SOLD
            IF SHCATSUM->SHIFT_DATE = FGCENALL->CS_DATE ;&& CURRENT SHIFT DATE
             .AND. SHCATSUM->SHIFT_NO = FGCENALL->CS_NO ;
              .AND. SHCATSUM->SHIFT_ID = FGCENALL->CS_ID
            DO FGFCSALS_RTN3
            ELSE
            DO FGFCSALS_RTN4
           ENDIF
PROCEDURE FGFCSALS_RTN3  && CURRENT SHIFT
          IF SHCATSUM->SHIFT_NO = "0" && DAY SHIFT
          PRATE = FGCEN->DAY_RATE
          ELSE
          PRATE = FGCEN->NIGHT_RATE
          ENDIF
          SELECT FGFCSALS
          APPEND BLANK
          REPLACE SHIFT_DATE WITH SHCATSUM->SHIFT_DATE
          REPLACE SHIFT_NO WITH SHCATSUM->SHIFT_NO
          REPLACE SHIFT_ID WITH SHCATSUM->SHIFT_ID
          REPLACE CEN WITH SHCATSUM->CEN
          REPLACE TYP WITH SHCATSUM->TYP
          REPLACE CLA WITH SHCATSUM->CLA
          REPLACE COD WITH SHCATSUM->COD
          REPLACE QTY_SOLD WITH PQTYSOLD
          REPLACE COMM_RATE WITH PRATE
          REPLACE OFF WITH FGCENALL->C_OFF
          
PROCEDURE FGFCSALS_RTN4  && NEXT SHIFT
          IF SHCATSUM->SHIFT_NO = "0" && DAY SHIFT
          PRATE = FGCEN->DAY_RATE
          ELSE
          PRATE = FGCEN->NIGHT_RATE
          ENDIF
         SELECT FGFCSALS
          APPEND BLANK
          REPLACE SHIFT_DATE WITH SHCATSUM->SHIFT_DATE
          REPLACE SHIFT_NO WITH SHCATSUM->SHIFT_NO
          REPLACE SHIFT_ID WITH SHCATSUM->SHIFT_ID
          REPLACE CEN WITH SHCATSUM->CEN
          REPLACE TYP WITH SHCATSUM->TYP
          REPLACE CLA WITH SHCATSUM->CLA
          REPLACE COD WITH SHCATSUM->COD
          REPLACE QTY_SOLD WITH PQTYSOLD
          REPLACE COMM_RATE WITH PRATE
          REPLACE OFF WITH FGCENALL->N_OFF
       
Procedure DACATPUR_RTN
   select DACATPUR
    seek pcoy+PDIV+PCEN+PTYP+PCLA+PCOD+DTOS(pshdate)
    if .not. found()
    APPEND BLANK
      replace coy with pCOY
      REPLACE DIV WITH PDIV
      replace cen with pcen
      replace cod with pcod
         replace shift_date with pshdate
        replace typ with ptyp
         replace CLA with pcla
        replace cs_pur_qty with SHCATSUM->cs_pur_qty
       replace cs_pur_shs with SHCATSUM->cs_pur_shs
        replace cr_pur_qty with  SHCATSUM->cr_pur_qty
         replace cr_pur_shs with SHCATSUM->cr_pur_shs
         REPLACE MM WITH PMM
         
         REPLACE YY WITH PYY
         
         ELSE
         replace cs_pur_qty with SHCATSUM->cs_pur_qty + cs_pur_qty
         replace cs_pur_shs with SHCATSUM->cs_pur_shs + cs_pur_shs
         replace cr_pur_qty with  SHCATSUM->cr_pur_qty + cr_pur_qty
        replace cr_pur_shs with SHCATSUM->cr_pur_shs + cr_pur_shs
  ENDIF
  select moCATPUR
 seek pcoy+PDIV+PCEN+PTYP+PCLA+PCOD+pyy+pmm
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
       REPLACE DIV WITH PDIV
       replace cen with pcen
       replace cod with pcod
         replace MM with pMM
         REPLACE YY WITH PYY
         
        replace typ with ptyp
         replace CLA with pcla
          replace cs_pur_qty with SHCATSUM->cs_pur_qty
         replace cs_pur_shs with SHCATSUM->cs_pur_shs
         replace cr_pur_qty with  SHCATSUM->cr_pur_qty
         replace cr_pur_shs with SHCATSUM->cr_pur_shs
         
          
     
             ELSE
               
          
        replace cs_pur_qty with SHCATSUM->cs_pur_qty + cs_pur_qty
         replace cs_pur_shs with SHCATSUM->cs_pur_shs + cs_pur_shs
         replace cr_pur_qty with  SHCATSUM->cr_pur_qty + cr_pur_qty
          replace cr_pur_shs with SHCATSUM->cr_pur_shs + cr_pur_shs
  ENDIF
       
 
  select monpurch
  seek pyy+pcoy+ptyp+pcla+pcod
  if .not.  found()
  append blank
  replace year with pyy
  replace coy with pcoy
  replace typ with ptyp
  replace cla with pcla
  replace cod with pcod
  replace jan_q with 0
  replace jan_a with 0
  replace feb_q with 0
  replace feb_a with 0
  replace mar_q with 0
  replace mar_a with 0
  replace apr_q with 0
  replace apr_a with 0
  replace may_q with 0
  replace may_a with 0
  replace jun_a with 0
  replace jun_q with 0
  replace jul_q with 0
  replace jul_a with 0
  replace aug_q with 0
  replace aug_a with 0
  replace sep_q with 0
  replace sep_a with 0
  replace oct_q with 0
  replace oct_a with 0
  replace nov_q with 0
  replace nov_a with 0
  replace dec_a with 0
  replace dec_q with 0
  endif
  PVMM = VAL(PMM)
  DO CASE
CASE PVMM =  1
   REPLACE JAN_A WITH JAN_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE JAN_Q WITH JAN_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
   
CASE PVMM =  2
   REPLACE FEB_A WITH FEB_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE FEB_Q WITH FEB_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  3
   REPLACE MAR_A WITH MAR_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE MAR_Q WITH MAR_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  4
   REPLACE APR_A WITH APR_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE APR_Q WITH APR_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  5
   REPLACE MAY_A WITH MAY_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE MAY_Q WITH MAY_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  6
   REPLACE JUN_A WITH JUN_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE JUN_Q WITH JUN_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  7
   REPLACE JUL_A WITH JUL_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE JUL_Q WITH JUL_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty   
CASE PVMM =  8
   REPLACE AUG_A WITH AUG_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE AUG_Q WITH AUG_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  9
   REPLACE SEP_A WITH SEP_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE SEP_Q WITH SEP_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  10
   REPLACE OCT_A WITH OCT_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE OCT_Q WITH OCT_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  11
   REPLACE NOV_A WITH NOV_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE NOV_Q WITH NOV_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
CASE PVMM =  12
   REPLACE DEC_A WITH DEC_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE DEC_Q WITH DEC_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
  OTHERWISE
  REPLACE DEC_A WITH DEC_A + SHCATSUM->cs_pur_shs + SHCATSUM->cr_pur_shs
   REPLACE DEC_Q WITH DEC_Q + SHCATSUM->cs_pur_qty + SHCATSUM->cr_pur_qty
ENDCASE


  
procedure update_pos_rtn
         LOCAL L1,L2,LCS,LOPC,LCDEBTS,LDBCRS,LCSTAFF
   L1 = shcatsum->COY
   L2 = shcatsum->SHIFT_DATE
   LCSS = shcatsum->CS_SAL_SHS
   LCRS = shcatsum->CR_SAL_SHS
   LOPC = 0
   LCDEBTS = 0
   LDBCRS = 0
   LCSTAFF = 0
  select fgdacash
        seek L1+DTOS(L2)
        if .not. found()
        append blank
        replace coy with L1
        replace shift_date with L2
        replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with  LOPC
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
         replace chq_sales with 0
        replace dr_staff with 0
      endif
      REPLACE SAL_CASH WITH SAL_CASH + LCSS
      REPLACE SAL_CREDIT WITH SAL_CREDIT + LCRS
      
       
      
      local l1,l2,l3,l4
         l1 = dtos(shcatsum->shift_date) && yyyymmdd
         l2 = left(l1,6) && yyyymm
         l3 = right(l2,2) && mm
         l4 = left(l2,4) && yyyy
         l1 = fgdacash->coy
         select fgmocash
         seek l1+l4+l3
         if .not. found()
         append blank
         replace coy with l1
         replace yy with l4
         replace mm with l3
         replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with 0
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
        replace dr_staff with 0
        replace chq_sales with 0
             endif
      REPLACE SAL_CASH WITH SAL_CASH + LCSS
      REPLACE SAL_CREDIT WITH SAL_CREDIT + LCRS
      
       
      
