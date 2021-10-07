Procedure fg30ucnt
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "fg30ucnt.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfgucnts,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
               PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
    
        set reprocess to -1
select fgucrup
set order to mkey
select fgmast2
set  order to mkey
select fgmast
set  order to mkey
      eoffgucnlin = .f.
      pposted = .f.
      select fgcoy
      go top
    
      SELECT fgucnts
      GO TOP
      IF .NOT. EOF()
       select fgucnlin
    set filter to order_no = fgucnts->order_no .and. empty(post_date) .AND. .NOT. (TOTAL = 0 .and. qty = 0);
     .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(stock_no) .and. .not. empty(off) .and. .not. empty(cashier_no) ;
     .and. .not. empty(driver)
   
           go top
                if .not. eof()
      pposted = .t.
                do
                do line_rtn
                until eoffgucnlin
                select fgucntsn
                go top
                if eof()
                append blank
                endif
                replace order_no with fgucnts->order_no
                
                  endif
               ENDIF
               SELECT FGCOY
               FLUSH
               
               
               SET AUTOSAVE OFF
close databases
procedure line_rtn
            local l1,l2,l11,l22,l3, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            select fgucrup
            seek fgucnlin->order_no+dtos(fgucnts->order_date)+fgucnlin->stock_no+fgucnlin->dde_time
            if .not. found()
            append blank
            replace order_no with fgucnlin->order_no
            replace order_date with fgucnts->order_date
            replace stock_no with fgucnlin->stock_no
            replace dde_time with fgucnlin->dde_time
         do cont_rtn
          select fgucnlin   
             replace post_date with date()
    SELECT fgucrup
    replace post_date with date()
     endif
       
      COMMIT()
   select fgucnlin   
       SKIP
    IF EOF()
     eoffgucnlin = .T.
    ENDIF
 procedure cont_rtn
   
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
      psys   = 'CN'  && point of sale
      pdoc   = 'LB'  && job card
      pstockno = fgucnlin->stock_no
    
                     
    local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = fgucnts->ORDER_DATE
        psys = "CN"
        pdoc = 'LB'
        l4 = fgucnts->order_no
        l5 = fgucnlin->stock_no
        l6 = fgucnts->shiftno
        l7 = fgucnlin->st_COY
        l8 = fgucnlin->st_div
        l9 = fgucnlin->st_cen
        l10 = fgucnlin->st_sto
        l11 = fgucnlin->typ
        l12 = fgucnlin->cla
        l13 = fgucnlin->cod
        l14 = fgucnlin->shift_id
         
          ppay = fgucnts->PAY_METHOD
         pcustno  =  fgucnts->frighter_N
         pftyp = fgucnts->ftyp
         psource = fgucnts->source
         ppmod = fgucnts->pmod
                LOCAL D1,D2
                
              D1 = DTOS(fgucnts->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = fgucnlin->QTY * -1
               PTTOTAL = fgucnlin->TOTAL
               PTVAT = fgucnlin->vat_out  && get vat amount
              PCOY = fgucnlin->ST_COY
              PDIV = fgucnlin->ST_DIV
              PCEN = fgucnlin->ST_CEN
              PTYP = fgucnlin->TYP
              PSTO = fgucnlin->ST_STO
              PCLA = fgucnlin->CLA
              PCOD = fgucnlin->COD
                ptcost = fgucnlin->qty * fgucnlin->cost_price
              
                    
             
                        pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
     ptdate = fgucnts->order_date
          select fglusals
          append blank
          replace system with psys
          replace doctype with pdoc
          replace order_no with fgucnts->order_no
             REPLACE source WITH fgucnts->source
          REPLACE ftyp WITH fgucnts->ftyp
           REPLACE PMOD WITH fgucnts->PMOD
           REPLACE FRIGHTER_N WITH fgucnts->FRIGHTER_N
              REPLACE SERIALNO WITH fgucnts->SERIALNO
         replace order_date with fgucnts->order_date
         replace lpo with fgucnts->lpo
           replace reg  with fgucnts->reg
             replace pay_method  with fgucnts->pay_method
       replace pay_mode with 'Cash'
        replace shiftid with fgucnts->shiftid
        replace shiftno  with fgucnts->shiftno
        replace shiftdate with fgucnts->shiftdate
        replace cashier_no  with fgucnlin->cashier_no
               replace dde_date with  fgucnlin->dde_date
                replace dde_time with fgucnlin->dde_time
                replace dde_user with fgucnlin->dde_user
            replace mileage with fgucnts->mileage
            replace off with fgucnlin->off
         replace stock_no with fgucnlin->stock_no
         replace coy with fgucnlin->coy
            replace div with fgucnlin->div
            replace cen with fgucnlin->cen
              replace sto with fgucnlin->sto
              replace st_coy with fgucnlin->st_coy
            replace st_div with fgucnlin->st_div
            replace st_cen with fgucnlin->st_cen
              replace st_sto with fgucnlin->st_sto
              replace shift_no with fgucnlin->shift_no
              replace shift_id with fgucnlin->shift_id
                 replace typ with fgucnlin->typ
            replace cla with fgucnlin->cla
            replace cod with fgucnlin->cod
            replace qty with fgucnlin->qty
            replace cost_price with fgucnlin->cost_price
            replace discount with fgucnlin->discount
            replace total with fgucnlin->total
            replace sell_price with fgucnlin->sell_price
            replace vat with fgucnlin->vat
            replace vat_out with fgucnlin->vat_out
             replace gross_amt with fgucnlin->gross_amt
            replace cashier_no with fgucnlin->cashier_no
             replace total_amt with fgucnlin->total_amt
             replace driver with fgucnlin->driver
              replace PR_QTY with fgucnlin->PR_QTY
              replace reference with fgucnlin->reference
            replace nonvat with fgucnlin->nonvat
              replace nonvat_amt with fgucnlin->nonvat_amt
       if typ <= "9Z" .and. .not. left(typ,1) = "7" .and. .not. typ="00" .and. .not. qty = 0
             select fgmast
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
             replace m_var with m_var - fgucnlin->qty
              select fgmast2
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
             replace m_var with m_var - fgucnlin->qty
              endif
