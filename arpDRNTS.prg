procedure arpdrnts
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpdrnts.QBE"
      do initial_rtn
      set safety off
      select ardrnln
      go top
      if eof()
      zap
      select ardrnupd
      zap
      select ardrnts
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
        select ardrnln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select ardrnts
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofardrnupd = .f.
        select ardrnupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do ardrnupd_rtn
          until eofardrnupd = .t.
      endif
      eofardrnln = .f.
       select ardrnln
       go top
       if .not. eof()
          do 
             do ardrnln_rtn
            until eofardrnln
       endif
       
procedure ardrnupd_rtn
   select ardrnts
   seek ardrnupd->order_no
   if .not. found()
      select ardrnupd
      delete
  endif
  select ardrnupd
  if .not. eof()
  skip
  endif
  if eof()
  eofardrnupd = .t.
  
  endif
procedure ardrnln_rtn
      select ardrnts
      seek ardrnln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select ardrnln
      delete
      endif
      select ardrnln
      if .not. eof()
      skip
      endif
      if eof()
      eofardrnln = .t.
      endif
    
         