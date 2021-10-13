Procedure ARTRCPST
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "ARTRCPST.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
select artrecup
set order to mkey
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofartrecln = .f.
      SELECT FGVISNOS
      SET ORDER TO MKEY
     SELECT artrecS
     GO TOP
     IF .NOT. EOF()
         select artrecln
    set filter to order_no = artrecs->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 ;
     .AND. .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. ;
      .NOT. EMPTY(STO) .AND. .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(CLA) .AND. .NOT. EMPTY(COD)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofartrecln
                 select artrecsn
                go top
                if eof()
                append blank
                endif
                replace order_no with artrecs->order_no
             ENDIF
             ENDIF
             SELECT FGCOY
             FLUSH
             SET AUTOSAVE OFF
           
             
             CLOSE DATABASES
             
procedure line_rtn
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            lerr = .t.
            select artrecup
            seek artrecln->order_no+dtos(artrecS->order_date)+artrecln->stock_no+artrecln->dde_time
            if .not. found()
            append blank
            replace order_no with artrecln->order_no
            replace order_date with artrecS->order_date
            replace stock_no with artrecln->stock_no
            replace dde_time with artrecln->dde_time
            lerr = .f.
            endif
            if empty(artrecln->post_date)
            lerr = .f.
            endif
             if .not. lerr   
           l7 = artrecln->order_no
         l8 = artrecln->order_date
         l9 = artrecln->stock_no
         l10 = "DS"
         l11 = '72'
         if empty(l8)
         l8 = artrecs->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         pshno = artrecs->shiftno
         pshid = artrecs->shiftid
         else
         pshno = "0"
         pshid = "0"
         endif
         
       
         select ARTRCPST
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
            replace total with artrecln->total
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
            replace off with artrecs->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace cashier_no with artrecs->cashier_no
            replace TRANtype with artrecs->PAYTYPE
            replace pay_method  with artrecs->pay_method
            REPLACE source WITH artrecs->source && credit
            REPLACE FTYP WITH artrecs->FTYP
            REPLACE PMOD WITH artrecs->PMOD
           REPLACE FRIGHTER_N WITH artrecs->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace coy  with artrecs->bcoy  
              replace div  with artrecs->bdiv
               replace cen  with artrecs->bcen
                replace sto  with artrecs->bsto
            replace typ  with artrecs->btyp 
           replace cla  with artrecs->bcla
           replace cod  with artrecs->bcod
           
           replace dcoy  with artrecln->coy  && debit
           replace ddiv   with artrecln->div
           replace dcen  with artrecln->cen
           replace dsto  with artrecln->sto
           replace dtyp  with artrecln->typ
           replace dcla  with artrecln->cla
           replace dcod  with artrecln->cod
            REPLACE dsource WITH artrecln->source
            REPLACE dftyp WITH artrecln->ftyp
            REPLACE dPMOD WITH artrecln->pmod
           REPLACE dfrighter WITH artrecln->frighter_n
              replace recdate with artrecs->recdate
              replace reg with right(artrecs->lpo,17)
              replace card_no with left(artrecs->lpo,8)
           replace serialno with artrecs->serialno
           REPLACE SHIFT_NO WITH artrecs->SHIFTNO
           REPLACE SHIFT_ID WITH artrecs->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace nett_total with artrecs->nett_total
           replace svccoy  with artrecs->coy  && debit
           replace svcdiv  with artrecs->div
           replace svccen  with artrecs->cen
           replace svcsto  with artrecs->sto
           replace svctyp  with artrecs->typ
           replace svccla  with artrecs->cla
           replace svccod  with artrecs->cod
           replace rec_total  with artrecln->rec_total
           replace svc_total  with artrecln->svc_total
           pserial = val(artrecs->serialno)
           ps = '3'
           pf = '0001'
           if artrecs->maxserial > 0
            SELECT FGVISNOS
          SEEK PS+PS+PS+PF+STR(PSERIAL)
          IF FOUND()
             if artrecln->rec_total  < 0
             REPLACE DDE_USER WITH ''
             REPLACE ORDER_NO WITH ''
             REPLACE ORDER_DATE WITH {}
             replace system with ''
             else
             REPLACE DDE_USER WITH pluser
             REPLACE ORDER_NO WITH artrecs->order_no
             REPLACE ORDER_DATE WITH artrecs->order_date
            replace system with 'DS'
             ENDIF
             endif
             endif
        
     select artrecln
    replace post_date with date()
    SELECT artrecup
    replace post_date with date()
        commit()
     ENDIF   
   SELECT artrecln
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofartrecln = .t.
   endif
  
  
  
  