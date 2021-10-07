Procedure ARDRCPST
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "ARDRCPST.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
select ardredup
set order to mkey
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofardrecln = .f.
       SELECT FGVISNOS
      SET ORDER TO MKEY
     SELECT ARDRECS
     GO TOP
     IF .NOT. EOF()
         select ardrecln
    set filter to order_no = ardrecs->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 ;
     .AND. .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. ;
      .NOT. EMPTY(STO) .AND. .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(CLA) .AND. .NOT. EMPTY(COD)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofardrecln
                 select ardrecsn
                go top
                if eof()
                append blank
                endif
                replace order_no with ardrecs->order_no
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
            select ardredup
            seek ardrecln->order_no+dtos(ARDRECS->order_date)+ardrecln->stock_no+ardrecln->dde_time
            if .not. found()
            append blank
            replace order_no with ardrecln->order_no
            replace order_date with ARDRECS->order_date
            replace stock_no with ardrecln->stock_no
            replace dde_time with ardrecln->dde_time
            lerr = .f.
            endif
            if empty(ardrecln->post_date)
            lerr = .f.
            endif
             if .not. lerr   
           l7 = ardrecln->order_no
         l8 = ardrecln->order_date
         l9 = ardrecln->stock_no
         l10 = "DS"
         l11 = "52"
         if empty(l8)
         l8 = ardrecs->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         pshno = ardrecs->shiftno
         pshid = ardrecs->shiftid
         else
         pshno = "0"
         pshid = "0"
         endif
         
       
         select ARDRCPST
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
            replace total with ardrecln->total
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
            replace off with ardrecs->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace cashier_no with ardrecs->cashier_no
            replace TRANtype with ardrecs->PAYTYPE
            replace pay_method  with ardrecs->pay_method
            REPLACE source WITH ardrecs->source
            REPLACE FTYP WITH ardrecs->FTYP
            REPLACE PMOD WITH ardrecs->PMOD
           REPLACE FRIGHTER_N WITH ardrecs->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace coy  with ardrecs->bcoy  && credit
              replace div  with ardrecs->bdiv
               replace cen  with ardrecs->bcen
                replace sto  with ardrecs->bsto
            replace typ  with ardrecs->btyp 
           replace cla  with ardrecs->bcla
           replace cod  with ardrecs->bcod
           replace bcoy  with ardrecln->coy  && debit
           replace bdiv   with ardrecln->div
           replace bcen  with ardrecln->cen
           replace bsto  with ardrecln->sto
           replace btyp  with ardrecln->typ
           replace bcla  with ardrecln->cla
           replace bcod  with ardrecln->cod
             REPLACE vsrce WITH ardrecln->vsrce
            REPLACE vTYP WITH ardrecln->vtyp
            REPLACE vPMOD WITH ardrecln->vpmod
           REPLACE vendor_N WITH ardrecln->vendor_n
              replace recdate with ardrecs->recdate
              replace lpo with ardrecln->ref
           replace serialno with ardrecs->serialno
           REPLACE SHIFT_NO WITH ardrecs->SHIFTNO
           REPLACE SHIFT_ID WITH ardrecs->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace nett_total with ardrecs->nett_total
           replace svccoy  with ardrecs->coy  && debit
           replace svcdiv  with ardrecs->div
           replace svccen  with ardrecs->cen
           replace svcsto  with ardrecs->sto
           replace svctyp  with ardrecs->typ
           replace svccla  with ardrecs->cla
           replace svccod  with ardrecs->cod
           replace rec_total  with ardrecln->rec_total
           replace svc_total  with ardrecln->svc_total
           pserial = val(ardrecs->serialno)
           ps = '3'
           pf = '0001'
           if ardrecs->maxserial > 0
            SELECT FGVISNOS
          SEEK PS+PS+PS+PF+STR(PSERIAL)
          IF FOUND()
             if ardrecln->rec_total  < 0
             REPLACE DDE_USER WITH ''
             REPLACE ORDER_NO WITH ''
             REPLACE ORDER_DATE WITH {}
             replace system with ''
             else
             REPLACE DDE_USER WITH pluser
             REPLACE ORDER_NO WITH ardrecs->order_no
             REPLACE ORDER_DATE WITH ardrecs->order_date
            replace system with 'DS'
             ENDIF
             endif
             endif
        
     select ardrecln
    replace post_date with date()
    SELECT ardredup
    replace post_date with date()
        commit()
     ENDIF   
   SELECT ardrecln
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofardrecln = .t.
   endif
  
  
  
  