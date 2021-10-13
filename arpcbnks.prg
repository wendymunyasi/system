procedure ARPCBNKS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "ARPCBNKS.QBE"
      do initial_rtn
      set safety off
      select ARCBNKLN
      go top
      if eof()
      zap
       select ARCBNUPD
       zap
       select ARCBNKS
       zap
     endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select ARCBNKLN
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO)  .or. total = 0
         set order to order_no      
           select ARCBNKS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofARCBNUPD = .f.
        select ARCBNUPD
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do ARCBNUPD_rtn
          until eofARCBNUPD = .t.
      endif
      eofARCBNKLN = .f.
       select ARCBNKLN
       go top
       if .not. eof()
          do 
             do ARCBNKLN_rtn
            until eofARCBNKLN
       endif
       
procedure ARCBNUPD_rtn
   select ARCBNKS
   seek ARCBNUPD->order_no
   if .not. found()
      select ARCBNUPD
      delete
  endif
  select ARCBNUPD
  if .not. eof()
  skip
  endif
  if eof()
  eofARCBNUPD = .t.
  
  endif
procedure ARCBNKLN_rtn
      select ARCBNKS
      seek ARCBNKLN->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select ARCBNKLN
      delete
      endif
      select ARCBNKLN
      if .not. eof()
      skip
      endif
      if eof()
      eofARCBNKLN = .t.
      endif
    
         