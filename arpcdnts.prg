procedure arpcdnts
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpcdnts.QBE"
      do initial_rtn
      set safety off
      select arcsdlin
      go top
      if eof()
      zap
       select arcsdupd
       zap
       select arcdnts
       zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select arcsdlin
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select arcdnts
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarcsdupd = .f.
        select arcsdupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do arcsdupd_rtn
          until eofarcsdupd = .t.
      endif
      eofarcsdlin = .f.
       select arcsdlin
       go top
       if .not. eof()
          do 
             do arcsdlin_rtn
            until eofarcsdlin
       endif
       
procedure arcsdupd_rtn
   select arcdnts
   seek arcsdupd->order_no
   if .not. found()
      select arcsdupd
      delete
  endif
  select arcsdupd
  if .not. eof()
  skip
  endif
  if eof()
  eofarcsdupd = .t.
  
  endif
procedure arcsdlin_rtn
      select arcdnts
      seek arcsdlin->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select arcsdlin
      delete
      endif
      select arcsdlin
      if .not. eof()
      skip
      endif
      if eof()
      eofarcsdlin = .t.
      endif
    
         