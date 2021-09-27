**************************************************************************
*  PROGRAM:      fgshcatP.prg
*
*
*******************************************************************************


procedure fgshcatP
parameter buser,blevel
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Extracting Phase I Sales Records in progress... ",MDI .F.,;
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
    ColorNormal "n+"
    PROGREPS.OPEN()
  create session
set talk off
set ldCheck off
set escape off
set decimals to 4
set date to british
set view to "fgshcatP.qbe"
PLUSER = BUSER
PLEVEL = BLEVEL
set reprocess to 10
       EOFDACATSUM = .f.
       select monsales
       set  order to mkey
       select monpurch
       set order to mkey
        select fgdasal2
      set order to mkey
       select fgdasal
       set order to mkey
        select fgmonsal
       set order to mkey
        SELECT fgmmperf
       SET ORDER TO MKEY
       SELECT fgddperf2
        SET ORDER TO MKEY
         SELECT fgddperf
       SET ORDER TO MKEY
       SELECT fgmmperf2
        SET ORDER TO MKEY
      
                 
           EOFDACATSUM = .f.
              select dacatsum
  set  filter to  .not. (cs_sal_qty =0 .and. cs_sal_shs = 0 .and. cr_sal_qty =0 .and. cr_sal_shs = 0) ;
         .and. .not. empty(shift_date)
go top
        if .not. eof()
       do
       do dacatsum_rtn0
       until EOFDACATSUM
       endif
    eoffgdasal = .f.
     select fgdasal2
     set order to mkey
     select fgdasal
      set order to mkey
      set filter to .not. empty(shift_date)
            go top
            if .not. eof()
               do 
              do fgdasal_new_rtn
            until eoffgdasal
         endif
         eofdacatpur = .f.
         select dacatpur
         go  top
         if .not. eof()
            do
            do pur_rtn
          until eofdacatpur
          endif
          do fgdsal_rtn
       close databases
      progreps.close()
      QUIT
Procedure fgdsal_rtn
pcsq = 0
pcrq = 0
pcsa = 0
pcra = 0
select fgdasal
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
close databases
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
procedure fgdasal_new_rtn
       poshyy = year(fgdasal->shift_date)
       poshmm = month(fgdasal->shift_date)
       pnshyy = year(fgdasal->shift_date)
       pnshmm = month(fgdasal->shift_date)
       pnshdate = fgdasal->shift_date
       pyy = str(year(fgdasal->shift_date),4)
      pmm  = str(month(fgdasal->shift_date),2)
      IF VAL(PMM) < 10
      PMM = "0"+STR(VAL(PMM),1)
      ENDIF
     
    
    pcoy = fgdasal->coy
    ptyp = fgdasal->typ
    pcla = fgdasal->cla
      
       select fgmonsal
       seek pcoy+ptyp+pcla+pyy+pmm
       if found()
       pxend = .f.
         do
            do  fgdasal_new_rtn1
           until .not. (poshyy = pnshyy .or. poshmm = pnshmm) .or. pxend
           endif
           select fgdasal
           if .not. eof()
           skip
           else
           eoffgdasal = .t.
           endif
           if  eof()
           eoffgdasal = .t.
           endif
procedure fgdasal_new_rtn1
   pnshdate = pnshdate + 1
   pnshyy = year(pnshdate)
   pnshmm = month(pnshdate)
   if pnshyy = poshyy .and. pnshmm = poshmm
   do new_fgdasal_rtn
   else
   pxend = .t.
   endif
    
  
procedure new_fgdasal_rtn
 pyyn = str(year(pnshdate),4)
      pmmn  = str(month(pnshdate),2)
      IF VAL(PMMN) < 10
      PMMN = "0"+STR(VAL(PMMN),1)
      ENDIF
      
  select fgdasal2
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


Procedure dacatsum_rtn0
    pcoy = dacatsum->coy
    PDIV = dacatsum->DIV
    PCEN = dacatsum->CEN
    ptyp = dacatsum->typ
    pcla = dacatsum->cla
    PCOD = dacatsum->COD
    pshdate = dacatsum->shift_date
       pyy = str(year(dacatsum->shift_date),4)
      pmm  = str(month(dacatsum->shift_date),2)
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
   
    select fgmonsal
 seek pcoy+PTYP+PCLA+pyy+pmm
      
 if .not. found()
    APPEND BLANK
       replace coy with pCOY
          replace MM with pMM
         REPLACE YY WITH PYY
        replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with dacatsum->cs_sal_qty
         replace cs_sal_shs with dacatsum->cs_sal_shs
         replace cr_sal_shs with dacatsum->cr_sal_shs
         replace cr_sal_qty with dacatsum->cr_sal_qty
            ELSE
         replace cs_sal_qty with dacatsum->cs_sal_qty + cs_sal_qty
         replace cs_sal_shs with dacatsum->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with dacatsum->cr_sal_shs + cr_sal_shs
         replace cr_sal_qty with dacatsum->cr_sal_qty + cr_sal_qty
  ENDIF
  
 select fgdasal
    seek pcoy+PTYP+PCLA+DTOS(pshdate)
    if .not. found()
    APPEND BLANK
      replace coy with pCOY
          replace shift_date with pshdate
         replace typ with ptyp
         replace CLA with pcla
         replace cs_sal_qty with dacatsum->cs_sal_qty
         replace cs_sal_shs with dacatsum->cs_sal_shs
         replace cr_sal_shs with dacatsum->cr_sal_shs
         replace cr_sal_qty with dacatsum->cr_sal_qty
             replace  mmcs_sal_q with 0
         replace  mmcs_sal_a with 0
         replace  mmcr_sal_a with 0
         replace  mmcr_sal_q with 0
         REPLACE YY WITH PYY
          REPLACE MM WITH PMM
         ELSE
          replace cs_sal_qty with dacatsum->cs_sal_qty + cs_sal_qty
         replace cs_sal_shs with dacatsum->cs_sal_shs + cs_sal_shs
         replace cr_sal_shs with dacatsum->cr_sal_shs + cr_sal_shs
         replace cr_sal_qty with dacatsum->cr_sal_qty + cr_sal_qty
  ENDIF
 
  replace mmcr_sal_q WITH fgmonsal->cr_sal_qty
  replace mmcr_sal_a WITH fgmonsal->cr_sal_shs
  replace mmcs_sal_q WITH fgmonsal->cs_sal_qty
  replace mmcs_sal_a WITH fgmonsal->cs_sal_shs
   

 
     
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
         
         replace sal_qty with sal_qty + dacatsum->cs_sal_qty+dacatsum->cr_sal_qty
         replace sal_shs with sal_shs + dacatsum->cs_sal_shs+dacatsum->cr_sal_shs
          replace sal_cr_qty with sal_cr_qty + dacatsum->cr_sal_qty
          replace sal_cr_shs with sal_cr_shs + dacatsum->cr_sal_shs
          
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
         
         
             
             LOCAL Ll1,L2,L3,L4,L5,L6,LPMM2,LPYY2,LPDD1
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
   ppmm = "0"+STR(L2,1)
   ELSE
   ppmm = STR(L2,2)
   ENDIF
   ppyy = STR(L3,4)
   LPDD1 = "00" && NULL NO PREVIOUS DATE
   
   ** PREVIOUS DATE INFORMATION
  
   
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
      
        
         replace cr_sal_qty with cr_sal_qty + dacatsum->cr_sal_qty
         replace cr_sal_shs with cr_sal_shs + dacatsum->cr_sal_shs
            replace cs_sal_qty with cs_sal_qty + dacatsum->cs_sal_qty
         replace cs_sal_shs with cs_sal_shs + dacatsum->cs_sal_shs
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
   
     ENDIF
     endif
     
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
         replace prev_date with pshdate
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
   
     ENDIF
     endif
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
   REPLACE JAN_A WITH JAN_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE JAN_Q WITH JAN_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
   
CASE PVMM =  2
   REPLACE FEB_A WITH FEB_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE FEB_Q WITH FEB_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  3
   REPLACE MAR_A WITH MAR_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE MAR_Q WITH MAR_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  4
   REPLACE APR_A WITH APR_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE APR_Q WITH APR_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  5
   REPLACE MAY_A WITH MAY_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE MAY_Q WITH MAY_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  6
   REPLACE JUN_A WITH JUN_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE JUN_Q WITH JUN_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  7
   REPLACE JUL_A WITH JUL_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE JUL_Q WITH JUL_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty   
CASE PVMM =  8
   REPLACE AUG_A WITH AUG_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE AUG_Q WITH AUG_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  9
   REPLACE SEP_A WITH SEP_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE SEP_Q WITH SEP_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  10
   REPLACE OCT_A WITH OCT_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE OCT_Q WITH OCT_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  11
   REPLACE NOV_A WITH NOV_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE NOV_Q WITH NOV_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
CASE PVMM =  12
   REPLACE DEC_A WITH DEC_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE DEC_Q WITH DEC_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
  OTHERWISE
  REPLACE DEC_A WITH DEC_A + dacatsum->cs_sal_shs + dacatsum->cr_sal_shs
   REPLACE DEC_Q WITH DEC_Q + dacatsum->cs_sal_qty + dacatsum->cr_sal_qty
ENDCASE
     
           select dacatsum
           if .not. eof()
         skip
         else
         EOFDACATSUM = .f.
         endif
        if eof()
        EOFDACATSUM = .t.
        endif

 procedure pur_rtn
    pcoy = dacatpur->coy
       ptyp = dacatpur->typ
    pcla = dacatpur->cla
    PCOD = dacatpur->COD
    pshdate = dacatpur->shift_date
     pyy = str(year(dacatpur->shift_date),4)
      pmm  = str(month(dacatpur->shift_date),2)
      IF VAL(PMM) < 10
      PMM = "0"+STR(VAL(PMM),1)
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
   REPLACE JAN_A WITH JAN_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE JAN_Q WITH JAN_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
   
CASE PVMM =  2
   REPLACE FEB_A WITH FEB_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE FEB_Q WITH FEB_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  3
   REPLACE MAR_A WITH MAR_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE MAR_Q WITH MAR_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  4
   REPLACE APR_A WITH APR_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE APR_Q WITH APR_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  5
   REPLACE MAY_A WITH MAY_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE MAY_Q WITH MAY_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  6
   REPLACE JUN_A WITH JUN_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE JUN_Q WITH JUN_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  7
   REPLACE JUL_A WITH JUL_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE JUL_Q WITH JUL_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty   
CASE PVMM =  8
   REPLACE AUG_A WITH AUG_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE AUG_Q WITH AUG_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  9
   REPLACE SEP_A WITH SEP_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE SEP_Q WITH SEP_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  10
   REPLACE OCT_A WITH OCT_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE OCT_Q WITH OCT_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  11
   REPLACE NOV_A WITH NOV_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE NOV_Q WITH NOV_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
CASE PVMM =  12
   REPLACE DEC_A WITH DEC_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE DEC_Q WITH DEC_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
  OTHERWISE
  REPLACE DEC_A WITH DEC_A + dacatpur->cs_pur_shs + dacatpur->cr_pur_shs
   REPLACE DEC_Q WITH DEC_Q + dacatpur->cs_pur_qty + dacatpur->cr_pur_qty
ENDCASE
select dacatpur
skip
if eof()
eofdacatpur = .t.
endif