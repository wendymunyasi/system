procedure appdrcrs
create session
set talk off
set ldCheck off
set decimals to 4

set view to "appdrcrs.QBE"
      do initial_rtn
      set safety off
      select apdrcrln
      go top
      if eof()
      zap
      select apdrcrs
      zap
      select apdrcrup
      zap
      endif
    
      set safety on
      
      close databases
procedure initial_rtn
      
        select apdrcrln
         delete all for .not. empty(POST_date) .OR. EMPTY(GRN_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to GRN_NO      
           select apdrcrs
        set order to GRN_NO
        delete all for empty(GRN_NO)
        go bottom
        porder = GRN_NO
        IF .NOT. EMPTY(GRN_NO)
        delete all for .not. GRN_NO = porder .and. .not. empty(POST_date) 
        endif
        eofapdrcrup = .f.
        select apdrcrup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do apdrcrup_rtn
          until eofapdrcrup = .t.
      endif
      eofapdrcrln = .f.
       select apdrcrln
       go top
       if .not. eof()
          do 
             do apdrcrln_rtn
            until eofapdrcrln
       endif
       
procedure apdrcrup_rtn
   select apdrcrs
   seek apdrcrup->GRN_NO
   if .not. found()
      select apdrcrup
      delete
  endif
  select apdrcrup
  if .not. eof()
  skip
  endif
  if eof()
  eofapdrcrup = .t.
  
  endif
procedure apdrcrln_rtn
      select apdrcrs
      seek apdrcrln->GRN_NO
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select apdrcrln
      delete
      endif
      select apdrcrln
      if .not. eof()
      skip
      endif
      if eof()
      eofapdrcrln = .t.
      endif
    
         