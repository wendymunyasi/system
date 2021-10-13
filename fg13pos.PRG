PROCEDURE FG13POS
PARAMETER BUSER,BLEVEL
CREATE SESSION
 set talk off                           && Set these for the new session
   set ldCheck off
   set reprocess to 1000
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "FG13POS.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 
      eofTODRLINE = .f.
      select TODUPD
       
set order to mkey
SELECT FGMAST
SET ORDER TO MKEY
SELECT ST15F
IF EMPTY(SHIFT_DATE) .OR. EMPTY(SHIFT_ID) .OR. EMPTY(SHIFT_NO)
QUIT
ENDIF
go top

eofTODRLINE = .f.
      SELECT TORDERS
       
      GO TOP
      IF .NOT. EOF()
     if .not. EMPTY(ORDER_NO) .and. .not. EMPTY(ORDER_DATE) .and. .not. EMPTY(SHIFT_DATE) ;
          .and. .not. EMPTY(SHIFT_NO) .and. .not. empty(shift_id) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. ;
           .not. EMPTY(CEN) .and. .not. EMPTY(STO) .and. empty(post_date)
          
          SELECT TODRLINE
           
          set filter to order_no = TORDERS->order_no  .and. ;
          .not. QTY = 0 .and. .not. EMPTY(STOCK_NO) ;
          .and. .not. EMPTY(COY) .and. .not. EMPTY(DIV) .and. .not. EMPTY(CEN);
          .and. .not. EMPTY(STO) .and. .not. EMPTY(TYP) .and. .not. EMPTY(CLA);
          .and. .not. EMPTY(COD) .and. empty(post_date) .and. .not. empty(shift_no) ;
           .and. .not. empty(shift_id) .and. .not. empty(shift_date)
     go top
     if .not. eof()
        do
           do Fg13_rtn1
           until eofTODRLINE
           select TORDERSN
                go top
                if eof()
                append blank
                endif
                replace order_no with TORDERS->order_no
         ENDIF
               
        endif
        ENDIF
        select fgcoy
        flush
        SET AUTOSAVE OFF
        
        
CLOSE DATABASES
procedure Fg13_rtn1
local lerr1, lerr

         begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
            LERR = .T.
    select TODUPD
            seek TODRLINE->order_no+dtos(TORDERS->order_date)+TODRLINE->stock_no+TODRLINE->DDE_TIME
            if .not. found()
            append blank
            replace order_no with TODRLINE->order_no
            replace order_date with TORDERS->order_date
            replace stock_no with TODRLINE->stock_no
            REPLACE DDE_TIME WITH TODRLINE->DDE_TIME
            lerr = .f.
            endif
         if .not. lerr  
         do cont_rtn
          SELECT TODRLINE
 REPLACE POST_DATE WITH DATE()
   SELECT TODUPD
    replace post_date with date()
      endif
       
    commit()
     
     select TODRLINE
     if .not. eof()
    skip
    endif
    if eof()
    eofTODRLINE = .T.
    endif
procedure cont_rtn
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
   
      P3 = TODRLINE->COY  && receiving centre
      P4 = TODRLINE->DIV
      P5 = TODRLINE->CEN
      P6 = TODRLINE->STO
      P7 = TODRLINE->TYP
      P8 = TODRLINE->CLA
      P9 = TODRLINE->COD
      P14 = TODRLINE->ORDER_NO
      P10 = TORDERS->COY  && despatch centre
      P11 = TORDERS->DIV
      P12 = TORDERS->CEN
      P13 = TORDERS->STO
            
     prst15f = .f.
  pdst15f = .f.
  IF TORDERS->DIV = "1"    && FORECOURT
                   DO fgtransf_TRANS_OUT_3012rtn
                 endif       
         IF .NOT. TORDERS->DIV = "1"  && not forecourt
        DO fgtransf_TRANS_OUT_3012rtn
        ENDIF
        IF TODRLINE->DIV = "1"    && forecourt
            DO fgtransf_TRANS_IN_3012rtn
        endif
        
      IF .NOT. TODRLINE->DIV = "1" 
        DO fgtransf_TRANS_IN_3012rtn
        ENDIF


         
 PROCEDURE fgtransf_TRANS_OUT_3012rtn  && DESPATCH
   LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = "TO"
  k2 = "12"
  k4 = TORDERS->order_no
  k5 = TODRLINE->STOCK_NO
      k6 = TODRLINE->stock_no   
          L1 = TORDERS->COY
          L2 = TORDERS->DIV
          L3 = TORDERS->CEN
          L4 = TORDERS->STO
          L5 = TODRLINE->TYP
          L6 = TODRLINE->CLA
          L7 = TODRLINE->COD
         
        SELECT fgtransf
          APPEND BLANK
          REPLACE off WITH TORDERS->off
          REPLACE COY WITH TORDERS->COY
          REPLACE DIV WITH TORDERS->DIV
          REPLACE CEN WITH TORDERS->CEN
          REPLACE STO WITH TORDERS->STO
          REPLACE TYP WITH TODRLINE->TYP
          REPLACE CLA WITH TODRLINE->CLA
          REPLACE COD WITH TODRLINE->COD
          REPLACE SYSTEM WITH K1
          REPLACE DOCTYPE WITH "12"
          REPLACE ORDER_NO WITH TORDERS->ORDER_NO
          REPLACE STOCK_NO WITH k5
          REPLACE ORDER_DATE WITH TORDERS->ORDER_DATE
          REPLACE QTY WITH TODRLINE->QTY 
          REPLACE SHIFT_NO WITH pshno
          REPLACE SHIFT_id WITH pshid
           REPLACE ST_COY WITH TODRLINE->COY
          REPLACE ST_DIV WITH TODRLINE->DIV
          REPLACE ST_CEN WITH TODRLINE->CEN
          REPLACE ST_STO WITH TODRLINE->STO
        
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
              ptranout = TODRLINE->qty
              pdate = fgtransf->ORDER_DATE
              SELECT FGMAST  && DESPATCH
              seek p10+p11+p12+p13+p7+p8+p9
              if found() .and. rlock()
              replace m_var with m_var - fgtransf->QTY
              endif
             
       
  
 PROCEDURE fgtransf_TRANS_IN_3012rtn
  LOCAL L1,L2,L3,L4,L5,L6,L7,k1,k2,k3,k4,k5
  k1 = "TO"
  k2 = "13"
  k4 = TORDERS->order_no
  k5 = TODRLINE->STOCK_NO
      k6 = TODRLINE->stock_no   
          L1 = TODRLINE->COY
          L2 = TODRLINE->DIV
          L3 = TODRLINE->CEN
          L4 = TODRLINE->STO
          L5 = TODRLINE->TYP
          L6 = TODRLINE->CLA
          L7 = TODRLINE->COD
       
               SELECT FGMAST
               seek p3+p4+p5+p6+p7+p8+p9
               if found() .and. rlock()
              replace m_var with m_var + TODRLINE->QTY
              endif
              
