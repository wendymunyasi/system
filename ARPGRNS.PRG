procedure arpgrns
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpgrns.QBE"
      do initial_rtn
      set safety off
      select argrline
      go top
      if eof()
      zap
      select argrnup
       zap
       select argrns
       zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select argrline
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select argrns
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofargrnup = .f.
        select argrnup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do argrnup_rtn
          until eofargrnup = .t.
      endif
      eofargrline = .f.
       select argrline
       go top
       if .not. eof()
          do 
             do argrline_rtn
            until eofargrline
       endif
       
procedure argrnup_rtn
   select argrns
   seek argrnup->order_no
   if .not. found()
      select argrnup
      delete
  endif
  select argrnup
  if .not. eof()
  skip
  endif
  if eof()
  eofargrnup = .t.
  
  endif
procedure argrline_rtn
      select argrns
      seek argrline->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select argrline
      delete
      endif
      select argrline
      if .not. eof()
      skip
      endif
      if eof()
      eofargrline = .t.
      endif
    
         