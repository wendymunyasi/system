procedure arpcmps
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpcmps.QBE"
      do initial_rtn
      set safety off
      select arcmpln
      go top
      if eof()
      zap
      select arcmpdup
      zap
      select arcmps
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select arcmpln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select arcmps
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarcmpdup = .f.
        select arcmpdup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do arcmpdup_rtn
          until eofarcmpdup = .t.
      endif
      eofarcmpln = .f.
       select arcmpln
       go top
       if .not. eof()
          do 
             do arcmpln_rtn
            until eofarcmpln
       endif
       
procedure arcmpdup_rtn
   select arcmps
   seek arcmpdup->order_no
   if .not. found()
      select arcmpdup
      delete
  endif
  select arcmpdup
  if .not. eof()
  skip
  endif
  if eof()
  eofarcmpdup = .t.
  
  endif
procedure arcmpln_rtn
      select arcmps
      seek arcmpln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select arcmpln
      delete
      endif
      select arcmpln
      if .not. eof()
      skip
      endif
      if eof()
      eofarcmpln = .t.
      endif
    
         