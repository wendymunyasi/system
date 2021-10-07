Procedure arcrcpst
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "arcrcpst.qbe"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
select arcreupd
set order to mkey
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofarcrecln = .f.
     SELECT ARCRECS
     GO TOP
     IF .NOT. EOF()
         select arcrecln
    set filter to order_no = ARCRECS->order_no .and. empty(post_date) .AND. .NOT. TOTAL <= 0 ;
     .AND. .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. ;
      .NOT. EMPTY(STO) .AND. .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(CLA) .AND. .NOT. EMPTY(COD)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofarcrecln
                 select ARCRECSn
                go top
                if eof()
                append blank
                endif
                replace order_no with ARCRECS->order_no
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
            select arcreupd
            seek arcrecln->order_no+dtos(ARCRECS->order_date)+arcrecln->stock_no+arcrecln->dde_time
            if .not. found()
            append blank
            replace order_no with arcrecln->order_no
            replace order_date with ARCRECS->order_date
            replace stock_no with arcrecln->stock_no
            replace dde_time with arcrecln->dde_time
            lerr = .f.
            endif
            if empty(arcrecln->post_date)
            lerr = .f.
            endif
             if .not. lerr   
           l7 = arcrecln->order_no
         l8 = arcrecln->order_date
         l9 = arcrecln->stock_no
         l10 = "SB"
         l11 = '16'
         if empty(l8)
         l8 = ARCRECS->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         pshno = ARCRECS->shiftno
         pshid = ARCRECS->shiftid
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
            replace total with arcrecln->total
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
            replace off with ARCRECS->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace cashier_no with ARCRECS->cashier_no
            replace TRANtype with ARCRECS->PAYTYPE
            replace pay_method  with ARCRECS->pay_method
            REPLACE source WITH ARCRECS->source
            REPLACE FTYP WITH ARCRECS->FTYP
            REPLACE PMOD WITH ARCRECS->PMOD
           REPLACE FRIGHTER_N WITH ARCRECS->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace Bcoy  with ARCRECS->bcoy
              replace Bdiv  with ARCRECS->bdiv
               replace Bcen  with ARCRECS->bcen
                replace Bsto  with ARCRECS->bsto
            replace Btyp  with ARCRECS->btyp
           replace Bcla  with ARCRECS->bcla
           replace Bcod  with ARCRECS->bcod
           replace coy  with arcrecln->coy
           replace div   with arcrecln->div
           replace cen  with arcrecln->cen
           replace sto  with arcrecln->sto
           replace typ  with arcrecln->typ
           replace cla  with arcrecln->cla
           replace cod  with arcrecln->cod
*             REPLACE vsrce WITH arcrecln->vsrce
           * REPLACE vTYP WITH arcrecln->vtyp
         *   REPLACE vPMOD WITH arcrecln->vpmod
        *   REPLACE vendor_N WITH arcrecln->vendor_n
              replace recdate with arcrecln->other_date
              replace lpo with arcrecln->ref
           replace serialno with ARCRECS->serialno
           REPLACE SHIFT_NO WITH ARCRECS->SHIFTNO
           REPLACE SHIFT_ID WITH ARCRECS->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
        
     select arcrecln
    replace post_date with date()
    SELECT arcreupd
    replace post_date with date()
        commit()
     ENDIF   
   SELECT arcrecln
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofarcrecln = .t.
   endif
  
  
  
  