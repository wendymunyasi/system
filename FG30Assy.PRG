procedure FG30ASSY
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    set reprocess to 100
    SET VIEW TO "FG30ASSY.QBE"
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    select dayfgmas
  set order to mkey
    
     select dacoysum
     
  set order to mkey
  SELECT ST15F
  
    SET ORDER TO MKEY
          select FGASSYUP
          
set order to mkey
SELECT FGMAST

SET ORDER TO MKEY
SELECT SHSTMAST

SET ORDER TO MKEY
      select FGASSY
      
      GO TOP
          IF .not. empty(order_no)  .and. .not. empty(reason) ;
          .and.  .not. SAqty = 0 .and. .not. empty(order_date) ;
           .and. .not. empty(coy) .and. .not. empty(div) .and. .not. empty(cen) ;
            .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) ;
             .and. .not. empty(sto) .and. .not. empty(off) .AND. .NOT. AAQTY = 0 ;
             .and. .not. empty(coy1) .and. .not. empty(div1) .and. .not. empty(cen1) ;
            .and. .not. empty(typ1) .and. .not. empty(cla1) .and. .not. empty(cod1) ;
             .and. .not. empty(sto1) .and. .not. empty(SHIFT_NO) .and. .not. empty(SHIFT_ID) 
           do save_rtn2
          endif
         SELECT FGCOY
         FLUSH
         
        
         
         SET AUTOSAVE OFF
         CLOSE DATABASES
         
procedure save_rtn2
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
            lerr = .t.
             SELECT FGASSY
           LS4 = CEN
          LS5 = TYP
          LS6 = CLA
          LS7 = COD
          LS8 = STO
          LS9 = COY
          LS10 = DIV
           LS41 = CEN1
          LS51 = TYP1
          LS61 = CLA1
          LS71 = COD1
          LS81 = STO1
          LS91 = COY1
          LS101 = DIV1
             select DACOYSUM
          seek dtos(FGASSY->order_date)+FGASSY->coy
          if .not. found()
          append blank
          replace coy with FGASSY->coy
          replace shift_date with FGASSY->order_date
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0

          endif
          
            select FGASSYUP
            seek FGASSY->order_no+dtos(FGASSY->order_date)+"01"+FGASSY->DDE_TIME
            if .not. found()
            append blank
            replace order_no with FGASSY->order_no
            replace order_date with FGASSY->order_date
            replace stock_no with "01"
            REPLACE DDE_TIME WITH FGASSY->DDE_TIME
            lerr = .f.
            endif
            
            IF EMPTY(FGASSY->POST_DATE)
            LERR = .F.
            ENDIF
            IF FGASSY->DIV = "1" && FORECOURT  std item
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
                 IF FGASSY->DIV1 = "1" && FORECOURT  assembled item
                SELECT ST15F2
                SEEK DTOS(LS1)+LS2+LS3+LS41+LS51+LS61+LS71+LS81+LS91+LS101
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
            DO DEASSEMBLE_RTN
            DO ASSEMBLE_RTN
            select fgmast
            
            select st15f 
            
            select dayfgmas
            
            select shstmast
            
             
            
             SELECT FGASSYN
            GO TOP
            IF EOF()
            APPEND BLANK
            ENDIF
            REPLACE ORDER_NO WITH FGASSY->ORDER_NO
            SELECT FGASSYUP
             REPLACE POST_DATE WITH DATE()
            SELECT FGASSY
            REPLACE POST_DATE WITH DATE()
            
            ENDIF
             commit()
            
PROCEDURE DEASSEMBLE_RTN
           
         ll1 = FGASSY->coy
         ll2 = FGASSY->div
         ll3 = FGASSY->cen
         ll4 = FGASSY->sto
         ll5 = FGASSY->typ
         ll6 = FGASSY->cla
         ll7 = FGASSY->cod
         
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
      seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)  && despatch
      if .not. found()
      append blank
        replace coy with ll1
        replace div with ll2
    replace cen with ll3
      replace sto with ll4
      replace shift_date with FGASSY->order_date
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
 seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)+FGASSY->SHIFT_NO+FGASSY->SHIFT_ID  && despatch
      if .not. found()
      append blank
      replace coy with ll1
        replace div with ll2
    replace cen with ll3
      replace sto with ll4
      replace shift_date with FGASSY->order_date
      replace shift_no with FGASSY->SHIFT_NO
      replace shift_id with FGASSY->SHIFT_ID
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
            l1 = "AS"
            l2 = "17"
            l3 = FGASSY->order_no
            l4 = FGASSY->order_date
            l5 = "01"
              IF FGASSY->DIV = "1"  && FORECOURT
            SELECT ST15F
            SEEK DTOS(LS1)+LS2+LS3+LS4+LS5+LS6+LS7+LS8+LS9+LS10
              if rlock()
      else
      Wait "Record lock failed. Try again Later"
      quit
      endif
      endif
    
            select fgadasto
             append blank
            replace system with l1
            replace off with FGASSY->off
            replace shift_no with FGASSY->shift_no
            replace shift_id with FGASSY->shift_id
            replace sto with FGASSY->sto
            replace doctype with l2
            replace order_no with l3
            replace order_date with l4
            replace stock_no with l5
            replace coy with FGASSY->coy
            replace div with FGASSY->div
            replace cen with FGASSY->cen
            replace typ with FGASSY->typ
            replace cla with FGASSY->cla
            replace cod with FGASSY->cod
            replace qty with FGASSY->SAqty * -1
            replace unit_cost with FGASSY->unit_cost
            replace new_bal with FGASSY->new_bal
             replace reason with FGASSY->reason
           
            REPLACE DDE_DATE WITH FGASSY->DDE_DATE
            REPLACE DDE_USER WITH PLUSER
            REPLACE DDE_TIME WITH FGASSY->DDE_TIME
            REPLACE SHIFT_NO WITH FGASSY->SHIFT_NO
            REPLACE SHIFT_ID WITH FGASSY->SHIFT_ID
            select fgmast
            seek ll1+ll2+ll3+ll4+ll5+ll6+ll7
             replace on_hand with on_hand - FGASSY->SAqty
            IF FGASSY->SAqty >  0  
             replace adj_out with adj_out + FGASSY->SAqty 
             else
             replace adj_in with adj_in - FGASSY->SAqty 
             endif
             if .not. ll2 = '1' .and. .not. ll5 = '00'
            select dayfgmas
            seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)
             replace on_hand with on_hand - FGASSY->SAqty 
             replace adjs with adjs - FGASSY->SAqty 
             endif
              select shstmast
               seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)+FGASSY->SHIFT_NO+FGASSY->SHIFT_ID  && despatch
            replace on_hand with on_hand - FGASSY->SAqty
            IF FGASSY->SAqty >  0  
              replace adj_out with adj_out + FGASSY->SAqty 
              else
               replace adj_in with adj_in - FGASSY->SAqty 
              endif
           IF FGASSY->DIV = "1"  && FORECOURT
            SELECT ST15F
            SEEK DTOS(LS1)+LS2+LS3+LS4+LS5+LS6+LS7+LS8+LS9+LS10
            IF FGASSY->SAqty <  0  
               REPLACE ST15F->TRANS_IN WITH ST15F->TRANS_IN + FGASSY->SAqty*-1
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + FGASSY->SAqty*-1
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
                 ELSE
                     REPLACE ST15F->TRANS_OUT WITH ST15F->TRANS_OUT + FGASSY->SAqty
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q - FGASSY->SAqty
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
        ENDIF
        ENDIF 
            
            
PROCEDURE ASSEMBLE_RTN
            
           
         ll1 = FGASSY->coy1
         ll2 = FGASSY->div1
         ll3 = FGASSY->cen1
         ll4 = FGASSY->sto1
         ll5 = FGASSY->typ1
         ll6 = FGASSY->cla1
         ll7 = FGASSY->cod1
         
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
          if .not. ll2 = '1' .and. .not. ll5 = '00' && not forecourt
       select dayfgmas
      seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)  && despatch
      if .not. found()
      append blank
        replace coy with ll1
        replace div with ll2
    replace cen with ll3
      replace sto with ll4
      replace shift_date with FGASSY->order_date
      replace typ with ll5
      replace cla with ll6
      replace cod with ll7
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      endif           
       select SHSTMAST
 seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)+FGASSY->SHIFT_NO+FGASSY->SHIFT_ID  && despatch
      if .not. found()
      append blank
      replace coy with ll1
        replace div with ll2
    replace cen with ll3
      replace sto with ll4
      replace shift_date with FGASSY->order_date
      replace shift_no with FGASSY->SHIFT_NO
      replace shift_id with FGASSY->SHIFT_ID
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
            l1 = "MF"
            l2 = "17"
            l3 = FGASSY->order_no
            l4 = FGASSY->order_date
            l5 = "01"
            select fgadasto
             append blank
            replace system with l1
            replace off with FGASSY->off
            replace shift_no with FGASSY->shift_no
            replace shift_id with FGASSY->shift_id
            replace sto with FGASSY->sto1
            replace doctype with l2
            replace order_no with l3
            replace order_date with l4
            replace stock_no with l5
            replace coy with FGASSY->coy1
            replace div with FGASSY->div1
            replace cen with FGASSY->cen1
            replace typ with FGASSY->typ1
            replace cla with FGASSY->cla1
            replace cod with FGASSY->cod1
              replace qty with FGASSY->AAqty 
            replace unit_cost with FGASSY->unit_cost
            replace new_bal with FGASSY->new_bal
            replace reason with FGASSY->reason
               REPLACE DDE_DATE WITH FGASSY->DDE_DATE
            REPLACE DDE_USER WITH PLUSER
            REPLACE DDE_TIME WITH FGASSY->DDE_TIME
            REPLACE SHIFT_NO WITH FGASSY->SHIFT_NO
            REPLACE SHIFT_ID WITH FGASSY->SHIFT_ID
            if .not. ll2 = '1' .and. .not. ll5 = '00'
            select dayfgmas
        seek    ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)
             replace on_hand with on_hand + FGASSY->AAqty
             replace adjs with adjs + FGASSY->AAqty
             endif
            select fgmast
            seek ll1+ll2+ll3+ll4+ll5+ll6+ll7
            replace on_hand with on_hand + FGASSY->AAqty
             replace adj_IN with adj_IN  + FGASSY->AAqty 
              select shstmast
               seek ll1+ll2+ll3+ll4+ll5+ll6+ll7+dtos(FGASSY->order_date)+FGASSY->SHIFT_NO+FGASSY->SHIFT_ID  && despatch
            replace on_hand with on_hand + FGASSY->AAqty
              replace adj_IN  with adj_IN  + FGASSY->AAqty 
              
              LOCAL LWK
              LWK = FGASSY->AAqty *  -1
 
           IF FGASSY->DIV1 = "1"  && FORECOURT
            SELECT ST15F2
            SEEK DTOS(LS1)+LS2+LS3+LS41+LS51+LS61+LS71+LS81+LS91+LS101
            IF LWK <  0  
               REPLACE ST15F2->TRANS_IN WITH ST15F2->TRANS_IN + LWK*-1
             REPLACE ST15F2->CL_M_Q WITH ST15F2->CL_M_Q + LWK*-1
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
                 ELSE
                     REPLACE ST15F2->TRANS_OUT WITH ST15F2->TRANS_OUT + LWK
             REPLACE ST15F2->CL_M_Q WITH ST15F2->CL_M_Q - LWK
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
        ENDIF
        ENDIF 
          