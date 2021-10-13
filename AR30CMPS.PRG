Procedure  ar30cmps
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
   set reprocess to 10000
    set exact on
    SET VIEW TO "ar30cmps.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
select arcmpdup

set order to mkey
SELECT CASHIERS
if flock()
SET ORDER TO CASHIER
SELECT ST15F
if flock()
SET ORDER TO MKEY
SELECT SCASHREC
if flock()
SET ORDER TO MKEY

select frighter
if flock()
set order to frighter
SET SAFETY ON
  
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofarcmpln = .f.
     SELECT arcmps
     
     GO TOP
     IF .NOT. EOF()
         select arcmpln
         
    set filter to order_no = arcmps->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0
              go top
                if .not. eof()
                do
                do line_rtn
                until eofarcmpln
                 select arcmpsn
                go top
                if eof()
                append blank
                endif
                replace order_no with arcmps->order_no
             ENDIF
             ENDIF
             SELECT FGCOY
             FLUSH
            else
            wait 'Unable to Lock Tables - Try Again Later!'
            quit
            endif
            endif
            endif
            endif
             
             
             CLOSE DATABASES
             
procedure line_rtn
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            lerr = .t.
            select arcmpdup
            seek arcmpln->order_no+dtos(arcmps->order_date)+arcmpln->stock_no+arcmpln->dde_time
            if .not. found()
            append blank
            replace order_no with arcmpln->order_no
            replace order_date with arcmps->order_date
            replace stock_no with arcmpln->stock_no
            replace dde_time with arcmpln->dde_time
            lerr = .f.
            endif
            if empty(arcmpln->post_date)
            lerr = .f.
            endif
             if .not. lerr   
           l7 = arcmpln->order_no
         l8 = arcmpln->order_date
         l9 = arcmpln->stock_no
         l10 = 'SB'
         l11 = '68'
         if empty(l8)
         l8 = arcmps->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         select st15f
         go top
         rlock()
         pshno = shift_no
         pshid = shift_id
         else
         pshno = "0"
         pshid = "0"
         endif
         
       
         select fgtran
         append blank
         replace system with l10
         replace doctype with l11
         replace order_no with l7
         replace order_date with l8
         replace stock_no with l9
              replace actype  with "4"  && CURRENT ASSETS
            replace qty with 0
            replace unit_cost with 0
            replace new_bal with 0
            replace total with arcmpln->total
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with 0
            replace disc_rate with 0
            replace tax_amt with 0
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with arcmps->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with arcmps->PAYTYPE
            replace pay_method  with arcmps->pay_method
            REPLACE source WITH arcmps->source
            REPLACE FTYP WITH arcmps->FTYP
            REPLACE PMOD WITH arcmps->PMOD
           REPLACE FRIGHTER_N WITH arcmps->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace Bcoy  with arcmps->bcoy
              replace Bdiv  with arcmps->bdiv
               replace Bcen  with arcmps->bcen
                replace Bsto  with arcmps->bsto
            replace Btyp  with arcmps->btyp
           replace Bcla  with arcmps->bcla
           replace Bcod  with arcmps->bcod
           replace coy  with arcmpln->coy
           replace div   with arcmpln->div
           replace cen  with arcmpln->cen
           replace sto  with arcmpln->sto
           replace typ  with arcmpln->typ
           replace cla  with arcmpln->cla
           replace cod  with arcmpln->cod
                replace recdate with arcmpln->other_date
              replace lpo with arcmpln->ref
           replace serialno with arcmps->serialno
           REPLACE SHIFT_NO WITH arcmps->SHIFTNO
           REPLACE SHIFT_ID WITH arcmps->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
        
              
    
        DO arcmpln_RTN1
        ENDIF
        commit()
        flush
   SELECT arcmpln
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofarcmpln = .t.
   endif
 PROCEDURE arcmpln_RTN1
    PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,Parcmps,pstt,pftyp,psource,ppmod,p20,ptsdate
            local lld1,lld2
              ptsdate = arcmpln->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = arcmps->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = arcmps->BTYP
      pcla = arcmps->BCLA
      pcod = arcmps->BCOD
      pcoy = arcmps->BCOY
      pdiv = arcmps->BDIV
      pcen = arcmps->BCEN
      psto = arcmps->BSTO
       porder = arcmpln->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          Parcmps = .F.
          select arcmps
                 pcustno = arcmps->frighter_N
                  pftyp = FTYP
                        psource = SOURCE
                       ppmod = PMOD              
                    pcashrno = arcmps->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   Parcmps = .T.
      pfrighter = arcmps->frighter_N
               porder = arcmps->order_no
                        pftyp = arcmps->ftyp
                          pcashrno = arcmps->cashier_no
                          psource = arcmps->source
                          ppmod = arcmps->pmod
                    
           select scashrec
   seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
   if .not. found()
   append blank
   replace cashr_no with  pcashrno
   replace shift_date with pshdate
   replace shift_no with pshno
   replace shift_id with pshid
   replace cen with pcen
    replace sto with psto
   replace typ with ptyp
   replace cla with pcla
   replace cod with pcod
   replace non_cash with 0
   replace exp_cash with 0
    replace exp_sales with 0
  REPLACE COYVISA WITH 0
   REPLACE BBKVISA WITH 0
   REPLACE GENVISA WITH 0
   REPLACE CHQS WITH 0
   REPLACE PAYMNTS WITH 0
   REPLACE RECEPTS WITH 0
   REPLACE PURCH WITH 0
   replace A_CASH with 0
   replace shortage with 0
   replace cr_notes with 0
   replace dr_notes with 0
   replace pdebits with 0
   replace pcredits with 0
   replace ppurch with 0
   replace fc_sales with 0
replace  cash_bank with 0
replace  dbcredits with 0
replace  dbdebits  with 0
replace  chqs_bank with 0
replace  reserved1 with 0
replace  reserved2 with 0
replace  reserved3 with 0
replace  reserved4 with 0
replace  reserved5 with 0
replace a_c_inhand with 0
    replace off with arcmps->off
   endif
   rlock()
   IF EMPTY(OFF)
    replace off with arcmps->off
    ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   replace coy with "1"
  replace div with "5"
  replace cen with "1"
  
   
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
        rlock()
                  
               PERROR = .F.
          
     IF EMPTY(arcmpln->POST_DATE)  .AND. PCUS
    DO arcmpln_RTN2
    select arcmpln
    replace post_date with date()
    SELECT arcmpdup
    replace post_date with date()
    ENDIF
  
  
    
  PROCEDURE arcmpln_RTN2
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
                   LOCAL D1,D2
              D1 = DTOS(arcmps->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = arcmpln->TOTAL * -1
                 PTVAT = 0
      ptyp = arcmps->bTYP
      pcla = arcmps->bCLA
      pcod = arcmps->bCOD
      pcoy = arcmps->bCOY
      pdiv = arcmps->bDIV
      pcen = arcmps->bCEN
      psto = arcmps->bSTO
 
       PFTYP = arcmps->Ftyp
       PPMOD = arcmps->PMOD
       PSOURCE = arcmps->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = arcmpln->TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
        pcash = .T.
         pcredit = .F.
        Pcheque = .F.
        pother = .f.
    
           ptdate = arcmps->ORDER_date
              PFTYP = arcmps->Ftyp
              PPMOD = arcmps->PMOD
              PSOURCE = arcmps->SOURCE
              pttotal = arcmpln->total * -1
    select st15f
   GO TOP
   rlock()
         replace shift_post with date()
         if arcmps->btyp = 'C0' .and. arcmps->bcla = '00' .and. arcmps->bcod = '01' && cash in hand
             replace st15f->cash_CARDS with st15f->Cash_CARDS + arcmpln->total
             replace mp_float with mp_float - arcmpln->total  && float reduced
             replace cl_mpfloat with cl_mpfloat - arcmpln->total
             else
          replace st15f->cash_CARDS with st15f->Cash_CARDS + arcmpln->total
          replace dbcredits with dbcredits  + arcmpln->total
             replace mp_liquid with mp_liquid + arcmpln->total
             replace cl_mliquid with cl_mliquid + arcmpln->total
             replace mp_float with mp_float - arcmpln->total  && float reduced
             replace cl_mpfloat with cl_mpfloat - arcmpln->total
             endif
        SELECT SCASHREC 
          seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
       if arcmps->btyp = 'C0' .and. arcmps->bcla = '00' .and. arcmps->bcod = '01' && cash in hand
         REPLACE RECEPTS WITH RECEPTS + arcmpln->total
         else
         REPLACE RECEPTS WITH RECEPTS + arcmpln->total
   replace dbcredits with dbcredits  + arcmpln->total
        endif
        
            
        