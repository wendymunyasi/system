**************************************************************************
*  PROGRAM:      fgshpitn.prg
*
*
*******************************************************************************


procedure fgshpitn
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
set view to "fgshpitn.qbe"
PLUSER = BUSER
PLEVEL = BLEVEL
set reprocess to -1
  set safety off
  SELECT hcashtrs
  SET ORDER TO MKEY
        select fgcod
        set order to mkey
        select fgshtrns
       
       SELECT FGOFFSAL
       go top
       if eof()
       pfirst = .t.
       else
       pfirst = .f.
       endif
       
       SET ORDER TO MKEY
       select FGPITSVC
       
       select FGTRANRS
       
       select FGINVTRS
       
       select FGJOBTRS
       
       select fgvistrs
       
        eofFGTRANRS = .f.
        SELECT FGTRANRS
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90" ;
        .and. .not. (system = "PO" .or. doctype = "24" .or. doctype = "21")
     
      GO TOP
        if .not. eof()
       do
       do FGTRANRS_RTN
       until eofFGTRANRS
      endif
      
       eofFGINVTRS = .f.
        SELECT FGINVTRS
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90"
     
      GO TOP
        if .not. eof()
       do
       do FGINVTRS_RTN
       until eofFGINVTRS
      endif
      
       eofFGJOBTRS = .f.
        SELECT FGJOBTRS
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90"
     
      GO TOP
        if .not. eof()
       do
       do FGJOBTRS_RTN
       until eofFGJOBTRS
      endif
       eoffgvistrs = .f.
        SELECT fgvistrs
       SET FILTER TO EMPTY(POST_DATE) .AND. TYP > "30" .AND. TYP < "90"
     
      GO TOP
        if .not. eof()
       do
       do fgvistrs_RTN
       until eoffgvistrs
      endif
 
   EOFfgshtrns = .F.
   pofp = ''
   SELECT fgshtrns
   SET FILTER TO EMPTY(POST_DATE)
   GO TOP
   IF .NOT. EOF()
      DO
      DO FGOFFSAL_RTN
    UNTIL EOFfgshtrns
  ENDIF
      eoffgLpGtrs = .f.
      select fgLpGtrs
      set filter to empty(post_date)
      go top
      if  .not. eof()
      do
      do fgLpGtrs_rtn
      until eoffgLpGtrs
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
eofFGINVTRS = .f.
   select FGINVTRS
   set filter to
   go top
   if .not. eof()
      do
         do fginv_rtn
       until eofFGINVTRS
    endif

Procedure inv_nml
eofFGINVTRS = .f.
   select FGINVTRS
   set filter to empty(post_date)
   go top
   if .not. eof()
      do
         do fginv_rtn
       until eofFGINVTRS
    endif
    
PROCEDURE FGINV_RTN
   PSD = FGINVTRS->ORDER_DATE
   PSN = FGINVTRS->SHIFT_NO
   PSI = FGINVTRS->SHIFT_ID
   PCS = FGINVTRS->CASHIER_NO
   PCN = FGINVTRS->ST_CEN
   PST = FGINVTRS->ST_STO
   PTY = FGINVTRS->TYP
   PCL = FGINVTRS->CLA
   PCD = FGINVTRS->COD
   PCO = FGINVTRS->ST_COY
   PDI = FGINVTRS->ST_DIV
   PCE = FGINVTRS->ST_CEN
   PSY = FGINVTRS->SYSTEM
   if FGINVTRS->off > '000' .and. FGINVTRS->off <='999'
   pof = FGINVTRS->off
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
   REPLACE TOTAL WITH TOTAL + FGINVTRS->TOTAL
   REPLACE OP WITH OP + FGINVTRS->QTY*-1
   SELECT FGINVTRS
     REPLACE POST_DATE WITH DATE()
   SKIP
    IF EOF()
   EOFFGINVTRS = .T.
   ENDIF
 
   
Procedure vis_first
eoffgvistrs = .f.
   select fgvistrs
   set filter to
   go top
   if .not. eof()
      do
         do FGVIS_rtn
       until eoffgvistrs
    endif

Procedure vis_nml
eoffgvistrs = .f.
   select fgvistrs
   set filter to empty(post_date)
   go top
   if .not. eof()
      do
         do FGVIS_rtn
       until eoffgvistrs
    endif
    
PROCEDURE FGVIS_RTN
   PSD = fgvistrs->ORDER_DATE
   PSN = fgvistrs->SHIFT_NO
   PSI = fgvistrs->SHIFT_ID
   PCS = fgvistrs->CASHIER_NO
   PCN = fgvistrs->ST_CEN
   PST = fgvistrs->ST_STO
   PTY = fgvistrs->TYP
   PCL = fgvistrs->CLA
   PCD = fgvistrs->COD
   PCO = fgvistrs->ST_COY
   PDI = fgvistrs->ST_DIV
   PCE = fgvistrs->ST_CEN
   PSY = fgvistrs->SYSTEM
   if fgvistrs->off > '000' .and. fgvistrs->off <='999'
   pof = fgvistrs->off
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
   REPLACE TOTAL WITH TOTAL + fgvistrs->TOTAL
   REPLACE AR WITH AR + fgvistrs->QTY*-1
   SELECT fgvistrs
     REPLACE POST_DATE WITH DATE()
    SKIP
   IF EOF()
   EOFfgvistrs = .T.
   ENDIF
  
Procedure job_first
eofFGJOBTRS = .f.
   select FGJOBTRS
   set filter to
   go top
   if .not. eof()
      do
         do FGJOB_rtn
       until eofFGJOBTRS
    endif

Procedure job_nml
eofFGJOBTRS = .f.
   select FGJOBTRS
   set filter to empty(post_date)
   go top
   if .not. eof()
      do
         do FGJOB_rtn
       until eofFGJOBTRS
    endif
    
PROCEDURE FGJOB_RTN
   PSD = FGJOBTRS->ORDER_DATE
   PSN = FGJOBTRS->SHIFT_NO
   PSI = FGJOBTRS->SHIFT_ID
   PCS = FGJOBTRS->CASHIER_NO
   PCN = FGJOBTRS->ST_CEN
   PST = FGJOBTRS->ST_STO
   PTY = FGJOBTRS->TYP
   PCL = FGJOBTRS->CLA
   PCD = FGJOBTRS->COD
   PCO = FGJOBTRS->ST_COY
   PDI = FGJOBTRS->ST_DIV
   PCE = FGJOBTRS->ST_CEN
   PSY = FGJOBTRS->SYSTEM
   if FGJOBTRS->off > '000' .and. FGJOBTRS->off <='999'
   pof = FGJOBTRS->off
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
   REPLACE TOTAL WITH TOTAL + FGJOBTRS->TOTAL
   REPLACE PS WITH PS + FGJOBTRS->QTY*-1
   SELECT FGJOBTRS
     REPLACE POST_DATE WITH DATE()
    SKIP
   IF EOF()
   EOFFGJOBTRS = .T.
   ENDIF 
PROCEDURE fgLpGtrs_rtn
   PSD = fgLpGtrs->ORDER_DATE
   PSN = fgLpGtrs->SHIFT_NO
   PSI = fgLpGtrs->SHIFT_ID
   PCS = fgLpGtrs->CASHIER_NO
   PCN = fgLpGtrs->ST_CEN
   PST = fgLpGtrs->ST_STO
   PTY = fgLpGtrs->TYP
   PCL = fgLpGtrs->CLA
   PCD = fgLpGtrs->COD
   PCO = fgLpGtrs->ST_COY
   PDI = fgLpGtrs->ST_DIV
   PCE = fgLpGtrs->ST_CEN
   PSY = fgLpGtrs->SYSTEM
   if fgLpGtrs->off > '000' .and. fgLpGtrs->off <='999'
   pof = fgLpGtrs->off
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
   REPLACE TOTAL WITH TOTAL + fgLpGtrs->TOTAL
   REPLACE lblp WITH lblp + fgLpGtrs->QTY*-1
   SELECT fgLpGtrs
     REPLACE POST_DATE WITH DATE()
   SELECT fgLpGtrs
   IF .NOT. EOF()
   SKIP
   ENDIF
   IF EOF()
   EOFfgLpGtrs = .T.
   ENDIF
   
PROCEDURE FGOFFSAL_RTN
   PSD = fgshtrns->ORDER_DATE
   PSN = fgshtrns->SHIFT_NO
   PSI = fgshtrns->SHIFT_ID
   PCS = fgshtrns->CASHIER_NO
   PCN = fgshtrns->ST_CEN
   PST = fgshtrns->ST_STO
   PTY = fgshtrns->TYP
   PCL = fgshtrns->CLA
   PCD = fgshtrns->COD
   PCO = fgshtrns->ST_COY
   PDI = fgshtrns->ST_DIV
   PCE = fgshtrns->ST_CEN
   PSY = fgshtrns->SYSTEM
   if fgshtrns->off > '000' .and. fgshtrns->off <='999'
   pof = fgshtrns->off
   else
   pof = ''
   endif
   if empty(pof)
   SELECT hcashtrs
   SEEK DTOS(PSD)+PSN+PSI+PCS+PCN+PST+PTY+PCL+PCD
   IF FOUND()
   POF = hcashtrs->OFF
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
   REPLACE TOTAL WITH TOTAL + fgshtrns->TOTAL
   REPLACE FS WITH FS + fgshtrns->QTY*-1
   SELECT fgshtrns
   if empty(off)
   replace off with pof
   endif
   REPLACE POST_DATE WITH DATE()
   SELECT fgshtrns
   IF .NOT. EOF()
   SKIP
   ENDIF
   IF EOF()
   EOFfgshtrns = .T.
   ENDIF
   
   
   
   
   
Procedure FGTRANRS_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGTRANRS->ORDER_DATE
REPLACE ORDER_NO WITH FGTRANRS->ORDER_NO
REPLACE REG WITH FGTRANRS->REG
REPLACE TOTAL WITH FGTRANRS->TOTAL
REPLACE OFF WITH FGTRANRS->OFF
REPLACE DRIVER WITH FGTRANRS->DRIVER
REPLACE QTY WITH FGTRANRS->QTY
REPLACE SYSTEM WITH FGTRANRS->SYSTEM
REPLACE DOCTYPE WITH FGTRANRS->DOCTYPE
REPLACE SHIFT_NO WITH FGTRANRS->SHIFT_NO
REPLACE STOCK_NO WITH FGTRANRS->STOCK_NO
REPLACE TYP WITH FGTRANRS->TYP
REPLACE CLA WITH FGTRANRS->CLA
REPLACE COD WITH FGTRANRS->COD
REPLACE COY WITH FGTRANRS->COY
REPLACE DIV WITH FGTRANRS->DIV
REPLACE CEN WITH FGTRANRS->CEN
REPLACE PAY_METHOD WITH FGTRANRS->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = FGTRANRS->shift_no
pshid = FGTRANRS->shift_id
poff = driver
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0
do fgfilter_rtn
endif
SELECT FGTRANRS
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGTRANRS = .T.
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

Procedure FGINVTRS_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGINVTRS->ORDER_DATE
REPLACE ORDER_NO WITH FGINVTRS->ORDER_NO
REPLACE REG WITH FGINVTRS->REG
REPLACE TOTAL WITH FGINVTRS->TOTAL
REPLACE OFF WITH FGINVTRS->OFF
REPLACE DRIVER WITH FGINVTRS->DRIVER
REPLACE QTY WITH FGINVTRS->QTY
REPLACE SYSTEM WITH FGINVTRS->SYSTEM
REPLACE DOCTYPE WITH FGINVTRS->DOCTYPE
REPLACE SHIFT_NO WITH FGINVTRS->SHIFT_NO
REPLACE STOCK_NO WITH FGINVTRS->STOCK_NO
REPLACE TYP WITH FGINVTRS->TYP
REPLACE CLA WITH FGINVTRS->CLA
REPLACE COD WITH FGINVTRS->COD
REPLACE COY WITH FGINVTRS->COY
REPLACE DIV WITH FGINVTRS->DIV
REPLACE CEN WITH FGINVTRS->CEN
REPLACE PAY_METHOD WITH FGINVTRS->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = FGINVTRS->shift_no
pshid = FGINVTRS->shift_id
poff = driver
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0
do fgfilter_rtn
endif
if .not.  pfirst
 PSD = FGINVTRS->ORDER_DATE
   PSN = FGINVTRS->SHIFT_NO
   PSI = FGINVTRS->SHIFT_ID
   PCS = FGINVTRS->CASHIER_NO
   PCN = FGINVTRS->ST_CEN
   PST = FGINVTRS->ST_STO
   PTY = FGINVTRS->TYP
   PCL = FGINVTRS->CLA
   PCD = FGINVTRS->COD
   PCO = FGINVTRS->ST_COY
   PDI = FGINVTRS->ST_DIV
   PCE = FGINVTRS->ST_CEN
   PSY = FGINVTRS->SYSTEM
   if FGINVTRS->off > '000' .and. FGINVTRS->off <='999'
   pof = FGINVTRS->off
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
   REPLACE TOTAL WITH TOTAL + FGINVTRS->TOTAL
   REPLACE OP WITH OP + FGINVTRS->QTY*-1
   endif
SELECT FGINVTRS
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGINVTRS = .T.
ENDIF

            



Procedure FGJOBTRS_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH FGJOBTRS->ORDER_DATE
REPLACE ORDER_NO WITH FGJOBTRS->ORDER_NO
REPLACE REG WITH FGJOBTRS->REG
REPLACE TOTAL WITH FGJOBTRS->TOTAL
REPLACE OFF WITH FGJOBTRS->OFF
REPLACE DRIVER WITH FGJOBTRS->DRIVER
REPLACE QTY WITH FGJOBTRS->QTY
REPLACE SYSTEM WITH FGJOBTRS->SYSTEM
REPLACE DOCTYPE WITH FGJOBTRS->DOCTYPE
REPLACE SHIFT_NO WITH FGJOBTRS->SHIFT_NO
REPLACE STOCK_NO WITH FGJOBTRS->STOCK_NO
REPLACE TYP WITH FGJOBTRS->TYP
REPLACE CLA WITH FGJOBTRS->CLA
REPLACE COD WITH FGJOBTRS->COD
REPLACE COY WITH FGJOBTRS->COY
REPLACE DIV WITH FGJOBTRS->DIV
REPLACE CEN WITH FGJOBTRS->CEN
REPLACE PAY_METHOD WITH FGJOBTRS->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = FGJOBTRS->shift_no
pshid = FGJOBTRS->shift_id
poff = driver
if .not.  empty(FGJOBTRS->srep)
do srep_rtn
endif
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0 .and. .not. pdiv = "1"
do fgfilter_rtn
endif
if .not.  pfirst
PSD = FGJOBTRS->ORDER_DATE
   PSN = FGJOBTRS->SHIFT_NO
   PSI = FGJOBTRS->SHIFT_ID
   PCS = FGJOBTRS->CASHIER_NO
   PCN = FGJOBTRS->ST_CEN
   PST = FGJOBTRS->ST_STO
   PTY = FGJOBTRS->TYP
   PCL = FGJOBTRS->CLA
   PCD = FGJOBTRS->COD
   PCO = FGJOBTRS->ST_COY
   PDI = FGJOBTRS->ST_DIV
   PCE = FGJOBTRS->ST_CEN
   PSY = FGJOBTRS->SYSTEM
   if FGJOBTRS->off > '000' .and. FGJOBTRS->off <='999'
   pof = FGJOBTRS->off
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
   REPLACE TOTAL WITH TOTAL + FGJOBTRS->TOTAL
   REPLACE PS WITH PS + FGJOBTRS->QTY*-1
   endif
SELECT FGJOBTRS
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFFGJOBTRS = .T.
ENDIF

            

Procedure fgvistrs_RTN
SELECT FGPITSVC
APPEND BLANK
REPLACE ORDER_DATE WITH fgvistrs->ORDER_DATE
REPLACE ORDER_NO WITH fgvistrs->ORDER_NO
REPLACE REG WITH fgvistrs->REG
REPLACE TOTAL WITH fgvistrs->TOTAL
REPLACE OFF WITH fgvistrs->OFF
REPLACE DRIVER WITH fgvistrs->DRIVER
REPLACE QTY WITH fgvistrs->QTY
REPLACE SYSTEM WITH fgvistrs->SYSTEM
REPLACE DOCTYPE WITH fgvistrs->DOCTYPE
REPLACE SHIFT_NO WITH fgvistrs->SHIFT_NO
REPLACE STOCK_NO WITH fgvistrs->STOCK_NO
REPLACE TYP WITH fgvistrs->TYP
REPLACE CLA WITH fgvistrs->CLA
REPLACE COD WITH fgvistrs->COD
REPLACE COY WITH fgvistrs->COY
REPLACE DIV WITH fgvistrs->DIV
REPLACE CEN WITH fgvistrs->CEN
REPLACE PAY_METHOD WITH fgvistrs->PAY_METHOD
ptyp = typ
pcla = cla
pcod = cod
pdiv = div
pcen = cen
pqty = qty*-1
ptotal = total
pshdate = order_date
pshno = fgvistrs->shift_no
pshid = fgvistrs->shift_id
poff = driver
select fgcod
seek ptyp+pcla+pcod
if comm_rate > 0
do fgfilter_rtn
endif
if .not.  pfirst
 PSD = fgvistrs->ORDER_DATE
   PSN = fgvistrs->SHIFT_NO
   PSI = fgvistrs->SHIFT_ID
   PCS = fgvistrs->CASHIER_NO
   PCN = fgvistrs->ST_CEN
   PST = fgvistrs->ST_STO
   PTY = fgvistrs->TYP
   PCL = fgvistrs->CLA
   PCD = fgvistrs->COD
   PCO = fgvistrs->ST_COY
   PDI = fgvistrs->ST_DIV
   PCE = fgvistrs->ST_CEN
   PSY = fgvistrs->SYSTEM
   if fgvistrs->off > '000' .and. fgvistrs->off <='999'
   pof = fgvistrs->off
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
   REPLACE TOTAL WITH TOTAL + fgvistrs->TOTAL
   REPLACE AR WITH AR + fgvistrs->QTY*-1
 endif
SELECT fgvistrs
REPLACE POST_DATE WITH DATE()
SKIP
IF EOF()
EOFfgvistrs = .T.
ENDIF

procedure srep_rtn
SELECT FGSALREP
APPEND BLANK
REPLACE ORDER_DATE WITH FGJOBTRS->ORDER_DATE
REPLACE ORDER_NO WITH FGJOBTRS->ORDER_NO
REPLACE TOTAL WITH FGJOBTRS->TOTAL
REPLACE SREP WITH FGJOBTRS->SREP
REPLACE QTY WITH FGJOBTRS->QTY
REPLACE SYSTEM WITH FGJOBTRS->SYSTEM
REPLACE DOCTYPE WITH FGJOBTRS->DOCTYPE
REPLACE SHIFT_NO WITH FGJOBTRS->SHIFT_NO
REPLACE SHIFT_ID WITH FGJOBTRS->SHIFT_ID
REPLACE STOCK_NO WITH FGJOBTRS->STOCK_NO
REPLACE TYP WITH FGJOBTRS->TYP
REPLACE CLA WITH FGJOBTRS->CLA
REPLACE COD WITH FGJOBTRS->COD
REPLACE COY WITH FGJOBTRS->COY
REPLACE DIV WITH FGJOBTRS->DIV
REPLACE CEN WITH FGJOBTRS->CEN