procedure FGPADJS
create session
set talk off
set ldCheck off
set decimals to 4

set view to "FGPADJS.QBE"
       set safety off
          select FGADJS
           zap
      select FGADJSUP
         zap
          
    
      set safety on
      
      close databases
         