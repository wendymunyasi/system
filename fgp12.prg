procedure FGP12
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGP12.QBE"
      do initial_rtn
      set safety off
      select xodRline
      go top
      if eof()
      zap
        select xodupd
      zap
      select xorders
      zap
     
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select xodRline
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. QTY = 0 .or. ;
          empty(X_coy) .or. empty(X_div) .or. empty(X_cen) .or. empty(X_sto) 
         set order to order_no      
           select XORDERS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofxodupd = .f.
        select xodupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do xodupd_rtn
          until eofxodupd = .t.
      endif
      eofxodRline = .f.
       select xodRline
       go top
       if .not. eof()
          do 
             do xodRline_rtn
            until eofxodRline
       endif
       
procedure xodupd_rtn
   select XORDERS
   seek xodupd->order_no
   if .not. found()
      select xodupd
      delete
  endif
  select xodupd
  if .not. eof()
  skip
  endif
  if eof()
  eofxodupd = .t.
  
  endif
procedure xodRline_rtn
      select XORDERS
      seek xodRline->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select xodRline
      delete
      endif
      select xodRline
      if .not. eof()
      skip
      endif
      if eof()
      eofxodRline = .t.
      endif
    
         