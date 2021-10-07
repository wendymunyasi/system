Procedure arcdspst
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "arcdspst.qbe"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
select arcsdupd
set order to mkey
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofarcsdlin = .f.
     SELECT arcdnts
     GO TOP
     IF .NOT. EOF()
         select arcsdlin
    set filter to order_no = arcdnts->order_no .and. empty(post_date) .AND. .NOT. TOTAL > 0 ;
     .AND. .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. ;
      .NOT. EMPTY(STO) .AND. .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(CLA) .AND. .NOT. EMPTY(COD)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofarcsdlin
                 select arcdntsn
                go top
                if eof()
                append blank
                endif
                replace order_no with arcdnts->order_no
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
            select arcsdupd
            seek arcsdlin->order_no+dtos(arcdnts->order_date)+arcsdlin->stock_no+arcsdlin->dde_time
            if .not. found()
            append blank
            replace order_no with arcsdlin->order_no
            replace order_date with arcdnts->order_date
            replace stock_no with arcsdlin->stock_no
            replace dde_time with arcsdlin->dde_time
            lerr = .f.
            endif
            if empty(arcsdlin->post_date)
            lerr = .f.
            endif
             if .not. lerr   
           l7 = arcsdlin->order_no
         l8 = arcsdlin->order_date
         l9 = arcsdlin->stock_no
         l10 = "SB"
         l11 = '15'
         if empty(l8)
         l8 = arcdnts->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         pshno = arcdnts->shiftno
         pshid = arcdnts->shiftid
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
            replace total with arcsdlin->total
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
            replace off with arcdnts->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace cashier_no with arcdnts->cashier_no
            replace TRANtype with arcdnts->PAYTYPE
            replace pay_method  with arcdnts->pay_method
            REPLACE source WITH arcdnts->source
            REPLACE FTYP WITH arcdnts->FTYP
            REPLACE PMOD WITH arcdnts->PMOD
           REPLACE FRIGHTER_N WITH arcdnts->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace Bcoy  with arcdnts->bcoy
              replace Bdiv  with arcdnts->bdiv
               replace Bcen  with arcdnts->bcen
                replace Bsto  with arcdnts->bsto
            replace Btyp  with arcdnts->btyp
           replace Bcla  with arcdnts->bcla
           replace Bcod  with arcdnts->bcod
           replace coy  with arcsdlin->coy
           replace div   with arcsdlin->div
           replace cen  with arcsdlin->cen
           replace sto  with arcsdlin->sto
           replace typ  with arcsdlin->typ
           replace cla  with arcsdlin->cla
           replace cod  with arcsdlin->cod
*             REPLACE vsrce WITH arcsdlin->vsrce
           * REPLACE vTYP WITH arcsdlin->vtyp
         *   REPLACE vPMOD WITH arcsdlin->vpmod
        *   REPLACE vendor_N WITH arcsdlin->vendor_n
              replace recdate with order_date
              replace lpo with arcsdlin->ref
           replace serialno with arcdnts->serialno
           REPLACE SHIFT_NO WITH arcdnts->SHIFTNO
           REPLACE SHIFT_ID WITH arcdnts->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
        
     select arcsdlin
    replace post_date with date()
    SELECT arcsdupd
    replace post_date with date()
        commit()
     ENDIF   
   SELECT arcsdlin
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofarcsdlin = .t.
   endif
  
  
  
  