 
Procedure sh30plub
PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
   * SET AUTOSAVE ON
    SET VIEW TO "sh30plub.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfglusals,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,PT1,PT2,PT3
            local lld1,lld2
                  PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
   set reprocess to 10000
   select DAYFGMAS
   
   SET ORDER TO MKEY
   
 
              select fgtrnref
              
            set order to mkey
SELECT FGMAST

SET ORDER TO MKEY
SELECT SHSTMAST

SET ORDER TO MKEY
SELECT CASHIERS

SET ORDER TO CASHIER
SELECT ST15F

SET ORDER TO MKEY
GO TOP
SELECT SCASHREC

SET ORDER TO MKEY
SELECT SHCATSUM

SET ORDER TO MKEY
SELECT FGCOD
SET ORDER TO MKEY


      eofglusals = .f.
      pposted = .f.
      select fgcoy
      go top
    
      SELECT fglusals
      
     set filter to  empty(post_date) .AND. .NOT. (TOTAL = 0 .AND. QTY = 0) .and. typ="10"
           go top
                if .not. eof()
      pposted = .t.
                do
                do line_rtn
                until eofglusals
              
               ENDIF
                 set safety off
               select fglusals
               zap
               set safety on
               SELECT FGCOY
               FLUSH
             
              
close databases
SET AUTOSAVE OFF
procedure line_rtn
            local l1,l2,l11,l22,l3, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
            if fglusals->typ = "10"
            DO CONT_RTN
            endif
                select fglusals   
       replace post_date with date()
  
          COMMIT()
         
      select fglusals   
      if .not.  eof()
       SKIP
       endif
    IF EOF()
     eofglusals = .T.
    ENDIF
        
 procedure cont_rtn
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "LB"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
      PCOY = fglusals->ST_COY
      PDIV = fglusals->ST_DIV
      PCEN = fglusals->ST_CEN
      PSTO = fglusals->ST_STO
      PTYP = fglusals->TYP
      PCLA = fglusals->CLA
      PCOD = fglusals->COD
      PCOY2 = fglusals->COY
      PDIV2 = fglusals->DIV
      PCEN2 = fglusals->CEN
      PSTO2 = fglusals->STO
   *   PSHID2 = fglusals->shift_id
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if .not. found()
       Wait 'fglusals - Problem with stock masterfile - Try Again Later!'
           quit
      endif
      
      pstmast = .t.
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
      
      replace cs_sales_a with 0
      replace cs_purch_a with 0
      replace cr_sales_a with 0
      replace cr_purch_a with 0
      
      
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
         replace tax_amt   with 0
         replace gross_amt  with 0
         replace nonvat   with fglusals->nonvat
         replace nonvat_amt with 0
         REPLACE TAX_RATE WITH fglusals->vat     
         REPLACE LIST_PRICE WITH fglusals->sell_PRICE
         REPLACE COST_PRICE WITH fglusals->COST_PRICE
      endif
            
       SELECT FGCOD
    SEEK  PTYP+PCLA+PCOD 
    
   
                pfrighter = fglusals->frighter_N
               porder = fglusals->order_no
                        pftyp = fglusals->ftyp
                          pcashrno = fglusals->cashier_no
                          psource = fglusals->source
                          ppmod = fglusals->pmod
                          
                    
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
replace off with fglusals->off
   endif
   if empty(off)
   replace off with fglusals->off
   endif
    
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
      
           PCUS = .T.
        if pdiv2 = "1" 
         pstf = .t.
         PST15F = .T.
         else
         pstf = .f.
         PST15F = .f.
         endif
         
         if pst15f 
         
        SELECT ST15F
         
        SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
          IF FOUND()
                PST15F = .t.
                pstf = .t.
                ELSE
                 Wait 'fglusals - Problem with shift masterfile - Try Again Later!'
           quit
          ENDIF
           
          endif
          
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcard = .f.
      pcash = .t.
      pcheque = .f.
      pother = .f.
      
      
      
         
               pfdate = .T.
          
       PCASHR = .T.
       ? pcus
       ? pstmast
       
  *  IF EMPTY(fglusals->POST_DATE)
    ? "done"  
     if pdiv2 = "1"     && cash collected at service
            select scashrec
             seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         replace fc_sales with fc_sales + fglusals->total
         replace non_cash with non_cash  + fglusals->discount  && normal credit
           select st15f
           SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
         replace fc_c_sales with fc_c_sales + fglusals->total  && cash summary
         replace reserved5 with reserved5 + fglusals->total
          REPLACE SHIFT_POST WITH DATE()
           select shstmast
           seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
         replace on_hand with on_hand - fglusals->qty
         replace cs_sales with cs_sales + fglusals->qty
         replace cs_sales_a with cs_sales_a + fglusals->total
          if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - fglusals->qty
       replace sales with sales + fglusals->qty
       endif
         select fgmast
         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
          REPLACE ON_HAND WITH ON_HAND - fglusals->QTY
         replace cs_sales with cs_sales + fglusals->qty
         replace m_var with m_var + fglusals->qty
          SELECT SHCATSUM
          seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
           replace cs_sal_qty with cs_sal_qty + fglusals->qty
           replace cs_sal_shs with cs_sal_shs + fglusals->total
           REPLACE TAX_AMT WITH TAX_AMT + fglusals->VAT_OUT 
                        REPLACE GROSS_AMT WITH GROSS_AMT + fglusals->PR_QTY + fglusals->NONVAT_AMT
                      *  REPLACE NONVAT_AMT WITH NONVAT_AMT 
        else
           select scashrec
            seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         replace exp_sales with exp_sales + fglusals->total
         select st15f
         go top
       select st15f
       GO TOP
         replace cash_cant with cash_cant + fglusals->total
         select shstmast
         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
         replace on_hand with on_hand - fglusals->qty
         replace cs_sales with cs_sales + fglusals->qty
         replace cs_sales_a with cs_sales_a + fglusals->total
          if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - fglusals->qty
       replace sales with sales + fglusals->qty
       endif
         select fgmast
         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
          REPLACE ON_HAND WITH ON_HAND - fglusals->QTY
         replace cs_sales with cs_sales + fglusals->qty
          replace m_var with m_var + fglusals->qty
          SELECT SHCATSUM
          seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
           replace cs_sal_qty with cs_sal_qty + fglusals->qty
           replace cs_sal_shs with cs_sal_shs + fglusals->total
           REPLACE TAX_AMT WITH TAX_AMT + fglusals->VAT_OUT 
                        REPLACE GROSS_AMT WITH GROSS_AMT + fglusals->PR_QTY + fglusals->NONVAT_AMT
                    *    REPLACE NONVAT_AMT WITH NONVAT_AMT 
             endif

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
      psys   = "PS"  && point of sale
      pdoc   = "LB"  && CASH SALE
      pstockno = fglusals->stock_no
    
                     
         IF  PST15F 
     SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty +   fglusals->QTY
           REPLACE NON_CASH WITH fglusals->TOTAL + ST15F->NON_CASH + fglusals->discount
          REPLACE SHIFT_POST WITH DATE()

 
    ENDIF
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = fglusals->ORDER_DATE
        psys = "PS"
        pdoc = "LB"
        l4 = fglusals->order_no
        l5 = fglusals->stock_no
        l6 = fglusals->shiftno
        l7 = fglusals->st_COY
        l8 = fglusals->st_div
        l9 = fglusals->st_cen
        l10 = fglusals->st_sto
        l11 = fglusals->typ
        l12 = fglusals->cla
        l13 = fglusals->cod
        l14 = fglusals->shift_id
         
          ppay = fglusals->PAY_METHOD
         pcustno  =  fglusals->frighter_N
         pftyp = fglusals->ftyp
         psource = fglusals->source
         ppmod = fglusals->pmod
                LOCAL D1,D2
                
              D1 = DTOS(fglusals->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = fglusals->QTY * -1
               PTTOTAL = fglusals->TOTAL
               PTVAT = fglusals->vat_out  && get vat amount
              PCOY = fglusals->ST_COY
              PDIV = fglusals->ST_DIV
              PCEN = fglusals->ST_CEN
              PTYP = fglusals->TYP
              PSTO = fglusals->ST_STO
              PCLA = fglusals->CLA
              PCOD = fglusals->COD
                ptcost = fglusals->qty * fglusals->cost_price
              
                    
             
                        pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
       ptdate = fglusals->order_date
        
        select FGLPGCAD
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fglusals->st_coy
            replace div with fglusals->st_div
            replace cen with fglusals->st_cen
              replace sto with fglusals->st_sto
              replace st_coy with fglusals->coy
            replace st_div with fglusals->div
            replace st_cen with fglusals->cen
              replace st_sto with fglusals->sto
              replace shift_no with fglusals->shiftno
               replace shift_id with fglusals->shiftid
               REPLACE SERIALNO WITH fglusals->lpo
                 replace dde_date with fglusals->dde_date
                replace dde_time with fglusals->dde_time
                replace dde_user with fglusals->dde_user
              
            replace typ with fglusals->typ
            replace cla with fglusals->cla
            replace cod with fglusals->cod
            replace qty with fglusals->qty * -1
            replace unit_cost with fglusals->cost_price
            replace new_bal with fglusals->discount
            replace total with fglusals->total
            replace list_price with fglusals->sell_price
            replace tax_rate with fglusals->vat
            replace tax_amt with fglusals->vat_out
            replace off with fglusals->off  && cashier
            replace gross_amt with fglusals->PR_QTY +  fglusals->nonvat_amt
            replace pay_method  with fglusals->pay_method
            replace cashier_no with fglusals->cashier_no
           REPLACE source WITH fglusals->source
          REPLACE ftyp WITH fglusals->ftyp
           REPLACE PMOD WITH fglusals->PMOD
           REPLACE FRIGHTER_N WITH fglusals->FRIGHTER_N
             replace total_amt with fglusals->nonvat
            
             replace driver with fglusals->driver
          *   replace nonvat with fglusals->nonvat
          *   replace nonvat_amt with
             local l1,l2,l3,l4
             l1 = FGLPGCAD->order_no
              l2 = dtos(FGLPGCAD->order_date)
              l3 = FGLPGCAD->doctype
              l4 = FGLPGCAD->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGLPGCAD->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + fglusals->total
              replace qty with qty + fglusals->qty
              
        pmain_key = psys+pdoc+dtos(pshdate)+fglusals->shiftno+fglusals->shiftID+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
    REPLACE MAIN_KEY WITH PMAIN_KEY
  replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fglusals->st_coy
            replace div with fglusals->st_div
            replace cen with fglusals->st_cen
              replace sto with fglusals->st_sto
              replace st_coy with fglusals->coy
            replace st_div with fglusals->div
            replace st_cen with fglusals->cen
              replace st_sto with fglusals->sto
              replace shift_no with fglusals->shiftno
               replace shift_id with fglusals->shiftid
               REPLACE SERIALNO WITH fglusals->lpo
                 replace dde_date with fglusals->dde_date
                replace dde_time with fglusals->dde_time
                replace dde_user with fglusals->dde_user
             replace typ with fglusals->typ
            replace cla with fglusals->cla
            replace cod with fglusals->cod
            replace qty with fglusals->qty * -1
            replace unit_cost with fglusals->cost_price
            replace new_bal with fglusals->discount
            replace total with fglusals->total
            replace list_price with fglusals->sell_price
            replace tax_rate with fglusals->vat
            replace tax_amt with fglusals->vat_out
            replace off with fglusals->off  && cashier
            replace gross_amt with fglusals->PR_QTY +  fglusals->nonvat_amt
            replace pay_method  with fglusals->pay_method
            replace cashier_no with fglusals->cashier_no
           REPLACE source WITH fglusals->source
          REPLACE ftyp WITH fglusals->ftyp
           REPLACE PMOD WITH fglusals->PMOD
           REPLACE FRIGHTER_N WITH fglusals->FRIGHTER_N
             replace total_amt with fglusals->nonvat
             replace scashier with cashier_no     
             replace mileage with 0
             replace unl with 0
             replace dis with 0
             replace lub with 1
             replace soff with off
             replace svc with 0
             replace sprice with total_amt
             replace driver with fglusals->driver
            replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
               replace customerid with '1110001'