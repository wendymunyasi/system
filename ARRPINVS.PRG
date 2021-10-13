procedure arrpinvs
create session
set talk off
set ldCheck off
set decimals to 4

set view to "arrpinvs.QBE"
      do initial_rtn
      set safety off
      select arrinvln
      go top
      if eof()
      zap
      select arrinvsp
       zap
       select arrinvs
       zap
       SELECT FGSTKNOS
       ZAP
      endif
      select fgjcrs
      delete all for .not. empty(post_date)
      go top
      if eof()
      zap
      endif
      select fgtrnref
      delete all for .not. empty(post_date)
      set safety on
      
      close databases
procedure initial_rtn
      
        select arrinvln
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select arrinvs
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofarrinvsp = .f.
        select arrinvsp
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do arrinvsp_rtn
          until eofarrinvsp = .t.
      endif
      eofarrinvln = .f.
       select arrinvln
       go top
       if .not. eof()
          do 
             do arrinvln_rtn
            until eofarrinvln
       endif
       
procedure arrinvsp_rtn
   select arrinvs
   seek arrinvsp->order_no
   if .not. found()
      select arrinvsp
      delete
  endif
  select arrinvsp
  if .not. eof()
  skip
  endif
  if eof()
  eofarrinvsp = .t.
  
  endif
procedure arrinvln_rtn
      select arrinvs
      seek arrinvln->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select arrinvln
      delete
      endif
      select arrinvln
      if .not. eof()
      skip
      endif
      if eof()
      eofarrinvln = .t.
      endif
    
         