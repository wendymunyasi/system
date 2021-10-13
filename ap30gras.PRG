Procedure ap30gras
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
   set reprocess to 10000
    SET VIEW TO "ap30gras.QBE"
     PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 select dayfgmas
 IF .NOT. FLOCK()
 WAIT 'Unable to Lock dayfgmas - Try Again Later'
 quit
 endif 
 set order to mkey
select apgraup
set order to mkey
SELECT FGMAST
IF .NOT. FLOCK()
 WAIT 'Unable to Lock fgmast - Try Again Later'
 quit
 endif
 
SET ORDER TO MKEY
SELECT SHSTMAST
IF .NOT. FLOCK()
 WAIT 'Unable to Lock shstmast - Try Again Later'
 quit
 endif
 
SET ORDER TO MKEY
SELECT CASHIERS
IF .NOT. FLOCK()
 WAIT 'Unable to Lock cashiers - Try Again Later'
 quit
 endif
 
SET ORDER TO CASHIER
SELECT ST15F
IF .NOT. FLOCK()
 WAIT 'Unable to Lock st15f - Try Again Later'
 quit
 endif
 
SET ORDER TO MKEY
SELECT SCASHREC
IF .NOT. FLOCK()
 WAIT 'Unable to Lock scashrec - Try Again Later'
 quit
 endif
 
SET ORDER TO MKEY
SELECT SHCATSUM
IF .NOT. FLOCK()
 WAIT 'Unable to Lock shcatsum - Try Again Later'
 quit
 endif
 
SET ORDER TO MKEY
select fgcod
set order to mkey
select vendor
IF .NOT. FLOCK()
 WAIT 'Unable to Lock vendor - Try Again Later'
 quit
 endif
 
set order to vendor
select vncount
IF .NOT. FLOCK()
 WAIT 'Unable to Lock vncount - Try Again Later'
 quit
 endif
 
set order to mkey
select vnstat
IF .NOT. FLOCK()
 WAIT 'Unable to Lock vnstat  - Try Again Later'
 quit
 endif
 
set order to mkey
SET SAFETY OFF
select vndocref
set order to docref
ZAP
SET SAFETY ON
pstockno = ""
      eofapgralin = .f.
      pposted = .t.
      select fgcoy
      go top
      if pospost = "Yes"
      ppfc = .t.
      else
      ppfc = .f.
      endif
       LOCAL LBAD
      LBAD = .F.
      select apgralin  
     set filter to grn_no = apgras->grn_no .and. empty(post_date) .AND. .NOT. (total = 0 ;
   .and. qty = 0)  .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(grn_stk_no)
   
           go top
                if .not. eof()
  
                do
                do line_rtn
                until eofapgralin
 select apgrasN
                go top
                if eof()
                append blank
                endif
                replace GRN_no with apgras->GRN_no
              
               ENDIF
              select fgcoy
              flush
              SET AUTOSAVE OFF
              CLOSE DATABASES
               
procedure line_rtn
? "LINE SECTION"
            local l1,l2,l11,l22,l3,l4, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            select apgraup
            seek apgralin->grn_no+dtos(apgras->grn_date)+apgralin->grn_stk_no+apgralin->DDE_TIME
            if .not. found()
            append blank
            replace grn_no with apgralin->grn_no
            replace grn_date with apgras->grn_date
            replace grn_stk_no with apgralin->grn_stk_no
            REPLACE DDE_TIME WITH apgralin->DDE_TIME
            DO CONT_RTN
              select apgralin  
            replace post_date with date() 
   SELECT apgraup
     replace post_date with date()
            endif
    commit()
   
   
   
   
   select apgralin  
   IF .NOT. EOF()
       SKIP
       ENDIF
    IF EOF()
     eofapgralin = .T.
    ENDIF
           
  PROCEDURE CONT_RTN
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
   pdoc = "GR"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    else
      pyear = str(year(apgras->grn_date),4)
   pmonth = str(month(apgras->grn_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "GR"
    pshno = "0"
    pshdate = apgras->grn_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
    PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,P14,pvendor,;
            pven,PST15F,Pfgmast,Papgras,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
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
    pshdate = apgras->grn_date
    pshid = "0"
   
   endif
    
      PTYP = apgralin->TYP
      PCLA = apgralin->CLA
      PCOD = apgralin->COD
      PCOY = apgralin->COY
      PDIV = apgralin->DIV
      PCEN = apgralin->CEN
      PSTO = apgralin->STO
      poo = apgras->o_order
      pommyy = dtos(apgras->o_date) && yyyymmdd
      pommyy = left(pommyy,6) && yyyymm
      pommyy = right(pommyy,4) && yymm
      pomm = right(pommyy,2)
      poyy = left(pommyy,2)
      poorder = poo+pomm+poyy
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
      append blank
      replace coy with pcoy
      replace div with pdiv
      replace cen with pcen
      replace sto with psto
      replace typ with ptyp
      replace cla with pcla
      replace cod with pcod
       replace bbf with 0
         replace on_hand with 0
         replace phy with 0
         replace alloc with 0
         replace trans_in with 0
         replace trans_out with 0
         replace purch with 0
         replace sales with 0
         replace adj_in with 0
         replace adj_out with 0
         REPLACE CR_PURCH WITH 0
         REPLACE CS_PURCH WITH 0
         REPLACE CR_SALES  WITH 0
         REPLACE CS_SALES WITH 0
         REPLACE BBF_PHY WITH 0
         REPLACE TEMP_QTY WITH 0
         REPLACE TEMP_PURCH WITH 0
         REPLACE PHY_QTY WITH 0
         REPLACE BCF WITH 0
         REPLACE M_PHY WITH 0
         REPLACE M_VAR WITH 0
         REPLACE OPEN_BAL WITH 0
         REPLACE LAST_PHY WITH 0
         REPLACE  TEMP_PHY WITH 0
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
      endif
       
    
                
              porder = apgras->grn_no
                          pcashrno = apgras->cashier_no
                          if apgras->btyp = "C0" .and. apgras->bcla = "00" .and. ;
                          apgras->bcod = "11"  && float
                            pvsrce = "1"
                          pvpmod = "1"
                           pvtyp = "1"
                               pvendor = "0001"
                          else
                           if apgras->pay_method = "Loan" .and. .not. empty(apgras->source)
                          pvsrce = apgras->source
                          pvpmod = apgras->pmod
                           pvtyp = apgras->ftyp
                               pvendor = apgras->frighter_n
                          else
                          pvsrce = apgras->vsrce
                          pvpmod = apgras->vpmod
                           pvtyp = apgras->vtyp
                               pvendor = apgras->vendor_N
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

  replace off with apgras->grn_off
   endif
   if empty(off)
   replace off with apgras->grn_off
   endif
    
   pfcmast = .t.
      
        SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           pven = .T.
         ELSE
           pven = .F.
        ENDIF
         
           if pdiv = "1"  .and. ppfc    .AND. PTYP > "00"  .AND. PTYP <= "9Z"
         pstf = .t.
         PST15F = .T.
         else
         pstf = .f.
         PST15F = .f.
         endif
         SELECT ST15F
         GO TOP
          
         if pst15f .and. ppfc 
         
        SELECT ST15F
         SEEK dtos(PSHDATE)+PSHNO+PSHID+pcen+PTYP+PCLA+PCOD+psto+pcoy+pdiv
        if .not. found()
        SELECT ST15F
        GO TOP
           PST15F = .F.
           pfcmast = .f.
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
     if apgras->pay_method = "Capital" 
      pcapital = .t.
     endif
      if apgras->pay_method = "FC Cash" .or. apgras->pay_method = "Float Cash" .or. apgras->pay_method = "Cash" 
      pcash = .t.
     endif
   
       if apgras->pay_method = "Cheque" .or. apgras->pay_method = "Bank Debit" .or. apgras->pay_method = "EFT";
        .or. apgras->pay_method = "Credit Card" .or. apgras->pay_method = "Card(credit)";
        .or. apgras->pay_method = "FT" .or. apgras->pay_method = "M-Money"
      pcheque = .t.
     endif
   
      if .not. pcash .and. .not. pcheque  .and. .not. pcapital
      pcredit = .t.
      endif
         
               pfdate = .T.
            ? "pstf"
            ? pstf
       PCASHR = .T.
   *IF POST_DATE) .and. pven .and. pstmast  .and. pfcmast
    DO apgralin_3018RTN2
    ? "done"
     if apgralin->TYP = "C0" 
       SELECT VENDOR
       REPLACE CDEP_AMT WITH CDEP_AMT + apgralin->TOTAL
       ENDIF
 
    
     if  apgras->btyp = "C0" .and.  apgras->bcla = "00" .and. (apgras->bcod = "01" .or. apgras->bcod = "11")
       do scashrec_rtn
       endif
           
 
         
  PROCEDURE apgralin_3018RTN2
  
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
      pdoc   = 'GR'  && Purchase
      pstockno = apgralin->grn_stk_no
    
      DO master_updt_rtn
         
        
      
  Procedure fgnfpur_3018RTN
        select fgnfpur
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with apgralin->coy
            replace div with apgralin->div
            replace cen with apgralin->cen
              replace sto with apgralin->sto
              replace st_coy with apgralin->coy
            replace st_div with apgralin->div
            replace st_cen with apgralin->cen
              replace st_sto with apgralin->sto
              
            replace typ with apgralin->typ
            replace cla with apgralin->cla
            replace cod with apgralin->cod
            replace qty with apgralin->QTY
              replace sale_qty  with apgralin->volume
              IF TYP = "00" .AND. .NOT. QTY = 0
            REPLACE DIP_Q_BOF WITH apgralin->SUPPLY_TOT
            REPLACE DIP_Q_AOF WITH apgralin->RETURN_AMT
            ELSE
             REPLACE DIP_Q_BOF WITH 0
            REPLACE DIP_Q_AOF WITH 0
           ENDIF
           REPLACE OFLD_TIME WITH apgras->ORDER_STAT
            REPLACE DRIVER WITH apgras->SHIPNAME
            REPLACE OFLD_NAME WITH apgras->OFFNAME
            REPLACE GRN_ASHIP WITH apgras->GRN_ASHIP
            REPLACE SHIP_NAME WITH apgras->ASHIPNAME
            REPLACE TRANSP WITH    apgras->TRANSP
            IF TYP = "00"
              REPLACE EXP_DIP_Q WITH DIP_Q_BOF + QTY
            REPLACE OFLD_VAR WITH DIP_Q_AOF - EXP_DIP_Q + sale_qty
            ENDIF
            IF TYP = "00" .AND. .NOT. QTY  = 0
            REPLACE OFLD_VPERC WITH (DIP_Q_AOF - EXP_DIP_Q + sale_qty)/QTY * 100
            ENDIF
          
            replace return_qty with 0
       
            replace unit_cost with apgralin->cost_price
            replace new_bal with 0
            replace total with apgralin->total
            replace list_price with apgralin->list_price
            replace tax_rate with apgralin->tax_rate
            replace tax_amt with apgralin->tax_amt
            replace job_order with apgras->job_order
            replace off with apgras->grn_off
             replace reg  with apgras->reg
            replace gross_amt with apgralin->gross_amt
            replace pay_method  with apgras->pay_method
            replace lpo with apgras->lpo
           REPLACE vsrce WITH apgras->vsrce
          REPLACE vtyp WITH apgras->vtyp
           REPLACE vpmod WITH apgras->vpmod
           REPLACE vendor_N WITH apgras->vendor_N
          if .not. empty(apgras->source)
           REPLACE paysrce WITH apgras->source
          REPLACE paytyp WITH apgras->ftyp
           REPLACE paymod WITH apgras->pmod
           REPLACE pay_n WITH apgras->frighter_n
           else
              REPLACE paysrce WITH vsrce
          REPLACE paytyp WITH vtyp
           REPLACE paymod WITH vpmod
           REPLACE pay_n WITH vendor_n
    endif
            replace shift_no with apgras->shiftno
           replace shift_id with apgras->shiftid
           replace job_order with apgras->job_order
           replace inv_no with apgras->inv_no
           replace inv_date with apgras->inv_date
            replace cashier_no with apgras->cashier_no
           replace bcoy  with apgras->bcoy
            replace bcen  with apgras->bcen
             replace bdiv  with apgras->bdiv
              replace bsto  with apgras->bsto
           replace btyp with apgras->btyp
           replace bcla with apgras->bcla
           replace bcod with apgras->bcod
           replace dde_date with date()
           replace dde_user with PLUSER
           replace dde_time with time()
           REPLACE SERIALNO WITH apgras->SERIALNO
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
           replace unused_f with poorder 
            
                  
 PROCEDURE sttran_purch_rtn
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = apgras->grn_DATE
        psys = "PO"
        pdoc = 'GR'
        
         
         ppay = apgras->PAY_METHOD
         pventno  =  pvendor
        *pvtyp = pvttrns->vtyp
        *pvsrce = apgras->vsrce
        *pvpmod = apgras->vpmod
                LOCAL D1,D2
                
              D1 = DTOS(apgras->grn_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
              PCOY = apgralin->COY
              PDIV = apgralin->DIV
              PCEN = apgralin->CEN
              PTYP = apgralin->TYP
              PSTO = apgralin->STO
              PCLA = apgralin->CLA
              PCOD = apgralin->COD
              
                    
         PCASH = .F.
     PCREDIT = .F.
     pcapital = .f.
     pcheque = .f.
     IF ppay = "FC Cash" .or. ppay = "Float Cash" .or. ppay = "Cash" 
        pcash = .T.
         endif
         IF ppay = "Capital" 
        pcapital = .T.
         endif
     if ppay = "Cheque"  .or.  ppay = "Bank Debit"  .or. ppay = "Credit Card"
       pcheque = .t.
         endif
         if .not. pcheque .and. .not. pcash  .and. .not. pcapital
         pcredit = .t.
         endif
       ptdate = apgras->grn_DATE
              do fgnfpur_3018RTN
                  
                 select shcatsum
                  IF PCASH .or. pcheque
                       replace cs_PUR_qty with cs_PUR_qty + apgralin->QTY 
                        replace cs_PUR_shs with cs_PUR_shs + apgralin->total 
                        else
                     replace cr_PUR_qty with cr_PUR_qty + apgralin->QTY 
                        replace cr_PUR_shs with cr_PUR_shs + apgralin->total 
                  endif
           
                  
          
               
           IF  pcredit .or. ;
           (apgras->btyp = "C0" .and. apgras->bcla = "00" .and.  apgras->bcod = "11")
                  do drtran_3018RTN
                   endif
  
   if pshm
       if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand + apgralin->QTY 
       replace purch with purch  + apgralin->QTY 
       endif
               
                  select shstmast
               
                  replace on_hand with on_hand + apgralin->QTY 
                  IF PCASH .or. pcheque
                       replace cs_PURCH with cs_PURCH + apgralin->QTY 
                       replace cs_purch_a with cs_purch_a + apgralin->total 
                       SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->on_hand + apgralin->QTY 
                            replace cs_PURCH with cs_PURCH + apgralin->QTY 
         
                        else
                     replace cr_PURCH with cr_PURCH + apgralin->QTY 
                     replace cr_purch_a with cr_purch_a + apgralin->total 
                SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->on_hand + apgralin->QTY 
                     replace cr_PURCH with cr_PURCH + apgralin->QTY 
           
                  endif
             
             
                  endif
          
     
 PROCEDURE master_updt_rtn
    IF  PST15F .AND. ppfc 
    DO fc_update_rtn
    ENDIF
     DO sttran_purch_rtn
    
PROCEDURE   fc_update_rtn
      if apgralin->QTY < 0
         do st15f_trans_out
         else
         do st15f_trans_in
     endif
  

 PROCEDURE ST15F_TRANS_OUT
       LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
          L1 = pshdate
          L2 = pshno
          l10 = pshid
          L7 = apgralin->COY
          L8 = apgralin->DIV
          L9 = apgralin->CEN
          L6 = apgralin->STO
          L3 = apgralin->TYP
          L4 = apgralin->CLA
          L5 = apgralin->COD
          LITEM = l3+l4+l5+left(l6,1)
          LID = L9
          SELECT ST15F
           REPLACE ST15F->TRANS_OUT WITH ST15F->TRANS_OUT - apgralin->QTY 
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + apgralin->QTY 
                  REPLACE SHIFT_POST WITH DATE()
                  replace errors WITH "Re-enter the Closing Stock Quantity"
                  pdst15f = .t.
                
   PROCEDURE ST15F_TRANS_IN
       LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
          L1 = pshdate
          L2 = pshno
          L7 = apgralin->COY
          L8 = apgralin->DIV
          L9 = apgralin->CEN
          L6 = apgralin->STO
          L3 = apgralin->TYP
          L4 = apgralin->CLA
          L5 = apgralin->COD
          l10 = pshid
          LID = L9
          LITEM = l3+l4+l5+left(l6,1)
         SELECT ST15F
             REPLACE ST15F->TRANS_IN WITH ST15F->TRANS_IN + apgralin->QTY 
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + apgralin->QTY 
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "Re-enter closing stock quantity"
                 
 PROCEDURE DRTRAN_3018RTN
  
       pdate = apgras->grn_DATE
       pventno = pvendor
      * Pvtyp = apgras->vtyp
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
       DO vnstat_3018RTN1
          SELECT vendor
      REPLACE vendor->BAL_DUE with  apgralin->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
     
             replace l_inv_date with apgras->grn_DATE
             replace l_inv_amt with apgralin->total   + l_inv_amt
    
             
 
    DO vnstat_3018RTN2
    
   
   
Procedure scashrec_rtn
                   if pcash
                   do scashrec_rtn1
                   endif
procedure scashrec_rtn1
      if .not. apgras->bcod = "11" && not float
                     select scashrec
                     replace purch with purch +  apgralin->total 
                        select st15f
                       go top
                        REPLACE SHIFT_POST WITH DATE()
         IF left(PTYP,1) = "E"  && expenses
                    replace cash_motor with cash_motor + apgralin->total 
                  else
          if ptyp >= "00" .and. ptyp <= "9Z"  && stock items, all items
             replace cash_lubes with cash_lubes + apgralin->total 
             else
             
             replace cash_withd with cash_withd + apgralin->total   && other payments        
        endif
        endif
        else
           select st15f
                       go top
                       replace batchamt with batchamt  + apgralin->total 
      endif  
         IF apgras->pay_method = "M-Money"  
        select st15f
        go top
        replace mbp_money with mbp_money + apgralin->total
        endif   
        
PROCEDURE vnstat_3018RTN1
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = apgras->grn_no
      ldate = apgras->grn_DATE
      tdate = apgras->grn_DATE
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = "PO"
      ldoc = 'GR'
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
      replace vnstat->serialno with apgras->serialno
      REPLACE vnstat->REG        WITH apgras->reg
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH apgras->LPO
         replace vnstat->pay_method with apgras->pay_method
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
    replace inv_date with apgras->inv_date
    replace inv_no with apgras->inv_no
    replace inv_due with apgras->inv_due
    replace off with apgras->grn_off
    replace inv_py_amt with apgras->inv_py_amt
     replace inv_py_ref with apgras->inv_py_ref
      replace inv_status with apgras->inv_status 
    
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
    replace vnstat->total with vnstat->total + apgralin->total 
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
    if (apgralin->typ = "00" .or. apgralin->typ = "05") .and. (apgralin->cla = "00" .or. apgralin->cla = "10")
        replace sup_qty with sup_qty + apgralin->qty
        replace sup_price with apgralin->list_price
        else
          if (apgralin->typ = "00" .or. apgralin->typ = "05") .and. (apgralin->cla = "30" .or. apgralin->cla = "50")
        replace dis_qty with dis_qty + apgralin->qty
        replace dis_price with apgralin->list_price
        else
             if (apgralin->typ = "00" .or. apgralin->typ = "05") .and. apgralin->cla = "20"
        replace sup_qty with sup_qty + apgralin->qty
        replace sup_price with apgralin->list_price
        else
               if (apgralin->typ = "00" .or. apgralin->typ = "05") .and. apgralin->cla = "40"
        replace ker_qty with ker_qty + apgralin->qty
        replace ker_price with apgralin->list_price
        else
        replace svc_amt with svc_amt + apgralin->total
        endif
        endif
         endif
        endif
  