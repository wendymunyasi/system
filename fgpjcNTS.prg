procedure FGPJCNTS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGPJCNTS.QBE"
      do initial_rtn
      set safety off
      select FGJCNLIN
      go top
      if eof()
      zap
      select fgjcrup
      zap
      select fgjcnts
      zap
      endif
      select fgtrnref
      delete all for .not. empty(post_date)
      set safety on
      
      close databases
procedure initial_rtn
      
        select FGJCNLIN
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select FGJCNTS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eoffgjcrup = .f.
        select fgjcrup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do fgjcrup_rtn
          until eoffgjcrup = .t.
      endif
      eofFGJCNLIN = .f.
       select FGJCNLIN
       go top
       if .not. eof()
          do 
             do FGJCNLIN_rtn
            until eofFGJCNLIN
       endif
       
procedure fgjcrup_rtn
   select FGJCNTS
   seek fgjcrup->order_no
   if .not. found()
      select fgjcrup
      delete
  endif
  select fgjcrup
  if .not. eof()
  skip
  endif
  if eof()
  eoffgjcrup = .t.
  
  endif
procedure FGJCNLIN_rtn
      select FGJCNTS
      seek FGJCNLIN->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select FGJCNLIN
      delete
      endif
      select FGJCNLIN
      if .not. eof()
      skip
      endif
      if eof()
      eofFGJCNLIN = .t.
      endif
    
         