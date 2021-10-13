Procedure ap30APOG
PARAMETER BUSER,BLEVEL
private postok
postok = .t.
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
   * SET AUTOSAVE ON
    SET VIEW TO "AP30APOG.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 10000
 
 select dayfgmas
 if flock()
 else
               Wait 'Unable to lock dayfgmas - Try Again Later!'
               quit
               endif
 set order to mkey
 
   
    select fgtrnref
   if flock()
    else
               Wait 'Unable to lock fgtrnref - Try Again Later!'
               quit
               endif
    set order to  mkey
SELECT FGMAST
if flock()
 else
               Wait 'Unable to lock fgmast - Try Again Later!'
               quit
               endif
SET ORDER TO MKEY
SELECT SHSTMAST
if flock()
 else
               Wait 'Unable to lock shstmast - Try Again Later!'
               quit
               endif
SET ORDER TO MKEY
SELECT CASHIERS
if flock()
 else
               Wait 'Unable to lock cashiers - Try Again Later!'
               quit
               endif
SET ORDER TO CASHIER
SELECT ST15F
if flock()
 else
               Wait 'Unable to lock st15f - Try Again Later!'
               quit
               endif
SET ORDER TO MKEY
SELECT SCASHREC
if flock()
 else
               Wait 'Unable to lock scashrec - Try Again Later!'
               quit
               endif
SET ORDER TO MKEY
SELECT SHCATSUM
if flock()
 else
               Wait 'Unable to lock shcatsum - Try Again Later!'
               quit
               endif
SET ORDER TO MKEY
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
      eoffgpurchs = .f.
      pposted = .t.
      select fgcoy
      go top
       ppfc = .t.
          select fgpurchs
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
                until eoffgpurchs
       select fgcoy
              flush
              SET AUTOSAVE OFF
             endif
             endif
             if postok
             set safety off
             select fgpurchs
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
                select fgpurchs  
            replace post_date with date()
         
   COMMIT()
   
   select fgpurchs  
   IF .NOT. EOF()
       SKIP
       ENDIF
    IF EOF()
     eoffgpurchs = .T.
    ENDIF
procedure cont_rtn
             
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
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "24"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    else
      pyear = str(year(fgpurchs->order_date),4)
   pmonth = str(month(fgpurchs->order_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "24"
    pshno = "0"
    pshdate = fgpurchs->order_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
    PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,P14,pvendor,;
            pven,PST15F,Pfgmast,Papogrns,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pvtyp,p18,p19,p20,ptsdte,pvsrce,pvtyp,pvpmod
            local lld1,lld2
            
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   if ppfc
      pshdate = st15f->shift_date
    pshno = st15f->shift_no
    pshid = st15f->shift_id
    else
  pshno = "0"
    pshdate = fgpurchs->order_date
    pshid = "0"
   
   endif
    
      PTYP = fgpurchs->TYP
      PCLA = fgpurchs->CLA
      PCOD = fgpurchs->COD
      PCOY = fgpurchs->COY
      PDIV = fgpurchs->DIV
      PCEN = fgpurchs->CEN
      PSTO = fgpurchs->STO
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
     if .not. found()
        Wait 'fgpurchs - Problem with stock masterfile - Try Again Later!'
           quit
      endif
        if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecourt
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      
        endif
 
  
      select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      replace cs_purch_a with 0
       replace cr_purch_a with 0
        replace cs_sales_a with 0
         replace cr_sales_a with 0
      
      replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
    ENDIF
    
        ENDIF
 
       select shcatsum
      seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
      if .not. found()
      append blank
         replace coy with pcoy
         replace cen with pcen
         replace div with pdiv
         replace typ with ptyp
         replace cla with pcla
         replace cod with pcod
         replace shift_date with pSHDATE
         replace shift_no with pshno
         replace shift_id with pshid
         replace cs_sal_qty with 0
         replace cr_sal_qty with 0
         replace cs_pur_qty with 0
         replace cr_pur_qty with 0
         replace cs_sal_shs with 0
         replace cr_sal_shs with 0
         replace cs_pur_shs with 0
         replace cr_pur_shs with 0
           replace tax_amt  with 0
         replace gross_amt  with 0
         replace nonvat_amt with 0
         REPLACE TAX_RATE WITH fgcod->vat     
         REPLACE LIST_PRICE WITH fgcod->Sale_PRICE
         REPLACE COST_PRICE WITH fgcod->COST_PRICE
         replace nonvat   with fgcod->snonvat
      endif
      
                
              porder = fgpurchs->order_no
                          pcashrno = fgpurchs->cashier_no
                          if fgpurchs->btyp = "C0" .and. fgpurchs->bcla = "00" .and. ;
                          fgpurchs->bcod = "11"  && payment from float
                            pvsrce = "1"
                          pvpmod = "1"
                           pvtyp = "1"
                               pvendor = "0001"
                          else
                          if fgpurchs->pay_method = "Loan" .and. .not. empty(fgpurchs->source)
                          pvsrce = fgpurchs->source
                          pvpmod = fgpurchs->pmod
                           pvtyp = fgpurchs->ftyp
                               pvendor = fgpurchs->frighter_n
                          else
                          pvsrce = fgpurchs->vsrce
                          pvpmod = fgpurchs->vpmod
                           pvtyp = fgpurchs->vtyp
                               pvendor = fgpurchs->vendor_n
                               endif
                               endif
                       
                          select cashiers
                          seek pcashrno
                         
                          if found()
                          replace coy with pcoy
                          replace cen with pcen
                          replace div with pdiv
                          endif
                    
           select scashrec
   seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
   if .not. found()
   append blank
   replace cashr_no with  pcashrno
   replace shift_date with pshdate
   replace shift_no with pshno
   replace shift_id with pshid
   replace cen with pcen
    replace sto with psto
   replace typ with ptyp
   replace cla with pcla
   replace cod with pcod
  replace non_cash with 0
   replace exp_cash with 0
    replace exp_sales with 0
  REPLACE COYVISA WITH 0
   REPLACE BBKVISA WITH 0
   REPLACE GENVISA WITH 0
   REPLACE CHQS WITH 0
   REPLACE PAYMNTS WITH 0
   REPLACE RECEPTS WITH 0
   REPLACE PURCH WITH 0
   replace A_CASH with 0
   replace shortage with 0
   replace cr_notes with 0
   replace dr_notes with 0
   replace pdebits with 0
   replace pcredits with 0
   replace ppurch with 0
   replace fc_sales with 0
   
replace  cash_bank with 0
replace  dbcredits with 0
replace  dbdebits  with 0
replace  chqs_bank with 0
replace  reserved1 with 0
replace  reserved2 with 0
replace  reserved3 with 0
replace  reserved4 with 0
replace  reserved5 with 0
replace a_c_inhand with 0
replace off with fgpurchs->off
   endif
    
      if empty(off)
   replace off with fgpurchs->off
   endif
   
      pfcmast =.t.
      
        SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           pven = .T.
         ELSE
           Wait 'fgpurchs - Problem with vendor masterfile - Try Again Later!'
           quit
        ENDIF
        
        ? PVEN
        ? "VENDOR OK"
        if pdiv = "1"  .and. ppfc    .AND. PTYP > "00"  .AND. PTYP <= "9Z" 
         pstf = .t.
         PST15F = .T.
         else
         pstf = .f.
         PST15F = .f.
         endif
         
         if pst15f .and. ppfc 
         
        SELECT ST15F
        SEEK dtos(PSHDATE)+PSHNO+PSHID+pcen+PTYP+PCLA+PCOD+psto+pcoy+pdiv
        if .not. found()
             Wait 'fgpurchs - Problem with shift masterfile - Try Again Later!'
           quit
        endif
         
           endif
          
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcapital = .f.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
     if fgpurchs->pay_method = "Capital" 
      pcapital = .t.
     endif
      if fgpurchs->pay_method = "FC Cash" .or. fgpurchs->pay_method = "Float Cash" .OR. fgpurchs->pay_method = "Cash" 
      pcash = .t.
     endif
   
       if fgpurchs->pay_method = "Cheque" .or. fgpurchs->pay_method = "Bank Debit";
       .or. fgpurchs->pay_method = "Credit Card" .or. fgpurchs->pay_method = "EFT";
        .or. fgpurchs->pay_method = "Card(credit)"  .or. fgpurchs->pay_method = "M-Money" .or. fgpurchs->pay_method = "FT"
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
 *   IF EMPTY(fgpurchs->POST_DATE) .and. pven .and. pstmast   .and. pfcmast 
    DO fgpurchs_3018RTN2
     ? "passed here 2"
    if fgpurchs->TYP = "C0" 
       SELECT VENDOR
       REPLACE CDEP_AMT WITH CDEP_AMT + fgpurchs->TOTAL
       ENDIF
     if  fgpurchs->btyp = "C0" .and.  fgpurchs->bcla = "00";
     .and. (fgpurchs->bcod = "01" .or. fgpurchs->bcod = "11") && cash float /ac
       do scashrec_rtn
       endif
          
         
  PROCEDURE fgpurchs_3018RTN2
  
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
      psys   = "PO"  && point of sale
      pdoc   = "24"  && Purchase
      pstockno = fgpurchs->stock_no
    
      DO master_updt_rtn
         
        
      
  Procedure fgnfpur_3018RTN
        select fgnfpur
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fgpurchs->coy
            replace div with fgpurchs->div
            replace cen with fgpurchs->cen
              replace sto with fgpurchs->sto
              replace st_coy with fgpurchs->coy
            replace st_div with fgpurchs->div
            replace st_cen with fgpurchs->cen
              replace st_sto with fgpurchs->sto
            replace typ with fgpurchs->typ
            replace cla with fgpurchs->cla
            replace cod with fgpurchs->cod
            replace qty with fgpurchs->QTY
              replace sale_qty  with fgpurchs->sale_qty
            REPLACE DIP_Q_BOF WITH fgpurchs->DIP_Q_BOF
            REPLACE DIP_Q_AOF WITH fgpurchs->DIP_Q_AOF
              REPLACE OFLD_TIME WITH fgpurchs->OFLD_TIME
            REPLACE DRIVER WITH fgpurchs->DRIVER
            REPLACE OFLD_NAME WITH fgpurchs->OFLD_NAME
            REPLACE GRN_ASHIP WITH fgpurchs->GRN_ASHIP
            REPLACE SHIP_NAME WITH fgpurchs->SHIP_NAME
            replace transp with fgpurchs->transp
            REPLACE EXP_DIP_Q WITH fgpurchs->EXP_DIP_Q
              REPLACE OFLD_VAR WITH fgpurchs->OFLD_VAR
            REPLACE OFLD_VPERC WITH fgpurchs->OFLD_VPERC
            replace return_qty with fgpurchs->nonvat
            replace unit_cost with fgpurchs->net_amt
            replace list_price with fgpurchs->list_price
            replace new_bal with fgpurchs->nonvat_amt
            replace total with fgpurchs->total
             replace tax_rate with fgpurchs->tax_rate
            replace tax_amt with fgpurchs->tax_amt
             replace job_order with fgpurchs->job_order
            replace off with fgpurchs->off
             replace reg  with fgpurchs->reg
            replace gross_amt with fgpurchs->gross_amt
                replace pay_method  with fgpurchs->pay_method
             replace lpo with fgpurchs->lpo
           REPLACE vsrce WITH fgpurchs->vsrce
          REPLACE vtyp WITH fgpurchs->vtyp
           REPLACE vpmod WITH fgpurchs->vpmod
           REPLACE vendor_N WITH fgpurchs->vendor_N
           if .not. empty(fgpurchs->source)
           REPLACE paysrce WITH fgpurchs->source
          REPLACE paytyp WITH fgpurchs->ftyp
           REPLACE paymod WITH fgpurchs->pmod
           REPLACE pay_n WITH fgpurchs->frighter_n
           else
              REPLACE paysrce WITH vsrce
          REPLACE paytyp WITH vtyp
           REPLACE paymod WITH vpmod
           REPLACE pay_n WITH vendor_n
    endif
        replace shift_no with fgpurchs->shift_no
           replace shift_id with fgpurchs->shift_id
           replace job_order with fgpurchs->job_order
           replace inv_no with fgpurchs->inv_no
           replace inv_date with fgpurchs->inv_date
           replace inv_date with inv_date
              replace cashier_no with fgpurchs->cashier_no
           replace bcoy  with fgpurchs->bcoy
           replace bcen  with fgpurchs->bcen
           replace bdiv  with fgpurchs->bdiv
           replace bsto  with fgpurchs->bsto
           replace btyp with fgpurchs->btyp
           replace bcla with fgpurchs->bcla
           replace bcod with fgpurchs->bcod
           replace dde_date with fgpurchs->dde_date
           replace dde_user with fgpurchs->dde_user
           replace dde_time with fgpurchs->dde_time
           REPLACE SERIALNO WITH fgpurchs->serialno
           if empty(inv_no)
           replace inv_no with serialno
           endif
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
      
           local l1,l2,l3,l4
             l1 = fgnfpur->order_no
              l2 = dtos(fgnfpur->order_date)
              l3 = fgnfpur->doctype
              l4 = fgnfpur->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fgnfpur->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + fgpurchs->total
              replace qty with qty + fgpurchs->qty
           
       
  PROCEDURE sttran_purch_rtn
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = fgpurchs->order_date
        psys = "PO"
        pdoc = "24"
        
         
         ppay = fgpurchs->pay_method
         pventno  =  pvendor
        *pvtyp = pvttrns->vtyp
        *pvsrce = fgpurchs->vsrce
        *pvpmod = fgpurchs->vpmod
                LOCAL D1,D2
                
              D1 = DTOS(fgpurchs->order_date)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
              PCOY = fgpurchs->COY
              PDIV = fgpurchs->DIV
              PCEN = fgpurchs->CEN
              PTYP = fgpurchs->TYP
              PSTO = fgpurchs->STO
              PCLA = fgpurchs->CLA
              PCOD = fgpurchs->COD
              
                    
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
     .or. ppay = "M-Money"  .or. fgpurchs->pay_method = "FT"
       pcheque = .t.
         endif
         if .not. pcheque .and. .not. pcash  .and. .not. pcapital
         pcredit = .t.
         endif
       ptdate = fgpurchs->order_date
              do fgnfpur_3018RTN
                          
       
           IF  pcredit .or. ;
           (fgpurchs->btyp = "C0" .and. fgpurchs->bcla = "00" .and.  fgpurchs->bcod = "11")
                  do drtran_3018RTN
                   endif
  
   
           select shcatsum
                  IF PCASH .or. pcheque
                       replace cs_PUR_qty with cs_PUR_qty + fgpurchs->QTY 
                        replace cs_PUR_shs with cs_PUR_shs + fgpurchs->total 
                        else
                     replace cr_PUR_qty with cr_PUR_qty + fgpurchs->QTY 
                        replace cr_PUR_shs with cr_PUR_shs + fgpurchs->total 
                  endif
       
                  
          if pshm
               if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand + fgpurchs->QTY 
       replace purch with purch + fgpurchs->QTY 
       endif
               
                  select shstmast
                   seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
         replace on_hand with on_hand + fgpurchs->QTY 
                  IF PCASH .or. pcheque
                       replace cs_PURCH with cs_PURCH + fgpurchs->QTY 
                       replace cs_purch_a with cs_purch_a + fgpurchs->total 
                       SELECT fgmast
                       seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
                       REPLACE fgmast->ON_HAND WITH fgmast->on_hand + fgpurchs->QTY 
                       replace cs_PURCH with cs_PURCH + fgpurchs->QTY 
                       if .not. typ='00' .and. .not. m_var = 0
                       replace m_var with m_var - fgpurchs->QTY 
                       endif
                    else
                              select shstmast
                   seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
                     replace cr_PURCH with cr_PURCH + fgpurchs->QTY 
                     replace cr_purch_a with cr_purch_a + fgpurchs->total 
                SELECT fgmast
                seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
              REPLACE fgmast->ON_HAND WITH fgmast->on_hand + fgpurchs->QTY 
                     replace cr_PURCH with cr_PURCH + fgpurchs->QTY 
           if .not. typ='00' .and. .not. m_var = 0
                       replace m_var with m_var - fgpurchs->QTY 
                       endif
                  endif
             
              SELECT FGCOD
              SEEK PTYP+PCLA+PCOD
              REPLACE COST_PRICE WITH  fgpurchs->list_price
              IF STD_COST =   0
              REPLACE STD_COST WITH COST_PRICE
              ENDIF
             
                  endif
     
 PROCEDURE master_updt_rtn
    IF  PST15F .AND. ppfc 
    DO fc_update_rtn
    ENDIF
     DO sttran_purch_rtn
    
PROCEDURE   fc_update_rtn
      if fgpurchs->QTY < 0
         do st15f_trans_out
         else
         do st15f_trans_in
     endif
  

 PROCEDURE ST15F_TRANS_OUT
       LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
          L1 = pshdate
          L2 = pshno
          l10 = pshid
          L7 = fgpurchs->COY
          L8 = fgpurchs->DIV
          L9 = fgpurchs->CEN
          L6 = fgpurchs->STO
          L3 = fgpurchs->TYP
          L4 = fgpurchs->CLA
          L5 = fgpurchs->COD
          LITEM = l3+l4+l5+left(l6,1)
          LID = L9
          SELECT ST15F
            SEEK dtos(PSHDATE)+PSHNO+PSHID+pcen+PTYP+PCLA+PCOD+psto+pcoy+pdiv
           REPLACE ST15F->TRANS_OUT WITH ST15F->TRANS_OUT - fgpurchs->QTY 
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + fgpurchs->QTY 
                  REPLACE SHIFT_POST WITH DATE()
                  replace errors WITH "REKEY CLOSE QTY"
                  pdst15f = .t.
                  
   PROCEDURE ST15F_TRANS_IN
       LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
          L1 = pshdate
          L2 = pshno
          L7 = fgpurchs->COY
          L8 = fgpurchs->DIV
          L9 = fgpurchs->CEN
          L6 = fgpurchs->STO
          L3 = fgpurchs->TYP
          L4 = fgpurchs->CLA
          L5 = fgpurchs->COD
          l10 = pshid
          LID = L9
          LITEM = l3+l4+l5+left(l6,1)
         SELECT ST15F
           SEEK dtos(PSHDATE)+PSHNO+PSHID+pcen+PTYP+PCLA+PCOD+psto+pcoy+pdiv
             REPLACE ST15F->TRANS_IN WITH ST15F->TRANS_IN + fgpurchs->QTY 
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + fgpurchs->QTY 
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
                 
        
 PROCEDURE DRTRAN_3018RTN
  
       pdate = fgpurchs->order_date
       pventno = pvendor
      * Pvtyp = fgpurchs->vtyp
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
       DO vnstat_3018RTN1
          SELECT vendor
      REPLACE vendor->BAL_DUE with  fgpurchs->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
     
             replace l_inv_date with fgpurchs->order_date
             replace l_inv_amt with fgpurchs->total   + l_inv_amt
    
             
 
    DO vnstat_3018RTN2
   
   
Procedure scashrec_rtn
                   if pcash
      if .not. fgpurchs->bcod = "11" && not float
                     select scashrec
                      seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
                     replace purch with purch +  fgpurchs->total 
                        select st15f
                       go BOTTOM
                        REPLACE SHIFT_POST WITH DATE()
         IF left(PTYP,1) = "E"  && expenses
                    replace cash_motor with cash_motor + fgpurchs->total 
                  else
          if ptyp >= "00" .and. ptyp <= "9Z"  && stock items, all items
             replace cash_lubes with cash_lubes + fgpurchs->total 
             else
             
             replace cash_withd with cash_withd + fgpurchs->total   && other payments        
        endif
        endif
        else
           select st15f
                       go BOTTOM
                       replace batchamt with batchamt - fgpurchs->total 
      endif  
      endif
        IF fgpurchs->pay_method = "M-Money"  
        select st15f
        go BOTTOM
        replace mbp_money with mbp_money + fgpurchs->total
        endif
        
PROCEDURE vnstat_3018RTN1
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = fgpurchs->order_no
      ldate = fgpurchs->order_date
      tdate = fgpurchs->order_date
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = "PO"
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
      replace vnstat->serialno with fgpurchs->serialno
      REPLACE vnstat->REG        WITH fgpurchs->reg
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH fgpurchs->lpo
         replace vnstat->pay_method with fgpurchs->pay_method
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
    replace inv_date with fgpurchs->inv_date
    replace inv_no with fgpurchs->inv_no
    replace inv_due with fgpurchs->inv_due
    replace off with fgpurchs->off
    replace inv_py_amt with 0
     replace inv_py_ref with fgpurchs->inv_py_ref
      replace inv_status with fgpurchs->inv_status 
    
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
    replace vnstat->total with vnstat->total + fgpurchs->total 
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
      if (fgpurchs->typ = "00" .or. fgpurchs->typ = "05") .and. (fgpurchs->cla = "00" .or. fgpurchs->cla = "10")
        replace sup_qty with sup_qty + fgpurchs->qty
        replace sup_price with fgpurchs->list_price
        else
          if (fgpurchs->typ = "00" .or. fgpurchs->typ = "05") .and. (fgpurchs->cla = "30" .or. fgpurchs->cla = "50")
        replace dis_qty with dis_qty + fgpurchs->qty
        replace dis_price with fgpurchs->list_price
        else
             if (fgpurchs->typ = "00" .or. fgpurchs->typ = "05") .and. fgpurchs->cla = "20"
        replace sup_qty with sup_qty + fgpurchs->qty
        replace sup_price with fgpurchs->list_price
        else
               if (fgpurchs->typ = "00" .or. fgpurchs->typ = "05") .and. fgpurchs->cla = "40"
        replace ker_qty with ker_qty + fgpurchs->qty
        replace ker_price with fgpurchs->list_price
        else
        replace svc_amt with svc_amt + fgpurchs->total
        endif
        endif
         endif
        endif
        
   
        
  
   
        
    
