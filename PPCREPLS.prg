procedure ppcrepls
create session
set talk off
set ldCheck off
set decimals to 4

set view to "ppcrepls.QBE"
      do initial_rtn
      set safety off
      select pcreplin
      go top
      if eof()
      zap
      select pcrepls
      zap
      select pcrepupd
         zap
           endif
         
    
      set safety on
      
      close databases
procedure initial_rtn
      
        select pcreplin
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select pcrepls
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofpcrepupd = .f.
        select pcrepupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do pcrepupd_rtn
          until eofpcrepupd = .t.
      endif
      eofpcreplin = .f.
       select pcreplin
       go top
       if .not. eof()
          do 
             do pcreplin_rtn
            until eofpcreplin
       endif
       
procedure pcrepupd_rtn
   select pcrepls
   seek pcrepupd->order_no
   if .not. found()
      select pcrepupd
      delete
  endif
  select pcrepupd
  if .not. eof()
  skip
  endif
  if eof()
  eofpcrepupd = .t.
  
  endif
procedure pcreplin_rtn
      select pcrepls
      seek pcreplin->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select pcreplin
      delete
      endif
      select pcreplin
      if .not. eof()
      skip
      endif
      if eof()
      eofpcreplin = .t.
      endif
    
         