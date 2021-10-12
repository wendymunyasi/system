**************************************************************************
*  PROGRAM:      fr3052ag.prg
*
*
*******************************************************************************


Procedure fr3052ag
PARAMETER BUSER,BLEVEL

create session
set talk off
set ldCheck off
set decimals to 4


     SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Extracting Debtors Accounts in progress... Wait!",MDI .F.,;
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
      set view to "fr3052ag.qbe"
      PLUSER = BUSER
PLEVEL = BLEVEL
  select fragedrs
     set order to mkey
     select fragecrs
     set order to mkey
      select fgshupdr
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
     do initial_rtn
     set safety off
   
     select fgshupdr
     zap
     set safety on
   *  endif
       progreps.close()
      
       
    close databases
    
Procedure initial_rtn

   private EOFfrstat
   EOFfrstat = .F.
   select frstat
   go top
   if .not. eof()
      do
         do rtn1
         until eoffrstat
    endif


procedure rtn1
p1 = frstat->source
p2 = frstat->ftyp  
p3 = frstat->pmod 
p4 = frstat->frighter_n
p5 = frstat->system  
p6 = frstat->doctype
p7 = dtos(frstat->trans_date)
      if frstat->total < 0
         do cr_rtn
         else
         if frstat->total > 0
         do dr_rtn
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

procedure cr_rtn
   select fragecrs
   seek p1+p2+p3+p4+p5+p6+p7
   if .not. found()
   append blank
   replace source with frstat->source
   replace ftyp with frstat->ftyp
   replace pmod with frstat->pmod
   replace frighter_n with frstat->frighter_n
   replace doctype with frstat->doctype
   replace trans_date with frstat->trans_date
   replace system  with p5
   replace total with 0
   endif
   replace total with total + frstat->total
  
 
 procedure dr_rtn
  select fragedrs
   seek p1+p2+p3+p4+p5+p6+p7
   if .not. found()
   append blank
   replace source with frstat->source
   replace ftyp with frstat->ftyp
   replace pmod with frstat->pmod
   replace frighter_n with frstat->frighter_n
   replace doctype with frstat->doctype
    replace trans_date with frstat->trans_date
    replace system with p5
   replace total with 0
   endif
   replace total with total + frstat->total