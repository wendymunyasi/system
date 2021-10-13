procedure arpdrecs
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arpdrecs.QBE"
      do initial_rtn
      set safety off
      select ardrecln
      go top
      if eof()
      zap
      select ardredup
      zap
      select ardrecs
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select ardrecln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select ardrecs
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofardredup = .f.
        select ardredup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do ardredup_rtn
          until eofardredup = .t.
      endif
      eofardrecln = .f.
       select ardrecln
       go top
       if .not. eof()
          do 
             do ardrecln_rtn
            until eofardrecln
       endif
       
procedure ardredup_rtn
   select ardrecs
   seek ardredup->order_no
   if .not. found()
      select ardredup
      delete
  endif
  select ardredup
  if .not. eof()
  skip
  endif
  if eof()
  eofardredup = .t.
  
  endif
procedure ardrecln_rtn
      select ardrecs
      seek ardrecln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select ardrecln
      delete
      endif
      select ardrecln
      if .not. eof()
      skip
      endif
      if eof()
      eofardrecln = .t.
      endif
    
         