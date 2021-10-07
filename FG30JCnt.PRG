Procedure fg30jcnt
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "fg30jcnt.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfgjcnts,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
               PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    set reprocess to -1
    if empty(pluser) .or. empty(plevel)
    quit
    endif
               
select fgjcrup
set order to mkey
select fgmast2
set order to mkey
select fgmast
set  order to mkey
      eoffgjcnlin = .f.
      pposted = .f.
      select fgcoy
      go top
    
      SELECT fgjcnts
      GO TOP
      IF .NOT. EOF()
       select fgjcnlin
    set filter to order_no = fgjcnts->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 ;
     .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(stock_no) .and. .not. empty(off) .and. .not. empty(cashier_no) ;
     .and. .not. empty(driver)
   
           go top
                if .not. eof()
      pposted = .t.
                do
                do line_rtn
                until eoffgjcnlin
                select fgjcntsn
                go top
                if eof()
                append blank
                endif
                replace order_no with fgjcnts->order_no
                
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

            select fgjcrup
            seek fgjcnlin->order_no+dtos(fgjcnts->order_date)+fgjcnlin->stock_no+fgjcnlin->dde_time
            if .not. found()
            append blank
            replace order_no with fgjcnlin->order_no
            replace order_date with fgjcnts->order_date
            replace stock_no with fgjcnlin->stock_no
            replace dde_time with fgjcnlin->dde_time
         do cont_rtn
          select fgjcnlin   
             replace post_date with date()
    SELECT fgjcrup
    replace post_date with date()
     endif
       
      COMMIT()
   select fgjcnlin   
       SKIP
    IF EOF()
     eoffgjcnlin = .T.
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
      psys   = 'PS'  && point of sale
      pdoc   = '16'  && job card
      pstockno = fgjcnlin->stock_no
    
                     
    local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = fgjcnts->ORDER_DATE
        psys = 'PS'
        pdoc = '16'
        l4 = fgjcnts->order_no
        l5 = fgjcnlin->stock_no
        l6 = fgjcnts->shiftno
        l7 = fgjcnlin->st_COY
        l8 = fgjcnlin->st_div
        l9 = fgjcnlin->st_cen
        l10 = fgjcnlin->st_sto
        l11 = fgjcnlin->typ
        l12 = fgjcnlin->cla
        l13 = fgjcnlin->cod
        l14 = fgjcnlin->shift_id
         
          ppay = fgjcnts->PAY_METHOD
         pcustno  =  fgjcnts->frighter_N
         pftyp = fgjcnts->ftyp
         psource = fgjcnts->source
         ppmod = fgjcnts->pmod
                LOCAL D1,D2
                
              D1 = DTOS(fgjcnts->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = fgjcnlin->QTY * -1
               PTTOTAL = fgjcnlin->TOTAL
               PTVAT = fgjcnlin->vat_out  && get vat amount
              PCOY = fgjcnlin->ST_COY
              PDIV = fgjcnlin->ST_DIV
              PCEN = fgjcnlin->ST_CEN
              PTYP = fgjcnlin->TYP
              PSTO = fgjcnlin->ST_STO
              PCLA = fgjcnlin->CLA
              PCOD = fgjcnlin->COD
                ptcost = fgjcnlin->qty * fgjcnlin->cost_price
              
                    
             
                        pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
     ptdate = fgjcnts->order_date
          select fgjcsals
          append blank
          replace system with psys
          replace doctype with pdoc
          replace order_no with fgjcnts->order_no
             REPLACE source WITH fgjcnts->source
          REPLACE ftyp WITH fgjcnts->ftyp
           REPLACE PMOD WITH fgjcnts->PMOD
           REPLACE FRIGHTER_N WITH fgjcnts->FRIGHTER_N
              REPLACE SERIALNO WITH fgjcnts->SERIALNO
         replace order_date with fgjcnts->order_date
         replace lpo with fgjcnts->lpo
           replace reg  with fgjcnts->reg
             replace pay_method  with fgjcnts->pay_method
        replace pay_mode with fgjcnts->pay_mode
        replace shiftid with fgjcnts->shiftid
        replace shiftno  with fgjcnts->shiftno
        replace shiftdate with fgjcnts->shiftdate
        replace cashier_no  with fgjcnlin->cashier_no
               replace dde_date with  fgjcnlin->dde_date
                replace dde_time with fgjcnlin->dde_time
                replace dde_user with fgjcnlin->dde_user
            replace mileage with fgjcnts->mileage
            replace off with fgjcnlin->off
         replace stock_no with fgjcnlin->stock_no
         replace coy with fgjcnlin->coy
            replace div with fgjcnlin->div
            replace cen with fgjcnlin->cen
              replace sto with fgjcnlin->sto
              replace st_coy with fgjcnlin->st_coy
            replace st_div with fgjcnlin->st_div
            replace st_cen with fgjcnlin->st_cen
              replace st_sto with fgjcnlin->st_sto
              replace shift_no with fgjcnlin->shift_no
              replace shift_id with fgjcnlin->shift_id
                 replace typ with fgjcnlin->typ
            replace cla with fgjcnlin->cla
            replace cod with fgjcnlin->cod
            replace qty with fgjcnlin->qty
            replace cost_price with fgjcnlin->cost_price
            replace discount with fgjcnlin->discount
            replace total with fgjcnlin->total
            replace sell_price with fgjcnlin->sell_price
            replace vat with fgjcnlin->vat
            replace vat_out with fgjcnlin->vat_out
            replace off with fgjcnlin->off  && cashier
             replace gross_amt with fgjcnlin->gross_amt
            replace cashier_no with fgjcnlin->cashier_no
             replace total_amt with fgjcnlin->total_amt
             replace driver with fgjcnlin->driver
              replace srep with fgjcnlin->srep
              replace scr_amt with fgjcnlin->scr_amt
              replace scr_qty with fgjcnlin->scr_qty
              replace bal_alloc with fgjcnlin->bal_alloc
              replace amt_alloc with fgjcnlin->amt_alloc
           
       if typ <= "9Z" .and. .not. left(typ,1) = "7" .and. .not. typ="00" .and. .not. qty = 0
             select fgmast2 && REAL MASTER
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
            RLOCK()
             replace m_var with m_var - fgjcnlin->qty
             
              select fgmast  && NOT REAL
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
             replace m_var with m_var - fgjcnlin->qty
             endif
