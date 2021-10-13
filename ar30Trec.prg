Procedure ar30TREC
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
  *  SET AUTOSAVE ON
    SET VIEW TO "ar30TREC.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
     set reprocess to 10000
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
     eofARTRCPST = .f.
         select ARTRCPST
    set filter to  empty(post_date) .and. order_date = st15f->shift_date .and. shift_no = st15f->shift_no .and. shift_id = st15f->shift_id
              go top
                if .not. eof()
                do
                do lines_rtn
                until  eofARTRCPST
             ENDIF
             SELECT FGCOY
             FLUSH
             SET AUTOSAVE OFF
           set safety off
           select ARTRCPST
           zap
           set safety on
                  close databases
              set safety off
  set safety on
procedure lines_rtn
       begintrans()
      do line_rtn
      do line2_rtn
      select artrcpst
    replace post_date with date()
        commit()   
      skip
      if eof()
        eofARTRCPST = .t.
        endif
procedure line_rtn
   
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
      select ARTRCPST
      if rec_total = 0
      replace rec_total  with total
      endif
           l7 = ARTRCPST->order_no
         l8 = ARTRCPST->order_date
         l9 = ARTRCPST->stock_no
         l10 = ARTRCPST->system
         l11 = ARTRCPST->doctype
          pshno = artrcpst->shift_no
         pshid = artrcpst->shift_id
              pfrighter = ARTRCPST->frighter_N
                        pftyp = ARTRCPST->ftyp
                          pcashrno = ARTRCPST->cashier_no
                          psource = ARTRCPST->source
                          ppmod = ARTRCPST->pmod
                          pcustno = pfrighter
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
          Wait 'ARTRCPST - Problem with customer masterfile in Receipts - Try Again Later!'
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
            replace total with ARTRCPST->TOTAL
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
            replace off with ARTRCPST->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with ARTRCPST->TOTAL  && NETT AMT
            replace dsc  WITH 0
            replace cashier_no with ARTRCPST->cashier_no
            replace TRANtype with ARTRCPST->trantype
            replace pay_method  with ARTRCPST->pay_method
            REPLACE source WITH ARTRCPST->source
            REPLACE FTYP WITH ARTRCPST->FTYP
            REPLACE PMOD WITH ARTRCPST->PMOD
           REPLACE FRIGHTER_N WITH ARTRCPST->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
           replace coy  with ARTRCPST->coy  && DEBTORS CONTROL - DEBITED
           replace typ  with ARTRCPST->typ
           replace cla  with ARTRCPST->cla
           replace cod  with ARTRCPST->cod
            replace sto  with ARTRCPST->sto
             replace div  with ARTRCPST->div
              replace cen  with ARTRCPST->cen
              *
               replace bcoy  with ARTRCPST->coy  && DEBTORS CONTROL - DEBITED
           replace btyp  with ARTRCPST->typ
           replace bcla  with ARTRCPST->cla
           replace bcod  with ARTRCPST->cod
            replace bsto  with ARTRCPST->sto
             replace bdiv  with ARTRCPST->div
              replace bcen  with ARTRCPST->cen
              *
              replace recdate with ARTRCPST->recdate
              replace lpo with ARTRCPST->lpo
              replace reg with artrcpst->reg
              replace card_no with artrcpst->card_no
           replace serialno with ARTRCPST->serialno
           REPLACE SHIFT_NO WITH ARTRCPST->SHIFT_NO
           REPLACE SHIFT_ID WITH ARTRCPST->SHIFT_id
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
        
    
       ptyp = ARTRCPST->TYP
      pcla = ARTRCPST->CLA
      pcod = ARTRCPST->COD
      pcoy = ARTRCPST->COY
      pdiv = ARTRCPST->DIV
      pcen = ARTRCPST->CEN
      psto = ARTRCPST->STO
       porder = ARTRCPST->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PARTRCPST = .F.
          select ARTRCPST
                 pcustno = ARTRCPST->frighter_N
                  pftyp = FTYP
                        psource = SOURCE
                       ppmod = PMOD              
                    pcashrno = ARTRCPST->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PARTRCPST = .T.
      pfrighter = ARTRCPST->frighter_N
               porder = ARTRCPST->order_no
                        pftyp = ARTRCPST->ftyp
                          pcashrno = ARTRCPST->cashier_no
                          psource = ARTRCPST->source
                          ppmod = ARTRCPST->pmod
                    
  
   
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
        
                  
               PERROR = .F.
          
     IF EMPTY(ARTRCPST->POST_DATE)  .AND. PCUS
    DO ARTRCPST_RTN2
      
        ENDIF

           
  PROCEDURE ARTRCPST_RTN2
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
              D1 = DTOS(ARTRCPST->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
                 PTVAT = 0
              PCOY = ARTRCPST->COY
              PDIV = ARTRCPST->DIV
              PCEN = ARTRCPST->CEN
              PTYP = ARTRCPST->TYP
              PSTO = ARTRCPST->STO
              PCLA = ARTRCPST->CLA
              PCOD = ARTRCPST->COD
       PFTYP = ARTRCPST->Ftyp
       PPMOD = ARTRCPST->PMOD
       PSOURCE = ARTRCPST->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = ARTRCPST->rec_TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
         pcash = .F.
         pcredit = .T.
           Pcheque = .F.
         
              PFTYP = ARTRCPST->Ftyp
              PPMOD = ARTRCPST->PMOD
              PSOURCE = ARTRCPST->SOURCE
              
                
                DO DRTRAN_RTN  && CREDIT
       
                        
 PROCEDURE DRTRAN_RTN
  
 
        pcoy = ARTRCPST->coy
    pdate = ARTRCPST->order_date
    pcustno =  ARTRCPST->frighter_n
    PFTYP = ARTRCPST->Ftyp
    PPMOD = ARTRCPST->PMOD
    PSOURCE = ARTRCPST->SOURCE
    
    pdoc = ARTRCPST->doctype
    
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
     replace bal_due with bal_due - ARTRCPST->rec_total
     replace l_pay_amt with ARTRCPST->rec_total + L_pay_amt
     
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
              replace bal_due with bal_due - ARTRCPST->rec_total
                  replace l_pay_amt with ARTRCPST->rec_total + L_pay_amt
                   replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
      SELECT frighter
      SEEK psource+pftyp+ppmod+pcustno
      REPLACE BAL_DUE with   BAL_DUE - ARTRCPST->rec_total 
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
     select frcustbl
     REPLACE BAL_DUE with   BAL_DUE - ARTRCPST->rec_total 
     
    DO frshtrn_RTN2
    
PROCEDURE frshtrn_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lpmod,lsource,lmm,lyy,ld
  
      lref = ARTRCPST->order_no
      ldate = ARTRCPST->order_date
      tdate = ARTRCPST->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = ARTRCPST->system
      ldoc = ARTRCPST->doctype
      lcust = ARTRCPST->frighter_n
      lftyp = ARTRCPST->Ftyp
      PFTYP = ARTRCPST->Ftyp
      lpmod = ARTRCPST->pmod
      lsource = ARTRCPST->source
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
               replace invoice with 1
                REPLACE PAYMENT WITH 0
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
          REPLACE ftyP WITH lftyp
               REPLACE MILEAGE WITH 0
               replace invoice with 1
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with ARTRCPST->serialno
      replace REG        WITH ARTRCPST->reg
      replace card_no with artrcpst->card_no
       replace sTIME       WITH ltime
        replace LPO        WITH ARTRCPST->card_no
         replace pay_method with ARTRCPST->pay_method
         replace recdate with ARTRCPST->recdate
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
    replace total with frshtrn->total + ARTRCPST->rec_total * -1
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with ARTRCPST->order_date
             replace l_pay_amt with ARTRCPST->rec_total + L_pay_amt
             pdate = frshtrn->trans_date
             
             
  procedure line2_rtn
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
      select ARTRCPST
      replace rec_total  with total
         l7 = ARTRCPST->order_no
         l8 = ARTRCPST->order_date
         l9 = ARTRCPST->stock_no
         l10 = ARTRCPST->system
         l11 = ARTRCPST->doctype
          pshno = artrcpst->shift_no
         pshid = artrcpst->shift_id
              pfrighter = ARTRCPST->dfrighter
                        pftyp = ARTRCPST->dftyp
                          pcashrno = ARTRCPST->cashier_no
                          psource = ARTRCPST->dsource
                          ppmod = ARTRCPST->dpmod
                          pcustno = pfrighter
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
          Wait 'ARTRCPST - Problem with customer masterfile in Receipts 2 - Try Again Later!'
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
         replace stock_no with '02'
         replace actype  with "4"  && CURRENT ASSETS
            replace qty with 0
            replace unit_cost with 0
            replace new_bal with 0
            replace total with ARTRCPST->TOTAL * -1
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
            replace off with ARTRCPST->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with ARTRCPST->TOTAL * -1 && NETT AMT
            replace dsc  WITH 0
            replace cashier_no with ARTRCPST->cashier_no
            replace TRANtype with ARTRCPST->trantype
            replace REG        WITH ARTRCPST->reg
            replace card_no with artrcpst->card_no
            replace pay_method  with ARTRCPST->pay_method
            REPLACE source WITH ARTRCPST->dsource
            REPLACE FTYP WITH ARTRCPST->dFtyp
            REPLACE PMOD WITH ARTRCPST->dpmod
           REPLACE FRIGHTER_N WITH ARTRCPST->dfrighter
           replace shift_no with pshno
           replace shift_id with pshid
           replace coy  with ARTRCPST->dcoy  && DEBTORS CONTROL - DEBITED
           replace typ  with ARTRCPST->dtyp
           replace cla  with ARTRCPST->dcla
           replace cod  with ARTRCPST->dcod
            replace sto  with ARTRCPST->dsto
             replace div  with ARTRCPST->ddiv
              replace cen  with ARTRCPST->dcen
              replace recdate with ARTRCPST->recdate
              replace lpo with ARTRCPST->lpo
           replace serialno with ARTRCPST->serialno
           REPLACE SHIFT_NO WITH ARTRCPST->SHIFT_NO
           REPLACE SHIFT_ID WITH ARTRCPST->SHIFT_id
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
      ptyp = ARTRCPST->dtyp
      pcla = ARTRCPST->dcla
      pcod = ARTRCPST->dcod
      pcoy = ARTRCPST->dcoy
      pdiv = ARTRCPST->ddiv
      pcen = ARTRCPST->dcen
      psto = ARTRCPST->dsto
       porder = ARTRCPST->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PARTRCPST = .F.
          select ARTRCPST
                 pcustno = ARTRCPST->dfrighter
                  pftyp = FTYP
                        psource = SOURCE
                       ppmod = PMOD              
                    pcashrno = ARTRCPST->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PARTRCPST = .T.
      pfrighter = ARTRCPST->dfrighter
               porder = ARTRCPST->order_no
                        pftyp = ARTRCPST->dFtyp
                          pcashrno = ARTRCPST->cashier_no
                          psource = ARTRCPST->dsource
                          ppmod = ARTRCPST->dpmod
                    
  
   
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
        
                  
               PERROR = .F.
          
   
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
              D1 = DTOS(ARTRCPST->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
                 PTVAT = 0
              PCOY = ARTRCPST->dcoy
              PDIV = ARTRCPST->ddiv
              PCEN = ARTRCPST->dcen
              PTYP = ARTRCPST->dtyp
              PSTO = ARTRCPST->dsto
              PCLA = ARTRCPST->dcla
              PCOD = ARTRCPST->dcod
       PFTYP = ARTRCPST->dFtyp
       PPMOD = ARTRCPST->dpmod
       PSOURCE = ARTRCPST->dsource
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
         pcash = .F.
         pcredit = .T.
           Pcheque = .F.
         
              PFTYP = ARTRCPST->dFtyp
              PPMOD = ARTRCPST->dpmod
              PSOURCE = ARTRCPST->dsource
  
        pcoy = ARTRCPST->dcoy
    pdate = ARTRCPST->order_date
    pcustno =  ARTRCPST->dfrighter
    PFTYP = ARTRCPST->dFtyp
    PPMOD = ARTRCPST->dpmod
    PSOURCE = ARTRCPST->dsource
    
    pdoc = ARTRCPST->doctype
    
    DO frshtrn2_RTN1
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
     replace bal_due with bal_due - ARTRCPST->rec_total*-1
     replace l_pay_amt with ARTRCPST->rec_total*-1 + L_pay_amt
     
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
              replace bal_due with bal_due - ARTRCPST->rec_total*-1
                  replace l_pay_amt with ARTRCPST->rec_total*-1 + L_pay_amt
                   replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
      SELECT frighter
      SEEK psource+pftyp+ppmod+pcustno
      REPLACE BAL_DUE with   BAL_DUE - ARTRCPST->rec_total*-1 
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
     select frcustbl
     REPLACE BAL_DUE with   BAL_DUE - ARTRCPST->rec_total*-1
     
    DO frshtrn2_RTN2
    
PROCEDURE frshtrn2_RTN1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lpmod,lsource,lmm,lyy,ld
  
      lref = ARTRCPST->order_no
      ldate = ARTRCPST->order_date
      tdate = ARTRCPST->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = ARTRCPST->system
      ldoc = ARTRCPST->doctype
      lcust = ARTRCPST->dfrighter
      lftyp = ARTRCPST->dFtyp
      PFTYP = ARTRCPST->dFtyp
      lpmod = ARTRCPST->dpmod
      lsource = ARTRCPST->dsource
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
               replace invoice with 1
                REPLACE PAYMENT WITH 0
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
          REPLACE ftyP WITH lftyp
               REPLACE MILEAGE WITH 0
               replace invoice with 1
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with ARTRCPST->serialno
       replace REG        WITH ARTRCPST->reg
      replace card_no with artrcpst->card_no
       replace sTIME       WITH ltime
        replace LPO        WITH ARTRCPST->card_no
         replace pay_method with ARTRCPST->pay_method
         replace recdate with ARTRCPST->recdate
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
       
 PROCEDURE frshtrn2_RTN2
    SELECT frshtrn
    replace bal_due with frighter->bal_due
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->bal_due
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + ARTRCPST->rec_total
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with ARTRCPST->order_date
             replace l_pay_amt with ARTRCPST->rec_total*-1 + L_pay_amt
