
                
**************************************************************************
*  PROGRAM:     FRSHTRN.prg
*
*
*******************************************************************************

Procedure FRSHTRN
PARAMETER BUSER,BLEVEL
private pptotal
pptotal = 0

  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Updating Customer Statements in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set view to "FRSHTRN.QBE"
SET REPROCESS TO -1
           PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    if empty(pluser) .or. empty(plevel)
    quit
    endif
   eoffrshtrn = .f.
   select frighter
   set order to frighter
 
select frshtrn

go top
if .not. eof()
   do
      do FRSHTRN_RTN1
      until eoffrshtrn
  endif
  set safety off
  select frshtrn
  zap
   set safety off
            use \kenserve\idssys\frshtrn.dbf
            copy stru to \kenservice\data\frshtrns dbase prod
                    close databases
  set safety on
 
      close databases
      progreps.close()
      

Procedure FRSHTRN_RTN1
     begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
       select frstat
      append blank
      replace source with frshtrn->source
      replace ftyp with frshtrn->ftyp
      replace pmod with frshtrn->pmod
      replace frighter_n with frshtrn->frighter_n
      replace yy with frshtrn->yy
      replace mm with frshtrn->mm
      replace stime with frshtrn->stime
      replace system with frshtrn->system
      replace doctype  with frshtrn->doctype
      replace docref with frshtrn->docref
      replace trans_date with frshtrn->trans_date
      replace sdate with frshtrn->sdate
      replace total with frshtrn->total
      replace reg with frshtrn->reg
      replace lpo with frshtrn->lpo
      replace serialno with frshtrn->serialno
      if empty(serialno)
      replace serialno with docref
      endif
      replace card_no with frshtrn->card_no
      replace mileage with frshtrn->mileage
      replace recdate with frshtrn->recdate
      replace invoice with frshtrn->invoice
      replace payment with frshtrn->payment
      replace amt_cr with frshtrn->amt_cr
      replace amt_dr with frshtrn->amt_dr
      replace bbf with frshtrn->bbf
      replace pay_method with frshtrn->pay_method
      replace stat_date with frshtrn->stat_date
      replace bal_due_dr with frshtrn->bal_due_dr
      replace bal_due_cr with frshtrn->bal_due_cr
      replace bbf_cr with frshtrn->bbf_cr
      replace bbf_dr with frshtrn->bbf_dr
      replace cheqno  with frshtrn->cheqno
      replace age_date with frshtrn->age_date
      replace dis_qty with frshtrn->dis_qty
      replace sup_qty with frshtrn->sup_qty
      replace lub_amt with frshtrn->lub_amt
      replace ser_amt with frshtrn->ser_amt
      replace driver with frshtrn->driver
      replace bal_due  with frshtrn->bal_due
     
      select frshtrn
      delete
      commit()
      if .not. eof()
      skip
      endif
      if eof()
      eoffrshtrn = .t.
      endif
  
