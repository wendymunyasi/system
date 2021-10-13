procedure FGPLCNTS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGPLCNTS.QBE"
      do initial_rtn
      set safety off
      select FGLCNLIN
      go top
      if eof()
      zap
      select FGLCrup
      zap
      select FGLCnts
      zap
      endif
      select fgtrnref
      delete all for .not. empty(post_date)
      set safety on
      
      close databases
procedure initial_rtn
      
        select FGLCNLIN
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0 
         set order to order_no      
           select FGLCNTS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofFGLCrup = .f.
        select FGLCrup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do FGLCrup_rtn
          until eofFGLCrup = .t.
      endif
      eofFGLCNLIN = .f.
       select FGLCNLIN
       go top
       if .not. eof()
          do 
             do FGLCNLIN_rtn
            until eofFGLCNLIN
       endif
       
procedure FGLCrup_rtn
   select FGLCNTS
   seek FGLCrup->order_no
   if .not. found()
      select FGLCrup
      delete
  endif
  select FGLCrup
  if .not. eof()
  skip
  endif
  if eof()
  eofFGLCrup = .t.
  
  endif
procedure FGLCNLIN_rtn
      select FGLCNTS
      seek FGLCNLIN->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select FGLCNLIN
      delete
      endif
      select FGLCNLIN
      if .not. eof()
      skip
      endif
      if eof()
      eofFGLCNLIN = .t.
      endif
    
         