**************************************************************************
*  PROGRAM:      ngljnls
*
*******************************************************************************

Procedure fg30jnls
PARAMETER BUSER,BLEVEL
   #include <messdlg.h>
*if .not. validdrive("H:")
* InformationMessage("Accounts Computer Not on Network", "Sorry!")
* quit
* endif  
   clear program
create session
set talk off
set ldCheck off
set decimals to 4
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting JOURNALS in progress... ",MDI .F.,;
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
    ColorNormal "b+/Btnface"
PROGREPS.OPEN()

     do initial_rtn
     
     progreps.close()
        CLOSE DATABASES
  
Procedure initial_rtn
   set view to "fg30jnls.qbe"
PRIVATE EOFngljnls,PYEAR,PPERIOD,PCOY,PCCENTRE,PACTYP,PACCLASS,PACC,psys,pshdate,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,ptyp,;
pcla,pcod,ppwk,eofwkprices,pcwk,PPRICE,per,pcashbook,pserial,eofnlbankc

   EOFngljnls = .F.
          
      SELECT ngljnls
      set filter to EMPTY(gl_post) .and. .not. (amount = 0 .AND. QTY = 0)  .and. .not. ;
       (empty(year) .or. empty(coy) .or. empty(ccentre) .or. empty(actype) .or. empty(pcentre);
        .or. empty(acclass) .or. empty(acc) .or. empty(period))
 GO TOP
      IF .NOT. EOF()
         DO 
            DO RTN2
            UNTIL EOFngljnls
            endif
            set safety off
            select ngljnls
            zap
            close databases
            set safety on
            

 PROCEDURE RTN2

      select nglnlif
      append blank
      replace year with ngljnls->year
      replace coy with ngljnls->coy
      replace ccentre with ngljnls->ccentre
      replace pcentre with ngljnls->pcentre
      replace actype with ngljnls->actype
      replace acclass with ngljnls->acclass
      replace acc with ngljnls->acc
      replace transdate with ngljnls->transdate
      replace system with ngljnls->system
      replace doctype with ngljnls->doctype
      replace qty with ngljnls->qty
      replace price with ngljnls->price
      replace amount with ngljnls->amount
      replace debitamt with ngljnls->debitamt
      replace creditamt with ngljnls->creditamt
      replace period with ngljnls->period
      replace dde_date with ngljnls->dde_date
       replace dde_user with ngljnls->dde_user
        replace dde_time with ngljnls->dde_time
        replace tcode    with ngljnls->tcode   
         replace off      with ngljnls->off
          replace order_no with ngljnls->order_no
           replace stock_no with ngljnls->stock_no
            replace serialno with ngljnls->serialno
       select ngljnls     
       replace gl_post with date()   
       flush
       if .not. eof()
      SKIP
      endif
     IF EOF()
     EOFngljnls = .T.
     ENDIF
         