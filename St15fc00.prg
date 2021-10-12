**************************************************************************
*  PROGRAM:      St15fc00.prg
*
*
******************************************************************************

procedure St15fc00
   PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
  *if blevel > 8
   if empty(pluser) .or. empty(plevel)
   quit
   endif
close databases
   private preceipt, pminishift
   pminishift = .f.
   preceipt = .f.
   
#include <Messdlg.h>
  
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Closing/Opening Shiftmaster in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .f.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 30-100 ss",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    MousePointer 11,;
    FontSize 11,;
    ColorNormal "N+"
PROGREPS.OPEN()
 create session
set talk off
set ldCheck off
set escape off
set decimals to 4
clear program
do St15fc00_rtn1 WITH PLUSER,PLEVEL && ok
*FLUSH
   close tables
   progreps.close()
   clear program
   close databases
 DO ST15FC01_RTN WITH PLUSER,PLEVEL && ok
 *FLUSH
   close databases
   clear program
 DO ST15FC02_RTN  WITH PLUSER,PLEVEL && ok
   close databases
   clear program
   *FLUSH
   close tables
   clear program
   DO ST15FC04_RTN WITH PLUSER,PLEVEL  && ok
   *FLUSH
   do st15fc05_rtn WITH PLUSER,PLEVEL
 * if .not. pminishift
   do fgclpgp_rtn  WITH PLUSER,PLEVEL
   *FLUSH
   do fgjcadp_rtn WITH PLUSER,PLEVEL
   *FLUSH
   DO arinvp_rtn WITH PLUSER,PLEVEL
   *FLUSH
   do aricdsp_rtn WITH PLUSER,PLEVEL
  
   close tables
   set view to "fgshupdt.QBE"
   do fgshupdt_rtn1 WITH PLUSER,PLEVEL
   close databases
    set view to "st15fc07.QBE"
       
       set safety on
       *FLUSH
       close databases
        
      InformationMessage("Shift Closed Normally - BACKUP TO EXTERNAL DISK AND RUN REPORT UPDATES NOW!", "Congratulations! ")
      set safety off
     quit
procedure fgshupdt_rtn1
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
select fgshupst  && stock update
      append blank
      replace dde_date with date()
     replace dde_time with time()
     replace dde_user with pluser
select fgshupiv  && inventory update
      append blank
      replace dde_date with date()
     replace dde_time with time()
     replace dde_user with pluser
     select fgshupdr  && debtors update
      append blank
      replace dde_date with date()
     replace dde_time with time()
     replace dde_user with pluser
     select fgshuppu  && purchase update
      append blank
      replace dde_date with date()
     replace dde_time with time()
     replace dde_user with pluser
     select fgshupsl  && sales update
      append blank
      replace dde_date with date()
     replace dde_time with time()
     replace dde_user with pluser
     
    
      
     close DATABASES

Procedure St15fc00_rtn1
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
   private EOFST15FWKF,EOFST15F, PVERIFY,PSHIFTDATE,PSHIFTNO,PVALUE,eoffgmastf;
   ,PPRICE,PVAT,PCASHQTY, PCASHAMT,OPSHIFTDATE,OPSHIFTNO, PSTOCKNO,PQTYVAR,PDATE,PREF,;
   PDD,PMM,PYY,PDIV,PCOY,PCEN,PSTO,PTYP,PCLA,PCOD,pcash,pcashVAR,pphyfreq,pcashfreq,psp,;
    pcash,pcredit,pcheque,pcard,pother,pspcoy,pspdiv,ptdate,pttotal,ptqty,ptvat,pyr,ptexp,ptcost,;
    padjin,padjout,ptranin,ptranout,pcss,pcsa,pcspa,pcrs,pcrsa,pcrp,pcrpa,pshift,ptranserr,;
    ptvols,ptvolp,pvol,PCSP,pcssa,ptcsale,psal,ppur,ptran,padj,ppcv,ppv,poth,prec,psdate,psuser,;
    pchangesmade,psubtyp,psubcla,psub,pshdate,pshno,pshm,eoffgmast,pshmm,pshyy,pshiftid,opshiftid,;
    pwkvols,pwhole,pmini,pshid, shdate,pshm,eoffgmast,pns0,pns1,pns2, ppchange,pns3,;
    pshmm,pshyy,pshid,pcount,pyear,pmonth,pdoc,PDAY,PXSHDATE,PXSHNO,PXSHID,PCRQTY,ppdocref,pdips,prem,pshstockno
    prem = .f.
    pshstockno = 0
    pdips = .f.
    ppdocref = ""
    pxshdate = {}
    pnmin = .f.
   SET VIEW TO "St15fc00.QBE"
   select dayfgmas
    set order to mkey
   select fgjcsals
   go top
   if .not. eof()
   prem = .t.
   endif
    select fglpsals
   go top
   if .not. eof()
   prem = .t.
   endif
    select fglusals
   go top
   if .not. eof()
   prem = .t.
   endif
    select fgviscad
   go top
   if .not. eof()
   prem = .t.
   endif
    select arwinvce
   go top
   if .not. eof()
   prem = .t.
   endif
   select jnwinvce
   go top
   if .not. eof()
   prem = .t.
   endif
    select ngljnls
   go top
   if .not. eof()
   prem = .t.
   endif
    select  fgpurchs
   go top
   if .not. eof()
   prem = .t.
   endif
   select  fgpaymts
   go top
   if .not. eof()
   prem = .t.
   endif
   select  fgtransf
   go top
   if .not. eof()
   prem = .t.
   endif
   SELECT ARDRCPST
   GO TOP
    if .not. eof()
   prem = .t.
   endif
   SELECT JNDRCPST
   GO TOP
    if .not. eof()
   prem = .t.
   endif
    SELECT frshtrn
   GO TOP
    if .not. eof()
   prem = .t.
   endif
   if prem
          InformationMessage("Post Remote Work Station Transactions to Shift Master First", "Sorry!")
 QUIT
 endif
 select st15f
 go top
 select scashrec
 set filter to .not. shift_date = st15f->shift_date .or. .not. shift_no = st15f->shift_no .or. ;
 .not. shift_id = st15f->shift_id .or. empty(cashr_no) .or. empty(cen) .or. ;
 empty(sto) .or. empty(cen) .or. empty(sto).or. empty(typ).or. empty(cla).or. empty(cod)
 go top
 if .not. eof()
          InformationMessage("Invalid Data in Cashiers Reconciliation Report.", "Sorry!")
 QUIT
 endif
 
  set filter to
  go top
   select shiftbk
   go bottom
   if .not. shift_date = st15f->shift_date .and. .not. shift_no = st15f->shift_no ;
    .and. .not. shift_id = st15f->shift_id .and. .not. coy = st15f->coy    
       InformationMessage("Verify Shiftmaster Again - Shiftbk Error", "Sorry!")
 QUIT
 endif
   pchange = .f.
   SELECT FGCOD1
   SET FILTER TO TYP = "00" .AND. ACTIVE = "Yes" .and. .not. new_p = sale_price  && there is a price change
   go top
   if .not. eof()
   pchange = .t.
   endif
   IF plevel < 4
   PCHANGE = .T.
   ENDIF
   select fgdacash
   set order to mkey
   select fgmocash
   set order to mkey
   select fgnjcads
   go top
   if .not. eof()
   pnmin = .t.
   endif
   select arnivces
   go top
   if .not. eof()
   pnmin = .t.
   endif
   select ARNICADS
   go top
   if .not. eof()
   pnmin = .t.
   endif
    select FGNCLPGS
   go top
   if .not. eof()
   pnmin = .t.
   endif
   
       SELECT fgcoy
    GO TOP
                  set safety off
                  
              local lrun, lnext
                  lnext = .f.
                  lrun = .f.
                  
     select shcongt0
     go top
     if eof()
     lrun = .t.
     endif
     if .not. lrun
     if .not. empty(end_time)
      lnext = .t.
      endif
      endif
      
     
    
    if .not. lrun .and. .not. lnext
   
  InformationMessage("Shift Closing Interrupted in Phase 0", "Sorry!")
 
    quit
   
   endif
   
 if lrun  
 SELECT FGSTKFLW
 SET ORDER TO MKEY
     select fgsprice
     set order to shiftid
     ppchange = .f.
         set safety off
  select fgmastf
  zap
  set safety on 
  set order to mkey
  select fgmast
  set order to mkey
  select shstmast
  set order to mkey
  SELECT FGTAXTYP
  SET ORDER TO TAX_TYPE
  select fgcod
  set order to mkey
  select shcatsum
  set order to mkey
  select scashrec
  set order to mkey
  select cashiers
  set order to cashier
  select dacoysum
  set order to mkey
  select fgcoy
  go top
  pbrkdow = fgcoy->brk13
  if pbrkdow < 1 .or. pbrkdow > 7
  pbrkdow = 7
  endif
 
  if st15f->shift_no = '1' .and. fgcoy->contact = 'Yes'
  select fgcoy
  replace contact with 'No'
  endif
  pns0 = .f.
  pns1 = .t.  
  pns2 = .f.
  pns3 = .f.
  if .not. FGCOY->CONTACT =  'Yes'
  if fgcoy->no_shifts = "2" .and. fgcoy->f1dr = "13"
  pns0 = .t.
  pns1 = .f.
  pns2 = .f.
  pns3 = .f.
  endif
  if fgcoy->no_shifts = "2" .and. fgcoy->f1dr = "12"
  pns0 = .f.
  pns1 = .f.
  pns2 = .f.
  pns3 = .t.
  endif
  if fgcoy->no_shifts = "2" .and. .not.  (fgcoy->f1dr = "13" .or. fgcoy->f1dr = "12")
  pns0 = .f.
  pns1 = .f.
  pns2 = .t.
  pns3 = .f.
  endif
  endif
  SET SAFETY OFF
  select st15fwkf
  ZAP
  SET SAFETY ON
  select st15f
  set order to mkey
 SET FILTER TO .NOT. EMPTY(SHIFT_POST) .or. ;
  (typ > "00" .and. .not. op_m_q = 0 .and. (cl_m_q = 0 .and. trans_in = 0  .and. trans_out = 0;
   .and. sold_qty = 0 .and. cr_sal_qty = 0)) .or. (.not. sold_qty = 0 .and. (exp_sales = 0 .and. .not. promotion = 'Yes'))
 go top
 if  .NOT. eof()
 InformationMessage("Check Errors in the Shiftmaster", "Note!")
 quit
 endif
 set filter to
 GO TOP
 IF .NOT. ROUND((ST15F->a_c_inhand + ST15F->op_c_hand - ST15F->cash_bank),2);
 = ROUND(ST15F->cl_c_hand,2)
 InformationMessage("Verify Cash Position again", "Sorry!")
 ? (a_c_inhand + op_c_hand - cash_bank)
quit
* CANCEL
 ENDIF
 
 pedips = .f.
 select st15f
 set filt to typ="00"
 go top
 if .not. eof()
 pedips = .t.
 endif
 set filter to
 go top
 if  pedips
 pdips = .t.
 select shiftcla
 set order to skey
 eofst15f=.f.
 select st15f
 set filt to typ="00" .AND. PHY_QTY > 0
 go top
 if .not. eof()
 do
    do shiftcla_stks
 until eofst15f
endif
eofst15f = .f.
if .not. pdips
 InformationMessage("VERIFY SHIFT DIPS AGAIN", "Sorry!")
 QUIT
ENDIF
endif
select st15f
set filter to
go top
eofshiftcla = .f.
pshcla = .f.
perrtype = ''
SELECT FGMAST
SET FILTER TO
GO TOP
if pdips .and. pedips 
select shiftcla
SET FILTER TO TYP = "00"
go top
   do
      do shiftcla_mas_rtn
 until eofshiftcla
 if pshcla 
  InformationMessage("CHECK AND ENTER DIPS AGAIN "+perrtype, "Sorry!")
  quit
 ENDIF
 endif
 SELECT SHIFTCLA
 SET FILTER TO

 SELECT SHIFTCAS
 GO TOP
 IF .NOT. round(OP_C_HAND,0) = round(A_CASH,0)
 InformationMessage("Check Opening Cash In Hand in Shift Verification", "Sorry!")
 quit
 ENDIF
 SELECT SHIFTBK
 SET ORDER TO SHIFTID
 GO BOTTOM
 IF .NOT. ROUND(CASH_SHORT,0) = 0
  InformationMessage("Cash Shortage/Excess Should be Zero Before closing the shift", "Note!")
    quit
    endif
    eofscashrec = .f.
    ptcash = 0
    select scashrec
    go top
    if .not. eof()
       do 
       do ptcash_rtn
       until eofscashrec
   endif
   eofcashrec = .f.
    IF .NOT. ROUND(ptcash,0) = 0
  InformationMessage("Cash Shortage/Excess Should be Zero in Cashiers Reconciliation", "Note!")
    quit
    endif

 select shsum
 go top
 if .not. OFNAME = PLUSER
  InformationMessage("Invalid Officer Closing the Shift", "Note!")
    quit
    endif
 select st15f
    pwhole = .f.
    pmini = .f.
    if okclose = DATE() .and. .not. date() < st15f->shift_date
   pwhole =.t.
   endif
   if okmini = DATE() .and. .not. date() < st15f->shift_date
   pmini = .t.
   endif
   if pmini .and. pwhole
    InformationMessage("Enter Current Date in the Shiftmaster Whole/Mini Shift Field", "Note!")
    quit
    endif
    IF .NOT. PMINI .AND. .NOT. PWHOLE
   InformationMessage("Enter Current Date in the Shiftmaster Whole/Mini Shift Field", "Note!")
    QUIT
    ENDIF
    if pmini .and. .not. pchange .AND. plevel > 3
    InformationMessage("Mini Shift Not Applicable where there is no price change", "Note!")
    QUIT
    endif
    
 LOCAL L1,L2
   L1 = dow(st15f->shift_date) 
     L2 = L1
     if pmini .and.  val(st15f->shift_id) > 9
      InformationMessage("Limit for Closing Mini-shifts reached", "Sorry!")
    quit
     endif
     
     if fgsys->opsys = "Yes"
      select kensback
    set order to shiftid
    seek dtos(ST15F->SHIFT_DATE)+ST15F->SHIFT_NO+ST15F->SHIFT_ID
    if .not. found()
    InformationMessage("Back up to the hard disk before closing the shift", "Sorry")

    quit
   endif
endif 
     if pmini
     pxshdate = st15f->shift_date
     pxshno = st15f->shift_no
     pxshid = str(val(st15f->shift_id)+1,1)
     
 pminishift = .t.
     select fgcoy
replace shift_date with pxshdate
replace shift_no with pxshno
replace shift_id with pxshid
     else
     ? "whole"
      pminishift = .f.
     do whole_rtn
         endif
    pphyfreq = 0
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
   endif
   pdoc = "FS"
     pshno = st15f->shift_no
    pshid = st15f->shift_id
    pshdate = st15f->shift_date
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    if empty(pshno) .or. empty(pshdate) .or. empty(pshid)
      InformationMessage("Check Shiftmaster", "Oops!")
 
    quit
    endif    
    IF PXSHDATE > DATE()+1
     InformationMessage("New Shift date greater than today's date plus 1", "Sorry!")
     QUIT
     ENDIF
     EOFSHIFTCLP = .F.
     SELECT SHIFTCLA
     SET ORDER TO sKEY
   SELECT SHIFTCLP
   GO TOP
   IF .NOT. EOF()
      DO
         DO SHIFTCLP_RTN
      UNTIL EOFSHIFTCLP
      ENDIF
 
   
set safety off
select shiftclp
zap
set safety on
select dacoysum
SET ORDER TO MKEY
**


   SELECT ST15F
   go top
    pchangesmade = .f.
   pcashfreq = 0
   pcash = .F.
   PSTOCKNO = "01"
   OPSHIFTDATE = {}
     oPSHIFTNO = ""
     OPSHIFTID = ""
   eoffgmastf = .F.
   PVERIFY = .F.
   pshiftdate = {}
   pshiftno = ""
   ****
  
   SET EXACT ON
   EOFST15F = .F.   
  
   
        select shcongt0
     append blank
     replace shift_date with st15f->shift_date
     replace shift_no with st15f->shift_no
     replace shift_id with st15f->shift_id
     replace start_user with pluser
     replace start_date with date()
     replace start_time with time()
     replace end_time with ""
   
   select st15f  && start off shift
   go top
   IF .NOT. EOF()
     select fgdacash
        seek st15f->coy+dtos(st15f->shift_date)
        if .not. found()
        append blank
        replace coy with st15f->coy
        replace shift_date with st15f->shift_date
        replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with st15f->op_c_hand
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
        replace dr_staff with 0
        replace chq_sales with 0
        replace mbk_money with 0
        replace mbd_money with 0
        replace mbp_money with 0
      endif
      replace cl_c_hand with st15f->cl_c_hand
       local l1,l2,l3,l4
         l1 = dtos(fgdacash->shift_date) && yyyymmdd
         l2 = left(l1,6) && yyyymm
         l3 = right(l2,2) && mm
         l4 = left(l2,4) && yyyy
         l1 = fgdacash->coy
         select fgmocash
         seek l1+l4+l3
         if .not. found()
         append blank
         replace coy with l1
         replace yy with l4
         replace mm with l3
         replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with st15f->op_c_hand
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace mbk_money with 0
        replace mbd_money with 0
        replace mbp_money with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
        replace dr_staff with 0
        replace chq_sales with 0
        
      endif
      replace cl_c_hand with st15f->cl_c_hand
         DO
            DO ST15F_CLOSE_RTN
               UNTIL  EOFST15F
               eoffgmast = .f.
         
      select fgmast
      set filter to (typ = "00" .and. left(sto,1) = "T") .or. ;
       (typ = "10" .and. left(sto,1) = "M") && fuel tanks/drums only
      go top
      if .not.  eof()
      do 
      do St15fc00_end_shift_rtn
      until eoffgmast
     endif
     endif
     EOFSHIFTCLA = .F.
     pstkerror = .f.
     SELECT SHIFTCLA
     GO TOP
     IF .NOT. EOF()
        DO
           DO SHIFTCLA_RTN
        UNTIL EOFSHIFTCLA
    ENDIF
       if .not. pstkerror
      select shcongt0
      replace end_time with time()
      endif
   endif
           set safety on
  
procedure shiftcla_stks
         local l1,l2,l3,l4,l5
            l1 =  st15f->coy
            l2 =  st15f->typ
            l3 =  st15f->cla
            l4 =  st15f->cod
            l5 =  st15f->st_sto
            select shiftcla
            seek l1+l2+l3+l4+l5
               if .not. found() 
               pdips = .f.
               InformationMessage("VERIFY SHIFT DIPS AGAIN - NOT FOUND" , "Sorry!")
               QUIT
               else
              if .not. round(phy,0) = round(st15f->phy_qty,0)
                InformationMessage("VERIFY SHIFT DIPS AGAIN - PHY NOT AGREEING" , "Sorry!")
               QUIT
            
              pdips = .f.
              endif
               endif
               select st15f
               skip
               if eof()
               eofst15f=.t.
               endif

procedure shiftcla_mas_rtn
   local l1,l2,l3,l4,l5,l6
      l1 = shiftcla->coy
      l2 = "2"
      l3 = "0"
      l4 = shiftcla->sto
      l5 = shiftcla->typ
      l6 = shiftcla->cla
      l7 = shiftcla->cod
      select fgmast
      seek l1+l2+l3+l4+l5+l6+l7
      if .not. found()
      pshcla = .t.
      perrtype = 'no fgmast record '+l4
      else
      if .not.  (round(bbf,0) = round(shiftcla->bbf,0)  .and. ;
      round((cr_purch+cs_purch+adj_in+trans_in-adj_out-trans_out),0) = round(shiftcla->purchases,0))
      pshcla = .t.
      perrtype = 'fgmast/shiftcla balances '+l4
      endif
      endif
     if shiftcla->phy = 0 .and.    shiftcla->on_hand > 999 .and. shiftcla->qty_var > 999
        pshcla = .t.
        perrtype = 'Dips Required '+l4
        endif
    select shiftcla
    if .not. eof()
    skip
    endif
    if eof()
    eofshiftcla = .t.
    endif
      
        
procedure SHIFTCLP_RTN
      local l1,l2,l3,l4,l5,l6
      l1 = shiftclp->coy
      l2 = shiftclp->typ
      l3 = shiftclp->cla
      l4 = shiftclp->cod
      l5 = shiftclp->sto
      select shiftcla
      seek l1+l2+l3+l4+l5
      if .not. found()
      append blank
      replace coy with l1
      replace typ with l2
      replace cla with l3
      replace cod with l4
      replace sto with l5
      replace shift_var with 0
      replace bbf_phy with 0
      replace bcf with 0
      replace qty2 with 0
      replace qty with 0
      replace price_var with 0
      replace new_p with 0
      replace old_p with 0
      replace manual with 0
      replace qty_v_p with 0
      replace qty_v_s with 0
      replace c_sales_q with 0
      replace qty_var with 0
      replace exp_cash with 0
      replace exp_sales with 0
      replace non_cash with 0
      replace a_cash with 0
      replace sold_qty with 0
      replace on_hand with 0
      replace phy with 0
      replace trans with 0
      replace purchases with 0
      replace bbf with 0
      replace adjs with 0
      endif
      replace sold_qty with sold_qty+shiftclp->sold_qty
      select shiftclp
      skip
      if eof()
      eofshiftclp = .t.
      endif

PROCEDURE SHIFTCLA_RTN
      SELECT FGSTKFLW
         SEEK DTOS(PSHDATE)+PSHNO+PSHID+SHIFTcLA->TYP+SHIFTCLA->CLA+SHIFTCLA->COD
         IF .NOT. FOUND()
         APPEND BLANK
         REPLACE SHIFT_DATE WITH PSHDATE
         REPLACE SHIFT_NO WITH PSHNO
         REPLACE SHIFT_ID WITH PSHID
         REPLACE TYP WITH SHIFTCLA->TYP
         REPLACE CLA WITH SHIFTCLA->CLA
         REPLACE COD WITH SHIFTCLA->COD
         REPLACE BBF WITH 0
         REPLACE PURCHASES WITH 0
         REPLACE SOLD_QTY WITH 0
         REPLACE ON_HAND WITH 0
         REPLACE PHY WITH 0
         REPLACE SHIFT_VAR WITH 0
         REPLACE QTY_VAR WITH 0
         ENDIF
         REPLACE BBF WITH BBF + SHIFTCLA->BBF
         REPLACE PURCHASES WITH PURCHASES  + SHIFTCLA->PURCHASES
         REPLACE SOLD_QTY WITH SOLD_QTY + SHIFTCLA->SOLD_QTY
         REPLACE ON_HAND WITH ON_HAND + SHIFTCLA->ON_HAND
         REPLACE PHY WITH PHY + SHIFTCLA->PHY
         REPLACE SHIFT_VAR WITH SHIFT_VAR  + SHIFTCLA->SHIFT_VAR
         REPLACE QTY_VAR WITH QTY_VAR + SHIFTCLA->QTY_VAR
         if shiftcla->typ = '00' .and. left(shiftcla->sto,1)= 'T'
         select fgmast
         seek '1'+'2'+'0'+shiftcla->sto+shiftcla->typ+shiftcla->cla+shiftcla->cod
         if found() .and. .not. on_hand = shiftcla->on_hand
         pstkerror = .t.
         endif
         endif
         SELECT SHIFTCLA
         SKIP
         IF EOF()
            EOFSHIFTCLA = .T.
            ENDIF
            
Procedure ptcash_rtn
   select scashrec
   
ptcash = ptcash + scashrec->A_cash  - (SCASHREC->Exp_sales;
+ recepts  - paymnts - purch - SCASHREC->Non_cash ;
- SCASHREC->BBKVISA-SCASHREC->COYVISA-SCASHREC->GENVISA-chqs - dbcredits)
select scashrec
skip
if eof()
eofscashrec = .t.
endif

Procedure whole_rtn
   if pns1  && one shift per day 
     ? "pns1"
      do whole_rtn1
      endif
   if pns0 && two shifts per day except pbrkdow (Sunday) which has one shift
     ? "pns0"
      do whole_rtn0
      endif
    if pns2 && two shifts per day
    ? "pns2"
      do whole_rtn2
      endif
       if pns3 && two shifts per day except Saturday and Sunday which have one shift
     ? "pns0"
      do whole_rtn3
      endif
      select fgmast
      set filt to .not. m_var = 0
      replace all m_var with 0
      set filter to
 
Procedure whole_rtn2
      pxshdate = st15f->shift_date
      pxshno = "1"
      pxshid = "0"
      if st15f->shift_no = "1"  && evening
                    pxshno = "0"
                pxshdate = st15f->shift_date + 1  && 1
          endif
          select fgcoy
replace shift_date with pxshdate
replace shift_no with pxshno
replace shift_id with pxshid
Procedure whole_rtn0
LOCAL L1,L2
   L1 = dow(st15f->shift_date) 
     L2 = L1
       pxshid = "0"
       if l1 = pbrkdow .and. st15f->shift_no = "1"  && dow evening
                 pxshno = "1"
                pxshdate = st15f->shift_date + 1 && 1
                else
         if st15f->shift_no = "1"
                 pxshno = "0"
                pxshdate = st15f->shift_date + 1 && 1
                else
                pxshno = "1"
                 pxshdate = st15f->shift_date
                 endif
          endif
          select fgcoy
replace shift_date with pxshdate
replace shift_no with pxshno
replace shift_id with pxshid

Procedure whole_rtn3
LOCAL L1,L2
   L1 = dow(st15f->shift_date) 
     L2 = L1
       pxshid = "0"
       if l1 = 6 .and. st15f->shift_no = "1"  && friday evening
                 pxshno = "1"
                pxshdate = st15f->shift_date + 1 && 1
                else
           if l1 = 7   && saturday 
                 pxshno = "1"
                pxshdate = st15f->shift_date + 1 && 1
                else  
         if st15f->shift_no = "1"
                 pxshno = "0"
                pxshdate = st15f->shift_date + 1 && 1
                else
                pxshno = "1"
                 pxshdate = st15f->shift_date
                 endif
          endif
          endif
          select fgcoy
replace shift_date with pxshdate
replace shift_no with pxshno
replace shift_id with pxshid
Procedure whole_rtn1
LOCAL L1,L2
   select st15f
   go top
   L1 = dow(st15f->shift_date) 
     L2 = L1
       pxshid = "0"
       if fgcoy->f1dr = "07"  && seven days per week
       if l1  > 1 .and. l1 < 6
                pxshno = "0"
                pxshdate = st15f->shift_date + 1 && 1
                else
                if l1 = 6
             *   pxshno = "1"
                pxshno = "0"  && new
                pxshdate = st15f->shift_date + 1 && 1
                else
                pxshno = "0"
                 pxshdate = st15f->shift_date + 1 && 1  && new
               *   pxshdate = st15f->shift_date + 2
                 endif
          endif
          else
           if l1  > 1 .and. l1 < 6 && sx days per week
                pxshno = "0"
                pxshdate = st15f->shift_date + 1 && 1
                else
                if l1 = 6
                pxshno = "1"
                 pxshdate = st15f->shift_date + 1 && 1
                else
                pxshno = "0"
                   pxshdate = st15f->shift_date + 2
                 endif
          endif
          endif
select fgcoy
replace shift_date with pxshdate
replace shift_no with pxshno
replace shift_id with pxshid

PROCEDURE St15fc00_end_shift_rtn
     LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,ER1,LD1,LD2,LD3,LD4,LD5;
     , wk1,wk2,l14,wk3,L15,L24
   
         L7 = fgmast->TYP
         L8 = fgmast->CLA
         L9 = fgmast->COD
         L10 = fgmast->COY
         L11 = fgmast->DIV
         L12 = fgmast->CEN
         L13 = fgmast->STO
          
        SELECT fgmastf
        SEEK dtos(opshiftdate)+opshiftno+opshiftid+L10+L11+L12+L13+L7+L8+L9
        IF FOUND()
        delete
        endif
        do fgmast_update_rtn      
         SELECT fgmast
           SKIP
           IF EOF()
           EOFfgmast = .T.
        ENDIF
PROCEDURE fgmast_UPDATE_RTN
  SELECT fgmastF
     append blank
     replace shift_date with opshiftdate
     replace shift_no with opshiftno
     replace shift_id with opshiftid
     replace coy with fgmast->coy
      replace div with fgmast->div
       replace cen with fgmast->cen
        replace sto with fgmast->sto
         replace typ with fgmast->typ
          replace cla with fgmast->cla
           replace cod with fgmast->cod
           replace nshdate with fgcoy->SHIFT_DATE
           replace nshno with fgcoy->SHIFT_NO
           replace nshid with fgcoy->SHIFT_ID
           replace phy_qty with fgmast->phy
           replace on_hand with fgmast->on_hand
           select fgmast
           if .not. month(fgmastf->shift_date) = month(fgmastf->nshdate) .and. typ = "00" && fuels only
           replace bbf with phy
           replace on_hand with bbf
           else
           replace bbf with on_hand
           endif
          
         replace alloc with 0
         replace trans_in with 0
         replace trans_out with 0
         replace purch with 0
         replace sales with 0
         replace adj_in with 0
         replace adj_out with 0
         REPLACE CR_PURCH WITH 0
         REPLACE CS_PURCH WITH 0
         REPLACE CR_SALES  WITH 0
         REPLACE CS_SALES WITH 0
         REPLACE BBF_PHY WITH PHY_QTY
         REPLACE TEMP_QTY WITH 0
         REPLACE TEMP_PURCH WITH 0
*         REPLACE PHY_QTY WITH 0
         REPLACE BCF WITH 0
         REPLACE M_PHY WITH 0
       *REPLACE M_VAR WITH 0
         REPLACE OPEN_BAL WITH 0
         REPLACE LAST_PHY WITH 0
         REPLACE  TEMP_PHY WITH 0

PROCEDURE ST15F_CLOSE_RTN
      LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,ER1,l14
        LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,ER1,l14
    
         L1 = ST15F->SHIFT_DATE
         L2 = ST15F->SHIFT_NO
         l14 = st15f->shift_id
         L3 = ST15F->COY
         L4 = ST15F->DIV
         L5 = ST15F->CEN
         L6 = ST15F->STO
         L7 = ST15F->TYP
         L8 = ST15F->CLA
         L9 = ST15F->COD
         L10 = ST15F->ST_COY
         L11 = ST15F->ST_DIV
         L12 = ST15F->ST_CEN
         L13 = ST15F->ST_STO
         pcoy = l10
         pdiv = l11
         pcen = l12
         psto = l13
         pshdate = l1
         pshid = l14
         pshno = l2
         ptyp = l7
         pcla = l8
         pcod = l9
         
         ER1 = .F.
             select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD 
      if .not. found()
         append blank
         replace coy with pcoy
         replace div with pdiv
         replace cen with pcen
         replace typ with ptyp 
         replace cla with pcla
         replace cod with pcod
         replace sto with psto
         replace bbf with 0
         replace on_hand with 0
         replace phy with 0
         replace alloc with 0
         replace trans_in with 0
         replace trans_out with 0
         replace purch with 0
         replace sales with 0
         replace adj_in with 0
         replace adj_out with 0
         REPLACE CR_PURCH WITH 0
         REPLACE CS_PURCH WITH 0
         REPLACE CR_SALES  WITH 0
         REPLACE CS_SALES WITH 0
         REPLACE BBF_PHY WITH 0
         REPLACE TEMP_QTY WITH 0
         REPLACE TEMP_PURCH WITH 0
         REPLACE PHY_QTY WITH 0
         REPLACE BCF WITH 0
         REPLACE M_PHY WITH 0
         REPLACE M_VAR WITH 0
         REPLACE OPEN_BAL WITH 0
         REPLACE LAST_PHY WITH 0
         REPLACE  TEMP_PHY WITH 0
         endif
         if st15f->f1cashr = "Yes"
    replace phy with st15f->phy_qty
    endif
      if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecourt
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      endif           
 select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      
      replace cs_sales_a with 0
      replace cr_sales_a with 0
      replace cs_purch_a with 0
      replace cr_purch_a with 0
      
      replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
    ENDIF
 DO CLOSE_SHIFTS_RTN
     
        SELECT ST15F
       if .not. eof()
          SKIP
       endif
       IF EOF()
          EOFST15F = .T.
      ENDIF
      
    
PROCEDURE CLOSE_SHIFTS_RTN
 LOCAL L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,ER1,LD1,LD2,LD3,LD4,LD5,l14
 PRIVATE PREFNO
    PSHIFTDATE = ST15F->SHIFT_DATE
    LD1 = DTOS(PSHIFTDATE)
    LD2 = RIGHT(LD1,2)	&& DAY
    LD3 = LEFT(LD1,6)	
    LD4 = RIGHT(LD1,2)	&& YEAR
    LD5 = RIGHT(LD3,2)	&& MONTH  
    if val(ld5) = 1
    ld5 = "JA"
    ENDIF
    if val(ld5) = 2
    ld5 = "FE"
    ENDIF
    if val(ld5) = 3
    ld5 = "MR"
    ENDIF
    if val(ld5) = 4
    ld5 = "AP"
    ENDIF
    if val(ld5) = 5
    ld5 = "MA"
    ENDIF
    if val(ld5) = 6
    ld5 = "JN"
    ENDIF
    if val(ld5) = 7
    ld5 = "JU"
    ENDIF
    if val(ld5) = 8
    ld5 = "AU"
    ENDIF
    if val(ld5) = 9
    ld5 = "SE"
    ENDIF
    if val(ld5) = 10
    ld5 = "OC"
    ENDIF
    if val(ld5) = 11
    ld5 = "NO"
    ENDIF
    if val(ld5) = 12
    ld5 = "DE"
    ENDIF
    
    PREFNO = ld2+LD5+LD4
    PSHIFTNO = ST15F->SHIFT_NO
    pshiftid = st15f->shift_id
         l14 = st15f->shift_id
         L1 = ST15F->SHIFT_DATE
         L2 = ST15F->SHIFT_NO
         L7 = ST15F->TYP
         OPSHIFTDATE = L1
         OPSHIFTNO = L2
          opshiftid = l14
         L8 = ST15F->CLA
         L9 = ST15F->COD
         L10 = ST15F->ST_COY
         L11 = ST15F->ST_DIV
         L12 = ST15F->ST_CEN
         L13 = ST15F->ST_STO
         pcoy = l10
         pdiv = l11
         pcen = l12
         psto = l13
         ptyp = l7
         pcla = l8
         pcod = l9
         
         SELECT ST15F
         REPLACE ST15F->DATE_CLOSE WITH DATE()
         REPLACE ST15F->TIME_CLOSE WITH TIME()
         REPLACE ST15F->USER_CLOSE WITH pluser
         REPLACE ST15F->ERRORS WITH "CLOSED - NO ERRORS"
         replace post_date with date()
        
        replace nshdate with fgcoy->shift_date
        replace nshid with fgcoy->shift_id
        replace nshno with fgcoy->shift_no
        
          REPLACE OSHDATE WITH ST15F->SHIFT_DATE
               REPLACE OSHNO WITH ST15F->SHIFT_NO
               REPLACE OSHID WITH ST15F->SHIFT_ID
               IF ST15F->typ = "00"
      IF ST15F->F1CASHR = "Yes"
      SELECT fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD 
      REPLACE fgmast->PHY WITH ST15F->PHY_QTY	&& new physical count in fgmast
      endif 
      ENDIF
       ptcost = 0
       PCRQTY = 0
      IF ST15F->typ = "00"
      PCRQTY = ST15F->cr_sal_qty
      ENDIF
 PCASHQTY = St15F->SOLD_QTY - ST15F->cr_sal_qty && WILL TAKE QTY SOLD AS PER METERS
      PCASHAMT = St15F->exp_cash
      select fgcod
              seek ST15F->typ+ST15F->cla+ST15F->cod
              if found()
              ptcost = PCASHQTY * fgcod->cost_price             
              endif
           
      IF ST15F->typ = "00" .or. (st15f->typ = "10" .and. st15f->st_cen = "2")
       IF ST15F->F1CASHR = "Yes" 
      select shstmast
        seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
      replace phy with fgmast->phy
      replace yy with left(dtos(shift_date),4)
      replace mm with right(left(dtos(shift_date),6),2)
      if typ = "00" .and. .not. fgcod->sale_price = fgcod->new_p
      select fgsprice
      SET FILTER TO TYP = ST15F->TYP .AND. CLA = ST15F->CLA .AND. COD = ST15F->COD ;
       .AND. SHIFT_DATE = PSHDATE .AND. SHIFT_NO = PSHNO .AND. SHIFT_ID = PSHID
       GO BOTTOM
      IF .NOT. EOF()
         replace qty with qty+fgmast->phy
         endif
         endif
      ENDIF
      ENDIF
     
              SELECT FGTAXTYP
              SEEK FGCOD->TAX_TYPE
              IF FOUND()
              PRATE = RATE
              ELSE
              PRATE = 0
              ENDIF
              
      PCASHVAR =   st15f->a_c_inhand - ST15F->EXP_CASH
      IF .NOT. (PCASHAMT = 0 .AND. PCASHQTY = 0) .and. empty(st15f->date_pass)
      DO fgshtran_CASH_SALES_RTN
      
    select st15f
  *  REPLACE NONVAT WITH fgshtran->NONVAT
   * REPLACE NONVAT_AMT WITH fgshtran->NONVAT_AMT
     REPLACE gross_amt  WITH fgshtran->gross_amt
    REPLACE tax_amt    WITH fgshtran->tax_amt   
     REPLACE total  WITH fgshtran->total  
    REPLACE vat       WITH fgshtran->tax_rate  
    replace date_pass with date()
    
    endif
              
PROCEDURE      fgshtran_CASH_SALES_RTN
 SELECT fgshtran
          APPEND BLANK
          **
       *  IF ST15F->OFF >'000' .AND. ST15F->OFF <='999'
          REPLACE OFF WITH ST15F->OFF
        * ENDIF
            replace system with "FS"
         replace doctype with "20"
         replace order_no with PREFNO
         replace order_date with pshdate
         replace stock_no with "01"
         replace coy with pcoy
            replace div with pdiv
            replace cen with pcen
              replace sto with psto
              replace st_coy with st15f->coy
            replace st_div with st15f->div
            replace st_cen with st15f->cen
              replace st_sto with st15f->sto
              replace shift_no with pshno
               replace shift_id with pshid
                replace serialno with PREFNO
                replace dde_date with date()
                replace dde_time with time()
                replace dde_user with pluser
                replace cashier_no  with st15f->cashier_no 
              
            replace typ with st15f->typ
            replace cla with st15f->cla
            replace cod with st15f->cod
            replace qty with PCASHQTY * - 1
            replace unit_cost with st15f->cost_price
            replace new_bal with 0
          
   **
            replace total with PCASHAMT
            replace list_price with ST15F->SALE_PRICE
            replace tax_rate with st15f->vat
             replace pay_method  with "Cash"
           REPLACE source WITH "1"
          REPLACE ftyp WITH "1"
           REPLACE PMOD WITH "1"
           REPLACE FRIGHTER_N WITH "0001"
             **
          pvatrate = list_price - fgcod->snonvat
          pnonvatamt = round(PCASHQTY * fgcod->snonvat,2) && non vatable amount
          replace sprice with fgcod->snonvat
          pvatamt = total - pnonvatamt
          replace total_amt with pnonvatamt
           
           REPLACE TAX_AMT WITH ROUND(pvatamt/(100+TAX_RATE)*TAX_RATE,2) && VAT PORTION
           
           REPLACE GROSS_AMT WITH pvatamt - TAX_AMT && GROSS AMT
        
                
              **
         
               PTTOTAL = fgshtran->TOTAL
                 PTVAT = tax_amt
              PCOY = fgshtran->COY
              PDIV = fgshtran->DIV
              PCEN = fgshtran->CEN
              PTYP = fgshtran->TYP
              PSTO = fgshtran->STO
              PCLA = fgshtran->CLA
              PCOD = fgshtran->COD
             
              ptexp = 0
              padjin = 0

     
                          pother = .F.
         pcash = .T.
           pcredit = .F.
        Pcard = .F.
            ptdate = fgshtran->order_date
        **
        pshstockno = pshstockno + 1
     pmain_key = LTRIM("FS"+"20"+dtos(pshdate)+pshno+pshid+PREFNO+ltrim(str(pshstockno)+ltrim(fgcoy->party_id)))
      select fgorinvs
      append blank
    REPLACE MAIN_KEY WITH PMAIN_KEY
       replace system with "FS"
         replace doctype with "20"
         replace order_no with PREFNO
         replace order_date with pshdate
         replace stock_no with ltrim(str(pshstockno))
         replace coy with pcoy
            replace div with pdiv
            replace cen with pcen
              replace sto with psto
              replace st_coy with st15f->coy
            replace st_div with st15f->div
            replace st_cen with st15f->cen
              replace st_sto with st15f->sto
              replace shift_no with pshno
               replace shift_id with pshid
                replace serialno with PREFNO
                replace dde_date with date()
                replace dde_time with time()
                replace dde_user with pluser
                replace cashier_no  with st15f->cashier_no 
              replace off with fgshtran->off
              replace driver with off
              replace soff with off
              replace scashier with cashier_no
            replace typ with st15f->typ
            replace cla with st15f->cla
            replace cod with st15f->cod
            replace qty with PCASHQTY * - 1
            replace unit_cost with st15f->cost_price
            replace new_bal with 0
            replace unl with 0
            replace dis with 0
            replace svc with 0
            replace lub with 0
            replace mileage with 0
          if typ='00'.and. cla='10'
          replace unl with 1
          else
          if typ='00'.and. cla='50'
          replace dis with 1
          else
          if typ='10'
          replace lub with 1
          else
          replace svc with 1
          endif
          endif
          endif
   **
            replace total with PCASHAMT
            replace list_price with ST15F->SALE_PRICE
            replace tax_rate with st15f->vat
             replace pay_method  with "Cash"
           REPLACE source WITH "1"
          REPLACE ftyp WITH "1"
           REPLACE PMOD WITH "1"
           REPLACE FRIGHTER_N WITH "0001"
             **
          pvatrate = list_price - fgcod->snonvat
          pnonvatamt = round(PCASHQTY * fgcod->snonvat,2) && non vatable amount
          replace sprice with fgcod->snonvat
          pvatamt = total - pnonvatamt
          replace total_amt with pnonvatamt
            REPLACE TAX_AMT WITH ROUND(pvatamt/(100+TAX_RATE)*TAX_RATE,2) && VAT PORTION
           
           REPLACE GROSS_AMT WITH pvatamt - TAX_AMT  && GROSS AMT
            replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with '1110001'
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
         replace tax_amt with 0
         replace gross_amt  with 0
         replace nonvat_amt  with 0
         replace nonvat with fgcod->snonvat
         replace list_price with fgshtran->list_price
         replace cost_price with  fgshtran->unit_cost
         replace tax_rate with  fgshtran->tax_rate
      endif
         replace nonvat with fgshtran->sprice
         replace list_price with fgshtran->list_price
         replace cost_price with  fgshtran->unit_cost
         replace tax_rate with  fgshtran->tax_rate

                          pcashrno = fgshtran->cashier_no
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
   SELECT CASHIERS
   SEEK pcashrno
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
      
   
                 select shcatsum
                  seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                       replace cs_sal_qty with cs_sal_qty + pcashqty
                        replace cs_sal_shs with cs_sal_shs + pcashamt
                      replace tax_amt with tax_amt + fgshtran->tax_amt
                      replace gross_amt with gross_amt + ((fgshtran->tax_amt/fgshtran->tax_rate)*100)
                      replace nonvat_amt with nonvat_amt  + (fgshtran->qty*-1*fgshtran->sprice)
                    select shstmast
                      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
    
                  replace on_hand with on_hand - pcashqty
                        replace cs_sales with cs_sales + pcashqty
                       replace cs_sales_a with cs_sales_a + pcashamt
                  
                    if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecou
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - pcashqty
       replace sales with sales + pcashqty
       endif
              SELECT fgmast
              seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD 
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - pcashqty
              replace cs_sales with cs_sales + pcashqty
                
       select DACOYSUM
          seek dtos(pshdate)+pcoy
          if .not. found()
          append blank
          replace coy with pcoy
          replace shift_date with pshdate
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0

          endif
          replace cs_sal_shs with cs_sal_shs + pcashamt 
         
          
**************************************************************************
*  PROGRAM:     St15fc01.prg
*
*
*******************************************************************************

Procedure st15fc01_RTN
 PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
  
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Updating Shift Stock Calculations in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power,will take 1-15 ss",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set view to "st15fc01.QBE"
SET REPROCESS TO -1
select st15f
      do ST15FC01_RTN1
      close tables
      progreps.close()

Procedure ST15FC01_RTN1
   private eofshiftcla,ptyp,pcla,pcod, pcoy,ptyp,pcla,pshdate,pshno,pshid,pyy,pmm,ppdate,;
   psale,prec,pret,pdvr,PSDATE
   eofshiftcla = .f.
   
   SELECT ST15F
   GO TOP
                  select fgstkcal
                  set order to mkey
                  
                  SELECT MONTHWST
                  SET ORDER TO MKEY
                  SELECT MONTHWET
                  SET ORDER TO MKEY
                   local lrun, lnext
                  lnext = .f.
                  lrun = .f.
        
     select shcongt1
     go top
     if eof()
     lrun = .t.
     endif
     if .not. lrun
     if .not. empty(end_time)
      lnext = .t.
      endif
      endif
     if .not. lrun .and. .not. lnext
   
   InformationMessage("Shift Closing Disrupted in Phase 1", "Sorry!")
 
    quit
   
   endif
   
 if lrun  
     select shcongt1
     append blank
     replace shift_date with st15f->shift_date
     replace shift_no with st15f->shift_no
     replace shift_id with st15f->shift_id
     replace start_user with pluser
     replace start_date with date()
     replace start_time with time()
     replace end_time with ""
   select shiftcla
    go top
    if .not. eof()
      do
         do st15fc01_rtn2
         until eofshiftcla
   endif
   select shcongt1
      replace end_time with time()
   
   endif
 
PROCEDURE ST15FC01_RTN2
      LOCAL L1,L2,L3,L4,L5,L6,L7
         L1 = ST15F->SHIFT_DATE
         L2 = ST15F->SHiFT_NO
         L3 = ST15F->SHIFT_ID
         L4 = SHIFTCLA->typ
         l5 = SHIFTCLA->cla
         l6 = SHIFTCLA->cod
         l7 = SHIFTCLA->sto
         if .not. empty(l1) .and. .not. empty(l2) .and. .not. empty(l3) ;
          .and. .not. empty(l4) .and. .not. empty(l5) .and. .not. empty(l6) ;
           .and. .not. empty(l7)
         select fgstkcal
         seek dtos(l1)+l2+l3+l4+l5+l6+l7
         if .not. found()
         append blank
         replace shift_date with l1
         replace shift_no with l2
         replace shift_id with l3
         replace typ with l4
         replace cla with l5
         replace cod with l6
         replace sto with l7
         replace coy with "1"
       
         endif
         replace tank_cap with shiftcla->tank_cap
         replace exp_sales with shiftcla->exp_sales
replace exp_cash with shiftcla->exp_cash
replace non_cash with shiftcla->non_cash
replace on_hand with shiftcla->on_hand
replace bbf_phy with shiftcla->BBF_PHY
replace bcf with shiftcla->bcf
replace shift_var with shiftcla->shift_var
replace phy with shiftcla->phy
replace qty2 with shiftcla->qty2
replace purchases with shiftcla->purchases
REPLACE BBF WITH shiftcla->bbf
replace c_sales_q with shiftcla->c_sales_q
REPLACE ADJS WITH shiftcla->adjs
REPLACE TRANS WITH shiftcla->trans
replace sold_qty with shiftcla->sold_qty
replace price_var with shiftcla->price_var
replace qty_var with shiftcla->qty_var
replace qty with shiftcla->qty
replace price_var with shiftcla->price_var
replace old_p with shiftcla->old_p
replace new_p with shiftcla->new_p
endif
IF TYP = "00" && WET STOCKS
   do PMS_rtn1
   DO AGO_RTN1
ENDIF
select shiftcla
skip
if eof()
eofshiftcla = .t.
endif
      

procedure PMS_RTN1
   pshdate = FGSTKCAL->shift_date
   pcoy = FGSTKCAL->coy
   if empty(pcoy)
   pcoy = "1"
   endif
   pshno = fgstkcal->shift_no
   pshid = fgstkcal->shift_id
   psal = FGSTKCAL->sold_qty
   ppur = fgstkcal->purchases
   pcla = FGSTKCAL->cla
   ptyp = fgstkcal->typ
   pcod = fgstkcal->cod
   PBBF = FGSTKCAL->BBF_PHY
   PPHY = FGSTKCAL->PHY
   PBK = PBBF+PPUR-PSAL
   PLG = PPHY-PBK
   psto = fgstkcal->sto
   
   IF .NOT. PSAL = 0
   PLPERC = PLG/PSAL*100
   ELSE
   PLPERC = 0
   ENDIF
   
   PDDYY = DTOS(PSHDATE) && YYYYMMDD
   PYY = LEFT(PDDYY,4) && YYYY
   PMM = RIGHT(LEFT(PDDYY,6),2) && MM
   
    select SHIFTWET
    set filter to typ = ptyp .and. cla = pcla .and. cod = pcod 
    go top
    if eof()
    do pms_start
   else
    go bottom
    do PMS_old
     endif


procedure pms_start
      select shiftwet
         set filter to
         append blank
         replace shift_date with pshdate
         replace coy with pcoy
         replace shift_no with pshno
         replace shift_id with pshid
         replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE BBF WITH PBBF
         REPLACE PURCH WITH PPUR
         REPLACE SALES WITH PSAL
         REPLACE ACT_STOCK WITH PPHY
         REPLACE BK_STOCK WITH PBK
         REPLACE LOSS_GAIN WITH PLG
         REPLACE LOSS_PERC WITH PLPERC
         REPLACE CUM_LOSS WITH LOSS_GAIN
         REPLACE CUM_L_PC WITH LOSS_PERC
         SELECT MONTHWET
         APPEND BLANK
         REPLACE COY WITH PCOY
          replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
       REPLACE MM WITH PMM
       REPLACE YY WITH PYY
       REPLACE PURCH WITH PPUR
       REPLACE SALES WITH PSAL
       REPLACE LOSS_GAIN WITH PLG
       REPLACE L_PERC WITH PLPERC
       select shiftwet
          replace cumm_sales with monthwet->sales
   replace cumm_purch with monthwet->purch
   replace cum_loss with monthwet->loss_gain
   replace cum_l_pc with monthwet->l_perc
     
procedure PMS_old
      if pshdate = shiftwet->shift_date .and. pshno = shiftwet->shift_no ;
       .and. pshid = shiftwet->shift_id .and. pcoy = shiftwet->coy
       do PMS_old_same
       else
       do PMS_old_new
       endif
Procedure PMS_old_same
select shiftwet
   replace sales with sales+psal
   replace purch with purch+ppur
   replace act_stock with act_stock+pphy
   replace bk_stock with bk_stock+pbk
   replace bbf with bbf+pbbf
   replace loss_gain with act_stock - bk_stock
   if .not. sales = 0
   plperc = loss_gain/sales*100
   else
   plperc = 0
   endif
   replace loss_perc with plperc
select monthwet
seek pcoy+pmm+pyy+ptyp+pcla+pcod
if found()
   replace purch with purch+ppur
   replace sales with sales+psal
   replace loss_gain with loss_gain + plg
   if .not. sales = 0
   plperc = loss_gain/sales*100
   else
   plperc = 0
   endif
   replace l_perc with plperc
   select shiftwet
   replace cumm_sales with monthwet->sales
   replace cumm_purch with monthwet->purch
   replace cum_loss with monthwet->loss_gain
   replace cum_l_pc with monthwet->l_perc
   endif
   
procedure PMS_old_new
         if .not. month(SHIFTWET->shift_date) = month(pshdate)
         do pms_old_new_mth
         else
         do pms_old_same_mth
         endif
procedure pms_old_same_mth
      select shiftwet
         append blank
         replace shift_date with pshdate
         replace coy with pcoy
         replace shift_no with pshno
         replace shift_id with pshid
         replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE BBF WITH PBBF
         REPLACE PURCH WITH PPUR
         REPLACE SALES WITH PSAL
         REPLACE ACT_STOCK WITH PPHY
         REPLACE BK_STOCK WITH PBK
         REPLACE LOSS_GAIN WITH PLG
         REPLACE LOSS_PERC WITH PLPERC
         SELECT MONTHWET
         seek pcoy+pmm+pyy+ptyp+pcla+pcod
         if .not. found()
         APPEND BLANK
         REPLACE COY WITH PCOY
          replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
       REPLACE MM WITH PMM
       REPLACE YY WITH PYY
       REPLACE PURCH WITH 0
       REPLACE SALES WITH 0
       REPLACE LOSS_GAIN WITH 0
       REPLACE L_PERC WITH 0
       endif
       replace sales with sales+psal
       replace purch with purch + ppur
       replace loss_gain with loss_gain + plg
       IF .NOT. SALES = 0
       replace l_Perc with LOSS_GAIN/SALES*100
       ELSE
       REPLACE L_PERC WITH 0
       ENDIF
       select shiftwet
   replace cumm_sales with monthwet->sales
   replace cumm_purch with monthwet->purch
   replace cum_loss with monthwet->loss_gain
   replace cum_l_pc with monthwet->l_perc
procedure pms_old_new_mth
      select shiftwet
         append blank
         replace shift_date with pshdate
         replace coy with pcoy
         replace shift_no with pshno
         replace shift_id with pshid
         replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE BBF WITH pbbf
         REPLACE PURCH WITH PPUR
         REPLACE SALES WITH PSAL
         REPLACE ACT_STOCK WITH PPHY
         REPLACE BK_STOCK WITH PBK
         REPLACE LOSS_GAIN WITH PLG
         REPLACE LOSS_PERC WITH PLPERC
         REPLACE CUM_LOSS WITH LOSS_GAIN
         REPLACE CUM_L_PC WITH LOSS_PERC
         SELECT MONTHWET
         APPEND BLANK
         REPLACE COY WITH PCOY
          replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
       REPLACE MM WITH PMM
       REPLACE YY WITH PYY
       REPLACE PURCH WITH PPUR
       REPLACE SALES WITH PSAL
       REPLACE LOSS_GAIN WITH PLG
       REPLACE L_PERC WITH PLPERC
       select shiftwet
          replace cumm_sales with monthwet->sales
   replace cumm_purch with monthwet->purch
   replace cum_loss with monthwet->loss_gain
   replace cum_l_pc with monthwet->l_perc
 
 procedure AGO_RTN1
   pshdate = FGSTKCAL->shift_date
   pcoy = FGSTKCAL->coy
   if empty(pcoy)
   pcoy = "1"
   endif
   pshno = fgstkcal->shift_no
   pshid = fgstkcal->shift_id
   psal = FGSTKCAL->sold_qty
   ppur = fgstkcal->purchases
   pcla = FGSTKCAL->cla
   ptyp = fgstkcal->typ
   pcod = fgstkcal->cod
   PBBF = FGSTKCAL->BBF_PHY
   PPHY = FGSTKCAL->PHY
   PBK = PBBF+PPUR-PSAL
   PLG = PPHY-PBK
   psto = fgstkcal->sto
   
   IF .NOT. PSAL = 0
   PLPERC = PLG/PSAL*100
   ELSE
   PLPERC = 0
   ENDIF
   
   PDDYY = DTOS(PSHDATE) && YYYYMMDD
   PYY = LEFT(PDDYY,4) && YYYY
   PMM = RIGHT(LEFT(PDDYY,6),2) && MM
   
    select SHIFTWST
    set filter to typ = ptyp .and. cla = pcla .and. cod = pcod .AND. STO = PSTO
    go top
    if eof()
    do AGO_STO_start
   else
    go bottom
    do AGO_sto_old_new
     endif
  
procedure AGO_sto_start
      select shiftwst
         set filter to
         append blank
         replace shift_date with pshdate
         replace coy with pcoy
         replace shift_no with pshno
         replace shift_id with pshid
         replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE STO WITH PSTO
         REPLACE BBF WITH PBBF
         REPLACE PURCH WITH PPUR
         REPLACE SALES WITH PSAL
         REPLACE ACT_STOCK WITH PPHY
         REPLACE BK_STOCK WITH PBK
         REPLACE LOSS_GAIN WITH PLG
         REPLACE LOSS_PERC WITH PLPERC
         REPLACE CUM_LOSS WITH LOSS_GAIN
         REPLACE CUM_L_PC WITH LOSS_PERC
         SELECT MONTHWST
         APPEND BLANK
         REPLACE COY WITH PCOY
          replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
        REPLACE STO WITH PSTO
       REPLACE MM WITH PMM
       REPLACE YY WITH PYY
       REPLACE PURCH WITH PPUR
       REPLACE SALES WITH PSAL
       REPLACE LOSS_GAIN WITH PLG
       REPLACE L_PERC WITH PLPERC
       select shiftwst
          replace cumm_sales with MONTHWST->sales
   replace cumm_purch with MONTHWST->purch
   replace cum_loss with MONTHWST->loss_gain
   replace cum_l_pc with MONTHWST->l_perc
     
 
Procedure AGO_sto_old_same
select shiftwst
   replace sales with sales+psal
   replace purch with purch+ppur
   replace act_stock with act_stock+pphy
   replace bk_stock with bk_stock+pbk
   replace bbf with bbf+pbbf
   replace loss_gain with act_stock - bk_stock
   if .not. sales = 0
   plperc = loss_gain/sales*100
   else
   plperc = 0
   endif
   replace loss_perc with plperc
select MONTHWST
seek pcoy+pmm+pyy+ptyp+pcla+pcod+PSTO
if found()
   replace purch with purch+ppur
   replace sales with sales+psal
   replace loss_gain with loss_gain + plg
   if .not. sales = 0
   plperc = loss_gain/sales*100
   else
   plperc = 0
   endif
   replace l_perc with plperc
   select shiftwst
   replace cumm_sales with MONTHWST->sales
   replace cumm_purch with MONTHWST->purch
   replace cum_loss with MONTHWST->loss_gain
   replace cum_l_pc with MONTHWST->l_perc
   endif
   
procedure AGO_sto_old_new
         if .not. month(SHIFTWST->shift_date) = month(pshdate)
         do AGO_sto_old_new_mth
         else
         do AGO_sto_old_same_mth
         endif
procedure AGO_sto_old_same_mth
      select shiftwst
         append blank
         replace shift_date with pshdate
         replace coy with pcoy
         replace shift_no with pshno
         replace shift_id with pshid
         replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE STO WITH PSTO
         REPLACE BBF WITH PBBF
         REPLACE PURCH WITH PPUR
         REPLACE SALES WITH PSAL
         REPLACE ACT_STOCK WITH PPHY
         REPLACE BK_STOCK WITH PBK
         REPLACE LOSS_GAIN WITH PLG
         REPLACE LOSS_PERC WITH PLPERC
         SELECT MONTHWST
         seek pcoy+pmm+pyy+ptyp+pcla+pcod+PSTO
         if .not. found()
         APPEND BLANK
         REPLACE COY WITH PCOY
          replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE STO WITH PSTO
       REPLACE MM WITH PMM
       REPLACE YY WITH PYY
       REPLACE PURCH WITH 0
       REPLACE SALES WITH 0
       REPLACE LOSS_GAIN WITH 0
       REPLACE L_PERC WITH 0
       endif
       replace sales with sales+psal
       replace purch with purch + ppur
       replace loss_gain with loss_gain + plg
       IF .NOT. SALES = 0
       replace l_Perc with LOSS_GAIN/SALES*100
       ELSE
       REPLACE L_PERC WITH 0
       ENDIF
       select shiftwst
   replace cumm_sales with MONTHWST->sales
   replace cumm_purch with MONTHWST->purch
   replace cum_loss with MONTHWST->loss_gain
   replace cum_l_pc with MONTHWST->l_perc



procedure AGO_sto_old_new_mth
      select shiftwst
         append blank
         replace shift_date with pshdate
         replace coy with pcoy
         replace shift_no with pshno
         replace shift_id with pshid
         replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE STO WITH PSTO
         REPLACE BBF WITH pbbf
         REPLACE PURCH WITH PPUR
         REPLACE SALES WITH PSAL
         REPLACE ACT_STOCK WITH PPHY
         REPLACE BK_STOCK WITH PBK
         REPLACE LOSS_GAIN WITH PLG
         REPLACE LOSS_PERC WITH PLPERC
         REPLACE CUM_LOSS WITH LOSS_GAIN
         REPLACE CUM_L_PC WITH LOSS_PERC
         SELECT MONTHWST
         APPEND BLANK
         REPLACE COY WITH PCOY
          replace TYP WITH PTYP
         REPLACE CLA WITH PCLA
         REPLACE COD WITH PCOD
         REPLACE STO WITH PSTO
       REPLACE MM WITH PMM
       REPLACE YY WITH PYY
       REPLACE PURCH WITH PPUR
       REPLACE SALES WITH PSAL
       REPLACE LOSS_GAIN WITH PLG
       REPLACE L_PERC WITH PLPERC
       select shiftwst
          replace cumm_sales with MONTHWST->sales
   replace cumm_purch with MONTHWST->purch
   replace cum_loss with MONTHWST->loss_gain
   replace cum_l_pc with MONTHWST->l_perc
  

     **************************************************************************
*  PROGRAM:     St15fc02.prg
*
*
*******************************************************************************

Procedure st15fc02_RTN
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL

  
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Opening New Shift Master in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 12,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set view to "st15fc02.QBE"
SET REPROCESS TO -1
select st15f
      do ST15FC2_RTN1
      close tables
      progreps.close()
Procedure ST15FC2_RTN1
   private EOFST15F,eofshstmast,poshdate,poshno,pnshdate,pnshno,pok,ptyp,pcla,pcod,;
   pcoy,eofst15fwkf,poyy,pomm,pnyy,pnmm,eofshcatsum,pyy,pmm,pqtr,pnqtr,ppqtr,POSHID,PNSHID, ppump,ppfirst
   ppfirst = .f.
   ppump = 0
   eofst15f = .f.
   set safety off
   set safety on
   select st15dmtr
   set order to shift_date
   SELECT SHIFTMTR
   SET ORDER TO MKEY
   select fgdacash
   set order to mkey
   select fgmocash
   set order to mkey
   select st15f
   go top
   

               local lrun, lnext
                  lnext = .f.
                  lrun = .f.
        
     select shcongt2
     go top
     if eof()
     lrun = .t.
     endif
     if .not. lrun
     if .not. empty(end_time)
      lnext = .t.
      endif
      endif
     if .not. lrun .and. .not. lnext
   
   InformationMessage("Shift Closing Disrupted in Phase 2", "Sorry!")
 
    quit
   
   endif
   
 if lrun  
     select shcongt2
     append blank
     replace shift_date with st15f->shift_date
     replace shift_no with st15f->shift_no
     replace shift_id with st15f->shift_id
     replace start_user with pluser
     replace start_date with date()
     replace start_time with time()
     replace end_time with ""
   select st15f
   if .not. eof()
      do 
      do st15fc2_rtn2 
      until  eofst15f
      endif
      
      set safety off
      select st15f
      zap
      set safety on
      eofst15fwkf = .f.
      select st15fwkf
      go top
      if .not. eof()
      do
      do st15fc2_rtn3
      until eofst15fwkf
      endif
      select st15f
      set order to mkey
      go top
      SELECT fgsshift
      GO TOP
      IF EOF()
      APPEND BLANK
      ENDIF
      REPLACE SHIFT WITH "01"
      REPLACE SHIFT_NO WITH ST15F->SHIFT_NO
      REPLACE SHIFT_DATE WITH ST15F->SHIFT_DATE
      REPLACE SHIFT_ID WITH ST15F->SHIFT_ID
          select fgdacash                      && opening new shift
        seek st15f->coy+dtos(st15f->shift_date)
        if .not. found()
        append blank
        replace coy with st15f->coy
        replace shift_date with st15f->shift_date
        replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with st15f->op_c_hand
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
        replace dr_staff with 0
         replace chq_sales with 0
         replace mbk_money with 0
        replace mbd_money with 0
        replace mbp_money with 0
      endif
       replace cl_c_hand with st15f->cl_c_hand
        local l1,l2,l3,l4
         l1 = dtos(fgdacash->shift_date) && yyyymmdd
         l2 = left(l1,6) && yyyymm
         l3 = right(l2,2) && mm
         l4 = left(l2,4) && yyyy
         l1 = fgdacash->coy
         select fgmocash
         seek l1+l4+l3
         if .not. found()
         append blank
         replace coy with l1
         replace yy with l4
         replace mm with l3
         replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with  st15f->op_c_hand
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
        replace dr_staff with 0
        replace chq_sales with 0  
        replace mbk_money with 0
        replace mbd_money with 0
        replace mbp_money with 0
      endif
       replace cl_c_hand with st15f->cl_c_hand
     
      select shcongt2
      replace end_time with time()
   endif
       
      close tables

   
 PROCEDURE st15fc2_rtn3
          SELECT ST15F
          APPEND BLANK
    replace op_capital with st15fwkf->cl_capital
    replace op_mpfloat with st15fwkf->cl_mpfloat
    replace op_mliquid with st15fwkf->cl_mliquid
    replace mp_capital with 0
    replace cl_capital with st15fwkf->cl_capital 
    replace cl_mpfloat with st15fwkf->cl_mpfloat
    replace cl_mliquid with st15fwkf->cl_mliquid
    replace mp_float with 0
    replace mp_liquid with 0
    
          replace m_sal_qty with st15fwkf->m_sal_qty
         replace e_sal_qty with st15fwkf->e_sal_qty
         replace e_sal_a with st15fwkf->e_sal_a
          replace off with st15fwkf->off
          replace f1cashr with st15fwkf->f1cashr
          REPLACE ST15F->SHIFT_DATE WITH ST15FWKF->SHIFT_DATE
           REPLACE ST15F->SHIFT_NO WITH ST15FWKF->SHIFT_NO
          REPLACE ST15F->SHIFT_id WITH ST15FWKF->SHIFT_id
         REPLACE ST15F->COY WITH ST15FWKF->COY
          REPLACE ST15F->DIV WITH ST15FWKF->DIV
           REPLACE ST15F->CEN WITH ST15FWKF->CEN
            REPLACE ST15F->STO WITH ST15FWKF->STO
             REPLACE OSHDATE WITH ST15FWKF->oSHDATE
               REPLACE OSHNO WITH ST15FWKF->oSHNO
               REPLACE OSHID WITH ST15FWKF->oSHID
             REPLACE ST15F->TYP WITH ST15FWKF->TYP
              REPLACE ST15F->CLA WITH ST15FWKF->CLA
               REPLACE ST15F->COD WITH ST15FWKF->COD
         REPLACE ST15F->cl_m_q WITH ST15FWKF->cl_m_q
          REPLACE op_m_q WITH ST15FWKF->op_m_q
           REPLACE ST15F->cl_m_a WITH ST15FWKF->cl_m_a
           replace op_mm_qty with st15fwkf->op_mm_qty
           REPLACE MM_SOLD WITH 0
           replace cl_mm_qty with st15fwkf->cl_mm_qty
            REPLACE ST15F->op_m_a WITH ST15FWKF->op_m_a
               REPLACE ST15F->PHY_QTY WITH 0
             REPLACE ST15F->SALE_PRICE WITH ST15FWKF->sale_price
            REPLACE ST15F->COST_PRICE WITH ST15FWKF->COST_PRICE
         REPLACE ST15F->ST_COY WITH ST15FWKF->ST_COY
          REPLACE ST15F->ST_DIV WITH ST15FWKF->ST_DIV
           REPLACE ST15F->ST_CEN WITH ST15FWKF->ST_CEN
            REPLACE ST15F->ST_STO WITH ST15FWKF->ST_STO
             REPLACE st15f->on_hand WITH ST15FWKF->on_hand
                replace op_c_hand  with st15fwkf->op_c_hand
                REPLACE M_Q1 WITH ST15FWKF->M_Q1
                REPLACE M_A1 WITH ST15FWKF->M_A1
                REPLACE M_Q2 WITH ST15FWKF->M_Q2
                REPLACE M_A2 WITH ST15FWKF->M_A2
                REPLACE OP_M_Q1 WITH ST15FWKF->M_Q1
                REPLACE OP_M_A1 WITH ST15FWKF->M_A1
                REPLACE OP_M_Q2 WITH ST15FWKF->M_Q2
                REPLACE OP_M_A2 WITH ST15FWKF->M_A2
                REPLACE a_c_inhand WITH 0
                REPLACE cl_c_hand WITH 0
                replace mm_qty_var with 0
                replace c_mstore with 0
                replace c_tstore with 0
                replace c_pstore with 0
                replace c_mmoney with 0
          
         REPLACE cr_sal_qty WITH 0
         REPLACE cr_sal_shs WITH 0
         REPLACE TEST_QTY WITH 0
         replace trans_in with 0
         replace trans_out with 0
           replace adj_in with 0
         replace adj_out with 0
         replace purchases with 0
         REPLACE TOTAL_QTY WITH 0
         REPLACE METER_AMT  WITH 0
         REPLACE SOLD_AMT   WITH 0
         REPLACE SOLD_QTY   WITH 0
         REPLACE NETT_AMT   WITH 0
         REPLACE CASH_AMT   WITH 0
         REPLACE CASH_QTY WITH 0
         REPLACE VAR_QTY WITH 0
         REPLACE t_purch WITH 0
         REPLACE VAR_CASH   WITH 0
         REPLACE on_hand WITH 0
           REPLACE TEST_AMT   WITH 0
             REPLACE VAT    WITH 0
             REPLACE EXP_CASH   WITH 0
              REPLACE EXP_SALES  WITH 0
              REPLACE NON_CASH   WITH 0
              REPLACE CASH_var   WITH 0
                REPLACE a_c_inhand   WITH 0
                replace total_cash         with 0
              replace manual             with 0 
              replace cash_debt      with 0
              replace cash_work with 0
              replace cash_cards         with 0
              replace cash_cant       with 0
              replace cash_shop          with 0
              replace cash_p_exp       with 0
              replace cash_p_pur       with 0
              replace cash_bank        with 0
              replace cash_short      with 0
               
   replace sh_c_sales with 0
   replace cash_short with 0
   
   replace t_cash_rec with 0
   replace cash_coy with 0
   replace net_cash with 0
   replace t_cash_pay with 0
   replace cash_merch with 0
   replace cash_food with 0
   replace cash_motor with 0
   replace cash_staff with 0
   replace cash_gen with 0
   replace cash_withd with 0
   replace cash_lubes with 0
   replace vs_company with 0
   replace vs_barclay with 0
   replace vs_others with 0
   replace chqs_sale with 0
   replace cash_soda with 0
   replace c_sh_shop with 0
   replace c_sh_work with 0
   replace c_sh_cards with 0
   replace c_sh_fuels with 0
   replace c_sh_cant with 0
   replace meter_var with 0
replace  purch with 0
replace  fc_c_sales with 0
replace  reserved1 with 0
replace  reserved2 with 0
replace  reserved3 with 0
replace  reserved4 with 0
replace  reserved5 with 0
replace  dbdebits with 0
replace  dbcredits with 0
REPLACE t_purch WITH 0
replace cash_hand with 0
replace  CHQS_BANK with 0
REPLACE A_CASH WITH 0
   plcen = st15f->cen
   plsto = st15f->sto
   pltyp = st15f->typ
   plcla = st15f->cla
    replace cashier_no with  plcen
      replace batchamt with 0
      REPLACE MBK_MONEY WITH 0
      REPLACE MBD_MONEY WITH 0
      REPLACE MBP_MONEY WITH 0
      pmanual = op_m_a - op_m_q - op_mm_qty  && hash total of opening meters
      replace soma with op_m_a
      replace somm with op_mm_qty
      replace some with op_m_q
      replace manual with round(pmanual,0)
       REPLACE DATE_AMEND WITH {}
   REPLACE USER_AMEND WITH ""
   REPLACE TIME_AMEND WITH ""

      
       select st15fwkf
       skip
            IF EOF()
          EOFST15FWKF = .T.
       ENDIF
       
 PROCEDURE st15fc2_rtn2

        SELECT ST15FWKF
         APPEND BLANK
    replace op_capital with st15f->op_capital
    replace op_mpfloat with st15f->op_mpfloat
    replace op_mliquid with st15f->op_mliquid
    replace mp_capital with st15f->mp_capital
    replace cl_capital with st15f->cl_capital 
    replace cl_mpfloat with st15f->cl_mpfloat
    replace cl_mliquid with st15f->cl_mliquid
    replace mp_float with st15f->mp_float
    replace mp_liquid with st15f->mp_liquid
         replace m_sal_qty with st15f->m_sal_qty
         replace e_sal_qty with st15f->e_sal_qty
         replace e_sal_a with st15f->e_sal_a
         replace off with st15f->off
         replace f1cashr with st15f->f1cashr
         REPLACE SHIFT_DATE WITH ST15F->nshdate
         if  empty(shift_date)
        REPLACE SHIFT_DATE WITH fgcoy->shift_date
        endif
         REPLACE SHIFT_NO WITH ST15F->nshno
         if empty(shift_no)
         replace shift_no  with fgcoy->shift_no
         endif
         REPLACE COY WITH ST15F->COY
         REPLACE DIV WITH ST15F->DIV
         REPLACE CEN WITH ST15F->CEN
         REPLACE shift_id with st15f->nshid
         if empty(shift_id)
         replace shift_id with  fgcoy->shift_id
         endif
         REPLACE STO WITH ST15F->STO
         REPLACE TYP WITH ST15F->TYP
         REPLACE CLA WITH ST15F->CLA
                REPLACE M_Q1 WITH ST15F->M_Q1
                REPLACE M_A1 WITH ST15F->M_A1
                REPLACE M_Q2 WITH ST15F->M_Q2
                REPLACE M_A2 WITH ST15F->M_A2
                REPLACE OP_M_Q1 WITH ST15F->M_Q1
                REPLACE OP_M_A1 WITH ST15F->M_A1
                REPLACE OP_M_Q2 WITH ST15F->M_Q2
                REPLACE OP_M_A2 WITH ST15F->M_A2
                
               REPLACE COD WITH ST15F->COD
               REPLACE OSHDATE WITH ST15F->SHIFT_DATE
               REPLACE OSHNO WITH ST15F->SHIFT_NO
               REPLACE OSHID WITH ST15F->SHIFT_ID
               REPLACE trans_in with 0
               REPLACE trans_out with 0
                REPLACE adj_in with 0
               REPLACE adj_out with 0
                REPLACE purchases with 0
         REPLACE cl_m_q WITH ST15F->cl_m_q
          REPLACE op_m_q WITH ST15F->cl_m_q
          replace op_mm_qty with st15f->cl_mm_qty
          replace cl_mm_qty with st15f->cl_mm_qty
          replace mm_qty_var with 0
          REPLACE MM_SOLD WITH 0
           REPLACE cl_m_a WITH ST15F->cl_m_a
            REPLACE op_m_a WITH ST15F->cl_m_a
         REPLACE PHY_QTY WITH ST15F->PHY_QTY
         REPLACE cr_sal_qty WITH 0
         REPLACE cr_sal_shs WITH 0
         REPLACE TEST_QTY WITH 0
         REPLACE sale_price WITH ST15F->SALE_PRICE
         REPLACE date_close WITH {}
         REPLACE time_close WITH ""
           REPLACE REMARKS WITH ""
         REPLACE COST_PRICE WITH ST15F->COST_PRICE
         REPLACE ST_COY WITH ST15F->ST_COY
          REPLACE ST_DIV WITH ST15F->ST_DIV
           REPLACE ST_CEN WITH ST15F->ST_CEN
            REPLACE ST_STO WITH ST15F->ST_STO
         REPLACE TOTAL_QTY WITH 0
         REPLACE METER_AMT  WITH 0
         REPLACE SOLD_AMT   WITH 0
         REPLACE SOLD_QTY   WITH 0
         REPLACE NETT_AMT   WITH 0
         REPLACE CASH_AMT   WITH 0
         REPLACE CASH_QTY WITH 0
         REPLACE VAR_QTY WITH 0
         REPLACE VAR_CASH   WITH 0
         REPLACE on_hand WITH st15f->on_hand
           REPLACE TEST_AMT   WITH 0
             REPLACE VAT    WITH 0
              REPLACE EXP_CASH   WITH 0
               REPLACE CASH_var   WITH 0
                REPLACE a_c_inhand   WITH 0
              REPLACE EXP_SALES  WITH 0
              REPLACE NON_CASH  WITH 0
              replace total_cash         with 0
              replace t_purch    with 0
              replace manual             with 0   
          replace op_c_hand  with st15f->cl_c_hand
           replace cl_c_hand with 0
              replace a_c_inhand with 0
              replace cash_debt      with 0
              replace cash_work with 0
              replace cash_cards         with 0
              replace cash_cant       with 0
              replace cash_shop          with 0 
              replace cash_p_exp       with 0
              replace cash_p_pur       with 0
              replace cash_bank        with 0
              replace cash_short      with 0
              replace vs_barclay with 0
     replace vs_others  with 0
      replace vs_company with 0
       replace chqs_sale with 0
       replace cash_soda with 0
replace  purch with 0
replace  fc_c_sales with 0
replace  reserved1 with 0
replace  reserved2 with 0
replace  reserved3 with 0
replace  reserved4 with 0
replace  reserved5 with 0
replace  dbdebits with 0
replace  dbcredits with 0
replace  CHQS_BANK with 0
REPLACE A_CASH WITH 0
select st15f
pzeros = .f.
if op_mm_qty = 0 .and. cl_mm_qty = 0 .and. cl_m_q = 0 .and. cl_m_a = 0 ;
 .and. op_m_q = 0 .and. op_m_a = 0 .and. test_qty = 0 .and. non_cash = 0 ;
  .and. cr_sal_qty = 0 .and. phY_qty = 0 .and. solD_qty = 0 .and. trans_in = 0 ;
   .and. trans_out = 0 .and. adj_in = 0 .and. adj_out = 0 .and. exp_sales = 0 ;
    .and. t_purch = 0 .and. cash_amt = 0
    pzeros = .t.
    endif
    if .not. pzeros

       select st15fhis
       append blank   
        REPLACE SHIFT_DATE WITH ST15F->SHIFT_DATE
         REPLACE SHIFT_NO WITH ST15F->SHIFT_NO
         REPLACE SHIFT_ID WITH ST15F->SHIFT_ID
         REPLACE COY WITH ST15F->COY
          REPLACE DIV WITH ST15F->DIV
           REPLACE CEN WITH ST15F->CEN
            REPLACE STO WITH ST15F->STO
             REPLACE TYP WITH ST15F->TYP
              REPLACE CLA WITH ST15F->CLA
               REPLACE COD WITH ST15F->COD
               REPLACE trans_in with st15f->trans_in
               REPLACE trans_out with st15f->trans_out
                REPLACE adj_in with st15f->adj_in
               REPLACE adj_out with st15f->adj_out
         REPLACE cl_m_q WITH ST15F->cl_m_q
          REPLACE op_m_q WITH ST15F->op_m_q
          replace op_mm_qty with st15f->op_mm_qty
          replace cl_mm_qty with st15f->cl_mm_qty
           REPLACE cl_m_a WITH ST15F->cl_m_a
            REPLACE op_m_a WITH ST15F->op_m_a
         REPLACE PHY_QTY WITH ST15F->PHY_QTY
         REPLACE cr_sal_qty WITH ST15F->cr_sal_qty
         REPLACE TEST_QTY WITH ST15F->TEST_QTY
         REPLACE sale_price WITH ST15F->SALE_PRICE
         REPLACE SOLD_QTY   WITH ST15F->SOLD_QTY
               REPLACE EXP_SALES  WITH ST15F->EXP_SALES
               REPLACE NON_CASH  WITH ST15F->NON_CASH
              REPLACE PURCHASES WITH ST15F->T_PURCH  
              REPLACE CASH_AMT WITH ST15F->CASH_AMT
              replace st_sto with st15f->st_sto
*              replace st_coy with st15f->st_coy
         *     replace st_div with st15f->st_div
          *    replace st_cen with st15f->st_cen
          *   REPLACE cost_price WITH ST15F->cost_price
             * REPLACE nonvat     WITH ST15F->nonvat
            *  REPLACE nonvat_amt WITH ST15F->nonvat_amt
         *     REPLACE vat        WITH ST15F->vat
          *    REPLACE gross_amt  WITH ST15F->gross_amt + ST15F->nonvat_amt
           *   REPLACE tax_amt    WITH ST15F->tax_amt
           *   REPLACE total      WITH ST15F->total     
REPLACE DATE_CLOSE WITH DATE()
REPLACE USER_CLOSE WITH pluser
REPLACE TIME_CLOSE WITH TIME()
REPLACE DATE_AMEND WITH ST15F->DATE_AMEND
REPLACE USER_AMEND WITH ST15F->USER_AMEND
REPLACE TIME_AMEND WITH ST15F->TIME_AMEND
REPLACE OFF WITH ST15F->OFF

if typ="00" .or. (typ="10" .and. (cen = "D" .or. cen ='O'))&& fuels and metered lubes only
pshdate = shift_date
   psno = shift_no
   psid = shift_id
   pcen = cen
   ptyp = typ
   pcla = cla
   pcod = cod
   psto = sto
   pcoy = coy
   pdiv = div
   select shiftmtr
    set filter to pcen = cen .and. ptyp = typ .and. pcla = cla .and. pcod = cod .and. coy = pcoy ;
     .and. psto = sto .and. div = pdiv
      go top
     if eof()
     set filter to
        do new_mtr
         DO NEW_MTR_VAR
        else
        go bottom
        set filter to
        do old_mtr
         DO NEW_MTR_VAR
    endif

endif
endif
   if st15f->typ = "00" .AND. (St15f->op_m_q1 > 0 .OR. st15f->op_m_q2 > 0 ; 
    .OR. st15f->op_m_a1 > 0 .OR. st15f->op_m_a2 > 0 .OR. st15f->m_q1 > 0 ;
     .OR. st15f->m_q2 > 0 .OR. st15f->m_a1 > 0 .OR. st15f->m_a2  > 0)
      do st15fsmtr_rtn
 endif
* if st15f->typ = '00' .and. .not. (st15f->op_m_q = 0 .and. st15f->cl_m_q = 0 .and. st15f->op_mm_qty = 0;
.and. st15f->cl_mm_qty = 0) .and. .not. empty(st15f->shift_date) .AND. FGCOY->SHIPNAME ='Orc'
* do st15dmtr_rtn
* endif
         select st15f
          SKIP
        IF EOF()
          EOFST15F = .T.
       ENDIF
procedure st15dmtr_rtn
 local loc1,loc2,l3,loc4,locd,locm,locy,locmn
   pmsdate = st15f->shift_date
  loc1 = dtos(pmsdate) && yyyymmdd
   loc2 = right(loc1,6) && yymmdd
   loc1 = left(loc2,4) && yymm
   locm = right(loc1,2)
   if locm ='01'
   locmn= 'Jan'
   endif
   if locm ='02'
   locmn= 'Feb'
   endif
   if locm ='03'
   locmn= 'Mar'
   endif
   if locm ='04'
   locmn= 'Apr'
   endif
   if locm ='05'
   locmn= 'May'
   endif
   if locm ='06'
   locmn= 'Jun'
   endif
   if locm ='07'
   locmn= 'Jul'
   endif
   if locm ='08'
   locmn= 'Aug'
   endif
   if locm ='09'
   locmn= 'Sep'
   endif
   if locm ='10'
   locmn= 'Oct'
   endif
   if locm ='11'
   locmn= 'Nov'
   endif
   if locm ='12'
   locmn= 'Dec'
   endif
   locy = left(loc1,2)
   locd = right(loc2,2)
   podate = locd+'-'+locmn+'-'+locy
   poman = st15f->op_mm_qty
   poele = st15f->op_m_q
   pcman = st15f->cl_mm_qty
   pcele = st15f->cl_m_q
   pmanqty = st15f->m_qty
   peleqty = st15f->e_qty
   prtt = st15f->test_qty
   psalep = st15f->sale_price
   pclass = st15f->cla
   if pmanqty > 0
   psalqty = pmanqty
   else
   psalqty = peleqty
   endif
   ppump = ppump + 1
   select st15dmtr
   seek pmsdate
   if .not. found()
      append blank
       ppfirst = .t.
      replace shift_date with pmsdate
      replace order_date with podate
      endif
     if ppfirst
      if ppump = 1 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_01 with poman
      replace cl_m_q_01 with pcman
      replace cla_01 with pclass
      replace rtt_01 with prtt
      replace salep_01 with psalep
     else
     if ppump = 1
      replace op_m_q_01 with poele
      replace cl_m_q_01 with pcele
       replace cla_01 with pclass
      replace rtt_01 with prtt
      replace salep_01 with psalep
      endif
      endif
      
       if ppump = 2 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_02 with poman
      replace cl_m_q_02 with pcman
            replace cla_02 with pclass
      replace rtt_02 with prtt
      replace salep_02 with psalep
  else
  if ppump = 2
      replace op_m_q_02 with poele
      replace cl_m_q_02 with pcele
            replace cla_02 with pclass
      replace rtt_02 with prtt
      replace salep_02 with psalep
      endif
      endif
  if ppump = 3 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_03 with poman
      replace cl_m_q_03 with pcman
            replace cla_03 with pclass
      replace rtt_03 with prtt
      replace salep_03 with psalep
  else
  if ppump = 3
      replace op_m_q_03 with poele
      replace cl_m_q_03 with pcele
            replace cla_03 with pclass
      replace rtt_03 with prtt
      replace salep_03 with psalep
      endif
      endif
      
  if ppump = 4 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_04 with poman
      replace cl_m_q_04 with pcman
            replace cla_04 with pclass
      replace rtt_04 with prtt
      replace salep_04 with psalep
   else
   if ppump = 4
      replace op_m_q_04 with poele
      replace cl_m_q_04 with pcele
            replace cla_04 with pclass
      replace rtt_04 with prtt
      replace salep_04 with psalep
      endif
      endif
      
  if ppump = 5 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_05 with poman
      replace cl_m_q_05 with pcman
            replace cla_05 with pclass
      replace rtt_05 with prtt
      replace salep_05 with psalep
 else
  if ppump = 5
      replace op_m_q_05 with poele
      replace cl_m_q_05 with pcele
            replace cla_05 with pclass
      replace rtt_05 with prtt
      replace salep_05 with psalep
      endif
      endif
      
  if ppump = 6 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_06 with poman
      replace cl_m_q_06 with pcman
            replace cla_06 with pclass
      replace rtt_06 with prtt
      replace salep_06 with psalep
  else
  if ppump = 6
      replace op_m_q_06 with poele
      replace cl_m_q_06 with pcele
            replace cla_06 with pclass
      replace rtt_06 with prtt
      replace salep_06 with psalep
      endif
      endif
  if ppump = 7 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_07 with poman
      replace cl_m_q_07 with pcman
            replace cla_07 with pclass
      replace rtt_07 with prtt
      replace salep_07 with psalep
    else
    if ppump = 7
      replace op_m_q_07 with poele
      replace cl_m_q_07 with pcele
            replace cla_07 with pclass
      replace rtt_07 with prtt
      replace salep_07 with psalep
       endif
       endif
  if ppump = 8 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_08 with poman
      replace cl_m_q_08 with pcman
            replace cla_08 with pclass
      replace rtt_08 with prtt
      replace salep_08 with psalep
  else
    if ppump = 8
      replace op_m_q_08 with poele
      replace cl_m_q_08 with pcele
            replace cla_08 with pclass
      replace rtt_08 with prtt
      replace salep_08 with psalep
      endif
      endif
  if ppump = 9 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_09 with poman
      replace cl_m_q_09 with pcman
            replace cla_09 with pclass
      replace rtt_09 with prtt
      replace salep_09 with psalep
else
if ppump = 9
      replace op_m_q_09 with poele
      replace cl_m_q_09 with pcele
            replace cla_09 with pclass
      replace rtt_09 with prtt
      replace salep_09 with psalep
       endif
       endif
   if ppump = 10 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_10 with poman
      replace cl_m_q_10 with pcman
            replace cla_10 with pclass
      replace rtt_10 with prtt
      replace salep_10 with psalep
    else
   if ppump = 10 
      replace op_m_q_10 with poele
      replace cl_m_q_10 with pcele
            replace cla_10 with pclass
      replace rtt_10 with prtt
      replace salep_10 with psalep
      endif
      endif
if ppump = 11 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_11 with poman
      replace cl_m_q_11 with pcman
            replace cla_11 with pclass
      replace rtt_11 with prtt
      replace salep_11 with psalep
     else
     if ppump = 11
      replace op_m_q_11 with poele
      replace cl_m_q_11 with pcele
            replace cla_11 with pclass
      replace rtt_11 with prtt
      replace salep_11 with psalep
        endif
        endif
if ppump = 12 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_12 with poman
      replace cl_m_q_12 with pcman
            replace cla_12 with pclass
      replace rtt_12 with prtt
      replace salep_12 with psalep
     else
     if ppump = 12
      replace op_m_q_12 with poele
      replace cl_m_q_12 with pcele
            replace cla_12 with pclass
      replace rtt_12 with prtt
      replace salep_12 with psalep
       endif
       endif
      if ppump = 13 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_13 with poman
      replace cl_m_q_13 with pcman
            replace cla_13 with pclass
      replace rtt_13 with prtt
      replace salep_13 with psalep
       else
       if ppump = 13
      replace op_m_q_13 with poele
      replace cl_m_q_13 with pcele
            replace cla_13 with pclass
      replace rtt_13 with prtt
      replace salep_13 with psalep
      endif
      endif
      if ppump = 14 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_14 with poman
      replace cl_m_q_14 with pcman
            replace cla_14 with pclass
      replace rtt_14 with prtt
      replace salep_14 with psalep
     else
      if ppump = 14
      replace op_m_q_14 with poele
      replace cl_m_q_14 with pcele
            replace cla_14 with pclass
      replace rtt_14 with prtt
      replace salep_14 with psalep
       endif
       endif
      if ppump = 15 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_15 with poman
      replace cl_m_q_15 with pcman
            replace cla_15 with pclass
      replace rtt_15 with prtt
      replace salep_15 with psalep
     else
     if ppump = 15
      replace op_m_q_15 with poele
      replace cl_m_q_15 with pcele
            replace cla_15 with pclass
      replace rtt_15 with prtt
      replace salep_15 with psalep
      endif
      endif
      if ppump = 16 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_16 with poman
      replace cl_m_q_16 with pcman
            replace cla_16 with pclass
      replace rtt_16 with prtt
      replace salep_16 with psalep
      else
      if ppump = 16
      replace op_m_q_16 with poele
      replace cl_m_q_16 with pcele
            replace cla_16 with pclass
      replace rtt_16 with prtt
      replace salep_16 with psalep
      endif
      endif
      if ppump = 17 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_17 with poman
      replace cl_m_q_17 with pcman
            replace cla_17 with pclass
      replace rtt_17 with prtt
      replace salep_17 with psalep
      else
      if ppump = 17
      replace op_m_q_17 with poele
      replace cl_m_q_17 with pcele
            replace cla_17 with pclass
      replace rtt_17 with prtt
      replace salep_17 with psalep
       endif
       endif
if ppump = 18 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_18 with poman
      replace cl_m_q_18 with pcman
            replace cla_18 with pclass
      replace rtt_18 with prtt
      replace salep_18 with psalep
      else
      if ppump = 18
      replace op_m_q_18 with poele
      replace cl_m_q_18 with pcele
            replace cla_18 with pclass
      replace rtt_18 with prtt
      replace salep_18 with psalep
       endif
       endif
      if ppump = 19 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_19 with poman
      replace cl_m_q_19 with pcman
            replace cla_19 with pclass
      replace rtt_19 with prtt
      replace salep_19 with psalep
      else
      if ppump = 19
      replace op_m_q_19 with poele
      replace cl_m_q_19 with pcele
            replace cla_19 with pclass
      replace rtt_19 with prtt
      replace salep_19 with psalep
       endif
       endif
      if ppump = 20 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_20 with poman
      replace cl_m_q_20 with pcman
            replace cla_20 with pclass
      replace rtt_20 with prtt
      replace salep_20 with psalep
      else
      if ppump = 20 
      replace op_m_q_20 with poele
      replace cl_m_q_20 with pcele
            replace cla_20 with pclass
      replace rtt_20 with prtt
      replace salep_20 with psalep
       endif
       endif

if ppump = 21 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_21 with poman
      replace cl_m_q_21 with pcman
            replace cla_21 with pclass
      replace rtt_21 with prtt
      replace salep_21 with psalep
      else
      if ppump = 21
      replace op_m_q_21 with poele
      replace cl_m_q_21 with pcele
            replace cla_21 with pclass
      replace rtt_21 with prtt
      replace salep_21 with psalep
      endif
      endif
      if ppump = 22 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_22 with poman
      replace cl_m_q_22 with pcman
            replace cla_22 with pclass
      replace rtt_22 with prtt
      replace salep_22 with psalep
     else
     if ppump = 22
      replace op_m_q_22 with poele
      replace cl_m_q_22 with pcele
      replace cla_22 with pclass
      replace rtt_22 with prtt
      replace salep_22 with psalep
      endif
      endif
      if ppump = 23 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_23 with poman
      replace cl_m_q_23 with pcman
            replace cla_23 with pclass
      replace rtt_23 with prtt
      replace salep_23 with psalep
      else
      if ppump = 23 
      replace op_m_q_23 with poele
      replace cl_m_q_23 with pcele
            replace cla_23 with pclass
      replace rtt_23 with prtt
      replace salep_23 with psalep
       endif
       endif
      if ppump = 24 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_24 with poman
      replace cl_m_q_24 with pcman
            replace cla_24 with pclass
      replace rtt_24 with prtt
      replace salep_24 with psalep
     else
     if ppump = 24 
      replace op_m_q_24 with poele
      replace cl_m_q_24 with pcele
            replace cla_24 with pclass
      replace rtt_24 with prtt
      replace salep_24 with psalep
       endif
       endif
if ppump = 25 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_25 with poman
      replace cl_m_q_25 with pcman
            replace cla_25 with pclass
      replace rtt_25 with prtt
      replace salep_25 with psalep
      else
      if ppump = 25 
      replace op_m_q_25 with poele
      replace cl_m_q_25 with pcele
            replace cla_25 with pclass
      replace rtt_25 with prtt
      replace salep_25 with psalep
       endif
       endif
      if ppump = 26 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_26 with poman
      replace cl_m_q_26 with pcman
            replace cla_26 with pclass
      replace rtt_26 with prtt
      replace salep_26 with psalep
      else
       if ppump = 26
      replace op_m_q_26 with poele
      replace cl_m_q_26 with pcele
            replace cla_26 with pclass
      replace rtt_26 with prtt
      replace salep_26 with psalep
       endif
       endif
if ppump = 27 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_27 with poman
      replace cl_m_q_27 with pcman
            replace cla_27 with pclass
      replace rtt_27 with prtt
      replace salep_27 with psalep
     else
     if ppump = 27
      replace op_m_q_27 with poele
      replace cl_m_q_27 with pcele
            replace cla_27 with pclass
      replace rtt_27 with prtt
      replace salep_27 with psalep
       endif
       endif

if ppump = 28 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_28 with poman
      replace cl_m_q_28 with pcman
            replace cla_28 with pclass
      replace rtt_28 with prtt
      replace salep_28 with psalep
      else
      if ppump = 28
      replace op_m_q_28 with poele
      replace cl_m_q_28 with pcele
            replace cla_28 with pclass
      replace rtt_28 with prtt
      replace salep_28 with psalep
       endif
       endif
        if ppump = 29 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_29 with poman
      replace cl_m_q_29 with pcman
            replace cla_29 with pclass
      replace rtt_29 with prtt
      replace salep_29 with psalep
      else
      if ppump = 29 
      replace op_m_q_29 with poele
      replace cl_m_q_29 with pcele
            replace cla_29 with pclass
      replace rtt_29 with prtt
      replace salep_29 with psalep
       endif
       endif
      if ppump = 30 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_30 with poman
      replace cl_m_q_30 with pcman
            replace cla_30 with pclass
      replace rtt_30 with prtt
      replace salep_30 with psalep
     else
     if ppump = 30 
      replace op_m_q_30 with poele
      replace cl_m_q_30 with pcele
            replace cla_30 with pclass
      replace rtt_30 with prtt
      replace salep_30 with psalep
       endif
       endif
if ppump = 31 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_31 with poman
      replace cl_m_q_31 with pcman
            replace cla_31 with pclass
      replace rtt_31 with prtt
      replace salep_31 with psalep
      else
      if ppump = 31 
      replace op_m_q_31 with poele
      replace cl_m_q_31 with pcele
            replace cla_31 with pclass
      replace rtt_31 with prtt
      replace salep_31 with psalep
       endif
       endif
      if ppump = 32 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_32 with poman
      replace cl_m_q_32 with pcman
            replace cla_32 with pclass
      replace rtt_32 with prtt
      replace salep_32 with psalep
      else
       if ppump = 32
      replace op_m_q_32 with poele
      replace cl_m_q_32 with pcele
            replace cla_32 with pclass
      replace rtt_32 with prtt
      replace salep_32 with psalep
       endif
       endif
if ppump = 33 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_33 with poman
      replace cl_m_q_33 with pcman
            replace cla_33 with pclass
      replace rtt_33 with prtt
      replace salep_33 with psalep
     else
     if ppump = 33
      replace op_m_q_33 with poele
      replace cl_m_q_33 with pcele
            replace cla_33 with pclass
      replace rtt_33 with prtt
      replace salep_33 with psalep
       endif
       endif

if ppump = 34 .and. pmanqty > 0  && manual mtr used
      replace op_m_q_34 with poman
      replace cl_m_q_34 with pcman
            replace cla_34 with pclass
      replace rtt_34 with prtt
      replace salep_34 with psalep
      else
      if ppump = 34
      replace op_m_q_34 with poele
      replace cl_m_q_34 with pcele
            replace cla_34 with pclass
      replace rtt_34 with prtt
      replace salep_34 with psalep
       endif
       endif
else
   do st15dmtr_rtn2
      endif
      replace order_date with podate
procedure st15dmtr_rtn2
     select st15dmtr
      if ppump = 1 
      replace cl_m_q_01 with cl_m_q_01 + psalqty
      REPLACE RTT_01 WITH RTT_01 + PRTT
      endif
      if ppump = 2
      replace cl_m_q_02 with cl_m_q_02 + psalqty
       REPLACE RTT_02 WITH RTT_02 + PRTT
      endif
        if ppump = 3
      replace cl_m_q_03 with cl_m_q_03 + psalqty
       REPLACE RTT_03 WITH RTT_03 + PRTT
      endif
       if ppump = 4
      replace cl_m_q_04 with cl_m_q_04 + psalqty
       REPLACE RTT_04 WITH RTT_04 + PRTT
      endif
       if ppump = 5
      replace cl_m_q_05 with cl_m_q_05 + psalqty
       REPLACE RTT_05 WITH RTT_05 + PRTT
      endif
       if ppump = 6
      replace cl_m_q_06 with cl_m_q_06 + psalqty
       REPLACE RTT_06 WITH RTT_06 + PRTT
      endif
       if ppump = 7
      replace cl_m_q_07 with cl_m_q_07 + psalqty
       REPLACE RTT_07 WITH RTT_07 + PRTT
      endif
       if ppump = 8
      replace cl_m_q_08 with cl_m_q_08 + psalqty
       REPLACE RTT_08 WITH RTT_08 + PRTT
      endif
       if ppump = 9
      replace cl_m_q_09 with cl_m_q_09 + psalqty
       REPLACE RTT_09 WITH RTT_09 + PRTT
      endif
       if ppump = 10
      replace cl_m_q_10 with cl_m_q_10 + psalqty
       REPLACE RTT_10 WITH RTT_10 + PRTT
      endif
      if ppump = 11
      replace cl_m_q_11 with cl_m_q_11 + psalqty
       REPLACE RTT_11 WITH RTT_11 + PRTT
      endif
        if ppump = 12
      replace cl_m_q_12 with cl_m_q_12 + psalqty
       REPLACE RTT_12 WITH RTT_12 + PRTT
      endif
       if ppump = 13
      replace cl_m_q_13 with cl_m_q_13 + psalqty
       REPLACE RTT_13 WITH RTT_13 + PRTT
      endif
      if ppump = 14
      replace cl_m_q_14 with cl_m_q_14 + psalqty
       REPLACE RTT_14 WITH RTT_14 + PRTT
      endif
       if ppump = 15
      replace cl_m_q_15 with cl_m_q_15 + psalqty
       REPLACE RTT_15 WITH RTT_15 + PRTT
      endif
       if ppump = 16
      replace cl_m_q_16 with cl_m_q_16 + psalqty
       REPLACE RTT_16 WITH RTT_16 + PRTT
      endif
       if ppump = 17
      replace cl_m_q_17 with cl_m_q_17 + psalqty
       REPLACE RTT_17 WITH RTT_17 + PRTT
      endif
       if ppump = 18
      replace cl_m_q_18 with cl_m_q_18 + psalqty
       REPLACE RTT_18 WITH RTT_18 + PRTT
      endif
       if ppump = 19
      replace cl_m_q_19 with cl_m_q_19 + psalqty
       REPLACE RTT_19 WITH RTT_19 + PRTT
      endif
       if ppump = 20
      replace cl_m_q_20 with cl_m_q_20 + psalqty
       REPLACE RTT_20 WITH RTT_20 + PRTT
      endif
          if ppump = 21
      replace cl_m_q_21 with cl_m_q_21 + psalqty
       REPLACE RTT_21 WITH RTT_21 + PRTT
      endif
        if ppump = 22
      replace cl_m_q_22 with cl_m_q_22 + psalqty
       REPLACE RTT_22 WITH RTT_22 + PRTT
      endif
       if ppump = 23
      replace cl_m_q_23 with cl_m_q_23 + psalqty
       REPLACE RTT_23 WITH RTT_23 + PRTT
      endif
      if ppump = 24
      replace cl_m_q_24 with cl_m_q_24 + psalqty
       REPLACE RTT_24 WITH RTT_24 + PRTT
      endif
       if ppump = 25
      replace cl_m_q_25 with cl_m_q_25 + psalqty
       REPLACE RTT_25 WITH RTT_25 + PRTT
      endif
       if ppump = 26
      replace cl_m_q_26 with cl_m_q_26 + psalqty
       REPLACE RTT_26 WITH RTT_26 + PRTT
      endif
       if ppump = 27
      replace cl_m_q_27 with cl_m_q_27 + psalqty
       REPLACE RTT_27 WITH RTT_27 + PRTT
      endif
       if ppump = 28
      replace cl_m_q_28 with cl_m_q_28 + psalqty
       REPLACE RTT_28 WITH RTT_28 + PRTT
      endif
      if ppump = 29
      replace cl_m_q_29 with cl_m_q_29 + psalqty
       REPLACE RTT_29 WITH RTT_29 + PRTT
      endif
      if ppump = 30
      replace cl_m_q_30 with cl_m_q_30 + psalqty
       REPLACE RTT_30 WITH RTT_30 + PRTT
      endif
       if ppump = 31
      replace cl_m_q_31 with cl_m_q_31 + psalqty
       REPLACE RTT_31 WITH RTT_31 + PRTT
      endif
       if ppump = 32
      replace cl_m_q_32 with cl_m_q_32 + psalqty
       REPLACE RTT_32 WITH RTT_32 + PRTT
      endif
       if ppump = 33
      replace cl_m_q_33 with cl_m_q_33 + psalqty
       REPLACE RTT_33 WITH RTT_33 + PRTT
      endif
       if ppump = 34
      replace cl_m_q_34 with cl_m_q_34 + psalqty
       REPLACE RTT_34 WITH RTT_34 + PRTT
      endif
procedure st15fsmtr_rtn
 select st15fsmr
       append blank   
        REPLACE SHIFT_DATE WITH ST15F->SHIFT_DATE
         REPLACE SHIFT_NO WITH ST15F->SHIFT_NO
         REPLACE SHIFT_ID WITH ST15F->SHIFT_ID
         REPLACE COY WITH ST15F->COY
          REPLACE DIV WITH ST15F->DIV
           REPLACE CEN WITH ST15F->CEN
            REPLACE STO WITH ST15F->STO
             REPLACE TYP WITH ST15F->TYP
              REPLACE CLA WITH ST15F->CLA
               REPLACE COD WITH ST15F->COD
              REPLACE cl_m_q WITH ST15F->cl_m_q
          REPLACE op_m_q WITH ST15F->op_m_q
          replace op_mm_qty with st15f->op_mm_qty
          replace cl_mm_qty with st15f->cl_mm_qty
           REPLACE cl_m_a WITH ST15F->cl_m_a
            REPLACE op_m_a WITH ST15F->op_m_a
         REPLACE PHY_QTY WITH ST15F->PHY_QTY
         REPLACE TEST_QTY WITH ST15F->TEST_QTY
         REPLACE sale_price WITH ST15F->SALE_PRICE
         REPLACE SOLD_QTY   WITH ST15F->SOLD_QTY
               REPLACE EXP_SALES  WITH ST15F->EXP_SALES
              replace st_sto with st15f->st_sto
              REPLACE DATE_CLOSE WITH DATE()
              REPLACE USER_CLOSE WITH pluser
              REPLACE TIME_CLOSE WITH TIME()
              replace op_m_q1 with st15f->op_m_q1
              replace op_m_q2 with st15f->op_m_q2
              replace op_m_a1 with st15f->op_m_a1
              replace op_m_a2 with st15f->op_m_a2
                  replace cl_m_q1 with st15f->m_q1
              replace cl_m_q2 with st15f->m_q2
              replace cl_m_a1 with st15f->m_a1
              replace cl_m_a2 with st15f->m_a2
PROCEDURE NEW_MTR_VAR
      SELECT SHIFTVAR
      SEEK PCEN+PTYP+PCLA+PCOD+PSTO+PCOY+PDIV
      IF .NOT. FOUND()
      APPEND BLANK
        replace cen with pcen
      replace typ with ptyp
      replace cla with pcla
      replace cod with pcod
      replace coy with pcoy
      replace sto with psto
      replace div with pdiv
   ENDIF
   REPLACE OP_MM_QTY WITH st15fhis->CL_MM_QTY
   REPLACE OP_M_Q  WITH st15fhis->CL_M_Q
   REPLACE OP_M_A  WITH st15fhis->CL_M_A
   replace sale_price with st15fhis->sale_price
   replace date_close with st15fhis->date_close
   replace time_close with st15fhis->time_close
   replace user_close with st15fhis->user_close
     REPLACE DATE_AMEND WITH st15fhis->DATE_AMEND
   REPLACE USER_AMEND WITH st15fhis->USER_AMEND
   REPLACE TIME_AMEND WITH st15fhis->TIME_AMEND

procedure new_mtr
      select shiftmtr
      append blank
      replace shift_date with pshdate
      replace shift_no with psno
      replace shift_id with psid
      replace cen with pcen
      replace typ with ptyp
      replace cla with pcla
      replace cod with pcod
      replace coy with pcoy
      replace sto with psto
      replace div with pdiv
      replace op_mm_qty with st15fhis->op_mm_qty
      replace cl_mm_qty  with st15fhis->cl_mm_qty
      replace cl_m_q with st15fhis->cl_m_q
      replace cl_m_a with st15fhis->cl_m_a
      replace op_m_q with st15fhis->op_m_q
      replace op_m_a with st15fhis->op_m_a
      replace sold_qty  with st15fhis->sold_qty
      replace exp_sales with st15fhis->exp_sales
      replace test_qty with st15fhis->test_qty
      replace pcl_mm_qty  with op_mm_qty
      replace pcl_m_a with op_m_a
      replace pcl_m_q with op_m_q
      replace sale_price with st15fhis->sale_price
      replace ps_price with sale_price
         replace date_close with st15fhis->date_close
   replace time_close with st15fhis->time_close
   replace user_close with st15fhis->user_close
     REPLACE DATE_AMEND WITH st15fhis->DATE_AMEND
   REPLACE USER_AMEND WITH st15fhis->USER_AMEND
   REPLACE TIME_AMEND WITH st15fhis->TIME_AMEND
 procedure old_mtr
      
      select shiftmtr
      popmm = cl_mm_qty
      popmq = cl_m_q
      popma = cl_m_a
      psprice = sale_price
      append blank
      replace shift_date with pshdate
      replace shift_no with psno
      replace shift_id with psid
      replace cen with pcen
      replace typ with ptyp
      replace cla with pcla
      replace cod with pcod
      replace coy with pcoy
      replace sto with psto
      replace div with pdiv
      replace op_mm_qty with st15fhis->op_mm_qty
      replace cl_mm_qty  with st15fhis->cl_mm_qty
      replace cl_m_q with st15fhis->cl_m_q
      replace cl_m_a with st15fhis->cl_m_a
      replace op_m_q with st15fhis->op_m_q
      replace op_m_a with st15fhis->op_m_a
      replace sold_qty  with st15fhis->sold_qty
      replace exp_sales with st15fhis->exp_sales
      replace test_qty with st15fhis->test_qty
      replace pcl_mm_qty  with popmm
      replace pcl_m_a with popma
      replace pcl_m_q with popmq
      replace ps_price with psprice
      replace sale_price with st15fhis->sale_price
         replace date_close with st15fhis->date_close
   replace time_close with st15fhis->time_close
   replace user_close with st15fhis->user_close
   REPLACE DATE_AMEND WITH st15fhis->DATE_AMEND
   REPLACE USER_AMEND WITH st15fhis->USER_AMEND
   REPLACE TIME_AMEND WITH st15fhis->TIME_AMEND
         
    **************************************************************************
*  PROGRAM:    St15fc04.prg  && St15fc04
*
*
*******************************************************************************


Procedure st15fc04_RTN
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL

  
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Updating Shift Reports in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set view to "st15fc04.QBE"
SET REPROCESS TO -1
      do ST15FC04_RTN1
      close tables
      progreps.close()      
       CLEAR PROGRAM

     close databases
    
 
Procedure ST15FC04_RTN1
   private EOFST15F,eofshstmast,poshdate,poshno,pnshdate,pnshno,pok,ptyp,pcla,pcod,;
   pcoy,eofshstmwkf,poyy,pomm,pnyy,pnmm,eofshcatsum,pyy,pmm,pqtr,ppqtr,pnqtr,;
   EOFSHIFTANA,EOFSCASHREC,eoffgcod,plpsd,plsno,plsid,plcno,pleno
   EOFSCASHREC = .F.
   SELECT DAYFGMAS
   SET ORDER TO MKEY
      select st15f
      go top
      
                   local lrun, lnext
                  lnext = .f.
                  lrun = .f.
        
     select shcongt4
     go top
     if eof()
     lrun = .t.
     endif
     if .not. lrun
     if .not. empty(end_time)
      lnext = .t.
      endif
      endif
      if .not. lrun .and. .not. lnext
   
   InformationMessage("Shift Closing Disrupted in Phase 3", "Sorry!")
 
    quit
   
   endif
   
 if lrun  
     select shcongt4
     append blank
     replace shift_date with st15f->shift_date
     replace shift_no with st15f->shift_no
     replace shift_id with st15f->shift_id
     replace start_user with pluser
     replace start_date with date()
     replace start_time with time()
     replace end_time with ""

   select shcatsum
   set order to mkey
   select mshstmas
   set order to mkey
     select shstmast
   set order to mkey
   select cashiers
   set order to cashier
   SELECT dacasrec
   SET ORDER TO MKEY
   select hcashrec
   set order to mkey
   
    SELECT SCAShREC
    
    set filter to empty(post_date) 
   GO TOP
   IF  .not. EOF()
   DO
   DO SCASHREC_RTN
   UNTIL EOFSCASHREC
   ENDIF
   pok = .t.
   private eofshiftbk
  
   SELECT ST15F
   DELETE ALL FOR .NOT. EMPTY(POST_DATE)
   GO TOP

    eofshiftbk = .f.
    select dshiftbk
    set order to shiftdate
    select fgdacash
    set order to mkey
    select fgmocash
    set order to mkey
    
     select shiftbk
     set filter to empty(post_date)
   go top
   if .not. eof()
      do 
      do shiftbk_rtn1
      until eofshiftbk
      endif
      
      
      
    eofshiftmn = .f.
 *   select dshiftmn
  *  set order to shiftdate
*     select shiftmn
   *  set filter to empty(post_date)
  * go top
   *if .not. eof()
    *  do 
    *  do shiftmn_rtn1
    *  until eofshiftmn
    *  endif


      local l1
       
       LOCAL L1,L2
       L1 = STR(YEAR(ST15F->SHIFT_DATE),4)
       L2 = STR(MONTH(ST15F->SHIFT_DATE),2)
       IF VAL(L2) < 10
       L2 = "0"+STR(VAL(L2),1)
       ENDIF
        eoffgmast = .f.
        select st15f
        go top
        pcoy = "1"
         pshdate = st15f->shift_date
         pshno = st15f->shift_no
         pshid = st15f->shift_id
         poshiftdate = st15f->oshdate
         do frddebtp_rtn
         eoffgmast  = .f.
    pshdate = st15f->shift_date
    pshno = st15f->shift_no
    pshid = st15f->shift_id
   select fgmast
   set filter to typ >= "00" .and. typ <= "9Z" .and. ;
    .not. (typ = "00" .and. cen > "0") .and. .not. left(typ,1) = "7" .AND. .NOT. (CEN="D" .or.cen ='O') .and. ;
    .not. ( bbf = 0 .and. on_hand=0 .and. phy=0 .and. trans_in = 0 .and. trans_out = 0 .and. purch = 0 ;
    .and. cr_purch = 0 .and. cs_purch = 0 .and. cr_sales=0 .and. CS_SALES = 0 .AND. sales = 0 .and. adj_in = 0 .and. adj_out = 0)
    go top
    if .not. eof()
       do
          do shmast_rtn2
          until eoffgmast
         endif
          select shcongt4
      replace end_time with time()
         
         endif
Procedure frddebtp_rtn
   private eofFrighter
   eofFrighter = .f.
   select FRMODEBT
   set order to mkey
  select frddebtp
   set order to mkey
   select Frighter
   go top
   if .not. eof()
      do
         do frddebtp_rtn1
         until eofFrighter
    endif
procedure frddebtp_rtn1
   local l1,l2,l3,l4,l5,l6,l7,l8,l9
      l1 = Frighter->source
      l2 = Frighter->ftyp
      l3 = frighter->pmod
      l4 = frighter->frighter_n
      l5 = poshiftdate
      l6 = dtos(l5) && yyyymmdd
      l7 = left(l6,4) && yyyy
      l8 = left(l6,6) && yyyymm
      l9 = right(l8,2) && mm
      select FRMODEBT
      seek l1+l2+l3+l4+l7+l9
      if .not. found()
      append blank
      replace bal_due with Frighter->bal_due
      replace bbf with bal_due
      replace source with l1
      replace ftyp with l2
      replace pmod with l3
      replace Frighter_n with l4
      replace yy with l7
      replace mm with l9
     replace l_pay_amt with 0
     replace l_inv_amt with 0
      
     endif
     
      select frddebtp
      seek l1+l2+l3+l4+dtos(l5)
      if .not. found()
      append blank
      replace bal_due with Frighter->bal_due
      replace bbf with bal_due
     replace source with l1
      replace ftyp with l2
      replace pmod with l3
      replace Frighter_n with l4
      replace shift_date with l5
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     endif
     replace m_pay_amt with FRMODEBT->l_pay_amt
     replace m_inv_amt with FRMODEBT->l_inv_amt
      replace bal_due with Frighter->bal_due
      select frcustbl
  seek l1+l2+l3+l4
  if .not. found()
  append blank
  replace source with l1
  replace ftyp with l2
  replace pmod with l3
  replace frighter_n with l4
  replace bal_due with frighter->bal_due
  endif
     select Frighter
     replace alloc_amt with 0
     skip
     if eof()
     eofFrighter = .t.
     endif
procedure shmast_rtn2
   local l10,l7,l8,l9,l11,l12
   pcoy = fgmast->coy
   pdiv = fgmast->div
   ptyp = fgmast->typ
   pcla = fgmast->cla
   pcod = fgmast->cod
   psto = fgmast->sto
   pcen = fgmast->cen
   PSD = DTOS(PSHDATE) && YYYYMMDD
   PYY = LEFT(PSD,4) && YYYYY
   PMM = LEFT(PSD,6) && YYYYMM
   PMM = RIGHT(PMM,2) && MM
    if .not. pdiv = '1' .and. .not. ptyp = '00' .and. .not. fgmast->on_hand = 0
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      endif           
   
select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
        replace cs_sales_a with 0
      replace cr_sales_a with 0
      replace cs_purch_a with 0
      replace cr_purch_a with 0
        
      replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
 if bbf = 0
       select mshstmas
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy+pmm
   if .not. found()
   append blank
   replace yy with pyy
   replace mm with pmm
   replace sto with psto
    replace coy with shstmast->coy
    replace div with pdiv
    replace cen with pcen
      replace typ with shstmast->tyP
      replace cla with shstmast->cla
      replace cod with shstmast->cod
      replace cs_purch with 0
      replace cr_purch with shstmast->cr_purch
      replace cs_sales with shstmast->cs_sales
       replace cr_sales with shstmast->cr_sales
      replace trans_in with shstmast->trans_in
      replace trans_out with shstmast->trans_out
      replace adj_in with shstmast->adj_in
      replace adj_out with shstmast->adj_out
      replace bbf with shstmast->bbf
      replace phy    with shstmast->phy
      replace on_hand with shstmast->on_hand
           endif
       
       
           ENDIF
           endif

       
          select fgmast
        skip
       if eof()
       eoffgmast = .t.
       endif    

procedure shiftbk_rtn1
   local l1
    pcoy = shiftbk->coy
      pshdate = shiftbk->shift_date
      pyy = str(year(shiftbk->shift_date),4)
      pmm  = str(month(shiftbk->shift_date),2)
      ppdate = shiftbk->shift_date - 1
      pndate = shiftbk->shift_date + 1
      
      l1 = val(pmm)
      pqtr = "9"
      ppqtr = "9"
      pnqtr = "9"
      if l1 = 1  .or. l1 = 2 .or. l1 = 3
      pqtr = "1"
      ppqtr = "4"
      pnqtr = "2"
      endif
       if l1 = 4  .or. l1 = 5 .or. l1 = 6
      pqtr = "2"
      ppqtr = "1"
      pnqtr = "3"
      endif
       if l1 = 7  .or. l1 = 8 .or. l1 = 9
      pqtr = "3"
      ppqtr = "2"
      pnqtr = "4"
      endif
       if l1 = 10 .or. l1 = 11 .or. l1 = 12
      pqtr = "4"
      ppqtr = "3"
      pnqtr = "1"
      endif
      ppyy = str(year(ppdate),4)
      if pmm = "12"
      pnmm = "01"
      pnyy = str(val(pyy)+1,4)
      else
      pnmm = str(val(pmm)+1,2)
      pnyy = pyy
      endif
      if pmm = "01"
      ppmm = "12"
      ppyy = str(val(pyy)-1,4)
      else
      ppmm = str(val(pmm)-1,2)
      ppyy = pyy
      endif
     do shiftbk_rtn2
     select shiftbk
     replace post_date with date()
     skip
     if eof()
     eofshiftbk = .t.
     endif
Procedure shiftbk_rtn2
     select dshiftbk
   seek pcoy+dtos(pshdate)
   if .not. found()
   append blank
   replace coy with pcoy
   replace shift_date with pshdate
      REPLACE SUP_PRICE WITH SHIFTBK->SUP_PRICE
      REPLACE KER_PRICE WITH SHIFTBK->KER_PRICE
      REPLACE UNL_PRICE WITH SHIFTBK->UNL_PRICE
      REPLACE DIS_PRICE WITH SHIFTBK->DIS_PRICE
      REPLACE REG_PRICE WITH SHIFTBK->REG_PRICE
      *
    replace op_capital with shiftbk->op_capital
    replace op_mpfloat with shiftbk->op_mpfloat
    replace op_mliquid with shiftbk->op_mliquid
    replace mp_capital with shiftbk->mp_capital
    replace cl_capital with shiftbk->cl_capital 
    replace cl_mpfloat with shiftbk->cl_mpfloat
    replace cl_mliquid with shiftbk->cl_mliquid
    replace mp_float with shiftbk->mp_float
    replace mp_liquid with shiftbk->mp_liquid
      *
replace purc_sup_q with shiftbk->purc_sup_q
   replace purc_ker_q with shiftbk->purc_ker_q
    replace purc_unl_q with shiftbk->purc_unl_q
     replace purc_reg_q with shiftbk->purc_reg_q
      replace purc_dis_q with shiftbk->purc_dis_q
      
  replace open_sup_q with shiftbk->open_sup_q
  replace open_ker_q with shiftbk->open_ker_q
  replace open_reg_q with shiftbk->open_reg_q
  replace open_unl_q with shiftbk->open_unl_q
  replace open_dis_q with shiftbk->open_dis_q
   replace open_LSD_q with shiftbk->open_LSD_q
  
  replace book_sup_q with shiftbk->book_sup_q
   replace book_ker_q with shiftbk->book_ker_q
    replace book_unl_q with shiftbk->book_unl_q
     replace book_reg_q with shiftbk->book_reg_q
      replace book_dis_q with shiftbk->book_dis_q
      replace book_LSD_q with shiftbk->book_LSD_q
      
       replace phy_sup_q with shiftbk->phy_sup_q
        replace phy_unl_q with shiftbk->phy_unl_q
         replace phy_ker_q with shiftbk->phy_ker_q
          replace phy_reg_q with shiftbk->phy_reg_q
           replace phy_dis_q with shiftbk->phy_dis_q
           replace phy_LSD_q with shiftbk->phy_LSD_q
           
replace sale_sup_q with shiftbk->sale_sup_q
   replace sale_ker_q with shiftbk->sale_ker_q
    replace sale_unl_q with shiftbk->sale_unl_q
     replace sale_reg_q with shiftbk->sale_reg_q
      replace sale_dis_q with shiftbk->sale_dis_q
      replace sale_LSD_q with shiftbk->sale_LSD_q
      
        replace sale_sup_a with shiftbk->sale_sup_a
   replace sale_ker_a with shiftbk->sale_ker_a
    replace sale_unl_a with shiftbk->sale_unl_a
     replace sale_reg_a with shiftbk->sale_reg_a
      replace sale_dis_a with shiftbk->sale_dis_a
      replace sale_LSD_a with shiftbk->sale_LSD_a
      
  
  
  replace mobilesals with shiftbk->mobilesals
   
  REPLACE day_cash WITH shiftbk->A_C_INHAND
  replace night_cash with 0
   
 REPLACE OP_C_HAND WITH shiftbk->OP_C_HAND
   REPLACE CL_C_HAND WITH shiftbk->CL_C_HAND
   REPLACE A_C_INHAND WITH shiftbk->A_C_INHAND
   REPLACE TOTAL_CASH WITH shiftbk->TOTAL_CASH 
   REPLACE SH_C_SALES WITH shiftbk->SH_C_SALES 
  REPLACE C_SH_SHOP WITH shiftbk->C_SH_SHOP 
  REPLACE C_SH_WORK WITH shiftbk->C_SH_WORK 
  REPLACE C_SH_CARDS WITH shiftbk->C_SH_CARDS
    REPLACE C_SH_FUELS WITH shiftbk->C_SH_FUELS
  REPLACE C_SH_CANT WITH shiftbk->C_SH_CANT 
   REPLACE CASH_DEBT WITH shiftbk->CASH_DEBT 
    REPLACE CASH_WORK WITH shiftbk->CASH_WORK
     REPLACE CASH_SHOP WITH  shiftbk->CASH_SHOP   
      REPLACE CASH_CARDS WITH shiftbk->CASH_CARDS  
       REPLACE CASH_CANT WITH  shiftbk->CASH_CANT 
        REPLACE CASH_P_EXP WITH shiftbk->CASH_P_EXP 
         REPLACE CASH_P_PUR WITH shiftbk->CASH_P_PUR
          REPLACE CASH_BANK WITH shiftbk->CASH_BANK 
             REPLACE MBK_MONEY WITH SHIFTBK->MBK_MONEY
             REPLACE MBD_MONEY WITH SHIFTBK->MBD_MONEY
             REPLACE MBP_MONEY WITH SHIFTBK->MBP_MONEY
           REPLACE CASH_SHORT WITH shiftbk->CASH_SHORT
    replace cash_coy with  shiftbk->cash_coy
    replace cash_merch with shiftbk->cash_merch
    replace cash_food with shiftbk->cash_food
    replace cash_motor with shiftbk->cash_motor
    replace cash_staff with shiftbk->cash_staff
    replace cash_gen with shiftbk->cash_gen
    replace cash_withd with shiftbk->cash_withd
    replace cash_lubes with shiftbk->cash_lubes
    replace t_cash_pay with shiftbk->t_cash_pay
    replace net_cash with  shiftbk->net_cash
    replace t_cash_rec with shiftbk->t_cash_rec
   
   replace vs_barclay with shiftbk->vs_barclay 
     replace vs_others  with shiftbk->vs_others 
      replace vs_company with shiftbk->vs_company 
       replace chqs_sale with shiftbk->chqs_sale 
       replace cash_soda with shiftbk->cash_soda
       replace non_cash with shiftbk->non_cash
       
replace  fc_c_sales with  shiftbk->fc_c_sales
replace  reserved1 with  shiftbk->reserved1
replace  reserved2 with  shiftbk->reserved2
replace  reserved3 with  shiftbk->reserved3
replace  reserved4 with  shiftbk->reserved4
replace  reserved5 with  shiftbk->reserved5
replace  dbdebits with  shiftbk->dbdebits
replace  dbcredits with  shiftbk->dbcredits

replace  CHQS_BANK with  shiftbk->CHQS_BANK
replace  A_CASH with  shiftbk->A_CASH
replace  cash_hand with  shiftbk->cash_hand
replace  c_tstore with  shiftbk->c_tstore
replace  c_pstore with  shiftbk->c_pstore
replace  c_mstore with  shiftbk->c_mstore
replace  c_mmoney with  shiftbk->c_mmoney

    else
     replace cash_hand with  shiftbk->cash_hand +  cash_hand
     replace A_CASH with  shiftbk->A_CASH +  A_CASH
     replace CHQS_BANK with  shiftbk->CHQS_BANK +  CHQS_BANK
    replace mobilesals with mobilesals + shiftbk->mobilesals
replace  fc_c_sales with  shiftbk->fc_c_sales +  fc_c_sales
replace  reserved1 with  shiftbk->reserved1 +  reserved1
replace  reserved2 with  shiftbk->reserved2 +  reserved2
replace  reserved3 with  shiftbk->reserved3 +  reserved3
replace  reserved4 with  shiftbk->reserved4 +  reserved4
replace  reserved5 with  shiftbk->reserved5 +  reserved5
replace  dbdebits with  shiftbk->dbdebits +  dbdebits
replace  dbcredits with  shiftbk->dbcredits +  dbcredits

replace  c_mmoney with  shiftbk->c_mmoney +  c_mmoney
replace  c_mstore with  shiftbk->c_mstore +  c_mstore
replace  c_tstore with  shiftbk->c_tstore +  c_tstore
replace  c_pstore with  shiftbk->c_pstore +  c_pstore


    replace night_cash with night_cash + shiftbk->A_C_INHAND
    replace cash_soda with shiftbk->cash_soda + cash_soda
       replace non_cash with shiftbk->non_cash + non_cash
       
   replace vs_barclay with shiftbk->vs_barclay + vs_barclay
     replace vs_others  with shiftbk->vs_others + vs_others
      replace vs_company with shiftbk->vs_company + vs_company
       replace chqs_sale with shiftbk->chqs_sale  + chqs_sale
       
replace purc_sup_q with shiftbk->purc_sup_q + purc_sup_q
   replace purc_ker_q with shiftbk->purc_ker_q + purc_ker_q
    replace purc_unl_q with shiftbk->purc_unl_q + purc_unl_q
     replace purc_reg_q with shiftbk->purc_reg_q + purc_reg_q
      replace purc_dis_q with shiftbk->purc_dis_q + purc_dis_q
      replace purc_LSD_q with shiftbk->purc_LSD_q + purc_LSD_q
      
   replace book_sup_q with shiftbk->book_sup_q
   replace book_ker_q with shiftbk->book_ker_q
    replace book_unl_q with shiftbk->book_unl_q
     replace book_reg_q with shiftbk->book_reg_q
      replace book_dis_q with shiftbk->book_dis_q
      replace book_LSD_q with shiftbk->book_LSD_q
      
       replace phy_sup_q with shiftbk->phy_sup_q
        replace phy_unl_q with shiftbk->phy_unl_q
         replace phy_ker_q with shiftbk->phy_ker_q
          replace phy_reg_q with shiftbk->phy_reg_q
           replace phy_dis_q with shiftbk->phy_dis_q
           replace phy_LSD_q with shiftbk->phy_LSD_q
           
replace mp_capital with mp_capital + shiftbk->mp_capital
    replace cl_capital with shiftbk->cl_capital 
    replace cl_mpfloat with shiftbk->cl_mpfloat
    replace cl_mliquid with shiftbk->cl_mliquid
    replace mp_float with mp_float + shiftbk->mp_float
    replace mp_liquid with mp_liquid + shiftbk->mp_liquid
    
replace sale_sup_q with shiftbk->sale_sup_q + sale_sup_q
   replace sale_ker_q with shiftbk->sale_ker_q + sale_ker_q
    replace sale_unl_q with shiftbk->sale_unl_q + sale_unl_q
     replace sale_reg_q with shiftbk->sale_reg_q + sale_reg_q
      replace sale_dis_q with shiftbk->sale_dis_q + sale_dis_q
      replace sale_LSD_q with shiftbk->sale_LSD_q + sale_LSD_q
                
replace sale_sup_a with shiftbk->sale_sup_a + sale_sup_a
   replace sale_ker_a with shiftbk->sale_ker_a + sale_ker_a
    replace sale_unl_a with shiftbk->sale_unl_a + sale_unl_a
     replace sale_reg_a with shiftbk->sale_reg_a + sale_reg_a
      replace sale_dis_a with shiftbk->sale_dis_a + sale_dis_a
       replace sale_LSD_a with shiftbk->sale_LSD_a + sale_LSD_a
      

 
  REPLACE CL_C_HAND WITH shiftbk->CL_C_HAND
   
 REPLACE t_cash_rec WITH shiftbk->t_cash_rec + t_cash_rec
 
   REPLACE A_C_INHAND WITH shiftbk->A_C_INHAND + A_C_INHAND 
   REPLACE TOTAL_CASH WITH shiftbk->t_cash_rec + total_cash
   REPLACE SH_C_SALES WITH shiftbk->SH_C_SALES + SH_C_SALES
   REPLACE C_SH_SHOP WITH shiftbk->C_SH_SHOP + C_SH_SHOP
REPLACE C_SH_WORK WITH shiftbk->C_SH_WORK + C_SH_WORK

  REPLACE C_SH_CANT WITH shiftbk->C_SH_CANT + C_SH_CANT
REPLACE C_SH_FUELS WITH shiftbk->C_SH_FUELS + C_SH_FUELS
   REPLACE C_SH_CARDS WITH shiftbk->C_SH_CARDS + C_SH_CARDS 
   REPLACE CASH_DEBT WITH shiftbk->CASH_DEBT + CASH_DEBT 
    REPLACE CASH_WORK WITH shiftbk->CASH_WORK + CASH_WORK
     REPLACE CASH_SHOP WITH  shiftbk->CASH_SHOP   + CASH_SHOP 
      REPLACE CASH_CARDS WITH shiftbk->CASH_CARDS  + CASH_CARDS 
       REPLACE CASH_CANT WITH  shiftbk->CASH_CANT + CASH_CANT 
        REPLACE CASH_P_EXP WITH shiftbk->CASH_P_EXP + CASH_P_EXP 
         REPLACE CASH_P_PUR WITH shiftbk->CASH_P_PUR + CASH_P_PUR
          REPLACE CASH_BANK WITH shiftbk->CASH_BANK + CASH_BANK 
           REPLACE CASH_SHORT WITH shiftbk->CASH_SHORT + CASH_SHORT
      REPLACE MBK_MONEY WITH shiftbk->MBK_MONEY + MBK_MONEY 
      REPLACE MBD_MONEY WITH SHIFTBK->MBD_MONEY + MBD_MONEY 
      REPLACE MBP_MONEY WITH SHIFTBK->MBP_MONEY + MBP_MONEY 
    replace cash_coy with  shiftbk->cash_coy + cash_coy
    replace cash_merch with shiftbk->cash_merch + cash_merch
    replace cash_food with shiftbk->cash_food + cash_food
    replace cash_motor with shiftbk->cash_motor + cash_motor
    replace cash_staff with shiftbk->cash_staff + cash_staff
    replace cash_gen with shiftbk->cash_gen + cash_gen
    replace cash_withd with shiftbk->cash_withd + cash_withd
    replace cash_lubes with shiftbk->cash_lubes + cash_lubes
    replace t_cash_pay with shiftbk->t_cash_pay + t_cash_pay
    replace net_cash with  shiftbk->net_cash + net_cash - shiftbk->OP_C_HAND
    REPLACE SUP_PRICE WITH SHIFTBK->SUP_PRICE
      REPLACE KER_PRICE WITH SHIFTBK->KER_PRICE
      REPLACE UNL_PRICE WITH SHIFTBK->UNL_PRICE
      REPLACE DIS_PRICE WITH SHIFTBK->DIS_PRICE
      REPLACE REG_PRICE WITH SHIFTBK->REG_PRICE
       REPLACE LSD_PRICE WITH SHIFTBK->LSD_PRICE

    endif
    REPLACE SUP_PRICE WITH SHIFTBK->SUP_PRICE
      REPLACE KER_PRICE WITH SHIFTBK->KER_PRICE
      REPLACE UNL_PRICE WITH SHIFTBK->UNL_PRICE
      REPLACE DIS_PRICE WITH SHIFTBK->DIS_PRICE
      REPLACE REG_PRICE WITH SHIFTBK->REG_PRICE
       REPLACE LSD_PRICE WITH SHIFTBK->LSD_PRICE

  do  update_pos_rtn3


 procedure update_pos_rtn3
         LOCAL L1,L2,LCS,LOPC,LCDEBTS,LDBCRS,LCSTAFF,LCSBANK,LCQBANK,LCSHORT,lcpesa,lfmtr,lmbk,lmbd,lmbp
   L1 = shiftbk->COY
   L2 = shiftbk->SHIFT_DATE
   lmbk = shiftbk->mbk_money
   lmbd = shiftbk->mbd_money
   lmbp = shiftbk->mbp_money
   
    LOPC = shiftbk->OP_C_HAND
   LCDEBTS = shiftbk->CASH_DEBT
   LDBCRS = shiftbk->DBCREDITS
   LCSTAFF = shiftbk->CASH_CARDS
   LCSBANK = shiftbk->CASH_BANK
   LCSHORT  = shiftbk->CASH_SHORT
   lcpesa  = SHIFTBK->batchamt
   LCSP = SHIFTBK->CASH_MOTOR +  SHIFTBK->CASH_WITHD  + SHIFTBK->CASH_STAFF ;
    + SHIFTBK->CASH_LUBES + SHIFTBK->CASH_GEN  && PETTY CASH
    LCSF  =   SHIFTBK->CASH_FOOD + SHIFTBK->CASH_COY
    LCHQB = SHIFTBK->CASH_MERCH
    lfmtr = SHIFTBK->cash_p_exp * -1

  select fgdacash
        seek L1+DTOS(L2)
        if .not. found()
        append blank
        replace coy with L1
        replace shift_date with L2
        replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with  LOPC
        replace coll_debts with 0  && DONE
        replace cr_notes with 0 && DONE
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0 && DONE
        replace payments with 0  && DONE FLOAT
        replace petty_cash with 0  && DONE FC CASH
        replace salaries with 0
        replace cl_c_hand with 0
         replace chq_sales with 0
        replace dr_staff with 0
        replace mbk_money with 0
        replace mbd_money with 0
        replace mbp_money with 0
      endif
      replace  cl_c_hand with shiftbk->cl_c_hand
       REPLACE coll_debts WITH coll_debts + LCDEBTS
      REPLACE cr_notes WITH cr_notes + LDBCRS 
      REPLACE coll_staff WITH coll_staff + LCSTAFF
      REPLACE bankings WITH bankings + LCSBANK
      REPLACE  PETTY_CASH WITH PETTY_CASH + LCSP
      REPLACE PAYMENTS WITH PAYMENTS +  LCSF
      REPLACE DR_NOTES WITH DR_NOTES + LCSHORT
      REPLACE CHQ_SALES WITH CHQ_SALES + LCHQB
       replace  dr_staff with dr_staff + lcpesa
       replace sal_cash with sal_cash + lfmtr
        replace sal_credit with sal_credit - lfmtr
      replace mbk_money with mbk_money + lmbk
       replace mbd_money with mbk_money + lmbd
        replace mbp_money with mbk_money + lmbp
      
      local l1,l2,l3,l4
         l1 = dtos(fgdacash->shift_date) && yyyymmdd
         l2 = left(l1,6) && yyyymm
         l3 = right(l2,2) && mm
         l4 = left(l2,4) && yyyy
         l1 = fgdacash->coy
         select fgmocash
         seek l1+l4+l3
         if .not. found()
         append blank
         replace coy with l1
         replace yy with l4
         replace mm with l3
         replace sal_cash with 0
        replace sal_credit with 0
        replace op_c_hand with LOPC
        replace coll_debts with 0
        replace cr_notes with 0
        replace coll_staff with 0
        replace dr_notes with 0
        replace bankings with 0
        replace payments with 0
        replace petty_cash with 0
        replace salaries with 0
        replace cl_c_hand with 0
        replace dr_staff with 0
        replace chq_sales with 0
        replace mbk_money with 0
        replace mbd_money with 0
        replace mbp_money with 0
        
      endif
      replace  cl_c_hand with shiftbk->cl_c_hand
       REPLACE coll_debts WITH coll_debts + LCDEBTS
      REPLACE cr_notes WITH cr_notes + LDBCRS 
      REPLACE coll_staff WITH coll_staff + LCSTAFF
      REPLACE bankings WITH bankings + LCSBANK
      REPLACE PETTY_CASH WITH PETTY_CASH + LCSP
      REPLACE PAYMENTS WITH PAYMENTS +  LCSF
      REPLACE DR_NOTES WITH DR_NOTES + LCSHORT
      REPLACE CHQ_SALES WITH CHQ_SALES + LCHQB
       replace  dr_staff with dr_staff + lcpesa
       replace sal_cash with sal_cash + lfmtr
        replace sal_credit with sal_credit - lfmtr
   replace mbk_money with mbk_money + lmbk
       replace mbd_money with mbk_money + lmbd
        replace mbp_money with mbk_money + lmbp
   
  
procedure shiftmn_rtn1
   local l1
    pcoy = shiftmn->coy
      pshdate = shiftmn->shift_date
      pyy = str(year(shiftmn->shift_date),4)
      pmm  = str(month(shiftmn->shift_date),2)
      ppdate = shiftmn->shift_date - 1
      pndate = shiftmn->shift_date + 1
      
      l1 = val(pmm)
      pqtr = "9"
      ppqtr = "9"
      pnqtr = "9"
      if l1 = 1  .or. l1 = 2 .or. l1 = 3
      pqtr = "1"
      ppqtr = "4"
      pnqtr = "2"
      endif
       if l1 = 4  .or. l1 = 5 .or. l1 = 6
      pqtr = "2"
      ppqtr = "1"
      pnqtr = "3"
      endif
       if l1 = 7  .or. l1 = 8 .or. l1 = 9
      pqtr = "3"
      ppqtr = "2"
      pnqtr = "4"
      endif
       if l1 = 10 .or. l1 = 11 .or. l1 = 12
      pqtr = "4"
      ppqtr = "3"
      pnqtr = "1"
      endif
      ppyy = str(year(ppdate),4)
      if pmm = "12"
      pnmm = "01"
      pnyy = str(val(pyy)+1,4)
      else
      pnmm = str(val(pmm)+1,2)
      pnyy = pyy
      endif
      if pmm = "01"
      ppmm = "12"
      ppyy = str(val(pyy)-1,4)
      else
      ppmm = str(val(pmm)-1,2)
      ppyy = pyy
      endif
     do shiftmn_rtn2
     select shiftmn
     replace post_date with date()
     skip
     if eof()
     eofshiftmn = .t.
     endif

Procedure shiftmn_rtn2
     select dshiftmn
   seek pcoy+dtos(pshdate)
   if .not. found()
   append blank
   replace coy with pcoy
   replace shift_date with pshdate
 replace cl_MM_Q_01 with shiftmn->cl_MM_Q_01
   replace cl_MM_Q_02 with shiftmn->cl_MM_Q_02
   replace cl_MM_Q_03 with shiftmn->cl_MM_Q_03
   replace cl_MM_Q_04 with shiftmn->cl_MM_Q_04
   replace cl_MM_Q_05 with shiftmn->cl_MM_Q_05
   replace cl_MM_Q_06 with shiftmn->cl_MM_Q_06
   replace cl_MM_Q_07 with shiftmn->cl_MM_Q_07
   replace cl_MM_Q_08 with shiftmn->cl_MM_Q_08
   replace cl_MM_Q_09 with shiftmn->cl_MM_Q_09
   replace cl_MM_Q_10 with shiftmn->cl_MM_Q_10
   replace cl_MM_Q_11 with shiftmn->cl_MM_Q_11
   replace cl_MM_Q_12 with shiftmn->cl_MM_Q_12
   replace cl_MM_Q_13 with shiftmn->cl_MM_Q_13
   replace cl_MM_Q_14 with shiftmn->cl_MM_Q_14
   replace cl_MM_Q_15 with shiftmn->cl_MM_Q_15
   
    replace cl_MM_Q_16 with shiftmn->cl_MM_Q_16
   replace cl_MM_Q_17 with shiftmn->cl_MM_Q_17
   replace cl_MM_Q_18 with shiftmn->cl_MM_Q_18
   replace cl_MM_Q_19 with shiftmn->cl_MM_Q_19
   replace cl_MM_Q_20 with shiftmn->cl_MM_Q_20
   
   replace cl_MM_Q_21 with shiftmn->cl_MM_Q_21
   
    replace cl_MM_Q_22 with shiftmn->cl_MM_Q_22
   replace cl_MM_Q_23 with shiftmn->cl_MM_Q_23
   replace cl_MM_Q_24 with shiftmn->cl_MM_Q_24
   replace cl_MM_Q_25 with shiftmn->cl_MM_Q_25
   replace cl_MM_Q_26 with shiftmn->cl_MM_Q_26
   replace cl_MM_Q_27 with shiftmn->cl_MM_Q_27
   replace cl_MM_Q_28 with shiftmn->cl_MM_Q_28
 replace cl_MM_Q_29 with shiftmn->cl_MM_Q_29
replace cl_MM_Q_30 with shiftmn->cl_MM_Q_30
replace cl_MM_Q_31 with shiftmn->cl_MM_Q_31
replace cl_MM_Q_32 with shiftmn->cl_MM_Q_32
replace cl_MM_Q_33 with shiftmn->cl_MM_Q_33
replace cl_MM_Q_34 with shiftmn->cl_MM_Q_34

   replace op_MM_Q_01 with shiftmn->op_MM_Q_01
   replace op_MM_Q_02 with shiftmn->op_MM_Q_02
   replace op_MM_Q_03 with shiftmn->op_MM_Q_03
   replace op_MM_Q_04 with shiftmn->op_MM_Q_04
   replace op_MM_Q_05 with shiftmn->op_MM_Q_05
   replace op_MM_Q_06 with shiftmn->op_MM_Q_06
   replace op_MM_Q_07 with shiftmn->op_MM_Q_07
   replace op_MM_Q_08 with shiftmn->op_MM_Q_08
   replace op_MM_Q_09 with shiftmn->op_MM_Q_09
   replace op_MM_Q_10 with shiftmn->op_MM_Q_10
   replace op_MM_Q_11 with shiftmn->op_MM_Q_11
   replace op_MM_Q_12 with shiftmn->op_MM_Q_12
   replace op_MM_Q_13 with shiftmn->op_MM_Q_13
   replace op_MM_Q_14 with shiftmn->op_MM_Q_14
   replace op_MM_Q_15 with shiftmn->op_MM_Q_15
   
   replace op_MM_Q_16 with shiftmn->op_MM_Q_16
   replace op_MM_Q_17 with shiftmn->op_MM_Q_17
   replace op_MM_Q_18 with shiftmn->op_MM_Q_18
   replace op_MM_Q_19 with shiftmn->op_MM_Q_19
   replace op_MM_Q_20 with shiftmn->op_MM_Q_20
   
   replace op_MM_Q_21 with shiftmn->op_MM_Q_21
   
   replace op_MM_Q_22 with shiftmn->op_MM_Q_22
   replace op_MM_Q_23 with shiftmn->op_MM_Q_23
   replace op_MM_Q_24 with shiftmn->op_MM_Q_24
   replace op_MM_Q_25 with shiftmn->op_MM_Q_25
   replace op_MM_Q_26 with shiftmn->op_MM_Q_26
   replace op_MM_Q_27 with shiftmn->op_MM_Q_27
   replace op_MM_Q_28 with shiftmn->op_MM_Q_28
   replace op_MM_Q_29 with shiftmn->op_MM_Q_29
replace op_MM_Q_30 with shiftmn->op_MM_Q_30
replace op_MM_Q_31 with shiftmn->op_MM_Q_31
replace op_MM_Q_32 with shiftmn->op_MM_Q_32
replace op_MM_Q_33 with shiftmn->op_MM_Q_33
replace op_MM_Q_34 with shiftmn->op_MM_Q_34
else 
      
   replace cl_MM_Q_01 with shiftmn->cl_MM_Q_01
   replace cl_MM_Q_02 with shiftmn->cl_MM_Q_02
   replace cl_MM_Q_03 with shiftmn->cl_MM_Q_03
   replace cl_MM_Q_04 with shiftmn->cl_MM_Q_04
   replace cl_MM_Q_05 with shiftmn->cl_MM_Q_05
   replace cl_MM_Q_06 with shiftmn->cl_MM_Q_06
   replace cl_MM_Q_07 with shiftmn->cl_MM_Q_07
   replace cl_MM_Q_08 with shiftmn->cl_MM_Q_08
   replace cl_MM_Q_09 with shiftmn->cl_MM_Q_09
   replace cl_MM_Q_10 with shiftmn->cl_MM_Q_10
   replace cl_MM_Q_11 with shiftmn->cl_MM_Q_11
   replace cl_MM_Q_12 with shiftmn->cl_MM_Q_12
   replace cl_MM_Q_13 with shiftmn->cl_MM_Q_13
   replace cl_MM_Q_14 with shiftmn->cl_MM_Q_14
   replace cl_MM_Q_15 with shiftmn->cl_MM_Q_15
    
    replace cl_MM_Q_16 with shiftmn->cl_MM_Q_16
   replace cl_MM_Q_17 with shiftmn->cl_MM_Q_17
   replace cl_MM_Q_18 with shiftmn->cl_MM_Q_18
   replace cl_MM_Q_19 with shiftmn->cl_MM_Q_19
   replace cl_MM_Q_20 with shiftmn->cl_MM_Q_20
   
   replace cl_MM_Q_21 with shiftmn->cl_MM_Q_21
    
    replace cl_MM_Q_22 with shiftmn->cl_MM_Q_22
   replace cl_MM_Q_23 with shiftmn->cl_MM_Q_23
   replace cl_MM_Q_24 with shiftmn->cl_MM_Q_24
   replace cl_MM_Q_25 with shiftmn->cl_MM_Q_25
   replace cl_MM_Q_26 with shiftmn->cl_MM_Q_26
   replace cl_MM_Q_27 with shiftmn->cl_MM_Q_27
    replace cl_MM_Q_28 with shiftmn->cl_MM_Q_28
    replace cl_MM_Q_29 with shiftmn->cl_MM_Q_29
replace cl_MM_Q_30 with shiftmn->cl_MM_Q_30
replace cl_MM_Q_31 with shiftmn->cl_MM_Q_31
replace cl_MM_Q_32 with shiftmn->cl_MM_Q_32
replace cl_MM_Q_33 with shiftmn->cl_MM_Q_33
replace cl_MM_Q_34 with shiftmn->cl_MM_Q_34
   
 endif
 
 Procedure scashrec_rtn
    local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,lerr
       l1 = scashrec->shift_date
       l9 = scashrec->shift_no
       l10 = scashrec->shift_id
       l2 = scashrec->cashr_no
       l3 = scashrec->cen
       l4 = scashrec->sto
       l5 = scashrec->typ
       l6 = scashrec->cla
       l7 = scashrec->cod
       lerr = .f.
       if   exp_sales = 0 .and. non_cash = 0 .and. exp_cash = 0 .and. shortage = 0 ;
      .and. a_cash = 0 .and. chqs = 0 .and. purch = 0 .and. coyvisa = 0 .and. genvisa = 0 ;
       .and. recepts = 0 .and. paymnts = 0 .and. bbkvisa = 0 .and. pdebits = 0 ;
        .and. pcredits = 0 .and. ppurch = 0 .and. cr_notes = 0 .and. dr_notes = 0 ;
         .and. fc_sales = 0 .and. cash_bank = 0 .and. dbcredits = 0 .and. chqs_bank = 0 ;
          .and. dbdebits = 0 .and. a_c_inhand = 0 ;
           .and. reserved1 = 0 .and. reserved2 = 0 .and. reserved3 = 0 .and. reserved4 = 0 ;
            .and. reserved5 = 0
            lerr = .t.
            endif

if .not. lerr
       select cashiers
       seek l2
       if found()
       l8 = off
       else
       l8 = "001"
       endif
       select dacasrec
       seek dtos(l1)+l2+l3+l4+l5+l6+l7+l8
       if .not. found()
       append blank
       replace off with l8
       
       replace cashr_no with  l2
   replace shift_date with l1
   replace cen with l3
    replace sto with l4
   replace typ with l5
   replace cla with l6
   replace cod with l7
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
    replace a_c_inhand with a_c_inhand +  scashrec->a_c_inhand
    replace cash_bank with cash_bank +  scashrec->cash_bank
   replace dbdebits with dbdebits + scashrec->dbdebits
    replace dbcredits with dbcredits + scashrec->dbcredits
  REPLACE chqs_bank with chqs_bank + scashrec->chqs_bank
   REPLACE reserved1 with reserved1 + scashrec->reserved1
   REPLACE reserved2 with reserved2 + scashrec->reserved2
   REPLACE reserved3 with reserved3 + scashrec->reserved3
   REPLACE reserved4 with reserved4 + scashrec->reserved4
   REPLACE reserved5 with reserved5 + scashrec->reserved5
 
  replace non_cash with non_cash +  scashrec->non_cash
   replace exp_cash with exp_cash + scashrec->exp_cash
    replace exp_sales with exp_sales + scashrec->exp_sales
  REPLACE COYVISA with COYVISA + scashrec->COYVISA
   REPLACE BBKVISA with BBKVISA + scashrec->BBKVISA
   REPLACE GENVISA with GENVISA + scashrec->GENVISA
   REPLACE CHQS with CHQS + scashrec->CHQS
   REPLACE PAYMNTS with PAYMNTS + scashrec->PAYMNTS
   REPLACE RECEPTS with RECEPTS + scashrec->RECEPTS
   REPLACE PURCH with PURCH + scashrec->PURCH
   replace A_CASH with A_CASH + scashrec->A_CASH
   replace shortage with shortage + scashrec->shortage
   replace cr_notes with cr_notes + scashrec->cr_notes
   replace dr_notes with dr_notes + scashrec->dr_notes
   replace pdebits with pdebits + scashrec->pdebits
   replace pcredits with pcredits + scashrec->pcredits
   replace ppurch with ppurch + scashrec->ppurch
   replace fc_sales with fc_sales + scashrec->fc_sales
   select hcashrec
       seek dtos(l1)+l9+l10+l2+l3+l4+l5+l6+l7+l8
       if .not. found()
       append blank
       replace off with l8
       replace shift_no with l9
       replace shift_id with l10
       replace cashr_no with  l2
   replace shift_date with l1
   replace cen with l3
    replace sto with l4
   replace typ with l5
   replace cla with l6
   replace cod with l7
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
    replace a_c_inhand with a_c_inhand +  scashrec->a_c_inhand
    replace cash_bank with cash_bank +  scashrec->cash_bank
   replace dbdebits with dbdebits + scashrec->dbdebits
    replace dbcredits with dbcredits + scashrec->dbcredits
  REPLACE chqs_bank with chqs_bank + scashrec->chqs_bank
   REPLACE reserved1 with reserved1 + scashrec->reserved1
   REPLACE reserved2 with reserved2 + scashrec->reserved2
   REPLACE reserved3 with reserved3 + scashrec->reserved3
   REPLACE reserved4 with reserved4 + scashrec->reserved4
   REPLACE reserved5 with reserved5 + scashrec->reserved5
 
  replace non_cash with non_cash +  scashrec->non_cash
   replace exp_cash with exp_cash + scashrec->exp_cash
    replace exp_sales with exp_sales + scashrec->exp_sales
  REPLACE COYVISA with COYVISA + scashrec->COYVISA
   REPLACE BBKVISA with BBKVISA + scashrec->BBKVISA
   REPLACE GENVISA with GENVISA + scashrec->GENVISA
   REPLACE CHQS with CHQS + scashrec->CHQS
   REPLACE PAYMNTS with PAYMNTS + scashrec->PAYMNTS
   REPLACE RECEPTS with RECEPTS + scashrec->RECEPTS
   REPLACE PURCH with PURCH + scashrec->PURCH
   replace A_CASH with A_CASH + scashrec->A_CASH
   replace shortage with shortage + scashrec->shortage
   replace cr_notes with cr_notes + scashrec->cr_notes
   replace dr_notes with dr_notes + scashrec->dr_notes
   replace pdebits with pdebits + scashrec->pdebits
   replace pcredits with pcredits + scashrec->pcredits
   replace ppurch with ppurch + scashrec->ppurch
   replace fc_sales with fc_sales + scashrec->fc_sales
endif
   SELECT SCASHREC
   replace post_date with date()
   skip
   if eof()
   eofscashrec = .t.
   endif
 
   
Procedure st15fc05_RTN
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL

  
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Initializing Data Entry files in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set view to "st15fc05.QBE"
SET REPROCESS TO -1
      do st15fc05_RTN1
      PNEWMTH = .F.
      pnshift = .f.
      SELECT ST15F
      GO TOP
      if .not. oshdate = shift_date
      pnshift = .t.
      endif
      local lz1,lz2,lz3
      lz1 = dtos(shift_date) && yyyymmdd
      lz1 = left(lz1,6) && yyyymm
      lz2 = left(lz1,4) && yyyy
      lz1 = right(lz1,2) && mm
      select fgnewmth
      set order to mkey
      go top
      if eof()
       append blank
      replace month with lz1
      replace year with lz2
      replace shift_date with date()
      replace shift_time with time()
      replace shift_user with pluser
      pnewmth = .t.
   endif
      seek lz1+lz2
      if .not. found()
      append blank
      replace month with lz1
      replace year with lz2
      replace shift_date with date()
      replace shift_time with time()
      replace shift_user with pluser
      pnewmth = .t.
      endif
      if pnshift
         set safety off
         select fgtrnref
         zap
         set safety on
     endif
    
      IF PNEWMTH
         set safety off
         select dasalsum
         zap
         set safety on
         endif
             close tables
      close databases
      clear program
   
      progreps.close()      
       CLEAR PROGRAM
         IF PNEWMTH
           DO fg3052EM_RTN
      ENDIF
      set safety off
     
    set safety on
 close databases
Procedure st15fc05_RTN1

   set safety off
   select scashrec
   SET ORDER TO MKEY
   eofst15f = .f.
   select st15f
   go top
   if .not. eof()
      do
         do end_rtn1
         until eofst15f
     endif
     GO TOP
  
    select cashiers
    if st15f->shift_id = "0" && whole shift
  replace all off with ""
  replace all name with ""
  endif
  replace all a_cash with 0
  replace all coy with ""
  replace all div with ""
  replace all cen with ""
  set safety off
  if st15f->shift_id = "0" && whole shift
  select fgoff
  replace all shift_date with {}
  replace all cashier_no with ""
  
  select fgoffs
  replace all shift_date with {}
  replace all cashier_no with ""
 
   eofcashiers = .f.
    select fgoffs
     set order to off
   select fgoff
   set order to off
   select cashiers
   go top
   if .not. eof()
      do
         do Fshcashrs_rtn1 
         until eofcashiers
     endif
       endif
      eofststo = .f.
      select ststo
      set filter to (left(sto,1) = "K"  .or. left(sto,1) = "P" .or. left(sto,1) = "U" ;
       .or. left(sto,1) = "L"  .or. left(sto,1) = "R" .or. left(sto,1) = "P")  .and. ;
       .not. empty(off) .and.  qty_sold > 0 .and. .not. empty(shift_date) ;
       .and. .not. empty(shift_id) .and. .not. empty(shift_no) 
       go top
       if .not. eof()
       do
          do fgpumsal_rtn
        until eofststo
     endif
     select ststo
     set filter to
     go top
     replace all off with "" && no officer allocated now
     replace all qty_sold with 0
     replace all offname with ""
     replace all shift_id with ""
     replace all shift_no with ""
     replace all shift_date with {}
     
procedure fgpumsal_rtn
      select fgpumsal
      append blank
      replace sto with ststo->sto
      replace off  with ststo->off
      replace shift_date with ststo->shift_date
      replace shift_no with ststo->shift_no
      replace shift_id with ststo->shift_id
      replace qty_sold with ststo->qty_sold
      if shift_no = "0"  && day shift
      replace comm_rate with ststo->day_rate
      else
      replace comm_rate with ststo->night_rate
      endif
      select ststo
      skip
      if eof()
      eofststo = .t.
      endif
procedure Fshcashrs_rtn1
   local p1,p2
        p1 = cashiers->nameN
        p2 = cashiers->OFFN
        if .not. empty(p1)
     select Fgoffs
      seek p2
      if found()
      replace shift_date with ST15F->SHIFT_DATE
      replace shift_id with ST15F->SHIFT_ID
      replace shift_no with ST15F->SHIFT_NO
      replace cashier_no with CASHIERS->cashr_NO
      REPLACE CASHIERNO WITH ""
         endif
         select Fgoff
         seek p2
         if found()
       replace shift_date with ST15F->SHIFT_DATE
      replace shift_id with ST15F->SHIFT_ID
      replace shift_no with ST15F->SHIFT_NO
      replace cashier_no with CASHIERS->cashr_no
      REPLACE CASHIERNO WITH ""
           endif
         endif
   select cashiers
   REPLACE OFF WITH OFFN
   REPLACE NAME WITH NAMEN
   REPLACE OFFN WITH ""
   REPLACE NAMEN WITH ""
   skip
   if eof()
   eofcashiers = .t.
   endif
Procedure end_rtn1
   local l1,l2,l3
    l1 = st15f->shift_date
    l2 = st15f->shift_no
    l3 = st15f->shift_id
   pcashier = st15f->cashier_no
   pcen = cen
   psto = sto
   ptyp = typ
   pcla = cla
   pcod = cod
   select scashrec
   seek dtos(l1)+l2+l3+pcashier+pcen+psto+ptyp+pcla+pcod
   if .not. found()
   append blank
   replace cashr_no with pcashier
   replace shift_date with l1
   replace shift_no with l2
   replace shift_id with l3
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
   
   select st15f
   skip
   if eof()
   eofst15f = .t.
   endif
   
  
Procedure fgjcadp_rtn
 PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Next Shift Job Cards in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
*progreps.close()   

set view to "fgjcadp.QBE"

   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfgnjcads,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            local lld1,lld2
            set reprocess to -1
*            select fgclas
 *           set order to mkey
            SELECT DAYFGMAS
            SET ORDER TO MKEY
                   SELECT FgTRnref
    SET ORDER TO MKEY

select fgnjcads
set order to order_no
select fgmast
set order to mkey
select shstmast
set order to mkey
select cashiers
set order to cashier
select shcatsum
set order to mkey
select st15f
set order to mkey
select scashrec
set order to mkey
SELECT FGCOD
SET ORDER TO MKEY

      eoffgnjclin = .f.
      pposted = .t.
      select fgcoy
      go top
      ppfc = .t.
   
       select fgnjclin
    *  set filter to empty(Post_date)
           go top
                if .not. eof()
  
                do
                do line_rtn_fgjcad
                until eoffgnjclin
                endif
                set safety off
                select fgnjclin
                set filter to
                go top
                 zap
                select fgnjcads
                set filter to
                go top
                zap
            *    endif
                set safety on
                select fgcoy
                *FLUSH
                close databases
 progreps.close()   
procedure line_rtn_fgjcad
            local l1,l2,l11,l22,l3,l4,l5
            l4 = fgnjclin->order_no
            l5 = st15f->shift_date
            select fgnjcads
            seek l4
            if found()
            if ppfc
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "JC"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    else
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
   pdoc = "JC"
    pshno = "0"
    pshdate = st15f->shift_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
             
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   
       PSHDATE2 = fgnjclin->SHIFT_DATE
       if .not. empty(PSHDATE2)
       PSHDATE2 =  st15f->shift_date
       endif
      PSHNO2 = fgnjclin->SHIFT_NO
      if .not. empty(PSHNO2)
      PSHNO2 = st15f->shift_no
      endif
      PCOY = fgnjclin->ST_COY
      PDIV = fgnjclin->ST_DIV
      PCEN = fgnjclin->ST_CEN
      PSTO = fgnjclin->ST_STO
      PTYP = fgnjclin->TYP
      PCLA = fgnjclin->CLA
      PCOD = fgnjclin->COD
      PCOY2 = fgnjclin->COY
      PDIV2 = fgnjclin->DIV
      PCEN2 = fgnjclin->CEN
      PSTO2 = fgnjclin->STO
      PSHID2 = fgnjclin->shift_id
      if .not. empty(PSHID2)
      PSHID2 = st15f->shift_id
      endif
   *   select fgclas
    *  seek ptyp+pcla
      select fgcod
      seek ptyp+pcla+pcod
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if found()
      pstmast = .t.
      else
      pstmast = .f.
      ? "bad stock master"
      endif
      
     if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecourt
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      ENDIF
      
      select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      
      replace cs_sales_a with 0
      replace cs_purch_a with 0
      replace cr_sales_a with 0
      replace cr_purch_a with 0
      
      
      replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
    ENDIF
    
    ENDIF
 
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
          replace tax_amt with 0
         replace gross_amt  with 0
         replace nonvat_amt  with 0
         replace nonvat with fgnjclin->nonvat
         replace cost_price with   fgnjclin->cost_price
         replace list_price with fgnjclin->sell_price
         replace tax_rate with   fgnjclin->vat    
      endif
      
                        replace cs_sal_qty with cs_sal_qty + fgnjclin->qty
                        replace cs_sal_shs with cs_sal_shs + fgnjclin->total
                    replace tax_amt with tax_amt + fgnjclin->vat_out
                      replace gross_amt with gross_amt + fgnjclin->gross_amt
       
   
                pfrighter = fgnjcads->frighter_N
               porder = fgnjcads->order_no
                        pftyp = fgnjcads->ftyp
                          pcashrno = fgnjclin->cashier_no
                          psource = fgnjcads->source
                          ppmod = fgnjcads->pmod
                          IF EMPTY(pcashrno)
                           pcashrno = "1"
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
  replace off with fgnjclin->off
   endif
   
   IF  EMPTY(OFF)
     replace off with fgnjclin->off
     ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
            PCUS = .T.
        
        if pdiv2 = "1" .and. ppfc
         pstf = .t.
         PST15F = .T.
         else
         pstf = .f.
         PST15F = .f.
         endif
         
         if pst15f .and. ppfc
         
        SELECT ST15F
         
        SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
          IF FOUND()
                PST15F = .t.
                pstf = .t.
                
                ELSE
                pstf = .f.
                SELECT ST15F
                GO TOP
          ENDIF
          endif
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcard = .f.
      pcash = .t.
      pcheque = .f.
      pother = .f.
               pfdate = .T.
          
       PCASHR = .T.
     IF EMPTY(fgnjclin->POST_DATE) .and. pcus .and. pstmast
    DO FGJCAD_NON_RTN1
    ? "done"
    
    do FGJCAD_NON_RTN6
    
    SELECT fgnjclin
    replace post_date with date()
    select fgnjcads
    replace post_date with date()
    endif
    endif
 
   select fgnjclin 
   if .not. eof()
       SKIP
       endif
    IF EOF()
     eoffgnjclin = .T.
    ENDIF
      
  PROCEDURE FGJCAD_NON_RTN1
  
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
      psys   = "CS"  && point of sale
      pdoc   = "JC"  && job card
      pstockno = fgnjclin->stock_no
      IF fgnjclin->TYP = "00"   .and. pst15f  .and. ppfc && fuel forecourt
           DO st15f_non_rtn3
           
     ELSE
     DO st15f_non_rtn2
           
     ENDIF
     
  PROCEDURE st15f_non_rtn3
        SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + ;
        fgnjclin->QTY
          REPLACE NON_CASH WITH fgnjclin->TOTAL + ST15F->NON_CASH + fgnjclin->discount
          REPLACE SHIFT_POST WITH DATE()
      do  FGJCAD_NON_RTN2
  Procedure FGJCAD_NON_RTN8
        select fgjobcad
          append blank
         replace system with psys
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fgnjclin->st_coy
            replace div with fgnjclin->st_div
            replace cen with fgnjclin->st_cen
              replace sto with fgnjclin->st_sto
              replace st_coy with fgnjclin->coy
            replace CASHIER_NO with fgnjclin->cashier_no
            replace st_div with fgnjclin->div
            replace st_cen with fgnjclin->cen
              replace st_sto with fgnjclin->sto
              replace shift_no with st15f->shift_no
               replace shift_id with st15f->shift_id
               REPLACE SERIALNO WITH fgnjcads->SERIALNO
                 replace dde_date with fgnjcads->dde_date
                replace dde_time with fgnjcads->dde_time
                replace dde_user with fgnjcads->dde_user
            replace typ with fgnjclin->typ
            replace cla with fgnjclin->cla
            replace cod with fgnjclin->cod
            replace qty with fgnjclin->qty * -1
            replace unit_cost with fgnjclin->cost_price
            replace new_bal with fgnjclin->discount
            replace total with fgnjclin->total
            replace list_price with fgnjclin->sell_price
            replace tax_rate with fgnjclin->vat
            replace tax_amt with fgnjclin->vat_out
            replace off with fgnjclin->off
              replace srep with fgnjclin->srep
            replace reg  with fgnjcads->reg
            replace gross_amt with fgnjclin->gross_amt 
            replace pay_method  with fgnjcads->pay_method
           REPLACE source WITH fgnjcads->source
          REPLACE ftyp WITH fgnjcads->ftyp
           REPLACE PMOD WITH fgnjcads->PMOD
           REPLACE FRIGHTER_N WITH fgnjcads->FRIGHTER_N
             replace total_amt with fgnjclin->total_amt
             replace driver with fgnjclin->driver
             REPLACE SPRICE WITH fgnjclin->nonvat
                    local l1,l2,l3,l4
             l1 = fgjobcad->order_no
              l2 = dtos(fgjobcad->order_date)
              l3 = fgjobcad->doctype
              l4 = fgjobcad->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fgjobcad->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + fgnjclin->total
              replace qty with qty + fgnjclin->qty
    IF LEFT(fgnjclin->TYP,1) = '7' && SERVICES
        SELECT FGOFFCAS
        APPEND BLANK
        REPLACE COY WITH fgjobcad->COY
        REPLACE TYP WITH fgjobcad->TYP
        REPLACE CLA WITH fgjobcad->CLA
        REPLACE COD WITH fgjobcad->COD
        REPLACE SYSTEM WITH fgjobcad->SYSTEM
        REPLACE DOCTYPE WITH fgjobcad->DOCTYPE
        REPLACE ORDER_NO WITH fgjobcad->ORDER_NO
        REPLACE ORDER_DATE WITH fgjobcad->ORDER_DATE
        REPLACE REG WITH fgjobcad->REG
        REPLACE DRIVER WITH fgjobcad->DRIVER
        REPLACE QTY WITH fgnjclin->QTY
        REPLACE TOTAL WITH fgjobcad->TOTAL
        REPLACE ADV_AMT WITH 0
        REPLACE STOCK_NO WITH fgjobcad->STOCK_NO
        replace caw_rate with fgnjclin->bal_alloc
        replace pit_rate with fgnjclin->scr_qty
        replace tba_rate with fgnjclin->scr_amt
        ENDIF
      **
      pmain_key = psys+pdoc+dtos(pshdate)+st15f->shift_no+st15f->shift_id+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
      replace main_key with pmain_key
         replace system with psys
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with fgnjclin->st_coy
            replace div with fgnjclin->st_div
            replace cen with fgnjclin->st_cen
              replace sto with fgnjclin->st_sto
              replace st_coy with fgnjclin->coy
            replace CASHIER_NO with fgnjclin->cashier_no
            replace scashier with cashier_no
            replace st_div with fgnjclin->div
            replace st_cen with fgnjclin->cen
              replace st_sto with fgnjclin->sto
              replace shift_no with st15f->shift_no
               replace shift_id with st15f->shift_id
               REPLACE SERIALNO WITH fgnjcads->SERIALNO
                 replace dde_date with fgnjcads->dde_date
                replace dde_time with fgnjcads->dde_time
                replace dde_user with fgnjcads->dde_user
            replace typ with fgnjclin->typ
            replace cla with fgnjclin->cla
            replace cod with fgnjclin->cod
            replace qty with fgnjclin->qty * -1
            replace unit_cost with fgnjclin->cost_price
            replace new_bal with fgnjclin->discount
            replace total with fgnjclin->total
            replace list_price with fgnjclin->sell_price
            replace tax_rate with fgnjclin->vat
            replace tax_amt with fgnjclin->vat_out
            replace off with fgnjclin->off
              replace srep with fgnjclin->srep
              replace mileage with fgnjcads->mileage
            replace reg  with fgnjcads->reg
            replace gross_amt with fgnjclin->gross_amt
            replace pay_method  with fgnjcads->pay_method
           REPLACE source WITH fgnjcads->source
          REPLACE ftyp WITH fgnjcads->ftyp
           REPLACE PMOD WITH fgnjcads->PMOD
           REPLACE FRIGHTER_N WITH fgnjcads->FRIGHTER_N
             replace total_amt with fgnjclin->total_amt
             replace driver with fgnjclin->driver
             REPLACE SPRICE WITH fgnjclin->nonvat
               replace soff with off
             replace unl with 0
             replace dis with 0
             replace lub with 0
             replace svc with 0
             if typ='10'
                replace lub with 1
                else
                replace svc with 1
                endif
    replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with '1110001'
 PROCEDURE FGJCAD_NON_RTN2
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = st15f->shift_date
        psys = "CS"
        pdoc = "JC"
        l4 = fgnjcads->order_no
        l5 = fgnjclin->stock_no
        l6 = st15f->shift_no
        l7 = fgnjclin->st_COY
        l8 = fgnjclin->st_div
        l9 = fgnjclin->st_cen
        l10 = fgnjclin->st_sto
        l11 = fgnjclin->typ
        l12 = fgnjclin->cla
        l13 = fgnjclin->cod
        l14 = fgnjclin->shift_id
         
          ppay = fgnjcads->PAY_METHOD
         pcustno  =  fgnjcads->frighter_N
         pftyp = fgnjcads->ftyp
         psource = fgnjcads->source
         ppmod = fgnjcads->pmod
                LOCAL D1,D2
                
              D1 = DTOS(st15f->shift_date)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = fgnjclin->QTY * -1
               PTTOTAL = fgnjclin->TOTAL
               PTVAT = fgnjclin->vat_out  && get vat amount
              PCOY = fgnjclin->COY
              PDIV = fgnjclin->DIV
              PCEN = fgnjclin->CEN
              PTYP = fgnjclin->TYP
              PSTO = fgnjclin->STO
              PCLA = fgnjclin->CLA
              PCOD = fgnjclin->COD
                ptcost = fgnjclin->qty * fgnjclin->cost_price
                         pother = .F.
        pcash = .T.
        pcredit = .F.
        Pcheque = .F.
        Pcard = .F.
     ptdate = st15f->shift_date
              do FGJCAD_NON_RTN8
        
             if pshm
               
                  select shstmast
                  seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
                  replace on_hand with on_hand - fgnjclin->qty
                  if pcash .or. pcheque
                       replace cs_sales with cs_sales + fgnjclin->qty
                       replace cs_sales_a with cs_sales_a + fgnjclin->total
                        else
                     replace cr_sales with cr_sales + fgnjclin->qty
                     replace cr_sales_a with cr_sales_a + fgnjclin->total
                  endif
              if .not. pdiv = '1' .and. .not. ptyp = '00'
           select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand -  fgnjclin->qty
       replace sales with sales +  fgnjclin->qty
       endif
              SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - fgnjclin->QTY
               if pcash .or. pcheque
                       replace cs_sales with cs_sales + fgnjclin->qty
                        else
                     replace cr_sales with cr_sales + fgnjclin->qty
                  endif
              
                  endif
      
 PROCEDURE st15f_non_rtn2
    IF .NOT. EMPTY(fgnjclin->SHIFT_DATE) .AND. .NOT. EMPTY(fgnjclin->SHIFT_NO);
       .AND. PST15F .AND. .NOT. EMPTY(fgnjclin->SHIFT_id) .and. ppfc
    DO st15f_non_rtn1
    ENDIF
     DO FGJCAD_NON_RTN2
    
PROCEDURE   st15f_non_rtn1
    SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + ;
        fgnjclin->QTY
           REPLACE ST15F->NON_CASH WITH fgnjclin->TOTAL + ST15F->NON_CASH  + fgnjclin->discount
          REPLACE SHIFT_POST WITH DATE()
   
   
   
Procedure FGJCAD_NON_RTN6
      if pdiv2 = "1" .and. pst15f .and. ppfc  && cash collected at service
            do FGJCAD_NON_RTN9  && done
       else
          do FGJCAD_NON_RTN5 && cash sales in service area
      endif
      
procedure FGJCAD_NON_RTN3
            select scashrec
            replace exp_sales with exp_sales  + fgnjclin->total
  
       replace non_cash with non_cash + fgnjclin->total + fgnjclin->discount  && normal credit
   
            
procedure FGJCAD_NON_RTN4
         select scashrec
         replace fc_sales with fc_sales + fgnjclin->total
       replace non_cash with non_cash + fgnjclin->total + fgnjclin->discount  && normal credit
            

procedure FGJCAD_NON_RTN9
         select scashrec
         replace fc_sales with fc_sales + fgnjclin->total
          replace non_cash with non_cash + fgnjclin->discount
         select st15f
         replace fc_c_sales with fc_c_sales + fgnjclin->total  && cash summary
         if typ="10" && fc lubes
          replace reserved5 with reserved5 + fgnjclin->total
          endif
       
          REPLACE SHIFT_POST WITH DATE()
          
Procedure FGJCAD_NON_RTN5
           select scashrec
         replace exp_sales with exp_sales + fgnjclin->total
          select st15f
         go top
         IF FGCOD->COST_MODE < "1" .OR. FGCOD->COST_MODE > "6" .or. empty(FGCOD->COST_MODE)
         DO service_cash_rtn_OLD
          ELSE
                   if FGCOD->COST_MODE  = "6"   && shop         
            replace cash_cant with cash_cant + fgnjclin->total
         else

          if FGCOD->COST_MODE  = "2"    && car wash     
         replace chqs_sale with chqs_sale + fgnjclin->total
           else
          if FGCOD->COST_MODE  = "3"   && tyre centre
         replace vs_others with vs_others + fgnjclin->total
          else
         if FGCOD->COST_MODE  = "5"    &&  cafe
         replace cash_soda with cash_soda + fgnjclin->total
         else
          if FGCOD->COST_MODE  = "4"  && other services 
         replace cash_shop with cash_shop + fgnjclin->total
           else
             replace cash_work with cash_work + fgnjclin->total
         endif
         endif
         endif
         endif
         endif
        
         select fgcoy
         flush

PROCEDURE service_cash_rtn_OLD
         select st15f
         if pdiv = "4"   && shop         
         replace cash_cant with cash_cant + fgnjclin->total
         else
         if (pdiv = "3" .and. pcen = "1") .or. pdiv = "6"   && car wash     
         replace chqs_sale with chqs_sale + fgnjclin->total
         else
         if (pdiv = "3" .and. pcen = "2")  .or.  pdiv = "7"  && tyre centre
         replace vs_others with vs_others + fgnjclin->total
         else
           if  pdiv = "8"   &&  cafe
         replace cash_soda with cash_soda + fgnjclin->total
         else
          if pdiv = "3"  .and. pcen = "3" && other services 
         replace cash_shop with cash_shop + fgnjclin->total
         else  && service
         replace cash_work with cash_work + fgnjclin->total
         endif
         endif
         endif
         endif
         endif
         endif
         select fgcoy
         flush
        * 
   

Procedure fgclpgp_rtn
 PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Next LPG & Lubes Cash Sales in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
*progreps.close()   

set view to "fgclpgp.QBE"

   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Pfgnclpgs,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            local lld1,lld2
            set reprocess to -1
          *  select fgclas
           * set order to mkey
            SELECT DAYFGMAS
            SET ORDER TO MKEY
                   SELECT FgTRnref
    SET ORDER TO MKEY

select fgnclpgs
set order to order_no
select fgmast
set order to mkey
select shstmast
set order to mkey
select cashiers
set order to cashier
select shcatsum
set order to mkey
select st15f
set order to mkey
go top
select scashrec
set order to mkey
select fgcod
set order to  mkey

      eofFGNLPLIN = .f.
      pposted = .t.
      select fgcoy
      go top
      ppfc = .t.
  
       select FGNLPLIN
 *      set filter to empty(Post_date)
           go top
                if .not. eof()
  
                do
                do line_rtn_FGLCAD
                until eofFGNLPLIN
                endif
                set safety off
                select FGNLPLIN
                set filter to
                go top
                 zap
                select fgnclpgs
                set filter to
                go top
                zap
            *    endif
                set safety on
                select fgcoy
                *FLUSH
                close databases
                set safety off
                use  \kenserve\idssys\fgnclpgs.dbf
                copy stru to \kenservice\data\fgnclpgs dbase prod
                close databases
                set safety on
 progreps.close()   
procedure line_rtn_FGLCAD
            local l1,l2,l11,l22,l3,l4,l5
            l4 = FGNLPLIN->order_no
            if fgnlplin->typ = "10"
            pjcad = "LUBES"
            ELSE
            PJCAD = "LPGS"
            ENDIF
            l5 = st15f->shift_date
            select fgnclpgs
            GO TOP
            LOCATE FOR ORDER_NO = l4 .AND. (EMPTY(JOB_CARD) .OR. JOB_CARD = PJCAD)
            if found()
            if ppfc
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
     if FGNLPLIN->typ = "20"
   pdoc = "LP"
   else
   pdoc = "LB"
   endif
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    else
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
   if val(pmonth) < 10
   pmonth = "0"+str(val(pmonth),1)
     endif
    pshno = "0"
    pshdate = st15f->shift_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
             
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   
      PSHDATE2 = FGNLPLIN->SHIFT_DATE
      if .not. empty(PSHDATE2)
      PSHDATE2 = st15f->shift_date
      endif
      PSHNO2 = FGNLPLIN->SHIFT_NO
      if .not. empty(PSHNO2)
      PSHNO2 = st15f->shift_no
      endif
      
      PCOY = FGNLPLIN->ST_COY
      PDIV = FGNLPLIN->ST_DIV
      PCEN = FGNLPLIN->ST_CEN
      PSTO = FGNLPLIN->ST_STO
      PTYP = FGNLPLIN->TYP
      PCLA = FGNLPLIN->CLA
      PCOD = FGNLPLIN->COD
      PCOY2 = FGNLPLIN->COY
      PDIV2 = FGNLPLIN->DIV
      PCEN2 = FGNLPLIN->CEN
      PSTO2 = FGNLPLIN->STO
      PSHID2 = FGNLPLIN->shift_id
      if .not. empty(PSHID2)
      PSHID2 = st15f->shift_id
      endif
      
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if found()
      pstmast = .t.
      else
      pstmast = .f.
      ? "bad stock master"
      endif
   
     if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecourt
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      
      endif           
      select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      
      replace cs_sales_a with 0
      replace cs_purch_a with 0
      replace cr_sales_a with 0
      replace cr_purch_a with 0
      
      
      replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
    ENDIF
    
    ENDIF
  * select fgclas
   *   seek PTYP+PCLA
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
          replace  tax_amt with 0
         replace nonvat with FGNLPLIN->nonvat
         replace nonvat_amt with 0
         replace gross_amt with 0
         replace tax_rate with FGNLPLIN->vat
         replace list_price with FGNLPLIN->sell_price
         replace cost_price with FGNLPLIN->cost_price
      endif
        select fgcod
    seek PTYP+PCLA+PCOD
    
                pfrighter = fgnclpgs->frighter_N
               porder = fgnclpgs->order_no
                        pftyp = fgnclpgs->ftyp
                          pcashrno = FGNLPLIN->cashier_no
                          psource = fgnclpgs->source
                          ppmod = fgnclpgs->pmod
                          IF EMPTY(pcashrno)
                          if FGNLPLIN->typ = "20"
                           pcashrno = "6"
                           else
                           pcashrno = "7"
                           ENDIF
                           endif
                    
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
 replace off with FGNLPLIN->off
   endif
   
   IF  EMPTY(OFF)
    replace off with FGNLPLIN->off
    ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
  endif
            PCUS = .T.
        
        if pdiv2 = "1" .and. ppfc
         pstf = .t.
         PST15F = .T.
         else
         pstf = .f.
         PST15F = .f.
         endif
         
         if pst15f .and. ppfc
         
        SELECT ST15F
         
        SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
          IF FOUND()
                PST15F = .t.
                pstf = .t.
                ELSE
                pstf = .f.
                SELECT ST15F
                GO TOP
          ENDIF
          
          endif
      local wk1,wk2
      wk1 = 0
      pcredit = .f.
      pcard = .f.
      pcash = .T.
      pcheque = .f.
      pother = .f.
          
               pfdate = .T.
          
       PCASHR = .T.
       ? pcus
       ? pstmast
    IF EMPTY(FGNLPLIN->POST_DATE) .and. pcus .and. pstmast
    DO FGLCAD_NON_RTN1
     do FGLCAD_NON_RTN6
      
       
    SELECT FGNLPLIN
    replace post_date with date()
    select fgnclpgs
    replace post_date with date()
    endif
    endif
    *FLUSH
   select FGNLPLIN 
   if .not. eof()
       SKIP
       endif
    IF EOF()
     eofFGNLPLIN = .T.
    ENDIF
  PROCEDURE FGLCAD_NON_RTN1
  
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
      psys   = "PS"  && point of sale
    if FGNLPLIN->TYP = "20"
      pdoc   = "LP"  && job card
      ELSE
      PDOC = "LB"
      ENDIF
      pstockno = FGNLPLIN->stock_no
    
        DO st15f_non_rtn2_LPG
   Procedure FGLCAD_NON_RTN8
        select FGLPGCAD
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with FGNLPLIN->st_coy
            replace div with FGNLPLIN->st_div
            replace cen with FGNLPLIN->st_cen
              replace sto with FGNLPLIN->st_sto
              replace st_coy with FGNLPLIN->coy
            replace st_div with FGNLPLIN->div
            replace st_cen with FGNLPLIN->cen
              replace st_sto with FGNLPLIN->sto
              replace shift_no with st15f->shift_no
              replace shift_id with st15f->shift_id
               IF FGNLPLIN->typ="20"
               REPLACE SERIALNO WITH FGNLPLIN->reference
               ELSE
               REPLACE SERIALNO WITH fgnclpgs->lpo
               ENDIF
               replace cashier_no with pcashrno
                 replace dde_date with fgnclpgs->dde_date
                replace dde_time with fgnclpgs->dde_time
                replace dde_user with fgnclpgs->dde_user
              
            replace typ with FGNLPLIN->typ
            replace cla with FGNLPLIN->cla
            replace cod with FGNLPLIN->cod
            replace qty with FGNLPLIN->qty * -1
            replace unit_cost with FGNLPLIN->cost_price
            replace new_bal with  + FGNLPLIN->discount
            replace total with FGNLPLIN->total
            replace list_price with FGNLPLIN->sell_price
            replace tax_rate with FGNLPLIN->vat
            replace tax_amt with FGNLPLIN->vat_out
            replace off with FGNLPLIN->off
            replace driver with FGNLPLIN->driver
            replace gross_amt with FGNLPLIN->pr_qty
            replace pay_method  with fgnclpgs->pay_method
           REPLACE source WITH fgnclpgs->source
          REPLACE ftyp WITH fgnclpgs->ftyp
           REPLACE PMOD WITH fgnclpgs->PMOD
           REPLACE FRIGHTER_N WITH fgnclpgs->FRIGHTER_N
             replace total_amt with FGNLPLIN->nonvat
                   local l1,l2,l3,l4
             l1 = FGLPGCAD->order_no
              l2 = dtos(st15f->shift_date)
              l3 = FGLPGCAD->doctype
              l4 = FGLPGCAD->system
               IF FGNLPLIN->typ="20"
                 select FGLPGTRN
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with FGNLPLIN->st_coy
            replace div with FGNLPLIN->st_div
            replace cen with FGNLPLIN->st_cen
            replace sto with FGNLPLIN->st_sto
               replace shift_no with st15f->shift_no
              replace shift_id with st15f->shift_id
               REPLACE SERIALNO WITH FGNLPLIN->reference
                 replace dde_date with fgnclpgs->dde_date
                replace dde_time with fgnclpgs->dde_time
                replace dde_user with fgnclpgs->dde_user
             replace typ with FGNLPLIN->typ
            replace cla with FGNLPLIN->cla
            replace cod with FGNLPLIN->cod
            replace qty with FGNLPLIN->qty
              replace total with FGNLPLIN->total
            replace list_price with FGNLPLIN->sell_price
            REPLACE PHONE WITH Fgnclpgs->lpo
            REPLACE IDNO WITH fgnclpgs->reg
            REPLACE CUSTNAME WITH fgnclpgs->custname
            ENDIF
              
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH st15f->shift_date
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGNLPLIN->total
              replace qty with qty + FGNLPLIN->qty
    **
     pmain_key = psys+pdoc+dtos(pshdate)+st15f->shift_no+st15f->shift_id+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
      replace main_key with pmain_key
   replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with FGNLPLIN->st_coy
            replace div with FGNLPLIN->st_div
            replace cen with FGNLPLIN->st_cen
              replace sto with FGNLPLIN->st_sto
              replace st_coy with FGNLPLIN->coy
            replace st_div with FGNLPLIN->div
            replace st_cen with FGNLPLIN->cen
              replace st_sto with FGNLPLIN->sto
              replace shift_no with st15f->shift_no
              replace shift_id with st15f->shift_id
               IF FGNLPLIN->typ="20"
               REPLACE SERIALNO WITH FGNLPLIN->reference
               ELSE
               REPLACE SERIALNO WITH fgnclpgs->lpo
               ENDIF
               replace cashier_no with pcashrno
                 replace dde_date with fgnclpgs->dde_date
                replace dde_time with fgnclpgs->dde_time
                replace dde_user with fgnclpgs->dde_user
              
            replace typ with FGNLPLIN->typ
            replace cla with FGNLPLIN->cla
            replace cod with FGNLPLIN->cod
            replace qty with FGNLPLIN->qty * -1
            replace unit_cost with FGNLPLIN->cost_price
            replace new_bal with  + FGNLPLIN->discount
            replace total with FGNLPLIN->total
            replace list_price with FGNLPLIN->sell_price
            replace tax_rate with FGNLPLIN->vat
            replace tax_amt with FGNLPLIN->vat_out
            replace off with FGNLPLIN->off
            replace gross_amt with FGNLPLIN->pr_qty 
            replace pay_method  with fgnclpgs->pay_method
           REPLACE source WITH fgnclpgs->source
          REPLACE ftyp WITH fgnclpgs->ftyp
           REPLACE PMOD WITH fgnclpgs->PMOD
           REPLACE FRIGHTER_N WITH fgnclpgs->FRIGHTER_N
             replace total_amt with FGNLPLIN->nonvat
             replace scashier with cashier_no     
             replace mileage with 0
             replace unl with 0
             replace dis with 0
             replace lub with 0
             replace soff with off
             replace svc with 1
             replace sprice with total_amt
             replace driver with FGNLPLIN->driver
             replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
                replace customerid with '1110001'
 PROCEDURE FGLCAD_NON_RTN2
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = st15f->shift_date
        psys = "PS"
        if FGNLPLIN->TYP = "20"
      pdoc   = "LP"  && job card
      ELSE
      PDOC = "LB"
     ENDIF
 
        l4 = fgnclpgs->order_no
        l5 = FGNLPLIN->stock_no
        l6 = fgnclpgs->shiftno
        l7 = FGNLPLIN->st_COY
        l8 = FGNLPLIN->st_div
        l9 = FGNLPLIN->st_cen
        l10 = FGNLPLIN->st_sto
        l11 = FGNLPLIN->typ
        l12 = FGNLPLIN->cla
        l13 = FGNLPLIN->cod
        l14 = FGNLPLIN->shift_id
         
          ppay = fgnclpgs->PAY_METHOD
         pcustno  =  fgnclpgs->frighter_N
         pftyp = fgnclpgs->ftyp
         psource = fgnclpgs->source
         ppmod = fgnclpgs->pmod
                LOCAL D1,D2
                
              D1 = DTOS(st15f->shift_date)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = FGNLPLIN->QTY * -1
               PTTOTAL = FGNLPLIN->TOTAL
               PTVAT = FGNLPLIN->vat_out  && get vat amount
              PCOY = FGNLPLIN->ST_COY
              PDIV = FGNLPLIN->ST_DIV
              PCEN = FGNLPLIN->ST_CEN
              PTYP = FGNLPLIN->TYP
              PSTO = FGNLPLIN->ST_STO
              PCLA = FGNLPLIN->CLA
              PCOD = FGNLPLIN->COD
                ptcost = FGNLPLIN->qty * FGNLPLIN->cost_price
                         pother = .F.
         pcash = .T.
            pcredit = .F.
            Pcheque = .F.
          Pcard = .F.
         ptdate = st15f->shift_date
              do FGLCAD_NON_RTN8
        
                 select shcatsum
                 seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                      replace cs_sal_qty with cs_sal_qty + FGNLPLIN->qty
                      replace cs_sal_shs with cs_sal_shs + FGNLPLIN->total
                      replace tax_amt with tax_amt + FGNLPLIN->vat_out
                      replace gross_amt with gross_amt + FGNLPLIN->pr_qty 
                    *  replace nonvat_amt with nonvat_amt  + FGNLPLIN->nonvat_amt
                 
                if pshm
               
                  select shstmast
                   seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid
                  replace on_hand with on_hand - FGNLPLIN->qty
                       replace cs_sales with cs_sales + FGNLPLIN->qty
                       replace cs_sales_a with cs_sales_a + FGNLPLIN->total
                       if .not. pdiv = '1' .and. .not. ptyp = '00'
           select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - FGNLPLIN->qty
       replace sales with sales + FGNLPLIN->qty
       endif
              SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - FGNLPLIN->QTY
                       replace cs_sales with cs_sales + FGNLPLIN->qty
                    endif
  PROCEDURE st15f_non_rtn2_LPG
    IF .NOT. EMPTY(FGNLPLIN->SHIFT_DATE) .AND. .NOT. EMPTY(FGNLPLIN->SHIFT_NO);
       .AND. PST15F .AND. .NOT. EMPTY(FGNLPLIN->SHIFT_id) .and. ppfc
    DO st15f_non_rtn1_LPG
    ENDIF
     DO FGLCAD_NON_RTN2
    
PROCEDURE   st15f_non_rtn1_LPG
    SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + ;
        FGNLPLIN->QTY
           REPLACE NON_CASH WITH FGNLPLIN->TOTAL + ST15F->NON_CASH + FGNLPLIN->discount
          REPLACE SHIFT_POST WITH DATE()
   
Procedure FGLCAD_NON_RTN6
      if pdiv2 = "1" .and. pst15f .and. (pcash .or. pcheque) .and. ppfc  && cash collected at service
            do FGLCAD_NON_RTN9  && done
       else
       if pcash .or. pcheque
          do FGLCAD_NON_RTN5 && cash sales in service area
        else
        if pdiv2 = "1" .and. pst15f .and. ppfc
              do FGLCAD_NON_RTN4  && credit sales of forecourt items at service bay
          else
          do FGLCAD_NON_RTN3  && service items credit sales
      endif
      endif
      endif     
procedure FGLCAD_NON_RTN3
            select scashrec
            replace exp_sales with exp_sales  + FGNLPLIN->total
       replace non_cash with non_cash + FGNLPLIN->total  && normal credit            
procedure FGLCAD_NON_RTN4
         select scashrec
         replace fc_sales with fc_sales + FGNLPLIN->total
       replace non_cash with non_cash + FGNLPLIN->total+ FGNLPLIN->discount  && normal credit
            

procedure FGLCAD_NON_RTN9
         select scashrec
         replace fc_sales with fc_sales + FGNLPLIN->total
               replace non_cash with non_cash +  FGNLPLIN->discount  && normal credit
         if pcheque
         replace chqs with chqs + FGNLPLIN->total
         endif
         select st15f
         replace fc_c_sales with fc_c_sales + FGNLPLIN->total  && cash summary
        if  pdoc="LP"
         replace reserved4 with reserved4 + FGNLPLIN->total
         else
          replace reserved5 with reserved5 + FGNLPLIN->total
          endif
          REPLACE SHIFT_POST WITH DATE()
          
Procedure FGLCAD_NON_RTN5
         select scashrec
         replace exp_sales with exp_sales + FGNLPLIN->total
         select st15f
         go top
         IF FGCOD->COST_MODE < "1" .OR. FGCOD->COST_MODE > "6" 
         DO service_cash_rtn_OLDlpg
          ELSE
                   if FGCOD->COST_MODE  = "6"   && shop         
            replace cash_cant with cash_cant + FGNLPLIN->total
         else

          if FGCOD->COST_MODE  = "2"    && car wash     
         replace chqs_sale with chqs_sale + FGNLPLIN->total
           else
          if FGCOD->COST_MODE  = "3"   && tyre centre
         replace vs_others with vs_others + FGNLPLIN->total
          else
         if FGCOD->COST_MODE  = "5"    &&  cafe
         replace cash_soda with cash_soda + FGNLPLIN->total
         else
          if FGCOD->COST_MODE  = "4"  && other services 
         replace cash_shop with cash_shop + FGNLPLIN->total
           else
             replace cash_work with cash_work + FGNLPLIN->total
         endif
         endif
         endif
         endif
         endif
        
         select fgcoy
         flush

PROCEDURE service_cash_rtn_OLDlpg
         select st15f
         if pdiv = "4"   && shop         
         replace cash_cant with cash_cant + FGNLPLIN->total
         else
         if (pdiv = "3" .and. pcen = "1") .or. pdiv = "6"   && car wash     
         replace chqs_sale with chqs_sale + FGNLPLIN->total
         else
         if (pdiv = "3" .and. pcen = "2")  .or.  pdiv = "7"  && tyre centre
         replace vs_others with vs_others + FGNLPLIN->total
         else
           if  pdiv = "8"   &&  cafe
         replace cash_soda with cash_soda + FGNLPLIN->total
         else
          if pdiv = "3"  .and. pcen = "3" && other services 
         replace cash_shop with cash_shop + FGNLPLIN->total
         else  && service
         replace cash_work with cash_work + FGNLPLIN->total
         endif
         endif
         endif
         endif
         endif
         endif
         select fgcoy
         flush
   
Procedure arinvp_rtn
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Next Shift INVOICES in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
*progreps.close()
set view to "arinvp.QBE"

   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Parnivces,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,ppfc,pposted
       set reprocess to 10000
   select st15f
   go top
     select arinvflg
go top
if eof()
append blank
replace tran with 0
replace shift_date with st15f->shift_date
replace shift_no with st15f->shift_no
replace mast with 0
replace stat with 0
replace shift_id with st15f->shift_id
endif
     select frcustbl
  
            SELECT DAYFGMAS
            SET ORDER TO MKEY
                     SELECT FgTRnref
    SET ORDER TO MKEY

 select fgmast
set order to mkey
select shstmast
set order to mkey
select cashiers
set order to cashier
select shcatsum
set order to mkey
select st15f
set order to mkey
select scashrec
set order to mkey
select frighter
set order to frighter
select frmodebt
set order to mkey

select frddebtp
set order to mkey
select frcount
set order to mkey
set safety off
select frdocref
zap
set order to docref
select vendor
set order to vendor
select vncount
set order to mkey
select vnstat
set order to mkey
SET SAFETY OFF
select vndocref
set order to docref
ZAP
select frshtrn
set order to mkey
set safety off
            pposted = .t.
   eofarniclin = .f.
      select fgcoy
      go top
      ppfc = .t.
      select arniclin
      dele all for year(order_date) < 1
           go top
                if .not. eof()
  
                do
                do line_rtn_arinv
                until eofarniclin
                endif
                set safety off
                select arniclin
                set filter to
                  zap
                select arnivces
                set filter to
                zap
                set safety on
                select fgcoy
                 close databases
  
                progreps.close()
procedure line_rtn_arinv
            local l1,l2,l11,l22,l3,lok,l4,l5,L6,L7,L8,L9,L10,LFD
            l4 = arniclin->order_no  && ordwer no
            l5 = arnivces->order_date
            L7 = arniclin->SOURCE
            L8 = arniclin->FTYP
            L9 = arniclin->PMOD
            L10 = arniclin->FRIGHTER_N
            LFD = .F.
            
            IF .NOT. EMPTY(arniclin->SOURCE) .AND. .NOT. EMPTY(arniclin->FTYP) ;
            .AND. .NOT. EMPTY(arniclin->PMOD) .AND. .NOT. EMPTY(arniclin->FRIGHTER_N)
            SELECT arnivces
            SET ORDER TO MKEY
            SEEK L4+dtos(l5)+L7+L8+L9+L10
            IF FOUND()
            LFD = .T.
            ENDIF
            ENDIF
            IF .NOT. LFD
            select arnivces
            SET ORDER TO ORDER_NO  && NOW IT HAS THE RIGHT CUSTOMER
            seek l4
            if found()
            LFD = .T.
            ENDIF
            ENDIF
            IF LFD
            
                if ppfc
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
            if val(pmonth) < 10
         pmonth = "0"+str(val(pmonth),1)
           endif
   pdoc = "19"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
   else
      pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
         if val(pmonth) < 10
         pmonth = "0"+str(val(pmonth),1)
           endif
   pdoc = "19"
    pshno = "0"
    pshdate = st15f->shift_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
    
             local lld1,lld2
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
      PSHDATE2 = arniclin->SHIFT_DATE
      if .not. empty(PSHDATE2)
      PSHDATE2 = st15f->shift_date
      endif
      PSHNO2 = arniclin->SHIFT_NO
      if .not.  empty(PSHNO2)
      PSHNO2 =  st15f->shift_no
      endif
      PCOY = arniclin->ST_COY
      PDIV = arniclin->ST_DIV
      PCEN = arniclin->ST_CEN
      PSTO = arniclin->ST_STO
      PTYP = arniclin->TYP
      PCLA = arniclin->CLA
      PCOD = arniclin->COD
      PCOY2 = arniclin->COY
      PDIV2 = arniclin->DIV
      PCEN2 = arniclin->CEN
      PSTO2 = arniclin->STO
      PSHID2 = arniclin->shift_id
      if .not. empty(PSHID2)
      PSHID2 =  st15f->shift_id
      endif
       pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      SELECT FGCOD
      SEEK PTYP+PCLA+PCOD
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if found()
      pstmast = .t.
      else
        Wait 'arniclin - Problem with stock masterfile - Try Again Later!'
           quit
                
      endif
      
    if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecourt
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
      
      ENDIF
      select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
      replace cr_purch with 0
      replace cs_sales with 0
        replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
      replace cr_sales_a with 0
      replace cs_sales_a with 0
      replace cr_purch_a with 0
      replace cs_purch_a with 0
    ENDIF
    
    ENDIF
    IF .NOT. PTYP = "C0"
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
          replace  tax_amt with 0
         replace nonvat with arniclin->nonvat
         replace nonvat_amt with 0
         replace gross_amt with 0
         replace tax_rate with arniclin->tax_rate
         replace list_price with arniclin->list_price
         replace cost_price with arniclin->cost_price
      endif
      
      endif
                 pfrighter = arnivces->frighter_N
               porder = arnivces->order_no
                        pftyp = arnivces->ftyp
                          pcashrno = arniclin->cashier_no
                          psource = arnivces->source
                          ppmod = arnivces->pmod
                          IF EMPTY(pcashrno)
                           pcashrno = "1"
                           ENDIF
           select scashrec
   seek dtos(pshdate)+pshno+pshid+pcashrno+pcen+psto+ptyp+pcla+pcod
   if .not. found()
   append blank
   replace cashr_no with  pcashrno
   replace off with arniclin->off
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
   
   IF  EMPTY(OFF)
     replace off with arniclin->off
     ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
   replace coy with pcoy
   replace cen with pcen
   replace div with pdiv
   endif
        SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
        IF FOUND()
           PCUS = .T.
         ELSE
           Wait 'arnivces+arniclin - Problem with customer masterfile - Try Again Later!'
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
        
        ? "new ppf= "
        ? ppfc
        if pdiv2 = "1" .and. .not. empty(arniclin->shift_date) ;
         .and. .not. empty(arniclin->shift_no) .and. .not. empty(arniclin->shift_id) ;
          .and. ppfc
         pstf = .t.
         PST15F = .T.
         ? "st15f ok"
         else
         pstf = .f.
         PST15F = .f.
         endif
         
         if pst15f .and. ppfc
         
        SELECT ST15F
         
        SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
          IF FOUND()
                PST15F = .t.
                pstf = .t.
                ELSE
                  Wait 'arniclin - Problem with shift masterfile - Try Again Later!'
           quit
                
          ENDIF
          endif
          
      local wk1,wk2
      wk1 = 0
      pcredit = .t.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
                pfdate = .T.
        PCASHR = .T.
    IF EMPTY(arniclin->POST_DATE) .and. pcus .and. pstmast
    DO arnin_non_rtn1
          
    do scashrec_rtn_arinv
    pmkey = right(arniclin->mkey,7)
    pmkey2 = (arnivces->source+arnivces->ftyp+ arnivces->pmod+arnivces->frighter_n)
    ? pmkey
    ? pmkey2
     
     SELECT arniclin
    replace post_date with date()
    select arnivces
    replace post_date with date()
    endif
    endif
   
    
   select arniclin  
   if .not. eof()
       SKIP
       endif
    IF EOF()
     eofarniclin = .T.
    ENDIF
 
         

      
  PROCEDURE arnin_non_rtn1
  
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
      psys   = "OP"  && point of sale
      pdoc   = "19"  && job card
      pstockno = arniclin->stock_no
    
     IF arniclin->TYP = "00" .and. pst15f  .and. ppfc && fuel forecourt
           DO fuel_non_rtn1
     ELSE
     DO service_non_rtn2
     ENDIF
     
  PROCEDURE fuel_non_rtn1
        SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + arniclin->QTY
        REPLACE NON_CASH WITH arniclin->TOTAL + ST15F->NON_CASH+arniclin->disc_amt
        REPLACE SHIFT_POST WITH DATE()
      do  stttran_non_rtn1
        
   Procedure fginvtrn_NON_RTN10      
        select fginvtrn
           append blank
         replace system with psys         
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with arniclin->st_coy
            replace div with arniclin->st_div
            replace cen with arniclin->st_cen
              replace sto with arniclin->st_sto
              replace st_coy with arniclin->coy
            replace st_div with arniclin->div
            replace st_cen with arniclin->cen
              replace st_sto with arniclin->sto
              replace shift_no with st15f->shift_no
               replace shift_id with st15f->shift_id
                replace serialno with arnivces->serialno
                replace dde_date with arnivces->dde_date
                replace dde_time with arnivces->dde_time
                replace dde_user with arnivces->dde_user
                replace driver with arniclin->driver
                replace scashier  with arnivces->cashier_no 
                replace soff with arnivces->off
               replace cashier_no  with arniclin->cashier_no 
            replace typ with arniclin->typ
            replace cla with arniclin->cla
            replace cod with arniclin->cod
            replace qty with arniclin->qty * -1
            replace unit_cost with arniclin->cost_price
            replace new_bal with arniclin->disc_amt
            replace total with arniclin->total
            replace list_price with arniclin->list_price
            replace tax_rate with arniclin->tax_rate
            replace tax_amt with arniclin->tax_amt
            replace off with arniclin->off
            replace reg  with arnivces->reg
            replace gross_amt with arniclin->gross_amt 
            replace pay_method  with arnivces->pay_method
            replace lpo with arnivces->lpo
                 replace vendor_n with arnivces->proforma 
             *    replace nonvat_amt with arniclin->nonvat_amt
             *   replace nonvat with arniclin->nonvat
           REPLACE source WITH arnivces->source
          REPLACE ftyp WITH arnivces->ftyp
           REPLACE PMOD WITH arnivces->PMOD
           REPLACE FRIGHTER_N WITH arnivces->FRIGHTER_N
            
             replace total_amt with arniclin->nonvat
               REPLACE UNL WITH 0
              REPLACE DIS WITH 0
              REPLACE LUB WITH 0
              REPLACE SVC WITH 0
              IF TYP < "10" .AND. (CLA < "30" .OR. CLA = "40")
              REPLACE UNL WITH 1
              ENDIF
              IF TYP < "10" .AND. (CLA = "30" .OR. CLA = "50")
              REPLACE DIS WITH 1
              ENDIF
              IF TYP = "10"
              REPLACE LUB WITH 1
              ENDIF
              IF TYP > "10"
              REPLACE SVC WITH 1
              ENDIF
              
        pmain_key = psys+pdoc+dtos(pshdate)+st15f->shift_no+st15f->shift_ID+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
      replace main_key with pmain_key
        replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with frighter->cus_acc
               replace system with psys         
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with arniclin->st_coy
            replace div with arniclin->st_div
            replace cen with arniclin->st_cen
              replace sto with arniclin->st_sto
              replace st_coy with arniclin->coy
            replace st_div with arniclin->div
            replace st_cen with arniclin->cen
              replace st_sto with arniclin->sto
              replace shift_no with st15f->shift_no
               replace shift_id with st15f->shift_id
                replace serialno with arnivces->serialno
                replace dde_date with arnivces->dde_date
                replace dde_time with arnivces->dde_time
                replace dde_user with arnivces->dde_user
                replace driver with arniclin->driver
                replace scashier  with arnivces->cashier_no 
                replace soff with arnivces->off
               replace cashier_no  with arniclin->cashier_no 
            replace typ with arniclin->typ
            replace cla with arniclin->cla
            replace cod with arniclin->cod
            replace qty with arniclin->qty * -1
            replace unit_cost with arniclin->cost_price
            replace new_bal with arniclin->disc_amt
            replace total with arniclin->total
            replace list_price with arniclin->list_price
            replace tax_rate with arniclin->tax_rate
            replace tax_amt with arniclin->tax_amt
            replace off with arniclin->off
            replace reg  with arnivces->reg
            replace gross_amt with arniclin->gross_amt 
            replace pay_method  with arnivces->pay_method
            replace lpo with arnivces->lpo
                 replace vendor_n with arnivces->proforma 
             *    replace nonvat_amt with arniclin->nonvat_amt
             *   replace nonvat with arniclin->nonvat
           REPLACE source WITH arnivces->source
          REPLACE ftyp WITH arnivces->ftyp
           REPLACE PMOD WITH arnivces->PMOD
           REPLACE FRIGHTER_N WITH arnivces->FRIGHTER_N
            
             replace total_amt with arniclin->nonvat
             replace sprice with total_amt
              REPLACE UNL WITH 0
              REPLACE DIS WITH 0
              REPLACE LUB WITH 0
              REPLACE SVC WITH 0
              IF TYP < "10" .AND. (CLA < "30" .OR. CLA = "40")
              REPLACE UNL WITH 1
              ENDIF
              IF TYP < "10" .AND. (CLA = "30" .OR. CLA = "50")
              REPLACE DIS WITH 1
              ENDIF
              IF TYP = "10"
              REPLACE LUB WITH 1
              ENDIF
              IF TYP > "10"
              REPLACE SVC WITH 1
              ENDIF
               select arinvflg
   replace tran with tran + fginvtrn->total  && transaction file updated
  
                            
LOCAL L1,L2,L3,L4,L5,l6,l7,l8,l9
   L1 = fginvtrn->SOURCE
   L2 = fginvtrn->FTYP
   L3 = fginvtrn->PMOD
   L4 = fginvtrn->FRIGHTER_N
   L5 = fginvtrn->SYSTEM
   L6 = fginvtrn->DOCTYPE
   L7 = fginvtrn->ORDER_DATE
   
         local l1,l2,l3,l4
             l1 = fginvtrn->order_no
              l2 = dtos(fginvtrn->order_date)
              l3 = fginvtrn->doctype
              l4 = fginvtrn->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fginvtrn->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + arniclin->total
              replace qty with qty + arniclin->qty
    
    
    IF LEFT(fginvtrn->TYP,1) = '7' && SERVICES
        SELECT FGOFFCAS
        APPEND BLANK
        REPLACE COY WITH fginvtrn->COY
        REPLACE TYP WITH fginvtrn->TYP
        REPLACE CLA WITH fginvtrn->CLA
        REPLACE COD WITH fginvtrn->COD
        REPLACE SYSTEM WITH fginvtrn->SYSTEM
        REPLACE DOCTYPE WITH fginvtrn->DOCTYPE
        REPLACE ORDER_NO WITH fginvtrn->ORDER_NO
        REPLACE ORDER_DATE WITH fginvtrn->ORDER_DATE
        REPLACE REG WITH fginvtrn->REG
        REPLACE DRIVER WITH fginvtrn->DRIVER
        REPLACE QTY WITH fginvtrn->QTY * -1
        REPLACE TOTAL WITH fginvtrn->TOTAL
        REPLACE ADV_AMT WITH 0
        REPLACE STOCK_NO WITH fginvtrn->STOCK_NO
        REPLACE CAW_RATE WITH arniclin->LEVY_AMT
        REPLACE PIT_RATE WITH arniclin->LEVY_RATE
        REPLACE TBA_RATE WITH arniclin->DSC
        
        ENDIF
 
 PROCEDURE stttran_non_rtn1
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = st15f->shift_date
        psys = "OP"
        pdoc = "19"
        l4 = arnivces->order_no
        l5 = arniclin->stock_no
        l6 = st15f->shift_no
        l7 = arniclin->st_COY
        l8 = arniclin->st_div
        l9 = arniclin->st_cen
        l10 = arniclin->st_sto
        l11 = arniclin->typ
        l12 = arniclin->cla
        l13 = arniclin->cod
        l14 = arniclin->shift_id
          ppay = arnivces->PAY_METHOD
         pcustno  =  arnivces->frighter_N
         pftyp = arnivces->ftyp
         psource = arnivces->source
         ppmod = arnivces->pmod
                LOCAL D1,D2
                
              D1 = DTOS(st15f->shift_date)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = arniclin->QTY * -1
               PTTOTAL = arniclin->TOTAL
               PTVAT = arniclin->tax_amt  && get vat amount
              PCOY = arniclin->st_COY
              PDIV = arniclin->st_DIV
              PCEN = arniclin->st_CEN
              PTYP = arniclin->TYP
              PSTO = arniclin->st_STO
              PCLA = arniclin->CLA
              PCOD = arniclin->COD
                ptcost = arniclin->qty * arniclin->cost_price
                        pother = .F.
                        pcash = .f.
                        pcredit = .t.
                        pcheque = .f.
                        pcard = .f.
        
     ptdate = st15f->shift_date
              do fginvtrn_NON_RTN10
             IF .NOT. PTYP = "C0"
       
                 select shcatsum
                 seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                         replace cr_sal_qty with cr_sal_qty + arniclin->qty
                        replace cr_sal_shs with cr_sal_shs + arniclin->total
                     replace tax_amt with tax_amt + arniclin->tax_amt
                      replace gross_amt with gross_amt + arniclin->gross_amt 
                    *  replace nonvat_amt with nonvat_amt  + arniclin->nonvat_amt
                 endif
               
            if pshm
               
                  select shstmast
                  seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
                  replace on_hand with on_hand - arniclin->qty
                  if pcash .or. pcheque
                       replace cs_sales with cs_sales + arniclin->qty
                       replace cs_sales_a with cs_sales_a + arniclin->total
                             if .not. pdiv = '1' .and. .not. ptyp = '00'
           select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - arniclin->qty
       replace sales with sales + arniclin->qty
       endif
              SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - arniclin->QTY
                       replace cs_sales with cs_sales + arniclin->qty
        
                        else
                     replace cr_sales with cr_sales + arniclin->qty
                    replace cr_sales_a with cr_sales_a + arniclin->total
            if .not. pdiv = '1' .and. .not. ptyp = '00'
           select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - arniclin->qty
       replace sales with sales + arniclin->qty
       endif
              SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - arniclin->QTY
                   replace cr_sales with cr_sales + arniclin->qty
          
                  endif
             
                  endif
               
                  do DRTRAN_3018RTN_arinv
                   if ptyp = "C0" .and. pcla = "00" .and. pcod = "11"  && payment from float
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
               
         if pven
               do new_vnstat_rtn
        endif
        endif
    PROCEDURE new_vnstat_rtn
  
       pdate = fginvtrn->order_date
       pventno = pvendor
          local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
  local ldate,ltime,tdate,lsys,ldoc,lvend,lref,lvtyp,lvsrce,lvpmod
  
      lref = fginvtrn->order_no
      ldate = fginvtrn->order_date
      tdate = fginvtrn->order_date
      lvsrce = pvsrce
      lvpmod = pvpmod
      lsys = fginvtrn->SYSTEM 
      ldoc = fginvtrn->DOCTYPE
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
             replace dis_qty with 0
             replace sup_qty with 0
             replace ker_qty with 0
             replace dis_price with 0
             replace sup_price with 0
             replace ker_price with 0
             replace svc_amt with 0
             
      REPLACE vnstat->SYSTEM     WITH lsys
      REPLACE vnstat->DOCTYPE    WITH ldoc
      REPLACE vnstat->DOCREF     WITH lref
      REPLACE vnstat->TRANS_DATE WITH tdate
      replace vnstat->serialno with fginvtrn->serialno
      REPLACE vnstat->REG        WITH fginvtrn->reg
       REPLACE vnstat->sTIME       WITH ltime
        REPLACE vnstat->LPO        WITH fginvtrn->LPO
         replace vnstat->pay_method with fginvtrn->pay_method
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
    replace inv_date with fginvtrn->order_date
    replace inv_no with fginvtrn->order_no
    replace inv_due with fginvtrn->order_date
    replace off with fginvtrn->off
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
          SELECT vendor
      REPLACE vendor->BAL_DUE with  fginvtrn->total   + vendor->BAL_DUE
      IF vendor->BAL_DUE > 0
      REPLACE vendor->BAL_DUE_CR with  0
      REPLACE vendor->BAL_DUE_DR with  vendor->BAL_DUE
      ELSE
      REPLACE vendor->BAL_DUE_DR with  0
      REPLACE vendor->BAL_DUE_CR with  vendor->BAL_DUE * -1
      ENDIF
     
             replace l_inv_date with fginvtrn->order_date
             replace l_inv_amt with fginvtrn->total   + l_inv_amt
      SELECT vnstat
    replace vnstat->bal_due with vendor->BAL_DUE
   if vnstat->bal_due < 0
         replace vnstat->bal_due_cr with vendor->BAL_DUE* -1
         replace vnstat->bal_due_dr with 0
         else
         replace vnstat->bal_due_dr with vendor->BAL_DUE
         replace vnstat->bal_due_cr with 0
         endif
    replace vnstat->total with vnstat->total + fginvtrn->total 
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
      if (fginvtrn->typ = "00" .or. fginvtrn->typ = "05") .and. (fginvtrn->cla = "00" .or. fginvtrn->cla = "10")
        replace sup_qty with sup_qty + fginvtrn->qty
        replace sup_price with fginvtrn->list_price
        else
          if (fginvtrn->typ = "00" .or. fginvtrn->typ = "05") .and. (fginvtrn->cla = "30" .or. fginvtrn->cla = "50")
        replace dis_qty with dis_qty + fginvtrn->qty
        replace dis_price with fginvtrn->list_price
        else
             if (fginvtrn->typ = "00" .or. fginvtrn->typ = "05") .and. fginvtrn->cla = "20"
        replace sup_qty with sup_qty + fginvtrn->qty
        replace sup_price with fginvtrn->list_price
        else
               if (fginvtrn->typ = "00" .or. fginvtrn->typ = "05") .and. fginvtrn->cla = "40"
        replace ker_qty with ker_qty + fginvtrn->qty
        replace ker_price with fginvtrn->list_price
        else
        replace svc_amt with svc_amt + fginvtrn->total
        endif
        endif
         endif
        endif
  

                  
  PROCEDURE service_non_rtn2
    IF .NOT. EMPTY(arniclin->SHIFT_DATE) .AND. .NOT. EMPTY(arniclin->SHIFT_NO);
       .AND. PST15F .AND. .NOT. EMPTY(arniclin->SHIFT_id) .and. ppfc
    DO st15f_non_rtn5
    ENDIF
     if ptyp = "C0" .AND. PCLA = "00" .AND. PCOD = "01" && PAYMENT OF CASH
     select st15f
     GO TOP
        replace cash_withd with cash_withd + arniclin->total
        replace shift_post with date()
        else
          if ptyp = "C0" .AND. PCLA = "00" .AND. PCOD = "11"  && Float Cash
             select st15f
                       go top
                       replace batchamt with batchamt - arniclin->total 
                        replace shift_post with date()
        endif
        endif
 
     DO stttran_non_rtn1
    
PROCEDURE   st15f_non_rtn5
    SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty +  arniclin->QTY
           REPLACE NON_CASH WITH arniclin->TOTAL + ST15F->NON_CASH + arniclin->disc_amt
               REPLACE SHIFT_POST WITH DATE()
 PROCEDURE DRTRAN_3018RTN_arinv
  
       pcoy = arniclin->coy
       pdate = st15f->shift_date
       pcustno = arnivces->frighter_n
       Pftyp = arnivces->ftyp
      ptyp = arniclin->typ
       pcla = arniclin->cla
       pcod = arniclin->cod
       local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
                local l1,l2,l3,l4,l5,l6,l7,ll8,l9,l0,l10
      l0 = frighter->source
      l1 = frighter->ftyp
      l10 = frighter->pmod
      l2 = frighter->frighter_n
      l3 = pdate
      l6 = dtos(pdate) && yyyymmdd
      l7 = left(l6,4) && yyyy
      l8 = left(l6,6) && yyyymm
      l9 = right(l8,2) && mm
      select FRMODEBT
      seek l0+l1+l10+l2+l7+l9
      if .not. found()
      append blank
      replace bbf with frighter->bal_due
      replace bal_due with bbf
      replace source with l0
      replace ftyp with l1
      replace pmod with l10
      replace frighter_n with l2
      replace yy with l7
      replace mm with l9
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     endif
     replace l_inv_amt with arniclin->total + l_inv_amt
             replace bal_due with bal_due + arniclin->total
      select frddebtp
      seek l0+l1+l10+l2+dtos(l3)
      if .not. found()
      append blank
      replace bal_due with frighter->bal_due
      replace bbf with bal_due
     replace source with l0
      replace ftyp with l1
      replace pmod with l10
      replace frighter_n with l2
      replace shift_date with l3
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace m_pay_amt with 0
     replace m_inv_amt with 0
     endif
             replace l_inv_amt with arniclin->total + l_inv_amt
             replace bal_due with bal_due + arniclin->total
             replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
             
       DO frshtrn_non_rtn1
      
          SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
           if found()
      REPLACE BAL_DUE with  arniclin->TOTAL + BAL_DUE
      replace turnover with 0
      IF BAL_DUE > 0
      REPLACE BAL_DUE_CR with  0
      REPLACE BAL_DUE_DR with  BAL_DUE
      ELSE
      REPLACE BAL_DUE_DR with  0
      REPLACE BAL_DUE_CR with  BAL_DUE * -1
      ENDIF
             replace l_inv_date with st15f->shift_date
             replace l_inv_amt with arniclin->total + l_inv_amt
              select arinvflg
   replace mast with mast + arniclin->total  && transaction file updated
   else
   select arinvflg
   endif
  
              select frcustbl
             REPLACE BAL_DUE with  arniclin->TOTAL + BAL_DUE
     DO fginvtrn_NON_RTN12
   
Procedure scashrec_rtn_arinv
         if pdiv2 = "1" .and. pst15f .and. ppfc
              do fc_credit_rtn_arinv  && credit sales of forecourt items
          else
          do service_non_rtn1  && service items credit sales
       endif
      
procedure service_non_rtn1
         IF .NOT. PTYP = "C0" 
            select scashrec
            replace exp_sales with exp_sales  + arniclin->total
       replace non_cash with non_cash + arniclin->total  && normal credit
       ELSE
       IF PTYP = "C0" .AND. PCLA = "00" .AND. PCOD = "01" && FC Cash
            select scashrec
            replace PURCH with PURCH  + arniclin->total
       ENDIF
       endif
            
procedure fc_credit_rtn_arinv
     IF .NOT. PTYP = "C0" 
      select scashrec
       replace non_cash with non_cash + arniclin->total+arniclin->disc_amt  && normal credit
       else
         IF PTYP = "C0" .AND. PCLA = "00" .AND. PCOD = "01" && FC Cash
        select scashrec
       replace purch with purch + arniclin->total+arniclin->disc_amt  && normal credit
     endif
     endif
      
PROCEDURE frshtrn_non_rtn1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lsource,lpmod
  
      lref = arnivces->ORDER_NO
      ldate = st15f->shift_date
      tdate = st15f->shift_date
      lsource = arnivces->source
      lpmod = arnivces->pmod
      lsys = "OP"
      ldoc = "19"
      lcust = arnivces->frighter_n
      lftyp = arnivces->Ftyp
       select frcount
      seek lsource+lftyp+lpmod+LCUST+pyy+pmm
      if .not. found()
      append blank
      replace source with lsource
      replace pmod with lpmod
      replace yy with pyy
      replace mm with pmm
      replace count with "0"
      REPLACE fTYP WITH LfTYP
      REPLACE frighter_N WITH LCUST
      endif
      L1 = VAL(frcount->COUNT)
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
      select frcount
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
      **
       select frshtrn
      seek lsource+lftyp+lpmod+LCUST+pyy+pmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE CARD_NO  WITH LTRIM(left(arnivces->SHIPNAME,18)+'-'+left(arnivces->ASHIPNAME,10)+'-'+left(arnivces->PURTNAME,10))
      REPLACE frighter_N WITH lcust
      replace source with lsource
      replace pmod with lpmod
      replace mm with pmm
      replace yy with pyy
      replace dd with right(dtos(ldate),2)
      
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
          
            
     REPLACE ftyP WITH lftyp
               replace invoice with 1
               REPLACE PAYMENT WITH 0
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
     
                REPLACE MILEAGE WITH arnivces->MILEAGE
                replace driver with arnivces->driver
          
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with arnivces->serialno
      replace REG        WITH arnivces->reg
       replace sTIME       WITH ltime
        replace LPO        WITH arnivces->LPO
                  replace CHEQNO with arnivces->proforma   
       
        REPLACE RECDATE WITH TRANS_DATE + arnivces->YY
         replace pay_method with arnivces->PAY_METHOD
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
          select arinvflg
   replace stat with stat + arniclin->total  && transaction file updated
  
   PROCEDURE fginvtrn_NON_RTN12
    SELECT frshtrn
    replace bal_due with frighter->BAL_DUE
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->BAL_DUE
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + arniclin->TOTAL
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   
  REPLACE DIS_qty with arniclin->dis_QTY + dis_QTY
       REPLACE SUP_qty with arniclin->SUP_QTY + SUP_QTY
            REPLACE SER_AMT with arniclin->SER_AMT + SER_AMT
             REPLACE LUB_AMT with arniclin->LUB_AMT + LUB_AMT
 
  
   **************************************************************************
*  PROGRAM:      fg3052em.prg
*
*
*******************************************************************************

Procedure fg3052em_RTN
  
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Initializing Data Entry files in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set View to "fg3052em.QBE"
      do initial_rtn_FG3052EM
      close TABLES
   
       set safety on
       *FLUSH
       close databases
        progreps.close()
  
Procedure initial_rtn_FG3052EM
   private EOFfrstat,PSDATE,PSTIME,PSYS,PDOC,PREF,PSTK,PCUST,PDATE,PTOTAL,PALLOC,;
   EOFDRREC,EOFDRINVS,Pfrighter,EOFCUST,EOFfrstat,PCMM,PYY,PLMM,PCYY,pmm
    select custyymm
  set order to dd
  select st15f
go top
pdt = left(dtos(shift_date),6) && yyyymm
pyy = left(pdt,4) && yy
pmm = right(pdt,2) && mm
select custmmyy
go top
 select frstat
 set filter to empty(stat_date)
 go top
 if .not. eof()
 DO frstat_rtn_FG52EM
 endif
 do frcust_rtn
 
Procedure frstat_rtn_FG52EM
 EOFfrstat = .F.
 SELECT frstat
 replace all stat_date with date() for empty(stat_date)
procedure frcust_rtn 
      eofcust = .f.
 select frighter
 go top
 if .not. eof()
 do
 do cust_rtn_FG52EM
 until eofcust
 endif
 LOCAL L1,L2,L3,L4,L5
 SELECT CUSTMMYY
 set order to dd
 DELETE ALL FOR EMPTY(MM) .OR. EMPTY(YY) .OR. EMPTY(DD)
 GO TOP
 L1 = YY
 L2 = MM
 L3 = DD
 SELECT CUSTYYMM
 SEEK YY+MM+DD
 IF .NOT. FOUND()
 APPEND BLANK
 REPLACE YY WITH L1
 REPLACE MM WITH L2
 REPLACE DD WITH L3
 REPLACE CLOSE_DATE WITH DATE()
 REPLACE CLOSE_USER WITH pluser
 REPLACE CLOSE_TIME WITH TIME()
 ENDIF
 SELECT CUSTMMYY
 DELETE ALL
 APPEND BLANK
 replace yy with str(year(st15f->shift_date),4)
 if month(st15f->shift_date) > 9
    replace mm with str(month(st15f->shift_date),2)
    else
    replace mm with "0"+str(month(st15f->shift_date),1)
    endif
 IF MM = "01" .OR. MM = "03" .OR. MM = "05" .OR. MM = "07" .OR. MM = "08";
  .OR. MM = "12" .OR. MM = "10" && 31 DAYS
  REPLACE DD WITH "31"
  ELSE
   IF MM = "04" .OR. MM = "06" .OR. MM = "09" .OR. MM = "11" && 30 DAYS
  REPLACE DD WITH "30"
  ELSE
  REPLACE DD WITH "28"
  ENDIF
  ENDIF
  L2 = CTOD(DD+"/"+MM+"/"+YY)
  L2 = L2 + 1
  IF MM = "02" .AND. .NOT. DAY(L2) = 1
  REPLACE DD WITH "29"
  ENDIF
  select vnstat
  set filter to empty(stat_date)
  go top
  if .not. eof()
  replace all stat_date with date() for empty(stat_date)
  endif
  eofvendor = .f.
  select vendor
  go top
  if .not. eof()
     do
        do vendor_rtn_FG52EM
        until eofvendor
   endif
   eoffgmast = .f.
   select fgmast
   go top
   if .not. eof()
      do
      do fgmast_rtn_FG52EM
      until eoffgmast
   endif
 
procedure fgmast_rtn_FG52EM
select fgmast
 replace bbf with on_hand
     *    replace phy with 0
         replace alloc with 0
         replace trans_in with 0
         replace trans_out with 0
         replace purch with 0
         replace sales with 0
         replace adj_in with 0
         replace adj_out with 0
         REPLACE CR_PURCH WITH 0
         REPLACE CS_PURCH WITH 0
         REPLACE CR_SALES  WITH 0
         REPLACE CS_SALES WITH 0
         REPLACE BBF_PHY WITH phy
         REPLACE TEMP_QTY WITH 0
         REPLACE TEMP_PURCH WITH 0
      *   REPLACE PHY_QTY WITH 0
         REPLACE BCF WITH 0
         REPLACE M_PHY WITH 0
        *REPLACE M_VAR WITH 0
         REPLACE OPEN_BAL WITH 0
         REPLACE LAST_PHY WITH 0
         REPLACE  TEMP_PHY WITH 0
         select fgmast
         if .not. eof()
         skip
         endif
         if eof()
         eoffgmast = .t.
         endif
         
Procedure vendor_rtn_FG52EM
     replace bbf with bal_due
    replace bbf_cr with bal_due_cr
    replace bbf_dr with bal_due_dr
    replace debits with 0
    replace credits with 0
    replace l_pay_amt with 0
    replace l_inv_amt with 0
    
       select vendor  
       skip
       if eof()
       eofvendor = .t.
       endif

Procedure cust_rtn_FG52EM
select frighter
     replace bbf with bal_due
    replace bbf_cr with bal_due_cr
    replace bbf_dr with bal_due_dr
    replace debits with 0
    replace credits with 0
    replace l_pay_amt with 0
    replace l_inv_amt with 0
    replace turnover with 0
psrce = source
pftyp = ftyp
ppmod = pmod
pfno = frighter_n
PTD = LEFT(DTOS(ST15F->SHIFT_DATE),6) && YYYYMM
PYY = LEFT(PTD,4)
PMM = RIGHT(PTD,2)

    
    
       select frighter
       skip
       if eof()
       eofcust = .t.
       endif
 
Procedure aricdsp_rtn
PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting Next Shift Credit Cards Receipts in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 1-15 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePointer 11,;
    ColorNormal "N+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
    
    SET VIEW TO "aricdsp.QBE"
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,PARNICADS,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,pposted
            local lld1,lld2
            set reprocess to 10000
             select st15f
   go top
     select arvisflg
go top
if eof()
append blank
replace tran with 0
replace shift_date with st15f->shift_date
replace shift_no with st15f->shift_no
replace mast with 0
replace stat with 0
replace shift_id with st15f->shift_id
endif
            SELECT DAYFGMAS
            SET ORDER TO MKEY
                              SELECT FgTRnref
    SET ORDER TO MKEY
select fragedrs
set order to mkey
select fragecrs
set order to mkey
     
SELECT FGMAST
SET ORDER TO MKEY
SELECT SHSTMAST
SET ORDER TO MKEY
SELECT CASHIERS
SET ORDER TO CASHIER
SELECT ST15F
SET ORDER TO MKEY
go top
SELECT SCASHREC
SET ORDER TO MKEY
SELECT shcatsum
SET ORDER TO MKEY
select frighter
set order to frighter
select frmodebt
set order to mkey

select frddebtp
set order to mkey
select frcount
set order to mkey
set safety off
select frdocref
zap
set order to docref
select frshtrn
set order to mkey
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,PARNICADS,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,ppfc,pposted
            pposted = .t.

      eofARNCDLIN = .f.
      select fgcoy
      go top
      ppfc = .t.
  
      select ARNICADS
      go top
      if .not. eof()
       select ARNCDLIN
       dele all for year(order_date) < 1
            go top
                if .not. eof()
   ? "STEP 2"
                do
                do icadline_rtn
                until eofARNCDLIN
            endif
             set safety off
                select ARNCDLIN
                set filter to
                zap
                select ARNICADS
                set filter to
                zap
               select frstat
               set filter to empty(age_date)
               go top
               if .not. eof()
                  do fr3052ag_rtn0
                  endif
                  set safety on
                *FLUSH
                 close databases
          
               close databases
                progreps.close()
procedure icadline_rtn
           local l1,l2,l11,l22,l3,lok,l4,l5,L6,L7,L8,L9,L10,LFD
            l4 = ARNCDLIN->order_no  && ordwer no
            l5 = ARNICADS->order_date
            L7 = ARNCDLIN->SOURCE
            L8 = ARNCDLIN->FTYP
            L9 = ARNCDLIN->PMOD
            L10 = ARNCDLIN->FRIGHTER_N
            LFD = .F.
            
            IF .NOT. EMPTY(ARNCDLIN->SOURCE) .AND. .NOT. EMPTY(ARNCDLIN->FTYP) ;
            .AND. .NOT. EMPTY(ARNCDLIN->PMOD) .AND. .NOT. EMPTY(ARNCDLIN->FRIGHTER_N)
            SELECT ARNICADS
            SET ORDER TO MKEY
            SEEK L4+dtos(l5)+L7+L8+L9+L10
            IF FOUND()
            LFD = .T.
            ENDIF
            ENDIF
            IF .NOT. LFD
            select ARNICADS
            SET ORDER TO ORDER_NO  && NOW IT HAS THE RIGHT CUSTOMER
            seek l4
            if found()
            LFD = .T.
            ENDIF
            ENDIF
            IF LFD
            
               if ppfc
    select st15f
   go top
     pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
            if val(pmonth) < 10
         pmonth = "0"+str(val(pmonth),1)
           endif
   pdoc = "28"
    pshno = st15f->shift_no
    pshdate = st15f->shift_date
    pshid = st15f->shift_id
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
   else
      pyear = str(year(st15f->shift_date),4)
   pmonth = str(month(st15f->shift_date),2)
         if val(pmonth) < 10
         pmonth = "0"+str(val(pmonth),1)
           endif
   pdoc = "28"
    pshno = "0"
    pshdate = st15f->shift_date
    pshid = "0"
    pshmm = str(month(pshdate),2)
    pshyy = str(year(pshdate),4)
    endif
    
             local lld1,lld2
            
   pst15f = .f.
    pstf = .f.
    psttt = .t.
    psub = .t.
    ptcode = .f.
   
        PSHDATE2 = ARNCDLIN->SHIFT_DATE
        if .not. empty(PSHDATE2)
        PSHDATE2 =  st15f->shift_date
        endif
      PSHNO2 = ARNCDLIN->SHIFT_NO
      if .not. empty(PSHNO2)
      PSHNO2 = st15f->shift_no
      endif
      
      PCOY = ARNCDLIN->ST_COY
      PDIV = ARNCDLIN->ST_DIV
      PCEN = ARNCDLIN->ST_CEN
      PSTO = ARNCDLIN->ST_STO
      PTYP = ARNCDLIN->TYP
      PCLA = ARNCDLIN->CLA
      PCOD = ARNCDLIN->COD
      PCOY2 = ARNCDLIN->COY
      PDIV2 = ARNCDLIN->DIV
      PCEN2 = ARNCDLIN->CEN
      PSTO2 = ARNCDLIN->STO
      PSHID2 = ARNCDLIN->shift_id
      if .not. empty(PSHID2)
      PSHID2 =  st15f->shift_id
      endif
      SELECT FGCOD
      SEEK  PTYP+PCLA+PCOD
      pshm = .t.
      if PTYP < "00" .OR. left(PTYP,1) = "7" .OR. PTYP > "9Z"  && NON-STOCK
      pshm = .f.
      endif
      pstmast = .t.
      IF PSHM
               select fgmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD  && stock master
      if found()
      pstmast = .t.
      else
     Wait 'ARNCDLIN - Problem with stock masterfile - Try Again Later!'
           quit
      endif
      
     if .not. pdiv = '1' .and. .not. ptyp = '00' && not forecourt
       select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
      if .not. found()
      append blank
        replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adjs with 0
      replace on_hand  with fgmast->on_hand
      endif
       
      ENDIF
      select shstmast
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
       if .not. found()
      append blank
      replace coy with PCOY
        replace div with PDIV
    replace cen with PCEN
      replace sto with PSTO
      replace shift_date with pshdate
      replace shift_no with pshno
      replace shift_id with pshid
      replace typ with PTYP
      replace cla with PCLA
      replace cod with PCOD
      replace cs_purch with 0
       replace cr_purch with 0
       replace cs_sales with 0
       replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with fgmast->on_hand
      replace phy    with 0
      replace on_hand with bbf
      replace cr_sales_a with 0
      replace cs_sales_a with 0
      replace cr_purch_a with 0
      replace cs_purch_a with 0
    ENDIF
     
    ENDIF
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
          replace  tax_amt with 0
         replace nonvat with ARNCDLIN->nonvat
         replace nonvat_amt with 0
         replace gross_amt with 0
         replace tax_rate with ARNCDLIN->tax_rate
         replace list_price with ARNCDLIN->list_price
         replace cost_price with ARNCDLIN->cost_price
      endif
       
                pfrighter = ARNICADS->frighter_N
               porder = ARNICADS->order_no
                        pftyp = ARNICADS->ftyp
                          pcashrno = ARNCDLIN->cashier_no
                          psource = ARNICADS->source
                          ppmod = ARNICADS->pmod
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
 replace off with ARNCDLIN->off
   endif
    
   IF  EMPTY(OFF)
    replace off with ARNCDLIN->off
    ENDIF
   SELECT CASHIERS
   SEEK pcashrno
   if found()
   replace coy with pcoy
   replace cen with pcen
   replace div with pdiv
   endif
         SELECT frighter
           SEEK psource+pftyp+ppmod+pfrighter
        IF FOUND()
           PCUS = .T.
         ELSE
        Wait 'ARNICADS+ARNCDLIN - Problem with customer masterfile - Try Again Later!'
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
        
        if pdiv2 = "1" .and. .not. empty(ARNCDLIN->shift_date) ;
         .and. .not. empty(ARNCDLIN->shift_no) .and. .not. empty(ARNCDLIN->shift_id) ;
          .and. ppfc
         pstf = .t.
         PST15F = .T.
         else
         pstf = .f.
         PST15F = .f.
         endif
         if pst15f .and. ppfc
        SELECT ST15F
         
        SEEK dtos(PSHDATE)+PSHNO+PSHID+PCEN2+PTYP+PCLA+PCOD+PSTO2+PCOY2+PDIV2
          IF FOUND()
                PST15F = .t.
                pstf = .t.
                ELSE
               Wait 'ARNCDLIN - Problem with shift masterfile - Try Again Later!'
           quit
          ENDIF
           
          endif
      local wk1,wk2
      wk1 = 0
      pcredit = .t.
      pcard = .f.
      pcash = .f.
      pcheque = .f.
      pother = .f.
               pfdate = .T.
       PCASHR = .T.
    IF EMPTY(ARNCDLIN->POST_DATE) .and. pcus .and. pstmast
    DO ARNCDLIN_icad2
          IF  ARNICADS->PAY_METHOD = "Cheque" .and. ppfc
          select st15f
          go top
           
          replace cash_merch with cash_merch + ARNCDLIN->total
          endif
    do scas_rtn9
     
   select ARNCDLIN
    replace post_date with date()
     endif
     endif
     endif
    
   select ARNCDLIN   
   if .not. eof()
       SKIP
       endif
    IF EOF()
     eofARNCDLIN = .T.
    ENDIF
  PROCEDURE ARNCDLIN_icad2
  
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
      psys   = "CD"  && point of sale
      pdoc   = "28"  && job card
      pstockno = ARNCDLIN->stock_no
     IF ARNCDLIN->TYP = "00" .and. pst15f  .and. ppfc && fuel forecourt
           DO FUEL_nn_cas_icad1
     ELSE
     DO nn_cas_svc_icad
     ENDIF
  PROCEDURE FUEL_nn_cas_icad1
        SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty + ARNCDLIN->QTY
          REPLACE ST15F->NON_CASH WITH ARNCDLIN->TOTAL + ST15F->NON_CASH    + ARNCDLIN->disc_amt
          REPLACE SHIFT_POST WITH DATE()
      do  icad_sale_rtn
  Procedure fgvistrn_icad      
        select fgvistrn
          append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with ARNCDLIN->st_coy
            replace div with ARNCDLIN->st_div
            replace cen with ARNCDLIN->st_cen
              replace sto with ARNCDLIN->st_sto
              replace st_coy with ARNCDLIN->coy
            replace st_div with ARNCDLIN->div
            replace st_cen with ARNCDLIN->cen
              replace st_sto with ARNCDLIN->sto
              replace shift_no with st15f->shift_no
               replace shift_id with st15f->shift_id
                replace serialno with ARNICADS->serialno
                replace dde_date with ARNICADS->dde_date
                replace dde_time with ARNICADS->dde_time
                replace dde_user with ARNICADS->dde_user
                replace driver with ARNCDLIN->driver
                replace CARD_RUN with ARNICADS->driver
                replace cashier_no  with ARNCDLIN->cashier_no 
            replace typ with ARNCDLIN->typ
            replace cla with ARNCDLIN->cla
            replace cod with ARNCDLIN->cod
            replace qty with ARNCDLIN->qty * -1
            replace unit_cost with ARNCDLIN->cost_price
            replace new_bal with ARNCDLIN->disc_amt
            replace total with ARNCDLIN->total
            replace list_price with ARNCDLIN->list_price
            replace tax_rate with ARNCDLIN->tax_rate
            replace tax_amt with ARNCDLIN->tax_amt
          *  replace nonvat_amt with ARNCDLIN->nonvat_amt
           * replace nonvat with ARNCDLIN->nonvat
            replace off with ARNCDLIN->off
            replace gross_amt with ARNCDLIN->gross_amt 
            replace pay_method  with "Visacard"
            replace lpo with ARNICADS->lpo
           REPLACE source WITH ARNICADS->source
          REPLACE ftyp WITH ARNICADS->ftyp
           REPLACE PMOD WITH ARNICADS->PMOD
           REPLACE FRIGHTER_N WITH ARNICADS->FRIGHTER_N
            
             replace total_amt with ARNCDLIN->nonvat
              REPLACE CARD_NO WITH ARNICADS->CARD_NO
              LOCAL L1,L2,L3,L4,L5,l6,l7,l8,l9
                 select arvisflg
      replace tran with tran + fgvistrn->total  && transaction file updated

   L1 = fgvistrn->SOURCE
   L2 = fgvistrn->FTYP
   L3 = fgvistrn->PMOD
   L4 = fgvistrn->FRIGHTER_N
   L5 = fgvistrn->SYSTEM
   L6 = fgvistrn->DOCTYPE
   L7 = fgvistrn->ORDER_DATE
   
    
      local l1,l2,l3,l4
             l1 = fgvistrn->order_no
              l2 = dtos(fgvistrn->order_date)
              l3 = fgvistrn->doctype
              l4 = fgvistrn->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fgvistrn->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + ARNCDLIN->total
              replace qty with qty + ARNCDLIN->qty
 
  
IF LEFT(fgvistrn->TYP,1) = '7' && SERVICES
        SELECT FGOFFCAS
        APPEND BLANK
        REPLACE COY WITH fgvistrn->COY
        REPLACE TYP WITH fgvistrn->TYP
        REPLACE CLA WITH fgvistrn->CLA
        REPLACE COD WITH fgvistrn->COD
        REPLACE SYSTEM WITH fgvistrn->SYSTEM
        REPLACE DOCTYPE WITH fgvistrn->DOCTYPE
        REPLACE ORDER_NO WITH fgvistrn->ORDER_NO
        REPLACE ORDER_DATE WITH fgvistrn->ORDER_DATE
        REPLACE REG WITH fgvistrn->REG
        REPLACE DRIVER WITH fgvistrn->DRIVER
        REPLACE QTY WITH fgvistrn->QTY * -1
        REPLACE TOTAL WITH fgvistrn->TOTAL
        REPLACE ADV_AMT WITH 0
        REPLACE STOCK_NO WITH fgvistrn->STOCK_NO
        REPLACE CAW_RATE WITH ARNCDLIN->LEVY_AMT
        REPLACE PIT_RATE WITH ARNCDLIN->LEVY_RATE
        REPLACE TBA_RATE WITH ARNCDLIN->DSC
   
        ENDIF
            pmain_key = psys+pdoc+dtos(pshdate)+st15f->shift_no+st15f->shift_id+porder+pstockno+ltrim(fgcoy->party_id)
      select fgorinvs
      append blank
       replace main_key with pmain_key
   replace system with psys
         replace doctype with pdoc
         replace order_no with porder
         replace order_date with pshdate
         replace stock_no with pstockno
         replace coy with ARNCDLIN->st_coy
            replace div with ARNCDLIN->st_div
            replace cen with ARNCDLIN->st_cen
              replace sto with ARNCDLIN->st_sto
              replace st_coy with ARNCDLIN->coy
            replace st_div with ARNCDLIN->div
            replace st_cen with ARNCDLIN->cen
              replace st_sto with ARNCDLIN->sto
              replace shift_no with st15f->shift_no
               replace shift_id with st15f->shift_id
                replace serialno with ARNICADS->serialno
                replace dde_date with ARNICADS->dde_date
                replace dde_time with ARNICADS->dde_time
                replace dde_user with ARNICADS->dde_user
                replace driver with ARNCDLIN->driver
                replace CARD_RUN with ARNICADS->driver
                replace cashier_no  with ARNCDLIN->cashier_no 
            replace typ with ARNCDLIN->typ
            replace cla with ARNCDLIN->cla
            replace cod with ARNCDLIN->cod
            replace qty with ARNCDLIN->qty * -1
            replace unit_cost with ARNCDLIN->cost_price
            replace new_bal with ARNCDLIN->disc_amt
            replace total with ARNCDLIN->total
            replace list_price with ARNCDLIN->list_price
            replace tax_rate with ARNCDLIN->tax_rate
            replace tax_amt with ARNCDLIN->tax_amt
          *  replace nonvat_amt with ARNCDLIN->nonvat_amt
           * replace nonvat with ARNCDLIN->nonvat
            replace off with ARNCDLIN->off
            replace gross_amt with ARNCDLIN->gross_amt
            replace pay_method  with "Visacard"
            replace lpo with ARNICADS->lpo
           REPLACE source WITH ARNICADS->source
          REPLACE ftyp WITH ARNICADS->ftyp
           REPLACE PMOD WITH ARNICADS->PMOD
           REPLACE FRIGHTER_N WITH ARNICADS->FRIGHTER_N
            
             replace total_amt with ARNCDLIN->nonvat
               REPLACE CARD_NO WITH ARNICADS->CARD_NO
              replace cust_ac_id with fgcoy->cust_ac_id
              replace party_id with fgcoy->party_id
              replace acc_no with fgcoy->acc_no
              replace mat_code with fgcod->mat_code
              replace customerid with frighter->cus_acc
 PROCEDURE icad_sale_rtn
  local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14
        l1 = st15f->shift_date
        psys = "CD"
        pdoc = "28"
        l4 = ARNICADS->order_no
        l5 = ARNCDLIN->stock_no
        l6 = st15f->shift_no
        l7 = ARNCDLIN->st_COY
        l8 = ARNCDLIN->st_div
        l9 = ARNCDLIN->st_cen
        l10 = ARNCDLIN->st_sto
        l11 = ARNCDLIN->typ
        l12 = ARNCDLIN->cla
        l13 = ARNCDLIN->cod
        l14 = ARNCDLIN->shift_id
         
          ppay = ARNICADS->PAY_METHOD
         pcustno  =  ARNICADS->frighter_N
         pftyp = ARNICADS->ftyp
         psource = ARNICADS->source
         ppmod = ARNICADS->pmod
                LOCAL D1,D2
                
              D1 = DTOS(st15f->shift_date)
              D2 = LEFT(D1,6)
              PDD = LEFT(D1,2)
              PMM = RIGHT(D2,2)
              PYY = LEFT(D1,4)
              PYR = RIGHT(PYY,1)
               PTQTY = ARNCDLIN->QTY * -1
               PTTOTAL = ARNCDLIN->TOTAL
               PTVAT = ARNCDLIN->tax_amt  && get vat amount
              PCOY = ARNCDLIN->st_COY
              PDIV = ARNCDLIN->st_DIV
              PCEN = ARNCDLIN->st_CEN
              PTYP = ARNCDLIN->TYP
              PSTO = ARNCDLIN->st_STO
              PCLA = ARNCDLIN->CLA
              PCOD = ARNCDLIN->COD
                ptcost = ARNCDLIN->qty * ARNCDLIN->cost_price
                        pother = .F.
                        pcash = .f.
                        pcredit = .f.
                        pcheque = .f.
                        pcard = .t.
     ptdate = st15f->shift_date
              do fgvistrn_icad
                   select shcatsum
                   seek pcoy+pdiv+pcen+ptyp+pcla+pcod+dtos(pSHdate)+pshno+pshid
                  if pcash .or. pcheque
                       replace cs_sal_qty with cs_sal_qty + ARNCDLIN->qty
                        replace cs_sal_shs with cs_sal_shs + ARNCDLIN->total
                        else
                     replace cr_sal_qty with cr_sal_qty + ARNCDLIN->qty
                        replace cr_sal_shs with cr_sal_shs + ARNCDLIN->total
                  endif
                    replace tax_amt with tax_amt + ARNCDLIN->tax_amt
                      replace gross_amt with gross_amt + ARNCDLIN->gross_amt
                  *    replace nonvat_amt with nonvat_amt  
                 
           if pshm
                  select shstmast
                   seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)+pshno+pshid 
                  replace on_hand with on_hand - ARNCDLIN->qty
                  if pcash .or. pcheque
                       replace cs_sales with cs_sales + ARNCDLIN->qty
                       replace cs_sales_a with cs_sales_a + ARNCDLIN->total
                      if .not. pdiv = '1' .and. .not. ptyp = '00'
           select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - ARNCDLIN->qty
       replace sales with sales + ARNCDLIN->qty
       endif 
              SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - ARNCDLIN->QTY
                       replace cs_sales with cs_sales + ARNCDLIN->qty
        
                        else
                     replace cr_sales with cr_sales + ARNCDLIN->qty
                    replace cr_sales_a with cr_sales_a + ARNCDLIN->total
                           if .not. pdiv = '1' .and. .not. ptyp = '00'
           select dayfgmas
      seek PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+dtos(pshdate)
       replace on_hand with on_hand - ARNCDLIN->qty
       replace sales with sales + ARNCDLIN->qty
       endif  
              SELECT fgmast
              REPLACE fgmast->ON_HAND WITH fgmast->ON_HAND - ARNCDLIN->QTY
                   replace cr_sales with cr_sales + ARNCDLIN->qty
          
                  endif
              
                  endif
               
           IF  pcredit .or. pcard
                  do drtran_icad
                   endif
     
 PROCEDURE nn_cas_svc_icad
    IF .NOT. EMPTY(ARNCDLIN->SHIFT_DATE) .AND. .NOT. EMPTY(ARNCDLIN->SHIFT_NO);
       .AND. PST15F .AND. .NOT. EMPTY(ARNCDLIN->SHIFT_id) .and. ppfc
    DO st15f_nn_f_icad
    ENDIF
     DO icad_sale_rtn
    
PROCEDURE   st15f_nn_f_icad
    SELECT ST15F
        REPLACE ST15F->cr_sal_qty WITH ST15F->cr_sal_qty +  ARNCDLIN->QTY
           REPLACE ST15F->NON_CASH WITH ARNCDLIN->TOTAL + ST15F->NON_CASH + ARNCDLIN->disc_amt
               REPLACE SHIFT_POST WITH DATE()
 PROCEDURE DRTRAN_icad
  
       pcoy = ARNCDLIN->coy
       pdate = st15f->shift_date
       pcustno = ARNICADS->frighter_n
       Pftyp = ARNICADS->ftyp
      ptyp = ARNCDLIN->typ
       pcla = ARNCDLIN->cla
       pcod = ARNCDLIN->cod
       local x1
       x1 =dtoS(pdate)
       pyy = LEFT(x1,4)
       x1 = left(x1,6)
       pmm = right(x1,2)
         DO frshtrn_icad1
         
                local l1,l2,l3,l4,l5,l6,l7,ll8,l9,l0,l10
      l0 = frighter->source
      l1 = frighter->ftyp
      l10 = frighter->pmod
      l2 = frighter->frighter_n
      l3 = pdate
      l6 = dtos(pdate) && yyyymmdd
      l7 = left(l6,4) && yyyy
      l8 = left(l6,6) && yyyymm
      l9 = right(l8,2) && mm
      select FRMODEBT
      seek l0+l1+l10+l2+l7+l9
      if .not. found()
      append blank
      replace bbf with frighter->bal_due
      replace bal_due with bbf
      replace source with l0
      replace ftyp with l1
      replace pmod with l10
      replace frighter_n with l2
      replace yy with l7
      replace mm with l9
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     endif
     replace l_inv_amt with ARNCDLIN->total + l_inv_amt
             replace bal_due with bal_due + ARNCDLIN->total
      
      select frddebtp
      seek l0+l1+l10+l2+dtos(l3)
      if .not. found()
      append blank
      replace bal_due with frighter->bal_due
      replace bbf with bal_due
     replace source with l0
      replace ftyp with l1
      replace pmod with l10
      replace frighter_n with l2
      replace shift_date with l3
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace m_pay_amt with 0
     replace m_inv_amt with 0
     endif
             replace l_inv_amt with ARNCDLIN->total + l_inv_amt
             replace bal_due with bal_due + ARNCDLIN->total
             replace m_pay_amt with FRMODEBT->l_pay_amt
             replace m_inv_amt with FRMODEBT->l_inv_amt
          SELECT frighter
          seek l0+l1+l10+l2
          if found()
      REPLACE BAL_DUE with  ARNCDLIN->TOTAL + BAL_DUE
      IF frighter->BAL_DUE > 0
      REPLACE frighter->BAL_DUE_CR with  0
      REPLACE frighter->BAL_DUE_DR with  frighter->BAL_DUE
      ELSE
      REPLACE frighter->BAL_DUE_DR with  0
      REPLACE frighter->BAL_DUE_CR with  frighter->BAL_DUE * -1
      ENDIF
     
             replace l_inv_date with st15f->shift_date
             replace l_inv_amt with ARNCDLIN->total + l_inv_amt
              select arvisflg
         replace mast with mast + fgvistrn->total
        else
        select arvisflg
        endif
             select frcustbl
               REPLACE BAL_DUE with  ARNCDLIN->TOTAL + BAL_DUE
    DO frshtrn_icad2
   
Procedure scas_rtn9
      if pdiv2 = "1" .and. pst15f .and. ppfc
              do icdfc_credit_rtn  && credit sales of forecourt items
          else
          do svc_credit_rtn  && service items credit sales
      endif
      
procedure svc_credit_rtn
            select scashrec
            replace exp_sales with exp_sales  + ARNCDLIN->total
  
    if  ARNICADS->frighter_n = "0001" && bonvoyage
       replace coyvisa with coyvisa + ARNCDLIN->total
    else
    if  ARNICADS->frighter_n = "0002"  && bbk
       replace bbkvisa with bbkvisa + ARNCDLIN->total
         
      else
     replace genvisa with genvisa + ARNCDLIN->total
       endif
     endif
            
procedure icdfc_credit_rtn
         select scashrec
         if   ARNICADS->frighter_n = "0001" && bonvoyage
       replace coyvisa with coyvisa + ARNCDLIN->total + ARNCDLIN->disc_amt
    else
    if  ARNICADS->frighter_n = "0002"  && bbk
       replace bbkvisa with bbkvisa + ARNCDLIN->total + ARNCDLIN->disc_amt
         
      else
      replace genvisa with genvisa + ARNCDLIN->total + ARNCDLIN->disc_amt
        endif
     endif
      
PROCEDURE frshtrn_icad1
  local ldate,ltime,tdate,lsys,ldoc,lcust,lref,lftyp,lsource,lpmod
  
      lref = ARNICADS->ORDER_NO
      ldate = st15f->shift_date
      tdate = st15f->shift_date
      lsource = ARNICADS->source
      lpmod = ARNICADS->pmod
      lsys = "CD"
      ldoc = "28"
      lcust = ARNICADS->frighter_n
    lftyp = ARNICADS->Ftyp
       select frcount
      seek lsource+lftyp+lpmod+LCUST+pyy+pmm
      if .not. found()
      append blank
      replace source with lsource
      replace pmod with lpmod
      replace yy with pyy
      replace mm with pmm
      replace count with "0"
      REPLACE fTYP WITH LfTYP
      REPLACE frighter_N WITH LCUST
      endif
      L1 = VAL(frcount->COUNT)
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
      select frcount
      replace count with L3
      ELSE
       L3 = STR(L1,5)
      endif
      ltime = L3
      
      **
       select frshtrn
      seek lsource+lftyp+lpmod+LCUST+pyy+pmm+ltime+lsys+ldoc+lref+dtos(ldate)
      if .not. found()
      append blank
      REPLACE frighter_N WITH lcust
      replace source with lsource
      replace pmod with lpmod
       replace mm with pmm
      replace yy with pyy
      replace dd with right(dtos(ldate),2)
     REPLACE CARD_NO WITH ARNICADS->CARD_NO
             REPLACE LUB_AMT with 0
              REPLACE SER_AMT with 0
              REPLACE DIS_qty with 0
       REPLACE SUP_QTY with 0
     REPLACE ftyP WITH lftyp
               REPLACE MILEAGE WITH 0
               replace invoice with 1
               REPLACE PAYMENT WITH 0
              replace total with 0
        replace amt_dr with 0
          replace amt_cr with 0
                replace driver with ARNICADS->driver
          
      replace SYSTEM     WITH lsys
      replace DOCTYPE    WITH ldoc
      replace DOCREF     WITH lref
      replace TRANS_DATE WITH tdate
      replace serialno with ARNICADS->serialno
      replace REG        WITH ARNICADS->reg
       replace sTIME       WITH ltime
        replace LPO        WITH ARNICADS->LPO
         replace pay_method with ARNICADS->PAY_METHOD
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
            select arvisflg
         replace stat with stat + fgvistrn->total
       
   PROCEDURE frshtrn_icad2
    SELECT frshtrn
    replace bal_due with frighter->BAL_DUE
   if frshtrn->bal_due < 0
         replace bal_due_cr with frighter->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with frighter->BAL_DUE
         replace bal_due_cr with 0
         endif
    replace total with frshtrn->total + ARNCDLIN->TOTAL
    if frshtrn->total < 0
         replace amt_cr with frshtrn->total* -1
         replace amt_dr with 0
    else
         replace amt_dr with frshtrn->total
         replace amt_cr with 0
      endif
   
  REPLACE DIS_qty with ARNCDLIN->dis_QTY + dis_QTY
       REPLACE SUP_qty with ARNCDLIN->SUP_QTY + SUP_QTY
            REPLACE SER_AMT with ARNCDLIN->SER_AMT + SER_AMT
             REPLACE LUB_AMT with ARNCDLIN->LUB_AMT + LUB_AMT
    
Procedure fr3052ag_rtn0

   private EOFfrstat
   EOFfrstat = .F.
   select frstat
   go top
   if .not. eof()
      do
         do fr3052_rtn1
         until eoffrstat
    endif
procedure fr3052_rtn1
p1 = frstat->source
p2 = frstat->ftyp  
p3 = frstat->pmod 
p4 = frstat->frighter_n
p5 = frstat->system  
p6 = frstat->doctype
p7 = dtos(frstat->trans_date)
      if frstat->total < 0
         do visacr_rtn
         else
         if frstat->total > 0
         do visadr_rtn
      endif
      endif
      select frstat
      replace age_date with date()
      if .not. eof()
      skip
      endif
      if eof()
      eoffrstat = .t.
      endif

procedure visacr_rtn
   select fragecrs
   seek p1+p2+p3+p4+p5+p6+p7
   if .not. found()
   append blank
   replace source with frstat->source
   replace ftyp with frstat->ftyp
   replace pmod with frstat->pmod
   replace frighter_n with frstat->frighter_n
   replace doctype with frstat->doctype
   replace system with p5
   replace trans_date with frstat->trans_date
   replace total with 0
   endif
   replace total with total + frstat->total
  
 
 procedure visadr_rtn
  select fragedrs
   seek p1+p2+p3+p4+p5+p6+p7
   if .not. found()
   append blank
   replace source with frstat->source
   replace ftyp with frstat->ftyp
   replace pmod with frstat->pmod
   replace frighter_n with frstat->frighter_n
   replace doctype with frstat->doctype
   replace system with p5
    replace trans_date with frstat->trans_date
   replace total with 0
   endif
   replace total with total + frstat->total