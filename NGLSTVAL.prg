
**************************************************************************
*  PROGRAM:      NGLSTVAL
*
*******************************************************************************

Procedure NGLSTVAL
 PARAMETER BUSER,BLEVEL
   #include <messdlg.h>
   clear program
  SET DATE TO BRITISH
create session
set talk off
set ldCheck off
set decimals to 4
SET REPROCESS TO -1
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Posting STOCK VALUATION to the general ledger in progress... ",MDI .F.,;
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
   set view to "NGLSTVAL.qbe"
     PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
 
PRIVATE EOFDSHSTMAS,PYEAR,PPERIOD,PCOY,PCCENTRE,PACTYP,PACCLASS,PACC,psys,pshdate,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,pserialno,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,PTYP,PCLA,PCOD,ppwk,;
eofwkprices,pcwk,PPRICE,pcashbook,eofNLBANKC,PERR,PTVOL,PCCCOY,PCCDIV
    EOFDSHSTMAS = .F.
     select NGFGNLIF
     IF FLOCK()
     select fgadasto
      IF FLOCK()
     SET ORDER TO TKEY
  SELECT FGCOD
   IF FLOCK()
  SET ORDER TO MKEY
    select sttsheet
    set filter to .not. empty(gl_date) .and. day(gl_date+1) = 1
    go  top
    if eof()
    quit
    endif
          
      SELECT DSHSTMAS
       IF FLOCK()
      SET ORDER TO MKEY
      SET FILTER TO DAY(SHIFt_DATE + 1) = 1 .AND. .NOT. SHIFT_DATE = ST15F->SHIFT_DATE;
       .AND. PHY > 0 .AND. STD_COST > 0 .AND. shift_date = sttsheet->gl_date  .AND. EMPTY(post_date) 

      GO TOP
      IF .NOT. EOF()
         DO 
            DO RTN2
            UNTIL EOFDSHSTMAS
            endif
      ELSE
      WAIT 'UNABLE TO LOCK TABLES - TRY AGAIN LATER!'
      QUIT
      ENDIF
      ENDIF
      ENDIF
      ENDIF
 PROCEDURE RTN2
 PERR = .F.
    PTYP = DSHSTMAS->TYP
    PCLA = DSHSTMAS->CLA
    PCOD = DSHSTMAS->COD
    PCOY = DSHSTMAS->COY
    PCC = DSHSTMAS->DIV
    ppc = dshstmas->cen
    SELECT fgcod
    SEEK PTYP+PCLA+PCOD
    IF .NOT. FOUND()
    PERR = .T.
    ENDIF
   
    IF .NOT. PERR
    DO DSHSTMAS_RTN1
       ENDIF
    SELECT DSHSTMAS
    SKIP
    IF EOF()
    EOFDSHSTMAS = .T.
    ENDIF

 procedure DSHSTMAS_RTN1
  *   begintrans()
   *       on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

           pl7 = "000001"
         pl8 = DSHSTMAS->SHIFT_DATE
       pdd = dtos(pl8) && yyyymmdd
       pyr = left(pdd,4) && yyyy
       pdd1 = right(pdd,4) && mmdd
       pmth = left(pdd1,2) && mm
       pday = right(pdd1,2) && dd
       
         pl9 = "01"
         pl10 = "FG"
         p11 = "10"
      pactype = "4"
      ptyp = DSHSTMAS->typ
      pcla = DSHSTMAS->cla
      pcod = DSHSTMAS->cod
      PCOY = DSHSTMAS->COY
      PDIV = DSHSTMAS->DIV
      PCEN = DSHSTMAS->CEN
      PSTO = DSHSTMAS->STO
      PSYS  = "FG"
      PDOC = "10"
      PORDER = "000001"
      PDATE = DTOS(DSHSTMAS->shift_date)
        pacclass = "G0"
      pacc = ptyp+pcla
      pqty = DSHSTMAS->PHY
      pamt = PQTY * DSHSTMAS->STD_COST
       select fgadasto
       SEEK PCOY+PDIV+PCEN+PSTO+PTYP+PCLA+PCOD+PSYS+PDOC+PDATE
       IF .NOT. FOUND()
             append blank
            replace system with "FG"
            replace shift_no with ST15F->SHIFT_NO
            replace shift_id with ST15F->SHIFT_ID
            replace doctype with "10"
            REPLACE REASON WITH "V"
            replace order_no with "000001"
            replace order_date with DSHSTMAS->shift_date
            replace stock_no with "01"
            replace coy with DSHSTMAS->coy
            replace div with DSHSTMAS->div
            replace typ with DSHSTMAS->typ
            replace cla with DSHSTMAS->cla
            replace cod with DSHSTMAS->cod
            replace qty with DSHSTMAS->PHY
            REPLACE CEN WITH DSHSTMAS->CEN
            REPLACE STO WITH DSHSTMAS->STO
              replace ST_coy with DSHSTMAS->coy
            replace ST_div with DSHSTMAS->div
              REPLACE ST_CEN WITH DSHSTMAS->CEN
            REPLACE ST_STO WITH DSHSTMAS->STO
          
        
            replace unit_cost with DSHSTMAS->STD_COST
            replace new_bal with DSHSTMAS->STD_COST  * DSHSTMAS->PHY
            REPLACE DDE_DATE WITH DATE()
            REPLACE DDE_USER WITH PLUSER
            REPLACE DDE_TIME WITH TIME()
          
          
       DO   close_dr_rtn
      pactype = "8" && cost of sales
      pacclass = ptyp
      pacc = pcla+pcod
      pqty = DSHSTMAS->PHY * -1
      pamt = PQTY * DSHSTMAS->STD_COST
       DO   close_cr_rtn
   
     pl7 = "000001"
       pl8 = DSHSTMAS->SHIFT_DATE + 1  && new month/year
       pdd = dtos(pl8) && yyyymmdd
       pyr = left(pdd,4) && yyyy
       pdd1 = right(pdd,4) && mmdd
       pmth = left(pdd1,2) && mm
       pday = right(pdd1,2) && dd
       
         pl9 = "01"
         pl10 = "FG"
         p11 = "10"
      pactype = "8"
        pacclass = ptyp
      pacc = pcla+pcod
      pqty = DSHSTMAS->PHY
      pamt = PQTY  * DSHSTMAS->STD_COST
       DO   open_dr_rtn
    if day(pl8) = 1   .and.    month(pl8) = 1
      pactype = "9"
      pacclass = "W0"
      pacc = '0001'
      PCC = '5'
      ppc ='1'
      pqty = DSHSTMAS->PHY * -1 
      pamt = PQTY *  DSHSTMAS->STD_COST
      else
      pactype = "4"
      pacclass = "G0"
      pacc = ptyp+pcla
      pqty = DSHSTMAS->PHY * -1 
      pamt = PQTY *  DSHSTMAS->STD_COST
      endif
       DO   open_cr_rtn
         SELECT DSHSTMAS
       REPLACE POST_DATE WITH DATE()

       ENDIF
     
       procedure close_dr_rtn
       
         select NGFGNLIF
         append blank
         replace year with pyr
         replace period with pmth
           replace system with pl10
         replace doctype with p11
         replace order_no with pl7
         replace transdate with pl8
         replace stock_no with pl9
              replace actype  with pactype
            replace qty with pqty
            replace amount with pamt
            REPLACE SERIALNO WITH "000001"
            replace debitamt with 0
            replace creditamt with 0
            if amount > 0
            replace debitamt with amount
            else
            if amount < 0
            replace creditamt with amount*-1
            endif
            endif
            
            replace price with DSHSTMAS->STD_COST
            
            replace Tcode with "V"
           replace coy  with PCOY
           replace ccentre with PCC
           replace pcentre with ppc
           replace acclass  with pacclass
           replace acc  with pacc
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           
  procedure close_cr_rtn
       
         select NGFGNLIF
         append blank
         replace year with pyr
         replace period with pmth
           replace system with pl10
         replace doctype with p11
         replace order_no with pl7
         replace transdate with pl8
         replace stock_no with pl9
              replace actype  with pactype
            replace qty with pqty
            replace amount with pamt
            REPLACE SERIALNO WITH "000001"
            replace debitamt with 0
            replace creditamt with 0
            if amount > 0
            replace debitamt with amount
            else
            if amount < 0
            replace creditamt with amount*-1
            endif
            endif
            
            replace price with DSHSTMAS->STD_COST
            
            replace Tcode with "V"
           replace coy  with PCOY
           replace ccentre with PCC
           replace pcentre with ppc
           replace acclass  with pacclass
           replace acc  with pacc
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
  procedure open_dr_rtn
       
         select NGFGNLIF
         append blank
         replace year with pyr
         replace period with pmth
           replace system with pl10
         replace doctype with p11
         replace order_no with pl7
         replace transdate with pl8
         replace stock_no with pl9
              replace actype  with pactype
            replace qty with pqty
            replace amount with pamt
            REPLACE SERIALNO WITH "000001"
            replace debitamt with 0
            replace creditamt with 0
            if amount > 0
            replace debitamt with amount
            else
            if amount < 0
            replace creditamt with amount*-1
            endif
            endif
            
            replace price with DSHSTMAS->STD_COST
            
            replace Tcode with "V"
           replace coy  with PCOY
           replace ccentre with PCC
           replace pcentre with ppc
           replace acclass  with pacclass
           replace acc  with pacc
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
           
  procedure open_cr_rtn
       
         select NGFGNLIF
         append blank
         replace year with pyr
         replace period with pmth
           replace system with pl10
         replace doctype with p11
         replace order_no with pl7
         replace transdate with pl8
         replace stock_no with pl9
              replace actype  with pactype
            replace qty with pqty
            replace amount with pamt
            REPLACE SERIALNO WITH "000001"
            replace debitamt with 0
            replace creditamt with 0
            if amount > 0
            replace debitamt with amount
            else
            if amount < 0
            replace creditamt with amount*-1
            endif
            endif
            
            replace price with DSHSTMAS->STD_COST
            
            replace Tcode with "V"
           replace coy  with PCOY
           replace ccentre with PCC
           replace pcentre with ppc
           replace acclass  with pacclass
           replace acc  with pacc
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
      
      
 