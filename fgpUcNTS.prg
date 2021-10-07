procedure FGPUCNTS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGPUCNTS.QBE"
      do initial_rtn
      set safety off
      select FGUCNLIN
      go top
      if eof()
      zap
      select FGUCrup
      zap
      select FGUCnts
      zap
      endif
      select fgtrnref
      delete all for .not. empty(post_date)
      set safety on
      
      close databases
procedure initial_rtn
      
        select FGUCNLIN
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0 
         set order to order_no      
           select FGUCNTS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofFGUCrup = .f.
        select FGUCrup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do FGUCrup_rtn
          until eofFGUCrup = .t.
      endif
      eofFGUCNLIN = .f.
       select FGUCNLIN
       go top
       if .not. eof()
          do 
             do FGUCNLIN_rtn
            until eofFGUCNLIN
       endif
       
procedure FGUCrup_rtn
   select FGUCNTS
   seek FGUCrup->order_no
   if .not. found()
      select FGUCrup
      delete
  endif
  select FGUCrup
  if .not. eof()
  skip
  endif
  if eof()
  eofFGUCrup = .t.
  
  endif
procedure FGUCNLIN_rtn
      select FGUCNTS
      seek FGUCNLIN->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select FGUCNLIN
      delete
      endif
      select FGUCNLIN
      if .not. eof()
      skip
      endif
      if eof()
      eofFGUCNLIN = .t.
      endif
    
         