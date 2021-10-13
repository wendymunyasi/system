procedure ARPCRNTS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "ARPCRNTS.QBE"
      do initial_rtn
      set safety off
      select ARCRNLNE
      go top
      if eof()
      zap
      select ARCRNUPD
       zap
       SELECT ARCRNTS
       ZAP
      endif
      set safety on
      
      close databases
procedure initial_rtn
        select ARCRNLNE
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to order_no      
           select ARCRNTS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofARCRNUPD = .f.
        select ARCRNUPD
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do ARCRNUPD_rtn
          until eofARCRNUPD = .t.
      endif
      eofARCRNLNE = .f.
       select ARCRNLNE
       go top
       if .not. eof()
          do 
             do ARCRNLNE_rtn
            until eofARCRNLNE
       endif
       
procedure ARCRNUPD_rtn
   select ARCRNTS
   seek ARCRNUPD->order_no
   if .not. found()
      select ARCRNUPD
      delete
  endif
  select ARCRNUPD
  if .not. eof()
  skip
  endif
  if eof()
  eofARCRNUPD = .t.
  
  endif
procedure ARCRNLNE_rtn
      select ARCRNTS
      seek ARCRNLNE->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select ARCRNLNE
      delete
      endif
      select ARCRNLNE
      if .not. eof()
      skip
      endif
      if eof()
      eofARCRNLNE = .t.
      endif
    
         