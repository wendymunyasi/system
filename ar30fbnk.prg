
  Procedure ar30fbnk
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    set reprocess to 10000
    SET VIEW TO "ar30fbnk.QBE"
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
   set safety off
    select VNDOCREF
    if flock()
   set order to docref
   SET SAFETY ON
   select VENDOR
   if flock()
   set order to VENDOR
   select VNCOUNT
   if flock()
   set order to mkey
   select VNSTAT
   if flock()
   set order to mkey
 select arcbnupd
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


     eofARCBNKLN = .f.
     SELECT arcbnks
     GO TOP
     IF .NOT. EOF()
         select ARCBNKLN
     set filter to order_no = arcbnks->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 
              go top
                if .not. eof()
                do
                do line_rtn
                until eofARCBNKLN
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
             endif
             endif
             endif
             endif
             endif
             endif
            
             
             CLOSE DATABASES

procedure line_rtn
           begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            plerr = .t.
            select arcbnupd
            seek ARCBNKLN->order_no+dtos(arcbnks->order_date)+ARCBNKLN->stock_no+ARCBNKLN->dde_time
            if .not. found()
            append blank
            replace order_no with ARCBNKLN->order_no
            replace order_date with arcbnks->order_date
            replace stock_no with ARCBNKLN->stock_no
            replace dde_time with ARCBNKLN->dde_time
            plerr = .f.
            endif
            if empty(ARCBNKLN->post_date)
            plerr = .f.
            endif
             pl10 = "SB"
         pl11 = "56"
    
             if .not. plerr   
             
           pl7 = ARCBNKLN->order_no
         pl8 = ARCBNKLN->order_date
         pl9 = ARCBNKLN->stock_no
         
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
       Pbranch = .f.
       if arcbnks->pay_method = "Float Cash"
         pcash = .t.
      else
        if arcbnks->pay_method = "Transfer"
        pl10 = "SB"
         pl11 = "53"
       pbranch = .t.
       endif
       endif
      
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
            replace total with ARCBNKLN->total
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
       
           if pcash
            replace btyp  with arcbnks->btyp
           replace bcla  with arcbnks->bcla
           replace bcod  with arcbnks->bcod
           replace typ  with "C0"
           replace cla  with "00"
           replace cod  with "11"  && Float Cash 
           else
            replace btyp  with ARCBNKLN->typ
           replace bcla  with ARCBNKLN->cla
           replace bcod  with ARCBNKLN->cod
            replace typ  with arcbnks->btyp
           replace cla  with arcbnks->bcla
           replace cod  with arcbnks->bcod
         endif
        replace vsrce with arcbnks->vsrce
        replace vtyp with arcbnks->vtyp
        replace vpmod with arcbnks->vpmod
        replace vendor_n with arcbnks->vendor_n
           replace recdate with arcbnks->recdate
           if empty(recdate)
           replace recdate with order_date
           endif
           replace serialno with arcbnks->serialno
           REPLACE SHIFT_NO WITH arcbnks->SHIFTNO
           REPLACE SHIFT_ID WITH arcbnks->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace reg with ARCBNKLN->drawer
           replace lpo with ARCBNKLN->chqno
           replace reason with ARCBNKLN->bank
            
    
         DO ARCBNKLN_RTN1
         do fgtrand_rtn
    endif
         select  arcbnupd
         replace post_date with date()
   select ARCBNKLN
   replace post_date with date()
 *  endif
  commit()
    FLUSH
   select ARCBNKLN
   if .not. eof()
    skip
    endif
   if eof()
   eofARCBNKLN = .t.
   endif
  
  
  procedure fgtrand_rtn
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
            replace total with ARCBNKLN->total
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
       
           if pcash
            replace btyp  with arcbnks->btyp
           replace bcla  with arcbnks->bcla
           replace bcod  with arcbnks->bcod
           replace typ  with "C0"
           replace cla  with "00"
           replace cod  with "11"  && cash in hand
           else
            replace btyp  with ARCBNKLN->typ
           replace bcla  with ARCBNKLN->cla
           replace bcod  with ARCBNKLN->cod
            replace typ  with arcbnks->btyp
           replace cla  with arcbnks->bcla
           replace cod  with arcbnks->bcod
         endif
        
           replace recdate with arcbnks->recdate
           if empty(recdate)
           replace recdate with arcbnks->order_date
           endif
           replace serialno with arcbnks->serialno
           REPLACE SHIFT_NO WITH arcbnks->SHIFTNO
           REPLACE SHIFT_ID WITH arcbnks->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace reg with ARCBNKLN->drawer
           replace lpo with ARCBNKLN->chqno
           replace reason with ARCBNKLN->bank
  
  
 PROCEDURE ARCBNKLN_RTN1
    PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,Parcbnks,pstt,pftyp,psource,ppmod,p20,ptsdate
            local lld1,lld2
              ptsdate = ARCBNKLN->ORDER_DATE
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
      ptyp = arcbnks->BTYP
      pcla = arcbnks->BCLA
      pcod = arcbnks->BCOD
      pcoy = arcbnks->BCOY
      pdiv = arcbnks->BDIV
      pcen = arcbnks->BCEN
      psto = arcbnks->BSTO
       porder = ARCBNKLN->order_no
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
           
             pVENDOR = arcbnks->VENDOR_N
               porder = arcbnks->order_no
                        pvtyp = arcbnks->vtyp
                          pcashrno = arcbnks->cashier_no
                          pvsrce = arcbnks->vsrce
                          pvpmod = arcbnks->vpmod
    
                       
   
            SELECT VENDOR
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           PCUS = .T.
         ELSE
         ? "NO VENDOR"
           PCUS = .F.
        ENDIF
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
   endif
   if empty(off)
   replace off with arcbnks->off
   endif
   SELECT CASHIERS
   SEEK pcashrno
 replace coy with pcoy
 replace div with pdiv
 replace cen with pcen
   
      if pcash
   select scashrec
                     replace purch with purch -  ARCBNKLN->TOTAL
                     replace cash_bank with Cash_bank + ARCBNKLN->total
                       select st15f
        go top
         REPLACE SHIFT_POST WITH DATE()
                     replace cash_COY with cash_COY - ARCBNKLN->TOTAL
                     ENDIF
                                        select st15f
        go top
  
         replace batchamt with batchamt - ARCBNKLN->TOTAL
         replace cash_bank with Cash_bank + ARCBNKLN->total
         IF LEFT(ARCBNKS->BNAME,2) = 'M-' && M-MONEY
         REPLACE MBK_MONEY WITH MBK_MONEY  + ARCBNKLN->TOTAL
         ENDIF
 
    pdate = arcbnks->order_date
    pcustno =  arcbnks->VENDOR_n
    Pvtyp = arcbnks->vtyp
    Pvpmod = arcbnks->vpmod
    Pvsrce = arcbnks->vsrce
    
    pdoc = "56"
     
 
    
    DO vnstat_RTN1
       
   
        
      SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE + ARCBNKLN->TOTAL 
      IF VENDOR->BAL_DUE > 0
      REPLACE VENDOR->BAL_DUE_CR with  0
      REPLACE VENDOR->BAL_DUE_DR with  VENDOR->BAL_DUE
      ELSE
      REPLACE VENDOR->BAL_DUE_DR with  0
      REPLACE VENDOR->BAL_DUE_CR with  VENDOR->BAL_DUE * -1
      ENDIF
     
     
    DO vnstat_RTN2
    
PROCEDURE vnstat_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lvtyp,lvpmod,lvsrce,lmm,lyy,ld
  
      lref = arcbnks->order_no
      ldate = arcbnks->order_date
      tdate = arcbnks->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "SB"
      ldoc = pdoc
      lcust = arcbnks->VENDOR_n
      lvtyp = arcbnks->vtyp
      Pvtyp = arcbnks->vtyp
      lvpmod = arcbnks->vpmod
      lvsrce = arcbnks->vsrce
        select vnCOUNT
      seek lvsrce+lvtyp+lvpmod+LCUST+lyy+lmm
      if .not. found()
      append blank
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace yy with lyy
      replace mm with lmm
      replace count with "0000"
      REPLACE vtyp WITH Lvtyp
      REPLACE VENDOR_N WITH LCUST
      endif
      
      L1 = VAL(vnCOUNT->COUNT)
      L2 = L1 + 1
      L3 = STR(L2,5)
       select vndocref
     seek lvsrce+lvtyp+lvpmod+LCUST+lref
      if .not. found()
      append blank
      replace docref with lref
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace doctype with ldoc
        REPLACE vtyp WITH lvtyp
      REPLACE VENDOR_N WITH LCUST
      select vnCOUNT
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
       select vnstat
      seek lvsrce+lvtyp+lvpmod+LCUST+lyy+lmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE VENDOR_N WITH lcust
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace mm with lmm
      replace yy with lyy
      replace dd with right(dtos(ldate),2)
     REPLACE vtyp WITH lvtyp
               REPLACE MILEAGE WITH 0
               replace invoice with 0
              replace bl_dr with 0
             replace bl_cr with 0
             REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
             replace m_pay_amt with 0
             replace bal_this with 0
             replace bal_15 with 0
              replace bal_30 with 0
               replace bal_60 with 0
                replace bal_90 with 0
                 replace bal_120 with 0
                 replace alloc_tot with 0
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                 replace alloc_AMT with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with arcbnks->serialno
  *   replace REG        WITH arcbnks->paytype
       replace sTIME       WITH ltime
      * replace LPO        WITH ARCBNKLN->ref
         replace pay_method with arcbnks->pay_method
         replace recdate with arcbnks->RECDATE
          replace sdate with ldate
         replace bbf with VENDOR->bal_due
                if vnstat->bbf < 0
            replace bbf_cr with VENDOR->bal_due* -1
            replace bbf_dr with 0
         else
            replace bbf_dr with VENDOR->bal_due
            replace bbf_cr with 0
         endif
 
         endif
       
 PROCEDURE vnstat_rtn2
    SELECT vnstat
    replace bal_due with VENDOR->bal_due
   if vnstat->bal_due < 0
         replace bal_due_cr with VENDOR->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENDOR->bal_due
         replace bal_due_cr with 0
         endif
    replace total with vnstat->total + ARCBNKLN->total
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
       REPLACE BL_AMT WITH TOTAL  
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   select VENDOR
             replace l_pay_date with arcbnks->order_date
             replace l_pay_amt with (ARCBNKLN->total * -1) + L_pay_amt
            

