Procedure ar30rinv  
PARAMETER BUSER,BLEVEL
clear program
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "ar30rinv.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
    set reprocess to 10000
    select frighter
    set order to frighter
    
select arrinvsp

set order to mkey
SELECT FGMAST
SET ORDER TO MKEY
SELECT FGMAST2
SET ORDER TO MKEY
SELECT ST15F
SET ORDER TO MKEY
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Parrinvs,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,PT1,PT2,PT3
            pposted = .f.
     eofarrinvln = .f.
      select fgcoy
      go top
      select arrinvs
      
      go top
      if .not. eof()
       select arrinvln
       
    set filter to order_no = arrinvs->order_no .and. empty(post_date) .AND. .NOT. (TOTAL = 0 ;
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
                until eofarrinvln
                  select arrinvsn
                go top
                if eof()
                append blank
                endif
                replace order_no with arrinvs->order_no
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

              select arrinvsp
            seek arrinvln->order_no+dtos(arrinvs->order_date)+arrinvln->stock_no+arrinvln->dde_time
            if .not. found()
            append blank
            replace order_no with arrinvln->order_no
            replace order_date with arrinvs->order_date
            replace stock_no with arrinvln->stock_no
            replace dde_time with arrinvln->dde_time
                     do cont_rtn
     
          select arrinvln
    replace post_date with date()
   SELECT arrinvsp
    replace post_date with date()
     endif
        COMMIT()
   select arrinvln   
       SKIP
    IF EOF()
     eofarrinvln = .T.
    ENDIF
   procedure cont_rtn
         
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
            if val(pmonth) < 10
         pmonth = "0"+str(val(pmonth),1)
           endif
   pdoc = '16'
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
      PSHNO2 = arrinvln->SHIFT_NO
      PCOY = arrinvln->ST_COY
      PDIV = arrinvln->ST_DIV
      PCEN = arrinvln->ST_CEN
      PSTO = arrinvln->ST_STO
      PTYP = arrinvln->TYP
      PCLA = arrinvln->CLA
      PCOD = arrinvln->COD
      PCOY2 = arrinvln->COY
      PDIV2 = arrinvln->DIV
      PCEN2 = arrinvln->CEN
      PSTO2 = arrinvln->STO
      PSHID2 = arrinvln->shift_id
      porder = arrinvs->order_no
      pshm = .t.
     psys   = "OP"  && point of sale
      pdoc   = '16'  && job card
      pstockno = arrinvln->stock_no
                 select arwinvce
           append blank
           replace currname with arrinvs->currname
           replace shipname with arrinvs->shipname
           replace ashipname with arrinvs->ashipname
           replace purtname with arrinvs->purtname
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with arrinvln->coy
            replace div with arrinvln->div
            replace cen with arrinvln->cen
              replace sto with arrinvln->sto
              replace st_coy with arrinvln->st_coy
            replace st_div with arrinvln->st_div
            replace st_cen with arrinvln->st_cen
              replace st_sto with arrinvln->st_sto
              replace shiftno with arrinvs->shiftno
               replace shiftid with arrinvs->shiftid
                replace serialno with arrinvs->serialno
                replace dde_date with date()
                replace dde_time with time()
                replace dde_user with PLUSER
                replace driver with arrinvln->driver
                replace scashier  with arrinvs->cashier_no 
                replace offname with arrinvs->j_mkey
                replace soff with arrinvs->off
               replace cashier_no  with arrinvln->cashier_no 
            replace typ with arrinvln->typ
            replace cla with arrinvln->cla
            replace cod with arrinvln->cod
            replace qty with arrinvln->qty
            replace cost_price with arrinvln->cost_price
            replace disc_amt with arrinvln->disc_amt
            replace total with arrinvln->total
            replace list_price with arrinvln->list_price
            replace tax_rate with arrinvln->tax_rate
            replace tax_amt with arrinvln->tax_amt
            replace off with arrinvln->off
            replace reg  with arrinvs->reg
            replace gross_amt with arrinvln->gross_amt
            REPLACE MILEAGE WITH arrinvs->MILEAGE
            replace proforma with arrinvs->proforma
            replace pay_method  with "Credit"
            replace lpo with arrinvs->lpo
           REPLACE source WITH arrinvs->source
          REPLACE ftyp WITH arrinvs->ftyp
           REPLACE PMOD WITH arrinvs->PMOD
           REPLACE FRIGHTER_N WITH arrinvs->FRIGHTER_N
            replace basic_amt with arrinvln->basic_amt
             REPLACE DIS_QTY with arrinvln->DIS_QTY
         REPLACE SUP_QTY with arrinvln->SUP_QTY
         REPLACE SER_AMT with arrinvln->SER_AMT
         REPLACE LUB_AMT with arrinvln->LUB_AMT
         replace nonvat with arrinvln->nonvat
         replace nonvat_amt with arrinvln->nonvat * qty
          replace shift_no with arrinvln->SHIFT_NO
               replace shift_id with arrinvln->SHIFT_id
               replace shift_date with arrinvln->shift_date
               if arrinvs->source = 'S'
               replace hq_off with arrinvs->hq_off
               endif
            replace dsc with arrinvln->dsc
            replace levy_rate with arrinvln->levy_rate
            replace levy_amt with arrinvln->levy_amt
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
            rlock()
            replace turnover with turnover + arwinvce->total
            endif
            
             if ptyp <= "9Z" .and. .not. left(ptyp,1) = "7" .and. .not. ptyp="00"
               select fgmast2
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
              replace m_var with m_var - pqty
             endif
  
              
            
             
           
