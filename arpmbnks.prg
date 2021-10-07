procedure arpmbnks
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpmbnks.QBE"
      do initial_rtn
      set safety off
      select armbnkln
      go top
      if eof()
      zap
       select armbnupd
       zap
       select armbnks
       zap
     endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select armbnkln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO)  .or. total = 0
         set order to order_no      
           select armbnks
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarmbnupd = .f.
        select armbnupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do armbnupd_rtn
          until eofarmbnupd = .t.
      endif
      eofarmbnkln = .f.
       select armbnkln
       go top
       if .not. eof()
          do 
             do armbnkln_rtn
            until eofarmbnkln
       endif
       
procedure armbnupd_rtn
   select armbnks
   seek armbnupd->order_no
   if .not. found()
      select armbnupd
      delete
  endif
  select armbnupd
  if .not. eof()
  skip
  endif
  if eof()
  eofarmbnupd = .t.
  
  endif
procedure armbnkln_rtn
      select armbnks
      seek armbnkln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select armbnkln
      delete
      endif
      select armbnkln
      if .not. eof()
      skip
      endif
      if eof()
      eofarmbnkln = .t.
      endif
    
         