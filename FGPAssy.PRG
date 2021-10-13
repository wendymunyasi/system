procedure fgpassy
create session
set talk off
set ldCheck off
set decimals to 4

set view to "fgpassy.QBE"
       set safety off
          select fgassy
         
      zap
      select fgassyUP
         zap
          
    
      set safety on
      
      close databases
         