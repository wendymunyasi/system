Procedure ap30pymt
PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET VIEW TO "ap30pymt.QBE"
    PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    set safety off
    set reprocess to 10000
   select frcustbl
   if  flock()
    select fgnfpur
     SELECT FRTRNAGE
     if flock()
     SET ORDER TO MKEY
      select VNDOCREF
      if flock()
   set order to docref
   SET SAFETY ON
   select frighter
    if flock()
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
   select st15f
   if flock()
   set order to mkey
   GO TOP
   
    select scashrec
    if flock()
   set order to mkey
   select cashiers
   set order to cashier
   select VENDOR
    if flock()
   set order to VENDOR
      select VNCOUNT
   set order to mkey
   select VNSTAT
   if flock()
   set order to mkey
   select appymupd
set order to mkey

     eofappynlin = .f.
     select appymts
     go top
     if .not. eof()
         select appynlin
    set filter to order_no = APPYMTS->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 ;
     .AND. .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. ;
      .NOT. EMPTY(STO) .AND. .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(CLA) .AND. .NOT. EMPTY(COD)
              go top
                if .not. eof()
                do
                do line_rtn
                until eofappynlin
                select appymtsn
                go top
                if eof()
                append blank
                endif
                replace order_no with appymts->order_no
                   endif
                   endif
                 *  commit()
                   select fgcoy
                   flush
            else
            wait 'Unable to Lock Tables. Try Again Later!'
            quit
            endif
            endif
            endif
            endif
            endif
            endif
            endif
            ENDIF
            CLOSE DATABASES
              set safety off
            use \kenserve\idssys\frshtrn.dbf
            copy stru to \kenservice\data\frshtrns dbase prod
            close databases
            use  \kenservice\data\frshtrns.dbf
            appe from \kenservice\data\frshtrn.dbf
            close databases
           
                   close databases
       
procedure line_rtn
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            lerr = .t.
               begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

            select appymupd
       seek appynlin->order_no+dtos(appymts->order_date)+appynlin->stock_no+appynlin->dde_time
            if .not. found()
            append blank
            replace order_no with appynlin->order_no
            replace order_date with appymts->order_date
            replace stock_no with appynlin->stock_no
            replace dde_time with appynlin->dde_time
            lerr = .f.
            endif
            if empty(appynlin->post_date)
            lerr = .f.
            endif
         if .not. lerr   
           l7 = appynlin->order_no
         l8 = appynlin->order_date
         l9 = appynlin->stock_no
         l10 = "AP"
          l11 = "54"
         IF appymts->pay_method = "Cheque"
         l11 = "54"
         endif
          IF appymts->pay_method = "FC Cash"
         l11 = "51"
         endif
          IF appymts->pay_method = "Float Cash"
         l11 = "62"
         endif
            IF appymts->pay_method = "Capital"
         l11 = "50"
         endif
            IF appymts->pay_method = "Hqdebit"
         l11 = "59"
         endif
            IF appymts->pay_method = "Loan"
         l11 = "58"
         endif
            IF appymts->pay_method = "Credit(card)"
         l11 = "64"
         endif
            IF appymts->pay_method = "Bank Debit"
         l11 = "60"
         endif
            IF appymts->pay_method = "M-Money"
         l11 = "67"
         endif
           IF appymts->pay_method = "FT" .or. appymts->pay_method = "EFT"
         l11 = "61"
         endif
         if empty(l8)
         l8 = APPYMTS->order_date
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
         
       
         select fgnfpur
         append blank
         replace system with l10
         replace doctype with l11
         replace order_no with l7
         replace order_date with l8
         replace stock_no with l9
             replace total with appynlin->total
             replace off with APPYMTS->off
                replace pay_method  with APPYMTS->pay_method
              replace inv_date with appymts->inv_date
            if empty(inv_date)
           replace inv_date with order_date
           endif
         *  if pay_method = "FC Cash" .or. pay_method = "Cash"
       *    replace inv_date with order_date
      *     endif
               replace REG        WITH APPYMTS->paytype
            REPLACE vsrce WITH APPYMTS->vsrce
            REPLACE vtyp WITH APPYMTS->vtyp
            REPLACE vpmod WITH APPYMTS->vpmod
           REPLACE VENDOR_N WITH APPYMTS->VENDOR_N
              REPLACE paysrce WITH APPYMTS->paysrce
          REPLACE paytyp WITH APPYMTS->paytyp
           REPLACE paymod WITH APPYMTS->paymod
           REPLACE pay_n WITH APPYMTS->pay_n
           if empty(paysrce)
          REPLACE paysrce WITH vsrce
          REPLACE paytyp WITH vtyp
           REPLACE paymod WITH vpmod
           REPLACE pay_n WITH vendor_n
      endif
     
           replace shift_no with pshno
           replace shift_id with pshid
             replace Bcoy  with APPYMTS->bcoy
              replace Bdiv  with APPYMTS->bdiv
              replace cashier_no with  APPYMTS->cashier_no
               replace Bcen  with APPYMTS->bcen
                replace Bsto  with APPYMTS->bsto
            replace Btyp  with APPYMTS->btyp
           replace Bcla  with APPYMTS->bcla
           replace Bcod  with APPYMTS->bcod
           replace coy  with appynlin->coy
           replace div   with appynlin->div
           replace cen  with appynlin->cen
           replace sto  with appynlin->sto
           replace typ  with appynlin->typ
           replace cla  with appynlin->cla
           replace cod  with appynlin->cod
           replace lpo with appymts->lpo
           replace serialno with APPYMTS->serialno
           REPLACE SHIFT_NO WITH APPYMTS->SHIFTNO
           REPLACE SHIFT_ID WITH APPYMTS->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
            REPLACE source WITH APPYMTS->source
            REPLACE ftyp WITH APPYMTS->ftyp
            REPLACE pmod WITH APPYMTS->pmod
           REPLACE frighter_n WITH APPYMTS->frighter_n
        DO appynlin_RTN1
       
        
   select appynlin
   REPLACE POST_DATE WITH DATE()
    select appymupd
   REPLACE POST_DATE WITH DATE()
   endif
  commit()
     select appynlin
   if .not. eof()
   
   skip
   endif
   if eof()
   eofappynlin = .t.
   endif
  
  
  
  
  
 PROCEDURE appynlin_RTN1
    PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,PAPPYMTS,pstt,pvtyp,pvsrce,pvpmod,p20,ptsdate
            local lld1,lld2
              ptsdate = appynlin->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = APPYMTS->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = appynlin->TYP
      pcla = appynlin->CLA
      pcod = appynlin->COD
      pcoy = appynlin->COY
      pdiv = appynlin->DIV
      pcen = appynlin->CEN
      psto = appynlin->STO
       porder = appynlin->order_no
       pvtyp = ""
       pcustno = ""
       pvsrce = ""
       pvpmod = ""
       p20 = ""
       PCASHRNO = ""
          PAPPYMTS = .F.
          select APPYMTS
                 pcustno = APPYMTS->VENDOR_N
                  pvtyp = vtyp
                        pvsrce = vsrce
                       pvpmod = vpmod              
                    pcashrno = APPYMTS->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PAPPYMTS = .T.
      pVENDOR = APPYMTS->VENDOR_N
               porder = APPYMTS->order_no
                        pvtyp = APPYMTS->vtyp
                          pcashrno = APPYMTS->cashier_no
                          pvsrce = APPYMTS->vsrce
                          pvpmod = APPYMTS->vpmod
                    
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
REPLACE OFF WITH APPYMTS->OFF
   endif
  
   IF EMPTY(OFF)
   REPLACE OFF WITH APPYMTS->OFF
   ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
   
        SELECT VENDOR
           SEEK pvsrce+pvtyp+pvpmod+pcustno
        IF FOUND()
           PCUS = .T.
         ELSE
           PCUS = .F.
        ENDIF
        
                  
               PERROR = .F.
          
     IF EMPTY(appynlin->POST_DATE)  .AND. PCUS
    DO appynlin_RTN2
   
    ENDIF
    
  PROCEDURE appynlin_RTN2
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
              D1 = DTOS(APPYMTS->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = appynlin->TOTAL * -1
                 PTVAT = 0
              PCOY = appynlin->COY
              PDIV = appynlin->DIV
              PCEN = appynlin->CEN
              PTYP = appynlin->TYP
              PSTO = appynlin->STO
              PCLA = appynlin->CLA
              PCOD = appynlin->COD
       Pvtyp = APPYMTS->vtyp
       Pvpmod = APPYMTS->vpmod
       Pvsrce = APPYMTS->vsrce
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = appynlin->TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
               
                 pcash = .f.
                 pcheque = .f.
                  phqdebit = .F.
                  pcapital = .f.
                  ppmcapital = .f.
                  ploan = .f.
                  pdep = .f.
                  pbal = .f.
                  pflcash =.f.
                  pfccash = .f.
                  pinvoice = .f.
                if APPYMTS->PAY_METHOD= "Hqdebit" 
       phqdebit =   .T.
      endif  
        if APPYMTS->PAY_METHOD= "Capital" 
       ppmcapital   = .T.
      endif  
             
     if APPYMTS->PAY_METHOD= "FC Cash" 
        pfccash  = .T.
      endif
        
        if APPYMTS->PAY_METHOD= "Float Cash"
        pflcash = .t.
        endif
        if pfccash .or. pflcash
        pcash = .t.
        endif
        if APPYMTS->PAY_METHOD= "Cheque" .or. APPYMTS->PAY_METHOD= "Bank Debit";
        .or. APPYMTS->PAY_METHOD= "Card(credit)" .or. APPYMTS->PAY_METHOD= "FT" .or. APPYMTS->PAY_METHOD = "M-Money"
            pcheque = .T.
      endif
   
       if APPYMTS->PAYtype = "Capital"
        pcapital = .T.
      endif
      
       if APPYMTS->PAYtype = "Loan"
        ploan = .T.
      endif
       if APPYMTS->PAYtype = "Invoice"
        pinvoice = .T.
      endif
       if APPYMTS->PAYtype = "Debtordep"
        pdep = .T.
      endif
      if APPYMTS->PAYtype = "Debtorbal"
        pbal = .T.
      endif
      
 
           ptdate = APPYMTS->ORDER_date
              Pvtyp = APPYMTS->vtyp
              Pvpmod = APPYMTS->vpmod
              Pvsrce = APPYMTS->vsrce
              
              pttotal = appynlin->total * -1
              
              IF PBAL .OR. PDEP  && ok
                 DO FRIGHTER_RTN
                 ENDIF
              
             IF (PINVOICE .OR. PLOAN .or. ppmcapital .or.  pdep) .AND. APPYNLIN->typ = "L0" 
                   DO DRTRAN_RTN
              ENDIF
            
               if pcash
       if .not. appymts->bcod  = "11"  && not from float
   select scashrec
      seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
                    replace purch with purch +  appynlin->TOTAL
                        select st15f
       go top
         REPLACE SHIFT_POST WITH DATE()
                     replace cash_FOOD with cash_FOOD + appynlin->TOTAL
             else
                       select st15f
        go top
         REPLACE SHIFT_POST WITH DATE()
                     replace batchamt with batchamt - appynlin->TOTAL
              endif
        endif
         
         if appymts->pay_method = 'M-Money'
         select st15f
         go top
           REPLACE SHIFT_POST WITH DATE()
         replace mbp_money with mbp_money + appynlin->TOTAL
         endif
         
           if APPYMTS->btyp = "C0" .and. APPYMTS->bcla = "00" .and. ;
                          APPYMTS->bcod = "11"  && payment from float
                            pvsrce = "1"
                          pvpmod = "1"
                           pvtyp = "1"
                               pvendor = "0001"
                                 SELECT vendor
           SEEK pvsrce+pvtyp+pvpmod+pvendor
        IF FOUND()
           pven = .T.
         ELSE
           pven = .F.
        ENDIF
        
        IF PVEN
        DO DRTRAN_FLOAT
        ENDIF
        ENDIF
        IF APPYNLIN->TYP = "L0" .AND. .NOT. EMPTY(APPYMTS->PAYSRCE)
    pcustno =  APPYMTS->PAY_N
    Pvtyp = APPYMTS->PAYTYP
    Pvpmod = APPYMTS->PAYMOD
    Pvsrce = APPYMTS->PAYSRCE
SELECT VENDOR
 SEEK pvsrce+pvtyp+pvpmod+pcustno
 IF FOUND()
 DO BRANCH_RTN
 ENDIF
 ENDIF

 PROCEDURE DRTRAN_RTN
  
 
    pcoy = appynlin->coy
    pdate = APPYMTS->order_date
    pcustno =  APPYMTS->VENDOR_n
    Pvtyp = APPYMTS->vtyp
    Pvpmod = APPYMTS->vpmod
    Pvsrce = APPYMTS->vsrce
    
    pdoc = "54"
         IF appymts->pay_method = "Cheque"
         pdoc = "54"
         endif
          IF appymts->pay_method = "FC Cash"
         pdoc = "51"
         endif
          IF appymts->pay_method = "Float Cash"
         pdoc = "62"
         endif
            IF appymts->pay_method = "Capital"
         pdoc = "50"
         endif
            IF appymts->pay_method = "Hqdebit"
         pdoc = "59"
         endif
            IF appymts->pay_method = "Loan"
         pdoc = "58"
         endif
            IF appymts->pay_method = "Credit(card)"
         pdoc = "64"
         endif
            IF appymts->pay_method = "Bank Debit"
         pdoc = "60"
         endif
           IF appymts->pay_method = "M-Money"
          pdoc = "67"
         endif
           IF appymts->pay_method = "FT" .or. appymts->pay_method = "EFT"
         pdoc = "61"
         endif
    
    DO vnstat_RTN1
       
      SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE - appynlin->TOTAL 
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
  
      lref = APPYMTS->order_no
      ldate = APPYMTS->order_date
      tdate = APPYMTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "AP"
      ldoc = pdoc
      lcust = APPYMTS->VENDOR_n
      lvtyp = APPYMTS->vtyp
      Pvtyp = APPYMTS->vtyp
      lvpmod = APPYMTS->vpmod
      lvsrce = APPYMTS->vsrce
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
               replace invoice with 0
                REPLACE PAYMENT WITH 1
                replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
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
      replace serialno with APPYMTS->serialno
      replace REG        WITH APPYMTS->paytype
       replace sTIME       WITH ltime
        replace lpo with appymts->lpo
         replace pay_method with APPYMTS->pay_method
         replace recdate with appymts->inv_date
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
    replace total with vnstat->total + appynlin->total * -1
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
       REPLACE BL_AMT WITH TOTAL  + APPYMTS->al_amt
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   select VENDOR
             replace l_pay_date with APPYMTS->order_date
             replace l_pay_amt with appynlin->total + L_pay_amt
   

PROCEDURE DRTRAN_FLOAT
  
        pcoy = appynlin->coy
    pdate = APPYMTS->order_date
    pcustno =  "0001"
    Pvtyp = "1"
    Pvpmod = "1"
    Pvsrce = "1"
    pdoc = "54"
         IF appymts->pay_method = "Cheque"
         pdoc = "54"
         endif
          IF appymts->pay_method = "FC Cash"
         pdoc = "51"
         endif
          IF appymts->pay_method = "Float Cash"
         pdoc = "62"
         endif
            IF appymts->pay_method = "Capital"
         pdoc = "50"
         endif
            IF appymts->pay_method = "Hqdebit"
         pdoc = "59"
         endif
            IF appymts->pay_method = "Loan"
         pdoc = "58"
         endif
            IF appymts->pay_method = "Credit(card)"
         pdoc = "64"
         endif
            IF appymts->pay_method = "Bank Debit"
         pdoc = "60"
         endif
         IF appymts->pay_method = "M-Money"
         pdoc = "67"
         endif
           IF appymts->pay_method = "FT" .or. appymts->pay_method = "EFT"
         pdoc = "61"
         endif
    
    DO vnstat_FLOAT1
      SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE + appynlin->TOTAL 
      IF VENDOR->BAL_DUE > 0
      REPLACE VENDOR->BAL_DUE_CR with  0
      REPLACE VENDOR->BAL_DUE_DR with  VENDOR->BAL_DUE
      ELSE
      REPLACE VENDOR->BAL_DUE_DR with  0
      REPLACE VENDOR->BAL_DUE_CR with  VENDOR->BAL_DUE * -1
      ENDIF
     
     
    DO vnstat_FLOAT2
    
PROCEDURE vnstat_FLOAT1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lvtyp,lvpmod,lvsrce,lmm,lyy,ld
  
      lref = APPYMTS->order_no
      ldate = APPYMTS->order_date
      tdate = APPYMTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "AP"
      ldoc = pdoc
      lcust = "0001"
      lvtyp = "1"
      Pvtyp = "1"
      lvpmod = "1"
      lvsrce = "1"
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
                 replace invoice with 1
                REPLACE PAYMENT WITH 0
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
      replace serialno with APPYMTS->serialno
      replace REG        WITH APPYMTS->paytype
       replace sTIME       WITH ltime
        replace lpo with appymts->lpo
         replace pay_method with APPYMTS->pay_method
         replace recdate with appymts->inv_date
         if empty(recdate)
         replace recdate with appymts->order_date
         endif
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
       
 PROCEDURE vnstat_FLOAT2
    SELECT vnstat
    replace bal_due with VENDOR->bal_due
   if vnstat->bal_due < 0
         replace bal_due_cr with VENDOR->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENDOR->bal_due
         replace bal_due_cr with 0
         endif
    replace total with vnstat->total + appynlin->total
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
       REPLACE BL_AMT WITH TOTAL  + APPYMTS->al_amt
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   select VENDOR
             replace l_INV_date with APPYMTS->order_date
             replace l_INV_amt with appynlin->total + L_INV_amt
            
  
  PROCEDURE FRIGHTER_RTN

           
                  LOCAL L1,L2,L3,L4,L5,LERR
                  LERR = .T.
   L1 = FGNFPUR->SOURCE
   L2 = FGNFPUR->FTYP
   L3 = FGNFPUR->PMOD
   L4 = FGNFPUR->FRIGHTER_N
   L5 = FGNFPUR->SYSTEM
   L6 = FGNFPUR->DOCTYPE
   L7 = FGNFPUR->ORDER_DATE
   psource = L1
   pftyp = L2
   ppmod = L3
   pfrighter = L4
    SELECT FRIGHTER
   SEEK psource+pftyp+ppmod+pfrighter
   IF FOUND()
   LERR = .F.
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
   IF .NOT. LERR .AND. PBAL
   IF .NOT. (EMPTY(L1) .AND. EMPTY(L2) .AND. EMPTY(L3) .AND. EMPTY(L4) .AND. EMPTY(L5) ;
    .AND. EMPTY(L6) .AND. EMPTY(L7))
   SELECT FRTRNAGE
   SEEK L1+L2+L3+L4+DTOS(L7)
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE SOURCE WITH L1
   REPLACE FTYP WITH L2
   REPLACE PMOD WITH L3
   REPLACE FRIGHTER_N WITH L4
  *REPLACE SYSTEM WITH L5
 * REPLACE DOCTYPE WITH L6
   REPLACE TRANS_DATE WITH L7
   REPLACE TOTAL WITH 0
   REPLACE ALLOC_AMT WITH 0
  *REPLACE INVOICE WITH 0
 * REPLACE PAYMENT WITH 1
   endif
     REPLACE TOTAL WITH TOTAL - FGNFPUR->TOTAL
    ENDIF
    ENDIF
    IF .NOT. LERR .AND. PDep
    SELECT FRIGHTER
     SEEK psource+pftyp+ppmod+pfrighter
    REPLACE CDEP_AMT WITH CDEP_AMT - FGNFPUR->TOTAL
    ENDIF
    IF .NOT. LERR .AND. PBal
       DO FRSTAT_RTN
    ENDIF
    
    
 PROCEDURE FRSTAT_RTN
  
 
     pdate = APPYMTS->order_date
    pcustno =  APPYMTS->frighter_n
    PFTYP = APPYMTS->Ftyp
    PPMOD = APPYMTS->PMOD
    PSOURCE = APPYMTS->SOURCE
    
   pdoc = FGNFPUR->DOCTYPE
   
    
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
     replace bal_due with bal_due + appynlin->TOTAL
     replace l_pay_amt with appynlin->TOTAL + L_pay_amt
     
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
              replace bal_due with bal_due + appynlin->TOTAL
                  replace l_pay_amt with appynlin->TOTAL + L_pay_amt
                    replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
                  
   
        
      SELECT frighter
       SEEK psource+pftyp+ppmod+pfrighter
      REPLACE BAL_DUE with   BAL_DUE + appynlin->TOTAL 
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
     select frcustbl
     REPLACE BAL_DUE with   BAL_DUE + appynlin->TOTAL 
      SELECT frshtrn
    replace bal_due with frighter->bal_due
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->bal_due
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + appynlin->TOTAL
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   select frighter
    SEEK psource+pftyp+ppmod+pfrighter
             replace l_pay_date with APPYMTS->order_date
             replace l_pay_amt with appynlin->TOTAL + L_pay_amt
             pdate = frshtrn->trans_date

    
PROCEDURE frshtrn_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lpmod,lsource,lmm,lyy,ld
  
      lref = APPYMTS->order_no
      ldate = APPYMTS->order_date
      tdate = APPYMTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "AP"
      ldoc = FGNFPUR->DOCTYPE
      lcust = APPYMTS->frighter_n
      lftyp = APPYMTS->Ftyp
      PFTYP = APPYMTS->Ftyp
      lpmod = APPYMTS->pmod
      lsource = APPYMTS->source
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
      replace serialno with APPYMTS->serialno
      replace REG        WITH APPYMTS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH APPYMTS->LPO
         replace pay_method with APPYMTS->pay_method
         replace recdate with appymts->inv_date
          if empty(recdate)
         replace recdate with appymts->order_date
         endif
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
       
 
 
 PROCEDURE BRANCH_RTN
  
 
    pdate = APPYMTS->order_date
    pcustno =  APPYMTS->PAY_N
    Pvtyp = APPYMTS->PAYTYP
    Pvpmod = APPYMTS->PAYMOD
    Pvsrce = APPYMTS->PAYSRCE
    
    pdoc = "54"
         IF appymts->pay_method = "Cheque"
         pdoc = "54"
         endif
          IF appymts->pay_method = "FC Cash"
         pdoc = "51"
         endif
          IF appymts->pay_method = "Float Cash"
         pdoc = "62"
         endif
            IF appymts->pay_method = "Capital"
         pdoc = "50"
         endif
            IF appymts->pay_method = "Hqdebit"
         pdoc = "59"
         endif
            IF appymts->pay_method = "Loan"
         pdoc = "58"
         endif
            IF appymts->pay_method = "Credit(card)"
         pdoc = "64"
         endif
            IF appymts->pay_method = "Bank Debit"
         pdoc = "60"
         endif
          IF appymts->pay_method = "M-Money"
         pdoc = "67"
         endif
           IF appymts->pay_method = "FT" .or. appymts->pay_method = "EFT"
         pdoc = "61"
         endif
    
    DO VNBRANCH_RTN1
       
   
        
      SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE + appynlin->TOTAL 
      IF VENDOR->BAL_DUE > 0
      REPLACE VENDOR->BAL_DUE_CR with  0
      REPLACE VENDOR->BAL_DUE_DR with  VENDOR->BAL_DUE
      ELSE
      REPLACE VENDOR->BAL_DUE_DR with  0
      REPLACE VENDOR->BAL_DUE_CR with  VENDOR->BAL_DUE * -1
      ENDIF
     
     
    DO VNBRANCH_RTN2
    
PROCEDURE VNBRANCH_RTN1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lvtyp,lvpmod,lvsrce,lmm,lyy,ld
  
      lref = APPYMTS->order_no
      ldate = APPYMTS->order_date
      tdate = APPYMTS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "AP"
      ldoc = pdoc
      lcust = APPYMTS->PAY_N
      lvtyp = APPYMTS->PAYTYP
      Pvtyp = APPYMTS->PAYTYP
      lvpmod = APPYMTS->PAYMOD
      lvsrce = APPYMTS->PAYSRCE
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
               replace invoice with 0
                REPLACE PAYMENT WITH 1
                replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
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
      replace serialno with APPYMTS->serialno
      replace REG        WITH APPYMTS->paytype
       replace sTIME       WITH ltime
        replace lpo with appymts->lpo
         replace pay_method with APPYMTS->pay_method
         replace recdate with appymts->inv_date
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
       
 PROCEDURE VNBRANCH_RTN2
    SELECT vnstat
    replace bal_due with VENDOR->bal_due
   if vnstat->bal_due < 0
         replace bal_due_cr with VENDOR->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENDOR->bal_due
         replace bal_due_cr with 0
         endif
    replace total with vnstat->total - appynlin->total * -1
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
       REPLACE BL_AMT WITH TOTAL  - APPYMTS->al_amt
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   select VENDOR
             replace l_pay_date with APPYMTS->order_date
             replace l_pay_amt with  L_pay_amt - appynlin->total
            
            