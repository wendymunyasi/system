Procedure SH30PINV
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
  *  SET AUTOSAVE ON
    SET VIEW TO "SH30PINV.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,PARWINVCE,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
              PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
   set reprocess to 10000
 *  select st15f
  * go top
     select arinvflg
go top
if eof()
append blank
replace tran with 0
replace shift_date with st15f->shift_date
replace shift_no with st15f->shift_no
replace mast with 0
replace stat with 0
replace shift_id with st15f->shift_id
endif
if .not. mast = stat .and. .not. stat = tran
wait 'Errors with Posting Invoices - Contact System Team!'
close databases
quit
endif
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
  pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    IF EMPTY(PSHNO) .OR. EMPTY(PSHDATE) .OR. EMPTY(PSHID)
    WAIT 'SHIFTMASTER EMPTY!'
    QUIT
    ENDIF
SELECT SCASHREC

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
            PCUS,PST15F,Pfgmast,PARWINVCE,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            pposted = .t.
      eofARWINVCE = .f.
      select fgcoy
      go top
    
        select ARWINVCE
        dele all for year(order_date) < 1
         set filter to empty(post_date)
             go top
                if .not. eof()
                do
                do line_rtn
                until eofARWINVCE
                endif
                set safety off
                select ARWINVCE
                zap
              select fgcoy
             flush
            
             SET AUTOSAVE OFF
             set safety on
            close databases
               use \kenservice\data\vendor.dbf
              go top
              if .not. eof()
              set safety off
              copy stru to  \kenservice\data\vendors dbase prod
              close databases
              use \kenservice\data\vendors.dbf exclusive
              appe from \kenservice\data\vendor.dbf
              endif
              set safety off
            use \kenserve\idssys\frshtrn.dbf
            copy stru to \kenservice\data\frshtrns dbase prod
            close databases
            use  \kenservice\data\frshtrns.dbf
            appe from \kenservice\data\frshtrn.dbf
            close databases
  set safety on

procedure line_rtn
            local l1,l2,l11,l22,l3,lok, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
  *   pyear = str(year(st15f->shift_date),4)
  * pmonth = str(month(st15f->shift_date),2)
   *         if val(pmonth) < 10
   *      pmonth = "0"+str(val(pmonth),1)
    *       endif
   pdoc = ARWINVCE->doctype
   if empty(pdoc)
   pdoc = '18'
   endif
                  local lld1,lld2
    pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   
      PSHNO2 = ARWINVCE->SHIFT_NO
      PCOY = ARWINVCE->ST_COY
      PDIV = ARWINVCE->ST_DIV
      PCEN = ARWINVCE->ST_CEN
      PSTO = ARWINVCE->ST_STO
      PTYP = ARWINVCE->TYP
      PCLA = ARWINVCE->CLA
      PCOD = ARWINVCE->COD
      PCOY2 = ARWINVCE->COY
      PDIV2 = ARWINVCE->DIV
      PCEN2 = ARWINVCE->CEN
      PSTO2 = ARWINVCE->STO
      PSHID2 = ARWINVCE->shift_id
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
        Wait 'ARWINVCE - Problem with stock masterfile - Try Again Later!'+' '+ARWINVCE->ORDER_NO
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
       replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
      replace cr_sales_a with 0
      replace cs_sales_a with 0
      replace cr_purch_a with 0
      replace cs_purch_a with 0
    ENDIF
     
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
         replace nonvat   with ARWINVCE->nonvat
         replace nonvat_amt with 0
         REPLACE TAX_RATE WITH ARWINVCE->TAX_RATE
         REPLACE LIST_PRICE WITH ARWINVCE->LIST_PRICE
         REPLACE COST_PRICE WITH fgcod->cost_price
      endif
             
                
    ENDIF
   
               pfrighter = ARWINVCE->frighter_N
               porder = ARWINVCE->order_no
                        pftyp = ARWINVCE->ftyp
                          pcashrno = ARWINVCE->cashier_no
                          psource = ARWINVCE->source
                          ppmod = ARWINVCE->pmod
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
 replace off with ARWINVCE->off
   endif
   IF EMPTY(OFF)
   replace off with ARWINVCE->off
   ENDIF
    
   SELECT CASHIERS
   SEEK pcashrno
   if found()
   replace coy with pcoy
   replace cen with pcen
   replace div with pdiv
   endif
  
        SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
        IF FOUND()
           PCUS = .T.
         ELSE
           Wait 'ARWINVCE - Problem with customer masterfile in Invoices - Try Again Later!'
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
  
        if pdiv2 = "1" .and. .not. empty(ARWINVCE->shift_date) ;
         .and. .not. empty(ARWINVCE->shift_no) .and. .not. empty(ARWINVCE->shift_id)
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
                Wait 'ARWINVCE - Problem with shift masterfile - Try Again Later!'
           quit
                
          ENDIF
           
          endif
      local wk1,wk2
      wk1 = 0
      pcredit = .t.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
                 pfdate = .T.
         PCASHR = .T.
    DO ARWINVCE_3018RTN2
     
     if pdiv2 = "1" .and. pst15f
             IF .NOT. PTYP = "C0" 
      select scashrec
      seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
       replace non_cash with non_cash + ARWINVCE->total+ARWINVCE->disc_amt  && normal credit
       else
       IF PTYP = "C0" .AND. PCLA = "00" .AND. PCOD = "01"  && FC Cash
        select scashrec
        seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
       replace purch with purch + ARWINVCE->total+ARWINVCE->disc_amt  && normal credit
     endif
     endif
          else
        IF .NOT. PTYP = "C0" 
            select scashrec
            seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
            replace exp_sales with exp_sales  + ARWINVCE->total
       replace non_cash with non_cash + ARWINVCE->total  && normal credit
       ELSE
         IF PTYP = "C0" .AND. PCLA = "00" .AND. PCOD = "01"  && FC Cash
            select scashrec
            seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
            replace PURCH with PURCH  + ARWINVCE->total
       ENDIF
       endif
       endif
     IF PSHM
                 SELECT SHSTMAST
                 seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
                  replace on_hand with on_hand - ARWINVCE->qty
                      replace cr_sales with cr_sales + ARWINVCE->qty
                    replace cr_sales_a with cr_sales_a + ARWINVCE->total
                    if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - ARWINVCE->qty
       replace sales with sales + ARWINVCE->qty
       endif
                    select fgmast
                    seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
                       REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - ARWINVCE->QTY
                       if ARWINVCE->doctype = '15' 
                   replace adj_out with adj_out + ARWINVCE->qty
                   endif
                   replace m_var with m_var + ARWINVCE->qty
                   ENDIF
                              IF .NOT. PTYP = "C0"
                   SELECT SHCATSUM
                   seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                       replace cr_sal_qty with cr_sal_qty + ARWINVCE->qty
                        replace cr_sal_shs with cr_sal_shs + ARWINVCE->total + ARWINVCE->disc_amt
                         REPLACE TAX_AMT WITH TAX_AMT + ARWINVCE->TAX_AMT
                        REPLACE GROSS_AMT WITH GROSS_AMT + ARWINVCE->GROSS_AMT
                        REPLACE NONVAT_AMT WITH NONVAT_AMT + ARWINVCE->NONVAT_AMT
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
        endif
                   select ARWINVCE
             replace post_date with date()
    COMMIT()
    
    select ARWINVCE   
       SKIP
    IF EOF()
     eofARWINVCE = .T.
    ENDIF
  
   
  PROCEDURE ARWINVCE_3018RTN2
  
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
      psys   = ARWINVCE->system
      if empty(psys)
      psys = 'OP'  && point of sale
      endif
      pdoc   = ARWINVCE->doctype
      if empty(pdoc)
      pdoc = '18'  && job card
      endif
      pstockno = ARWINVCE->stock_no
       IF ARWINVCE->TYP = "00" .and. pst15f  && fuel forecourt
            SELECT ST15F
            SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + ARWINVCE->QTY
          REPLACE ST15F->NON_CASH WITH ARWINVCE->TOTAL + ST15F->NON_CASH + ARWINVCE->disc_amt
          if frighter->category = 'M'
          replace mobilesals with mobilesals + ARWINVCE->TOTAL
          endif
          REPLACE SHIFT_POST WITH DATE()       
     ELSE
    IF PST15F 
    SELECT ST15F
    SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty +  ARWINVCE->QTY
          if frighter->category = 'M'
          replace mobilesals with mobilesals + ARWINVCE->TOTAL
          endif
           REPLACE ST15F->NON_CASH WITH ARWINVCE->TOTAL + ST15F->NON_CASH +ARWINVCE->disc_amt
               REPLACE SHIFT_POST WITH DATE()
    ENDIF
    if ptyp = "C0" .AND. PCLA = "00" .AND. PCOD = "01" && FC Cash
     select st15f
     GO BOTTOM
        replace cash_withd with cash_withd + ARWINVCE->total
        replace shift_post with date()
        else
          if ptyp = "C0" .AND. PCLA = "00" .AND. PCOD = "11"  && Float Cash
             select st15f
                       GO BOTTOM
                       replace batchamt with batchamt - ARWINVCE->total 
                        replace shift_post with date()
        endif
        endif
           
     ENDIF
   local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = pshdate
       psys   = ARWINVCE->system
      if empty(psys)
      psys = 'OP'  && point of sale
      endif
      pdoc   = ARWINVCE->doctype
      if empty(pdoc)
      pdoc = '18'  && job card
      endif
        l4 = ARWINVCE->order_no
        l5 = ARWINVCE->stock_no
        l6 = ARWINVCE->shiftno
        l7 = ARWINVCE->st_COY
        l8 = ARWINVCE->st_div
        l9 = ARWINVCE->st_cen
        l10 = ARWINVCE->st_sto
        l11 = ARWINVCE->typ
        l12 = ARWINVCE->cla
        l13 = ARWINVCE->cod
        l14 = ARWINVCE->shift_id
         
          ppay = ARWINVCE->PAY_METHOD
         pcustno  =  ARWINVCE->frighter_N
         pftyp = ARWINVCE->ftyp
         psource = ARWINVCE->source
         ppmod = ARWINVCE->pmod
                LOCAL D1,D2
                
              D1 = DTOS(pshdate)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = ARWINVCE->QTY * -1
               PTTOTAL = ARWINVCE->TOTAL
               PTVAT = ARWINVCE->tax_amt  && get vat amount
              PCOY = ARWINVCE->st_COY
              PDIV = ARWINVCE->st_DIV
              PCEN = ARWINVCE->st_CEN
              PTYP = ARWINVCE->TYP
              PSTO = ARWINVCE->st_STO
              PCLA = ARWINVCE->CLA
              PCOD = ARWINVCE->COD
                ptcost = ARWINVCE->qty * fgcod->cost_price
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
         replace coy with ARWINVCE->st_coy
            replace div with ARWINVCE->st_div
            replace cen with ARWINVCE->st_cen
              replace sto with ARWINVCE->st_sto
              replace st_coy with ARWINVCE->coy
            replace st_div with ARWINVCE->div
            replace st_cen with ARWINVCE->cen
              replace st_sto with ARWINVCE->sto
              replace shift_no with ARWINVCE->shiftno
               replace shift_id with ARWINVCE->shiftid
                replace serialno with ARWINVCE->serialno
                replace dde_date with ARWINVCE->DDE_DATE
                replace dde_time with ARWINVCE->DDE_TIME
                replace dde_user with ARWINVCE->DDE_USER
                replace driver with ARWINVCE->driver
                replace scashier  with ARWINVCE->SCASHIER 
                replace soff with ARWINVCE->soff
               replace cashier_no  with ARWINVCE->cashier_no 
            replace typ with ARWINVCE->typ
            replace cla with ARWINVCE->cla
            replace cod with ARWINVCE->cod
            replace qty with ARWINVCE->qty * -1
            replace unit_cost with fgcod->cost_price
            replace new_bal with ARWINVCE->disc_amt
            replace total with ARWINVCE->total
            replace list_price with ARWINVCE->list_price
            replace tax_rate with ARWINVCE->tax_rate
            replace tax_amt with ARWINVCE->tax_amt
            replace off with ARWINVCE->off
            replace reg  with ARWINVCE->reg
            replace gross_amt with ARWINVCE->gross_amt 
            REPLACE MILEAGE WITH ARWINVCE->MILEAGE
            replace vendor_n with ARWINVCE->proforma
            replace pay_method  with ARWINVCE->pay_method
            replace lpo with ARWINVCE->lpo
           REPLACE source WITH ARWINVCE->source
          REPLACE ftyp WITH ARWINVCE->ftyp
           REPLACE PMOD WITH ARWINVCE->PMOD
           REPLACE FRIGHTER_N WITH ARWINVCE->FRIGHTER_N
             replace total_amt with ARWINVCE->nonvat
             IF TAX_RATE = 0
             REPLACE TOTAL_AMT WITH 100
             ENDIF
             *replace NONVAT with ARWINVCE->NONVAT
             *replace NONVAT_AMT with ARWINVCE->NONVAT_AMT
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
   select arinvflg
   replace tran with tran + FGINVTRN->total  && transaction file updated
   
  
    local l1,l2,l3,l4
             l1 = FGINVTRN->order_no
              l2 = dtos(FGINVTRN->order_date)
              l3 = FGINVTRN->doctype
              l4 = FGINVTRN->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
               replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGINVTRN->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + ARWINVCE->total
              replace qty with qty + ARWINVCE->qty
         pcoy = ARWINVCE->st_coy
       pdate = pshdate
       pcustno = ARWINVCE->frighter_n
       Pftyp = ARWINVCE->ftyp
      ptyp = ARWINVCE->typ
       pcla = ARWINVCE->cla
       pcod = ARWINVCE->cod
       local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
        local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lsource,lpmod
      lref = ARWINVCE->ORDER_NO
      ldate = pshdate
      tdate = pshdate
      lsource = ARWINVCE->source
      lpmod = ARWINVCE->pmod
      lsys   = ARWINVCE->system
      if empty(psys)
      lsys = 'OP'  && point of sale
      endif
      ldoc   = ARWINVCE->doctype
      if empty(pdoc)
      ldoc = '18'  && job card
      endif
      lcust = ARWINVCE->frighter_n
      lftyp = ARWINVCE->Ftyp
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
      REPLACE CARD_NO  WITH LTRIM(left(ARWINVCE->SHIPNAME,18)+'-'+left(ARWINVCE->ASHIPNAME,10)+'-'+left(ARWINVCE->PURTNAME,10))
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
          REPLACE MILEAGE WITH ARWINVCE->MILEAGE
                replace driver with ARWINVCE->driver
       replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with ARWINVCE->serialno
      replace REG        WITH ARWINVCE->reg
       replace sTIME       WITH ltime
        replace LPO        WITH ARWINVCE->LPO
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
         select arinvflg
         replace stat with stat + FGINVTRN->total  && transaction file updated
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
     replace l_inv_amt with ARWINVCE->total + l_inv_amt
             replace bal_due with bal_due + ARWINVCE->total
      
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
             replace l_inv_amt with ARWINVCE->total + l_inv_amt
             replace bal_due with bal_due + ARWINVCE->total
             replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
          SELECT frighter
          SEEK psource+pftyp+ppmod+pfrighter
          if found()
      REPLACE BAL_DUE with  ARWINVCE->TOTAL + BAL_DUE
        replace turnover with 0
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
             replace l_inv_date with pshdate
             replace l_inv_amt with ARWINVCE->total + l_inv_amt
             select arinvflg
     replace mast with mast + FGINVTRN->total  && transaction file updated
              else
             select arinvflg
             endif
             select frcustbl
             REPLACE BAL_DUE with  ARWINVCE->TOTAL + BAL_DUE
     SELECT frshtrn
    replace bal_due with frighter->BAL_DUE
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->BAL_DUE
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + ARWINVCE->TOTAL
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
  REPLACE DIS_qty with ARWINVCE->dis_QTY + dis_QTY
       REPLACE SUP_qty with ARWINVCE->SUP_QTY + SUP_QTY
            REPLACE SER_AMT with ARWINVCE->SER_AMT + SER_AMT
             REPLACE LUB_AMT with ARWINVCE->LUB_AMT + LUB_AMT
 
    IF LEFT(FGINVTRN->TYP,1) = '7' && SERVICES
        SELECT FGOFFCAS
        APPEND BLANK
        REPLACE COY WITH FGINVTRN->COY
        REPLACE TYP WITH FGINVTRN->TYP
        REPLACE CLA WITH FGINVTRN->CLA
        REPLACE COD WITH FGINVTRN->COD
        REPLACE SYSTEM WITH FGINVTRN->SYSTEM
        REPLACE DOCTYPE WITH FGINVTRN->DOCTYPE
        REPLACE ORDER_NO WITH FGINVTRN->ORDER_NO
        REPLACE ORDER_DATE WITH FGINVTRN->ORDER_DATE
        REPLACE REG WITH FGINVTRN->REG
        REPLACE DRIVER WITH FGINVTRN->DRIVER
        REPLACE QTY WITH FGINVTRN->QTY * -1
        REPLACE TOTAL WITH FGINVTRN->TOTAL
        REPLACE ADV_AMT WITH 0
        REPLACE STOCK_NO WITH FGINVTRN->STOCK_NO
        REPLACE CAW_RATE WITH ARWINVCE->LEVY_AMT
        REPLACE PIT_RATE WITH ARWINVCE->LEVY_RATE
        REPLACE TBA_RATE WITH ARWINVCE->DSC
        
        ENDIF
        pmain_key = psys+pdoc+dtos(pshdate)+ARWINVCE->shiftno+ARWINVCE->shiftid+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
      replace main_key with pmain_key
      replace system with psys
        replace doctype with pdoc
        replace order_no with porder
        replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with ARWINVCE->st_coy
            replace div with ARWINVCE->st_div
            replace cen with ARWINVCE->st_cen
              replace sto with ARWINVCE->st_sto
              replace st_coy with ARWINVCE->coy
            replace st_div with ARWINVCE->div
            replace st_cen with ARWINVCE->cen
              replace st_sto with ARWINVCE->sto
              replace shift_no with ARWINVCE->shiftno
               replace shift_id with ARWINVCE->shiftid
                replace serialno with ARWINVCE->serialno
                replace dde_date with ARWINVCE->DDE_DATE
                replace dde_time with ARWINVCE->DDE_TIME
                replace dde_user with ARWINVCE->DDE_USER
                replace driver with ARWINVCE->driver
                replace scashier  with ARWINVCE->SCASHIER 
                replace soff with ARWINVCE->soff
               replace cashier_no  with ARWINVCE->cashier_no 
            replace typ with ARWINVCE->typ
            replace cla with ARWINVCE->cla
            replace cod with ARWINVCE->cod
            replace qty with ARWINVCE->qty * -1
            replace unit_cost with fgcod->cost_price
            replace new_bal with ARWINVCE->disc_amt
            replace total with ARWINVCE->total
            replace list_price with ARWINVCE->list_price
            replace tax_rate with ARWINVCE->tax_rate
            replace tax_amt with ARWINVCE->tax_amt
            replace off with ARWINVCE->off
            replace reg  with ARWINVCE->reg
            replace gross_amt with ARWINVCE->gross_amt
            REPLACE MILEAGE WITH ARWINVCE->MILEAGE
            replace vendor_n with ARWINVCE->proforma
            replace pay_method  with ARWINVCE->pay_method
            replace lpo with ARWINVCE->lpo
           REPLACE source WITH ARWINVCE->source
          REPLACE ftyp WITH ARWINVCE->ftyp
           REPLACE PMOD WITH ARWINVCE->PMOD
           REPLACE FRIGHTER_N WITH ARWINVCE->FRIGHTER_N
             replace total_amt with ARWINVCE->nonvat
             replace sprice with total_amt
             IF TAX_RATE = 0
             REPLACE TOTAL_AMT WITH 100
             ENDIF
             *replace NONVAT with ARWINVCE->NONVAT
             *replace NONVAT_AMT with ARWINVCE->NONVAT_AMT
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