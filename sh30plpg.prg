Procedure sh30plpg
PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
   * SET AUTOSAVE ON
    SET VIEW TO "sh30plpg.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfglpsals,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
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


      eofglpsals = .f.
      pposted = .f.
      select fgcoy
      go top
    
      SELECT fglpsals
     
      set filter to  empty(post_date) .AND. .NOT. (TOTAL = 0 .AND. QTY = 0)  .and. typ="20"
           go top
                if .not. eof()
      pposted = .t.
                do
                do line_rtn
                until eofglpsals
              
               ENDIF
                 set safety off
               select fglpsals
               zap
               set safety on
               SELECT FGCOY
               FLUSH
             
               
              
close databases
set safety off
use  \kenserve\idssys\fglpsals.dbf
copy stru to \kenservice\data\fglpsals dbase prod
close databases
SET AUTOSAVE OFF
procedure line_rtn
            local l1,l2,l11,l22,l3, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
            if fglpsals->typ = "20"
            DO CONT_RTN
            endif
                select fglpsals   
       replace post_date with date()
  
          COMMIT()
    
      select fglpsals   
      if .not.  eof()
       SKIP
       endif
    IF EOF()
     eofglpsals = .T.
    ENDIF
        
 procedure cont_rtn
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "LP"
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
   
    *  PSHDATE2 = fglpsals->SHIFT_DATE
   *   PSHNO2 = fglpsals->SHIFT_NO
      PCOY = fglpsals->ST_COY
      PDIV = fglpsals->ST_DIV
      PCEN = fglpsals->ST_CEN
      PSTO = fglpsals->ST_STO
      PTYP = fglpsals->TYP
      PCLA = fglpsals->CLA
      PCOD = fglpsals->COD
      PCOY2 = fglpsals->COY
      PDIV2 = fglpsals->DIV
      PCEN2 = fglpsals->CEN
      PSTO2 = fglpsals->STO
   *   PSHID2 = fglpsals->shift_id
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if .not. found()
       Wait 'fglpsals - Problem with stock masterfile - Try Again Later!'
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
   
      pstmast = .t.
        
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
         replace nonvat   with Fglpsals->nonvat
         replace nonvat_amt with 0
         REPLACE TAX_RATE WITH Fglpsals->vat     
         REPLACE LIST_PRICE WITH Fglpsals->sell_PRICE
         REPLACE COST_PRICE WITH Fglpsals->COST_PRICE
      endif
            
       SELECT FGCOD
    SEEK  PTYP+PCLA+PCOD 
    
   
                pfrighter = fglpsals->frighter_N
               porder = fglpsals->order_no
                        pftyp = fglpsals->ftyp
                          pcashrno = fglpsals->cashier_no
                          psource = fglpsals->source
                          ppmod = fglpsals->pmod
                          
                    
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
replace off with fglpsals->off
   endif
   if empty(off)
   replace off with fglpsals->off
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
                Wait 'fglpsals - Problem with shift masterfile - Try Again Later!'
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
       
  *  IF EMPTY(fglpsals->POST_DATE)
    ? "done"  
     if pdiv2 = "1"     && cash collected at service
            select scashrec
             seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         replace fc_sales with fc_sales + fglpsals->total
         replace non_cash with non_cash  + fglpsals->discount  && normal credit
           select st15f
           SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
         replace fc_c_sales with fc_c_sales + fglpsals->total  && cash summary
         replace reserved4 with reserved4 + fglpsals->total
          REPLACE SHIFT_POST WITH DATE()
           select shstmast
           seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
         replace on_hand with on_hand - fglpsals->qty
         replace cs_sales with cs_sales + fglpsals->qty
         replace cs_sales_a with cs_sales_a + fglpsals->total
          if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - fglpsals->qty
       replace sales with sales + fglpsals->qty
       endif
         select fgmast
         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
          REPLACE ON_HAND WITH ON_HAND - fglpsals->QTY
         replace cs_sales with cs_sales + fglpsals->qty
         replace m_var with m_var + fglpsals->qty
          SELECT SHCATSUM
          seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
           replace cs_sal_qty with cs_sal_qty + fglpsals->qty
           replace cs_sal_shs with cs_sal_shs + fglpsals->total
            REPLACE TAX_AMT WITH TAX_AMT + fglpsals->VAT_OUT 
                        REPLACE GROSS_AMT WITH GROSS_AMT + fglpsals->PR_QTY + fglpsals->NONVAT_AMT
                      *  REPLACE NONVAT_AMT WITH NONVAT_AMT + fglpsals->NONVAT_AMT
        else
           select scashrec
            seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         replace exp_sales with exp_sales + fglpsals->total
         select st15f
         go top
       select st15f
       GO TOP
         replace cash_cant with cash_cant + fglpsals->total
         select shstmast
         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
         replace on_hand with on_hand - fglpsals->qty
         replace cs_sales with cs_sales + fglpsals->qty
         replace cs_sales_a with cs_sales_a + fglpsals->total
          if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - fglpsals->qty
       replace sales with sales + fglpsals->qty
       endif
         select fgmast
         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
          REPLACE ON_HAND WITH ON_HAND - fglpsals->QTY
         replace cs_sales with cs_sales + fglpsals->qty
          replace m_var with m_var + fglpsals->qty
          SELECT SHCATSUM
          seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
           replace cs_sal_qty with cs_sal_qty + fglpsals->qty
           replace cs_sal_shs with cs_sal_shs + fglpsals->total
             REPLACE TAX_AMT WITH TAX_AMT + fglpsals->VAT_OUT 
                        REPLACE GROSS_AMT WITH GROSS_AMT + fglpsals->PR_QTY + fglpsals->NONVAT_AMT
                      *  REPLACE NONVAT_AMT WITH NONVAT_AMT 
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
      pdoc   = "LP"  && CASH SALE
      pstockno = fglpsals->stock_no
    
                     
         IF  PST15F 
     SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty +   fglpsals->QTY
           REPLACE NON_CASH WITH fglpsals->TOTAL + ST15F->NON_CASH + fglpsals->discount
          REPLACE SHIFT_POST WITH DATE()

 
    ENDIF
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = fglpsals->ORDER_DATE
        psys = "PS"
        pdoc = "LP"
        l4 = fglpsals->order_no
        l5 = fglpsals->stock_no
        l6 = fglpsals->shiftno
        l7 = fglpsals->st_COY
        l8 = fglpsals->st_div
        l9 = fglpsals->st_cen
        l10 = fglpsals->st_sto
        l11 = fglpsals->typ
        l12 = fglpsals->cla
        l13 = fglpsals->cod
        l14 = fglpsals->shift_id
         
          ppay = fglpsals->PAY_METHOD
         pcustno  =  fglpsals->frighter_N
         pftyp = fglpsals->ftyp
         psource = fglpsals->source
         ppmod = fglpsals->pmod
                LOCAL D1,D2
                
              D1 = DTOS(fglpsals->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = fglpsals->QTY * -1
               PTTOTAL = fglpsals->TOTAL
               PTVAT = fglpsals->vat_out  && get vat amount
              PCOY = fglpsals->ST_COY
              PDIV = fglpsals->ST_DIV
              PCEN = fglpsals->ST_CEN
              PTYP = fglpsals->TYP
              PSTO = fglpsals->ST_STO
              PCLA = fglpsals->CLA
              PCOD = fglpsals->COD
                ptcost = fglpsals->qty * fglpsals->cost_price
              
                    
             
                        pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
       ptdate = fglpsals->order_date
        
        select FGLPGCAD
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fglpsals->st_coy
            replace div with fglpsals->st_div
            replace cen with fglpsals->st_cen
              replace sto with fglpsals->st_sto
              replace st_coy with fglpsals->coy
            replace st_div with fglpsals->div
            replace st_cen with fglpsals->cen
              replace st_sto with fglpsals->sto
              replace shift_no with fglpsals->shiftno
               replace shift_id with fglpsals->shiftid
               REPLACE SERIALNO WITH fglpsals->reference
                 replace dde_date with fglpsals->dde_date
                replace dde_time with fglpsals->dde_time
                replace dde_user with fglpsals->dde_user
             replace typ with fglpsals->typ
            replace cla with fglpsals->cla
            replace cod with fglpsals->cod
            replace qty with fglpsals->qty * -1
            replace unit_cost with fglpsals->cost_price
            replace new_bal with fglpsals->discount
            replace total with fglpsals->total
            replace list_price with fglpsals->sell_price
            replace tax_rate with fglpsals->vat
            replace tax_amt with fglpsals->vat_out
            replace off with fglpsals->off  && cashier
            replace gross_amt with fglpsals->PR_QTY +  fglpsals->nonvat_amt
            replace pay_method  with fglpsals->pay_method
            replace cashier_no with fglpsals->cashier_no
           REPLACE source WITH fglpsals->source
          REPLACE ftyp WITH fglpsals->ftyp
           REPLACE PMOD WITH fglpsals->PMOD
           REPLACE FRIGHTER_N WITH fglpsals->FRIGHTER_N
             replace total_amt with Fglpsals->nonvat
               replace driver with fglpsals->driver
            * replace nonvat with fglpsals->nonvat
            * replace nonvat_amt with fglpsals->nonvat_amt
             local l1,l2,l3,l4
             l1 = FGLPGCAD->order_no
              l2 = dtos(FGLPGCAD->order_date)
              l3 = FGLPGCAD->doctype
              l4 = FGLPGCAD->system
               select FGLPGTRN
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fglpsals->st_coy
            replace div with fglpsals->st_div
            replace cen with fglpsals->st_cen
             replace sto with fglpsals->st_sto
               replace shift_no with fglpsals->shiftno
               replace shift_id with fglpsals->shiftid
               REPLACE SERIALNO WITH fglpsals->reference
                 replace dde_date with fglpsals->dde_date
                replace dde_time with fglpsals->dde_time
                replace dde_user with fglpsals->dde_user
             replace typ with fglpsals->typ
            replace cla with fglpsals->cla
            replace cod with fglpsals->cod
            replace qty with fglpsals->qty
              replace total with fglpsals->total
            replace list_price with fglpsals->sell_price
            REPLACE PHONE WITH FGLPSALS->LPO
            REPLACE IDNO WITH FGLPSALS->REG
            REPLACE CUSTNAME WITH FGLPSALS->CUSTNAME
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
              replace total with total + fglpsals->total
              replace qty with qty + fglpsals->qty
              
    pmain_key = psys+pdoc+dtos(pshdate)+fglpsals->shiftno+fglpsals->shiftID+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
      replace main_key with pmain_key
   replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fglpsals->st_coy
            replace div with fglpsals->st_div
            replace cen with fglpsals->st_cen
              replace sto with fglpsals->st_sto
              replace st_coy with fglpsals->coy
            replace st_div with fglpsals->div
            replace st_cen with fglpsals->cen
              replace st_sto with fglpsals->sto
              replace shift_no with fglpsals->shiftno
               replace shift_id with fglpsals->shiftid
               REPLACE SERIALNO WITH fglpsals->reference
                 replace dde_date with fglpsals->dde_date
                replace dde_time with fglpsals->dde_time
                replace dde_user with fglpsals->dde_user
             replace typ with fglpsals->typ
            replace cla with fglpsals->cla
            replace cod with fglpsals->cod
            replace qty with fglpsals->qty * -1
            replace unit_cost with fglpsals->cost_price
            replace new_bal with fglpsals->discount
            replace total with fglpsals->total
            replace list_price with fglpsals->sell_price
            replace tax_rate with fglpsals->vat
            replace tax_amt with fglpsals->vat_out
            replace off with fglpsals->off  && cashier
            replace gross_amt with fglpsals->PR_QTY +  fglpsals->nonvat_amt
            replace pay_method  with fglpsals->pay_method
            replace cashier_no with fglpsals->cashier_no
           REPLACE source WITH fglpsals->source
          REPLACE ftyp WITH fglpsals->ftyp
           REPLACE PMOD WITH fglpsals->PMOD
           REPLACE FRIGHTER_N WITH fglpsals->FRIGHTER_N
             replace total_amt with Fglpsals->nonvat
           replace scashier with cashier_no     
             replace mileage with 0
             replace unl with 0
             replace dis with 0
             replace lub with 0
             replace soff with off
             replace svc with 1
             replace sprice with total_amt
             replace driver with fglpsals->driver
              replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
               replace customerid with '1110001'
   