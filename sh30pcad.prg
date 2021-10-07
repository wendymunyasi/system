Procedure SH30PCAD
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
   * SET AUTOSAVE ON
    SET VIEW TO "SH30PCAD.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfgviscad,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
              PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
   set reprocess to 10000
   select st15f
   go top
     select arvisflg
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
wait 'Errors with Posting Credit Cards - Contact System Team!'
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
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)

IF EMPTY(SHIFT_DATE) .OR. EMPTY(SHIFT_ID) .OR. EMPTY(SHIFT_NO)
WAIT 'EMPTY SHIFTMASTER!'
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
select frshtrn

set order to mkey
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfgviscad,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            pposted = .t.
      eofFGVISCAD = .f.
      select fgcoy
      go top
    
        select FGVISCAD
        dele all for year(order_date) < 1
        set filter to empty(post_date)
             go top
                if .not. eof()
                do
                do line_rtn
                until eofFGVISCAD
                endif
                set safety off
                select fgviscad
                zap
              select fgcoy
             flush
             
              
             SET AUTOSAVE OFF
             set safety on
           
            close databases
            set safety off
         
            close databases
  set safety on
           
procedure line_rtn
            local l1,l2,l11,l22,l3,lok, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
         IF EMPTY(FGVISCAD->SYSTEM)
        psys = "AR"
        ELSE
        PSYS = FGVISCAD->SYSTEM
        ENDIF
        IF EMPTY(FGVISCAD->DOCTYPE)
        pdoc = "28"
        ELSE
        PDOC = FGVISCAD->DOCTYPE
        ENDIF
                 local lld1,lld2
    pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   
      PSHNO2 = FGVISCAD->SHIFT_NO
      PCOY = FGVISCAD->ST_COY
      PDIV = FGVISCAD->ST_DIV
      PCEN = FGVISCAD->ST_CEN
      PSTO = FGVISCAD->ST_STO
      PTYP = FGVISCAD->TYP
      PCLA = FGVISCAD->CLA
      PCOD = FGVISCAD->COD
      PCOY2 = FGVISCAD->COY
      PDIV2 = FGVISCAD->DIV
      PCEN2 = FGVISCAD->CEN
      PSTO2 = FGVISCAD->STO
      PSHID2 = FGVISCAD->shift_id
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if .not. found()
       if .not. found()
        Wait 'fgviscad - Problem with stock masterfile - Try Again Later!'
           quit
      endif
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
         replace tax_amt   with 0
         replace gross_amt  with 0
          replace cs_pur_qty with 0
         replace cr_pur_qty with 0
        replace cs_pur_shs with 0
         replace cr_pur_shs with 0
         replace cs_sal_shs with 0
         replace cr_sal_shs with 0
         replace nonvat   with fgviscad->nonvat
         replace nonvat_amt with 0
         REPLACE TAX_RATE WITH fgviscad->TAX_RATE
         REPLACE LIST_PRICE WITH fgviscad->LIST_PRICE
         REPLACE COST_PRICE WITH fgviscad->COST_PRICE
      endif
      
               pfrighter = fgviscad->frighter_N
               porder = fgviscad->order_no
                        pftyp = fgviscad->ftyp
                          pcashrno = FGVISCAD->cashier_no
                          psource = fgviscad->source
                          ppmod = fgviscad->pmod
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
 replace off with FGVISCAD->off
   endif
   
   IF EMPTY(OFF)
   replace off with FGVISCAD->off
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
        Wait 'fgviscad - Problem with customer masterfile in Credit Visa Cards - Try Again Later!'
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
        if pdiv2 = "1" .and. .not. empty(FGVISCAD->shift_date) ;
         .and. .not. empty(FGVISCAD->shift_no) .and. .not. empty(FGVISCAD->shift_id)
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
                    Wait 'fgviscad - Problem with shift masterfile - Try Again Later!'
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
    DO FGVISCAD_3018RTN2
     
     if pdiv2 = "1" .and. pst15f
                select scashrec
                seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
         if fgviscad->frighter_n = "0001" && bonvoyage
       replace coyvisa with coyvisa + FGVISCAD->total+FGVISCAD->disc_amt
    else
    if fgviscad->frighter_n = "0002"  && bbk
       replace bbkvisa with bbkvisa + FGVISCAD->total+FGVISCAD->disc_amt
         
      else
      replace genvisa with genvisa + FGVISCAD->total+FGVISCAD->disc_amt
       endif
     endif
          else
            select scashrec
            seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
            replace exp_sales with exp_sales  + FGVISCAD->total
  
    if fgviscad->frighter_n = "0001" && bonvoyage
       replace coyvisa with coyvisa + FGVISCAD->total
    else
    if fgviscad->frighter_n = "0002"  && bbk
       replace bbkvisa with bbkvisa + FGVISCAD->total
         
      else
      replace genvisa with genvisa + FGVISCAD->total
       endif
     endif
      endif
        IF PSHM
     select shstmast
     seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
                  replace on_hand with on_hand - FGVISCAD->qty
                         replace cr_sales with cr_sales + FGVISCAD->qty
                          if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - FGVISCAD->qty
       replace sales with sales + FGVISCAD->qty
       endif
                         select fgmast
                         seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD
                               REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - FGVISCAD->QTY
                 replace cr_sales with cr_sales + FGVISCAD->qty
                 replace m_var with m_var  + FGVISCAD->qty
     ENDIF
        select shcatsum
        seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                     replace cr_sal_qty with cr_sal_qty + FGVISCAD->qty
                        replace cr_sal_shs with cr_sal_shs + FGVISCAD->total+FGVISCAD->disc_amt
                        REPLACE TAX_AMT WITH TAX_AMT + FGVISCAD->TAX_AMT
                        REPLACE GROSS_AMT WITH GROSS_AMT + FGVISCAD->GROSS_AMT
                      *  REPLACE NONVAT_AMT WITH NONVAT_AMT + FGVISCAD->NONVAT_AMT
       
                   select FGVISCAD
             replace post_date with date()
    COMMIT()
   select FGVISCAD   
       SKIP
    IF EOF()
     eofFGVISCAD = .T.
    ENDIF
    
           

   
  PROCEDURE FGVISCAD_3018RTN2
  
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
        IF EMPTY(FGVISCAD->SYSTEM)
        psys = "AR"
        ELSE
        PSYS = FGVISCAD->SYSTEM
        ENDIF
        IF EMPTY(FGVISCAD->DOCTYPE)
        pdoc = "28"
        ELSE
        PDOC = FGVISCAD->DOCTYPE
        ENDIF
      pstockno = FGVISCAD->stock_no
     IF FGVISCAD->TYP = "00" .and. pst15f  && fuel forecourt
        SELECT ST15F
        SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + FGVISCAD->QTY
          REPLACE ST15F->NON_CASH WITH FGVISCAD->TOTAL + ST15F->NON_CASH  + FGVISCAD->disc_amt
          REPLACE SHIFT_POST WITH DATE()
     ELSE
     IF  PST15F 
    SELECT ST15F
    SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty +  FGVISCAD->QTY
           REPLACE ST15F->NON_CASH WITH FGVISCAD->TOTAL + ST15F->NON_CASH + FGVISCAD->disc_amt
               REPLACE SHIFT_POST WITH DATE()
    ENDIF
     ENDIF
     
   local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = pshdate
        IF EMPTY(FGVISCAD->SYSTEM)
        psys = "AR"
        ELSE
        PSYS = FGVISCAD->SYSTEM
        ENDIF
        IF EMPTY(FGVISCAD->DOCTYPE)
        pdoc = "28"
        ELSE
        PDOC = FGVISCAD->DOCTYPE
        ENDIF
        l4 = fgviscad->order_no
        l5 = FGVISCAD->stock_no
        l6 = fgviscad->shiftno
        l7 = FGVISCAD->st_COY
        l8 = FGVISCAD->st_div
        l9 = FGVISCAD->st_cen
        l10 = FGVISCAD->st_sto
        l11 = FGVISCAD->typ
        l12 = FGVISCAD->cla
        l13 = FGVISCAD->cod
        l14 = FGVISCAD->shift_id
         
          ppay = fgviscad->PAY_METHOD
         pcustno  =  fgviscad->frighter_N
         pftyp = fgviscad->ftyp
         psource = fgviscad->source
         ppmod = fgviscad->pmod
                LOCAL D1,D2
                
              D1 = DTOS(pshdate)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = FGVISCAD->QTY * -1
               PTTOTAL = FGVISCAD->TOTAL
               PTVAT = FGVISCAD->tax_amt  && get vat amount
              PCOY = FGVISCAD->st_COY
              PDIV = FGVISCAD->st_DIV
              PCEN = FGVISCAD->st_CEN
              PTYP = FGVISCAD->TYP
              PSTO = FGVISCAD->st_STO
              PCLA = FGVISCAD->CLA
              PCOD = FGVISCAD->COD
                ptcost = FGVISCAD->qty * FGVISCAD->cost_price
                          pother = .F.
                        pcash = .f.
                        pcredit = .f.
                        pcheque = .f.
                        pcard = .f.
         pcard = .T.
         
     ptdate = pshdate
              select fgvistrn
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with FGVISCAD->st_coy
            replace div with FGVISCAD->st_div
            replace cen with FGVISCAD->st_cen
              replace sto with FGVISCAD->st_sto
              replace st_coy with FGVISCAD->coy
            replace st_div with FGVISCAD->div
            replace st_cen with FGVISCAD->cen
              replace st_sto with FGVISCAD->sto
              replace shift_no with fgviscad->shiftno
               replace shift_id with fgviscad->shiftid
                replace serialno with fgviscad->serialno
                replace dde_date with FGVISCAD->dde_date
                replace dde_time with FGVISCAD->dde_time
                replace dde_user with FGVISCAD->dde_user
                replace driver with FGVISCAD->driver
                replace CARD_RUN with fgviscad->card_run
                replace cashier_no  with FGVISCAD->cashier_no 
             replace typ with FGVISCAD->typ
            replace cla with FGVISCAD->cla
            replace cod with FGVISCAD->cod
            replace qty with FGVISCAD->qty * -1
            replace unit_cost with FGVISCAD->cost_price
          replace new_bal with FGVISCAD->disc_amt
            replace total with FGVISCAD->total
            replace list_price with FGVISCAD->list_price
            replace tax_rate with FGVISCAD->tax_rate
            replace tax_amt with FGVISCAD->tax_amt
            replace off with FGVISCAD->off
            replace reg  with fgviscad->reg
            replace gross_amt with FGVISCAD->gross_amt
            replace pay_method with "Visacard"
            replace lpo with fgviscad->lpo
           REPLACE source WITH fgviscad->source
          REPLACE ftyp WITH fgviscad->ftyp
           REPLACE PMOD WITH fgviscad->PMOD
           REPLACE FRIGHTER_N WITH fgviscad->FRIGHTER_N
             replace total_amt with fgviscad->nonvat
             IF TAX_RATE = 0
             REPLACE TOTAL_AMT WITH 100
             ENDIF
         REPLACE CARD_NO WITH fgviscad->CARD_NO
         *  replace NONVAT with fgviscad->NONVAT
          *   replace NONVAT_AMT with fgviscad->NONVAT_AMT
          
              LOCAL L1,L2,L3,L4,L5,l6,l7,l8,l9
   L1 = fgvistrn->SOURCE
   L2 = fgvistrn->FTYP
   L3 = fgvistrn->PMOD
   L4 = fgvistrn->FRIGHTER_N
   L5 = fgvistrn->SYSTEM
   L6 = fgvistrn->DOCTYPE
   L7 = fgvistrn->ORDER_DATE
  
   select arvisflg
      replace tran with tran + fgvistrn->total  && transaction file updated
    local l1,l2,l3,l4
             l1 = fgvistrn->order_no
              l2 = dtos(fgvistrn->order_date)
              l3 = fgvistrn->doctype
              l4 = fgvistrn->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
               replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fgvistrn->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGVISCAD->total
              replace qty with qty + FGVISCAD->qty
         pcoy = FGVISCAD->st_coy
       pdate = pshdate
       pcustno = fgviscad->frighter_n
       Pftyp = fgviscad->ftyp
      ptyp = FGVISCAD->typ
       pcla = FGVISCAD->cla
       pcod = FGVISCAD->cod
       local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
        local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lsource,lpmod
      lref = fgviscad->ORDER_NO
      ldate = pshdate
      tdate = pshdate
      lsource = fgviscad->source
      lpmod = fgviscad->pmod
      lsys = PSYS
      ldoc = PDOC
      lcust = fgviscad->frighter_n
      lftyp = fgviscad->Ftyp
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
      REPLACE frighter_N WITH lcust
      replace source with lsource
      replace pmod with lpmod
       replace mm with pmm
      replace yy with pyy
     REPLACE CARD_NO WITH fgviscad->CARD_NO
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
                replace driver with fgviscad->driver
       replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with fgviscad->serialno
      replace REG        WITH fgviscad->reg
       replace sTIME       WITH ltime
        replace LPO        WITH fgviscad->LPO
         replace pay_method with "Visacard"
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
         select arvisflg
         replace stat with stat + fgvistrn->total
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
     replace l_inv_amt with FGVISCAD->total + l_inv_amt
             replace bal_due with bal_due + FGVISCAD->total
      
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
             replace l_inv_amt with FGVISCAD->total + l_inv_amt
             replace bal_due with bal_due + FGVISCAD->total
             replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
          SELECT frighter
          SEEK psource+pftyp+ppmod+pfrighter
          if found()
      REPLACE BAL_DUE with  FGVISCAD->TOTAL + BAL_DUE
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
             replace l_inv_date with pshdate
             replace l_inv_amt with FGVISCAD->total + l_inv_amt
               select arvisflg
         replace mast with mast + fgvistrn->total
     
             else
               select arvisflg
     endif
              select frcustbl
              REPLACE BAL_DUE with  FGVISCAD->TOTAL + BAL_DUE
     SELECT frshtrn
    replace bal_due with frighter->BAL_DUE
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->BAL_DUE
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + FGVISCAD->TOTAL
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
  REPLACE DIS_qty with FGVISCAD->dis_QTY + dis_QTY
       REPLACE SUP_qty with FGVISCAD->SUP_QTY + SUP_QTY
            REPLACE SER_AMT with FGVISCAD->SER_AMT + SER_AMT
             REPLACE LUB_AMT with FGVISCAD->LUB_AMT + LUB_AMT
 
IF LEFT(fgvistrn->TYP,1) = '7' && SERVICES
        SELECT FGOFFCAS
        APPEND BLANK
        REPLACE COY WITH fgvistrn->COY
        REPLACE TYP WITH fgvistrn->TYP
        REPLACE CLA WITH fgvistrn->CLA
        REPLACE COD WITH fgvistrn->COD
        REPLACE SYSTEM WITH fgvistrn->SYSTEM
        REPLACE DOCTYPE WITH fgvistrn->DOCTYPE
        REPLACE ORDER_NO WITH fgvistrn->ORDER_NO
        REPLACE ORDER_DATE WITH fgvistrn->ORDER_DATE
        REPLACE REG WITH fgvistrn->REG
        REPLACE DRIVER WITH fgvistrn->DRIVER
        REPLACE QTY WITH fgvistrn->QTY * -1
        REPLACE TOTAL WITH fgvistrn->TOTAL
        REPLACE ADV_AMT WITH 0
        REPLACE STOCK_NO WITH fgvistrn->STOCK_NO
        REPLACE CAW_RATE WITH FGVISCAD->LEVY_AMT
        REPLACE PIT_RATE WITH FGVISCAD->LEVY_RATE
        REPLACE TBA_RATE WITH FGVISCAD->DSC
   
        ENDIF
          pmain_key = psys+pdoc+dtos(pshdate)+fgviscad->shiftno+fgviscad->shiftid+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
    REPLACE MAIN_KEY WITH PMAIN_KEY
  replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with FGVISCAD->st_coy
            replace div with FGVISCAD->st_div
            replace cen with FGVISCAD->st_cen
              replace sto with FGVISCAD->st_sto
              replace st_coy with FGVISCAD->coy
            replace st_div with FGVISCAD->div
            replace st_cen with FGVISCAD->cen
              replace st_sto with FGVISCAD->sto
              replace shift_no with fgviscad->shiftno
               replace shift_id with fgviscad->shiftid
                replace serialno with fgviscad->serialno
                replace dde_date with FGVISCAD->dde_date
                replace dde_time with FGVISCAD->dde_time
                replace dde_user with FGVISCAD->dde_user
                replace driver with FGVISCAD->driver
                replace CARD_RUN with fgviscad->card_run
                replace cashier_no  with FGVISCAD->cashier_no 
             replace typ with FGVISCAD->typ
            replace cla with FGVISCAD->cla
            replace cod with FGVISCAD->cod
            replace qty with FGVISCAD->qty * -1
            replace unit_cost with FGVISCAD->cost_price
          replace new_bal with FGVISCAD->disc_amt
            replace total with FGVISCAD->total
            replace list_price with FGVISCAD->list_price
            replace tax_rate with FGVISCAD->tax_rate
            replace tax_amt with FGVISCAD->tax_amt
            replace off with FGVISCAD->off
            replace soff with off
            replace mileage with 0
            replace scashier with cashier_no
            replace sprice with fgviscad->nonvat
            replace unl with 0
            replace dis with 0
            replace svc with 0
            replace lub with 0
            if typ='00' .and. cla='10'
            replace unl with 1
           else
           if typ='00' .and. cla='50'
            replace dis with 1
           else
            if typ='10' 
            replace lub with 1
           else
            replace svc with 1
           endif
           endif
           endif
            replace reg  with fgviscad->reg
            replace gross_amt with FGVISCAD->gross_amt 
            replace pay_method with "Visacard"
            replace lpo with fgviscad->lpo
           REPLACE source WITH fgviscad->source
          REPLACE ftyp WITH fgviscad->ftyp
           REPLACE PMOD WITH fgviscad->PMOD
           REPLACE FRIGHTER_N WITH fgviscad->FRIGHTER_N
             replace total_amt with fgviscad->nonvat
             IF TAX_RATE = 0
             REPLACE TOTAL_AMT WITH 100
             ENDIF
         REPLACE CARD_NO WITH fgviscad->CARD_NO
          replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with frighter->cus_acc