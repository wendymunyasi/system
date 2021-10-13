procedure arvcntsp
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arvcntsp.QBE"
      do initial_rtn
      set safety off
      select arvcrnln
      go top
      if eof()
      zap
      select arvcrnup
      
      zap
      select arvcnts
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select arvcrnln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select arvcnts
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarvcrnup = .f.
        select arvcrnup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do arvcrnup_rtn
          until eofarvcrnup = .t.
      endif
      eofarvcrnln = .f.
       select arvcrnln
       go top
       if .not. eof()
          do 
             do arvcrnln_rtn
            until eofarvcrnln
       endif
       
procedure arvcrnup_rtn
   select arvcnts
   seek arvcrnup->order_no
   if .not. found()
      select arvcrnup
      delete
  endif
  select arvcrnup
  if .not. eof()
  skip
  endif
  if eof()
  eofarvcrnup = .t.
  
  endif
procedure arvcrnln_rtn
      select arvcnts
      seek arvcrnln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select arvcrnln
      delete
      endif
      select arvcrnln
      if .not. eof()
      skip
      endif
      if eof()
      eofarvcrnln = .t.
      endif
    
         