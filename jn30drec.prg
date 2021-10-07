Procedure jn30DREC
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
  *  SET AUTOSAVE ON
    SET VIEW TO "jn30DREC.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
     set reprocess to 10000
SElect vendor
set order to vendor
select vncount
set order to mkey
select vnstat
set order to mkey
SET SAFETY OFF
select vndocref
set order to docref
SET SAFETY ON
select frighter
set order to frighter
select frmodebt
set order to mkey
SET SAFETY OFF
select frddebtp
set order to mkey
select frcount
set order to mkey
select frdocref
set order to docref
select frshtrn
set order to mkey
SET SAFETY ON
  
  PRIVATE PPOSTED
  PPOSTED = .T.
  ? "passed"
     eofJNDRCPST = .f.
         select JNDRCPST
    set filter to  empty(post_date) 
              go top
                if .not. eof()
                do
                do line_rtn
                until eofJNDRCPST
             ENDIF
             SELECT FGCOY
             FLUSH
             SET AUTOSAVE OFF
           set safety off
           select JNDRCPST
           zap
           set safety on
           close databases
            
     
procedure line_rtn
  PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,PJNDRCPST,pstt,p20,ptsdate
  
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
      select JNDRCPST
      if rec_total = 0
      replace rec_total  with total
      endif
               lerr = .f.
                if .not. lerr   
           l7 = JNDRCPST->order_no
         l8 = JNDRCPST->order_date
         l9 = JNDRCPST->stock_no
         l10 = JNDRCPST->system
         l11 = JNDRCPST->doctype
         if empty(l8)
         l8 = JNDRCPST->order_date
         endif
       pshno = "0"
         pshid = "0"
             pfrighter = JNDRCPST->frighter_N
                        pftyp = JNDRCPST->ftyp
                          pcashrno = JNDRCPST->cashier_no
                          psource = JNDRCPST->source
                          ppmod = JNDRCPST->pmod
                          pcustno = pfrighter
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
          Wait 'JNDRCPST - Problem with customer masterfile in Receipts - Try Again Later!'
           quit
        ENDIF
        select fgcods
        seek  JNDRCPST->btyp+ JNDRCPST->bcla+ JNDRCPST->bcod
        if .not. found()
         Wait 'JNDRCPST - Problem with prouct line file in Receipts - Try Again Later!'
           quit
        endif
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
            replace total with JNDRCPST->rec_total && total receipts
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with 0
            replace disc_rate with JNDRCPST->tax_RATE
            replace tax_amt with JNDRCPST->tax_amt 
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with JNDRCPST->off
 *           REPLACE INV_NO WITH JNDRCPST->END_REC
            replace inv_py_amt with 0
            replace gross_amt with JNDRCPST->SVC_TOTAL
            REPLACE ST_STO with JNDRCPST->SVCTYP
            REPLACE OTOWN with JNDRCPST->SVCCLA
            REPLACE DTOWN with JNDRCPST->SVCCOD
            replace basic_amt with JNDRCPST->TOTAL  && NETT AMT
            replace dsc  WITH 0
            replace TRANtype with JNDRCPST->trantype
            replace pay_method  with JNDRCPST->pay_method
            REPLACE source WITH JNDRCPST->source
            REPLACE FTYP WITH JNDRCPST->FTYP
            REPLACE PMOD WITH JNDRCPST->PMOD
           REPLACE FRIGHTER_N WITH JNDRCPST->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
           if .not. empty(JNDRCPST->btyp)
           replace Bcoy  with JNDRCPST->bcoy  && CREDITORS CONTROL VENDOR IS SELECTED
           replace Btyp  with JNDRCPST->btyp
           replace Bcla  with JNDRCPST->bcla
           replace Bcod  with JNDRCPST->bcod
            replace Bsto  with JNDRCPST->bsto
             replace Bdiv  with JNDRCPST->bdiv
              replace Bcen  with JNDRCPST->bcen
              else
           replace Bcoy  with JNDRCPST->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with JNDRCPST->typ
           replace Bcla  with JNDRCPST->cla
           replace Bcod  with JNDRCPST->cod
            replace Bsto  with JNDRCPST->sto
             replace Bdiv  with JNDRCPST->div
              replace Bcen  with JNDRCPST->cen
      ENDIF
           replace coy  with JNDRCPST->coy  && DEBTORS CONTROL - DEBITED
           replace typ  with JNDRCPST->typ
           replace cla  with JNDRCPST->cla
           replace cod  with JNDRCPST->cod
            replace sto  with JNDRCPST->sto
             replace div  with JNDRCPST->div
              replace cen  with JNDRCPST->cen
                 if trantype = "Deposit"
                replace coy  with "1" && creditors CONTROL - DEBITED
           replace typ  with "L0"
           replace cla  with "00"
           replace cod  with "00"
            replace sto  with "A1"
             replace div  with "5"
              replace cen  with "1"
             replace Bcoy  with JNDRCPST->coy  &&  OTHER GL A/C- credit, VENDOR IS SELECTED
           replace Btyp  with JNDRCPST->typ
           replace Bcla  with JNDRCPST->cla
           replace Bcod  with JNDRCPST->cod
            replace Bsto  with JNDRCPST->sto
             replace Bdiv  with JNDRCPST->div
              replace Bcen  with JNDRCPST->cen
endif
           
              replace vsrce with JNDRCPST->vsrce
      replace vpmod with JNDRCPST->vpmod
      replace vtyp with JNDRCPST->vtyp
      replace vendor_n with JNDRCPST->vendor_n
 
              replace recdate with JNDRCPST->recdate
              replace lpo with JNDRCPST->LPO
           REPLACE SHIFT_NO WITH '0'
           REPLACE SHIFT_ID WITH '0'
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
        
    
              
    
        DO JNDRCPST_RTN1
        ENDIF
        commit()
        
        
   SELECT JNDRCPST
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofJNDRCPST = .t.
   endif
  
  
 PROCEDURE JNDRCPST_RTN1
            local lld1,lld2
              ptsdate = JNDRCPST->ORDER_DATE
            SELECT FGCOY
            GO TOP
      pshdate = JNDRCPST->order_date
     pshno = "0"
    pshid = "0"
   * pterror = .f.  
      ptyp = JNDRCPST->TYP
      pcla = JNDRCPST->CLA
      pcod = JNDRCPST->COD
      pcoy = JNDRCPST->COY
      pdiv = JNDRCPST->DIV
      pcen = JNDRCPST->CEN
      psto = JNDRCPST->STO
       porder = JNDRCPST->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PJNDRCPST = .F.
          select JNDRCPST
                 pcustno = JNDRCPST->frighter_N
                  pftyp = FTYP
                        psource = SOURCE
                       ppmod = PMOD              
                    pcashrno = JNDRCPST->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PJNDRCPST = .T.
      pfrighter = JNDRCPST->frighter_N
               porder = JNDRCPST->order_no
                        pftyp = JNDRCPST->ftyp
                          pcashrno = JNDRCPST->cashier_no
                          psource = JNDRCPST->source
                          ppmod = JNDRCPST->pmod
                    
  
   
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
        
                  
               PERROR = .F.
          
     IF EMPTY(JNDRCPST->POST_DATE)  .AND. PCUS
    DO JNDRCPST_RTN2
      
    select JNDRCPST
    replace post_date with date()
       ENDIF

           
  PROCEDURE JNDRCPST_RTN2
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
              D1 = DTOS(JNDRCPST->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = JNDRCPST->rec_TOTAL * -1
                 PTVAT = 0
              PCOY = JNDRCPST->COY
              PDIV = JNDRCPST->DIV
              PCEN = JNDRCPST->CEN
              PTYP = JNDRCPST->TYP
              PSTO = JNDRCPST->STO
              PCLA = JNDRCPST->CLA
              PCOD = JNDRCPST->COD
       PFTYP = JNDRCPST->Ftyp
       PPMOD = JNDRCPST->PMOD
       PSOURCE = JNDRCPST->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = JNDRCPST->rec_TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
     if JNDRCPST->PAY_METHOD= "Cash"  .or.  (JNDRCPST->PAY_METHOD= "Debitnote" .and. JNDRCPST->system = 'SB')
        pcash = .T.
        else
        pcash = .F.
     endif
         pcredit = .F.
        if JNDRCPST->PAY_METHOD= "Cheque" .or. JNDRCPST->PAY_METHOD= "Directcredit";
        .or. JNDRCPST->pay_method ="Directdepsit"  .or. JNDRCPST->pay_method ="M-Money"
        pcheque = .T.
        else
        Pcheque = .F.
     endif
        if .not. pcash .and. .not. pcredit .and. .not. pcheque
        pother = .T.
        endif
        if pother
        pcredit = .t.
        pother = .f.
        endif
 
           ptdate = JNDRCPST->ORDER_date
              PFTYP = JNDRCPST->Ftyp
              PPMOD = JNDRCPST->PMOD
              PSOURCE = JNDRCPST->SOURCE
              
              pttotal = JNDRCPST->rec_total * -1
              
              
               if JNDRCPST->trantype = "Deposit"  && deposit
              select frighter
              SEEK psource+pftyp+ppmod+pcustno
              replace cdep_amt with cdep_amt + JNDRCPST->rec_total
              else
          IF  fgtran->TYP = "C0" .AND. fgtran->CLA = "10"  && DEBTORS CONTROL
                DO DRTRAN_RTN
          endif
     IF  fgtran->TYP >= "00" .AND. fgtran->typ <= "9Z"  .and. JNDRCPST->trantype  = 'Income' && income
                DO INCOME_RTN
          endif
          endif
                         
          IF  fgtran->TYP = "L0" && creditors control
                              
                          pvsrce = JNDRCPST->vsrce
                          pvpmod = JNDRCPST->vpmod
                           pvtyp = JNDRCPST->vtyp
                               pvendor = JNDRCPST->vendor_N
         SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
                DO vntran_rtn
                   endif
                 endif
       
PROCEDURE INCOME_RTN
PCOY = FGTRAN->COY
PDIV = FGTRAN->DIv
pcen = FGTRAN->cen
ptyp = FGTRAN->typ
pcla = FGTRAN->cla
pcod = FGTRAN->cod
pshdate = FGTRAN->order_date
pshno = FGTRAN->shift_no
pshid = FGTRAN->shift_id
  
 PROCEDURE DRTRAN_RTN
  
 
        pcoy = JNDRCPST->coy
    pdate = JNDRCPST->order_date
    pcustno =  JNDRCPST->frighter_n
    PFTYP = JNDRCPST->Ftyp
    PPMOD = JNDRCPST->PMOD
    PSOURCE = JNDRCPST->SOURCE
    
    pdoc = JNDRCPST->doctype
    
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
     replace bal_due with bal_due - JNDRCPST->rec_total
     replace l_pay_amt with JNDRCPST->rec_total + L_pay_amt
     
      select frddebtp
      seek l6+l1+l7+l2+dtos(l3)
      if .not. found()
      append blank
      replace bal_due with FRIGHTER->BAL_DUE
      replace bbf with FRIGHTER->BAL_DUE
      replace ftyp with l1
      replace source with l6
      replace pmod with l7
      replace frighter_n with l2
      replace shift_date with l3
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     endif
              replace bal_due with bal_due - JNDRCPST->rec_total
                  replace l_pay_amt with JNDRCPST->rec_total + L_pay_amt
                   replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
      SELECT frighter
      SEEK psource+pftyp+ppmod+pcustno
      REPLACE BAL_DUE with   BAL_DUE - JNDRCPST->rec_total 
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
     select frcustbl
     REPLACE BAL_DUE with   BAL_DUE - JNDRCPST->rec_total 
     
    DO frshtrn_RTN2
    
PROCEDURE frshtrn_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lpmod,lsource,lmm,lyy,ld
  
      lref = JNDRCPST->order_no
      ldate = JNDRCPST->order_date
      tdate = JNDRCPST->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = JNDRCPST->system
      ldoc = JNDRCPST->doctype
      lcust = JNDRCPST->frighter_n
      lftyp = JNDRCPST->Ftyp
      PFTYP = JNDRCPST->Ftyp
      lpmod = JNDRCPST->pmod
      lsource = JNDRCPST->source
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
               REPLACE MILEAGE WITH 0
               replace invoice with 0
                REPLACE PAYMENT WITH 1
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
          REPLACE ftyP WITH lftyp
               REPLACE MILEAGE WITH 0
               replace invoice with 0
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with JNDRCPST->serialno
      replace REG        WITH JNDRCPST->trantype
       replace sTIME       WITH ltime
        replace LPO        WITH JNDRCPST->lpo
         replace pay_method with JNDRCPST->pay_method
         replace recdate with JNDRCPST->order_date
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
    replace total with frshtrn->total + JNDRCPST->rec_total * -1
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with JNDRCPST->order_date
             replace l_pay_amt with JNDRCPST->rec_total + L_pay_amt
             pdate = frshtrn->trans_date
  
 PROCEDURE vntran_rtn
  
       pdate = JNDRCPST->order_date
       pventno = pvendor
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
       DO vnstat_3018RTN1
          SELECT vendor
      REPLACE vendor->BAL_DUE with  JNDRCPST->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
             replace l_inv_date with JNDRCPST->order_date
             replace l_inv_amt with JNDRCPST->total   + l_inv_amt
    
             
 
    DO vnstat_3018RTN2
    
   
   
            
        
PROCEDURE vnstat_3018RTN1
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = JNDRCPST->order_no
      ldate = JNDRCPST->order_date
      tdate = JNDRCPST->order_date
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = JNDRCPST->system
      ldoc = JNDRCPST->doctype
      lvend = pvendor
      lvtyp = pvtyp
       select vncount
      seek lvsrce+lvtyp+lvpmod+lvend+pyy+pmm
      if .not. found()
      append blank
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace yy with pyy
      replace mm with pmm
      replace count with "0"
      REPLACE vtyp WITH Lvtyp
      REPLACE vendor_N WITH lvend
      endif
      L1 = VAL(vncount->COUNT)
      L2 = L1 + 1
      L3 = STR(L2,5)
       select vndocref
     seek lvsrce+lvtyp+lvpmod+lvend+lref
      if .not. found()
      append blank
      replace docref with lref
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace doctype with ldoc
        REPLACE vtyp WITH lvtyp
      REPLACE vendor_N WITH lvend
      select vncount
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
      **
       select vnstat
      seek lvsrce+lvtyp+lvpmod+lvend+pyy+pmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE vendor_N WITH lvend
      replace vsrce with lvsrce
      replace vpmod with lvpmod
      replace mm with pmm
      replace yy with pyy
      replace dd with right(dtos(ldate),2)
      
           REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
             replace bl_dr with 0
             replace bl_cr with 0
              REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
    
         REPLACE vtyp WITH lvtyp
               REPLACE MILEAGE WITH 0
               replace invoice with 1
               REPLACE PAYMENT WITH 0
             replace bl_dr with 0
             replace bl_cr with 0
             REPLACE AL_AMT WITH 0
             REPLACE BL_AMT WITH 0
          
      REPLACE vnstat->SYSTEM     WITH lsys
      REPLACE vnstat->DOCTYPE    WITH ldoc
      REPLACE vnstat->DOCREF     WITH lref
      REPLACE vnstat->TRANS_DATE WITH tdate
      replace vnstat->serialno with JNDRCPST->serialno
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH JNDRCPST->lpo
        replace reg with JNDRCPST->trantype
        replace recdate with JNDRCPST->order_date
         replace vnstat->pay_method with JNDRCPST->pay_method
            replace vnstat->alloc_AMT with 0
         replace vnstat->sdate with ldate
         replace vnstat->bbf with vendor->bal_due
                if vnstat->bbf < 0
            replace vnstat->bbf_cr with vendor->bal_due* -1
            replace vnstat->bbf_dr with 0
         else
            replace vnstat->bbf_dr with vendor->bal_due
            replace vnstat->bbf_cr with 0
         endif
    replace bal_this with 0
    replace bal_15   with 0
    replace bal_30   with 0
    replace bal_60   with 0
    replace bal_90   with 0
    replace bal_120  with 0
    replace off with JNDRCPST->off
    replace inv_py_amt with 0
       replace vnstat->total with 0
        replace vnstat->amt_dr with 0
          replace vnstat->amt_cr with 0
          replace gratax_amt with 0
          replace gra_total with 0
          replace gra_gross with 0
          replace gra_cost with 0
       endif
      **
     
   PROCEDURE vnstat_3018RTN2
    SELECT vnstat
    replace vnstat->bal_due with vendor->BAL_DUE
   if vnstat->bal_due < 0
         replace vnstat->bal_due_cr with vendor->BAL_DUE* -1
         replace vnstat->bal_due_dr with 0
         else
         replace vnstat->bal_due_dr with vendor->BAL_DUE
         replace vnstat->bal_due_cr with 0
         endif
    replace vnstat->total with vnstat->total + JNDRCPST->total 
    if vnstat->total < 0
         replace vnstat->amt_cr with vnstat->total* -1
         replace vnstat->amt_dr with 0
    else
         replace vnstat->amt_dr with vnstat->total
         replace vnstat->amt_cr with 0
      endif
    
    REPLACE BL_AMT WITH TOTAL
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
    
