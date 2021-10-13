 
                
**************************************************************************
*  PROGRAM:     Fgnshmas.prg
*
*
*******************************************************************************

Procedure Fgnshmas
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif

  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "In final stages of Updtaing Stock Records in progress...Wait! ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 10-30 ss.",;
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
set decimals to 4
SET ESCAPE OFF
set view to "Fgnshmas.QBE"
SET REPROCESS TO -1
SELECT SHSTMAST
 IF FLOCK()
 select shiftsal
 IF FLOCK()
   set order to mkey
     select MONTHSAL
   IF FLOCK()
   set order to mkey
     select DAYSAL
    IF FLOCK()
   set order to mkey
select fgshupst
 IF FLOCK()
go top
if .not. eof() .AND. .NOT. EMPTY(SHIFT_DATE)
quit
endif
IF EOF()
append blank
ENDIF
replace shift_date with date()
replace dde_user with pluser
replace dde_time with time()
      do Fgshmas_RTN1
      set safety off
      select fgshupst
      zap
      set safety on
ELSE
WAIT 'UNABLE TO LOCK TABLES - TRY LATER'
QUIT
ENDIF
ENDIF
ENDIF
ENDIF
ENDIF


      close databases
      progreps.close()
      

Procedure Fgshmas_RTN1
   private EOFST15F,eofshstmast,poshdate,poshno,pnshdate,pnshno,pok,ptyp,pcla,pcod,;
   pcoy,eofshstmwkf,poyy,pomm,pnyy,pnmm,eofshcatsum,pyy,pmm,pqtr,pnqtr,ppqtr,POSHID,PNSHID
   pok = .t.
   
  eofshstmast = .f.
  select shstmast
 
    SET FILTER TO typ < "10" && fuels only
   go top
  if .not. eof()
     do
        do shstmast_rtn
        until eofshstmast
     endif
     set safety off
         select shstmast
         set filter to
         go top
        
         ZAP
        flush
         set safety on
        
      
     
    
    
    
   Procedure shstmast_rtn
       do fgmast_rtn1
      
      select shstmast
      skip
      if eof()
      eofshstmast = .t.
      endif




procedure fgmast_rtn1
   pshdate = SHSTMAST->shift_date
   pcoy = SHSTMAST->coy
   pshno = SHSTMAST->SHIFT_NO
   psal = SHSTMAST->cR_SALES   +  SHSTMAST->cS_SALES
   ppur = SHSTMAST->CR_PURCH   +  SHSTMAST->CS_PURCH  
   pcla = SHSTMAST->cla
   pyymmdd = dtos(SHSTMAST->shift_date) && yymmdd
   pyy = left(pyymmdd,4) && yyyyy
   pdd = right(pyymmdd,2) && dd
   pmm = right(left(pyyMMDD,6),2) && mm
   pdays = 30
   PXX = VAL(PMM)
   if pXX = 01 .or. pXX = 03 .or. pXX = 05 .or. pXX = 07 .or. pXX = 08 .or. pXX = 10 .or. pXX = 12
   pdays = 31
   endif
   
   px = VAL(Pyy)/4
   px1 = int(VAL(pyy)/4)
   if VAL(Pmm) = 02 
   if px - px1 > 0
   pdays = 28
   else
   pdays = 29
   endif
   endif
   
   do shiftsal_rtn
   do DAYsal_rtn
procedure shiftsal_rtn
    select shiftsal
   seek pcoy+dtos(pshdate)+pshno
   if .not. found()
   append blank
    replace shift_coy with pcoy
      replace shift_date with pshdate
      replace shift_no with pshno
       replace pur_ago with 0
       replace sal_ago with 0
       replace pur_pms with 0
       replace sal_pms with 0
       replace pur_rms with 0
       replace sal_rms with 0
       replace pur_ik with 0
       replace sal_ik with 0
       
          endif
    
   if pcla = "00" .or. pcla = "10"  && super
   replace sal_pms with sal_pms + PSAL
  replace pur_pms with pur_pms + PPUR
    endif 
    
 if pcla = "50" .or. pcla = "30"  && ago
   replace sal_ago with sal_ago + PSAL
  replace pur_ago with pur_ago + PPUR
    endif
    
     if  pcla = "20"  && regular
   replace sal_rms with sal_rms + PSAL
  replace pur_rms with pur_rms + PPUR
    endif
    
       if  pcla = "40"  && kerosene
   replace sal_ik with sal_ik + PSAL
  replace pur_ik with pur_ik + PPUR
    endif
    
    
procedure DAYSAL_rtn
    select DAYSAL
   seek pcoy+PMM+PYY+PDD
   if .not. found()
   append blank
    replace shift_coy with pcoy
      replace MM with pMM
      replace YY with PYY
      REPLACE DD WITH PDD
       replace sal_ago with 0
       replace sal_pms with 0
       replace sal_rms with 0
       replace sal_ik with 0
       
      replace CUM_ago with 0
       replace CUM_pms with 0
       replace CUM_rms with 0
       replace CUM_ik with 0
       replace PRJ_ago with 0
       replace PRJ_pms with 0
       replace PRJ_rms with 0
       replace PRJ_ik with 0
       REPLACE MON_DAYS WITH PDAYS
       
          endif
    
   if pcla = "00" .or. pcla = "10"  && super
   replace sal_pms with sal_pms + PSAL
    endif 
    
 if pcla = "50" .or. pcla = "30"  && ago
   replace sal_ago with sal_ago + PSAL
    endif
    
     if  pcla = "20"  && regular
   replace sal_rms with sal_rms + PSAL
    endif
    
       if  pcla = "40"  && kerosene
   replace sal_ik with sal_ik + PSAL
    endif
    
     select MONTHSAL
   seek pcoy+PMM+PYY
   if .not. found()
   append blank
    replace shift_coy with pcoy
      replace MM with pMM
      replace YY with PYY
       replace sal_ago with 0
       replace sal_pms with 0
       replace sal_rms with 0
       replace sal_ik with 0
       
       
          endif
    
   if pcla = "00" .or. pcla = "10"  && super
   replace sal_pms with sal_pms + PSAL
    endif 
    
 if pcla = "50" .or. pcla = "30"  && ago
   replace sal_ago with sal_ago + PSAL
    endif
    
     if  pcla = "20"  && regular
   replace sal_rms with sal_rms + PSAL
    endif
    
       if  pcla = "40"  && kerosene
   replace sal_ik with sal_ik + PSAL
    endif
    PX2 = VAL(PDD)
    SELECT DAYSAL
    REPLACE CUM_PMS WITH MONTHSAL->SAL_PMS
    REPLACE CUM_AGO WITH MONTHSAL->SAL_AGO
    REPLACE CUM_RMS WITH MONTHSAL->SAL_RMS
    REPLACE CUM_IK WITH MONTHSAL->SAL_IK
   REPLACE PRJ_PMS WITH ROUND(CUM_PMS/PX2*MON_DAYS,2)
   REPLACE PRJ_RMS WITH ROUND(CUM_RMS/PX2*MON_DAYS,2)
   REPLACE PRJ_AGO WITH ROUND(CUM_AGO/PX2*MON_DAYS,2)
   REPLACE PRJ_IK WITH ROUND(CUM_IK/PX2*MON_DAYS,2)

   