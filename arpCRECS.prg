procedure ARPCRECS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "ARPCRECS.QBE"
      do initial_rtn
      set safety off
      select arcrecln
      go top
      if eof()
      zap
       select arcreupd
       zap
       select arcrecs
       zap
     endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select arcrecln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select ARCRECS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarcreupd = .f.
        select arcreupd
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do arcreupd_rtn
          until eofarcreupd = .t.
      endif
      eofarcrecln = .f.
       select arcrecln
       go top
       if .not. eof()
          do 
             do arcrecln_rtn
            until eofarcrecln
       endif
       
procedure arcreupd_rtn
   select ARCRECS
   seek arcreupd->order_no
   if .not. found()
      select arcreupd
      delete
  endif
  select arcreupd
  if .not. eof()
  skip
  endif
  if eof()
  eofarcreupd = .t.
  
  endif
procedure arcrecln_rtn
      select ARCRECS
      seek arcrecln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select arcrecln
      delete
      endif
      select arcrecln
      if .not. eof()
      skip
      endif
      if eof()
      eofarcrecln = .t.
      endif
    
         