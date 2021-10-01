procedure APPOGRNS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "APPOGRNS.QBE"
      do initial_rtn
      set safety off
      select apogrlin
      go top
      if eof()
      zap
      select apogrns
      zap
      select apogrnup
      zap
      endif
      select apojcads
      delete all for .not. empty(post_date)
      go top
      if eof()
      zap
      endif
      set safety on
      
      close databases
procedure initial_rtn
      
        select apogrlin
         delete all for .not. empty(POST_date) .OR. EMPTY(GRN_NO) .or. ;
          empty(coy) .or. empty(div) .or. empty(cen) .or. empty(sto) ;
           .or. empty(typ) .or. empty(cla) .or. empty(cod) .or. total = 0
         set order to GRN_NO      
           select APOGRNS
        set order to GRN_NO
        delete all for empty(GRN_NO)
        go bottom
        porder = GRN_NO
        IF .NOT. EMPTY(GRN_NO)
        delete all for .not. GRN_NO = porder .and. .not. empty(POST_date) 
        endif
        eofapogrnup = .f.
        select apogrnup
        delete all for .not. empty(post_date)
       go top
       if .not. eof()
          do
          do apogrnup_rtn
          until eofapogrnup = .t.
      endif
      eofapogrlin = .f.
       select apogrlin
       go top
       if .not. eof()
          do 
             do apogrlin_rtn
            until eofapogrlin
       endif
       
procedure apogrnup_rtn
   select APOGRNS
   seek apogrnup->GRN_NO
   if .not. found()
      select apogrnup
      delete
  endif
  select apogrnup
  if .not. eof()
  skip
  endif
  if eof()
  eofapogrnup = .t.
  
  endif
procedure apogrlin_rtn
      select APOGRNS
      seek apogrlin->GRN_NO
      if .not. found() .or. (found() .and. .not. empty(post_date))
      select apogrlin
      delete
      endif
      select apogrlin
      if .not. eof()
      skip
      endif
      if eof()
      eofapogrlin = .t.
      endif
    
         