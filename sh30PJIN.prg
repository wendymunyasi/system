Procedure SH30PJIN
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
  *  SET AUTOSAVE ON
    SET VIEW TO "SH30PJIN.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,PJNWINVCE,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
              PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
   
            
SELECT FGMAST

SET ORDER TO MKEY

SELECT SHCATSUM

SET ORDER TO MKEY
select frighter

set order to frighter
select frmodebt

set order to mkey
select frddebtp

set order to mkey
select frcount

set order to mkey
set safety off
select frdocref

set order to docref
select vendor

set order to vendor
select vncount

set order to mkey
select vnstat

set order to mkey
SET SAFETY OFF
select vndocref

set order to docref
select frshtrn

set order to mkey
select fgcod
set order to mkey
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,PJNWINVCE,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            pposted = .t.
      eofJNWINVCE = .f.
      select fgcoy
      go top
    
        select JNWINVCE
        dele all for year(order_date) < 1
         set filter to empty(post_date)
             go top
                if .not. eof()
                do
                do line_rtn
                until eofJNWINVCE
                endif
                set safety off
                select JNWINVCE
                zap
              select fgcoy
             flush
            
             SET AUTOSAVE OFF
             set safety on
            close databases
            
       
procedure line_rtn
            local l1,l2,l11,l22,l3,lok, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
  pdoc = JNWINVCE->doctype
   if empty(pdoc)
   pdoc = '25'
   endif
                  local lld1,lld2
    pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   
      PSHNO2 = JNWINVCE->SHIFT_NO
      PCOY = JNWINVCE->ST_COY
      PDIV = JNWINVCE->ST_DIV
      PCEN = JNWINVCE->ST_CEN
      PSTO = JNWINVCE->ST_STO
      PTYP = JNWINVCE->TYP
      PCLA = JNWINVCE->CLA
      PCOD = JNWINVCE->COD
      PCOY2 = JNWINVCE->COY
      PDIV2 = JNWINVCE->DIV
      PCEN2 = JNWINVCE->CEN
      PSTO2 = JNWINVCE->STO
      PSHID2 = JNWINVCE->shift_id
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      select fgcod
      seek ptyp+pcla+pcod
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if .not. found()
        Wait 'JNWINVCE - Problem with stock masterfile - Try Again Later!'+' '+JNWINVCE->ORDER_NO
           quit
      endif
      ENDIF
        
       IF .NOT. PTYP = "C0"
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
         replace nonvat   with JNWINVCE->nonvat
         replace nonvat_amt with 0
         REPLACE TAX_RATE WITH JNWINVCE->TAX_RATE
         REPLACE LIST_PRICE WITH JNWINVCE->LIST_PRICE
         REPLACE COST_PRICE WITH fgcod->cost_price
      endif
             
                
    ENDIF
   
               pfrighter = JNWINVCE->frighter_N
               porder = JNWINVCE->order_no
                        pftyp = JNWINVCE->ftyp
                          pcashrno = JNWINVCE->cashier_no
                          psource = JNWINVCE->source
                          ppmod = JNWINVCE->pmod
   
  
        SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
        IF FOUND()
           PCUS = .T.
         ELSE
           Wait 'JNWINVCE - Problem with customer masterfile in Invoices - Try Again Later!'
           quit
        ENDIF
          select frcustbl
  locate for source = psource .and. ftyp = pftyp .and. pmod = ppmod .and. frighter_n = pfrighter
  if .not. found()
  append blank
  replace source with psource
  replace ftyp with pftyp
  replace pmod with ppmod
  replace frighter_n with pfrighter
  replace bal_due with frighter->bal_due
  endif
  
          pstf = .f.
         PST15F = .f.
       
      local wk1,wk2
      wk1 = 0
      pcredit = .t.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
                 pfdate = .T.
         PCASHR = .T.
    DO JNWINVCE_3018RTN2
     
    
                              IF LEFT(PTYP,1)='7'
                   SELECT SHCATSUM
                   seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                       replace cr_sal_qty with cr_sal_qty + JNWINVCE->qty
                        replace cr_sal_shs with cr_sal_shs + JNWINVCE->total + JNWINVCE->disc_amt
                         REPLACE TAX_AMT WITH TAX_AMT + JNWINVCE->TAX_AMT
                        REPLACE GROSS_AMT WITH GROSS_AMT + JNWINVCE->GROSS_AMT
                        REPLACE NONVAT_AMT WITH NONVAT_AMT + JNWINVCE->NONVAT_AMT
                        ENDIF
                        if ptyp = "C0" .and. pcla = "00" .and. pcod = "11"  && payment from float
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
         
                      
         if pven
               do new_vnstat_rtn
         endif
         ENDIF
                   select JNWINVCE
             replace post_date with date()
    COMMIT()
    
    select JNWINVCE   
       SKIP
    IF EOF()
     eofJNWINVCE = .T.
    ENDIF
  
   
  PROCEDURE JNWINVCE_3018RTN2
  
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
     psys = 'OP'  && point of sale
       pdoc = '25'  && job card
      pstockno = JNWINVCE->stock_no
      pshdate = JNWINVCE->order_date
   local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = pshdate
       l4 = JNWINVCE->order_no
        l5 = JNWINVCE->stock_no
        l6 = JNWINVCE->shiftno
        l7 = JNWINVCE->st_COY
        l8 = JNWINVCE->st_div
        l9 = JNWINVCE->st_cen
        l10 = JNWINVCE->st_sto
        l11 = JNWINVCE->typ
        l12 = JNWINVCE->cla
        l13 = JNWINVCE->cod
        l14 = JNWINVCE->shift_id
         
          ppay = JNWINVCE->PAY_METHOD
         pcustno  =  JNWINVCE->frighter_N
         pftyp = JNWINVCE->ftyp
         psource = JNWINVCE->source
         ppmod = JNWINVCE->pmod
                LOCAL D1,D2
                
              D1 = DTOS(pshdate)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = JNWINVCE->QTY * -1
               PTTOTAL = JNWINVCE->TOTAL
               PTVAT = JNWINVCE->tax_amt  && get vat amount
              PCOY = JNWINVCE->st_COY
              PDIV = JNWINVCE->st_DIV
              PCEN = JNWINVCE->st_CEN
              PTYP = JNWINVCE->TYP
              PSTO = JNWINVCE->st_STO
              PCLA = JNWINVCE->CLA
              PCOD = JNWINVCE->COD
                ptcost = JNWINVCE->qty * fgcod->cost_price
                          pother = .F.
                        pcash = .f.
                        pcredit = .t.
                        pcheque = .f.
                        pcard = .f.
         pcard = .f.
         
     ptdate = pshdate
              select FGINVTRN
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with JNWINVCE->st_coy
            replace div with JNWINVCE->st_div
            replace cen with JNWINVCE->st_cen
              replace sto with JNWINVCE->st_sto
              replace st_coy with JNWINVCE->coy
            replace st_div with JNWINVCE->div
            replace st_cen with JNWINVCE->cen
              replace st_sto with JNWINVCE->sto
              replace shift_no with JNWINVCE->shiftno
               replace shift_id with JNWINVCE->shiftid
                replace serialno with JNWINVCE->serialno
                replace dde_date with JNWINVCE->DDE_DATE
                replace dde_time with JNWINVCE->DDE_TIME
                replace dde_user with JNWINVCE->DDE_USER
                replace driver with JNWINVCE->driver
                replace scashier  with JNWINVCE->SCASHIER 
                replace soff with JNWINVCE->soff
               replace cashier_no  with JNWINVCE->cashier_no 
            replace typ with JNWINVCE->typ
            replace cla with JNWINVCE->cla
            replace cod with JNWINVCE->cod
            replace qty with JNWINVCE->qty * -1
            replace unit_cost with fgcod->cost_price
            replace new_bal with JNWINVCE->disc_amt
            replace total with JNWINVCE->total
            replace list_price with JNWINVCE->list_price
            replace tax_rate with JNWINVCE->tax_rate
            replace tax_amt with JNWINVCE->tax_amt
            replace off with JNWINVCE->off
            replace reg  with JNWINVCE->reg
            replace gross_amt with JNWINVCE->gross_amt 
            REPLACE MILEAGE WITH JNWINVCE->MILEAGE
            replace vendor_n with JNWINVCE->proforma
            replace pay_method  with JNWINVCE->pay_method
            replace lpo with JNWINVCE->lpo
           REPLACE source WITH JNWINVCE->source
          REPLACE ftyp WITH JNWINVCE->ftyp
           REPLACE PMOD WITH JNWINVCE->PMOD
           REPLACE FRIGHTER_N WITH JNWINVCE->FRIGHTER_N
             replace total_amt with JNWINVCE->nonvat
             IF TAX_RATE = 0
             REPLACE TOTAL_AMT WITH 0
             ENDIF
             *replace NONVAT with JNWINVCE->NONVAT
             *replace NONVAT_AMT with JNWINVCE->NONVAT_AMT
              REPLACE UNL WITH 0
              REPLACE DIS WITH 0
              REPLACE LUB WITH 0
              REPLACE SVC WITH 0
              IF TYP < "10" .AND. (CLA < "30" .OR. CLA = "40")
              REPLACE UNL WITH 1
              ENDIF
              IF TYP < "10" .AND. (CLA = "30" .OR. CLA = "50")
              REPLACE DIS WITH 1
              ENDIF
              IF TYP = "10"
              REPLACE LUB WITH 1
              ENDIF
              IF TYP > "10"
              REPLACE SVC WITH 1
              ENDIF
              LOCAL L1,L2,L3,L4,L5,l6,l7,l8,l9
   L1 = FGINVTRN->SOURCE
   L2 = FGINVTRN->FTYP
   L3 = FGINVTRN->PMOD
   L4 = FGINVTRN->FRIGHTER_N
   L5 = FGINVTRN->SYSTEM
   L6 = FGINVTRN->DOCTYPE
   L7 = FGINVTRN->ORDER_DATE
 
    local l1,l2,l3,l4
             l1 = FGINVTRN->order_no
              l2 = dtos(FGINVTRN->order_date)
              l3 = FGINVTRN->doctype
              l4 = FGINVTRN->system
            
         pcoy = JNWINVCE->st_coy
       pdate = pshdate
       pcustno = JNWINVCE->frighter_n
       Pftyp = JNWINVCE->ftyp
      ptyp = JNWINVCE->typ
       pcla = JNWINVCE->cla
       pcod = JNWINVCE->cod
       local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
        local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lsource,lpmod
      lref = JNWINVCE->ORDER_NO
      ldate = pshdate
      tdate = pshdate
      lsource = JNWINVCE->source
      lpmod = JNWINVCE->pmod
      lsys   = JNWINVCE->system
      lsys = 'OP'  && point of sale
      ldoc = '25'  && GL INVOICE
      lcust = JNWINVCE->frighter_n
      lftyp = JNWINVCE->Ftyp
       select frcount
      seek lsource+lftyp+lpmod+LCUST+pyy+pmm
      if .not. found()
      append blank
      replace source with lsource
      replace pmod with lpmod
      replace yy with pyy
      replace mm with pmm
      replace count with "0"
      REPLACE fTYP WITH LfTYP
      REPLACE frighter_N WITH LCUST
      endif
      L1 = VAL(frcount->COUNT)
      L2 = L1 + 1
      L3 = STR(L2,5)
       select frdocref
     seek lsource+lftyp+lpmod+LCUST+lref
      if .not. found()
      append blank
      replace docref with lref
      replace source with lsource
      replace pmod with lpmod
      replace doctype with ldoc
        REPLACE fTYP WITH lftyp
        REPLACE frighter_N WITH LCUST
      select frcount
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
        select frshtrn
      seek lsource+lftyp+lpmod+LCUST+pyy+pmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE CARD_NO  WITH LTRIM(left(JNWINVCE->SHIPNAME,18)+'-'+left(JNWINVCE->ASHIPNAME,10)+'-'+left(JNWINVCE->PURTNAME,10))
      REPLACE frighter_N WITH lcust
      replace source with lsource
      replace pmod with lpmod
       replace mm with pmm
      replace yy with pyy
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
     REPLACE ftyP WITH lftyp
               replace invoice with 1
               REPLACE PAYMENT WITH 0
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
          REPLACE MILEAGE WITH JNWINVCE->MILEAGE
                replace driver with JNWINVCE->driver
       replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with JNWINVCE->serialno
      replace REG        WITH JNWINVCE->reg
       replace sTIME       WITH ltime
        replace LPO        WITH JNWINVCE->LPO
         replace pay_method with "Credit"
         replace sdate with ldate
         replace bbf with frighter->bal_due
                if frshtrn->bbf < 0
            replace bbf_cr with frighter->bal_due* -1
            replace bbf_dr with 0
         else
            replace bbf_dr with frighter->bal_due
            replace bbf_cr with 0
         endif
         endif
                  local l1,l2,l3,l4,l5,l6,l7,ll8,l9,l0,l10
      l0 = frighter->source
      l1 = frighter->ftyp
      l10 = frighter->pmod
      l2 = frighter->frighter_n
      l3 = pdate
      l6 = dtos(pdate) && yyyymmdd
      l7 = left(l6,4) && yyyy
      l8 = left(l6,6) && yyyymm
      l9 = right(l8,2) && mm
      select FRMODEBT
      seek l0+l1+l10+l2+l7+l9
      if .not. found()
      append blank
      replace bbf with frighter->bal_due
      replace bal_due with bbf
      replace source with l0
      replace ftyp with l1
      replace pmod with l10
      replace frighter_n with l2
      replace yy with l7
      replace mm with l9
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     endif
     replace l_inv_amt with JNWINVCE->total + l_inv_amt
             replace bal_due with bal_due + JNWINVCE->total
      
      select frddebtp
      seek l0+l1+l10+l2+dtos(l3)
      if .not. found()
      append blank
      replace bal_due with frighter->bal_due
      replace bbf with bal_due
     replace source with l0
      replace ftyp with l1
      replace pmod with l10
      replace frighter_n with l2
      replace shift_date with l3
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace m_pay_amt with 0
     replace m_inv_amt with 0
     endif
             replace l_inv_amt with JNWINVCE->total + l_inv_amt
             replace bal_due with bal_due + JNWINVCE->total
             replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
          SELECT frighter
          SEEK psource+pftyp+ppmod+pfrighter
          if found()
      REPLACE BAL_DUE with  JNWINVCE->TOTAL + BAL_DUE
        replace turnover with 0
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
             replace l_inv_date with pshdate
             replace l_inv_amt with JNWINVCE->total + l_inv_amt
           ENDIF
           
             select frcustbl
             REPLACE BAL_DUE with  JNWINVCE->TOTAL + BAL_DUE
     SELECT frshtrn
    replace bal_due with frighter->BAL_DUE
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->BAL_DUE
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + JNWINVCE->TOTAL
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
  REPLACE DIS_qty with JNWINVCE->dis_QTY + dis_QTY
       REPLACE SUP_qty with JNWINVCE->SUP_QTY + SUP_QTY
            REPLACE SER_AMT with JNWINVCE->SER_AMT + SER_AMT
             REPLACE LUB_AMT with JNWINVCE->LUB_AMT + LUB_AMT
 
          pmain_key = psys+pdoc+dtos(pshdate)+JNWINVCE->shiftno+JNWINVCE->shiftid+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
      replace main_key with pmain_key
      replace system with psys
        replace doctype with pdoc
        replace order_no with porder
        replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with JNWINVCE->st_coy
            replace div with JNWINVCE->st_div
            replace cen with JNWINVCE->st_cen
              replace sto with JNWINVCE->st_sto
              replace st_coy with JNWINVCE->coy
            replace st_div with JNWINVCE->div
            replace st_cen with JNWINVCE->cen
              replace st_sto with JNWINVCE->sto
              replace shift_no with JNWINVCE->shiftno
               replace shift_id with JNWINVCE->shiftid
                replace serialno with JNWINVCE->serialno
                replace dde_date with JNWINVCE->DDE_DATE
                replace dde_time with JNWINVCE->DDE_TIME
                replace dde_user with JNWINVCE->DDE_USER
                replace driver with JNWINVCE->driver
                replace scashier  with JNWINVCE->SCASHIER 
                replace soff with JNWINVCE->soff
               replace cashier_no  with JNWINVCE->cashier_no 
            replace typ with JNWINVCE->typ
            replace cla with JNWINVCE->cla
            replace cod with JNWINVCE->cod
            replace qty with JNWINVCE->qty * -1
            replace unit_cost with fgcod->cost_price
            replace new_bal with JNWINVCE->disc_amt
            replace total with JNWINVCE->total
            replace list_price with JNWINVCE->list_price
            replace tax_rate with JNWINVCE->tax_rate
            replace tax_amt with JNWINVCE->tax_amt
            replace off with JNWINVCE->off
            replace reg  with JNWINVCE->reg
            replace gross_amt with JNWINVCE->gross_amt
            REPLACE MILEAGE WITH JNWINVCE->MILEAGE
            replace vendor_n with JNWINVCE->proforma
            replace pay_method  with JNWINVCE->pay_method
            replace lpo with JNWINVCE->lpo
           REPLACE source WITH JNWINVCE->source
          REPLACE ftyp WITH JNWINVCE->ftyp
           REPLACE PMOD WITH JNWINVCE->PMOD
           REPLACE FRIGHTER_N WITH JNWINVCE->FRIGHTER_N
             replace total_amt with JNWINVCE->nonvat
             replace sprice with total_amt
             IF TAX_RATE = 0
             REPLACE TOTAL_AMT WITH 100
             ENDIF
             *replace NONVAT with JNWINVCE->NONVAT
             *replace NONVAT_AMT with JNWINVCE->NONVAT_AMT
              REPLACE UNL WITH 0
              REPLACE DIS WITH 0
              REPLACE LUB WITH 0
              REPLACE SVC WITH 0
              IF TYP < "10" .AND. (CLA < "30" .OR. CLA = "40")
              REPLACE UNL WITH 1
              ENDIF
              IF TYP < "10" .AND. (CLA = "30" .OR. CLA = "50")
              REPLACE DIS WITH 1
              ENDIF
              IF TYP = "10"
              REPLACE LUB WITH 1
              ENDIF
              IF TYP > "10"
              REPLACE SVC WITH 1
              ENDIF
              replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with frighter->cus_acc
  PROCEDURE new_vnstat_rtn
  
       pdate = FGINVTRN->order_date
       pventno = pvendor
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = FGINVTRN->order_no
      ldate = FGINVTRN->order_date
      tdate = FGINVTRN->order_date
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys   = FGINVTRN->system
      ldoc   =  FGINVTRN->doctype
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
      replace vnstat->serialno with FGINVTRN->serialno
      REPLACE vnstat->REG        WITH FGINVTRN->reg
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH FGINVTRN->LPO
         replace vnstat->pay_method with FGINVTRN->pay_method
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
    replace inv_date with FGINVTRN->order_date
    replace inv_no with FGINVTRN->order_no
    replace inv_due with FGINVTRN->order_date
    replace off with FGINVTRN->off
    replace inv_py_amt with 0
       replace vnstat->total with 0
        replace vnstat->amt_dr with 0
          replace vnstat->amt_cr with 0
          replace gratax_amt with 0
          replace gra_total with 0
          replace gra_gross with 0
          replace gra_cost with 0
       endif
      **
          SELECT vendor
      REPLACE vendor->BAL_DUE with  FGINVTRN->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
     
             replace l_inv_date with FGINVTRN->order_date
             replace l_inv_amt with FGINVTRN->total   + l_inv_amt
      SELECT vnstat
    replace vnstat->bal_due with vendor->BAL_DUE
   if vnstat->bal_due < 0
         replace vnstat->bal_due_cr with vendor->BAL_DUE* -1
         replace vnstat->bal_due_dr with 0
         else
         replace vnstat->bal_due_dr with vendor->BAL_DUE
         replace vnstat->bal_due_cr with 0
         endif
    replace vnstat->total with vnstat->total + FGINVTRN->total 
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
      if (FGINVTRN->typ = "00" .or. FGINVTRN->typ = "05") .and. (FGINVTRN->cla = "00" .or. FGINVTRN->cla = "10")
        replace sup_qty with sup_qty + FGINVTRN->qty
        replace sup_price with FGINVTRN->list_price
        else
          if (FGINVTRN->typ = "00" .or. FGINVTRN->typ = "05") .and. (FGINVTRN->cla = "30" .or. FGINVTRN->cla = "50")
        replace dis_qty with dis_qty + FGINVTRN->qty
        replace dis_price with FGINVTRN->list_price
        else
             if (FGINVTRN->typ = "00" .or. FGINVTRN->typ = "05") .and. FGINVTRN->cla = "20"
        replace sup_qty with sup_qty + FGINVTRN->qty
        replace sup_price with FGINVTRN->list_price
        else
               if (FGINVTRN->typ = "00" .or. FGINVTRN->typ = "05") .and. FGINVTRN->cla = "40"
        replace ker_qty with ker_qty + FGINVTRN->qty
        replace ker_price with FGINVTRN->list_price
        else
        replace svc_amt with svc_amt + FGINVTRN->total
        endif
        endif
         endif
        endif