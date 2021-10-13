procedure arpcashs
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpcashs.QBE"
      do initial_rtn
      set safety off
      select aracasln
      go top
      if eof()
      zap
      select arcasupd
      zap
      select arcashs
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select aracasln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. total = 0
         set order to order_no      
           select arcashs
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarcasupd = .f.
        select arcasupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do arcasupd_rtn
          until eofarcasupd = .t.
      endif
      eofaracasln = .f.
       select aracasln
       go top
       if .not. eof()
          do 
             do aracasln_rtn
            until eofaracasln
       endif
       
procedure arcasupd_rtn
   select arcashs
   seek arcasupd->order_no
   if .not. found()
      select arcasupd
      delete
  endif
  select arcasupd
  if .not. eof()
  skip
  endif
  if eof()
  eofarcasupd = .t.
  
  endif
procedure aracasln_rtn
      select arcashs
      seek aracasln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select aracasln
      delete
      endif
      select aracasln
      if .not. eof()
      skip
      endif
      if eof()
      eofaracasln = .t.
      endif
    
         