Procedure fg30lcnt
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "fg30lcnt.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfglcnts,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
               PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
    
        set reprocess to -1
select fglcrup
set order to mkey
select fgmast2
set  order to mkey
select fgmast
set  order to mkey
      eoffglcnlin = .f.
      pposted = .f.
      select fgcoy
      go top
    
      SELECT fglcnts
      GO TOP
      IF .NOT. EOF()
       select fglcnlin
    set filter to order_no = fglcnts->order_no .and. empty(post_date) .AND. .NOT. (TOTAL = 0 .and. qty = 0) ;
     .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(stock_no) .and. .not. empty(off) .and. .not. empty(cashier_no) ;
     .and. .not. empty(driver)
   
           go top
                if .not. eof()
      pposted = .t.
                do
                do line_rtn
                until eoffglcnlin
                select fglcntsn
                go top
                if eof()
                append blank
                endif
                replace order_no with fglcnts->order_no
                
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

            select fglcrup
            seek fglcnlin->order_no+dtos(fglcnts->order_date)+fglcnlin->stock_no+fglcnlin->dde_time
            if .not. found()
            append blank
            replace order_no with fglcnlin->order_no
            replace order_date with fglcnts->order_date
            replace stock_no with fglcnlin->stock_no
            replace dde_time with fglcnlin->dde_time
         do cont_rtn
          select fglcnlin   
             replace post_date with date()
    SELECT fglcrup
    replace post_date with date()
     endif
       
      COMMIT()
   select fglcnlin   
       SKIP
    IF EOF()
     eoffglcnlin = .T.
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
      pdoc   = "LP"  && job card
      pstockno = fglcnlin->stock_no
    
                     
    local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = fglcnts->ORDER_DATE
        psys = "CN"
        pdoc = "LP"
        l4 = fglcnts->order_no
        l5 = fglcnlin->stock_no
        l6 = fglcnts->shiftno
        l7 = fglcnlin->st_COY
        l8 = fglcnlin->st_div
        l9 = fglcnlin->st_cen
        l10 = fglcnlin->st_sto
        l11 = fglcnlin->typ
        l12 = fglcnlin->cla
        l13 = fglcnlin->cod
        l14 = fglcnlin->shift_id
         
          ppay = fglcnts->PAY_METHOD
         pcustno  =  fglcnts->frighter_N
         pftyp = fglcnts->ftyp
         psource = fglcnts->source
         ppmod = fglcnts->pmod
                LOCAL D1,D2
                
              D1 = DTOS(fglcnts->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = fglcnlin->QTY * -1
               PTTOTAL = fglcnlin->TOTAL
               PTVAT = fglcnlin->vat_out  && get vat amount
              PCOY = fglcnlin->ST_COY
              PDIV = fglcnlin->ST_DIV
              PCEN = fglcnlin->ST_CEN
              PTYP = fglcnlin->TYP
              PSTO = fglcnlin->ST_STO
              PCLA = fglcnlin->CLA
              PCOD = fglcnlin->COD
                ptcost = fglcnlin->qty * fglcnlin->cost_price
              
                    
             
                        pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
     ptdate = fglcnts->order_date
          select FGLPSALS
          append blank
          replace system with psys
          replace doctype with pdoc
          replace order_no with fglcnts->order_no
             REPLACE source WITH fglcnts->source
          REPLACE ftyp WITH fglcnts->ftyp
           REPLACE PMOD WITH fglcnts->PMOD
           REPLACE FRIGHTER_N WITH fglcnts->FRIGHTER_N
              REPLACE SERIALNO WITH fglcnts->SERIALNO
         replace order_date with fglcnts->order_date
         replace lpo with fglcnts->lpo
           replace reg  with fglcnts->reg
             replace pay_method  with fglcnts->pay_method
       replace pay_mode with 'Cash'
        replace shiftid with fglcnts->shiftid
        replace shiftno  with fglcnts->shiftno
        replace shiftdate with fglcnts->shiftdate
        replace cashier_no  with fglcnlin->cashier_no
               replace dde_date with  fglcnlin->dde_date
                replace dde_time with fglcnlin->dde_time
                replace dde_user with fglcnlin->dde_user
            replace mileage with fglcnts->mileage
            replace off with fglcnlin->off
         replace stock_no with fglcnlin->stock_no
         replace coy with fglcnlin->coy
            replace div with fglcnlin->div
            replace cen with fglcnlin->cen
              replace sto with fglcnlin->sto
              replace st_coy with fglcnlin->st_coy
            replace st_div with fglcnlin->st_div
            replace st_cen with fglcnlin->st_cen
              replace st_sto with fglcnlin->st_sto
              replace shift_no with fglcnlin->shift_no
              replace shift_id with fglcnlin->shift_id
                 replace typ with fglcnlin->typ
            replace cla with fglcnlin->cla
            replace cod with fglcnlin->cod
            replace qty with fglcnlin->qty
            replace cost_price with fglcnlin->cost_price
            replace discount with fglcnlin->discount
            replace total with fglcnlin->total
            replace sell_price with fglcnlin->sell_price
            replace vat with fglcnlin->vat
            replace vat_out with fglcnlin->vat_out
             replace gross_amt with fglcnlin->gross_amt
            replace cashier_no with fglcnlin->cashier_no
             replace total_amt with fglcnlin->total_amt
             replace driver with fglcnlin->driver
              replace PR_QTY with fglcnlin->PR_QTY
              replace reference with fglcnlin->reference
            replace nonvat with fglcnlin->nonvat
              replace nonvat_amt with fglcnlin->nonvat_amt
       if typ <= "9Z" .and. .not. left(typ,1) = "7" .and. .not. typ="00" .and. .not. qty = 0
             select fgmast
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
             replace m_var with m_var - fglcnlin->qty
              select fgmast2
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
             replace m_var with m_var - fglcnlin->qty
              endif
