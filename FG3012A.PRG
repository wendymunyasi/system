
PROCEDURE FG3012A    
  PARAMETER BUSER,BLEVEL
  
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "FG3012A.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 10000
    
      eoffodrline = .f.
      select dacoysum
      if flock()
      set order to mkey
      select fodupd
set order to mkey
SELECT FGMAST
if flock()
SET ORDER TO MKEY
SELECT ST15F
SET ORDER TO MKEY
go top
SELECT SHSTMAST
if flock()
SET ORDER TO MKEY
select fgmmstks
if flock()
set order to mkey


      SELECT FORDERS
      GO TOP
      IF .NOT. EOF()
     if .not. EMPTY(ORDER_NO) .and. .not. EMPTY(ORDER_DATE) .and. .not. EMPTY(SHIFT_DATE) ;
          .and. .not. EMPTY(SHIFT_NO) .and. .not. empty(shift_id) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. ;
           .not. EMPTY(CEN) .and. .not. EMPTY(STO) .and. empty(post_date) 
          
          SELECT fodrline
          set filter to order_no = FORDERS->order_no  .and. ;
          .not. QTY = 0 .and. .not. EMPTY(STOCK_NO) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. .not. EMPTY(CEN);
          .and. .not. EMPTY(STO) .and. .not. EMPTY(TYP) .and. .not. EMPTY(CLA);
          .and. .not. EMPTY(COD) .and. empty(post_date)
     go top
     if .not. eof()
        do
           do fg12_rtn1
           until eoffodrline
         *  ? "ended"
            select FORDERSn
                go top
                if eof()
                append blank
                endif
                replace order_no with FORDERS->order_no
                
           ENDIF
           ENDIF
           ENDIF
           else
           Wait 'Unable to Lock Tables - Try Again Later!'
           quit
           endif
           endif
           endif
           endif
           
           select fgcoy
           flush
           SET AUTOSAVE OFF
          
            
       CLOSE DATABASES
procedure fg12_rtn1
   local lerr1, lerr
            lerr = .t.
                     begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

              select DACOYSUM
          seek dtos(FORDERS->order_date)+fodrline->coy
          if .not. found()
          append blank
          replace coy with fodrline->coy
          replace shift_date with FORDERS->order_date
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0

          endif
             select fodupd
            seek fodrline->order_no+dtos(FORDERS->order_date)+fodrline->stock_no+fodrline->dde_time
            if .not. found()
            append blank
            replace order_no with fodrline->order_no
            replace order_date with FORDERS->order_date
            replace stock_no with fodrline->stock_no
            replace dde_time with fodrline->dde_time
            lerr = .f.
            endif
            if empty(post_date)
            lerr = .f.
            endif
         if .not. lerr   
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
   
      P3 = fodrline->COY  && receiving centre
      P4 = fodrline->DIV
      P5 = fodrline->CEN
      P6 = fodrline->STO
      P7 = fodrline->TYP
      P8 = fodrline->CLA
      P9 = fodrline->COD
    
      P14 = fodrline->ORDER_NO
      P10 = FORDERS->COY  && despatch centre
      P11 = FORDERS->DIV
      P12 = FORDERS->CEN
      P13 = FORDERS->STO
    
  
      select fgmast
      seek p10+p11+p12+p13+p7+p8+p9  && despatch centre
      if .not. found()
      lerr1 = .t.
      ? "fgmast - bad"
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
      lerr1 = .t.
      ? "fgmast - bad"
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
      
          
          if .not. lerr1              
     DO UPDATE_fodrline_3012rtn2
     
     
  SELECT fodupd
    replace post_date with date()
    select fodrline
    replace post_date with date()
    endif
    endif
    commit()
    
    
    select fodrline
        
       
    skip
    if eof()
    eoffodrline = .T.
    endif
    
  PROCEDURE UPDATE_fodrline_3012rtn2
  prst15f = .f.
  pdst15f = .f.
        DO fgadasto_TRANS_OUT_3012rtn
       
        DO fgadasto_TRANS_IN_3012rtn
         
 PROCEDURE fgadasto_TRANS_OUT_3012rtn  && DESPATCH
   LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = 'WP'
  k2 = '12'
  k4 = FORDERS->order_no
  k5 = fodrline->STOCK_NO
      k6 = fodrline->stock_no   
          L1 = FORDERS->COY
          L2 = FORDERS->DIV
          L3 = FORDERS->CEN
          L4 = FORDERS->STO
          L5 = fodrline->TYP
          L6 = fodrline->CLA
          L7 = fodrline->COD
         
        SELECT fgadasto
          APPEND BLANK
          REPLACE off WITH FORDERS->off
          REPLACE COY WITH FORDERS->COY && despatch
          REPLACE DIV WITH FORDERS->DIV
          REPLACE CEN WITH FORDERS->CEN
          REPLACE STO WITH FORDERS->STO
          REPLACE TYP WITH fodrline->TYP
          REPLACE CLA WITH fodrline->CLA
          REPLACE COD WITH fodrline->COD
          REPLACE SYSTEM WITH K1
          REPLACE DOCTYPE WITH '12'
          REPLACE ORDER_NO WITH FORDERS->ORDER_NO
          REPLACE STOCK_NO WITH k5
          REPLACE ORDER_DATE WITH FORDERS->ORDER_DATE
          REPLACE QTY WITH fodrline->QTY * -1
          REPLACE SHIFT_NO WITH pshno
          REPLACE SHIFT_id WITH pshid
           REPLACE ST_COY WITH fodrline->COY  && receiving
          REPLACE ST_DIV WITH fodrline->DIV
          REPLACE ST_CEN WITH fodrline->CEN
          REPLACE ST_STO WITH fodrline->STO
        
            REPLACE DDE_USER WITH PLUSER
            REPLACE DDE_DATE WITH DATE()
             REPLACE DDE_TIME WITH TIME()
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
              ptranout = fodrline->qty
              pdate = fgadasto->ORDER_DATE
              SELECT fgmast  && DESPATCH
              seek p10+p11+p12+p13+p7+p8+p9
         REPLACE ON_HAND WITH ON_HAND - fodrline->QTY
         REPLACE adj_out WITH adj_out + fodrline->QTY
           
               
                select SHSTMAST
                seek p10+p11+p12+p13+p7+p8+p9+dtos(pshdate)+pshno+pshid  && despatch
             replace on_hand with on_hand - fodrline->QTY
                       replace adj_out with adj_out  + fodrline->QTY
                       
                       select fgmmstks
                       seek p10+p11+p12+p13+p7+p8+p9+pshyy+pshmm
                        replace on_hand with on_hand - fodrline->QTY
                       replace TRANS with TRANS - fodrline->QTY
            
              
           
 
 PROCEDURE fgadasto_TRANS_IN_3012rtn  && receiving
  LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = 'WP'
  k2 = '13'
  k4 = FORDERS->order_no
  k5 = fodrline->STOCK_NO
      k6 = fodrline->stock_no   
          L1 = fodrline->COY
          L2 = fodrline->DIV
          L3 = fodrline->CEN
          L4 = fodrline->STO
          L5 = fodrline->TYP
          L6 = fodrline->CLA
          L7 = fodrline->COD
                
          select SHSTMAST
             seek p3+p4+p5+p6+p7+p8+p9+dtos(pshdate)+pshno+pshid  && receiving 
                  replace on_hand with on_hand + fodrline->QTY
                        replace adj_in with adj_in +  fodrline->QTY
                        
                        select fgmmstks
                            seek p3+p4+p5+p6+p7+p8+p9+pshyy+pshmm  && receiving
                       replace on_hand with on_hand + fodrline->QTY
                        replace TRANS with TRANS + fodrline->QTY
                   
         
               SELECT FGMAST
                seek p3+p4+p5+p6+p7+p8+p9  && receiving centre
              REPLACE FGMAST->ON_HAND WITH FGMAST->ON_HAND + fodrline->QTY
             REPLACE adj_in WITH adj_in + fodrline->QTY
          

