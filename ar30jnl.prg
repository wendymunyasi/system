Procedure ar30jnl
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
 *   SET AUTOSAVE ON
    SET VIEW TO "ar30jnl.QBE"
           PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
set reprocess to 10000
select frcustbl
   if  flock()
select frighter
if flock()
set order to frighter
select frmodebt
if flock()
set order to mkey
SET SAFETY OFF
select frddebtp
if flock()
set order to mkey
select frcount
if flock()
set order to mkey
select frdocref

set order to docref
select frshtrn
if flock()
set order to mkey
SET SAFETY ON
select VENDOR
if flock()
   set order to VENDOR
      select VNCOUNT
      
   set order to mkey
   select VNSTAT
   if flock()
   set order to mkey
      set safety off
     select VNDOCREF
     
   set order to docref
   SET SAFETY ON

  
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofarjncpst = .f.
     SELECT arjncpst
     GO TOP
     IF .NOT. EOF()
         select arjncpst
   set filter to  .NOT. rec_TOTAL = 0 .AND. .NOT. (EMPTY(arjncpst->btyp) .and. empty(typ));
     .AND.  .NOT. (EMPTY(arjncpst->VSRCE) .AND. .NOT. SVC_TOTAL =0)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofarjncpst
                 
             ENDIF
             ENDIF
             select fgcoy
             flush
             SET AUTOSAVE OFF
            else
            Wait 'Cannot Lock Tables Try Again Later'
            quit
             endif
             endif
             endif
            endif
             endif
            endif
             ENDIF
             ENDIF
             SET SAFETY OFF
             CLOSE DATABASES
             USE  \KENSERVICE\DATA\arjncpst.DBF EXCLUSIVE
              ZAP
             close databases
              
  
procedure line_rtn
 PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,Parjncpst,pstt,pftyp,psource,ppmod,p20,ptsdate
   
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            lerr = .f.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
           l7 = arjncpst->order_no
         l8 = arjncpst->order_date
         l9 = arjncpst->stock_no
         l10 = 'GL'
         l11 = ARJNCPST->DOCTYPE
         pshno = "0"
         pshid = "0"
          pftyp = arjncpst->FTYP
          psource = arjncpst->SOURCE
                       ppmod = arjncpst->PMOD  
                        pfrighter = arjncpst->frighter_N
                        pcustno = pfrighter
           SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
          Wait 'Problem with customer masterfile - Try Again Later!'
           quit
        ENDIF
          select frcustbl
  locate for source = psource .and. ftyp = pftyp .and. pmod = ppmod .and. frighter_n = pfrighter
  if .not. found()
  append blank
  replace source with psource
  replace ftyp with pftyp
  replace pmod with ppmod
  replace frighter_n with pfrighter
  replace bal_due with frighter->bal_due
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
            replace total with arjncpst->rec_total && total receipts
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with 0
            replace disc_rate with arjncpst->tax_RATE
            replace tax_amt with arjncpst->tax_amt   
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with arjncpst->off
*            REPLACE INV_NO WITH arjncpst->END_REC
            replace inv_py_amt with 0
            replace gross_amt with arjncpst->SVC_TOTAL
            replace basic_amt with arjncpst->TOTAL  && NETT AMT
            replace dsc  WITH 0
            replace TRANtype with arjncpst->trantype
            replace pay_method  with arjncpst->pay_method
            REPLACE source WITH arjncpst->source
            REPLACE FTYP WITH arjncpst->FTYP
            REPLACE PMOD WITH arjncpst->PMOD
           REPLACE FRIGHTER_N WITH arjncpst->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
           if .not. empty(arjncpst->btyp)
           replace Bcoy  with arjncpst->bcoy  && CREDITORS CONTROL VENDOR IS SELECTED
           replace Btyp  with arjncpst->btyp
           replace Bcla  with arjncpst->bcla
           replace Bcod  with arjncpst->bcod
            replace Bsto  with arjncpst->bsto
             replace Bdiv  with arjncpst->bdiv
              replace Bcen  with arjncpst->bcen
              else
           replace Bcoy  with arjncpst->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with arjncpst->typ
           replace Bcla  with arjncpst->cla
           replace Bcod  with arjncpst->cod
            replace Bsto  with arjncpst->sto
             replace Bdiv  with arjncpst->div
              replace Bcen  with arjncpst->cen
      ENDIF
           replace coy  with arjncpst->coy  && DEBTORS CONTROL - DEBITED
           replace typ  with arjncpst->typ
           replace cla  with arjncpst->cla
           replace cod  with arjncpst->cod
            replace sto  with arjncpst->sto
             replace div  with arjncpst->div
              replace cen  with arjncpst->cen
                 if trantype = "Deposit"
                replace coy  with "1" && DEBTORS CONTROL - DEBITED
           replace typ  with "L0"
           replace cla  with "00"
           replace cod  with "00"
            replace sto  with "A1"
             replace div  with "5"
              replace cen  with "1"
             replace Bcoy  with arjncpst->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with arjncpst->typ
           replace Bcla  with arjncpst->cla
           replace Bcod  with arjncpst->cod
            replace Bsto  with arjncpst->sto
             replace Bdiv  with arjncpst->div
              replace Bcen  with arjncpst->cen
endif
           
              replace vsrce with arjncpst->vsrce
      replace vpmod with arjncpst->vpmod
      replace vtyp with arjncpst->vtyp
      replace vendor_n with arjncpst->vendor_n
 
              replace recdate with arjncpst->order_date
              replace lpo with arjncpst->LPO
         *  replace serialno with arjncpst->START_REC  && START RECEIPT NO
           REPLACE SHIFT_NO WITH '0'
           REPLACE SHIFT_ID WITH '0'
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           
     
        DO arjncpst_RTN1
        commit()
        
       SELECT arjncpst
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofarjncpst = .t.
   endif
   

  
 PROCEDURE arjncpst_RTN1
            local lld1,lld2
              ptsdate = arjncpst->ORDER_DATE
            SELECT FGCOY
            GO TOP
        pshdate = arjncpst->order_date
     pshno = "0"
    pshid = "0"
    * pterror = .f.  
      ptyp = arjncpst->TYP
      pcla = arjncpst->CLA
      pcod = arjncpst->COD
      pcoy = arjncpst->COY
      pdiv = arjncpst->DIV
      pcen = arjncpst->CEN
      psto = arjncpst->STO
      
       porder = arjncpst->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          Parjncpst = .F.
          select arjncpst
                 pcustno = arjncpst->frighter_N
                  pftyp = arjncpst->FTYP
                        psource = arjncpst->SOURCE
                       ppmod = arjncpst->PMOD  
                        pfrighter = arjncpst->frighter_N
     
                    pcashrno = arjncpst->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   Parjncpst = .T.
               porder = arjncpst->order_no
                        pftyp = arjncpst->ftyp
                          pcashrno = arjncpst->cashier_no
                          psource = arjncpst->source
                          ppmod = arjncpst->pmod
   
      
                  
               PERROR = .F.
          
     IF EMPTY(arjncpst->POST_DATE)  .AND. PCUS
    DO arjncpst_RTN2
      IF  .NOT.  arjncpst->svc_total = 0       .OR. .NOT.  EMPTY(arjncpst->vsrce)
       do appymts_rtn && for the nett , but update fgnfpur for the service charge transaction
       ENDIF

    SELECT arjncpst
     REPLACE POST_DATE WITH DATE()
      ENDIF
  
  
    
  PROCEDURE arjncpst_RTN2
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
              D1 = DTOS(arjncpst->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = arjncpst->REC_TOTAL * -1
                 PTVAT = 0
              PCOY = arjncpst->COY
              PDIV = arjncpst->DIV
              PCEN = arjncpst->CEN
              PTYP = arjncpst->TYP
              PSTO = arjncpst->STO
              PCLA = arjncpst->CLA
              PCOD = arjncpst->COD
       PFTYP = arjncpst->Ftyp
       PPMOD = arjncpst->PMOD
       PSOURCE = arjncpst->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = arjncpst->REC_TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
        pcash = .F.
        pcredit = .T.
        Pcheque = .F.
        pother = .f.
  
           ptdate = arjncpst->ORDER_date
              PFTYP = arjncpst->Ftyp
              PPMOD = arjncpst->PMOD
              PSOURCE = arjncpst->SOURCE
              
              pttotal = arjncpst->REC_total * -1
              
                    
               if arjncpst->trantype = "Deposit"  && deposit
              select frighter
              replace cdep_amt with cdep_amt + arjncpst->total  && ok
         else
   
                DO DRTRAN_RTN
                endif
  
     
 
 PROCEDURE DRTRAN_RTN
  
 
        pcoy = arjncpst->coy
    pdate = arjncpst->order_date
    pcustno =  arjncpst->frighter_n
    PFTYP = arjncpst->Ftyp
    PPMOD = arjncpst->PMOD
    PSOURCE = arjncpst->SOURCE
    
   pdoc  = ARJNCPST->DOCTYPE
   
    
    DO frshtrn_RTN1
        
             local l1,l2,l3,l4,l5,l6,l7,L8,L9,L0,L10
             l6 = frighter->source
             l7 = frighter->pmod
      l1 = frighter->ftyp
      l2 = frighter->frighter_n
      l3 = pdate
      
      l0 = dtos(l3) && yyyymmdd
      l8 = left(l0,4) && yyyy
      l10 = left(l0,6) && yyyymm
      l9 = right(l10,2) && mm
      
     
      select FRMODEBT
      seek L6+L1+L7+L2+L8+L9
      if .not. found()
      append blank
      replace bbf with FRIGHTER->BAL_DUE
      replace Ftyp with l1
      replace FRIGHTER_n with l2
      replace yy with l8
      replace mm with l9
      REPLACE SOURCE WITH L6
      REPLACE PMOD WITH L7
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     REPLACE BAL_DUE WITH FRIGHTER->BAL_DUE
     endif
     replace bal_due with bal_due - arjncpst->REC_Total
     replace l_pay_amt with arjncpst->REC_total + L_pay_amt
     
      select frddebtp
      seek l6+l1+l7+l2+dtos(l3)
      if .not. found()
      append blank
      replace bal_due with FRIGHTER->BAL_DUE
      replace bbf with bal_due
      replace ftyp with l1
      replace source with l6
      replace pmod with l7
      replace frighter_n with l2
      replace shift_date with l3
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     endif
              replace bal_due with bal_due - arjncpst->REC_total
                  replace l_pay_amt with arjncpst->REC_total + L_pay_amt
                    replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
     select frcustbl
             REPLACE BAL_DUE with   BAL_DUE - arjncpst->REC_TOTAL 
          SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
      REPLACE BAL_DUE with   BAL_DUE - arjncpst->REC_TOTAL 
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
     
     
    DO frshtrn_RTN2
    
PROCEDURE frshtrn_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lpmod,lsource,lmm,lyy,ld
  
      lref = arjncpst->order_no
      ldate = arjncpst->order_date
      tdate = arjncpst->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = 'GL'
      ldoc  = ARJNCPST->DOCTYPE
      lcust = arjncpst->frighter_n
      lftyp = arjncpst->Ftyp
      PFTYP = arjncpst->Ftyp
      lpmod = arjncpst->pmod
      lsource = arjncpst->source
        select frcount
      seek lsource+lftyp+lpmod+LCUST+lyy+lmm
      if .not. found()
      append blank
      replace source with lsource
      replace pmod with lpmod
      replace yy with lyy
      replace mm with lmm
      replace count with "0000"
      REPLACE fTYP WITH LfTYP
      REPLACE frighter_N WITH LCUST
      endif
      
      L1 = VAL(FRCOUNT->COUNT)
      L2 = L1 + 1
      L3 = STR(L2,5)
       select frdocref
     seek lsource+lftyp+lpmod+LCUST+lref
      if .not. found()
      append blank
      replace docref with lref
      replace source with lsource
      replace pmod with lpmod
      replace doctype with ldoc
        REPLACE fTYP WITH lftyp
      REPLACE frighter_N WITH LCUST
      select FRCOUNT
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
       select frshtrn
      seek lsource+lftyp+lpmod+LCUST+lyy+lmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE frighter_N WITH lcust
 replace source with lsource
      replace pmod with lpmod
      replace mm with lmm
      replace yy with lyy
      replace dd with right(dtos(ldate),2)
     REPLACE ftyP WITH lftyp
               replace invoice with 0
                REPLACE PAYMENT WITH 1
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
     REPLACE ftyP WITH lftyp
               REPLACE MILEAGE WITH 0
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with arjncpst->serialno
      replace REG        WITH arjncpst->trantype
       replace sTIME       WITH ltime
        replace LPO        WITH arjncpst->LPO
         replace pay_method with arjncpst->pay_method
         replace recdate with arjncpst->recdate
          replace sdate with ldate
         replace bbf with frighter->bal_due
                if frshtrn->bbf < 0
            replace bbf_cr with frighter->bal_due* -1
            replace bbf_dr with 0
         else
            replace bbf_dr with frighter->bal_due
            replace bbf_cr with 0
         endif
 
         endif
       
 PROCEDURE frshtrn_rtn2
    SELECT frshtrn
    replace bal_due with frighter->bal_due
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->bal_due
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + arjncpst->REC_total * -1
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with arjncpst->order_date
             replace l_pay_amt with arjncpst->REC_total + L_pay_amt
             pdate = frshtrn->trans_date
            
           
 
  
      
  PROCEDURE appymts_rtn   
       
      PTYP = arjncpst->TYP   && nett credited to vendor
      PCLA = arjncpst->CLA
      PCOD = arjncpst->COD
      PCOY = arjncpst->COY
      PDIV = arjncpst->DIV
      PCEN = arjncpst->CEN
      PSTO = arjncpst->STO
      PSHDATE = arjncpst->ORDER_DATE
      PSHNO = '0'
      PSHID = '0'
       PTOTAL1 = arjncpst->SVC_TOTAL + arjncpst->tax_amt  && service charge
 if .not.  arjncpst->trantype = "Deposit"
    PTOTAL = arjncpst->TOTAL && nett
    else
    ptotal = arjncpst->TOTAL * -1
    endif
   pcoy = arjncpst->coy
    pdate = arjncpst->order_date
    pcustno =  arjncpst->VENDOR_n
    Pvtyp = arjncpst->vtyp
    Pvpmod = arjncpst->vpmod
    Pvsrce = arjncpst->vsrce
 
        SELECT VENDOR
           SEEK pvsrce+pvtyp+pvpmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
         
                  
               PERROR = .F.
          
     IF PCUS .and. .not. ptotal1 = 0
        DO fgnfpur_RTN
        endif
        if pcus  .and. .not. ptotal = 0
              
                   DO VNTRAN_RTN
                   ENDIF
                   
      
  Procedure fgnfpur_RTN
        select fgnfpur
          append blank
         replace system with 'GL'
         replace doctype with  arjncpst->DOCTYPE
         replace order_no with porder
         replace order_date with pshdate
          replace inv_date with order_date
          replace stock_no with arjncpst->STOCK_NO
         replace coy with arjncpst->coy
            replace div with arjncpst->div
            replace cen with arjncpst->cen
              replace sto with arjncpst->sto
              replace st_coy with arjncpst->coy
            replace st_div with arjncpst->div
            replace st_cen with arjncpst->cen
              replace st_sto with arjncpst->sto
             replace typ with arjncpst->typ
            replace cla with arjncpst->cla
            replace cod with arjncpst->cod
            replace qty with 0
            replace return_qty with 0
            replace unit_cost with 0
            replace list_price with 0
            replace total with PTOTAL1
             replace tax_rate with arjncpst->tax_rate
            replace tax_amt with arjncpst->tax_amt
             replace job_order with TYP
            replace off with arjncpst->off
            replace gross_amt with arjncpst->SVC_TOTAL
               replace pay_method  with arjncpst->pay_method
             replace lpo with arjncpst->lpo
           REPLACE vsrce WITH arjncpst->vsrce
          REPLACE vtyp WITH arjncpst->vtyp
           REPLACE vpmod WITH arjncpst->vpmod
           REPLACE vendor_N WITH arjncpst->vendor_N
             replace shift_no with '0'
           replace shift_id with '0'
           replace inv_no with arjncpst->serialno
           replace cashier_no with arjncpst->cashier_no
            replace bcoy  with arjncpst->bcoy
           replace bcen  with arjncpst->BCEN
           replace bdiv  with arjncpst->BDIV
           replace bsto  with arjncpst->BSTO
           replace btyp with arjncpst->BTYP
           replace bcla with arjncpst->BCLA
           replace bcod with arjncpst->BCOD
           replace dde_date with date()
           replace dde_user with PLUSER
           replace dde_time with time()
           REPLACE SERIALNO WITH arjncpst->SERIALNO
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
           REPLACE NEW_BAL WITH arjncpst->REC_TOTAL
            REPLACE source WITH arjncpst->source
            REPLACE FTYP WITH arjncpst->FTYP
            REPLACE PMOD WITH arjncpst->PMOD
           REPLACE FRIGHTER_N WITH arjncpst->FRIGHTER_N
           
          
 PROCEDURE VNTRAN_RTN
     
    DO vnstat_RTN1
        
      SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE - PTOTAL 
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
  
      lref = arjncpst->order_no
      ldate = arjncpst->order_date
      tdate = arjncpst->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = 'GL'
      ldoc  = ARJNCPST->DOCTYPE
      lcust = arjncpst->VENDOR_n
      lvtyp = arjncpst->vtyp
      Pvtyp = arjncpst->vtyp
      lvpmod = arjncpst->vpmod
      lvsrce = arjncpst->vsrce
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
                     replace invoice with 0
                  REPLACE PAYMENT WITH 1
                 replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                 replace alloc_AMT with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with arjncpst->serialno
      replace REG        WITH arjncpst->trantype
       replace sTIME       WITH ltime
        replace LPO        WITH arjncpst->lpo
         replace pay_method with arjncpst->pay_method
         replace recdate with arjncpst->order_date
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
    replace total with vnstat->total + PTOTAL * -1
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
   select VENDOR
             replace l_pay_date with arjncpst->order_date
             replace l_pay_amt with PTOTAL + L_pay_amt
            
     
    
      
