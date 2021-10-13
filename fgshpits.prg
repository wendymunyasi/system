**************************************************************************
*  PROGRAM:      FGSHPITS.prg
*
*
*******************************************************************************


procedure FGSHPITS
  PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif

 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Updating CAR WASH & PIT SERVICES in progress... Wait!",MDI .F.,;
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
set talk off
set ldCheck off
set escape off
set decimals to 4
set view to "FGSHPITS.qbe"
PLUSER = BUSER
PLEVEL = BLEVEL
set reprocess to -1
  set safety off
  SELECT hcashrec
  SET ORDER TO MKEY
        select fgcod
        set order to mkey
        select fgshtran
       IF FLOCK()
       SELECT FGOFFSAL
       go top
       if eof()
       pfirst = .t.
       else
       pfirst = .f.
       endif
       IF FLOCK()
       SET ORDER TO MKEY
       select FGPITSVC
       IF FLOCK()
       select fgtran
       if flock()
       select fginvtrn
       if flock()
       select fgjobcad
       if flock()
       select fgvistrn
       if flock()
     *   eofFGTRAN = .f.
     *   SELECT FGTRAN
     *  SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90" ;
        .and. .not. (system = "PO" .or. doctype = "24" .or. doctype = "21")
     
    *  GO TOP
    *    if .not. eof()
    *   do
    *   do FGTRAN_RTN
    *   until eofFGTRAN
    *  endif
      
       eofFGINVTRN = .f.
        SELECT FGINVTRN
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90"
     
      GO TOP
        if .not. eof()
       do
       do FGINVTRN_RTN
       until eofFGINVTRN
      endif
      
       eofFGJOBCAD = .f.
        SELECT FGJOBCAD
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90"
     
      GO TOP
        if .not. eof()
       do
       do FGJOBCAD_RTN
       until eofFGJOBCAD
      endif
       eofFGVISTRN = .f.
        SELECT FGVISTRN
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90"
     
      GO TOP
        if .not. eof()
       do
       do FGVISTRN_RTN
       until eofFGVISTRN
      endif
   else
   wait 'Unable to lock tables - try again later!'
   quit
   endif
   endif
   endif
   endif
   endif
   ENDIF
   ENDIF
   EOFFGSHTRAN = .F.
   pofp = ''
   SELECT FGSHTRAN
   SET FILTER TO EMPTY(POST_DATE)
   GO TOP
   IF .NOT. EOF()
      DO
      DO FGOFFSAL_RTN
    UNTIL EOFFGSHTRAN
  ENDIF
      eoffgLpGcad = .f.
      select fgLpGcad
      set filter to empty(post_date)
      go top
      if  .not. eof()
      do
      do fgLpGcad_rtn
      until eoffgLpGcad
      endif
      if pfirst
         do inv_first
         do vis_first
         do  job_first
         else
         do inv_nml
         do vis_nml
         do job_nml
         endif
      close databases
      progreps.close()

Procedure inv_first
eoffginvtrn = .f.
   select fginvtrn
   set filter to
   go top
   if .not. eof()
      do
         do fginv_rtn
       until eoffginvtrn
    endif

Procedure inv_nml
eoffginvtrn = .f.
   select fginvtrn
   set filter to empty(post_date)
   go top
   if .not. eof()
      do
         do fginv_rtn
       until eoffginvtrn
    endif
    
PROCEDURE FGINV_RTN
   PSD = FGINVTRN->ORDER_DATE
   PSN = FGINVTRN->SHIFT_NO
   PSI = FGINVTRN->SHIFT_ID
   PCS = FGINVTRN->CASHIER_NO
   PCN = FGINVTRN->ST_CEN
   PST = FGINVTRN->ST_STO
   PTY = FGINVTRN->TYP
   PCL = FGINVTRN->CLA
   PCD = FGINVTRN->COD
   PCO = FGINVTRN->ST_COY
   PDI = FGINVTRN->ST_DIV
   PCE = FGINVTRN->ST_CEN
   PSY = FGINVTRN->SYSTEM
   if FGINVTRN->off > '000' .and. FGINVTRN->off <='999'
   pof = FGINVTRN->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGINVTRN->TOTAL
   REPLACE OP WITH OP + FGINVTRN->QTY*-1
   SELECT FGINVTRN
     REPLACE POST_DATE WITH DATE()
   SKIP
    IF EOF()
   EOFFGINVTRN = .T.
   ENDIF
 
   
Procedure vis_first
eofFGVISTRN = .f.
   select FGVISTRN
   set filter to
   go top
   if .not. eof()
      do
         do FGVIS_rtn
       until eofFGVISTRN
    endif

Procedure vis_nml
eofFGVISTRN = .f.
   select FGVISTRN
   set filter to empty(post_date)
   go top
   if .not. eof()
      do
         do FGVIS_rtn
       until eofFGVISTRN
    endif
    
PROCEDURE FGVIS_RTN
   PSD = FGVISTRN->ORDER_DATE
   PSN = FGVISTRN->SHIFT_NO
   PSI = FGVISTRN->SHIFT_ID
   PCS = FGVISTRN->CASHIER_NO
   PCN = FGVISTRN->ST_CEN
   PST = FGVISTRN->ST_STO
   PTY = FGVISTRN->TYP
   PCL = FGVISTRN->CLA
   PCD = FGVISTRN->COD
   PCO = FGVISTRN->ST_COY
   PDI = FGVISTRN->ST_DIV
   PCE = FGVISTRN->ST_CEN
   PSY = FGVISTRN->SYSTEM
   if FGVISTRN->off > '000' .and. FGVISTRN->off <='999'
   pof = FGVISTRN->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGVISTRN->TOTAL
   REPLACE AR WITH AR + FGVISTRN->QTY*-1
   SELECT FGVISTRN
     REPLACE POST_DATE WITH DATE()
    SKIP
   IF EOF()
   EOFFGVISTRN = .T.
   ENDIF
  
Procedure job_first
eofFGJOBCAD = .f.
   select FGJOBCAD
   set filter to
   go top
   if .not. eof()
      do
         do FGJOB_rtn
       until eofFGJOBCAD
    endif

Procedure job_nml
eofFGJOBCAD = .f.
   select FGJOBCAD
   set filter to empty(post_date)
   go top
   if .not. eof()
      do
         do FGJOB_rtn
       until eofFGJOBCAD
    endif
    
PROCEDURE FGJOB_RTN
   PSD = FGJOBCAD->ORDER_DATE
   PSN = FGJOBCAD->SHIFT_NO
   PSI = FGJOBCAD->SHIFT_ID
   PCS = FGJOBCAD->CASHIER_NO
   PCN = FGJOBCAD->ST_CEN
   PST = FGJOBCAD->ST_STO
   PTY = FGJOBCAD->TYP
   PCL = FGJOBCAD->CLA
   PCD = FGJOBCAD->COD
   PCO = FGJOBCAD->ST_COY
   PDI = FGJOBCAD->ST_DIV
   PCE = FGJOBCAD->ST_CEN
   PSY = FGJOBCAD->SYSTEM
   if FGJOBCAD->off > '000' .and. FGJOBCAD->off <='999'
   pof = FGJOBCAD->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGJOBCAD->TOTAL
   REPLACE PS WITH PS + FGJOBCAD->QTY*-1
   SELECT FGJOBCAD
     REPLACE POST_DATE WITH DATE()
    SKIP
   IF EOF()
   EOFFGJOBCAD = .T.
   ENDIF 
PROCEDURE fgLpGcad_rtn
   PSD = fgLpGcad->ORDER_DATE
   PSN = fgLpGcad->SHIFT_NO
   PSI = fgLpGcad->SHIFT_ID
   PCS = fgLpGcad->CASHIER_NO
   PCN = fgLpGcad->ST_CEN
   PST = fgLpGcad->ST_STO
   PTY = fgLpGcad->TYP
   PCL = fgLpGcad->CLA
   PCD = fgLpGcad->COD
   PCO = fgLpGcad->ST_COY
   PDI = fgLpGcad->ST_DIV
   PCE = fgLpGcad->ST_CEN
   PSY = fgLpGcad->SYSTEM
   if fgLpGcad->off > '000' .and. fgLpGcad->off <='999'
   pof = fgLpGcad->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + fgLpGcad->TOTAL
   REPLACE lblp WITH lblp + fgLpGcad->QTY*-1
   SELECT fgLpGcad
     REPLACE POST_DATE WITH DATE()
   SELECT fgLpGcad
   IF .NOT. EOF()
   SKIP
   ENDIF
   IF EOF()
   EOFfgLpGcad = .T.
   ENDIF
   
PROCEDURE FGOFFSAL_RTN
   PSD = FGSHTRAN->ORDER_DATE
   PSN = FGSHTRAN->SHIFT_NO
   PSI = FGSHTRAN->SHIFT_ID
   PCS = FGSHTRAN->CASHIER_NO
   PCN = FGSHTRAN->ST_CEN
   PST = FGSHTRAN->ST_STO
   PTY = FGSHTRAN->TYP
   PCL = FGSHTRAN->CLA
   PCD = FGSHTRAN->COD
   PCO = FGSHTRAN->ST_COY
   PDI = FGSHTRAN->ST_DIV
   PCE = FGSHTRAN->ST_CEN
   PSY = FGSHTRAN->SYSTEM
   if fgshtran->off > '000' .and. fgshtran->off <='999'
   pof = FGSHTRAN->off
   else
   pof = ''
   endif
   if empty(pof)
   SELECT HCASHREC
   SEEK DTOS(PSD)+PSN+PSI+PCS+PCN+PST+PTY+PCL+PCD
   IF FOUND()
   POF = HCASHREC->OFF
   else
   pof = pofp
   if empty(pof)
   pof = '001'
   endif
   endif
   endif
   pofp = pof
   
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGSHTRAN->TOTAL
   REPLACE FS WITH FS + FGSHTRAN->QTY*-1
   SELECT FGSHTRAN
   if empty(off)
   replace off with pof
   endif
   REPLACE POST_DATE WITH DATE()
   SELECT FGSHTRAN
   IF .NOT. EOF()
   SKIP
   ENDIF
   IF EOF()
   EOFFGSHTRAN = .T.
   ENDIF
   
   
   
   
   
Procedure FGTRAN_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGTRAN->ORDER_DATE
REPLACE ORDER_NO WITH FGTRAN->ORDER_NO
REPLACE REG WITH FGTRAN->REG
REPLACE TOTAL WITH FGTRAN->TOTAL
REPLACE OFF WITH FGTRAN->OFF
REPLACE DRIVER WITH FGTRAN->DRIVER
REPLACE QTY WITH FGTRAN->QTY
REPLACE SYSTEM WITH FGTRAN->SYSTEM
REPLACE DOCTYPE WITH FGTRAN->DOCTYPE
REPLACE SHIFT_NO WITH FGTRAN->SHIFT_NO
REPLACE STOCK_NO WITH FGTRAN->STOCK_NO
REPLACE TYP WITH FGTRAN->TYP
REPLACE CLA WITH FGTRAN->CLA
REPLACE COD WITH FGTRAN->COD
REPLACE COY WITH FGTRAN->COY
REPLACE DIV WITH FGTRAN->DIV
REPLACE CEN WITH FGTRAN->CEN
REPLACE PAY_METHOD WITH FGTRAN->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = fgtran->shift_no
pshid = fgtran->shift_id
poff = driver
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0
do fgfilter_rtn
endif
SELECT FGTRAN
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGTRAN = .T.
ENDIF

procedure fgfilter_rtn
select fgfilter
append blank
replace shift_date with pshdate
replace shift_id with pshid
replace shift_no with pshno
replace divcen with pdiv+pcen
replace off with poff
replace typ with ptyp
replace cla with pcla
replace cod with pcod
replace comm_rate with fgcod->comm_rate
if comm_rate < 1  && percentage
replace qty_sold with ptotal
else
replace qty_sold with pqty
endif

Procedure FGINVTRN_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGINVTRN->ORDER_DATE
REPLACE ORDER_NO WITH FGINVTRN->ORDER_NO
REPLACE REG WITH FGINVTRN->REG
REPLACE TOTAL WITH FGINVTRN->TOTAL
REPLACE OFF WITH FGINVTRN->OFF
REPLACE DRIVER WITH FGINVTRN->DRIVER
REPLACE QTY WITH FGINVTRN->QTY
REPLACE SYSTEM WITH FGINVTRN->SYSTEM
REPLACE DOCTYPE WITH FGINVTRN->DOCTYPE
REPLACE SHIFT_NO WITH FGINVTRN->SHIFT_NO
REPLACE STOCK_NO WITH FGINVTRN->STOCK_NO
REPLACE TYP WITH FGINVTRN->TYP
REPLACE CLA WITH FGINVTRN->CLA
REPLACE COD WITH FGINVTRN->COD
REPLACE COY WITH FGINVTRN->COY
REPLACE DIV WITH FGINVTRN->DIV
REPLACE CEN WITH FGINVTRN->CEN
REPLACE PAY_METHOD WITH FGINVTRN->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = fginvtrn->shift_no
pshid = fginvtrn->shift_id
poff = driver
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0
do fgfilter_rtn
endif
if .not.  pfirst
 PSD = FGINVTRN->ORDER_DATE
   PSN = FGINVTRN->SHIFT_NO
   PSI = FGINVTRN->SHIFT_ID
   PCS = FGINVTRN->CASHIER_NO
   PCN = FGINVTRN->ST_CEN
   PST = FGINVTRN->ST_STO
   PTY = FGINVTRN->TYP
   PCL = FGINVTRN->CLA
   PCD = FGINVTRN->COD
   PCO = FGINVTRN->ST_COY
   PDI = FGINVTRN->ST_DIV
   PCE = FGINVTRN->ST_CEN
   PSY = FGINVTRN->SYSTEM
   if FGINVTRN->off > '000' .and. FGINVTRN->off <='999'
   pof = FGINVTRN->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGINVTRN->TOTAL
   REPLACE OP WITH OP + FGINVTRN->QTY*-1
   endif
SELECT FGINVTRN
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGINVTRN = .T.
ENDIF

            



Procedure FGJOBCAD_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGJOBCAD->ORDER_DATE
REPLACE ORDER_NO WITH FGJOBCAD->ORDER_NO
REPLACE REG WITH FGJOBCAD->REG
REPLACE TOTAL WITH FGJOBCAD->TOTAL
REPLACE OFF WITH FGJOBCAD->OFF
REPLACE DRIVER WITH FGJOBCAD->DRIVER
REPLACE QTY WITH FGJOBCAD->QTY
REPLACE SYSTEM WITH FGJOBCAD->SYSTEM
REPLACE DOCTYPE WITH FGJOBCAD->DOCTYPE
REPLACE SHIFT_NO WITH FGJOBCAD->SHIFT_NO
REPLACE STOCK_NO WITH FGJOBCAD->STOCK_NO
REPLACE TYP WITH FGJOBCAD->TYP
REPLACE CLA WITH FGJOBCAD->CLA
REPLACE COD WITH FGJOBCAD->COD
REPLACE COY WITH FGJOBCAD->COY
REPLACE DIV WITH FGJOBCAD->DIV
REPLACE CEN WITH FGJOBCAD->CEN
REPLACE PAY_METHOD WITH FGJOBCAD->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = fgjobcad->shift_no
pshid = fgjobcad->shift_id
poff = driver
if .not.  empty(fgjobcad->srep)
do srep_rtn
endif
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0 .and. .not. pdiv = "1"
do fgfilter_rtn
endif
if .not.  pfirst
PSD = FGJOBCAD->ORDER_DATE
   PSN = FGJOBCAD->SHIFT_NO
   PSI = FGJOBCAD->SHIFT_ID
   PCS = FGJOBCAD->CASHIER_NO
   PCN = FGJOBCAD->ST_CEN
   PST = FGJOBCAD->ST_STO
   PTY = FGJOBCAD->TYP
   PCL = FGJOBCAD->CLA
   PCD = FGJOBCAD->COD
   PCO = FGJOBCAD->ST_COY
   PDI = FGJOBCAD->ST_DIV
   PCE = FGJOBCAD->ST_CEN
   PSY = FGJOBCAD->SYSTEM
   if FGJOBCAD->off > '000' .and. FGJOBCAD->off <='999'
   pof = FGJOBCAD->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGJOBCAD->TOTAL
   REPLACE PS WITH PS + FGJOBCAD->QTY*-1
   endif
SELECT FGJOBCAD
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGJOBCAD = .T.
ENDIF

            

Procedure FGVISTRN_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGVISTRN->ORDER_DATE
REPLACE ORDER_NO WITH FGVISTRN->ORDER_NO
REPLACE REG WITH FGVISTRN->REG
REPLACE TOTAL WITH FGVISTRN->TOTAL
REPLACE OFF WITH FGVISTRN->OFF
REPLACE DRIVER WITH FGVISTRN->DRIVER
REPLACE QTY WITH FGVISTRN->QTY
REPLACE SYSTEM WITH FGVISTRN->SYSTEM
REPLACE DOCTYPE WITH FGVISTRN->DOCTYPE
REPLACE SHIFT_NO WITH FGVISTRN->SHIFT_NO
REPLACE STOCK_NO WITH FGVISTRN->STOCK_NO
REPLACE TYP WITH FGVISTRN->TYP
REPLACE CLA WITH FGVISTRN->CLA
REPLACE COD WITH FGVISTRN->COD
REPLACE COY WITH FGVISTRN->COY
REPLACE DIV WITH FGVISTRN->DIV
REPLACE CEN WITH FGVISTRN->CEN
REPLACE PAY_METHOD WITH FGVISTRN->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = fgvistrn->shift_no
pshid = fgvistrn->shift_id
poff = driver
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0
do fgfilter_rtn
endif
if .not.  pfirst
 PSD = FGVISTRN->ORDER_DATE
   PSN = FGVISTRN->SHIFT_NO
   PSI = FGVISTRN->SHIFT_ID
   PCS = FGVISTRN->CASHIER_NO
   PCN = FGVISTRN->ST_CEN
   PST = FGVISTRN->ST_STO
   PTY = FGVISTRN->TYP
   PCL = FGVISTRN->CLA
   PCD = FGVISTRN->COD
   PCO = FGVISTRN->ST_COY
   PDI = FGVISTRN->ST_DIV
   PCE = FGVISTRN->ST_CEN
   PSY = FGVISTRN->SYSTEM
   if FGVISTRN->off > '000' .and. FGVISTRN->off <='999'
   pof = FGVISTRN->off
   else
   pof = '001'
   endif
   SELECT FGOFFSAL
   SEEK DTOS(PSD)+PCO+PTY+PCL+PCD+POF
   IF .NOT. FOUND()
   APPEND BLANK
   REPLACE ORDER_DATE WITH PSD
   REPLACE COY WITH PCO
    REPLACE TYP WITH PTY
   REPLACE CLA WITH PCL
   REPLACE COD WITH PCD
   REPLACE OFF WITH POF
   REPLACE FS WITH 0
   REPLACE LBLP WITH 0
   REPLACE OP WITH 0
   REPLACE AR WITH 0
   REPLACE PS WITH 0
   REPLACE TOTAL WITH 0
   REPLACE OTH WITH 0
   ENDIF
   REPLACE TOTAL WITH TOTAL + FGVISTRN->TOTAL
   REPLACE AR WITH AR + FGVISTRN->QTY*-1
 endif
SELECT FGVISTRN
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGVISTRN = .T.
ENDIF

procedure srep_rtn
SELECT FGSALREP
APPEND BLANK
REPLACE ORDER_DATE WITH FGJOBCAD->ORDER_DATE
REPLACE ORDER_NO WITH FGJOBCAD->ORDER_NO
REPLACE TOTAL WITH FGJOBCAD->TOTAL
REPLACE SREP WITH FGJOBCAD->SREP
REPLACE QTY WITH FGJOBCAD->QTY
REPLACE SYSTEM WITH FGJOBCAD->SYSTEM
REPLACE DOCTYPE WITH FGJOBCAD->DOCTYPE
REPLACE SHIFT_NO WITH FGJOBCAD->SHIFT_NO
REPLACE SHIFT_ID WITH FGJOBCAD->SHIFT_ID
REPLACE STOCK_NO WITH FGJOBCAD->STOCK_NO
REPLACE TYP WITH FGJOBCAD->TYP
REPLACE CLA WITH FGJOBCAD->CLA
REPLACE COD WITH FGJOBCAD->COD
REPLACE COY WITH FGJOBCAD->COY
REPLACE DIV WITH FGJOBCAD->DIV
REPLACE CEN WITH FGJOBCAD->CEN