Procedure ar30mpft
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET VIEW TO "ar30mpft.QBE"
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 * 
 select armbnupd
set order to mkey
SELECT CASHIERS
if flock()
SET ORDER TO CASHIER
SELECT SCASHREC
if flock()
SET ORDER TO MKEY
select st15f
if flock()
set order to mkey
go top


     eofarmbnkln = .f.
     SELECT armbnks
     
     GO TOP
     IF .NOT. EOF()
         select armbnkln
         
    set filter to order_no = armbnks->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 
              go top
                if .not. eof()
                do
                do line_rtn
                until eofarmbnkln
                      select armbnksn
                go top
                if eof()
                append blank
                endif
                replace order_no with armbnks->order_no
             ENDIF
             ENDIF
             SELECT FGCOY
             FLUSH
            else
            wait 'Unable to lock tables - try again later!'
            quit
            endif
            endif
            endif
             CLOSE DATABASES

procedure line_rtn
           begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            plerr = .t.
            select armbnupd
            seek armbnkln->order_no+dtos(armbnks->order_date)+armbnkln->stock_no+armbnkln->dde_time
            if .not. found()
            append blank
            replace order_no with armbnkln->order_no
            replace order_date with armbnks->order_date
            replace stock_no with armbnkln->stock_no
            replace dde_time with armbnkln->dde_time
            plerr = .f.
            endif
            if empty(armbnkln->post_date)
            plerr = .f.
            endif
             pl10 = "SB"
         pl11 = '69'
    
             if .not. plerr && 1
             do line_rtn_cont
              endif
         select  armbnupd
         replace post_date with date()
   select armbnkln
   replace post_date with date()
 *  endif
  commit()
    FLUSH
   select armbnkln
   if .not. eof()
    skip
    endif
   if eof()
   eofarmbnkln = .t.
   endif
procedure line_rtn_cont
              
            local lld1,lld2
  
           pl7 = armbnkln->order_no
         pl8 = armbnkln->order_date
         pl9 = armbnkln->stock_no
         
         if empty(pl8) && 2
         pl8 = armbnks->order_date
         endif && 2
         select fgcoy
         go top
         if pospost = "Yes"  && 3
         select st15f
         go top
         
         pshno = shift_no
         pshid = shift_id
         else
         pshno = "0"
         pshid = "0"
         endif  && 3
         
       pcash = .f.
       pbbk = .f.
       pcheque = .f.
       pdirect = .f.
       PMOB = .F.
       Pbranch = .f.
       if armbnks->pay_method = "Cash"   && 4
       IF armbnks->paytype = 'M-MONEY' && 5
       PMOB = .T.
       ELSE
       PCASH = .T.
       ENDIF && 5
       else
        if armbnks->pay_method = "Transfer"  && 6
        pl10 = "SB"
         pl11 = "53"
       pbranch = .t.
       endif  && 6
       endif  && 4
      
  *   if pcash .or. pbranch
       
         select fgtran
          append blank
         replace system with pl10
         replace doctype with pl11
         replace order_no with pl7
         replace order_date with pl8
         replace stock_no with pl9
              replace actype  with "4"  && CURRENT ASSETS
            replace qty with 0
            replace unit_cost with 0
            replace new_bal with 0
            replace total with armbnkln->total
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
            replace off with armbnks->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with armbnks->paytype
            replace pay_method  with armbnks->pay_method
               replace shift_no with pshno
           replace shift_id with pshid
             replace coy  with "1"
           replace div   with "5"
           replace cen  with "1"
           replace sto  with "A1"
             replace bcoy  with "1"
           replace bdiv   with "5"
           replace bcen  with "1"
           replace bsto  with "A1"
       
       *    if pcash .OR. PMOB  && 7
             replace typ  with armbnkln->typ
           replace cla  with armbnkln->cla
           replace cod  with armbnkln->cod
         *  else
           replace btyp  with armbnks->btyp
           replace bcla  with armbnks->bcla
           replace bcod  with armbnks->bcod
      *   endif  && 7
        
            replace recdate with order_date
           replace serialno with armbnks->serialno
           REPLACE SHIFT_NO WITH armbnks->SHIFTNO
           REPLACE SHIFT_ID WITH armbnks->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace reg with armbnkln->drawer
           replace lpo with armbnkln->chqno
           replace reason with armbnkln->bank
            
    
               ptsdate = armbnkln->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
     
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = armbnks->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = FGTRAN->TYP
      pcla = FGTRAN->CLA
      pcod = FGTRAN->COD
      pcoy = FGTRAN->COY
      pdiv = FGTRAN->DIV
      pcen = FGTRAN->CEN
      psto = FGTRAN->STO
       porder = armbnkln->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          Parmbnks = .F.
                      pcashrno = armbnks->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
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
   replace off with armbnks->off
   endif
    
   IF EMPTY(OFF)
    replace off with armbnks->off
    ENDIF
   SELECT CASHIERS
   SEEK pcashrno
 replace coy with pcoy
 replace div with pdiv
 replace cen with pcen
    select st15f
   GO TOP
    
         replace shift_post with date()
         if armbnks->btyp = 'C0' .and. armbnks->bcla = '00' .and. armbnks->bcod = '01' && cash in hand
             replace st15f->cash_CARDS with st15f->Cash_CARDS + armbnkln->total
             replace cl_mpfloat with cl_mpfloat - armbnkln->total
             replace mp_float with mp_float - armbnkln->total
             else
              replace st15f->cash_CARDS with st15f->Cash_CARDS + armbnkln->total
              replace st15f->dbcredits   with st15f->dbcredits + armbnkln->total
           replace cl_mliquid with cl_mliquid + armbnkln->total
          replace mp_liquid with mp_liquid + armbnkln->total
          replace cl_mpfloat with cl_mpfloat - armbnkln->total
          replace mp_float with mp_float - armbnkln->total
          endif
         SELECT SCASHREC 
          seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
           if armbnks->btyp = 'C0' .and. armbnks->bcla = '00' .and. armbnks->bcod = '01' && cash in hand
               REPLACE RECEPTS WITH RECEPTS + armbnkln->total
               else
                 REPLACE RECEPTS WITH RECEPTS + armbnkln->total
             replace dbcredits   with dbcredits + armbnkln->total
        endif
        
  
         select fgtrand
          append blank
         replace system with pl10
         replace doctype with pl11
         replace order_no with pl7
         replace order_date with pl8
         replace stock_no with pl9
              replace actype  with "4"  && CURRENT ASSETS
            replace qty with 0
            replace unit_cost with 0
            replace new_bal with 0
            replace total with armbnkln->total
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
            replace off with armbnks->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with armbnks->paytype
            replace pay_method  with armbnks->pay_method
               replace shift_no with pshno
           replace shift_id with pshid
             replace coy  with "1"
           replace div   with "5"
           replace cen  with "1"
           replace sto  with "A1"
             replace bcoy  with "1"
           replace bdiv   with "5"
           replace bcen  with "1"
           replace bsto  with "A1"
       
          
       *    if pcash .OR. PMOB  && 7
             replace typ  with armbnkln->typ
           replace cla  with armbnkln->cla
           replace cod  with armbnkln->cod
         *  else
           replace btyp  with armbnks->btyp
           replace bcla  with armbnks->bcla
           replace bcod  with armbnks->bcod
      *   endif  && 7
           replace recdate with armbnks->order_date
           replace serialno with armbnks->serialno
           REPLACE SHIFT_NO WITH armbnks->SHIFTNO
           REPLACE SHIFT_ID WITH armbnks->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace reg with armbnkln->drawer
           replace lpo with armbnkln->chqno
           replace reason with armbnkln->bank