Procedure AR30CRNT
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
 *   SET AUTOSAVE ON
    SET VIEW TO "AR30CRNT.QBE"
           PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
set reprocess to 10000
select frcustbl
   if  flock()
select ARCRNUPD

set order to mkey
SELECT CASHIERS
if flock()
SET ORDER TO CASHIER
SELECT ST15F
if flock()
SET ORDER TO MKEY
SELECT SCASHREC
IF FLOCK()
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
     eofARCRNLNE = .f.
     SELECT ARCRNTS
     
     GO TOP
     IF .NOT. EOF()
         select ARCRNLNE
         
    set filter to order_no = arcrnts->order_no .and. empty(post_date) .AND. .NOT. rec_TOTAL = 0 ;
     .AND. .NOT. (EMPTY(arcrnts->btyp) .and. empty(typ));
     .AND.  .NOT. (EMPTY(arcrnts->VSRCE) .AND. .NOT. SVC_TOTAL =0)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofARCRNLNE
                 select ARCRNTSN
                go top
                if eof()
                append blank
                endif
                replace order_no with ARCRNTS->order_no
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
             ENDIF
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
            PCUS,PST15F,ST15C,PSTMAST,PARCRNTS,pstt,pftyp,psource,ppmod,p20,ptsdate
   
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            lerr = .t.
                  begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            select ARCRNUPD
            seek ARCRNLNE->order_no+dtos(ARCRNTS->order_date)+ARCRNLNE->stock_no+ARCRNLNE->DDE_TIME
            if .not. found()
            append blank
            replace order_no with ARCRNLNE->order_no
            replace order_date with ARCRNTS->order_date
            replace stock_no with ARCRNLNE->stock_no
            REPLACE DDE_TIME WITH ARCRNLNE->DDE_TIME
            lerr = .f.
            endif
            IF EMPTY(POST_DATE)
            LERR = .F.
            ENDIF
             if .not. lerr   
           l7 = ARCRNLNE->order_no
         l8 = ARCRNLNE->order_date
         l9 = ARCRNLNE->stock_no
         l10 = "DS"
         l11 = "16"
         if empty(l8)
         l8 = ARCRNTS->order_date
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
          pftyp = ARCRNTS->FTYP
          psource = ARCRNTS->SOURCE
                       ppmod = ARCRNTS->PMOD  
                        pfrighter = ARCRNTS->frighter_N
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
            replace total with ARCRNLNE->rec_total && total receipts
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with 0
            replace disc_rate with ARCRNLNE->VAT_RATE
            replace tax_amt with ARCRNLNE->VAT_TOTAL
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with ARCRNTS->off
            REPLACE INV_NO WITH ARCRNTS->END_REC
            replace inv_py_amt with 0
            replace gross_amt with ARCRNLNE->SVC_TOTAL
            replace basic_amt with ARCRNLNE->TOTAL  && NETT AMT
            replace dsc  WITH 0
            replace TRANtype with ARCRNTS->PAYTYPE
            replace pay_method  with ARCRNTS->pay_method
            REPLACE source WITH ARCRNTS->source
            REPLACE FTYP WITH ARCRNTS->FTYP
            REPLACE PMOD WITH ARCRNTS->PMOD
           REPLACE FRIGHTER_N WITH ARCRNTS->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
           if .not. empty(arcrnts->btyp)
           replace Bcoy  with arcrnts->bcoy  && CREDITORS CONTROL VENDOR IS SELECTED
           replace Btyp  with arcrnts->btyp
           replace Bcla  with arcrnts->bcla
           replace Bcod  with arcrnts->bcod
            replace Bsto  with arcrnts->bsto
             replace Bdiv  with arcrnts->bdiv
              replace Bcen  with arcrnts->bcen
              else
           replace Bcoy  with ARCRNLNE->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with ARCRNLNE->typ
           replace Bcla  with ARCRNLNE->cla
           replace Bcod  with ARCRNLNE->cod
            replace Bsto  with ARCRNLNE->sto
             replace Bdiv  with ARCRNLNE->div
              replace Bcen  with ARCRNLNE->cen
      ENDIF
           replace coy  with ARCRNTS->coy  && DEBTORS CONTROL - DEBITED
           replace typ  with ARCRNTS->typ
           replace cla  with ARCRNTS->cla
           replace cod  with ARCRNTS->cod
            replace sto  with ARCRNTS->sto
             replace div  with ARCRNTS->div
              replace cen  with ARCRNTS->cen
                 if trantype = "Deposit"
                replace coy  with "1" && DEBTORS CONTROL - DEBITED
           replace typ  with "L0"
           replace cla  with "00"
           replace cod  with "00"
            replace sto  with "A1"
             replace div  with "5"
              replace cen  with "1"
             replace Bcoy  with ARCRNLNE->coy  &&  OTHER GL A/C- credit,  NO VENDOR IS SELECTED
           replace Btyp  with ARCRNLNE->typ
           replace Bcla  with ARCRNLNE->cla
           replace Bcod  with ARCRNLNE->cod
            replace Bsto  with ARCRNLNE->sto
             replace Bdiv  with ARCRNLNE->div
              replace Bcen  with ARCRNLNE->cen
endif
           
              replace vsrce with ARCRNTS->vsrce
      replace vpmod with ARCRNTS->vpmod
      replace vtyp with ARCRNTS->vtyp
      replace vendor_n with ARCRNTS->vendor_n
 
              replace recdate with arcrnts->recdate
              replace lpo with ARCRNTS->LPO
           replace serialno with ARCRNTS->START_REC  && START RECEIPT NO
           REPLACE SHIFT_NO WITH ARCRNTS->SHIFTNO
           REPLACE SHIFT_ID WITH ARCRNTS->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace inv_date with arcrnts->save_date
           replace inv_due with arcrnts->print_date
           
                IF  fgtran->BTYP >= "00" .AND. fgtran->Btyp <= "9Z"  && income
                DO INCOME_RTN
          endif   
    
        DO ARCRNLNE_RTN1
        ENDIF
        commit()
        
       SELECT ARCRNLNE
   IF .NOT. EOF()
   skip
   ENDIF
   if eof()
   eofARCRNLNE = .t.
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
                        
  
  
 PROCEDURE ARCRNLNE_RTN1
            local lld1,lld2
              ptsdate = ARCRNLNE->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = ARCRNTS->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = arcrnts->TYP
      pcla = arcrnts->CLA
      pcod = arcrnts->COD
      pcoy = arcrnts->COY
      pdiv = arcrnts->DIV
      pcen = arcrnts->CEN
      psto = arcrnts->STO
      
       porder = ARCRNLNE->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PARCRNTS = .F.
          select ARCRNTS
                 pcustno = ARCRNTS->frighter_N
                  pftyp = ARCRNTS->FTYP
                        psource = ARCRNTS->SOURCE
                       ppmod = ARCRNTS->PMOD  
                        pfrighter = ARCRNTS->frighter_N
     
                    pcashrno = ARCRNTS->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PARCRNTS = .T.
               porder = ARCRNTS->order_no
                        pftyp = ARCRNTS->ftyp
                          pcashrno = ARCRNTS->cashier_no
                          psource = ARCRNTS->source
                          ppmod = ARCRNTS->pmod
                    
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
replace off with ARCRNTS->off
   endif
    
   IF EMPTY(OFF)
   replace off with ARCRNTS->off
   ENDIF
      REPLACE RECEPTS WITH RECEPTS + ARCRNLNE->REC_total
        REPLACE dbcredits WITH dbcredits + ARCRNLNE->REC_total
  
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
   
      
                  
               PERROR = .F.
          
     IF EMPTY(ARCRNLNE->POST_DATE)  .AND. PCUS
    DO ARCRNLNE_RTN2
      IF  .NOT.  ARCRNLNE->svc_total = 0       .OR. .NOT.  EMPTY(arcrnts->vsrce)
       do appymts_rtn && for the nett , but update fgnfpur for the service charge transaction
       ENDIF

    SELECT ARCRNLNE
     REPLACE POST_DATE WITH DATE()
    SELECT ARCRNUPD
    replace post_date with date()
    ENDIF
  
  
    
  PROCEDURE ARCRNLNE_RTN2
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
              D1 = DTOS(ARCRNTS->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = ARCRNLNE->REC_TOTAL * -1
                 PTVAT = 0
              PCOY = ARCRNLNE->COY
              PDIV = ARCRNLNE->DIV
              PCEN = ARCRNLNE->CEN
              PTYP = ARCRNLNE->TYP
              PSTO = ARCRNLNE->STO
              PCLA = ARCRNLNE->CLA
              PCOD = ARCRNLNE->COD
       PFTYP = ARCRNTS->Ftyp
       PPMOD = ARCRNTS->PMOD
       PSOURCE = ARCRNTS->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = ARCRNLNE->REC_TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
        pcash = .F.
        pcredit = .T.
        Pcheque = .F.
        pother = .f.
  
           ptdate = ARCRNTS->ORDER_date
              PFTYP = ARCRNTS->Ftyp
              PPMOD = ARCRNTS->PMOD
              PSOURCE = ARCRNTS->SOURCE
              
              pttotal = ARCRNLNE->REC_total * -1
              
                    
               if ARCRNTS->paytype = "Deposit"  && deposit
              select frighter
              replace cdep_amt with cdep_amt + ARCRNLNE->total  && ok
         else
   
                DO DRTRAN_RTN
                endif
   select st15f
   GO TOP
   IF EOF()
   GO BOTTOM
   ENDIF
         replace shift_post with date()
      if ARCRNTS->source = "9"
          replace st15f->cash_CARDS with st15f->Cash_CARDS + ARCRNLNE->REC_total
           replace st15f->dbcredits with st15f->dbcredits + ARCRNLNE->REC_total
            ELSE
             replace st15f->CASH_DEBT with st15f->CASH_DEBT  + ARCRNLNE->REC_total
              replace st15f->dbcredits with st15f->dbcredits + ARCRNLNE->REC_total
            endif
       
     
 
 PROCEDURE DRTRAN_RTN
  
 
        pcoy = ARCRNLNE->coy
    pdate = ARCRNTS->order_date
    pcustno =  ARCRNTS->frighter_n
    PFTYP = ARCRNTS->Ftyp
    PPMOD = ARCRNTS->PMOD
    PSOURCE = ARCRNTS->SOURCE
    
   pdoc = "16"
   
    
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
     replace bal_due with bal_due - ARCRNLNE->REC_Total
     replace l_pay_amt with ARCRNLNE->REC_total + L_pay_amt
     
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
              replace bal_due with bal_due - ARCRNLNE->REC_total
                  replace l_pay_amt with ARCRNLNE->REC_total + L_pay_amt
                    replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
     select frcustbl
             REPLACE BAL_DUE with   BAL_DUE - ARCRNLNE->REC_TOTAL 
          SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
      REPLACE BAL_DUE with   BAL_DUE - ARCRNLNE->REC_TOTAL 
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
  
      lref = ARCRNTS->order_no
      ldate = ARCRNTS->order_date
      tdate = ARCRNTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "DS"
      ldoc = "16"
      lcust = ARCRNTS->frighter_n
      lftyp = ARCRNTS->Ftyp
      PFTYP = ARCRNTS->Ftyp
      lpmod = ARCRNTS->pmod
      lsource = ARCRNTS->source
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
      replace serialno with ARCRNTS->serialno
      replace REG        WITH ARCRNTS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH ARCRNTS->LPO
         replace pay_method with ARCRNTS->pay_method
         replace recdate with arcrnts->recdate
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
    replace total with frshtrn->total + ARCRNLNE->REC_total * -1
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
             replace l_pay_date with ARCRNTS->order_date
             replace l_pay_amt with ARCRNLNE->REC_total + L_pay_amt
             pdate = frshtrn->trans_date
            
           
 
  
      
  PROCEDURE appymts_rtn   
       
      PTYP = ARCRNLNE->TYP   && nett credited to vendor
      PCLA = ARCRNLNE->CLA
      PCOD = ARCRNLNE->COD
      PCOY = ARCRNLNE->COY
      PDIV = ARCRNLNE->DIV
      PCEN = ARCRNLNE->CEN
      PSTO = ARCRNLNE->STO
      PSHDATE = ARCRNTS->ORDER_DATE
      PSHNO = st15f->shift_no
      PSHID = st15f->shift_id
       PTOTAL1 = ARCRNLNE->SVC_TOTAL + ARCRNLNE->VAT_TOTAL  && service charge
 if .not.  arcrnts->paytype = "Deposit"
    PTOTAL = ARCRNLNE->TOTAL && nett
    else
    ptotal = ARCRNLNE->TOTAL * -1
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
      
      endif


    pcoy = ARCRNLNE->coy
    pdate = ARCRNTS->order_date
    pcustno =  ARCRNTS->VENDOR_n
    Pvtyp = ARCRNTS->vtyp
    Pvpmod = ARCRNTS->vpmod
    Pvsrce = ARCRNTS->vsrce
 
        SELECT VENDOR
           SEEK pvsrce+pvtyp+pvpmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
         
                  
               PERROR = .F.
          
     IF PCUS .and. .not. ptotal1 = 0
        DO PURCH_RTN
        endif
        if pcus  .and. .not. ptotal = 0
              
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
         replace doctype with "16"
         replace order_no with porder
         replace order_date with pshdate
         replace inv_date with ARCRNTS->recdate
         if empty(inv_date)
         replace inv_date with order_date
         endif
         replace stock_no with ARCRNLNE->STOCK_NO
         replace coy with ARCRNLNE->coy
            replace div with ARCRNLNE->div
            replace cen with ARCRNLNE->cen
              replace sto with ARCRNLNE->sto
              replace st_coy with ARCRNLNE->coy
            replace st_div with ARCRNLNE->div
            replace st_cen with ARCRNLNE->cen
              replace st_sto with ARCRNLNE->sto
             replace typ with ARCRNLNE->typ
            replace cla with ARCRNLNE->cla
            replace cod with ARCRNLNE->cod
            replace qty with 0
            replace return_qty with 0
            replace unit_cost with 0
            replace list_price with 0
            replace total with PTOTAL1
             replace tax_rate with ARCRNLNE->VAT_rate
            replace tax_amt with ARCRNLNE->VAT_TOTAL
             replace job_order with TYP
            replace off with ARCRNTS->off
            replace gross_amt with ARCRNLNE->SVC_TOTAL
               replace pay_method  with ARCRNTS->pay_method
             replace lpo with ARCRNTS->lpo
           REPLACE vsrce WITH ARCRNTS->vsrce
          REPLACE vtyp WITH ARCRNTS->vtyp
           REPLACE vpmod WITH ARCRNTS->vpmod
           REPLACE vendor_N WITH ARCRNTS->vendor_N
             replace shift_no with ARCRNTS->shiftno
           replace shift_id with ARCRNTS->shiftid
           replace inv_no with ARCRNTS->serialno
           replace cashier_no with ARCRNTS->cashier_no
            replace bcoy  with ARCRNTS->bcoy
           replace bcen  with ARCRNTS->BCEN
           replace bdiv  with ARCRNTS->BDIV
           replace bsto  with ARCRNTS->BSTO
           replace btyp with ARCRNTS->BTYP
           replace bcla with ARCRNTS->BCLA
           replace bcod with ARCRNTS->BCOD
           replace dde_date with date()
           replace dde_user with PLUSER
           replace dde_time with time()
           REPLACE SERIALNO WITH ARCRNTS->SERIALNO
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
           REPLACE NEW_BAL WITH ARCRNLNE->REC_TOTAL
            REPLACE source WITH ARCRNTS->source
            REPLACE FTYP WITH ARCRNTS->FTYP
            REPLACE PMOD WITH ARCRNTS->PMOD
           REPLACE FRIGHTER_N WITH ARCRNTS->FRIGHTER_N
           
          
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
  
      lref = ARCRNTS->order_no
      ldate = ARCRNTS->order_date
      tdate = ARCRNTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "DS"
      ldoc = "16"
      lcust = ARCRNTS->VENDOR_n
      lvtyp = ARCRNTS->vtyp
      Pvtyp = ARCRNTS->vtyp
      lvpmod = ARCRNTS->vpmod
      lvsrce = ARCRNTS->vsrce
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
      replace serialno with ARCRNTS->serialno
      replace REG        WITH ARCRNTS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH ARCRNLNE->ref
         replace pay_method with ARCRNTS->pay_method
         replace recdate with arcrnts->recdate
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
             replace l_pay_date with ARCRNTS->order_date
             replace l_pay_amt with PTOTAL + L_pay_amt
            
     
    
      
