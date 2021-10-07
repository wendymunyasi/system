PROCEDURE fg12pos    
  PARAMETER BUSER,BLEVEL
  
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "fg12pos.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 1000
    
      eofxodrline = .f.
      select fgmast
      set order to mkey
      select st15f
      go top
      if empty(shift_date) .or. empty(shift_no) .or. empty(shift_id)
      quit
      endif
      select xodupd
set order to mkey

      SELECT XORDERS
      GO TOP
      IF .NOT. EOF()
     if .not. EMPTY(ORDER_NO) .and. .not. EMPTY(ORDER_DATE) .and. .not. EMPTY(SHIFT_DATE) ;
          .and. .not. EMPTY(SHIFT_NO) .and. .not. empty(shift_id) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. ;
           .not. EMPTY(CEN) .and. .not. EMPTY(STO) .and. empty(post_date) 
          SELECT xodrline
          set filter to order_no = xorders->order_no  .and. ;
          .not. QTY = 0 .and. .not. EMPTY(STOCK_NO) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. .not. EMPTY(CEN);
          .and. .not. EMPTY(STO) .and. .not. EMPTY(TYP) .and. .not. EMPTY(CLA);
          .and. .not. EMPTY(COD) .and. empty(post_date)
     go top
     if .not. eof()
        do
           do fg12_rtn1
           until eofxodrline
            select xordersn
                go top
                if eof()
                append blank
                endif
                replace order_no with xorders->order_no
                
           ENDIF
           ENDIF
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

            select xodupd
            seek xodrline->order_no+dtos(XORDERS->order_date)+xodrline->stock_no+xodrline->dde_time
            if .not. found()
            append blank
            replace order_no with xodrline->order_no
            replace order_date with XORDERS->order_date
            replace stock_no with xodrline->stock_no
            replace dde_time with xodrline->dde_time
            lerr = .f.
            endif
              
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
   
      P3 = xodrline->COY  && receiving centre
      P4 = xodrline->DIV
      P5 = xodrline->CEN
      P6 = xodrline->STO
      P7 = xodrline->TYP
      P8 = xodrline->CLA
      P9 = xodrline->COD
    
      P14 = xodrline->ORDER_NO
      P10 = xorders->COY  && despatch centre
      P11 = xorders->DIV
      P12 = xorders->CEN
      P13 = xorders->STO
  
      DO UPDATE_xodrline_3012rtn2
     
  SELECT xodupd
    replace post_date with date()
    select xodrline
    replace post_date with date()
    commit()
    
    
    select xodrline
       if .not. eof()
       
    skip
    endif
    if eof()
    eofxodrline = .T.
    endif
    
  PROCEDURE UPDATE_xodrline_3012rtn2
  prst15f = .f.
  pdst15f = .f.
  IF xorders->DIV = "1"   && FORECOURT
                    DO fgtransf_TRANS_OUT_3012rtn
                 endif       
         IF .NOT. xorders->DIV = "1"  && not forecourt
        DO fgtransf_TRANS_OUT_3012rtn
        ENDIF
        IF xodrline->DIV = "1"  && forecourt
             DO fgtransf_TRANS_IN_3012rtn
        endif
        
      IF .NOT. xodrline->DIV = "1" 
        DO fgtransf_TRANS_IN_3012rtn
        ENDIF

     
         
 PROCEDURE fgtransf_TRANS_OUT_3012rtn  && DESPATCH
   LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = "XO"
  k2 = "12"
  k4 = xorders->order_no
  k5 = xodrline->STOCK_NO
      k6 = xodrline->stock_no   
          L1 = xorders->COY
          L2 = xorders->DIV
          L3 = xorders->CEN
          L4 = xorders->STO
          L5 = xodrline->TYP
          L6 = xodrline->CLA
          L7 = xodrline->COD
         
        SELECT fgtransf
          APPEND BLANK
          REPLACE off WITH xorders->off
          REPLACE COY WITH xorders->COY
          REPLACE DIV WITH xorders->DIV
          REPLACE CEN WITH xorders->CEN
          REPLACE STO WITH xorders->STO
          REPLACE TYP WITH xodrline->TYP
          REPLACE CLA WITH xodrline->CLA
          REPLACE COD WITH xodrline->COD
          REPLACE SYSTEM WITH K1
          REPLACE DOCTYPE WITH "12"
          REPLACE ORDER_NO WITH xorders->ORDER_NO
          REPLACE STOCK_NO WITH k5
          REPLACE ORDER_DATE WITH xorders->ORDER_DATE
          REPLACE QTY WITH xodrline->QTY
          REPLACE SHIFT_NO WITH pshno
          REPLACE SHIFT_id WITH pshid
           REPLACE ST_COY WITH xodrline->COY
          REPLACE ST_DIV WITH xodrline->DIV
          REPLACE ST_CEN WITH xodrline->CEN
          REPLACE ST_STO WITH xodrline->STO
        
            REPLACE DDE_USER WITH PLUSER
            REPLACE DDE_DATE WITH DATE()
             REPLACE DDE_TIME WITH TIME()
                             LOCAL D1,D2
              D1 = DTOS(fgtransf->ORDER_DATE) && YYYYMMDD
              D2 = LEFT(D1,6)
              PDD = RIGHT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PCOY = fgtransf->COY
              PDIV = fgtransf->DIV
              PCEN = fgtransf->CEN
              PTYP = fgtransf->TYP
              PSTO = fgtransf->STO
              PCLA = fgtransf->CLA
              PCOD = fgtransf->COD
              ptranin = 0
              ptranout = xodrline->qty
              pdate = fgtransf->ORDER_DATE
              SELECT fgmast  && DESPATCH
              seek p10+p11+p12+p13+p7+p8+p9
              if found() .and. rlock()
         REPLACE m_var with m_var - fgtransf->QTY
         endif
         select fgmast 
         unlock
         
              
           
                 
  
 PROCEDURE fgtransf_TRANS_IN_3012rtn  && receiving
  LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = "XO"
  k2 = "13"
  k4 = xorders->order_no
  k5 = xodrline->STOCK_NO
      k6 = xodrline->stock_no   
          L1 = xodrline->COY
          L2 = xodrline->DIV
          L3 = xodrline->CEN
          L4 = xodrline->STO
          L5 = xodrline->TYP
          L6 = xodrline->CLA
          L7 = xodrline->COD
                            SELECT FGMAST
                seek p3+p4+p5+p6+p7+p8+p9  && receiving centre
                if found() .and. rlock()
                replace m_var with m_var + xodrline->QTY
                endif
                select fgmast
                unlock
            