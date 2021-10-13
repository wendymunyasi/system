Procedure AR30DRNT
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
   * SET AUTOSAVE ON
    SET VIEW TO "AR30DRNT.QBE"
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 10000
 select frcustbl
   if  flock()
       
select ARDRNUPD

set order to mkey
SELECT CASHIERS
if flock()
SET ORDER TO CASHIER
SELECT ST15F
if flock()
SET ORDER TO MKEY
SELECT SCASHREC
if flock()
SET ORDER TO MKEY
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
      if flock()
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
     eofARDRNLN = .f.
     SELECT ARDRNTS
     
     GO TOP
     IF .NOT. EOF()
         select ARDRNLN
         
    set filter to order_no = ARDRNTS->order_no .and. empty(post_date) .AND. .NOT. rec_TOTAL = 0 ;
     .AND. .NOT. (EMPTY(ARDRNTS->btyp) .and. empty(typ));
     .AND.  .NOT. (EMPTY(ARDRNTS->VSRCE) .AND. .NOT. SVC_TOTAL =0)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofARDRNLN
                 select ARDRNTSN
                go top
                if eof()
                append blank
                endif
                replace order_no with ARDRNTS->order_no
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
             endif
             endif
            endif
            endif
            endif
             ENDIF
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
            PCUS,PST15F,ST15C,PSTMAST,PARDRNTS,pstt,pftyp,psource,ppmod,p20,ptsdate
   
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            select ARDRNUPD
            seek ARDRNLN->order_no+dtos(ARDRNTS->order_date)+ARDRNLN->stock_no+ARDRNLN->DDE_TIME
            if .not. found()
            append blank
            replace order_no with ARDRNLN->order_no
            replace order_date with ARDRNTS->order_date
            replace stock_no with ARDRNLN->stock_no
            REPLACE DDE_TIME WITH ARDRNLN->DDE_TIME
            lerr = .f.
            endif
            IF EMPTY(POST_DATE)
            LERR = .F.
            ENDIF
             if .not. lerr   
           l7 = ARDRNLN->order_no
         l8 = ARDRNLN->order_date
         l9 = ARDRNLN->stock_no
         l10 = "DS"
         l11 = "15"
         if empty(l8)
         l8 = ARDRNTS->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         select st15f
         go top
         rlock()
         pshno = shift_no
         pshid = shift_id
         else
         pshno = "0"
         pshid = "0"
         endif
          pftyp = ARDRNTS->FTYP
          psource = ARDRNTS->SOURCE
                       ppmod = ARDRNTS->PMOD  
                        pfrighter = ARDRNTS->frighter_N
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
            replace total with ARDRNLN->rec_total && total receipts
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with 0
            replace disc_rate with ARDRNLN->VAT_RATE
            replace tax_amt with ARDRNLN->VAT_TOTAL
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with ARDRNTS->off
            REPLACE INV_NO WITH ARDRNTS->END_REC
            replace inv_py_amt with 0
            replace gross_amt with ARDRNLN->SVC_TOTAL
            replace basic_amt with ARDRNLN->TOTAL  && NETT AMT
            replace dsc  WITH 0
            replace TRANtype with ARDRNTS->PAYTYPE
            replace pay_method  with ARDRNTS->pay_method
            REPLACE source WITH ARDRNTS->source
            REPLACE FTYP WITH ARDRNTS->FTYP
            REPLACE PMOD WITH ARDRNTS->PMOD
           REPLACE FRIGHTER_N WITH ARDRNTS->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
           if .not. empty(ardrnts->btyp)
           replace Bcoy  with ARDRNTS->bcoy  && CREDITORS CONTROL VENDOR IS SELECTED
           replace Btyp  with ARDRNTS->btyp
           replace Bcla  with ARDRNTS->bcla
           replace Bcod  with ARDRNTS->bcod
            replace Bsto  with ARDRNTS->bsto
             replace Bdiv  with ARDRNTS->bdiv
              replace Bcen  with ARDRNTS->bcen
              else
           replace Bcoy  with ARDRNLN->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with ARDRNLN->typ
           replace Bcla  with ARDRNLN->cla
           replace Bcod  with ARDRNLN->cod
            replace Bsto  with ARDRNLN->sto
             replace Bdiv  with ARDRNLN->div
              replace Bcen  with ARDRNLN->cen
      ENDIF
           replace coy  with ARDRNTS->coy  && DEBTORS CONTROL - DEBITED
           replace typ  with ARDRNTS->typ
           replace cla  with ARDRNTS->cla
           replace cod  with ARDRNTS->cod
            replace sto  with ARDRNTS->sto
             replace div  with ARDRNTS->div
              replace cen  with ARDRNTS->cen
              
              if trantype = "Deposit"
                replace coy  with "1" && DEBTORS CONTROL - DEBITED
           replace typ  with "L0"
           replace cla  with "00"
           replace cod  with "00"
            replace sto  with "A1"
             replace div  with "5"
              replace cen  with "1"
             replace Bcoy  with ARDRNLN->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with ARDRNLN->typ
           replace Bcla  with ARDRNLN->cla
           replace Bcod  with ARDRNLN->cod
            replace Bsto  with ARDRNLN->sto
             replace Bdiv  with ARDRNLN->div
              replace Bcen  with ARDRNLN->cen
endif
     
    
      replace vsrce with ARDRNTS->vsrce
      replace vpmod with ARDRNTS->vpmod
      replace vtyp with ARDRNTS->vtyp
      replace vendor_n with ARDRNTS->vendor_n
           
              replace recdate with ardrnts->recdate
              replace lpo with ARDRNTS->LPO
           replace serialno with ARDRNTS->START_REC  && START RECEIPT NO
           REPLACE SHIFT_NO WITH ARDRNTS->SHIFTNO
           REPLACE SHIFT_ID WITH ARDRNTS->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
              replace inv_date with ARDRNTS->save_date
           replace inv_due with ARDRNTS->print_date
       
                IF  fgtran->BTYP >= "00" .AND. fgtran->Btyp <= "9Z"  && income
                DO INCOME_RTN
          endif   
        DO ARDRNLN_RTN1
        ENDIF
        commit()
        
       SELECT ARDRNLN
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofARDRNLN = .t.
   endif
  
  PROCEDURE INCOME_RTN
PCOY = FGTRAN->BCOY
PDIV = FGTRAN->BDIv
pcen = FGTRAN->Bcen
ptyp = FGTRAN->Btyp
pcla = FGTRAN->Bcla
pcod = FGTRAN->Bcod
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
     replace cr_sal_shs with cr_sal_shs + FGtran->total * -1
     select fgtran
     replace sales_date with date()
                        
  
  
 PROCEDURE ARDRNLN_RTN1
            local lld1,lld2
              ptsdate = ARDRNLN->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = ARDRNTS->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = ARDRNTS->TYP
      pcla = ARDRNTS->CLA
      pcod = ARDRNTS->COD
      pcoy = ARDRNTS->COY
      pdiv = ARDRNTS->DIV
      pcen = ARDRNTS->CEN
      psto = ARDRNTS->STO
       porder = ARDRNLN->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PARDRNTS = .F.
          select ARDRNTS
                 pcustno = ARDRNTS->frighter_N
                  pftyp = FTYP
                        psource = SOURCE
                       ppmod = PMOD              
                    pcashrno = ARDRNTS->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PARDRNTS = .T.
      pfrighter = ARDRNTS->frighter_N
               porder = ARDRNTS->order_no
                        pftyp = ARDRNTS->ftyp
                          pcashrno = ARDRNTS->cashier_no
                          psource = ARDRNTS->source
                          ppmod = ARDRNTS->pmod
                    
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
 replace off with ARDRNTS->off
   endif
   IF  EMPTY(OFF)
    replace off with ARDRNTS->off
    ENDIF
    REPLACE RECEPTS WITH RECEPTS + ARDRNLN->REC_total
        REPLACE dbcredits WITH dbcredits + ARDRNLN->REC_total
          
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
              rlock()    
               PERROR = .F.
          
     IF EMPTY(ARDRNLN->POST_DATE)  .AND. PCUS
    DO ARDRNLN_RTN2
       IF  .NOT.  ARDRNLN->svc_total = 0       .OR. .NOT.  EMPTY(ARDRNTS->vsrce)
       do appymts_rtn && for the nett , but update fgnfpur for the service charge transaction
       ENDIF
    SELECT ARDRNLN
     REPLACE POST_DATE WITH DATE()
    SELECT ARDRNUPD
    replace post_date with date()
    ENDIF
  
  
    
  PROCEDURE ARDRNLN_RTN2
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
              D1 = DTOS(ARDRNTS->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = ARDRNLN->REC_TOTAL * -1
                 PTVAT = 0
              PCOY = ARDRNLN->COY
              PDIV = ARDRNLN->DIV
              PCEN = ARDRNLN->CEN
              PTYP = ARDRNLN->TYP
              PSTO = ARDRNLN->STO
              PCLA = ARDRNLN->CLA
              PCOD = ARDRNLN->COD
       PFTYP = ARDRNTS->Ftyp
       PPMOD = ARDRNTS->PMOD
       PSOURCE = ARDRNTS->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = ARDRNLN->REC_TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
        pcash = .F.
        pcredit = .T.
        Pcheque = .F.
        pother = .f.
  
           ptdate = ARDRNTS->ORDER_date
              PFTYP = ARDRNTS->Ftyp
              PPMOD = ARDRNTS->PMOD
              PSOURCE = ARDRNTS->SOURCE
              
              pttotal = ARDRNLN->REC_total * -1
              
               
               if ARDRNTS->paytype = "Deposit"  && deposit
              select frighter
              replace cdep_amt with cdep_amt + ARDRNLN->total
         else
                DO DRTRAN_RTN
                endif
               
   select st15f
   GO TOP
   IF EOF()
   GO BOTTOM
   ENDIF
         replace shift_post with date()
         if ARDRNTS->source = "9"
          replace st15f->cash_CARDS with st15f->Cash_CARDS + ARDRNLN->REC_total
           replace st15f->dbcredits with st15f->dbcredits + ARDRNLN->REC_total
            ELSE
            
            replace st15f->CASH_DEBT with st15f->CASH_DEBT  + ARDRNLN->REC_total
             replace st15f->dbcredits with st15f->dbcredits + ARDRNLN->REC_total
            endif
   
 PROCEDURE DRTRAN_RTN
  
 
        pcoy = ARDRNLN->coy
    pdate = ARDRNTS->order_date
    pcustno =  ARDRNTS->frighter_n
    PFTYP = ARDRNTS->Ftyp
    PPMOD = ARDRNTS->PMOD
    PSOURCE = ARDRNTS->SOURCE
    
   pdoc = "15"
   
    
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
     replace bal_due with bal_due - ARDRNLN->REC_Total
     replace l_pay_amt with ARDRNLN->REC_total + L_pay_amt
     
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
              replace bal_due with bal_due - ARDRNLN->REC_total
                  replace l_pay_amt with ARDRNLN->REC_total + L_pay_amt
                    replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
        
      select frcustbl
             REPLACE BAL_DUE with   BAL_DUE - ARDRNLN->REC_TOTAL 
          SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
      REPLACE BAL_DUE with   BAL_DUE - ARDRNLN->REC_TOTAL 
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
  
      lref = ARDRNTS->order_no
      ldate = ARDRNTS->order_date
      tdate = ARDRNTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "DS"
      ldoc = "15"
      lcust = ARDRNTS->frighter_n
      lftyp = ARDRNTS->Ftyp
      PFTYP = ARDRNTS->Ftyp
      lpmod = ARDRNTS->pmod
      lsource = ARDRNTS->source
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
      replace serialno with ARDRNTS->serialno
      replace REG        WITH ARDRNTS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH ARDRNTS->LPO
         replace pay_method with ARDRNTS->pay_method
         replace recdate with ardrnts->recdate
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
    replace total with frshtrn->total + ARDRNLN->REC_total * -1
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with ARDRNTS->order_date
             replace l_pay_amt with ARDRNLN->REC_total + L_pay_amt
             pdate = frshtrn->trans_date
            
           
 
 
  PROCEDURE appymts_rtn   
       
      PTYP = ARDRNLN->TYP   && nett credited to vendor
      PCLA = ARDRNLN->CLA
      PCOD = ARDRNLN->COD
      PCOY = ARDRNLN->COY
      PDIV = ARDRNLN->DIV
      PCEN = ARDRNLN->CEN
      PSTO = ARDRNLN->STO
      PSHDATE = ARDRNTS->ORDER_DATE
      PSHNO = st15f->shift_no
      PSHID = st15f->shift_id
       PTOTAL1 = ARDRNLN->SVC_TOTAL + ARDRNLN->VAT_TOTAL  && service charge/OTHER CR A/C
 
    if .not.  ARDRNTS->paytype = "Deposit"
    PTOTAL = ARDRNLN->TOTAL && nett
    else
    ptotal = ARDRNLN->TOTAL * -1
    endif
 if .not. ptotal1 = 0
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
      rlock()
      endif


    pcoy = ARDRNLN->coy
    pdate = ARDRNTS->order_date
    pcustno =  ARDRNTS->VENDOR_n
    Pvtyp = ARDRNTS->vtyp
    Pvpmod = ARDRNTS->vpmod
    Pvsrce = ARDRNTS->vsrce
 
        SELECT VENDOR
           SEEK pvsrce+pvtyp+pvpmod+pcustno
        IF FOUND()
           PvCUS = .T.
         ELSE
           PvCUS = .F.
        ENDIF
        rlock()
                  
               PERROR = .F.
          
     IF PvCUS .and. .not. ptotal1 = 0  && ONLY IF OTHER A/C INVOLVED
        DO PURCH_RTN
        endif
        if pvcus .and. .not. ptotal = 0
                   DO VNTRAN_RTN
                   ENDIF
                   


          
 PROCEDURE purch_rtn
              do fgnfpur_RTN
                 select shcatsum
                        replace cr_PUR_shs with cr_PUR_shs + PTOTAL1
  
  Procedure fgnfpur_RTN
        select fgnfpur
          append blank
         replace system with "DS"
         replace doctype with "15"
         replace order_no with porder
         replace order_date with pshdate
         replace inv_date with ARDRNTS->recdate
         if empty(inv_date)
         replace inv_date with order_date
         endif
         replace stock_no with ARDRNLN->STOCK_NO
         replace coy with ARDRNLN->coy
            replace div with ARDRNLN->div
            replace cen with ARDRNLN->cen
              replace sto with ARDRNLN->sto
              replace st_coy with ARDRNLN->coy
            replace st_div with ARDRNLN->div
            replace st_cen with ARDRNLN->cen
              replace st_sto with ARDRNLN->sto
            replace typ with ARDRNLN->typ
            replace cla with ARDRNLN->cla
            replace cod with ARDRNLN->cod
            replace qty with 0
            replace return_qty with 0
            replace unit_cost with 0
            replace list_price with 0
            replace total with PTOTAL1
             replace tax_rate with ARDRNLN->VAT_rate
            replace tax_amt with ARDRNLN->VAT_TOTAL
             replace job_order with TYP
            replace off with ARDRNTS->off
            replace gross_amt with ARDRNLN->SVC_TOTAL
               replace pay_method  with ARDRNTS->pay_method
             replace lpo with ARDRNTS->lpo
           REPLACE vsrce WITH ARDRNTS->vsrce
          REPLACE vtyp WITH ARDRNTS->vtyp
           REPLACE vpmod WITH ARDRNTS->vpmod
           REPLACE vendor_N WITH ARDRNTS->vendor_N
             replace shift_no with ARDRNTS->shiftno
           replace shift_id with ARDRNTS->shiftid
           replace inv_no with ARDRNTS->serialno
           replace cashier_no with ARDRNTS->cashier_no
           replace bcoy  with ARDRNTS->Bcoy
           replace bcen  with ARDRNTS->BCEN
           replace bdiv  with ARDRNTS->BDIV
           replace bsto  with ARDRNTS->BSTO
           replace btyp with ARDRNTS->BTYP
           replace bcla with ARDRNTS->BCLA
           replace bcod with ARDRNTS->BCOD
           replace dde_date with date()
           replace dde_user with PLUSER
           replace dde_time with time()
           REPLACE SERIALNO WITH ARDRNTS->SERIALNO
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
           REPLACE NEW_BAL WITH ARDRNLN->REC_TOTAL
            REPLACE source WITH ARDRNTS->source
            REPLACE FTYP WITH ARDRNTS->FTYP
            REPLACE PMOD WITH ARDRNTS->PMOD
           REPLACE FRIGHTER_N WITH ARDRNTS->FRIGHTER_N
           
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
  
      lref = ARDRNTS->order_no
      ldate = ARDRNTS->order_date
      tdate = ARDRNTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "DS"
      ldoc = "15"
      lcust = ARDRNTS->VENDOR_n
      lvtyp = ARDRNTS->vtyp
      Pvtyp = ARDRNTS->vtyp
      lvpmod = ARDRNTS->vpmod
      lvsrce = ARDRNTS->vsrce
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
                 replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
             replace payment with 1
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                 replace alloc_AMT with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with ARDRNTS->serialno
      replace REG        WITH ARDRNTS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH ARDRNLN->ref
         replace pay_method with ARDRNTS->pay_method
         replace recdate with ardrnts->recdate
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
             replace l_pay_date with ARDRNTS->order_date
             replace l_pay_amt with PTOTAL + L_pay_amt
            
     
