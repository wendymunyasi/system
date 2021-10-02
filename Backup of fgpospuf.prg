Procedure fgpospuf
PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET AUTOSAVE ON
    SET VIEW TO "fgpospur.QBE"
       PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 set reprocess to 1000
 
select APOGRNUP
set order to mkey
SELECT FGMAST
set order to mkey
SET SAFETY ON
pstockno = ""
      eofAPOGRLIN = .f.
      pposted = .t.
      select fgcoy
      go top
      if pospost = "Yes"
      ppfc = .t.
      else
      ppfc = .f.
      endif
      LOCAL LBAD
      LBAD = .F.
      select apogrns
         select APOGRLIN
         set filter to (typ > "00" .and. typ <= "9Z" .and. ;
         ((qty = 0 .and. plevel > 4) .or. (total < 0 .and. .not. qty = 0)))
         go top
         if  .not. EOF()
         LBAD = .T.
         endif
         IF .NOT. LBAD
    set filter to grn_no = apogrns->grn_no .and. empty(post_date) .AND. .NOT. (total = 0 ;
   .and. qty = 0)  .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(grn_stk_no)
   ? "passed here 1"
           go top
                if .not. eof()
            do
                do line_rtn
                until eofAPOGRLIN
 select APOGRNSN
                go top
                if eof()
                append blank
                endif
                replace GRN_no with APOGRNS->GRN_no
              
              ENDIF
              ENDIF
                select fgcoy
              flush
              SET AUTOSAVE OFF
             
              
              CLOSE DATABASES
PROCEDURE END_RTN
      CLOSE DATABASES
procedure line_rtn
      begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
? "PASSED 2"
            local l1,l2,l11,l22,l3,l4, lerr
            lerr = .t.
            select APOGRNUP
            seek APOGRLIN->grn_no+dtos(apogrns->grn_date)+APOGRLIN->grn_stk_no+APOGRLIN->DDE_TIME
            if .not. found()
            append blank
            replace grn_no with APOGRLIN->grn_no
            replace grn_date with apogrns->grn_date
            replace grn_stk_no with APOGRLIN->grn_stk_no
            REPLACE DDE_TIME WITH APOGRLIN->DDE_TIME
            do cont_rtn
                select APOGRLIN  
            replace post_date with date()
   SELECT APOGRNUP
    replace post_date with date()
            endif
         
   COMMIT()
   
   select APOGRLIN  
   IF .NOT. EOF()
       SKIP
       ENDIF
    IF EOF()
     eofAPOGRLIN = .T.
    ENDIF
procedure cont_rtn
             
            select fgcoy
      go top
      if pospost = "Yes"
      ppfc = .t.
      else
      ppfc = .f.
      endif
          
         if ppfc
     pyear = str(year(apogrns->grn_date),4)
   pmonth = str(month(apogrns->grn_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "24"
    pshno = apogrns->shiftno
    pshdate = apogrns->grn_date
    pshid = apogrns->shiftid
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    else
      pyear = str(year(apogrns->grn_date),4)
   pmonth = str(month(apogrns->grn_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "24"
    pshno = "0"
    pshdate = apogrns->grn_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
   
    PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,P14,pvendor,;
            pven,PST15F,Pfgmast,Papogrns,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pvtyp,p18,p19,p20,ptsdte,pvsrce,pvtyp,pvpmod
            local lld1,lld2
            
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   if ppfc
      pshdate = apogrns->grn_date
    pshno = apogrns->shiftno
    pshid = apogrns->shiftid
    else
  pshno = "0"
    pshdate = apogrns->grn_date
    pshid = "0"
   
   endif
    
      PTYP = APOGRLIN->TYP
      PCLA = APOGRLIN->CLA
      PCOD = APOGRLIN->COD
      PCOY = APOGRLIN->COY
      PDIV = APOGRLIN->DIV
      PCEN = APOGRLIN->CEN
      PSTO = APOGRLIN->STO
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
        psys   = "PO"  && point of sale
      pdoc   = "24"  && Purchase
      porder = apogrns->grn_no
         pstockno = APOGRLIN->grn_stk_no
  
      IF PSHM
                 select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
     if  found() .and. rlock()
      do fgpurchs_3018RTN
      else
      Wait "Record lock failed/No Record in Stock Master. Try again Later"
      quit
      endif
      else
   do   fgpurchs_3018RTN
      endif
        
      
  Procedure fgpurchs_3018RTN
        select fgpurchs
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with APOGRLIN->coy
            replace div with APOGRLIN->div
            replace cen with APOGRLIN->cen
              replace sto with APOGRLIN->sto
              replace st_coy with APOGRLIN->coy
            replace st_div with APOGRLIN->div
            replace st_cen with APOGRLIN->cen
              replace st_sto with APOGRLIN->sto
            replace typ with APOGRLIN->typ
            replace cla with APOGRLIN->cla
            replace cod with APOGRLIN->cod
            replace qty with APOGRLIN->QTY
               replace sale_qty  with APOGRLIN->volume
                 replace NONVAT with APOGRLIN->NONVAT
             replace NONVAT_AMT with APOGRLIN->NONVAT_AMT
              replace NET_AMT with APOGRLIN->NET_AMT
              IF TYP = "00" 
            REPLACE DIP_Q_BOF WITH APOGRLIN->SUPPLY_TOT
            REPLACE DIP_Q_AOF WITH APOGRLIN->RETURN_AMT
            ELSE
             REPLACE DIP_Q_BOF WITH 0
            REPLACE DIP_Q_AOF WITH 0
           ENDIF
           REPLACE OFLD_TIME WITH APOGRNS->ORDER_STAT
            REPLACE DRIVER WITH APOGRNS->SHIPNAME
            REPLACE OFLD_NAME WITH APOGRNS->OFFNAME
            REPLACE GRN_ASHIP WITH APOGRNS->GRN_ASHIP
            REPLACE SHIP_NAME WITH APOGRNS->ASHIPNAME
            replace transp with apogrns->transp
            IF TYP = "00"
            REPLACE EXP_DIP_Q WITH DIP_Q_BOF + QTY 
              REPLACE OFLD_VAR WITH DIP_Q_AOF - EXP_DIP_Q + sale_qty
            IF .NOT. QTY = 0
            REPLACE OFLD_VPERC WITH (DIP_Q_AOF - EXP_DIP_Q + sale_qty)/QTY * 100
            ENDIF
            ENDIF
            
            replace return_qty with 0
            replace unit_cost with APOGRLIN->cost_price
            replace list_price with APOGRLIN->list_price
            replace new_bal with 0
            replace total with APOGRLIN->total
             replace tax_rate with APOGRLIN->tax_rate
            replace tax_amt with APOGRLIN->tax_amt
             replace job_order with apogrns->job_order
            replace off with apogrns->grn_off
             replace reg  with apogrns->reg
            replace gross_amt with APOGRLIN->gross_amt
                replace pay_method  with apogrns->pay_method
             replace lpo with apogrns->lpo
           REPLACE vsrce WITH apogrns->vsrce
          REPLACE vtyp WITH apogrns->vtyp
           REPLACE vpmod WITH apogrns->vpmod
           REPLACE vendor_N WITH apogrns->vendor_N
            REPLACE source WITH apogrns->source
          REPLACE ftyp WITH apogrns->ftyp
           REPLACE pmod WITH apogrns->pmod
           REPLACE frighter_n WITH apogrns->frighter_n
           
        replace shift_no with apogrns->shiftno
           replace shift_id with apogrns->shiftid
           replace job_order with apogrns->job_order
           replace inv_no with apogrns->inv_no
           replace inv_date with apogrns->inv_date
           if empty(inv_date)
           replace inv_date with order_date
           endif
           if pay_method = "FC Cash" .or. pay_method = "Cash"
           replace inv_date with order_date
           endif
              replace cashier_no with apogrns->cashier_no
           replace bcoy  with apogrns->bcoy
           replace bcen  with apogrns->bcen
           replace bdiv  with apogrns->bdiv
           replace bsto  with apogrns->bsto
           replace btyp with apogrns->btyp
           replace bcla with apogrns->bcla
           replace bcod with apogrns->bcod
           replace dde_date with date()
           replace dde_user with PLUSER
           replace dde_time with time()
           REPLACE SERIALNO WITH apogrns->SERIALNO
           if empty(inv_no)
           replace inv_no with serialno
           endif
           REPLACE SHIFT_NO WITH pshno
           REPLACE SHIFT_ID WITH pshid
      if pshm .and. .not. typ='00'
      select fgmast
      replace m_var with m_var + APOGRLIN->QTY
      endif
      unlock
         