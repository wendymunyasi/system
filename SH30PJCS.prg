Procedure SH30PJCS
    PARAMETER BUSER,BLEVEL
   *  SET AUTOSAVE ON
     SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Remote Job Cards to the Shift Master in progress...Wait!",MDI .F.,;
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
  set exact on
set decimals to 4
SET CENTURY ON
set date to british
    SET VIEW TO "SH30PJCS.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,PFGJCSALS,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
               PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
     set reprocess to 10000
    select dayfgmas
    
    set order to mkey
   SELECT FGCOD
SET ORDER TO MKEY
              select fgtrnref
              
            set order to mkey
            select shcatsum
            
            set order to mkey
            select scashrec
            
            set order to mkey
            
SELECT FGMAST

SET ORDER TO MKEY
SELECT SHSTMAST

SET ORDER TO MKEY
SELECT CASHIERS

SET ORDER TO CASHIER
SELECT ST15F

SET ORDER TO MKEY
      eofFGJCSALS = .f.
      pposted = .f.
      select fgcoy
      go top
        select FGJCSALS
    set filter to empty(post_date) .AND. .NOT. TOTAL = 0 
           go top
                if .not. eof()
      pposted = .t.
                do
                do line_rtn
                until eofFGJCSALS      
                  endif
               SET SAFETY OFF
               SELECT FGJCSALS
               ZAP
               
               SET SAFETY ON
               SELECT FGCOY
               FLUSH
               
               
               SET AUTOSAVE OFF
close databases
progreps.close()
do sh30plpg.prg with pluser, plevel  && updated 18/09/2018
do sh30plub.prg with pluser, plevel	&& updated 18/09/2018
do sh30pcad.prg with pluser, plevel  && updated 18/09/2018
do sh30pinv.prg with pluser, plevel  && updated 18/09/2018
do sh30PJIN.prg with pluser, plevel  && updated 23/04/2020
do ap30apog.prg with pluser, plevel  && normal purchases
do gl30apog.prg with pluser, plevel  && gl purchases
do fg301213.prg with pluser, plevel  && transfers
do ar30drec.prg with pluser, plevel  && receipts  05/08/2014
do jn30drec.prg with pluser, plevel  && receipts  26/04/2020
do ar30Trec.prg with pluser, plevel && TOP UP CREDIT NOTES
do fg30jnls.prg with pluser, plevel && TOP UP CREDIT NOTES
do ar30jnl.prg with pluser,plevel && customer gl credit/debit notes
do frshtrn.prg with pluser, plevel  && receipts  02/04/2017

procedure line_rtn
            local l1,l2,l11,l22,l3, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

                do cont_rtn2
                
          select FGJCSALS   
             replace post_date with date()
      COMMIT()
   select FGJCSALS   
       SKIP
    IF EOF()
     eofFGJCSALS = .T.
    ENDIF
 procedure cont_rtn2
    select st15f
    go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "JC"
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
   
      PCOY = FGJCSALS->ST_COY
      PDIV = FGJCSALS->ST_DIV
      PCEN = FGJCSALS->ST_CEN
      PSTO = FGJCSALS->ST_STO
      PTYP = FGJCSALS->TYP
      PCLA = FGJCSALS->CLA
      PCOD = FGJCSALS->COD
      PCOY2 = FGJCSALS->COY
      PDIV2 = FGJCSALS->DIV
      PCEN2 = FGJCSALS->CEN
      PSTO2 = FGJCSALS->STO
      PSHID2 = FGJCSALS->shift_id
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if .not. found()
         Wait 'FGJCSALS - Problem with stock masterfile - Try Again Later!'
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
         replace nonvat_amt with 0
          endif
        REPLACE TAX_RATE WITH FGJCSALS->vat     
         REPLACE LIST_PRICE WITH FGJCSALS->sell_PRICE
         REPLACE COST_PRICE WITH FGJCSALS->COST_PRICE
         replace nonvat   with FGJCSALS->nonvat
      
    
                 SELECT FGCOD
    SEEK  PTYP+PCLA+PCOD 
                pfrighter = FGJCSALS->frighter_N
               porder = FGJCSALS->order_no
                        pftyp = FGJCSALS->ftyp
                          pcashrno = FGJCSALS->cashier_no
                          psource = FGJCSALS->source
                          ppmod = FGJCSALS->pmod
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
replace off with FGJCSALS->off
endif

   if empty(off)
   replace off with FGJCSALS->off
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
                    Wait 'FGJCSALS - Problem with shift masterfile - Try Again Later!'
           quit
         
                GO TOP
          ENDIF
         
          endif
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcard = .f.
      pcash = .t.
      pcheque = .f.
                pfdate = .T.
       PCASHR = .T.
      DO FGJCSALS_3018RTN2
       if pdiv2 = "1"    && cash collected at service
             select scashrec
            seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         replace fc_sales with fc_sales + FGJCSALS->total
         replace non_cash with non_cash + FGJCSALS->discount
         select st15f
         replace fc_c_sales with fc_c_sales + FGJCSALS->total  && cash summary
         if typ="10" && fc lubes
          replace reserved5 with reserved5 + FGJCSALS->total
          endif
           REPLACE SHIFT_POST WITH DATE()
          if pshm
              select shstmast
                seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
                  replace on_hand with on_hand - FGJCSALS->qty
                       replace cs_sales with cs_sales + FGJCSALS->qty
                       replace cs_sales_a with cs_sales_a + FGJCSALS->total
                        if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - FGJCSALS->qty
       replace sales with sales + FGJCSALS->qty
       endif
                       select fgmast
                       seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
                        REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - FGJCSALS->QTY
                       replace cs_sales with cs_sales + FGJCSALS->qty
                       replace m_var with m_var + FGJCSALS->qty
                       endif
     select shcatsum
     seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                        replace cs_sal_qty with cs_sal_qty + FGJCSALS->qty
                        replace cs_sal_shs with cs_sal_shs + FGJCSALS->total
                         REPLACE TAX_AMT WITH TAX_AMT + FGJCSALS->VAT_OUT 
                        REPLACE GROSS_AMT WITH GROSS_AMT + FGJCSALS->GROSS_AMT + FGJCSALS->NONVAT_AMT
                      *  REPLACE NONVAT_AMT WITH NONVAT_AMT 
                    
       else
          select scashrec
          seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         replace exp_sales with exp_sales + FGJCSALS->total
         select st15f
         go BOTTOM
         IF FGCOD->COST_MODE < "1" .OR. FGCOD->COST_MODE > "6" .or. empty(fgcod->cost_mode)
         if pdiv = "4"   && shop         
         replace cash_cant with cash_cant + FGJCSALS->total
         else
         if (pdiv = "3" .and. pcen = "1") .or. pdiv = "6"   && car wash     
         replace chqs_sale with chqs_sale + FGJCSALS->total
         else
         if (pdiv = "3" .and. pcen = "2")  .or.  pdiv = "7"  && tyre centre
         replace vs_others with vs_others + FGJCSALS->total
         else
           if  pdiv = "8"   &&  cafe
         replace cash_soda with cash_soda + FGJCSALS->total
         else
          if pdiv = "3"  .and. pcen = "3" && other services 
         replace cash_shop with cash_shop + FGJCSALS->total
         else  && service
         replace cash_work with cash_work + FGJCSALS->total
         endif
         endif
         endif
         endif
         endif
          ELSE
         select st15f
         GO BOTTOM
         if FGCOD->COST_MODE  = "6"   && shop         
            replace cash_cant with cash_cant + FGJCSALS->total
         else

          if FGCOD->COST_MODE  = "2"    && car wash     
         replace chqs_sale with chqs_sale + FGJCSALS->total
           else
          if FGCOD->COST_MODE  = "3"   && tyre centre
         replace vs_others with vs_others + FGJCSALS->total
          else
         if FGCOD->COST_MODE  = "5"    &&  cafe
         replace cash_soda with cash_soda + FGJCSALS->total
         else
          if FGCOD->COST_MODE  = "4"  && other services 
         replace cash_shop with cash_shop + FGJCSALS->total
           else
             replace cash_work with cash_work + FGJCSALS->total
         endif
         endif
         endif
         endif
         endif
         endif
          if pshm
                 select shstmast
                seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
                  replace on_hand with on_hand - FGJCSALS->qty
                       replace cs_sales with cs_sales + FGJCSALS->qty
                       replace cs_sales_a with cs_sales_a + FGJCSALS->total
                                if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - FGJCSALS->qty
       replace sales with sales + FGJCSALS->qty
       endif
                       select fgmast
                       seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
                        REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - FGJCSALS->QTY
                       replace cs_sales with cs_sales + FGJCSALS->qty
                        replace m_var with m_var + FGJCSALS->qty
                       endif
    
     select shcatsum
     seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                        replace cs_sal_qty with cs_sal_qty + FGJCSALS->qty
                        replace cs_sal_shs with cs_sal_shs + FGJCSALS->total
                         REPLACE TAX_AMT WITH TAX_AMT + FGJCSALS->VAT_OUT 
                        REPLACE GROSS_AMT WITH GROSS_AMT + FGJCSALS->GROSS_AMT + FGJCSALS->NONVAT_AMT
                     *   REPLACE NONVAT_AMT WITH NONVAT_AMT 
      endif
      
     
      
  PROCEDURE FGJCSALS_3018RTN2
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
    IF EMPTY(FGJCSALS->SYSTEM)
      psys   = "PS"  && point of sale
      ELSE
      PSYS = FGJCSALS->SYSTEM
      ENDIF
      IF EMPTY(FGJCSALS->DOCTYPE)
      pdoc   = "JC"  && job card
      ELSE
      PDOC = FGJCSALS->DOCTYPE
      ENDIF
      pstockno = FGJCSALS->stock_no
     IF  PST15F 
     SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + ;
        FGJCSALS->QTY
           REPLACE NON_CASH WITH FGJCSALS->TOTAL + ST15F->NON_CASH  + FGJCSALS->DISCOUNT
          REPLACE SHIFT_POST WITH DATE()        
    ENDIF
    local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = FGJCSALS->ORDER_DATE
        l4 = FGJCSALS->order_no
        l5 = FGJCSALS->stock_no
        l6 = FGJCSALS->shiftno
        l7 = FGJCSALS->st_COY
        l8 = FGJCSALS->st_div
        l9 = FGJCSALS->st_cen
        l10 = FGJCSALS->st_sto
        l11 = FGJCSALS->typ
        l12 = FGJCSALS->cla
        l13 = FGJCSALS->cod
        l14 = FGJCSALS->shift_id
          ppay = FGJCSALS->PAY_METHOD
         pcustno  =  FGJCSALS->frighter_N
         pftyp = FGJCSALS->ftyp
         psource = FGJCSALS->source
         ppmod = FGJCSALS->pmod
                LOCAL D1,D2
              D1 = DTOS(FGJCSALS->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = FGJCSALS->QTY * -1
               PTTOTAL = FGJCSALS->TOTAL
               PTVAT = FGJCSALS->vat_out  && get vat amount
              PCOY = FGJCSALS->ST_COY
              PDIV = FGJCSALS->ST_DIV
              PCEN = FGJCSALS->ST_CEN
              PTYP = FGJCSALS->TYP
              PSTO = FGJCSALS->ST_STO
              PCLA = FGJCSALS->CLA
              PCOD = FGJCSALS->COD
                ptcost = FGJCSALS->qty * FGJCSALS->cost_price
              
                         pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
     ptdate = FGJCSALS->order_date
          select fgjobcad
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate  && OK
         replace stock_no with pstockno
         replace coy with FGJCSALS->st_coy
            replace div with FGJCSALS->st_div
            replace cen with FGJCSALS->st_cen
              replace sto with FGJCSALS->st_sto
              replace st_coy with FGJCSALS->coy
            replace st_div with FGJCSALS->div
            replace st_cen with FGJCSALS->cen
              replace st_sto with FGJCSALS->sto
              replace shift_no with PSHNO
               replace shift_id with PSHID
               REPLACE SERIALNO WITH FGJCSALS->SERIALNO
                 replace dde_date with FGJCSALS->DDE_DATE
                replace dde_time with FGJCSALS->DDE_TIME
                replace dde_user with FGJCSALS->DDE_USER
            replace typ with FGJCSALS->typ
            replace cla with FGJCSALS->cla
            replace cod with FGJCSALS->cod
            replace qty with FGJCSALS->qty * -1
            replace unit_cost with FGJCSALS->cost_price
            replace new_bal with FGJCSALS->discount
            replace total with FGJCSALS->total
            replace list_price with FGJCSALS->sell_price
            replace tax_rate with FGJCSALS->vat
            replace tax_amt with FGJCSALS->vat_out
            replace off with FGJCSALS->off  && cashier
            replace reg  with FGJCSALS->reg
            replace gross_amt with FGJCSALS->gross_amt + FGJCSALS->NONVAT_AMT
            replace pay_method  with FGJCSALS->pay_method
            replace cashier_no with FGJCSALS->cashier_no
           REPLACE source WITH FGJCSALS->source
          REPLACE ftyp WITH FGJCSALS->ftyp
           REPLACE PMOD WITH FGJCSALS->PMOD
           REPLACE FRIGHTER_N WITH FGJCSALS->FRIGHTER_N
             replace total_amt with FGJCSALS->total_amt
             replace driver with FGJCSALS->driver
              replace srep with FGJCSALS->srep
              REPLACE SPRICE WITH FGJCSALS->nonvat
              IF TAX_RATE = 0
              REPLACE SPRICE WITH 100
              ENDIF
           *    replace NONVAT with FGJCSALS->NONVAT
          *   replace NONVAT_AMT with 
             local l1,l2,l3,l4
             l1 = fgjobcad->order_no
              l2 = dtos(PSHDATE)
              l3 = fgjobcad->doctype
              l4 = fgjobcad->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH PSHDATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGJCSALS->total
              replace qty with qty + FGJCSALS->qty
                IF LEFT(FGJCSALS->TYP,1) = '7' && SERVICES
        SELECT FGOFFCAS
        APPEND BLANK
        REPLACE COY WITH fgjobcad->COY
        REPLACE TYP WITH fgjobcad->TYP
        REPLACE CLA WITH fgjobcad->CLA
        REPLACE COD WITH fgjobcad->COD
        REPLACE SYSTEM WITH fgjobcad->SYSTEM
        REPLACE DOCTYPE WITH fgjobcad->DOCTYPE
        REPLACE ORDER_NO WITH fgjobcad->ORDER_NO
        REPLACE ORDER_DATE WITH fgjobcad->ORDER_DATE
        REPLACE REG WITH fgjobcad->REG
        REPLACE DRIVER WITH fgjobcad->DRIVER
        REPLACE QTY WITH FGJCSALS->QTY
        REPLACE TOTAL WITH fgjobcad->TOTAL
        REPLACE ADV_AMT WITH FGJCSALS->AMT_ALLOC  * -1
        REPLACE STOCK_NO WITH fgjobcad->STOCK_NO
        replace caw_rate with FGJCSALS->bal_alloc
        replace pit_rate with FGJCSALS->scr_qty
        replace tba_rate with FGJCSALS->scr_amt
        ENDIF
   **
      pmain_key = psys+pdoc+dtos(pshdate)+PSHNO+PSHID+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
    replace system with psys
    REPLACE MAIN_KEY WITH PMAIN_KEY
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate  && OK
         replace stock_no with pstockno
         replace coy with FGJCSALS->st_coy
            replace div with FGJCSALS->st_div
            replace cen with FGJCSALS->st_cen
              replace sto with FGJCSALS->st_sto
              replace st_coy with FGJCSALS->coy
            replace st_div with FGJCSALS->div
            replace st_cen with FGJCSALS->cen
              replace st_sto with FGJCSALS->sto
              replace shift_no with PSHNO
               replace shift_id with PSHID
               REPLACE SERIALNO WITH FGJCSALS->SERIALNO
                 replace dde_date with FGJCSALS->DDE_DATE
                replace dde_time with FGJCSALS->DDE_TIME
                replace dde_user with FGJCSALS->DDE_USER
            replace typ with FGJCSALS->typ
            replace cla with FGJCSALS->cla
            replace cod with FGJCSALS->cod
            replace qty with FGJCSALS->qty * -1
            replace unit_cost with FGJCSALS->cost_price
            replace new_bal with FGJCSALS->discount
            replace total with FGJCSALS->total
            replace list_price with FGJCSALS->sell_price
            replace tax_rate with FGJCSALS->vat
            replace tax_amt with FGJCSALS->vat_out
            replace off with FGJCSALS->off  && cashier
            replace reg  with FGJCSALS->reg
            replace gross_amt with FGJCSALS->gross_amt + FGJCSALS->NONVAT_AMT
            replace pay_method  with FGJCSALS->pay_method
            replace cashier_no with FGJCSALS->cashier_no
            replace scashier with cashier_no
            replace mileage with fgjcsals->mileage
           REPLACE source WITH FGJCSALS->source
          REPLACE ftyp WITH FGJCSALS->ftyp
           REPLACE PMOD WITH FGJCSALS->PMOD
           REPLACE FRIGHTER_N WITH FGJCSALS->FRIGHTER_N
             replace total_amt with FGJCSALS->total_amt
             replace driver with FGJCSALS->driver
              replace srep with FGJCSALS->srep
              REPLACE SPRICE WITH FGJCSALS->nonvat
              replace soff with off
             replace unl with 0
             replace dis with 0
             replace lub with 0
             replace svc with 0
             if typ='10'
                replace lub with 1
                else
                replace svc with 1
                endif
              replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with '1110001'