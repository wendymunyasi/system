procedure APPOCRNT
create session
set talk off
set ldCheck off
set decimals to 4

set view to "APPOCRNT.QBE"
      do initial_rtn
      set safety off
      select APOCRLIN
      go top
      if eof()
      zap
      select APCRNTS
      zap
      select APOCRLUP
      zap
      endif
        select fgtrnref
      delete all for .not. empty(post_date)
      set safety on
      
      close databases
procedure initial_rtn
      
        select APOCRLIN
         delete all for .not. empty(POST_date) .OR. EMPTY(GRN_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to GRN_NO      
           select APCRNTS
        set order to GRN_NO
        delete all for empty(GRN_NO)
        go bottom
        porder = GRN_NO
        IF .NOT. EMPTY(GRN_NO)
        delete all for .not. GRN_NO = porder .and. .not. empty(POST_date) 
        endif
        eofAPOCRLUP = .f.
        select APOCRLUP
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do APOCRLUP_rtn
          until eofAPOCRLUP = .t.
      endif
      eofAPOCRLIN = .f.
       select APOCRLIN
       go top
       if .not. eof()
          do 
             do APOCRLIN_rtn
            until eofAPOCRLIN
       endif
       
procedure APOCRLUP_rtn
   select APCRNTS
   seek APOCRLUP->GRN_NO
   if .not. found()
      select APOCRLUP
      delete
  endif
  select APOCRLUP
  if .not. eof()
  skip
  endif
  if eof()
  eofAPOCRLUP = .t.
  
  endif
procedure APOCRLIN_rtn
      select APCRNTS
      seek APOCRLIN->GRN_NO
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select APOCRLIN
      delete
      endif
      select APOCRLIN
      if .not. eof()
      skip
      endif
      if eof()
      eofAPOCRLIN = .t.
      endif
    
         