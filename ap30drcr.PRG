Procedure ap30drcr
   PARAMETER BUSER,BLEVEL

create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET REPROCESS TO 10000
    SET VIEW TO "ap30drcr.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
select apdrcrup
set order to mkey
SELECT FGMAST
SET ORDER TO MKEY
SELECT ST15F
SET ORDER TO MKEY
SELECT DACOYSUM
IF FLOCK()
SET ORDER TO MKEY
select fgcod
set order to mkey
select vendor
IF FLOCK()
set order to vendor
select vncount
IF FLOCK()
set order to mkey
select vnstat
IF FLOCK()
set order to mkey
SET SAFETY OFF
select vndocref
IF FLOCK()
set order to docref
SET SAFETY ON
pstockno = ""
      eofapdrcrln = .f.
      pposted = .t.
      select fgcoy
      go top
      ppfc = .t.
      LOCAL LBAD
      LBAD = .F.
         select apdrcrln 
         IF .NOT. LBAD
    set filter to grn_no = apdrcrs->grn_no .and. empty(post_date) .AND. .NOT. (total = 0 ;
   .and. qty = 0)  .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(grn_stk_no)
   
           go top
                if .not. eof()
  
                do
                do line_rtn
                until eofapdrcrln
 select apdrcrsN
                go top
                if eof()
                append blank
                endif
                replace GRN_no with apdrcrs->GRN_no
              
              ENDIF
              ENDIF
              ELSE
              WAIT 'UNABLE TO LOCK TABLES - TRY AGAIN LATER!'
              QUIT
              ENDIF
              ENDIF
              ENDIF
              ENDIF
              ENDIF
              
              CLOSE DATABASES
PROCEDURE END_RTN
      CLOSE DATABASES
procedure line_rtn
? "LINE SECTION"
            local l1,l2,l11,l22,l3,l4, lerr
               begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
            lerr = .t.
            select apdrcrup
            seek apdrcrln->grn_no+dtos(apdrcrs->grn_date)+apdrcrln->grn_stk_no+apdrcrln->DDE_TIME
            if .not. found()
            append blank
            replace grn_no with apdrcrln->grn_no
            replace grn_date with apdrcrs->grn_date
            replace grn_stk_no with apdrcrln->grn_stk_no
            REPLACE DDE_TIME WITH apdrcrln->DDE_TIME
            lerr = .f.
            endif
            if empty(apdrcrln->post_date)
            lerr = .f.
            endif
             if .not. lerr   
            select fgcoy
      go top
      if pospost = "Yes"
      ppfc = .t.
      else
      ppfc = .f.
      endif
          
         if ppfc
    select st15f
   go top
     pyear = str(year(apdrcrs->grn_date),4)
   pmonth = str(month(apdrcrs->grn_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
     if apdrcrln->total > 0
     pdoc = "15"
     else
   pdoc = "16"
   endif
    pshno = st15f->shift_no
    pshdate = apdrcrs->grn_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    else
      pyear = str(year(apdrcrs->grn_date),4)
   pmonth = str(month(apdrcrs->grn_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
 * pdoc = "16"
    pshno = "0"
    pshdate = apdrcrs->grn_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
    PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,P14,pvendor,;
            pven,PST15F,Pfgmast,Papdrcrs,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pvtyp,p18,p19,p20,ptsdte,pvsrce,pvtyp,pvpmod
            local lld1,lld2
            
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   if ppfc
      pshdate = apdrcrs->grn_date
    pshno = st15f->shift_no
    pshid = st15f->shift_id
    else
  pshno = "0"
    pshdate = apdrcrs->grn_date
    pshid = "0"
   
   endif
    
      PTYP = apdrcrln->TYP
      PCLA = apdrcrln->CLA
      PCOD = apdrcrln->COD
      PCOY = apdrcrln->COY
      PDIV = apdrcrln->DIV
      PCEN = apdrcrln->CEN
      PSTO = apdrcrln->STO
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      
      IF PSHM
            SELECT FGCOD
            SEEK PTYP+PCLA+PCOD
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if found()
      pstmast = .t.
      else
      pstmast = .f.
      endif
    
      
    ENDIF
 
      
    
                
              porder = apdrcrs->grn_no
                          pcashrno = apdrcrs->cashier_no
                              
                          pvsrce = apdrcrs->vsrce
                          pvpmod = apdrcrs->vpmod
                           pvtyp = apdrcrs->vtyp
                               pvendor = apdrcrs->vendor_N
      
        SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           pven = .T.
         ELSE
           pven = .F.
        ENDIF
           pstf = .f.
         PST15F = .f.
        
        
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
     
   
     
     pcredit = .t.
         
               pfdate = .T.
            ? "pstf"
            ? pstf
       PCASHR = .T.
    IF EMPTY(apdrcrln->POST_DATE) .and. pven .and. pstmast
    DO apdrcrln_3018RTN2
    ? "done"
      if apdrcrln->typ = "C0" .and. apdrcrln->cla = "00" .and. ;
                          apdrcrln->cod = "11"  && purchase from float
                            pvsrce = "1"
                          pvpmod = "1"
                           pvtyp = "1"
                               pvendor = "0001"
                                                SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           pven = .T.
         ELSE
           pven = .F.
        ENDIF
        IF PVEN
        DO DRTRAN_FLOAT
        ENDIF
        ENDIF
                    
    
            select apdrcrln  
            replace post_date with date()
  
   SELECT apdrcrup
   if .not. eof()
    replace post_date with date()
    endif
   endif
   endif
   commit()
   select apdrcrln  
   IF .NOT. EOF()
       SKIP
       ENDIF
    IF EOF()
     eofapdrcrln = .T.
    ENDIF
        
  
PROCEDURE DRTRAN_FLOAT
  
 
    pcoy = apdrcrln->coy
    pdate = apdrcrs->grn_date
    pcustno =  "0001"
    Pvtyp = "1"
    Pvpmod = "1"
    Pvsrce = "1"
      
    DO vnstat_FLOAT1
       
      SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE - apdrcrln->TOTAL 
      IF VENDOR->BAL_DUE > 0
      REPLACE VENDOR->BAL_DUE_CR with  0
      REPLACE VENDOR->BAL_DUE_DR with  VENDOR->BAL_DUE
      ELSE
      REPLACE VENDOR->BAL_DUE_DR with  0
      REPLACE VENDOR->BAL_DUE_CR with  VENDOR->BAL_DUE * -1
      ENDIF
     
     
    DO vnstat_FLOAT2
    
PROCEDURE vnstat_FLOAT1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lvtyp,lvpmod,lvsrce,lmm,lyy,ld
  
      lref = apdrcrs->grn_no
      ldate = apdrcrs->grn_date
      tdate = apdrcrs->grn_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = 'AP'
      ldoc = pdoc
      lcust = "0001"
      lvtyp = "1"
      Pvtyp = "1"
      lvpmod = "1"
      lvsrce = "1"
        select vnCOUNT
      seek lvsrce+lvtyp+lvpmod+LCUST+lyy+lmm
      if .not. found()
      append blank
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace yy with lyy
      replace mm with lmm
      replace count with "0000"
      REPLACE vtyp WITH Lvtyp
      REPLACE VENDOR_N WITH LCUST
      endif
      
      L1 = VAL(vnCOUNT->COUNT)
      L2 = L1 + 1
      L3 = STR(L2,5)
       select vndocref
     seek lvsrce+lvtyp+lvpmod+LCUST+lref
      if .not. found()
      append blank
      replace docref with lref
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace doctype with ldoc
        REPLACE vtyp WITH lvtyp
      REPLACE VENDOR_N WITH LCUST
      select vnCOUNT
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
       select vnstat
      seek lvsrce+lvtyp+lvpmod+LCUST+lyy+lmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE VENDOR_N WITH lcust
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace mm with lmm
      replace yy with lyy
      replace dd with right(dtos(ldate),2)
     REPLACE vtyp WITH lvtyp
               REPLACE MILEAGE WITH 0
               replace invoice with 0
              replace bl_dr with 0
             replace bl_cr with 0
             REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
             replace m_pay_amt with 0
             replace bal_this with 0
             replace bal_15 with 0
              replace bal_30 with 0
               replace bal_60 with 0
                replace bal_90 with 0
                 replace bal_120 with 0
                 replace alloc_tot with 0
                  replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                 replace alloc_AMT with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with apdrcrs->serialno
      replace REG        WITH apdrcrs->paytype
       replace sTIME       WITH ltime
        replace lpo with apdrcrs->lpo
         replace pay_method with apdrcrs->pay_method
*         replace recdate with apdrcrln->other_date
          replace sdate with ldate
         replace bbf with VENDOR->bal_due
                if vnstat->bbf < 0
            replace bbf_cr with VENDOR->bal_due* -1
            replace bbf_dr with 0
         else
            replace bbf_dr with VENDOR->bal_due
            replace bbf_cr with 0
         endif
 
         endif
       
 PROCEDURE vnstat_FLOAT2
    SELECT vnstat
    replace bal_due with VENDOR->bal_due
   if vnstat->bal_due < 0
         replace bal_due_cr with VENDOR->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENDOR->bal_due
         replace bal_due_cr with 0
         endif
    replace total with vnstat->total - apdrcrln->total
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
*       REPLACE BL_AMT WITH TOTAL  + apdrcrs->al_amt
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   if (apdrcrln->typ = "00" .or. apdrcrln->typ = "05") .and. (apdrcrln->cla = "00" .or. apdrcrln->cla = "10")
        replace sup_qty with sup_qty + apdrcrln->qty
        replace sup_price with apdrcrln->list_price
        else
          if (apdrcrln->typ = "00" .or. apdrcrln->typ = "05") .and. (apdrcrln->cla = "30" .or. apdrcrln->cla = "50")
        replace dis_qty with dis_qty + apdrcrln->qty
        replace dis_price with apdrcrln->list_price
        else
             if (apdrcrln->typ = "00" .or. apdrcrln->typ = "05") .and. apdrcrln->cla = "20"
        replace sup_qty with sup_qty + apdrcrln->qty
        replace sup_price with apdrcrln->list_price
        else
               if (apdrcrln->typ = "00" .or. apdrcrln->typ = "05") .and. apdrcrln->cla = "40"
        replace ker_qty with ker_qty + apdrcrln->qty
        replace ker_price with apdrcrln->list_price
        else
        replace svc_amt with svc_amt + apdrcrln->total
        endif
        endif
         endif
        endif
        

  PROCEDURE apdrcrln_3018RTN2
  
    padjin = 0
    padjout = 0
    ptranin = 0
    ptranout = 0
    pcss = 0
    PCSSA = 0
    pcspa = 0
    PCSP = 0
    pcrs = 0
    pcrsa = 0
    pcrp = 0
    pcrpa = 0
    ptvols = 0
    ptvolp = 0
    pvol = 0
    ptcost = 0
      psys   = 'AP'  && point of sale
       if apdrcrln->total > 0
     pdoc = "15"
     else
   pdoc = "16"
   endif
      pstockno = apdrcrln->grn_stk_no
    
      DO master_updt_rtn
         
        
      
  Procedure fgnfpur_3018RTN
        select fgnfpur
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with apdrcrln->coy
            replace div with apdrcrln->div
            replace cen with apdrcrln->cen
              replace sto with apdrcrln->sto
              replace st_coy with apdrcrln->coy
            replace st_div with apdrcrln->div
            replace st_cen with apdrcrln->cen
              replace st_sto with apdrcrln->sto
              
            replace typ with apdrcrln->typ
            replace cla with apdrcrln->cla
            replace cod with apdrcrln->cod
            replace qty with apdrcrln->QTY
            replace list_price with apdrcrln->list_price
            replace new_bal with 0
            replace total with apdrcrln->total
             replace tax_rate with apdrcrln->tax_rate
            replace tax_amt with apdrcrln->tax_amt
             replace job_order with apdrcrs->job_order
            replace off with apdrcrs->grn_off
             replace reg  with apdrcrs->reg
            replace gross_amt with apdrcrln->gross_amt
               replace pay_method  with apdrcrs->pay_method
             replace lpo with apdrcrs->lpo
           REPLACE vsrce WITH apdrcrs->vsrce
          REPLACE vtyp WITH apdrcrs->vtyp
           REPLACE vpmod WITH apdrcrs->vpmod
           REPLACE vendor_N WITH apdrcrs->vendor_N
             replace shift_no with apdrcrs->shiftno
           replace shift_id with apdrcrs->shiftid
           replace job_order with apdrcrs->job_order
           replace inv_no with apdrcrs->inv_no
           replace inv_date with apdrcrs->inv_date
           if empty(inv_date)
           replace inv_date with order_date
           endif
              replace cashier_no with apdrcrs->cashier_no
           replace bcoy  with apdrcrs->bcoy
           replace bcen  with apdrcrs->bcen
           replace bdiv  with apdrcrs->bdiv
           replace bsto  with apdrcrs->bsto
           replace btyp with apdrcrs->btyp
           replace bcla with apdrcrs->bcla
           replace bcod with apdrcrs->bcod
           replace dde_date with date()
           replace dde_user with PLUSER
           replace dde_time with time()
           REPLACE SERIALNO WITH apdrcrs->SERIALNO
           REPLACE SHIFT_NO WITH st15f->shift_no
           REPLACE SHIFT_ID WITH st15f->shift_id
             
         
      
           local l1,l2,l3,l4
             l1 = fgnfpur->order_no
              l2 = dtos(fgnfpur->order_date)
              l3 = fgnfpur->doctype
              l4 = fgnfpur->system
           
       
       
 Procedure DACOYSUM_3018RTN
           select DACOYSUM
          seek dtos(pshdate)+pcoy
          if .not. found()
          append blank
          replace coy with pcoy
          replace shift_date with pshdate
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
          endif
          
                IF PCREDIT
          replace cr_PUR_shs with cr_PUR_shs + apdrcrln->total 
        else
          replace cs_PUR_shs with cs_PUR_shs + apdrcrln->total 
          endif

          
    
 PROCEDURE sttran_purch_rtn
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = apdrcrs->grn_DATE
        psys = 'AP'
         if apdrcrln->total > 0
     pdoc = "15"
     else
   pdoc = "16"
   endif
        
         
         ppay = apdrcrs->PAY_METHOD
         pventno  =  pvendor
        *pvtyp = pvttrns->vtyp
        *pvsrce = apdrcrs->vsrce
        *pvpmod = apdrcrs->vpmod
                LOCAL D1,D2
                
              D1 = DTOS(apdrcrs->grn_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
              PCOY = apdrcrln->COY
              PDIV = apdrcrln->DIV
              PCEN = apdrcrln->CEN
              PTYP = apdrcrln->TYP
              PSTO = apdrcrln->STO
              PCLA = apdrcrln->CLA
              PCOD = apdrcrln->COD
              
                    
        PCASH = .F.
     PCREDIT = .F.
     pcheque = .f.
     IF ppay = "Cash" 
        pcash = .T.
         endif
     if ppay = "Cheque"  .or.  ppay = "Direct debit"  .or. ppay = "Visacard"
       pcheque = .t.
         endif
         if .not. pcheque .and. .not. pcash
         pcredit = .t.
         endif
       ptdate = apdrcrs->grn_DATE
              do fgnfpur_3018RTN
              do DACOYSUM_3018RTN
                 
            
           IF  (pcredit .or. ;
           (apdrcrln->typ = "C0" .and. apdrcrln->cla = "00" .and.  apdrcrln->cod = "11")) ;
            .AND. .NOT. apdrcrln->TOTAL = 0
                  do drtran_3018RTN
                   endif
  
   
          
     
 PROCEDURE master_updt_rtn
        DO sttran_purch_rtn
    
  

           
        
 PROCEDURE DRTRAN_3018RTN
  
       pdate = apdrcrs->grn_DATE
       pventno = pvendor
      * Pvtyp = apdrcrs->vtyp
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
       DO vnstat_3018RTN1
          SELECT vendor
      REPLACE vendor->BAL_DUE with  apdrcrln->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
     
         *    replace l_inv_date with apdrcrs->grn_DATE
          *   replace l_inv_amt with apdrcrln->total   + l_inv_amt
    
             
 
    DO vnstat_3018RTN2
 
        
PROCEDURE vnstat_3018RTN1
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = apdrcrs->grn_no
      ldate = apdrcrs->grn_DATE
      tdate = apdrcrs->grn_DATE
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = 'AP'
       if apdrcrln->total > 0
     ldoc = "15"
     else
   ldoc = "16"
   endif
      lvend = pvendor
      lvtyp = pvtyp
       select vncount
      seek lvsrce+lvtyp+lvpmod+lvend+pyy+pmm
      if .not. found()
      append blank
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace yy with pyy
      replace mm with pmm
      replace count with "0"
      REPLACE vtyp WITH Lvtyp
      REPLACE vendor_N WITH lvend
      endif
      L1 = VAL(vncount->COUNT)
      L2 = L1 + 1
      L3 = STR(L2,5)
       select vndocref
     seek lvsrce+lvtyp+lvpmod+lvend+lref
      if .not. found()
      append blank
      replace docref with lref
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace doctype with ldoc
        REPLACE vtyp WITH lvtyp
      REPLACE vendor_N WITH lvend
      select vncount
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
      **
       select vnstat
      seek lvsrce+lvtyp+lvpmod+lvend+pyy+pmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE vendor_N WITH lvend
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace mm with pmm
      replace yy with pyy
      replace dd with right(dtos(ldate),2)
      
           REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
             replace bl_dr with 0
             replace bl_cr with 0
              REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
    
         REPLACE vtyp WITH lvtyp
               REPLACE MILEAGE WITH 0
               replace invoice with 1
               REPLACE PAYMENT WITH 0
             replace bl_dr with 0
             replace bl_cr with 0
             REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
          
      REPLACE vnstat->SYSTEM     WITH lsys
      REPLACE vnstat->DOCTYPE    WITH ldoc
      REPLACE vnstat->DOCREF     WITH lref
      REPLACE vnstat->TRANS_DATE WITH tdate
      replace vnstat->serialno with apdrcrs->serialno
      REPLACE vnstat->REG        WITH apdrcrs->reg
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH apdrcrs->LPO
         replace vnstat->pay_method with apdrcrs->pay_method
            replace vnstat->alloc_AMT with 0
         replace vnstat->sdate with ldate
         replace vnstat->bbf with vendor->bal_due
                if vnstat->bbf < 0
            replace vnstat->bbf_cr with vendor->bal_due* -1
            replace vnstat->bbf_dr with 0
         else
            replace vnstat->bbf_dr with vendor->bal_due
            replace vnstat->bbf_cr with 0
         endif
    replace bal_this with 0
    replace bal_15   with 0
    replace bal_30   with 0
    replace bal_60   with 0
    replace bal_90   with 0
    replace bal_120  with 0
    replace inv_date with apdrcrs->inv_date
    replace inv_no with apdrcrs->inv_no
    replace inv_due with apdrcrs->inv_due
    replace off with apdrcrs->grn_off
    replace inv_py_amt with apdrcrs->inv_py_amt
     replace inv_py_ref with apdrcrs->inv_py_ref
      replace inv_status with apdrcrs->inv_status 
    
      replace vnstat->total with 0
        replace vnstat->amt_dr with 0
          replace vnstat->amt_cr with 0
          replace gratax_amt with 0
          replace gra_total with 0
          replace gra_gross with 0
          replace gra_cost with 0
       endif
      **
     
   PROCEDURE vnstat_3018RTN2
    SELECT vnstat
    replace vnstat->bal_due with vendor->BAL_DUE
   if vnstat->bal_due < 0
         replace vnstat->bal_due_cr with vendor->BAL_DUE* -1
         replace vnstat->bal_due_dr with 0
         else
         replace vnstat->bal_due_dr with vendor->BAL_DUE
         replace vnstat->bal_due_cr with 0
         endif
    replace vnstat->total with vnstat->total + apdrcrln->total 
    if vnstat->total < 0
         replace vnstat->amt_cr with vnstat->total* -1
         replace vnstat->amt_dr with 0
    else
         replace vnstat->amt_dr with vnstat->total
         replace vnstat->amt_cr with 0
      endif
    
    REPLACE BL_AMT WITH TOTAL
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
    
