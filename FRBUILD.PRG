Procedure FRBUILD
   PARAMETER BUSER,BLEVEL
      PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL

SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Rebuilding DEBTORS Ledger Accounts in progress...Wait!",MDI .F.,;
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
    SET VIEW TO "FRBUILD.QBE"
    select frstat2
    go top
    if .not. eof()
    wait 'Check frstat2'
    quit
    endif
    SELECT FRIMAS
    SET ORDER TO FRIGHTER
  EOFFRSTAT = .F.
  SELECT FRSTAT
  SET ORDER TO MKEY2
  GO TOP
  IF .NOT. EOF()
     DO 
     DO FRI_RTN
   UNTIL EOFFRSTAT
   ENDIF
    progreps.close()
   CLOSE DATABASES
PROCEDURE FRI_RTN
SELECT FRIMAS
SEEK FRSTAT->SOURCE+FRSTAT->FTYP+FRSTAT->PMOD+FRSTAT->FRIGHTER_N
IF .NOT. FOUND()
   DO RTN2
   ELSE
   DO RTN3
   ENDIF
   do frstat2_rtn
   SELECT FRSTAT
   SKIP
   IF EOF()
    EOFFRSTAT = .T.
    ENDIF
PROCEDURE RTN3
      SELECT FRSTAT
         REPLACE BBF WITH FRIMAS->BAL_DUE
          IF BBF > 0
      REPLACE BBF_DR WITH BAL_DUE
      REPLACE BBF_CR WITH 0
      ELSE
       REPLACE BBF_CR WITH BAL_DUE * -1
       REPLACE BBF_DR WITH 0
       ENDIF
  SELECT FRIMAS
  REPLACE BAL_DUE WITH BAL_DUE + FRSTAT->TOTAL
     REPLACE TRANS_DATE WITH FRSTAT->TRANS_DATE
      SELECT FRSTAT
      REPLACE BAL_DUE WITH FRIMAS->BAL_DUE
      IF BAL_DUE > 0
      REPLACE BAL_DUE_DR WITH BAL_DUE
      REPLACE BAL_DUE_CR WITH 0
      ELSE
       REPLACE BAL_DUE_CR WITH BAL_DUE * -1
      REPLACE BAL_DUE_DR WITH 0
      ENDIF
      
PROCEDURE RTN2    
SELECT FRIMAS
APPEND BLANK
      replace source with FRSTAT->source
      replace ftyp with FRSTAT->ftyp
      replace pmod with FRSTAT->pmod
      replace frighter_n with FRSTAT->frighter_n
       replace bal_due with FRSTAT->TOTAL
     SELECT FRSTAT
      REPLACE BBF WITH 0
      REPLACE BBF_CR WITH 0
      REPLACE BBF_DR WITH 0
      REPLACE BAL_DUE WITH TOTAL
      IF BAL_DUE > 0
      REPLACE BAL_DUE_DR WITH BAL_DUE
      REPLACE BAL_DUE_CR WITH 0
      ELSE
       REPLACE BAL_DUE_CR WITH BAL_DUE * -1
      REPLACE BAL_DUE_DR WITH 0
      ENDIF
 
   procedure frstat2_rtn
   select frstat2
      append blank
      replace source with frstat->source
      replace ftyp with frstat->ftyp
      replace pmod with frstat->pmod
      replace frighter_n with frstat->frighter_n
      replace yy with frstat->yy
      replace mm with frstat->mm
      replace stime with frstat->stime
      replace system with frstat->system
      replace doctype  with frstat->doctype
      replace docref with frstat->docref
      replace trans_date with frstat->trans_date
      replace sdate with frstat->sdate
      replace total with frstat->total
      replace reg with frstat->reg
      replace lpo with frstat->lpo
      replace serialno with frstat->serialno
       replace card_no with frstat->card_no
      replace mileage with frstat->mileage
      replace recdate with frstat->recdate
      replace invoice with frstat->invoice
      replace payment with frstat->payment
      replace amt_cr with frstat->amt_cr
      replace amt_dr with frstat->amt_dr
      replace bbf with frstat->bbf
      replace pay_method with frstat->pay_method
      replace stat_date with frstat->stat_date
      replace bal_due_dr with frstat->bal_due_dr
      replace bal_due_cr with frstat->bal_due_cr
      replace bbf_cr with frstat->bbf_cr
      replace bbf_dr with frstat->bbf_dr
      replace cheqno  with frstat->cheqno
      replace age_date with frstat->age_date
      replace dis_qty with frstat->dis_qty
      replace sup_qty with frstat->sup_qty
      replace lub_amt with frstat->lub_amt
      replace ser_amt with frstat->ser_amt
      replace driver with frstat->driver
      replace bal_due  with frstat->bal_due
      replace cust with frstat->cust