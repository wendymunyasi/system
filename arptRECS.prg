procedure arptRECS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arptRECS.QBE"
      do initial_rtn
      set safety off
      select artrecln
      go top
      if eof()
      zap
      select artrecup
      zap
      select artrecs
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select artrecln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select artrecs
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofartrecup = .f.
        select artrecup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do artrecup_rtn
          until eofartrecup = .t.
      endif
      eofartrecln = .f.
       select artrecln
       go top
       if .not. eof()
          do 
             do artrecln_rtn
            until eofartrecln
       endif
       
procedure artrecup_rtn
   select artrecs
   seek artrecup->order_no
   if .not. found()
      select artrecup
      delete
  endif
  select artrecup
  if .not. eof()
  skip
  endif
  if eof()
  eofartrecup = .t.
  
  endif
procedure artrecln_rtn
      select artrecs
      seek artrecln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select artrecln
      delete
      endif
      select artrecln
      if .not. eof()
      skip
      endif
      if eof()
      eofartrecln = .t.
      endif
    
         