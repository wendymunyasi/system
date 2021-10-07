procedure FG30ADJS
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "fg30ADJS.QBE"
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    set reprocess to 10000
  select dayfgmas
  if flock()
  set order to mkey
     SELECT ST15F
      if flock()
     SET ORDER TO MKEY
  select dacoysum
  set order to mkey
        select FGADJSUP
         
set order to mkey
SELECT FGMAST
 if flock()
SET ORDER TO MKEY
SELECT SHSTMAST
 if flock()
SET ORDER TO MKEY
select fgcod
set order to mkey
      select FGADJS
       
      GO TOP
         IF .not. empty(order_no)  .AND. EMPTY(POST_DATE)  .and. .not. empty(reason) ;
          .and. .not.  qty = 0 .and. .not. empty(order_date) ;
           .AND. .NOT. EMPTY(SHIFT_NO) .AND. .NOT. EMPTY(SHIFT_NO) ;
           .and. .not. empty(coy) .and. .not. empty(div) .and. .not. empty(cen) ;
            .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) ;
             .and. .not. empty(sto) .and. .not. empty(off)
           do save_rtn2
          endif
          SELECT FGCOY
         FLUSH
         SET AUTOSAVE OFF
         else
         wait 'Unable to Lock Tables - Try Again Later!'
         quit
         endif
         endif
         endif
         endif
         
         
         CLOSE DATABASES
         
procedure save_rtn2
         local l1,l2,l3,l4,l5,ll1,ll2,ll3,ll4,ll5,ll6,lerr1, lerr,LS1,LS2,LS3,LS4,LS5,LS6,LS7,LS8,LS9,LS10
            lerr = .t.
                     begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            SELECT ST15F
            GO TOP
            IF EOF() .OR. EMPTY(SHIFT_DATE) .OR. EMPTY(SHIFT_NO) .OR. EMPTY(SHIFT_ID)
            QUIT
            ENDIF
          LS1 = SHIFT_DATE
          LS2 = SHIFT_NO
          LS3 = SHIFT_ID
          SELECT FGADJS
           LS4 = CEN
          LS5 = TYP
          LS6 = CLA
          LS7 = COD
          LS8 = STO
          LS9 = COY
          LS10 = DIV
             select DACOYSUM
          seek dtos(FGADJS->order_date)+FGADJS->coy
          if .not. found()
          append blank
          replace coy with FGADJS->coy
          replace shift_date with FGADJS->order_date
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0

          endif
          
            select FGADJSUP
            seek FGADJS->order_no+dtos(FGADJS->order_date)+"01"+FGADJS->DDE_TIME
            if .not. found()
            append blank
            replace order_no with FGADJS->order_no
            replace order_date with FGADJS->order_date
            replace stock_no with "01"
            REPLACE DDE_TIME WITH FGADJS->DDE_TIME
            lerr = .f.
            endif
            IF EMPTY(FGADJS->POST_DATE)
            LERR = .F.
            ENDIF
            IF FGADJS->DIV = "1" && FORECOURT
                SELECT ST15F
                SEEK DTOS(LS1)+LS2+LS3+LS4+LS5+LS6+LS7+LS8+LS9+LS10
                IF .NOT. FOUND()
                LERR = .F.
                ENDIF
               if rlock()
      else
      Wait "Record lock failed. Try again Later"
      quit
      endif
                ENDIF
            IF .NOT. LERR
         ll1 = FGADJS->coy
         ll2 = FGADJS->div
         ll3 = FGADJS->cen
         ll4 = FGADJS->sto
         ll5 = FGADJS->typ
         ll6 = FGADJS->cla
         ll7 = FGADJS->cod
         select fgcod
         seek ll5+ll6+ll7
         select fgmast
         seek ll1+ll2+ll3+ll4+ll5+ll6+ll7
         if .not. found()
         append blank
          replace coy with ll1
         replace div with ll2
         replace cen with ll3
         replace typ with ll4
         replace cla with ll5
         replace cod with ll6
         replace sto with ll7
         replace bbf with 0
         replace on_hand with 0
         replace phy with 0
         replace alloc with 0
         replace trans_in with 0
         replace trans_out with 0
         replace purch with 0
         replace sales with 0
         replace adj_in with 0
         replace adj_out with 0
         REPLACE CR_PURCH WITH 0
         REPLACE CS_PURCH WITH 0
         REPLACE CR_SALES  WITH 0
         REPLACE CS_SALES WITH 0
         REPLACE BBF_PHY WITH 0
         REPLACE TEMP_QTY WITH 0
         REPLACE TEMP_PURCH WITH 0
         REPLACE PHY_QTY WITH 0
         REPLACE BCF WITH 0
         REPLACE M_PHY WITH 0
         REPLACE M_VAR WITH 0
         REPLACE OPEN_BAL WITH 0
         REPLACE LAST_PHY WITH 0
         REPLACE  TEMP_PHY WITH 0
         endif
         if rlock()
      else
      Wait "Record lock failed. Try again Later"
      quit
      endif
          if .not. ll2 = '1' .and. .not. ll5 = '00' && not forecourt
       select dayfgmas
      seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGADJS->order_date)  && despatch
      if .not. found()
      append blank
        replace coy with ll1
        replace div with ll2
    replace cen with ll3
      replace sto with ll4
      replace shift_date with FGADJS->order_date
      replace typ with ll5
      replace cla with ll6
      replace cod with ll7
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      if rlock()
      else
      Wait "Record lock failed. Try again Later"
      quit
      endif
      endif           
       select SHSTMAST
 seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGADJS->order_date)+FGADJS->SHIFT_NO+FGADJS->SHIFT_ID  && despatch
      if .not. found()
      append blank
      replace coy with ll1
      replace div with ll2
      replace cen with ll3
      replace sto with ll4
      replace shift_date with FGADJS->order_date
      replace shift_no with FGADJS->SHIFT_NO
      replace shift_id with FGADJS->SHIFT_ID
      replace typ with ll5
      replace cla with ll6
      replace cod with ll7
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
     endif
     if rlock()
      else
      Wait "Record lock failed. Try again Later"
      quit
      endif
            l1 = "FG"
            l2 = "17"
            l3 = FGADJS->order_no
            l4 = FGADJS->order_date
            l5 = "01"
            PUPD = .T.
            
            IF FGADJS->DIV = "1" .AND. (FGMAST->ON_HAND + FGADJS->QTY) < 0
            PUPD = .F.
            ENDIF
            IF PUPD
            select fgadasto
             append blank
            replace system with l1
            replace off with FGADJS->off
            replace shift_no with FGADJS->shift_no
            replace shift_id with FGADJS->shift_id
            replace sto with FGADJS->sto
            replace doctype with l2
            replace order_no with l3
            replace order_date with l4
            replace stock_no with l5
            replace coy with FGADJS->coy
            replace div with FGADJS->div
            replace cen with FGADJS->cen
            replace typ with FGADJS->typ
            replace cla with FGADJS->cla
            replace cod with FGADJS->cod
            replace qty with FGADJS->qty
            replace unit_cost with FGADJS->unit_cost
            replace new_bal with fgcod->pnonvat
             replace reason with FGADJS->reason
            REPLACE DDE_DATE WITH FGADJS->DDE_DATE
            REPLACE DDE_USER WITH PLUSER
            REPLACE DDE_TIME WITH FGADJS->DDE_TIME
            REPLACE SHIFT_NO WITH FGADJS->SHIFT_NO
            REPLACE SHIFT_ID WITH FGADJS->SHIFT_ID
            select fgmast
            replace on_hand with on_hand + FGADJS->qty
            if FGADJS->qty > 0
            replace adj_in with adj_in + FGADJS->qty
            else
            replace adj_out with adj_out + FGADJS->qty * -1
            endif
            if .not. fgadjs->div = '1' .and. .not. fgadjs->typ = '00'
            select dayfgmas
             replace on_hand with on_hand + FGADJS->qty
             replace adjs with adjs + FGADJS->qty
             endif
            
              select shstmast
            replace on_hand with on_hand + FGADJS->qty
            if FGADJS->qty > 0
            replace adj_in with adj_in + FGADJS->qty
            else
            replace adj_out with adj_out + FGADJS->qty * -1
            endif
             IF FGADJS->DIV = "1"  && FORECOURT
            SELECT ST15F
            IF FGADJS->QTY >  0
               REPLACE ST15F->TRANS_IN WITH ST15F->TRANS_IN + FGADJS->QTY
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + FGADJS->QTY
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
                 ELSE
                     REPLACE ST15F->TRANS_OUT WITH ST15F->TRANS_OUT - FGADJS->QTY
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + FGADJS->QTY
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
        ENDIF
        ENDIF
        select fgmast
        
         select dayfgmas
        
         select shstmast
        
         select st15f
        
         
            SELECT FGADJSN
            GO TOP
            IF EOF()
            APPEND BLANK
            ENDIF
            REPLACE ORDER_NO WITH FGADJS->ORDER_NO
            SELECT FGADJSUP
             REPLACE POST_DATE WITH DATE()
            SELECT FGADJS
            REPLACE POST_DATE WITH DATE()
            ENDIF
            ENDIF
            COMMIT()
            