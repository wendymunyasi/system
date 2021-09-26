procedure frtrns
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Updating Daily Aged Analysis Report in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take a few minutes.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePOinter 11,;
    ColorNormal "n+"
    PROGREPS.OPEN()
    create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
set safety off
select 1
use \kenservice\data\frstat.dbf exclusive
select 2
use \kenserve\idssys\fragedrs.dbf
copy stru to \kenservice\data\fragedrs dbase prod
use \kenservice\data\fragedrs.dbf
select 3
use \kenserve\idssys\fragecrs.dbf  exclusive
copy stru to \kenservice\data\fragecrs dbase prod
use \kenservice\data\fragecrs.dbf exclusive

eoffrstat = .f.
pzeros = .f.
select fragedrs
set order to mkey
select fragecrs
set order to mkey
select frstat
set order to  mkey
go top 
if .not. eof()
   do 
      do frstat_rtn
    until eoffrstat
    endif
    set safety on
    close databases
     progreps.close()
procedure frstat_rtn
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
   replace system with p5
   replace trans_date with frstat->trans_date
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
   replace system with p5
    replace trans_date with frstat->trans_date
   replace total with 0
   endif
   replace total with total + frstat->total