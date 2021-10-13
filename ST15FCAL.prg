PROCEDURE ST15FCAL
create session
set talk off
set ldCheck off
set view to "ST15FCAL.QBE"
     private psPrice

      local lvar
      lvar = 0
      select shifttyp
      repl all total_sale with 0, total_qty with 0
          SELECT SHIFTID
          REPLACE ALL TOTAL_SALE WITH 0
           select shTYPCLA
      repl all total_sale with 0, total_qty with 0
          SELECT SHIFTID
          REPLACE ALL TOTAL_SALE WITH 0
          SELECT st15f
         SCAN
          PCOY = COY
      PDIV = DIV
      PCEN = CEN
      PSTO = STO
      PTYP = TYP
      PCLA = CLA
      PCOD = COD
         LOCAL LX1,lx1e
        lx1e =.t.
      replace shift_post with {}
      replace errors with ""
   select FGCODS
   seek ptyp+pcla+pcod
   if .not. found()
   lx1e = .f.
   endif
    IF .not. FGCODS->sale_price > 0
           SELECT st15f
             REPLACE SHIFT_POST WITH DATE()
           replace st15f->errors with "CHECK SALE PRICE"
        ENDIF
          IF .NOT. LX1e
           SELECT st15f
             REPLACE SHIFT_POST WITH DATE()
           replace st15f->errors with "CHECK PRODUCT"
        ENDIF
        PSPRICE = FGCODS->SALE_PRICE
          
           
           select st15f
           PCOY1 = ST_COY
           PDIV1 = ST_DIV
           PCEN1 = ST_CEN
           PSTO1 = ST_STO
            if ptyp = "00"
           select ststo
           seek psto
           if .not. found() .or. (empty(off) .and. rate_on = "Yes")
           select st15f
           REPLACE SHIFT_POST WITH DATE()
           replace st15f->errors with "Check PUM OFFICER"
           endif
           endif
           pmacdisc = psprice * 0.25  && max disc on pump price
          IF (st15f->STO = "K2" .OR. st15f->STO = "K3" ;
          .OR. st15f->STO = "U6" .OR. st15f->STO = "U7" .OR. st15f->STO = "U8" .OR. st15f->STO = "U9".OR. st15f->STO = "UA";
          .OR. st15f->STO = "L6" .OR. st15f->STO = "L7" .OR. st15f->STO = "L8" .OR. st15f->STO = "L9".OR. st15f->STO = "LA");
          .AND. STSTO->MAXAMT < pmacdisc
          PSPRICE = PSPRICE - STSTO->MAXAMT
          ENDIF
          


           if ptyp = "00" .and. .NOT. (st15f->STO = "K2" .OR. st15f->STO = "K3" ;
            .OR. st15f->STO = "U6" .OR. st15f->STO = "U7" .OR. st15f->STO = "U8" .OR. st15f->STO = "U9".OR. st15f->STO = "UA";
          .OR. st15f->STO = "L6" .OR. st15f->STO = "L7" .OR. st15f->STO = "L8" .OR. st15f->STO = "L9".OR. st15f->STO = "LA")
           SELECT SHIFTCLS
           SEEK PCOY+PTYP+PCLA
           if .not. found()
           append blank
           replace coy with pcoy
           replace typ with ptyp
           replace cla with pcla
           endif
           replace sale_price with FGCODS->SALE_PRICE

           ENDIF
           L2M = 0
           L3M = 0

          select st15f
            L1 = st15f->TYP
            t1 = st15f->cla
            t6 = st15f->cod
            L2 = cl_m_q
            L3 = op_m_q
            L2M = CL_mM_QTY
            L3M = OP_mM_QTY

        ** past here
            L5 = 0
            IF TYP = "00" .or. (typ = "10" .and. FGCODS->shs_auto = "Yes")
            l5 = test_QTY
            ENDIF
            L55 = L5 * PSPRICE
            REPLACE TEST_AMT WITH L55
        replace sale_price with PSPRICE

               if .NOT. TYP = "00"
             replace cl_m_a with 0
             endif
            SHSRETURN = L55 && SHS RETURN TO TANK
            t55 = 0
            SHSPLOSS = T55  && SHS PUMP LOSS
            if  .not. TEST_AMT =  0
            L5 =  TEST_AMT / PSPRICE
            else
            l5 = 0
            endif
            QTYRETURN = L5 && QTY RETURN
            t5 = t55 / PSPRICE   && pumps loss qty
            QTYPLOSS = T5 && QUANTITY PUMP LOSS
          


                IF st15f->typ = "00"
        if  .not. st15f->f1cashr = "Yes"
               IF .NOT. st15f->PHY_QTY = 0
               REPLACE SHIFT_POST WITH DATE()
                replace st15f->errors with "Check Dippings 2"
          ENDIF
          ENDIF
          ENDIF

            L7 = st15f->TRANS_IN
            L8 = st15f->TRANS_OUT
            L9 = st15f->ADJ_IN
            L10 = st15f->ADJ_OUT
            L11 = st15f->PURCHASES
            L4m = 0
            l4e = 0
            plvar1 = 0
            if m_q1 > 0 .or.  m_q2 > 0
            replace cl_m_q with m_q1+m_q2
            endif
             if m_a1 > 0 .or.  m_a2 > 0
            replace cl_m_a with m_a1+m_a2
            endif


          IF st15f->TYP = "00"   .or. (st15f->TYP = "10" .and. FGCODS->shs_auto = "Yes") && fuels/auto lubes
               L4 = L2 - L3        && && VOLUME electronic
               l4e = l4 && volume electric ony
                  L4m = L2M-L3M  && volume manual
               lvar = L4 - L4m  && variance  0 - 10
               plvar1 = lvar * -1
               plvar1 = round(plvar1,2)

               IF L4M > L4 .and. plvar1 > 0.74  && VOLUME = MANUAL IF MANUAL > ELECTRONIC
               L4 = L4M
               ENDIF
               QTYTHRUPUT = L4 && QUANTITY THRUPUT
               L6 = L4 - L5 - T5        && SOLD QTY  - VOLUME
                 ELSE
               L4 = L3 - L2 + L7 - L8 + L9 - L10 + L11  && non-fuels
               QTYTHRUPUT = L4
               L6 = L4 - L5 - t5  && SOLD QTY


                   ENDIF
                   REPLACE MM_SOLD WITH L4M
                    replace mm_qty_var with lvar


                 IF  st15f->TYP = "00"   ;
                 .or.  (st15f->typ = "10" .and. FGCODS->shs_auto = "Yes")
                   if  (st15f->cl_m_q  - st15f->op_m_q) < 0 .or. (st15f->cl_mm_qty - st15f->op_mm_qty) < 0

                   replace shift_post with date()
                    replace st15f->errors with "Err1. Check qty meters"
                     endif
                     endif

                       IF  st15f->TYP = "00" .or.  (st15f->typ = "10" .and. FGCODS->shs_auto = "Yes")
                   if  (st15f->cl_m_q  - st15f->op_m_q) < 0 .or. (st15f->cl_mm_qty - st15f->op_mm_qty) < 0

                   replace shift_post with date()
                    replace st15f->errors with "Err1. Check qty meters"
                     endif
                     endif


                       IF  st15f->TYP = "00" .or.  (st15f->typ = "10" .and. FGCODS->shs_auto = "Yes")
          if  (st15f->cl_m_q  - st15f->op_m_q) > 99999 .or. (st15f->cl_m_q  - st15f->op_m_q) < -9999

                   replace shift_post with date()
                    replace st15f->errors with "Err1. Check qty meters"
                     endif
                     endif

                    if  (st15f->cl_m_a  - st15f->op_m_a) < 0

              replace shift_post with date()
               replace st15f->errors with "Err1. Check shs meters"
                endif
                 if  (st15f->cl_m_a  - st15f->op_m_a) > 0 .and. ((st15f->cl_m_q - st15f->op_m_q = 0 .and. ;
                 st15f->cl_mm_qty - st15f->op_mm_qty = 0))
               replace shift_post with date()
               replace st15f->errors with "Cash Mtr No Sold Qty"
                endif
                if  st15f->cl_m_q   < 0

              replace shift_post with date()
               replace st15f->errors with "Err2. Check Electronic qty meters"
                endif
                 if  (st15f->cl_m_q  - st15f->op_m_q) < 0
              replace shift_post with date()
               replace st15f->errors with "Err2. Check Electronic qty meters"
                endif

              if  st15f->cl_m_a   < 0

              replace shift_post with date()
               replace st15f->errors with "Err2. Check shs meters"
                endif

           if  st15f->cl_mm_qty   < 0

              replace shift_post with date()
               replace st15f->errors with "Err3. Check Manual qty meters"
                endif
                 if  (st15f->cl_mm_qty  - st15f->op_mm_qty) < 0
              replace shift_post with date()
               replace st15f->errors with "Err3. Check Manual qty meters"
                endif
           ** past here

                     LOCAL L12,L13,L14,L15,L16,L17,L18,L19,L20,l22,t17
            L13 = PSPRICE
            L12 = L4 * L13                && SOLD AMT
              L22 = 0           && CASH DISCOUNTS
          SHSDISCOUNT = L22
           if .not. st15f->typ = "00"
       l14 = 0
       else
       L14 = cl_m_A
       endif
   if .not. st15f->typ = "00"   .and. .not. cl_m_A = 0
       replace shift_post with date()
        replace st15f->errors with "(a) Check shillings meters - 2"
       endif
       if .not. typ="00" .and.  .not. op_m_a = 0
       replace op_m_a with 0
       endif
             L15 = st15f->op_m_a
            L16 = L14 - L15                && METER AMOUNT
            SHSTHRUPUT = L16
            SHSSALE = SHSTHRUPUT - SHSPLOSS - SHSRETURN - SHSDISCOUNT && SHS METER SALE
            QTYSALE = QTYTHRUPUT - QTYRETURN - QTYPLOSS
              L17 = L55        && TEST AMOUNT
              t17 = t55  && pump loss amount
             L18 = L16 - L17 - t17         && NETT SOLD METER AMOUNT
              L19 = st15f->cr_sal_qty        && CREDIT SALES QTY
             L20 = L19 * L13        && CREDIT SALES AMOUNT
             LOCAL L21,L23,L24,L25,L26,L27
            * l24 = 0

             L21 = st15f->NON_CASH        && ACTUAL NONCASH SALES
             SHSNONCASH = L21  && SHS CREDIT SALES
             QTYNONCASH = st15f->cr_sal_qty  && QTY CREDIT SALES
             SHSQTYSALE = (QTYSALE * PSPRICE  ) - SHSDISCOUNT
             expsalesprice = PSPRICE
             QTYEXPSALE = QTYSALE
             SHSEXPSALE = SHSSALE
             IF SHSSALE < SHSQTYSALE
             SHSEXPSALE = SHSQTYSALE  && sale based on price * qty

             ENDIF
               L23 = L16 - L21 - L22 - L17 - t17        && CASH AMOUNT BASED ON METER SHS
               L24 = L12 - L21 - L22        && CASH AMOUNT BASED ON VOLUMES
               IF L23 > L24
               L24 = L23
               ENDIF
             L25 = 0
             L26 = st15f->PHY_QTY
            L27 = L25 - L26        && VARIANCE QTY
             LOCAL L28,L29,L30,l31,l32,l33,L33A,L33B
             l31 = 0
             replace st15f->cost_price with FGCODS->cost_price
             replace st15f->vat with FGCODS->vat
             l33 = a_c_inhand  && actual cash
             L33A = CASH_BANK
             L33B  = CL_C_HAND
             QTYEXPCASH = QTYSALE - QTYNONCASH
             SHSEXPCASH = SHSEXPSALE - SHSNONCASH
             L28 = L24 - L23        && VARIANCE CASH
               IF L24 > L23
               L29 = L24                && EXP CASH
               ELSE
               L29 = L23                && EXP CASH
               ENDIF
               L29 = SHSEXPCASH
             IF L12 > L18
             L30 = L12                && EXP SALES
             ELSE
             L30 = L18                && EXP SALES
             ENDIF
             L30 = SHSEXPSALE
                 replace total_qty with l4e
               LOCAL WK55
               WK55 = SOLD_QTY
             replace sold_qty with QTYSALE
             replace sold_amt with (qtythruput * PSPRICE)   && new entry
            IF .NOT. st15f->typ = "00"
             IF cr_sal_qty > SOLD_QTY  .and. .not. cr_sal_qty = 0
             replace st15f->errors with "Check credit sales"
             REPLACE SHIFT_POST WITH DATE()
             ENDIF
             ENDIF
               replace meter_amt with l16

              replace nett_amt with l18
               replace cr_sal_shs with l20
               replace cash_amt with l23
               replace cash_qty with l24
               replace var_cash with l28
               replace exp_cash with SHSEXPCASH
               replace exp_sales with SHSEXPSALE
               replace sh_c_SALES WITH SHSEXPCASH
              if st15f->typ = "30" .or. st15f->typ = "90"
            replace c_sh_cards with shsexpcash  && s scratch cards
            endif
             if st15f->typ > "30" .and. .not. st15f->typ = "90"
            replace c_sh_shop with shsexpcash  && sodas
            endif
            if st15f->typ = "00"
            replace c_sh_fuels with shsexpcash
            endif
            if st15f->typ = "10"
            replace c_sh_work with shsexpcash
            endif
            if st15f->typ = "20"
            replace c_sh_cant with shsexpcash
            endif

    IF  st15f->TYP = "00" .or.  (st15f->typ = "10" .and. FGCODS->shs_auto = "Yes")
       replace st15f->meter_var with st15f->meter_amt - st15f->sold_amt
       endif

            local ll1,ll2,ll3,lL4,ll5,ll6,ll7,ll8,ll9
            ll1 = st15f->shift_date
            ll2 = st15f->shift_no
            ll3 = st15f->shift_id
            lL4 = st15f->cen
            ll5 = st15f->cashier_no
            ll6 = st15f->sto
            ll7 = st15f->typ
            ll8 = st15f->cla
            ll9 = st15f->cod
            select st15f

                LOCAL WK55
               WK55 = st15f->SOLD_QTY
               local wk1,wk2,wk3,wk4,wk5,wk6,wk7
           WK1 =  st15f->sh_c_sales+st15f->cash_debt;
          + st15f->cash_work+st15f->cash_shop+st15f->cash_cards+st15f->CASH_CANT;
          + st15f->cash_soda;
           + st15f->vs_others + st15f->chqs_sale + st15f->fc_c_sales && total cash
          wk4 = st15f->CASH_MERCH + st15f->cash_motor + st15f->cash_food;  && total payments
             + st15f->cash_withd + st15f->cash_staff + st15f->cash_lubes;
             + st15f->cash_gen + st15f->cash_coy + st15f->vs_company + st15f->vs_barclay
          wk2 = wk1 - wk4 && net cash
          wk6 = st15f->a_c_inhand
          wk5 = st15f->CL_C_HAND  && cash in hand carried forward
          wk3 = wk6 - wk2  && cash shortage
          wk3 = st15f->a_c_inhand - ((st15f->Cash_cards + st15f->c_sh_fuels;
        + st15f->c_sh_work +  st15f->cash_soda;
        + st15f->c_sh_shop+st15f->c_sh_cards+st15f->c_sh_cant + st15f->fc_c_sales;
        +st15f->cash_debt+st15f->CASH_CANT+st15f->Cash_shop + st15f->cash_work);
        - (st15f->CASH_COY+st15f->cash_staff+st15f->cash_gen;
        +st15f->cash_withd+st15f->VS_COMPANY+st15f->VS_BARCLAY ;
        +st15f->cash_lubes+st15f->cash_food+st15f->cash_motor))

          wk7 = st15f->sh_c_sales+st15f->cash_debt;
        + st15f->cash_work+st15f->cash_shop+st15f->cash_cards+st15f->CASH_CANT ;
        + st15f->cash_soda ;
        + st15f->vs_others + st15f->chqs_sale + st15f->fc_c_sales && total cash
          replace total_cash with wk1
          replace cash_short with wk3
          replace net_cash with wk2
          replace st15f->t_cash_pay with wk4
          replace t_cash_rec with wk7
          if mm_sold < 0
           replace st15f->errors with "Check Manual Litres"
             REPLACE SHIFT_POST WITH DATE()
           endif
              if .not. typ = "00" .and. .not. cl_mm_qty = 0
               replace st15f->errors with "Check Manual Litres"
             REPLACE SHIFT_POST WITH DATE()
         endif
         LOCAL LNQTY
         LNQTY = MM_SOLD
         IF TOTAL_QTY > MM_SOLD
         LNQTY = TOTAL_QTY
         ENDIF
          if TEST_QTY > LNQTY
           replace st15f->errors with "Check RTT"
             REPLACE SHIFT_POST WITH DATE()
           endif
           if meter_amt > 0 .and. sold_amt <=0
           replace st15f->errors with "Check Ltrs Mtrs"
             REPLACE SHIFT_POST WITH DATE()
           endif
      *     if form.blevel > 4
           if  typ = "00" .and.  (op_mm_qty = cl_mm_qty .or. op_m_q = op_m_q)  ;
            .and. .not.  (op_mm_qty = 0 .or. op_m_q = 0) .and.   ;
          (mm_qty_var > 10 .or. mm_qty_var < -10)
           replace shift_post with date()
           replace errors with "Lt1 Mtr Out of Range"
           endif

           if typ = "00" .and. op_m_a = cl_m_a  .and. .not. op_m_a = 0  .and.  ;
            (meter_var > 1000 .or. meter_var < -1000)
             replace shift_post with date()
           replace errors with "Sh1 Mtr Out of Range"
           endif
            if  typ = "00"  .and. .not.  (op_mm_qty = 0 .or. op_m_q = 0) .and.;
   (mm_qty_var > 10 .or. mm_qty_var < -10)
           replace errors with "Lt2 Mtr Out of Range"
            replace shift_post with date()
           endif
   if typ = "00"   .and. .not. op_m_a = 0 .and. (meter_var > 1000 .or. meter_var < -1000)
   replace errors with "Sh2 Mtr Out of Range"
    replace shift_post with date()
           endif
            if  typ = "00"  .and. .not.  (op_mm_qty  = cl_mm_qty  .and.  op_m_q = cl_m_q) .and.;
   (mm_qty_var > 10 .or. mm_qty_var < -10)
           replace errors with "Lt3 Mtr Out of Range"
            replace shift_post with date()
           endif
           if typ = "00" .and. .not.  (op_m_a = cl_m_a);
           .and. (meter_var > 1000 .or. meter_var < -1000)
           replace errors with "Sh3 Mtr Out of Range"
            replace shift_post with date()
           endif
         *  endif
   *         if st15f->
          SELECT SHIFTID
        SEEK st15f->CEN
        IF .NOT. FOUND()
        APPEND BLANK
        REPLACE ID WITH st15f->CEN
        IF .NOT. BOF()
        REPLACE TOTAL_SALE WITH 0
        ENDIF
        ENDIF
        REPLACE TOTAL_SALE WITH TOTAL_SALE + st15f->EXP_SALES
        select fgtyps
          seek st15f->typ

        select shifttyp
        seek st15f->typ
        if .not. found()
        append blank
        replace typ with st15f->typ
        replace total_sale with 0
        replace total_qty with 0
        replace name with fgtyps->name
        endif
         REPLACE TOTAL_SALE WITH TOTAL_SALE + st15f->EXP_SALES
         REPLACE TOTAL_QTY WITH TOTAL_QTY + st15f->SOLD_QTY
               select fgCLAS
          seek st15f->typ+st15f->cla

     select shTYPCLA
        seek st15f->typ+st15f->CLA
        if .not. found()
        append blank
        replace typ with st15f->typ
        REPLACE CLA WITH st15f->CLA
        replace total_sale with 0
        replace total_qty with 0
        replace name with fgclas->name
        endif
         REPLACE TOTAL_SALE WITH TOTAL_SALE + st15f->EXP_SALES
         REPLACE TOTAL_QTY WITH TOTAL_QTY + st15f->SOLD_QTY
         go top
        SELECT st15f
    ENDSCAN
    
