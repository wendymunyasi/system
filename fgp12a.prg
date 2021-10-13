procedure FGP12A
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGP12A.QBE"
      do initial_rtn
      set safety off
      select FodRline
      go top
      if eof()
      zap
        select fodupd
      zap
      select FORDERS
      zap
     
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select FodRline
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. QTY = 0 .or. ;
          empty(X_coy) .or. empty(X_div) .or. empty(X_cen) .or. empty(X_sto) 
         set order to order_no      
           select FORDERS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eoffodupd = .f.
        select fodupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do fodupd_rtn
          until eoffodupd = .t.
      endif
      eofFodRline = .f.
       select FodRline
       go top
       if .not. eof()
          do 
             do FodRline_rtn
            until eofFodRline
       endif
       
procedure fodupd_rtn
   select FORDERS
   seek fodupd->order_no
   if .not. found()
      select fodupd
      delete
  endif
  select fodupd
  if .not. eof()
  skip
  endif
  if eof()
  eoffodupd = .t.
  
  endif
procedure FodRline_rtn
      select FORDERS
      seek FodRline->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select FodRline
      delete
      endif
      select FodRline
      if .not. eof()
      skip
      endif
      if eof()
      eofFodRline = .t.
      endif
    
         