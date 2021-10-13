Procedure gl30APOG
PARAMETER BUSER,BLEVEL
private postok
postok = .t.
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
   * SET AUTOSAVE ON
    SET VIEW TO "gl30APOG.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 10000
 
select fgcod
if flock()
 else
               Wait 'Unable to lock fgcod - Try Again Later!'
               quit
               endif
set order to mkey
select vendor
if flock()
 else
               Wait 'Unable to lock vendor - Try Again Later!'
               quit
               endif
set order to vendor
select vncount
if flock()
 else
               Wait 'Unable to lock vncount  - Try Again Later!'
               quit
               endif
set order to mkey
select vnstat
if flock()
 else
               Wait 'Unable to lock vnstat - Try Again Later!'
               quit
               endif
set order to mkey
SET SAFETY OFF
select vndocref
if flock()
 else
               Wait 'Unable to lock  vndocref - Try Again Later!'
               quit
               endif
set order to docref
SET SAFETY ON
pstockno = ""
      eofglpurchs = .f.
      pposted = .t.
      select fgcoy
      go top
       ppfc = .t.
          select glpurchs
          dele all for year(order_date) < 1 .or. (qty = 0 .and. total = 0)
         set filter to typ >= "00" .and. typ <= "9Z" .and.  qty = 0 .and. plevel > 4
         go top
         if  .not. EOF()
         postok =.f.
         endif
         IF postok
    set filter to empty(post_date) 
   ? "passed here 1"
           go top
                if .not. eof()
            do
                do line_rtn
                until eofglpurchs
       select fgcoy
              flush
              SET AUTOSAVE OFF
             endif
             endif
             if postok
             set safety off
             select glpurchs
             zap
             endif
              
              CLOSE DATABASES
              use \kenservice\data\vendor.dbf
              go top
              if .not. eof()
              close databases
              use \kenservice\data\vendors.dbf exclusive
              set safety off
              zap
              appe from \kenservice\data\vendor.dbf
              endif
              close databases
              
PROCEDURE END_RTN
      CLOSE DATABASES
procedure line_rtn
      begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
? "PASSED 2"
                do cont_rtn
                select glpurchs  
            replace post_date with date()
         
   COMMIT()
   
   select glpurchs  
   IF .NOT. EOF()
       SKIP
       ENDIF
    IF EOF()
     eofglpurchs = .T.
    ENDIF
procedure cont_rtn
          ppfc = .f.
     
      pyear = str(year(glpurchs->order_date),4)
   pmonth = str(month(glpurchs->order_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "24"
    pshno = "0"
    pshdate = glpurchs->order_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,P14,pvendor,;
            pven,PST15F,Pfgmast,Papogrns,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pvtyp,p18,p19,p20,ptsdte,pvsrce,pvtyp,pvpmod
            local lld1,lld2
            
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   pshno = "0"
    pshdate = glpurchs->order_date
    pshid = "0"
     
      PTYP = glpurchs->TYP
      PCLA = glpurchs->CLA
      PCOD = glpurchs->COD
      PCOY = glpurchs->COY
      PDIV = glpurchs->DIV
      PCEN = glpurchs->CEN
      PSTO = glpurchs->STO
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
            SELECT FGCOD
            SEEK PTYP+PCLA+PCOD
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
     if .not. found()
        Wait 'glpurchs - Problem with stock masterfile - Try Again Later!'
           quit
      endif
       
  
      
                
              porder = glpurchs->order_no
                          pcashrno = glpurchs->cashier_no
                          if glpurchs->btyp = "C0" .and. glpurchs->bcla = "00" .and. ;
                          glpurchs->bcod = "11"  && payment from float
                            pvsrce = "1"
                          pvpmod = "1"
                           pvtyp = "1"
                               pvendor = "0001"
                          else
                          if glpurchs->pay_method = "Loan" .and. .not. empty(glpurchs->source)
                          pvsrce = glpurchs->source
                          pvpmod = glpurchs->pmod
                           pvtyp = glpurchs->ftyp
                               pvendor = glpurchs->frighter_n
                          else
                          pvsrce = glpurchs->vsrce
                          pvpmod = glpurchs->vpmod
                           pvtyp = glpurchs->vtyp
                               pvendor = glpurchs->vendor_n
                               endif
                               endif
                       
           
   
      pfcmast =.t.
      
        SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           pven = .T.
         ELSE
           Wait 'glpurchs - Problem with vendor masterfile - Try Again Later!'
           quit
        ENDIF
        
        ? PVEN
        ? "VENDOR OK"
        pstf = .f.
         PST15F = .f.
            
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcapital = .f.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
     if glpurchs->pay_method = "Capital" 
      pcapital = .t.
     endif
      if glpurchs->pay_method = "FC Cash" .or. glpurchs->pay_method = "Float Cash" .OR. glpurchs->pay_method = "Cash" 
      pcash = .t.
     endif
   
       if glpurchs->pay_method = "Cheque" .or. glpurchs->pay_method = "Bank Debit";
       .or. glpurchs->pay_method = "Credit Card" .or. glpurchs->pay_method = "EFT";
        .or. glpurchs->pay_method = "Card(credit)"  .or. glpurchs->pay_method = "M-Money" .or. glpurchs->pay_method = "FT"
      pcheque = .t.
     endif
   
      if .not. pcash .and. .not. pcheque  .and. .not. pcapital
      pcredit = .t.
      endif
         ?  pven
         ? pstmast
         ? pfcmast
               pfdate = .T.
              PCASHR = .T.
 *   IF EMPTY(glpurchs->POST_DATE) .and. pven .and. pstmast   .and. pfcmast 
    DO glpurchs_3018RTN2
     ? "passed here 2"
    if glpurchs->TYP = "C0" 
       SELECT VENDOR
       REPLACE CDEP_AMT WITH CDEP_AMT + glpurchs->TOTAL
       ENDIF
          
         
  PROCEDURE glpurchs_3018RTN2
  
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
      psys   = 'GL'  && point of sale
      pdoc   = "24"  && Purchase
      pstockno = glpurchs->stock_no
    
     DO sttran_purch_rtn
         
        
      
  Procedure fgnfpur_3018RTN
        select fgnfpur
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with glpurchs->coy
            replace div with glpurchs->div
            replace cen with glpurchs->cen
              replace sto with glpurchs->sto
              replace st_coy with glpurchs->coy
            replace st_div with glpurchs->div
            replace st_cen with glpurchs->cen
              replace st_sto with glpurchs->sto
            replace typ with glpurchs->typ
            replace cla with glpurchs->cla
            replace cod with glpurchs->cod
            replace qty with glpurchs->QTY
              replace sale_qty  with glpurchs->sale_qty
            REPLACE DIP_Q_BOF WITH glpurchs->DIP_Q_BOF
            REPLACE DIP_Q_AOF WITH glpurchs->DIP_Q_AOF
              REPLACE OFLD_TIME WITH glpurchs->OFLD_TIME
            REPLACE DRIVER WITH glpurchs->DRIVER
            REPLACE OFLD_NAME WITH glpurchs->OFLD_NAME
            REPLACE GRN_ASHIP WITH glpurchs->GRN_ASHIP
            REPLACE SHIP_NAME WITH glpurchs->SHIP_NAME
            replace transp with glpurchs->transp
            REPLACE EXP_DIP_Q WITH glpurchs->EXP_DIP_Q
              REPLACE OFLD_VAR WITH glpurchs->OFLD_VAR
            REPLACE OFLD_VPERC WITH glpurchs->OFLD_VPERC
            replace return_qty with glpurchs->nonvat
            replace unit_cost with glpurchs->net_amt
            replace list_price with glpurchs->list_price
            replace new_bal with glpurchs->nonvat_amt
            replace total with glpurchs->total
             replace tax_rate with glpurchs->tax_rate
            replace tax_amt with glpurchs->tax_amt
             replace job_order with glpurchs->job_order
            replace off with glpurchs->off
             replace reg  with glpurchs->reg
            replace gross_amt with glpurchs->gross_amt
                replace pay_method  with glpurchs->pay_method
             replace lpo with glpurchs->lpo
           REPLACE vsrce WITH glpurchs->vsrce
          REPLACE vtyp WITH glpurchs->vtyp
           REPLACE vpmod WITH glpurchs->vpmod
           REPLACE vendor_N WITH glpurchs->vendor_N
           if .not. empty(glpurchs->source)
           REPLACE paysrce WITH glpurchs->source
          REPLACE paytyp WITH glpurchs->ftyp
           REPLACE paymod WITH glpurchs->pmod
           REPLACE pay_n WITH glpurchs->frighter_n
           else
              REPLACE paysrce WITH vsrce
          REPLACE paytyp WITH vtyp
           REPLACE paymod WITH vpmod
           REPLACE pay_n WITH vendor_n
    endif
        replace shift_no with glpurchs->shift_no
           replace shift_id with glpurchs->shift_id
           replace job_order with glpurchs->job_order
           replace inv_no with glpurchs->inv_no
           replace inv_date with glpurchs->inv_date
           replace inv_date with inv_date
              replace cashier_no with glpurchs->cashier_no
           replace bcoy  with glpurchs->bcoy
           replace bcen  with glpurchs->bcen
           replace bdiv  with glpurchs->bdiv
           replace bsto  with glpurchs->bsto
           replace btyp with glpurchs->btyp
           replace bcla with glpurchs->bcla
           replace bcod with glpurchs->bcod
           replace dde_date with glpurchs->dde_date
           replace dde_user with glpurchs->dde_user
           replace dde_time with glpurchs->dde_time
           REPLACE SERIALNO WITH glpurchs->serialno
           if empty(inv_no)
           replace inv_no with serialno
           endif
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
      
           
       
  PROCEDURE sttran_purch_rtn
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = glpurchs->order_date
        psys = 'GL'
        pdoc = "24"
        
         
         ppay = glpurchs->pay_method
         pventno  =  pvendor
        *pvtyp = pvttrns->vtyp
        *pvsrce = glpurchs->vsrce
        *pvpmod = glpurchs->vpmod
                LOCAL D1,D2
                
              D1 = DTOS(glpurchs->order_date)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
              PCOY = glpurchs->COY
              PDIV = glpurchs->DIV
              PCEN = glpurchs->CEN
              PTYP = glpurchs->TYP
              PSTO = glpurchs->STO
              PCLA = glpurchs->CLA
              PCOD = glpurchs->COD
              
                    
        PCASH = .F.
     PCREDIT = .F.
     pcapital = .f.
     pcheque = .f.
     IF ppay = "FC Cash" .or. ppay = "Float Cash"
        pcash = .T.
         endif
         IF ppay = "Capital" 
        pcapital = .T.
         endif
     if ppay = "Cheque"  .or.  ppay = "Bank Debit"  .or. ppay = "Card(credit)";
     .or. ppay = "M-Money"  .or. glpurchs->pay_method = "FT"
       pcheque = .t.
         endif
         if .not. pcheque .and. .not. pcash  .and. .not. pcapital
         pcredit = .t.
         endif
       ptdate = glpurchs->order_date
              do fgnfpur_3018RTN
                          
       
           IF  pcredit .or. ;
           (glpurchs->btyp = "C0" .and. glpurchs->bcla = "00" .and.  glpurchs->bcod = "11")
                  do drtran_3018RTN
                   endif
  
  
        
 PROCEDURE DRTRAN_3018RTN
  
       pdate = glpurchs->order_date
       pventno = pvendor
      * Pvtyp = glpurchs->vtyp
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
       DO vnstat_3018RTN1
          SELECT vendor
      REPLACE vendor->BAL_DUE with  glpurchs->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
     
             replace l_inv_date with glpurchs->order_date
             replace l_inv_amt with glpurchs->total   + l_inv_amt
    
             
 
    DO vnstat_3018RTN2
   
   

PROCEDURE vnstat_3018RTN1
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = glpurchs->order_no
      ldate = glpurchs->order_date
      tdate = glpurchs->order_date
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = 'GL'
      ldoc = "24"
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
             replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
             
      REPLACE vnstat->SYSTEM     WITH lsys
      REPLACE vnstat->DOCTYPE    WITH ldoc
      REPLACE vnstat->DOCREF     WITH lref
      REPLACE vnstat->TRANS_DATE WITH tdate
      replace vnstat->serialno with glpurchs->serialno
      REPLACE vnstat->REG        WITH glpurchs->reg
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH glpurchs->lpo
         replace vnstat->pay_method with glpurchs->pay_method
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
    replace inv_date with glpurchs->inv_date
    replace inv_no with glpurchs->inv_no
    replace inv_due with glpurchs->inv_due
    replace off with glpurchs->off
    replace inv_py_amt with 0
     replace inv_py_ref with glpurchs->inv_py_ref
      replace inv_status with glpurchs->inv_status 
    
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
    replace vnstat->total with vnstat->total + glpurchs->total 
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
      if (glpurchs->typ = "00" .or. glpurchs->typ = "05") .and. (glpurchs->cla = "00" .or. glpurchs->cla = "10")
        replace sup_qty with sup_qty + glpurchs->qty
        replace sup_price with glpurchs->list_price
        else
          if (glpurchs->typ = "00" .or. glpurchs->typ = "05") .and. (glpurchs->cla = "30" .or. glpurchs->cla = "50")
        replace dis_qty with dis_qty + glpurchs->qty
        replace dis_price with glpurchs->list_price
        else
             if (glpurchs->typ = "00" .or. glpurchs->typ = "05") .and. glpurchs->cla = "20"
        replace sup_qty with sup_qty + glpurchs->qty
        replace sup_price with glpurchs->list_price
        else
               if (glpurchs->typ = "00" .or. glpurchs->typ = "05") .and. glpurchs->cla = "40"
        replace ker_qty with ker_qty + glpurchs->qty
        replace ker_price with glpurchs->list_price
        else
        replace svc_amt with svc_amt + glpurchs->total
        endif
        endif
         endif
        endif
        
   
        
  
   
        
    
