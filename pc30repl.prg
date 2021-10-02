
Procedure pc30repl
    PARAMETER BUSER,BLEVEL
     
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET VIEW TO "pc30repl.QBE"
     PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
  set reprocess to 10000
       set safety off
    select VNDOCREF
   set order to docref
   SET SAFETY ON
   select st15f
   if flock()
   set order to mkey
   GO TOP
    select scashrec
    if flock()
   set order to mkey
   select cashiers
   if flock()
   set order to cashier
   select VENDOR
   if flock()
   set order to VENDOR
   select VNCOUNT
   if flock()
    set order to mkey
   select VNSTAT
   if flock()
   set order to mkey
   select pcrepupd
   set order to mkey
    
  pposted = .t.
  select pcrepls
  go top
  if .not. eof()
     eofpcreplin = .f.
         select pcreplin
    set filter to order_no = PCREPLS->order_no .and. empty(post_date) .AND. .NOT. TOTAL = 0 ;
     .AND. .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. ;
      .NOT. EMPTY(STO) .AND. .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(CLA) .AND. .NOT. EMPTY(COD) 
              go top
                if .not. eof()
                do
                do line_rtn
                until eofpcreplin
                select pcreplsn
                go top
                if eof()
                append blank
                endif
                replace order_no with pcrepls->order_no
            endif
            endif
            select fgcoy
            flush
            else
            wait 'Unable to Lock Tables - Try Again Later!'
            quit
            endif
            endif
            endif
            endif
            endif
            endif
            
            close databases
procedure line_rtn
     PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,PPCREPLS,pstt,pvtyp,pvsrce,pvpmod,p20,ptsdate
            local lld1,lld2, lerr
              begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
            lerr = .t.
            select pcrepupd
       seek pcreplin->order_no+dtos(pcrepls->order_date)+pcreplin->stock_no+pcreplin->dde_time
            if .not. found()
            append blank
            replace order_no with pcreplin->order_no
            replace order_date with pcrepls->order_date
            replace stock_no with pcreplin->stock_no
            replace dde_time with pcreplin->dde_time
            lerr = .f.
            endif
            if empty(pcreplin->post_date)
            lerr = .f.
            endif
         if .not. lerr   
              ptsdate = pcrepls->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = PCREPLS->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp = pcreplin->TYP
      pcla = pcreplin->CLA
      pcod = pcreplin->COD
      pcoy = pcreplin->COY
      pdiv = pcreplin->DIV
      pcen = pcreplin->CEN
      psto = pcreplin->STO
       porder = pcreplin->order_no
       pvtyp = ""
       pcustno = ""
       pvsrce = ""
       pvpmod = ""
       p20 = ""
       PCASHRNO = ""
          PPCREPLS = .F.
          select PCREPLS
                 pcustno = PCREPLS->VENDOR_N
                  pvtyp = vtyp
                        pvsrce = vsrce
                       pvpmod = vpmod              
                    pcashrno = PCREPLS->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PPCREPLS = .T.
      pVENDOR = PCREPLS->VENDOR_N
               porder = PCREPLS->order_no
                        pvtyp = PCREPLS->vtyp
                          pcashrno = PCREPLS->cashier_no
                          pvsrce = PCREPLS->vsrce
                          pvpmod = PCREPLS->vpmod
                    
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
   IF EMPTY(OFF)
   REPLACE OFF WITH pcrepls->OFF
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
          
     IF EMPTY(pcreplin->POST_DATE)  .AND. PCUS
    DO pcreplin_RTN2
    if pcrepls->pay_method = "Hqcheque" .and. .not. empty(pcrepls->source) .and. ;
     .not. empty(pcrepls->dtyp) 
        do hqcheque_rtn
        endif
        if pcrepls->pay_method = "Hqcash" .and. .not. empty(pcrepls->hqvsrce) .and. ;
     .not. empty(pcrepls->hqvtyp) .and. .not. empty(pcrepls->hqvpmod) .and.  .not. empty(pcrepls->hqv_n) 
        do hqcash_rtn
        endif
        
         
        
     select pcreplin
   REPLACE POST_DATE WITH DATE()
  select pcrepupd
   REPLACE POST_DATE WITH DATE()
   endif
   endif
   commit()
        flush
    select pcreplin
    if .not. eof()
   skip
   endif
   if eof()
   eofpcreplin = .t.
   endif
  
   
    
  PROCEDURE pcreplin_RTN2
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11
  ? "PASSED HERE"
           l7 = pcreplin->order_no
         l8 = pcrepls->ORDER_DATE
         l9 = pcreplin->stock_no
         l10 = "PC"
         l11 = "51"
         if empty(l8)
         l8 = PCREPLS->order_date
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
               replace total with pcreplin->total
                  replace off with PCREPLS->off
            replace pay_method  with PCREPLS->pay_method
            REPLACE vsrce WITH PCREPLS->vsrce
            REPLACE vtyp WITH PCREPLS->vtyp
            REPLACE vpmod WITH PCREPLS->vpmod
           REPLACE VENDOR_N WITH PCREPLS->VENDOR_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace Bcoy  with PCREPLS->bcoy
             replace Bdiv  with PCREPLS->bdiv
             replace Bcen  with PCREPLS->bcen
             replace Bsto  with PCREPLS->bsto
            replace Btyp  with PCREPLS->btyp
           replace Bcla  with PCREPLS->bcla
           replace Bcod  with PCREPLS->bcod
           replace cashier_no with PCREPLS->cashier_no
           replace coy  with pcreplin->coy
           replace div   with pcreplin->div
           replace cen  with pcreplin->cen
           replace sto  with pcreplin->sto
           replace typ  with pcreplin->typ
           replace cla  with pcreplin->cla
           replace cod  with pcreplin->cod
      replace inv_date with pcrepls->inv_date
      if empty(inv_date)
      replace inv_date with order_date
      endif
               replace lpo with pcreplin->ref
           replace serialno with PCREPLS->serialno
           REPLACE SHIFT_NO WITH PCREPLS->SHIFTNO
           REPLACE SHIFT_ID WITH PCREPLS->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           replace qty with 0, unit_cost with 0, new_bal with 0, list_price with 0, tax_rate with 0
           replace gross_amt with total, tax_amt with 0, job_order with "C0", return_qty with 0
           replace st_coy with coy, st_div with div, st_cen with cen, st_sto with sto
           
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
              D1 = DTOS(PCREPLS->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = pcreplin->TOTAL * -1
                 PTVAT = 0
              PCOY = pcreplin->COY
              PDIV = pcreplin->DIV
              PCEN = pcreplin->CEN
              PTYP = pcreplin->TYP
              PSTO = pcreplin->STO
              PCLA = pcreplin->CLA
              PCOD = pcreplin->COD
       Pvtyp = PCREPLS->vtyp
       Pvpmod = PCREPLS->vpmod
       Pvsrce = PCREPLS->vsrce
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = pcreplin->TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
     if PCREPLS->PAY_METHOD= "FC Cash"
        pcash = .T.
        else
        pcash = .F.
     endif
     if PCREPLS->PAY_METHOD= "Capital" .or. PCREPLS->PAY_METHOD= "Hqcheque"
        pcapital = .T.
        else
        pcapital = .F.
     endif
        pcredit = .F.
        if PCREPLS->PAY_METHOD= "Cheque" .or. PCREPLS->PAY_METHOD= "Bank Debit"  
        pcheque = .T.
        else
        Pcheque = .F.
     endif
        if .not. pcash .and. .not. pcredit .and. .not. pcheque  .and. .not. pcapital
        pother = .T.
        endif
        if pother
        pcredit = .t.
        pother = .f.
        endif
           ptdate = PCREPLS->ORDER_date
              Pvtyp = PCREPLS->vtyp
              Pvpmod = PCREPLS->vpmod
              Pvsrce = PCREPLS->vsrce
              
              pttotal = pcreplin->total * -1
                   DO DRTRAN_RTN
      DO SCASHREC_RTN
         
 PROCEDURE DRTRAN_RTN
        pcoy = pcreplin->coy
    pdate = PCREPLS->order_date
    pcustno =  PCREPLS->VENDOR_n
    Pvtyp = PCREPLS->vtyp
    Pvpmod = PCREPLS->vpmod
    Pvsrce = PCREPLS->vsrce
    
    pdoc = "51"
     DO vnstat_RTN1
       SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE - pcreplin->TOTAL 
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
  
      lref = PCREPLS->order_no
      ldate = PCREPLS->order_date
      tdate = PCREPLS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "PC"
      ldoc = '51'
      lcust = PCREPLS->VENDOR_n
      lvtyp = PCREPLS->vtyp
      Pvtyp = PCREPLS->vtyp
      lvpmod = PCREPLS->vpmod
      lvsrce = PCREPLS->vsrce
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
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                 replace alloc_AMT with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with PCREPLS->serialno
      replace REG        WITH PCREPLS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH pcreplin->ref
         replace pay_method with PCREPLS->pay_method
         replace recdate with pcreplin->other_date
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
    replace total with vnstat->total + pcreplin->total * -1
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
       REPLACE BL_AMT WITH TOTAL  + PCREPLS->al_amt
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   select VENDOR
             replace l_pay_date with PCREPLS->order_date
             replace l_pay_amt with pcreplin->total + L_pay_amt
            
     
    
  PROCEDURE SCASHREC_RTN
  if pcash
   select scashrec
                     replace purch with purch +  pcreplin->TOTAL
                       select st15f
        go top
         REPLACE SHIFT_POST WITH DATE()
                     replace cash_COY with cash_COY + pcreplin->TOTAL
                     ENDIF
                                        select st15f
        go top
          replace batchamt with batchamt + pcreplin->TOTAL
 
Procedure hqcheque_rtn
             
            l7 = pcrepls->order_no
         l9 = pcreplin->stock_no
         l10 = "PC"
         l11 = "51"
         l8 = PCREPLS->order_date   
       
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
            replace total with pcreplin->total
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
            replace off with PCREPLS->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with "Hq Cheque"
            replace pay_method  with PCREPLS->pay_method
            REPLACE source WITH PCREPLS->source
            REPLACE FTYP WITH PCREPLS->FTYP
            REPLACE PMOD WITH PCREPLS->PMOD
           REPLACE FRIGHTER_N WITH PCREPLS->FRIGHTER_N
           replace shift_no with pshno
           replace shift_id with pshid
             replace Bcoy  with PCREPLS->dcoy
              replace Bdiv  with PCREPLS->ddiv
               replace Bcen  with PCREPLS->dcen
                replace Bsto  with PCREPLS->dsto
            replace Btyp  with PCREPLS->dtyp
           replace Bcla  with PCREPLS->dcla
           replace Bcod  with PCREPLS->dcod
           replace coy  with "1"
           replace div   with "5"
           replace cen  with "1"
           replace sto  with "A1"
           replace typ  with "C0"
           replace cla  with "00"
           replace cod  with "01"
              replace recdate with pcrepls->inv_date
              if empty(recdate)
              replace recdate with order_date
              endif
              replace inv_date with recdate
              replace lpo with pcreplin->ref
           replace serialno with PCREPLS->serialno
           REPLACE SHIFT_NO WITH PCREPLS->SHIFTNO
           REPLACE SHIFT_ID WITH PCREPLS->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
    
        DO hqcheque_RTN1
     
  
  
  
  
 PROCEDURE hqcheque_RTN1
    PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,PPCREPLS,pstt,pftyp,psource,ppmod,p20,ptsdate
            local lld1,lld2
              ptsdate = pcrepls->order_date
     select st15f
    go top
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
      ptyp = fgtran->typ
      pcla = fgtran->CLA
      pcod = fgtran->COD
      pcoy = fgtran->COY
      pdiv = fgtran->DIV
      pcen = fgtran->CEN
      psto = fgtran->STO
       porder = pcrepls->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       PCASHRNO = ""
          PPCREPLS = .F.
          select PCREPLS
                 pcustno = PCREPLS->frighter_N
                 pftyp = FTYP
                 psource = SOURCE
                 ppmod = PMOD              
                 pcashrno = PCREPLS->cashier_no
                    if empty(pcashrno)
                      pcashrno = "1"
                      endif
           
                   PPCREPLS = .T.
      pfrighter = PCREPLS->frighter_N
               porder = PCREPLS->order_no
                        pftyp = PCREPLS->ftyp
                          pcashrno = PCREPLS->cashier_no
                          psource = PCREPLS->source
                          ppmod = PCREPLS->pmod
                    
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
  replace off with PCREPLS->off
   endif
   IF  EMPTY(OFF)
     replace off with PCREPLS->off
     ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
   
                     
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
              D1 = DTOS(PCREPLS->order_DATE)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
             PYR = RIGHT(PYY,1)
               PTQTY = 0
               PTTOTAL = pcreplin->TOTAL * -1
                 PTVAT = 0
              PCOY = fgtran->COY
              PDIV = fgtran->DIV
              PCEN = fgtran->CEN
              PTYP = fgtran->TYP
              PSTO = fgtran->STO
              PCLA = fgtran->CLA
              PCOD = fgtran->COD
       PFTYP = PCREPLS->Ftyp
       PPMOD = PCREPLS->PMOD
       PSOURCE = PCREPLS->SOURCE
        
              ptcost = 0
              ptexp = 0
              PCSS = 0
              PCRS = 0
              PCSSA = pcreplin->TOTAL * -1
               PCRSA = 0
               PTVOLS =  0
                    
              pother = .F.
       select st15f
   GO TOP
         replace shift_post with date()
   select scashrec
                     replace purch with purch +  pcreplin->TOTAL
                      REPLACE RECEPTS WITH RECEPTS + pcreplin->total
                      REPLACE CHQS WITH CHQS + pcreplin->total
  
                       select st15f
                       GO TOP
                     replace cash_COY with cash_COY + pcreplin->TOTAL
                     replace st15f->CASH_DEBT with st15f->CASH_DEBT  + pcreplin->total
         
              replace chqs_bank with chqs_bank + pcreplin->total
                replace st15f->CASH_MERCH with st15f->CASH_MERCH + pcreplin->total
    
          
        
Procedure hqcash_rtn
               select pcrepls
                 pcustno = hqv_n
                 pvtyp = hqvtyp
                 pvsrce = hqvsrce
                 pvpmod = hqvpmod              
                   
           
      pVENDOR = PCREPLS->hqv_n
               porder = PCREPLS->order_no
                        pvtyp = PCREPLS->hqvtyp
                           pvsrce = PCREPLS->hqvsrce
                          pvpmod = PCREPLS->hqvpmod
                           SELECT VENDOR
           SEEK pvsrce+pvtyp+pvpmod+pcustno
         DO vnstat_hq_RTN1
       SELECT VENDOR
      REPLACE VENDOR->BAL_DUE with   VENDOR->BAL_DUE + pcreplin->TOTAL 
      IF VENDOR->BAL_DUE > 0
      REPLACE VENDOR->BAL_DUE_CR with  0
      REPLACE VENDOR->BAL_DUE_DR with  VENDOR->BAL_DUE
      ELSE
      REPLACE VENDOR->BAL_DUE_DR with  0
      REPLACE VENDOR->BAL_DUE_CR with  VENDOR->BAL_DUE * -1
      ENDIF
     
     
    DO vnstat_hq_RTN2
    
PROCEDURE vnstat_hq_RTN1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lvtyp,lvpmod,lvsrce,lmm,lyy,ld
  
      lref = PCREPLS->order_no
      ldate = PCREPLS->order_date
      tdate = PCREPLS->order_date
      ld = dtos(tdate)  && yyyymmdd
      lyy = left(ld,4)
      ld = left(ld,6)
      lmm = right(ld,2)
      lsys = "PC"
      pdoc = '51'
      ldoc = '51'
      lcust = PCREPLS->hqv_n
      lvtyp = PCREPLS->hqvtyp
      Pvtyp = PCREPLS->hqvtyp
      lvpmod = PCREPLS->hqvpmod
      lvsrce = PCREPLS->hqvsrce
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
             
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                 replace alloc_AMT with 0
     
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with PCREPLS->serialno
      replace REG        WITH PCREPLS->paytype
       replace sTIME       WITH ltime
        replace LPO        WITH pcreplin->ref
         replace pay_method with PCREPLS->pay_method
         replace recdate with pcreplin->other_date
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
       
 PROCEDURE vnstat_hq_RTN2
    SELECT vnstat
    replace bal_due with VENDOR->bal_due
   if vnstat->bal_due < 0
         replace bal_due_cr with VENDOR->bal_due* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENDOR->bal_due
         replace bal_due_cr with 0
         endif
    replace total with vnstat->total + pcreplin->total
    if vnstat->total < 0
         replace amt_cr with vnstat->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with vnstat->total
         replace amt_cr with 0
      endif
       REPLACE BL_AMT WITH TOTAL  + PCREPLS->al_amt
      
      if bl_amt < 0
      replace bl_cr with bl_amt * -1
      replace bl_dr with 0
      else
      replace bl_cr with 0
      replace bl_dr with bl_amt
      endif
   select VENDOR
             replace l_pay_date with PCREPLS->order_date
             replace l_pay_amt with  L_pay_amt - pcreplin->total
            