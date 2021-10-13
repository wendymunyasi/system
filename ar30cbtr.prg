Procedure ar30cbtr
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
   set reprocess to 10000
    set exact on
    SET VIEW TO "ar30cbtr.QBE"
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 select arcbnupd
 
set order to mkey
select st15f
if flock()
set order to mkey
go top


     eofarcbnkln = .f.
     SELECT arcbnks
     
     GO TOP
     IF .NOT. EOF()
         select arcbnkln
         
    set filter to order_no = arcbnks->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 
              go top
                if .not. eof()
                do
                do line_rtn
                until eofarcbnkln
                      select arcbnksn
                go top
                if eof()
                append blank
                endif
                replace order_no with arcbnks->order_no
             ENDIF
             ENDIF
             SELECT FGCOY
             FLUSH
            else
            wait 'Unable to lock tables - try again later!'
            quit
            endif
             CLOSE DATABASES

procedure line_rtn
           begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            plerr = .t.
            select arcbnupd
            seek arcbnkln->order_no+dtos(arcbnks->order_date)+arcbnkln->stock_no+arcbnkln->dde_time
            if .not. found()
            append blank
            replace order_no with arcbnkln->order_no
            replace order_date with arcbnks->order_date
            replace stock_no with arcbnkln->stock_no
            replace dde_time with arcbnkln->dde_time
            plerr = .f.
            endif
            if empty(arcbnkln->post_date)
            plerr = .f.
            endif
             pl10 = "SB"
         pl11 = "56"
    
             if .not. plerr  
              do line_rtn_cont
              endif
              select  arcbnupd
         replace post_date with date()
   select arcbnkln
   replace post_date with date()
  commit()
    FLUSH
   select arcbnkln
   if .not. eof()
    skip
    endif
   if eof()
   eofarcbnkln = .t.
   endif
 procedure line_rtn_cont
             
           pl7 = arcbnkln->order_no
         pl8 = arcbnkln->order_date
         pl9 = arcbnkln->stock_no
         
         if empty(pl8)
         pl8 = arcbnks->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         select st15f
         go top
         pshno = shift_no
         pshid = shift_id
         else
         pshno = "0"
         pshid = "0"
         endif
         
       pcash = .f.
       pbbk = .f.
       pcheque = .f.
       pdirect = .f.
       PMOB = .F.
       Pbranch = .f.
       if arcbnks->pay_method = "FC Cash" 
       IF arcbnks->paytype = 'M-MONEY'
       PMOB = .T.
       ELSE
       PCASH = .T.
       ENDIF
       else
        if arcbnks->pay_method = "Transfer"
        pl10 = "SB"
         pl11 = "53"
       pbranch = .t.
       endif
       endif
      
       
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
            replace total with arcbnkln->total
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
            replace off with arcbnks->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with arcbnks->paytype
            replace pay_method  with arcbnks->pay_method
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
         replace btyp  with arcbnks->btyp
           replace bcla  with arcbnks->bcla
           replace bcod  with arcbnks->bcod
             replace typ  with arcbnkln->typ
           replace cla  with arcbnkln->cla
           replace cod  with arcbnkln->cod
          replace recdate with order_date
           replace serialno with arcbnks->serialno
           REPLACE SHIFT_NO WITH arcbnks->SHIFTNO
           REPLACE SHIFT_ID WITH arcbnks->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace reg with ARCBNKLN->drawer
           replace lpo with ARCBNKLN->chqno
           replace reason with ARCBNKLN->bank
       PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,Parcbnks,pstt,pftyp,psource,ppmod,p20,ptsdate
            local lld1,lld2
              ptsdate = arcbnkln->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = arcbnks->order_date
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
       porder = arcbnkln->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          Parcbnks = .F.
                      pcashrno = arcbnks->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
  select st15f
   GO TOP
   
         replace shift_post with date()
        if  left(arcbnks->bname,14) = 'M-MPESA LIQUID'
        REPLACE CL_MLIQUID WITH CL_MLIQUID + arcbnkln->total
        REPLACE MP_LIQUID WITH MP_LIQUID + arcbnkln->total
        ENDIF
        if  left(arcbnks->bname,13) = 'M-MPESA FLOAT'
        REPLACE CL_MPFLOAT WITH CL_MPFLOAT + arcbnkln->total
        REPLACE MP_FLOAT WITH MP_FLOAT + arcbnkln->total
        ENDIF
        if  left(arcbnks->bname,15) = 'M-MPESA CAPITAL'
        REPLACE CL_CAPITAL WITH CL_CAPITAL + arcbnkln->total
        REPLACE MP_CAPITAL WITH MP_CAPITAL + arcbnkln->total
        ENDIF
        if  left(arcbnkln->bname,14) = 'M-MPESA LIQUID'
        REPLACE CL_MLIQUID WITH CL_MLIQUID - arcbnkln->total
        REPLACE MP_LIQUID WITH MP_LIQUID - arcbnkln->total
        ENDIF
        if  left(arcbnkln->bname,13) = 'M-MPESA FLOAT'
        REPLACE CL_MPFLOAT WITH CL_MPFLOAT - arcbnkln->total
        REPLACE MP_FLOAT WITH MP_FLOAT - arcbnkln->total
        ENDIF
        if  left(arcbnkln->bname,15) = 'M-MPESA CAPITAL'
        REPLACE CL_CAPITAL WITH CL_CAPITAL - arcbnkln->total
        REPLACE MP_CAPITAL WITH MP_CAPITAL - arcbnkln->total
    ENDIF
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
            replace total with arcbnkln->total
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
            replace off with arcbnks->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with arcbnks->paytype
            replace pay_method  with arcbnks->pay_method
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
           replace btyp  with arcbnks->btyp
           replace bcla  with arcbnks->bcla
           replace bcod  with arcbnks->bcod
           replace typ  with arcbnkln->typ
           replace cla  with arcbnkln->cla
           replace cod  with arcbnkln->cod
          replace recdate with order_date
           replace serialno with arcbnks->serialno
           REPLACE SHIFT_NO WITH arcbnks->SHIFTNO
           REPLACE SHIFT_ID WITH arcbnks->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace reg with ARCBNKLN->drawer
           replace lpo with ARCBNKLN->chqno
           replace reason with ARCBNKLN->bank
         