Procedure ar30grn  
PARAMETER BUSER,BLEVEL
clear program
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "ar30grn.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
    set reprocess to 10000
    select frighter
    set order to frighter
    
select argrnup

set order to mkey
SELECT FGMAST

SET ORDER TO MKEY
SELECT ST15F

SET ORDER TO MKEY
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pargrns,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,PT1,PT2,PT3
            pposted = .f.
     eofargrline = .f.
      select fgcoy
      go top
      select argrns
      
      go top
      if .not. eof()
       select argrline
       
    set filter to order_no = argrns->order_no .and. empty(post_date) .AND. .NOT. (TOTAL = 0 ;
     .and. qty = 0)  .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(stock_no)   .and. empty(post_date) .and. .not. empty(st_coy) ;
     .and. .not. empty(st_div) .and. .not. empty(st_cen) .and. .not. empty(st_sto) ;
      .and. .not. empty(trantype)  .and. .not. empty(off) ;
       .and. .not. empty(cashier_no) .and. .not. empty(driver)
            go top
                if .not. eof()
   ? "STEP 2"
   pposted = .t.
                do
                do line_rtn
                until eofargrline
                  select argrnsn
                go top
                if eof()
                append blank
                endif
                replace order_no with argrns->order_no
               endif
          endif
          SELECT FGCOY
          FLUSH
          
          
          SET AUTOSAVE OFF
                close databases
procedure line_rtn
            local l1,l2,l11,l22,l3,lok, lerr
            lerr = .t.
               begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

              select argrnup
            seek argrline->order_no+dtos(argrns->order_date)+argrline->stock_no+argrline->dde_time
            if .not. found()
            append blank
            replace order_no with argrline->order_no
            replace order_date with argrns->order_date
            replace stock_no with argrline->stock_no
            replace dde_time with argrline->dde_time
                     do cont_rtn
     
          select argrline
    replace post_date with date()
   SELECT argrnup
    replace post_date with date()
     endif
        COMMIT()
   select argrline   
       SKIP
    IF EOF()
     eofargrline = .T.
    ENDIF
   procedure cont_rtn
         
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
            if val(pmonth) < 10
         pmonth = "0"+str(val(pmonth),1)
           endif
   pdoc = "15"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
              local lld1,lld2
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
      PSHNO2 = argrline->SHIFT_NO
      PCOY = argrline->ST_COY
      PDIV = argrline->ST_DIV
      PCEN = argrline->ST_CEN
      PSTO = argrline->ST_STO
      PTYP = argrline->TYP
      PCLA = argrline->CLA
      PCOD = argrline->COD
      PCOY2 = argrline->COY
      PDIV2 = argrline->DIV
      PCEN2 = argrline->CEN
      PSTO2 = argrline->STO
      PSHID2 = argrline->shift_id
      porder = argrns->order_no
      pshm = .t.
     psys   = "OP"  && point of sale
      pdoc   = "15"  && job card
      pstockno = argrline->stock_no
                 select arwinvce
           append blank
           replace currname with argrns->currname
           replace shipname with argrns->shipname
           replace ashipname with argrns->ashipname
           replace purtname with argrns->purtname
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with argrline->coy
            replace div with argrline->div
            replace cen with argrline->cen
              replace sto with argrline->sto
              replace st_coy with argrline->st_coy
            replace st_div with argrline->st_div
            replace st_cen with argrline->st_cen
              replace st_sto with argrline->st_sto
              replace shiftno with argrns->shiftno
               replace shiftid with argrns->shiftid
                replace serialno with argrns->order
                replace dde_date with date()
                replace dde_time with time()
                replace dde_user with PLUSER
                replace driver with argrline->driver
                replace scashier  with argrns->cashier_no 
                replace soff with argrns->off
               replace cashier_no  with argrline->cashier_no 
            replace typ with argrline->typ
            replace cla with argrline->cla
            replace cod with argrline->cod
            replace qty with argrline->qty
            replace cost_price with argrline->cost_price
            replace disc_amt with argrline->disc_amt
            replace total with argrline->total
            replace list_price with argrline->list_price
            replace tax_rate with argrline->tax_rate
            replace tax_amt with argrline->tax_amt
            replace off with argrline->off
            replace reg  with argrns->reg
            replace gross_amt with argrline->gross_amt
            REPLACE MILEAGE WITH argrns->MILEAGE
            replace proforma with dtos(argrns->po_date)
            replace pay_method  with "Credit"
            replace lpo with argrns->po_inv
           REPLACE source WITH argrns->source
          REPLACE ftyp WITH argrns->ftyp
           REPLACE PMOD WITH argrns->PMOD
           REPLACE FRIGHTER_N WITH argrns->FRIGHTER_N
            replace basic_amt with argrline->basic_amt
             REPLACE DIS_QTY with argrline->DIS_QTY
         REPLACE SUP_QTY with argrline->SUP_QTY
         REPLACE SER_AMT with argrline->SER_AMT
         REPLACE LUB_AMT with argrline->LUB_AMT
          replace shift_no with argrline->SHIFT_NO
               replace shift_id with argrline->SHIFT_id
               replace shift_date with argrline->shift_date
               if argrns->source = 'S'
               replace hq_off with argrns->hq_off
               endif
            replace dsc with argrline->dsc
            replace levy_rate with argrline->levy_rate
            replace levy_amt with argrline->levy_amt
          pcoy = st_coy
            pdiv = st_div
            pcen = st_cen
            psto = st_sto
            ptyp = typ
            pcla = cla
            pcod = cod
            pqty = qty
            select frighter
            seek arwinvce->source+arwinvce->ftyp+arwinvce->pmod+arwinvce->frighter_n
            if found()
            *rlock()
            replace turnover with turnover + arwinvce->total
            endif
            *unlock
             if ptyp <= "9Z" .and. .not. left(ptyp,1) = "7" .and. .not. ptyp="00"
             select fgmast
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
             if found()
             *rlock()
             replace m_var with m_var - pqty
             *unlock
             endif
             endif
  
              
            
             
           
