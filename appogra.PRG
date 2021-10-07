procedure APPOGRA
create session
set talk off
set ldCheck off
set decimals to 4

set view to "APPOGRA.QBE"
      do initial_rtn
      set safety off
      select APGRALIN
      go top
      if eof()
      zap
      select APGRAS
      zap
      select APGRAUP
      zap
      endif
        select fgtrnref
      delete all for .not. empty(post_date)
      set safety on
      
      close databases
procedure initial_rtn
      
        select APGRALIN
         delete all for .not. empty(POST_date) .OR. EMPTY(GRN_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to GRN_NO      
           select APGRAS
        set order to GRN_NO
        delete all for empty(GRN_NO)
        go bottom
        porder = GRN_NO
        IF .NOT. EMPTY(GRN_NO)
        delete all for .not. GRN_NO = porder .and. .not. empty(POST_date) 
        endif
        eofAPGRAUP = .f.
        select APGRAUP
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do APGRAUP_rtn
          until eofAPGRAUP = .t.
      endif
      eofAPGRALIN = .f.
       select APGRALIN
       go top
       if .not. eof()
          do 
             do APGRALIN_rtn
            until eofAPGRALIN
       endif
       
procedure APGRAUP_rtn
   select APGRAS
   seek APGRAUP->GRN_NO
   if .not. found()
      select APGRAUP
      delete
  endif
  select APGRAUP
  if .not. eof()
  skip
  endif
  if eof()
  eofAPGRAUP = .t.
  
  endif
procedure APGRALIN_rtn
      select APGRAS
      seek APGRALIN->GRN_NO
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select APGRALIN
      delete
      endif
      select APGRALIN
      if .not. eof()
      skip
      endif
      if eof()
      eofAPGRALIN = .t.
      endif
    
         