Procedure ar30DREC
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
  *  SET AUTOSAVE ON
    SET VIEW TO "ar30DREC.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
     set reprocess to 10000
SELECT SHCATSUM
SET ORDER TO MKEY
SELECT CASHIERS
SET ORDER TO CASHIER
SELECT ST15F
SET ORDER TO MKEY
SELECT SCASHREC
SET ORDER TO MKEY
select vendor
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
     eofARDRCPST = .f.
         select ARDRCPST
    set filter to  empty(post_date) 
              go top
                if .not. eof()
                do
                do line_rtn
                until eofARDRCPST
             ENDIF
             SELECT FGCOY
             FLUSH
             SET AUTOSAVE OFF
           set safety off
           select ARDRCPST
           zap
           set safety on
           close databases
               use \kenservice\data\vendor.dbf
              go top
              if .not. eof()
              close databases
              use \kenservice\data\vendors.dbf exclusive
              set safety off
              zap
              appe from \kenservice\data\vendor.dbf
              endif
              close databases
              set safety off
            use \kenserve\idssys\frshtrn.dbf
            copy stru to \kenservice\data\frshtrns dbase prod
            close databases
            use  \kenservice\data\frshtrns.dbf
            appe from \kenservice\data\frshtrn.dbf
            close databases
  set safety on
procedure line_rtn
  PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,PARDRCPST,pstt,p20,ptsdate
  
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
      select ARDRCPST
      if rec_total = 0
      replace rec_total  with total
      endif
               lerr = .f.
                if .not. lerr   
           l7 = ARDRCPST->order_no
         l8 = ARDRCPST->order_date
         l9 = ARDRCPST->stock_no
         l10 = ARDRCPST->system
         l11 = ARDRCPST->doctype
         if empty(l8)
         l8 = ARDRCPST->order_date
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
            pfrighter = ARDRCPST->frighter_N
                        pftyp = ARDRCPST->ftyp
                          pcashrno = ARDRCPST->cashier_no
                          psource = ARDRCPST->source
                          ppmod = ARDRCPST->pmod
                          pcustno = pfrighter
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
          Wait 'ARDRCPST - Problem with customer masterfile in Receipts - Try Again Later!'
           quit
        ENDIF
        select fgcods
        seek  ARDRCPST->btyp+ ARDRCPST->bcla+ ARDRCPST->bcod
        if .not. found()
         Wait 'ARDRCPST - Problem with prouct line file in Receipts - Try Again Later!'
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
            replace total with ARDRCPST->rec_total
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with ARDRCPST->tax_rate
            replace disc_rate with 0
            replace tax_amt with ARDRCPST->tax_amt
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with ARDRCPST->off
            replace inv_py_amt with 0
            replace gross_amt with ARDRCPST->SVC_TOTAL
            replace basic_amt with ARDRCPST->TOTAL  && NETT AMT
            if total = 0
            replace total  with basic_amt
            endif
            replace dsc  WITH 0
            replace cashier_no with ARDRCPST->cashier_no
            replace TRANtype with ARDRCPST->trantype
            replace pay_method  with ARDRCPST->pay_method
            REPLACE source WITH ARDRCPST->source
            REPLACE FTYP WITH ARDRCPST->FTYP
            REPLACE PMOD WITH ARDRCPST->PMOD
           REPLACE FRIGHTER_N WITH ARDRCPST->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
         *   if .not. empty(ARDRCPST->btyp)
           replace Bcoy  with ARDRCPST->bcoy  && CREDITORS CONTROL VENDOR IS SELECTED
           replace Btyp  with ARDRCPST->btyp
           replace Bcla  with ARDRCPST->bcla
           replace Bcod  with ARDRCPST->bcod
            replace Bsto  with ARDRCPST->bsto
             replace Bdiv  with ARDRCPST->bdiv
              replace Bcen  with ARDRCPST->bcen
         *     else
         *  replace Bcoy  with ARDRCPST->svccoy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace st_sto  with ARDRCPST->svctyp
           replace otown  with ARDRCPST->svccla
           replace dtown  with ARDRCPST->svccod
          *  replace Bsto  with ARDRCPST->svcsto
           *  replace Bdiv  with ARDRCPST->svcdiv
           *   replace Bcen  with ARDRCPST->svccen
    *  ENDIF
           replace coy  with ARDRCPST->coy  && DEBTORS CONTROL - DEBITED
           replace typ  with ARDRCPST->typ
           replace cla  with ARDRCPST->cla
           replace cod  with ARDRCPST->cod
            replace sto  with ARDRCPST->sto
             replace div  with ARDRCPST->div
              replace cen  with ARDRCPST->cen
             REPLACE vsrce WITH ARDRCPST->vsrce
            REPLACE vTYP WITH ARDRCPST->vtyp
            REPLACE vPMOD WITH ARDRCPST->vpmod
           REPLACE vendor_N WITH ARDRCPST->vendor_n
              replace recdate with ARDRCPST->recdate
              replace lpo with ARDRCPST->lpo
           replace serialno with ARDRCPST->serialno
           REPLACE SHIFT_NO WITH ARDRCPST->SHIFT_NO
           REPLACE SHIFT_ID WITH ARDRCPST->SHIFT_id
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
        
    
              
    
        DO ARDRCPST_RTN1
        ENDIF
        commit()
        
        
   SELECT ARDRCPST
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofARDRCPST = .t.
   endif
  
  
 PROCEDURE ARDRCPST_RTN1
            local lld1,lld2
              ptsdate = ARDRCPST->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = ARDRCPST->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = ARDRCPST->TYP
      pcla = ARDRCPST->CLA
      pcod = ARDRCPST->COD
      pcoy = ARDRCPST->COY
      pdiv = ARDRCPST->DIV
      pcen = ARDRCPST->CEN
      psto = ARDRCPST->STO
       porder = ARDRCPST->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PARDRCPST = .F.
          select ARDRCPST
                 pcustno = ARDRCPST->frighter_N
                  pftyp = FTYP
                        psource = SOURCE
                       ppmod = PMOD              
                    pcashrno = ARDRCPST->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PARDRCPST = .T.
      pfrighter = ARDRCPST->frighter_N
               porder = ARDRCPST->order_no
                        pftyp = ARDRCPST->ftyp
                          pcashrno = ARDRCPST->cashier_no
                          psource = ARDRCPST->source
                          ppmod = ARDRCPST->pmod
                    
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
 replace off with ARDRCPST->off
   endif
  
   IF EMPTY(OFF)
    replace off with ARDRCPST->off
    ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
   
        SELECT frighter
           SEEK psource+pftyp+ppmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
        
                  
               PERROR = .F.
          
     IF EMPTY(ARDRCPST->POST_DATE)  .AND. PCUS
    DO ARDRCPST_RTN2
      
    select ARDRCPST
    replace post_date with date()
       ENDIF

           
  PROCEDURE ARDRCPST_RTN2
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
              D1 = DTOS(ARDRCPST->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = ARDRCPST->rec_TOTAL * -1
                 PTVAT = 0
              PCOY = ARDRCPST->COY
              PDIV = ARDRCPST->DIV
              PCEN = ARDRCPST->CEN
              PTYP = ARDRCPST->TYP
              PSTO = ARDRCPST->STO
              PCLA = ARDRCPST->CLA
              PCOD = ARDRCPST->COD
       PFTYP = ARDRCPST->Ftyp
       PPMOD = ARDRCPST->PMOD
       PSOURCE = ARDRCPST->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = ARDRCPST->rec_TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
     if ARDRCPST->PAY_METHOD= "Cash"  .or.  (ARDRCPST->PAY_METHOD= "Debitnote" .and. ARDRCPST->system = 'SB')
        pcash = .T.
        else
        pcash = .F.
     endif
         pcredit = .F.
        if ARDRCPST->PAY_METHOD= "Cheque" .or. ARDRCPST->PAY_METHOD= "Directcredit";
        .or. ARDRCPST->pay_method ="Directdepsit"  .or. ARDRCPST->pay_method ="M-Money"
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
 
           ptdate = ARDRCPST->ORDER_date
              PFTYP = ARDRCPST->Ftyp
              PPMOD = ARDRCPST->PMOD
              PSOURCE = ARDRCPST->SOURCE
              
              pttotal = ARDRCPST->rec_total * -1
              
              
               if ARDRCPST->trantype = "Deposit"  && deposit
              select frighter
              SEEK psource+pftyp+ppmod+pcustno
              replace cdep_amt with cdep_amt + ARDRCPST->rec_total
              else
          IF  fgtran->TYP = "C0" .AND. fgtran->CLA = "10"  && DEBTORS CONTROL
                DO DRTRAN_RTN
          endif
     IF  fgtran->TYP >= "00" .AND. fgtran->typ <= "9Z"  .and. ARDRCPST->trantype  = 'Income' && income
                DO INCOME_RTN
          endif
          endif
                         
          IF  fgtran->TYP = "L0" && creditors control
                              
                          pvsrce = ARDRCPST->vsrce
                          pvpmod = ARDRCPST->vpmod
                           pvtyp = ARDRCPST->vtyp
                               pvendor = ARDRCPST->vendor_N
         SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
                DO vntran_rtn
                   endif
                 endif
      DO SCASHREC_RTN
       
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
   SELECT SHCATSUM
       select shcatsum
         seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
      if .not. found()
      append blank
         replace coy with pcoy
         replace cen with pcen
         replace div with pdiv
         replace typ with ptyp
         replace cla with pcla
         replace cod with pcod
         replace shift_date with pSHDATE
         replace shift_no with pshno
         replace shift_id with pshid
         replace cs_sal_qty with 0
         replace cr_sal_qty with 0
         replace cs_pur_qty with 0
         replace cr_pur_qty with 0
         replace cs_sal_shs with 0
         replace cr_sal_shs with 0
         replace cs_pur_shs with 0
         replace cr_pur_shs with 0
     endif
     replace cs_sal_shs with cs_sal_shs + FGtran->total
                        
 PROCEDURE DRTRAN_RTN
  
 
        pcoy = ARDRCPST->coy
    pdate = ARDRCPST->order_date
    pcustno =  ARDRCPST->frighter_n
    PFTYP = ARDRCPST->Ftyp
    PPMOD = ARDRCPST->PMOD
    PSOURCE = ARDRCPST->SOURCE
    
    pdoc = ARDRCPST->doctype
    
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
     replace bal_due with bal_due - ARDRCPST->rec_total
     replace l_pay_amt with ARDRCPST->rec_total + L_pay_amt
     
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
              replace bal_due with bal_due - ARDRCPST->rec_total
                  replace l_pay_amt with ARDRCPST->rec_total + L_pay_amt
                   replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
      SELECT frighter
      SEEK psource+pftyp+ppmod+pcustno
      REPLACE BAL_DUE with   BAL_DUE - ARDRCPST->rec_total 
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
     select frcustbl
     REPLACE BAL_DUE with   BAL_DUE - ARDRCPST->rec_total 
     
    DO frshtrn_RTN2
    
PROCEDURE frshtrn_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lpmod,lsource,lmm,lyy,ld
  
      lref = ARDRCPST->order_no
      ldate = ARDRCPST->order_date
      tdate = ARDRCPST->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = ARDRCPST->system
      ldoc = ARDRCPST->doctype
      lcust = ARDRCPST->frighter_n
      lftyp = ARDRCPST->Ftyp
      PFTYP = ARDRCPST->Ftyp
      lpmod = ARDRCPST->pmod
      lsource = ARDRCPST->source
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
      replace serialno with ARDRCPST->serialno
      replace REG        WITH ARDRCPST->trantype
       replace sTIME       WITH ltime
        replace LPO        WITH ARDRCPST->lpo
         replace pay_method with ARDRCPST->pay_method
         replace recdate with ARDRCPST->recdate
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
    replace total with frshtrn->total + ARDRCPST->rec_total * -1
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with ARDRCPST->order_date
             replace l_pay_amt with ARDRCPST->rec_total + L_pay_amt
             pdate = frshtrn->trans_date
  PROCEDURE SCASHREC_RTN
   select st15f
   GO BOTTOM
         replace shift_post with date()
            IF ARDRCPST->SOURCE=   "9"  && STAFF SHORTAGES
             replace st15f->cash_CARDS with st15f->Cash_CARDS + ARDRCPST->rec_total
            ELSE
            replace st15f->CASH_DEBT with st15f->CASH_DEBT  + ARDRCPST->rec_total
            ENDIF
            
 IF  PCHEQUE
      replace st15f->CASH_MERCH with st15f->CASH_MERCH + ARDRCPST->rec_total
      endif
      IF  PCredit
      replace st15f->dbcredits with st15f->dbcredits + ARDRCPST->rec_total
      endif

      if ARDRCPST->btyp = "C0" .and. ARDRCPST->bcla = "00" .and. .not. ARDRCPST->bcod = "01"
               if pcash
                  replace cash_bank with cash_bank + ARDRCPST->rec_total
               else
                if pcheque
                   replace chqs_bank with chqs_bank + ARDRCPST->rec_total
           endif
           endif
           endif
        if ARDRCPST->pay_method = 'M-Money'
        if left(fgcods->name,13) = 'M-MPESA FLOAT'
           replace cl_mpfloat with cl_mpfloat + ARDRCPST->rec_total
           replace mp_float with mp_float  + ARDRCPST->rec_total
           else
           if left(fgcods->name,15) = 'M-MPESA CAPITAL'
           replace cl_CAPITAL with cl_CAPITAL + ARDRCPST->rec_total
           replace mp_CAPITAL with mp_CAPITAL  + ARDRCPST->rec_total
           ENDIF
           ENDIF
        endif
      
        SELECT SCASHREC   
        seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
        REPLACE RECEPTS WITH RECEPTS + ARDRCPST->rec_total
        IF PCHEQUE
             REPLACE CHQS WITH CHQS + ARDRCPST->rec_total
  
        ENDIF
        IF .NOT. PCASH .AND. .NOT. PCHEQUE
        REPLACE dbcredits WITH dbcredits + ARDRCPST->rec_total
        ENDIF
        if ARDRCPST->btyp = "C0" .and. ARDRCPST->bcla = "00" .and. .not. ARDRCPST->bcod = "01"
               if pcash
                  replace cash_bank with cash_bank + ARDRCPST->rec_total
               else
                if pcheque
                   replace chqs_bank with chqs_bank + ARDRCPST->rec_total
           endif
           endif
           endif
        
 PROCEDURE vntran_rtn
  
       pdate = ARDRCPST->order_date
       pventno = pvendor
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
       DO vnstat_3018RTN1
          SELECT vendor
      REPLACE vendor->BAL_DUE with  ARDRCPST->rec_total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
             replace l_inv_date with ARDRCPST->order_date
             replace l_inv_amt with ARDRCPST->rec_total   + l_inv_amt
    
             
 
    DO vnstat_3018RTN2
    
   
   
            
        
PROCEDURE vnstat_3018RTN1
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = ARDRCPST->order_no
      ldate = ARDRCPST->order_date
      tdate = ARDRCPST->order_date
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = ARDRCPST->system
      ldoc = ARDRCPST->doctype
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
      replace vnstat->serialno with ARDRCPST->serialno
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH ARDRCPST->lpo
        replace reg with ARDRCPST->trantype
        replace recdate with ARDRCPST->recdate
         replace vnstat->pay_method with ARDRCPST->pay_method
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
    replace off with ARDRCPST->off
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
    replace vnstat->total with vnstat->total + ARDRCPST->rec_total 
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
    
