procedure FGP13
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGP13.QBE"
      do initial_rtn
      set safety off
      select TODRLINE
      go top
      if eof()
      zap
      select TODUPD
      ZAP
      SELECT TORDERS
      ZAP
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select TODRLINE
         delete all for .not. empty(POST_date) .OR. EMPTY(ORDER_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. QTY = 0 .or. ;
          empty(X_coy) .or. empty(X_div) .or. empty(X_cen) .or. empty(X_sto) 
         set order to order_no      
           select TORDERS
        set order to ORDER_NO
        delete all for empty(ORDER_NO)
        go bottom
        porder = ORDER_NO
        IF .NOT. EMPTY(ORDER_NO)
        delete all for .not. ORDER_NO = porder .and. .not. empty(POST_date) 
        endif
        eofTODUPD = .f.
        select TODUPD
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do TODUPD_rtn
          until eofTODUPD = .t.
      endif
      eofTODRLINE = .f.
       select TODRLINE
       go top
       if .not. eof()
          do 
             do TODRLINE_rtn
            until eofTODRLINE
       endif
       
procedure TODUPD_rtn
   select TORDERS
   seek TODUPD->order_no
   if .not. found()
      select TODUPD
      delete
  endif
  select TODUPD
  if .not. eof()
  skip
  endif
  if eof()
  eofTODUPD = .t.
  
  endif
procedure TODRLINE_rtn
      select TORDERS
      seek TODRLINE->order_no
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select TODRLINE
      delete
      endif
      select TODRLINE
      if .not. eof()
      skip
      endif
      if eof()
      eofTODRLINE = .t.
      endif
    
         