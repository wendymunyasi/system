Procedure ar30vcnt
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "ar30vcnt.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Parvcnts,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted,pt1,pt2,pt3
            local lld1,lld2
              PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    set reprocess to 10000
       SELECT FGVISNOS
      SET ORDER TO MKEY
select arvcrnup
set order to mkey
SELECT FGMAST2
SET ORDER TO MKEY
SELECT FGMAST
SET ORDER TO MKEY
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Parvcnts,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            pposted = .t.
      eofarvcrnln = .f.
      select fgcoy
      go top
      select arvcnts
      go top
      if .not. eof()
       select arvcrnln
     set filter to order_no = arvcnts->order_no .and. empty(post_date) .AND. .NOT. (TOTAL = 0 ;
     .and. qty = 0)  .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(stock_no)   .and. empty(post_date) .and. .not. empty(st_coy) ;
     .and. .not. empty(st_div) .and. .not. empty(st_cen) .and. .not. empty(st_sto) ;
      .and. .not. empty(trantype) .AND. EMPTY(POST_DATE) ;
       .and. .not. empty(off) .and. .not. empty(cashier_no) .and. .not. empty(driver)
   
           go top
                if .not. eof()
   ? "STEP 2"
                do
                do line_rtn
                until eofarvcrnln
                 select arvcntsn
                go top
                if eof()
                append blank
                endif
                replace order_no with arvcnts->order_no
                      endif
             endif
             select fgcoy
             flush
            
             SET AUTOSAVE OFF
            close databases

procedure line_rtn
            local l1,l2,l11,l22,l3,lok, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
        select arvcrnup
            seek arvcrnln->order_no+dtos(arvcnts->order_date)+arvcrnln->stock_no+arvcrnln->dde_time
            if .not. found()
            append blank
            replace order_no with arvcrnln->order_no
            replace order_date with arvcnts->order_date
            replace stock_no with arvcrnln->stock_no
            replace dde_time with arvcrnln->dde_time
           do cont_rtn
            select arvcrnln
             replace post_date with date()
     SELECT arvcrnup
    replace post_date with date()
            endif
    COMMIT()
    select arvcrnln   
       SKIP
    IF EOF()
     eofarvcrnln = .T.
    ENDIF
    
   Procedure cont_rtn
               select fgviscad
          append blank
         replace system with 'CD'
         replace doctype with '16'
         replace order_no with arvcnts->ORDER_NO
         replace order_date with arvcnts->ORDER_DATE
         replace stock_no with arvcrnln->STOCK_NO
         replace coy with arvcrnln->coy
            replace div with arvcrnln->div
            replace cen with arvcrnln->cen
              replace sto with arvcrnln->sto
              replace st_coy with arvcrnln->st_coy
            replace st_div with arvcrnln->st_div
            replace st_cen with arvcrnln->st_cen
              replace st_sto with arvcrnln->st_sto
              replace shiftno with arvcnts->shiftno
               replace shiftid with arvcnts->shiftid
               replace shift_no with arvcrnln->SHIFT_NO
               replace shift_id with arvcrnln->SHIFT_id
               replace shift_date with arvcrnln->shift_date
                replace serialno with arvcnts->serialno
                replace dde_date with date()
                replace dde_time with time()
                replace dde_user with PLUSER
                replace driver with arvcrnln->driver
                replace CARD_RUN with arvcnts->driver
                replace cashier_no  with arvcrnln->cashier_no 
             replace typ with arvcrnln->typ
            replace cla with arvcrnln->cla
            replace cod with arvcrnln->cod
            replace qty with arvcrnln->qty
            replace cost_price with arvcrnln->cost_price
          replace disc_amt with arvcrnln->disc_amt
            replace total with arvcrnln->total
            replace list_price with arvcrnln->list_price
            replace tax_rate with arvcrnln->tax_rate
            replace tax_amt with arvcrnln->tax_amt
            replace off with arvcrnln->off
            replace reg  with arvcnts->reg
            replace gross_amt with arvcrnln->gross_amt
            replace dsc with arvcrnln->dsc
            replace levy_amt with arvcrnln->levy_amt
            replace levy_rate with arvcrnln->levy_rate
            replace pay_method with "Visacard"
            replace lpo with arvcnts->lpo
           REPLACE source WITH arvcnts->source
          REPLACE ftyp WITH arvcnts->ftyp
           REPLACE PMOD WITH arvcnts->PMOD
           REPLACE FRIGHTER_N WITH arvcnts->FRIGHTER_N
             replace basic_amt with arvcrnln->basic_amt
         REPLACE CARD_NO WITH arvcnts->CARD_NO
         REPLACE DIS_QTY with arvcrnln->DIS_QTY
         REPLACE SUP_QTY with arvcrnln->SUP_QTY
         REPLACE SER_AMT with arvcrnln->SER_AMT
         REPLACE LUB_AMT with arvcrnln->LUB_AMT
         replace nonvat with arvcrnln->nonvat
         replace nonvat_amt with arvcrnln->nonvat_amt
          pcoy = st_coy
            pdiv = st_div
            pcen = st_cen
            psto = st_sto
            ptyp = typ
            pcla = cla
            pcod = cod
            pqty = qty
             if typ <= "9Z" .and. .not. left(typ,1) = "7" .and. .not. typ="00"
             select fgmast
             seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod
              replace m_var with m_var - pqty
                endif
      PSERIAL = VAL(arvcnts->SERIALNO)
        PS = arvcnts->SOURCE
        PF = arvcnts->FRIGHTER_N
     *   IF arvcnts->MAXSERIAL > 0
          SELECT FGVISNOS
          SEEK PS+PS+PS+PF+STR(PSERIAL)
          IF FOUND()
             REPLACE DDE_USER WITH ''
             REPLACE ORDER_NO WITH ''
             REPLACE ORDER_DATE WITH {}
             ENDIF
         *    ENDIF