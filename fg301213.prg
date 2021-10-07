PROCEDURE FG301213    
  PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
 *   SET AUTOSAVE ON
    SET VIEW TO "FG301213.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 10000
      eoffgtransF = .f.
      select fgcod
      set order to mkey
       select dayfgmas
       if flock()
  set order to mkey
      select dacoysum
       if flock()
      set order to mkey
SELECT FGMAST
 if flock()
SET ORDER TO MKEY
SELECT ST15F
 if flock()
SET ORDER TO MKEY
go top
SELECT SHSTMAST
 if flock()
SET ORDER TO MKEY
select fgmmstks
 if flock()
set order to mkey
          SELECT fgtransF
          set filter to  .not. QTY = 0 .and. .not. EMPTY(STOCK_NO) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. .not. EMPTY(CEN);
          .and. .not. EMPTY(STO) .and. .not. EMPTY(TYP) .and. .not. EMPTY(CLA);
          .and. .not. EMPTY(COD) .and. empty(post_date) .and. .not. EMPTY(ST_COY);
          .and. .not. EMPTY(ST_DIV) .and. .not. EMPTY(ST_CEN);
          .and. .not. EMPTY(ST_STO) .AND. .NOT. EMPTY(ORDER_DATE)
     go top
     if .not. eof()
        do
           do fg1213_rtn1
           until eoffgtransF
           endif
              set safety off
        
            SELECT fgtransF
           zap
           
           select fgcoy
           flush
           SET AUTOSAVE OFF
          
            else
            Wait 'Unable to Lock Tables Try Again Later!'
            quit
            endif
            endif
            endif
            endif
            endif
            endif
       CLOSE DATABASES
procedure fg1213_rtn1

   local lerr1, lerr
                     begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

              select DACOYSUM
          seek dtos(fgtransF->order_date)+fgtransF->coy
          if .not. found()
          append blank
          replace coy with fgtransF->coy
          replace shift_date with fgtransF->order_date
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0
        endif
            select st15f
            go top
           
   lerr1 = .f.	
     pshno = st15f->shift_no
     pshid = st15f->shift_id
    pshdate = st15f->shift_date
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
      pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
   endif
   
      P3 = fgtransF->ST_COY  && receiving centre
      P4 = fgtransF->ST_DIV
      P5 = fgtransF->ST_CEN
      P6 = fgtransF->ST_STO
      P7 = fgtransF->TYP
      P8 = fgtransF->CLA
      P9 = fgtransF->COD
    
      P14 = fgtransF->ORDER_NO
      P10 = fgtransF->COY  && despatch centre
      P11 = fgtransF->DIV
      P12 = fgtransF->CEN
      P13 = fgtransF->STO
  select fgcod
  seek p7+p8+p9
  
      select fgmast
      seek p10+p11+p12+p13+p7+p8+p9  && despatch centre
      if .not. found()
       Wait 'fgtransF - Problem with stock masterfile - Try Again Later!'
           quit
      endif
        if .not. p11 = '1' .and. .not. p7 = '00' && not forecourt
       select dayfgmas
      seek p10+p11+p12+p13+p7+p8+p9+dtos(pshdate)
      if .not. found()
      append blank
         replace coy with p10
        replace div with p11
    replace cen with p12
      replace sto with p13
      replace shift_date with pshdate
      replace typ with p7
      replace cla with p8
      replace cod with p9
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
         endif           
      select SHSTMAST
      seek p10+p11+p12+p13+p7+p8+p9+dtos(pshdate)+pshno+pshid  && despatch
      if .not. found()
      append blank
      replace coy with p10
        replace div with p11
    replace cen with p12
      replace sto with p13
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with p7
      replace cla with p8
      replace cod with p9
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      replace cs_sales_a with 0
      replace cr_sales_a with 0
      replace cs_purch_a with 0
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
         select fgmmstks
       seek p10+p11+p12+p13+p7+p8+p9+pshyy+pshmm  && despatch
      if .not. found()
      append blank
      replace coy with p10
        replace div with p11
    replace cen with p12
      replace sto with p13
      replace mm with pshmm          
      replace yy with pshyy      
      replace typ with p7
      replace cla with p8
      replace cod with p9
      replace purch with 0
      replace sales with 0
      replace sales_a with 0
      replace purch_a with 0
      replace trans with 0
      replace adjs with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
      replace sale_price with 0
      replace std_cost with 0
      replace std_vat with 0
     endif
          select fgmast
      seek p3+p4+p5+p6+p7+p8+p9  && receiving centre
      if .not. found()
        Wait 'fgtransF - Problem with stock masterfile - Try Again Later!'
           quit
      endif
       if .not. p4 = '1' .and. .not. p7 = '00' && not forecourt
       select dayfgmas
      seek p3+p4+p5+p6+p7+p8+p9+dtos(pshdate)
      if .not. found()
      append blank
         replace coy with p3
        replace div with p4
    replace cen with p5
      replace sto with p6
      replace shift_date with pshdate
      replace typ with p7
      replace cla with p8
      replace cod with p9
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
     endif           
      select SHSTMAST
      seek p3+p4+p5+p6+p7+p8+p9+dtos(pshdate)+pshno+pshid  && receiving
       if .not. found()
      append blank
      replace coy with p3
        replace div with p4
    replace cen with p5
      replace sto with p6
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with p7
      replace cla with p8
      replace cod with p9
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      replace cs_sales_a with 0
      replace cr_sales_a with 0
      replace cs_purch_a with 0
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
    
      select fgmmstks
       seek p3+p4+p5+p6+p7+p8+p9+pshyy+pshmm  && receiving
      if .not. found()
      append blank
      replace coy with p3
        replace div with p4
    replace cen with p5
      replace sto with p6
      replace mm with pshmm          
      replace yy with pshyy      
      replace typ with p7
      replace cla with p8
      replace cod with p9
      replace purch with 0
      replace sales with 0
      replace sales_a with 0
      replace purch_a with 0
      replace trans with 0
      replace adjs with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
      replace sale_price with 0
      replace std_cost with 0
      replace std_vat with 0
     endif
       pst15f = .f.
      
      IF fgtransF->DIV = "1"  && FORECOURT DESPATCH
            LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
           L1 = PSHDATE
          L2 = PSHNO
          l10 = PSHID
          L7 = fgtransF->COY
          L8 = fgtransF->DIV
          L9 = fgtransF->CEN
          L6 = fgtransF->STO
          L3 = fgtransF->TYP
          L4 = fgtransF->CLA
          L5 = fgtransF->COD
          LITEM = l3+l4+l5+left(l6,1)
          LID = L9
          SELECT ST15F
          SEEK DTOS(L1)+L2+L10+L9+L3+L4+L5+L6+L7+l8
          IF  FOUND()
          pst15f = .t.  && forecourt ok
          
          else
            Wait 'fgtransF - Problem with shift masterfile - Try Again Later!'
           quit
             endif
          endif 
               
              
        IF fgtransF->ST_DIV = "1"  && forecourt receiving
                   LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
          L1 = PSHDATE
          prst15f = .f.
          L2 = PSHNO
          L7 = fgtransF->ST_COY
          L8 = fgtransF->ST_DIV
          L9 = fgtransF->ST_CEN
          L6 = fgtransF->ST_STO
          L3 = fgtransF->TYP
          L4 = fgtransF->CLA
          L5 = fgtransF->COD
          l10 = PSHID
          LID = L9
          LITEM = l3+l4+l5+left(l6,1)
         SELECT ST15F
          SEEK DTOS(L1)+L2+L10+L9+L3+L4+L5+L6+L7+l8
          IF FOUND()
          pst15f = .t.
          else
           Wait 'fgtransF - Problem with shift masterfile - Try Again Later!'
           quit
              endif
         
          endif
     *    clear
        *  ? '>>>>>'
          if .not. lerr1              
     DO UPDATE_fgtransF_3012rtn2
     select fgtransF
    replace post_date with date()
    endif
 *   endif
    commit()
    
    select fgtransF
      IF .NOT. EOF()  
    skip
    ENDIF
    if eof()
    eoffgtransF = .T.
    endif
    
  PROCEDURE UPDATE_fgtransF_3012rtn2
  prst15f = .f.
  pdst15f = .f.
  ? fgtransf->order_no
  IF fgtransF->DIV = "1"   && FORECOURT
                 DO ST15F_TRANS_OUT_3012rtn
                   DO fgadasto_TRANS_OUT_3012rtn
                 endif       
         IF .NOT. fgtransF->DIV = "1"  && not forecourt
        DO fgadasto_TRANS_OUT_3012rtn
        ENDIF
        IF fgtransF->ST_DIV = "1"  && forecourt
              DO ST15F_TRANS_IN_3012rtn
            DO fgadasto_TRANS_IN_3012rtn
        endif
        
      IF .NOT. fgtransF->ST_DIV = "1" && not forecourt
        DO fgadasto_TRANS_IN_3012rtn
        ENDIF

 PROCEDURE ST15F_TRANS_OUT_3012rtn
       LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
       pdst15f = .f.
       ? "passed here"
          L1 = pshdate
          L2 = pshno
          l10 = pshid
          L7 = fgtransF->COY
          L8 = fgtransF->DIV
          L9 = fgtransF->CEN
          L6 = fgtransF->STO
          L3 = fgtransF->TYP
          L4 = fgtransF->CLA
          L5 = fgtransF->COD
          LITEM = l3+l4+l5+left(l6,1)
          LID = L9
          SELECT ST15F
          SEEK DTOS(L1)+L2+L10+L9+L3+L4+L5+L6+L7+l8
              REPLACE ST15F->TRANS_OUT WITH ST15F->TRANS_OUT + fgtransF->QTY
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q - fgtransF->QTY
                  REPLACE SHIFT_POST WITH DATE()
                  replace errors WITH "REKEY CLOSE QTY"
                  
     
         
 PROCEDURE fgadasto_TRANS_OUT_3012rtn  && DESPATCH
   LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = "XO"
  k2 = "12"
  k4 = fgtransF->order_no
  k5 = fgtransF->STOCK_NO
      k6 = fgtransF->stock_no   
          L1 = fgtransF->COY
          L2 = fgtransF->DIV
          L3 = fgtransF->CEN
          L4 = fgtransF->STO
          L5 = fgtransF->TYP
          L6 = fgtransF->CLA
          L7 = fgtransF->COD
         
        SELECT fgadasto
          APPEND BLANK
          REPLACE off WITH fgtransF->off
          REPLACE COY WITH fgtransF->COY
          REPLACE DIV WITH fgtransF->DIV
          REPLACE CEN WITH fgtransF->CEN
          REPLACE STO WITH fgtransF->STO
          REPLACE TYP WITH fgtransF->TYP
          REPLACE CLA WITH fgtransF->CLA
          REPLACE COD WITH fgtransF->COD
          REPLACE SYSTEM WITH fgtransF->SYSTEM
          REPLACE DOCTYPE WITH "12"
          REPLACE ORDER_NO WITH fgtransF->ORDER_NO
          REPLACE STOCK_NO WITH fgtransF->STOCK_NO
          REPLACE ORDER_DATE WITH fgtransF->ORDER_DATE
          REPLACE QTY WITH fgtransF->QTY
          REPLACE SHIFT_NO WITH pshno
          REPLACE SHIFT_id WITH pshid
           REPLACE ST_COY WITH fgtransF->ST_COY
          REPLACE ST_DIV WITH fgtransF->ST_DIV
          REPLACE ST_CEN WITH fgtransF->ST_CEN
          REPLACE ST_STO WITH fgtransF->ST_STO
          replace unit_cost with fgcod->cost_price
        
            REPLACE DDE_USER WITH fgtransF->DDE_USER
            REPLACE DDE_DATE WITH fgtransF->DDE_DATE
             REPLACE DDE_TIME WITH fgtransF->DDE_TIME
                             LOCAL D1,D2
              D1 = DTOS(fgadasto->ORDER_DATE) && YYYYMMDD
              D2 = LEFT(D1,6)
              PDD = RIGHT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PCOY = fgadasto->COY
              PDIV = fgadasto->DIV
              PCEN = fgadasto->CEN
              PTYP = fgadasto->TYP
              PSTO = fgadasto->STO
              PCLA = fgadasto->CLA
              PCOD = fgadasto->COD
              ptranin = 0
              ptranout = fgtransF->qty
              pdate = fgadasto->ORDER_DATE
              SELECT fgmast  && DESPATCH
              seek p10+p11+p12+p13+p7+p8+p9
         REPLACE ON_HAND WITH ON_HAND - fgadasto->QTY
         REPLACE TRANS_OUT WITH TRANS_OUT + fgadasto->QTY
         REPLACE M_VAR WITH M_VAR + fgadasto->QTY
             if .not. p11 = '1' .and. .not. p7 = '00' && not forecourt
       select dayfgmas
      seek p10+p11+p12+p13+p7+p8+p9+dtos(pshdate)
       replace on_hand with on_hand - fgadasto->qty
       replace trans with trans - fgadasto->qty 
       endif
               
                select SHSTMAST
                seek p10+p11+p12+p13+p7+p8+p9+dtos(pshdate)+pshno+pshid  && despatch
             replace on_hand with on_hand - fgadasto->qty
                       replace TRANS_OUT with TRANS_OUT + fgadasto->qty 
                       
                       select fgmmstks
                       seek p10+p11+p12+p13+p7+p8+p9+pshyy+pshmm
                        replace on_hand with on_hand - fgadasto->qty
                       replace TRANS with TRANS - fgadasto->qty
            
              
           
 
 PROCEDURE ST15F_TRANS_IN_3012rtn  && receiving
       LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,l10,LID,LITEM
          L1 = pshdate
          prst15f = .f.
          L2 = pshno
          L7 = fgtransF->ST_COY
          L8 = fgtransF->ST_DIV
          L9 = fgtransF->ST_CEN
          L6 = fgtransF->ST_STO
          L3 = fgtransF->TYP
          L4 = fgtransF->CLA
          L5 = fgtransF->COD
          l10 = pshid
          LID = L9
          LITEM = l3+l4+l5+left(l6,1)
         SELECT ST15F
         SEEK DTOS(L1)+L2+L10+L9+L3+L4+L5+L6+L7+l8
             REPLACE ST15F->TRANS_IN WITH ST15F->TRANS_IN + fgtransF->QTY
             REPLACE ST15F->CL_M_Q WITH ST15F->CL_M_Q + fgtransF->QTY
                  REPLACE SHIFT_POST WITH date()
                 replace errors with "REKEY CLOSE QTY"
                 
  
 PROCEDURE fgadasto_TRANS_IN_3012rtn  && receiving
  LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = "XO"
  k2 = "13"
  k4 = fgtransF->order_no
  k5 = fgtransF->STOCK_NO
      k6 = fgtransF->stock_no   
          L1 = fgtransF->ST_COY
          L2 = fgtransF->ST_DIV
          L3 = fgtransF->ST_CEN
          L4 = fgtransF->ST_STO
          L5 = fgtransF->TYP
          L6 = fgtransF->CLA
          L7 = fgtransF->COD
          
          select SHSTMAST
             seek p3+p4+p5+p6+p7+p8+p9+dtos(pshdate)+pshno+pshid  && receiving 
                  replace on_hand with on_hand + fgadasto->qty
                        replace TRANS_IN with TRANS_IN + fgadasto->qty
                        select fgmmstks
                            seek p3+p4+p5+p6+p7+p8+p9+pshyy+pshmm  && receiving
                       replace on_hand with on_hand + fgadasto->qty
                        replace TRANS with TRANS + fgadasto->qty
                   
          if .not. p4 = '1' .and. .not. p7 = '00' && not forecou
       select dayfgmas
      seek p3+p4+p5+p6+p7+p8+p9+dtos(pshdate)
       replace on_hand with on_hand + fgtransF->QTY
       replace trans with trans + fgtransF->QTY
       endif
               SELECT FGMAST
                seek p3+p4+p5+p6+p7+p8+p9  && receiving centre
              REPLACE FGMAST->ON_HAND WITH FGMAST->ON_HAND + fgtransF->QTY
             REPLACE FGMAST->TRANS_IN WITH FGMAST->TRANS_IN + fgtransF->QTY
             REPLACE M_VAR WITH M_VAR -  fgtransF->QTY
         