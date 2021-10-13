procedure ARPCINVS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "ARPCINVS.QBE"
      do initial_rtn
      set safety off
      select ARCILINE
      go top
      if eof()
      zap
      select ARCINVUP
       zap
       select ARCINVS
       zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select ARCILINE
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select ARCINVS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofARCINVUP = .f.
        select ARCINVUP
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do ARCINVUP_rtn
          until eofARCINVUP = .t.
      endif
      eofARCILINE = .f.
       select ARCILINE
       go top
       if .not. eof()
          do 
             do ARCILINE_rtn
            until eofARCILINE
       endif
       
procedure ARCINVUP_rtn
   select ARCINVS
   seek ARCINVUP->order_no
   if .not. found()
      select ARCINVUP
      delete
  endif
  select ARCINVUP
  if .not. eof()
  skip
  endif
  if eof()
  eofARCINVUP = .t.
  
  endif
procedure ARCILINE_rtn
      select ARCINVS
      seek ARCILINE->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select ARCILINE
      delete
      endif
      select ARCILINE
      if .not. eof()
      skip
      endif
      if eof()
      eofARCILINE = .t.
      endif
    
         