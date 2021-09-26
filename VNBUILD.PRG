Procedure VNBUILD
  PARAMETER BUSER,BLEVEL
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL

SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Rebuilding Vendor Ledger Accounts in progress...Wait!",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePOinter 11,;
    ColorNormal "b+/Btnface"
    PROGREPS.OPEN()
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET VIEW TO "VNBUILD.QBE"
       SELECT  VENMAS
    SUM BAL_DUE TO PWK0
 SELECT VENSTAT
 SET ORDER TO MKEY
 SUM TOTAL TO PWK1
select vendor
SUM BAL_DUE TO PWK2

select vnstat
SUM TOTAL TO PWK3
pwk0 = round(pwk0,2)
pwk1 = round(pwk1,2)
pwk2 = round(pwk2,2)
pwk3 = round(pwk3,2)

IF .NOT. (PWK1 = PWK2  .AND.  PWK3 = PWK1 .AND. PWK2 = PWK0)  .and. plevel > 1
QUIT
ENDIF
? pwk0
? pwk1
? pwk2
? pwk3
SELECT VENMAS
REPL ALL BAL_DUE WITH 0
SET ORDER TO VENDOR
PFIRST = .T.
EOFVENSTAT = .F.
local ld1,ld2
SELECT VENSTAT
   GO  TOP
   IF .NOT. EOF()
      DO
         DO VENSTAT_RTN
     UNTIL EOFVENSTAT
 ENDIF
 set safety off
 select venstat
 zap
 select venmas
 zap
 close databases
  progreps.close()
 
 
PROCEDURE VENSTAT_RTN
PSRCE = VENSTAT->VSRCE
PTYP = VENSTAT->VTYP
PMOD = VENSTAT->VPMOD
PVEN = VENSTAT->VENDOR_N
      PVENDOR1 = PSRCE+PTYP+PMOD+PVEN     
         IF PFIRST
            DO OPEN_BAL_RTN
       ENDIF
       PSRCE = VENSTAT->VSRCE
       PTYP = VENSTAT->VTYP
       PMOD = VENSTAT->VPMOD
       PVEN = VENSTAT->VENDOR_N
       PVENDOR2 = PSRCE+PTYP+PMOD+PVEN     
      IF PVENDOR1 = PVENDOR2
         DO
            DO VENSTAT_RTN2
          UNTIL EOFVENSTAT .OR. .NOT. PVENDOR1 = PVENDOR2
        ENDIF
        PFIRST = .T.
PROCEDURE OPEN_BAL_RTN
      SELECT VENMAS
      SEEK PSRCE+PTYP+PMOD+PVEN
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE VSRCE WITH PSRCE
      REPLACE VTYP WITH PTYP
      REPLACE VPMOD WITH PMOD
      REPLACE VENDOR_N  WITH PVEN
      REPLACE BAL_DUE WITH 0
      ENDIF
      
 select vnstat
       append blank
      REPLACE vendor_N WITH venstat->vendor_n
      replace vsrce with venstat->vsrce
      replace vpmod with venstat->vpmod
      replace mm with venstat->mm
      replace yy with venstat->yy
      replace dd with venstat->dd
      
           REPLACE AL_AMT WITH venstat->al_amt
             REPLACE BL_AMT WITH venstat->bl_amt
             replace bl_dr with venstat->bl_dr
             replace bl_cr with venstat->bl_cr
              REPLACE AL_AMT WITH venstat->al_amt
        
         REPLACE vtyp WITH venstat->vtyp
               REPLACE MILEAGE WITH venstat->mileage
               replace invoice with venstat->invoice
               REPLACE PAYMENT WITH venstat->payment
             
      REPLACE SYSTEM     WITH venstat->system
      REPLACE DOCTYPE    WITH venstat->doctype
      REPLACE DOCREF     WITH venstat->docref
      REPLACE TRANS_DATE WITH venstat->trans_date
      replace serialno with venstat->serialno
      REPLACE REG        WITH venstat->reg
       REPLACE sTIME       WITH venstat->stime
        REPLACE LPO        WITH venstat->LPO
        REPLACE cust        WITH venstat->cust
         replace pay_method with venstat->pay_method
            replace alloc_AMT with venstat->alloc_amt
         replace sdate with venstat->sdate
         replace bbf with venmas->bal_due
                if bbf < 0
            replace bbf_cr with venmas->bal_due* -1
            replace bbf_dr with 0
         else
            replace bbf_dr with venmas->bal_due
            replace bbf_cr with 0
         endif
    replace bal_this with 0
    replace bal_15   with 0
    replace bal_30   with 0
    replace bal_60   with 0
    replace bal_90   with 0
    replace bal_120  with 0
    replace inv_date with venstat->inv_date
    replace inv_no with venstat->inv_no
    replace inv_due with venstat->inv_due
    replace off with venstat->off
    replace inv_py_amt with venstat->inv_py_amt
     replace inv_py_ref with venstat->inv_py_ref
      replace inv_status with venstat->inv_status 
    
      replace total with venstat->total
        replace amt_dr with venstat->amt_dr
          replace amt_cr with venstat->amt_cr
          replace gratax_amt with venstat->gratax_amt
          replace gra_total with venstat->gra_total
          replace gra_gross with venstat->gra_gross
          replace gra_cost with venstat->gra_cost
      replace stat with venstat->stat
      replace cheqno with  venstat->cheqno
      replace recdate  with  venstat->recdate
      replace serialno with  venstat->serialno
      
      
          replace sup_qty with venstat->sup_qty
             replace ker_qty with venstat->ker_qty
             replace dis_price with venstat->dis_price
             replace sup_price with venstat->sup_price
             replace ker_price with venstat->ker_price
             replace svc_amt with venstat->svc_amt
             
         SELECT VENMAS
      REPLACE BAL_DUE with  VNSTAT->total   + BAL_DUE
      
         
         
 SELECT VNSTAT
    replace bal_due with VENMAS->BAL_DUE
   if bal_due < 0
         replace bal_due_cr with VENMAS->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENMAS->BAL_DUE
         replace bal_due_cr with 0
         endif
    
    PFIRST = .F.
       do rd_venstat
Procedure rd_venstat

  SeLECT VENSTAT
  SKIP
  IF EOF()
     EOFVENSTAT = .T.
     ENDIF
 
 procedure venstat_rtn2
      select vnstat
       append blank
      REPLACE vendor_N WITH venstat->vendor_n
      replace vsrce with venstat->vsrce
      replace vpmod with venstat->vpmod
      replace mm with venstat->mm
      replace yy with venstat->yy
      replace dd with venstat->dd
      
           REPLACE AL_AMT WITH venstat->al_amt
             REPLACE BL_AMT WITH venstat->bl_amt
             replace bl_dr with venstat->bl_dr
             replace bl_cr with venstat->bl_cr
              REPLACE AL_AMT WITH venstat->al_amt
        
         REPLACE vtyp WITH venstat->vtyp
               REPLACE MILEAGE WITH venstat->mileage
               replace invoice with venstat->invoice
               REPLACE PAYMENT WITH venstat->payment
             
      REPLACE SYSTEM     WITH venstat->system
      REPLACE DOCTYPE    WITH venstat->doctype
      REPLACE DOCREF     WITH venstat->docref
      REPLACE TRANS_DATE WITH venstat->trans_date
      replace serialno with venstat->serialno
      REPLACE REG        WITH venstat->reg
       REPLACE sTIME       WITH venstat->stime
        REPLACE LPO        WITH venstat->LPO
         REPLACE cust        WITH venstat->cust
         replace pay_method with venstat->pay_method
            replace alloc_AMT with venstat->alloc_amt
         replace sdate with venstat->sdate
         replace bbf with venmas->bal_due
                if bbf < 0
            replace bbf_cr with venmas->bal_due* -1
            replace bbf_dr with 0
         else
            replace bbf_dr with venmas->bal_due
            replace bbf_cr with 0
         endif
    replace bal_this with 0
    replace bal_15   with 0
    replace bal_30   with 0
    replace bal_60   with 0
    replace bal_90   with 0
    replace bal_120  with 0
    replace inv_date with venstat->inv_date
    replace inv_no with venstat->inv_no
    replace inv_due with venstat->inv_due
    replace off with venstat->off
    replace inv_py_amt with venstat->inv_py_amt
     replace inv_py_ref with venstat->inv_py_ref
      replace inv_status with venstat->inv_status 
    
      replace total with venstat->total
        replace amt_dr with venstat->amt_dr
          replace amt_cr with venstat->amt_cr
          replace gratax_amt with venstat->gratax_amt
          replace gra_total with venstat->gra_total
          replace gra_gross with venstat->gra_gross
          replace gra_cost with venstat->gra_cost
      replace stat with venstat->stat
      replace cheqno with  venstat->cheqno
      replace recdate  with  venstat->recdate
      replace serialno with  venstat->serialno
       replace sup_qty with venstat->sup_qty
             replace ker_qty with venstat->ker_qty
             replace dis_price with venstat->dis_price
             replace sup_price with venstat->sup_price
             replace ker_price with venstat->ker_price
             replace svc_amt with venstat->svc_amt
      
         
         SELECT VENMAS
      REPLACE BAL_DUE with  VNSTAT->total   + BAL_DUE
     
         
         
 SELECT VNSTAT
    replace bal_due with VENMAS->BAL_DUE
   if bal_due < 0
         replace bal_due_cr with VENMAS->BAL_DUE* -1
         replace bal_due_dr with 0
         else
         replace bal_due_dr with VENMAS->BAL_DUE
         replace bal_due_cr with 0
         endif
    
       do rd_venstat
       PSRCE = VENSTAT->VSRCE
       PTYP = VENSTAT->VTYP
       PMOD = VENSTAT->VPMOD
       PVEN = VENSTAT->VENDOR_N
       PVENDOR2 = PSRCE+PTYP+PMOD+PVEN     
     