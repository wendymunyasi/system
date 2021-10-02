procedure apppymts
create session
set talk off
set ldCheck off
set decimals to 4

set view to "apppymts.QBE"
      do initial_rtn
      set safety off
      select appynlin
      go top
      if eof()
      zap
      select appymts
      zap
      select appymupd
         zap
           endif
         
    
      set safety on
      
      close databases
procedure initial_rtn
      
        select appynlin
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select appymts
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofappymupd = .f.
        select appymupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do appymupd_rtn
          until eofappymupd = .t.
      endif
      eofappynlin = .f.
       select appynlin
       go top
       if .not. eof()
          do 
             do appynlin_rtn
            until eofappynlin
       endif
       
procedure appymupd_rtn
   select appymts
   seek appymupd->order_no
   if .not. found()
      select appymupd
      delete
  endif
  select appymupd
  if .not. eof()
  skip
  endif
  if eof()
  eofappymupd = .t.
  
  endif
procedure appynlin_rtn
      select appymts
      seek appynlin->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select appynlin
      delete
      endif
      select appynlin
      if .not. eof()
      skip
      endif
      if eof()
      eofappynlin = .t.
      endif
    
         