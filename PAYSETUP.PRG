Procedure paysetup
* Visual dBASE .QBE file 9
*quit
PARAMETER BUSER,BLEVEL
PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
     use \kenserve\idssys\keninitp.dbf exclusive
    go top
     if plevel < 2 .and. day(ken_date) = 1 .and. month(ken_date) = month(date()) .and. ;
    year(ken_date) = year(date()) .and. .not. eof() .and. empty(ken_init) .and. empty(ken_user) 
    replace ken_init with date()
    replace ken_user with pluser
SET EXACT ON
SET EXCLUSIVE ON
set safety off
*quit
*CD \KENSERVICe\data

 use \kenserve\idssys\paysrecv.dbf
  copy stru to \kenservice\data\paysrecv dbase prod
 

If file("\kenservice\data\YTDEDRP.DB")
use \kenservice\data\YTDEDRP.DB
zap
endif

If file("\kenservice\data\YTDEDRP2.DB")
use \kenservice\data\YTDEDRP2.DB
zap
endif
if file("\kenservice\data\YTDEDRP3.DB")
use \kenservice\data\YTDEDRP3.DB
zap
endif
if file("\kenservice\data\YTDEDRP4.DB")
use \kenservice\data\YTDEDRP4.DB
zap
endif
if file("\kenservice\data\YTDEDRP5.DB")
use \kenservice\data\YTDEDRP5.DB
zap
endif
if file("\kenservice\data\YTDEDRP6.DB")
use \kenservice\data\YTDEDRP6.DB
zap
endif
if file("\kenservice\data\YTDEDRP7.DB")
use \kenservice\data\YTDEDRP7.DB
zap
endif
if file("\kenservice\data\YTDEDRP8.DB")
use \kenservice\data\YTDEDRP8.DB
zap
endif
if file("\kenservice\data\YTDEDRP9.DB")
use \kenservice\data\YTDEDRP9.DB
zap
endif


If file("\kenservice\data\ytdrept.DB")
use \kenservice\data\ytdrept.DB
zap
endif

If file("\kenservice\data\ytdrept2.DB")
use \kenservice\data\ytdrept2.DB
zap
endif
if file("\kenservice\data\ytdrept3.DB")
use \kenservice\data\ytdrept3.DB
zap
endif
if file("\kenservice\data\ytdrept4.DB")
use \kenservice\data\ytdrept4.DB
zap
endif
if file("\kenservice\data\ytdrept5.DB")
use \kenservice\data\ytdrept5.DB
zap
endif
if file("\kenservice\data\ytdrept6.DB")
use \kenservice\data\ytdrept6.DB
zap
endif
if file("\kenservice\data\ytdrept7.DB")
use \kenservice\data\ytdrept7.DB
zap
endif
if file("\kenservice\data\ytdrept8.DB")
use \kenservice\data\ytdrept8.DB
zap
endif
if file("\kenservice\data\ytdrept9.DB")
use \kenservice\data\ytdrept9.DB
zap
endif

If file("\kenservice\data\PYAUDIT.DB")
use \kenservice\data\PYAUDIT.DB
zap
endif

If file("\kenservice\data\PYAUDIT2.DB")
use \kenservice\data\PYAUDIT2.DB
zap
endif
if file("\kenservice\data\PYAUDIT3.DB")
use \kenservice\data\PYAUDIT3.DB
zap
endif
if file("\kenservice\data\PYAUDIT4.DB")
use \kenservice\data\PYAUDIT4.DB
zap
endif
if file("\kenservice\data\PYAUDIT5.DB")
use \kenservice\data\PYAUDIT5.DB
zap
endif
if file("\kenservice\data\PYAUDIT6.DB")
use \kenservice\data\PYAUDIT6.DB
zap
endif
if file("\kenservice\data\PYAUDIT7.DB")
use \kenservice\data\PYAUDIT7.DB
zap
endif
if file("\kenservice\data\PYAUDIT8.DB")
use \kenservice\data\PYAUDIT8.DB
zap
endif
if file("\kenservice\data\PYAUDIT9.DB")
use \kenservice\data\PYAUDIT9.DB
zap
endif

If file("\kenservice\data\lonmas22.DB")
use \kenservice\data\lonmas22.DB
zap
endif
if file("\kenservice\data\lonmas23.DB")
use \kenservice\data\lonmas23.DB
zap
endif
if file("\kenservice\data\lonmas24.DB")
use \kenservice\data\lonmas24.DB
zap
endif
if file("\kenservice\data\lonmas25.DB")
use \kenservice\data\lonmas25.DB
zap
endif
if file("\kenservice\data\lonmas26.DB")
use \kenservice\data\lonmas26.DB
zap
endif
if file("\kenservice\data\lonmas27.DB")
use \kenservice\data\lonmas27.DB
zap
endif
if file("\kenservice\data\lonmas28.DB")
use \kenservice\data\lonmas28.DB
zap
endif
if file("\kenservice\data\lonmas29.DB")
use \kenservice\data\lonmas29.DB
zap
endif
If file("\kenservice\data\lonmas12.DB")
use \kenservice\data\lonmas12.DB
zap
endif
if file("\kenservice\data\lonmas13.DB")
use \kenservice\data\lonmas13.DB
zap
endif
if file("\kenservice\data\lonmas14.DB")
use \kenservice\data\lonmas14.DB
zap
endif
if file("\kenservice\data\lonmas15.DB")
use \kenservice\data\lonmas15.DB
zap
endif
if file("\kenservice\data\lonmas16.DB")
use \kenservice\data\lonmas16.DB
zap
endif
if file("\kenservice\data\lonmas17.DB")
use \kenservice\data\lonmas17.DB
zap
endif
if file("\kenservice\data\lonmas18.DB")
use \kenservice\data\lonmas18.DB
zap
endif
if file("\kenservice\data\lonmas19.DB")
use \kenservice\data\lonmas19.DB
zap
endif
If file("\kenservice\data\edtmas22.DB")
use \kenservice\data\edtmas22.DB
zap
endif
if file("\kenservice\data\edtmas23.DB")
use \kenservice\data\edtmas23.DB
zap
endif
if file("\kenservice\data\edtmas24.DB")
use \kenservice\data\edtmas24.DB
zap
endif
if file("\kenservice\data\edtmas25.DB")
use \kenservice\data\edtmas25.DB
zap
endif
if file("\kenservice\data\edtmas26.DB")
use \kenservice\data\edtmas26.DB
zap
endif
if file("\kenservice\data\edtmas27.DB")
use \kenservice\data\edtmas27.DB
zap
endif
if file("\kenservice\data\edtmas28.DB")
use \kenservice\data\edtmas28.DB
zap
endif
if file("\kenservice\data\edtmas29.DB")
use \kenservice\data\edtmas29.DB
zap
endif
If file("\kenservice\data\edtmas12.DB")
use \kenservice\data\edtmas12.DB
zap
endif
if file("\kenservice\data\edtmas13.DB")
use \kenservice\data\edtmas13.DB
zap
endif
if file("\kenservice\data\edtmas14.DB")
use \kenservice\data\edtmas14.DB
zap
endif
if file("\kenservice\data\edtmas15.DB")
use \kenservice\data\edtmas15.DB
zap
endif
if file("\kenservice\data\edtmas16.DB")
use \kenservice\data\edtmas16.DB
zap
endif
if file("\kenservice\data\edtmas17.DB")
use \kenservice\data\edtmas17.DB
zap
endif
if file("\kenservice\data\edtmas18.DB")
use \kenservice\data\edtmas18.DB
zap
endif
if file("\kenservice\data\edtmas19.DB")
use \kenservice\data\edtmas19.DB
zap
endif
If file("\kenservice\data\pymas22.DB")
use \kenservice\data\pymas22.DB
zap
endif
if file("\kenservice\data\pymas23.DB")
use \kenservice\data\pymas23.DB
zap
endif
if file("\kenservice\data\pymas24.DB")
use \kenservice\data\pymas24.DB
zap
endif
if file("\kenservice\data\pymas25.DB")
use \kenservice\data\pymas25.DB
zap
endif
if file("\kenservice\data\pymas26.DB")
use \kenservice\data\pymas26.DB
zap
endif
if file("\kenservice\data\pymas27.DB")
use \kenservice\data\pymas27.DB
zap
endif
if file("\kenservice\data\pymas28.DB")
use \kenservice\data\pymas28.DB
zap
endif
if file("\kenservice\data\pymas29.DB")
use \kenservice\data\pymas29.DB
zap
endif
If file("\kenservice\data\pymas12.DB")
use \kenservice\data\pymas12.DB
zap
endif
if file("\kenservice\data\pymas13.DB")
use \kenservice\data\pymas13.DB
zap
endif
if file("\kenservice\data\pymas14.DB")
use \kenservice\data\pymas14.DB
zap
endif
if file("\kenservice\data\pymas15.DB")
use \kenservice\data\pymas15.DB
zap
endif
if file("\kenservice\data\pymas16.DB")
use \kenservice\data\pymas16.DB
zap
endif
if file("\kenservice\data\pymas17.DB")
use \kenservice\data\pymas17.DB
zap
endif
if file("\kenservice\data\pymas18.DB")
use \kenservice\data\pymas18.DB
zap
endif
if file("\kenservice\data\pymas19.DB")
use \kenservice\data\pymas19.DB
zap
endif
If file("\kenservice\data\py002.DB")
use \kenservice\data\py002.DB
zap
endif
if file("\kenservice\data\py003.DB")
use \kenservice\data\py003.DB
zap
endif
if file("\kenservice\data\py004.DB")
use \kenservice\data\py004.DB
zap
endif
if file("\kenservice\data\py005.DB")
use \kenservice\data\py005.DB
zap
endif
if file("\kenservice\data\py006.DB")
use \kenservice\data\py006.DB
zap
endif
if file("\kenservice\data\py007.DB")
use \kenservice\data\py007.DB
zap
endif
if file("\kenservice\data\py008.DB")
use \kenservice\data\py008.DB
zap
endif
if file("\kenservice\data\py009.DB")
use \kenservice\data\py009.DB
zap
endif
If file("\kenservice\data\LREPMAS2.DB")
use \kenservice\data\LREPMAS2.DB
zap
endif
if file("\kenservice\data\LREPMAS3.DB")
use \kenservice\data\LREPMAS3.DB
zap
endif
if file("\kenservice\data\LREPMAS4.DB")
use \kenservice\data\LREPMAS4.DB
zap
endif
if file("\kenservice\data\LREPMAS5.DB")
use \kenservice\data\LREPMAS5.DB
zap
endif
if file("\kenservice\data\LREPMAS6.DB")
use \kenservice\data\LREPMAS6.DB
zap
endif
if file("\kenservice\data\LREPMAS7.DB")
use \kenservice\data\LREPMAS7.DB
zap
endif
if file("\kenservice\data\LREPMAS8.DB")
use \kenservice\data\LREPMAS8.DB
zap
endif
if file("\kenservice\data\LREPMAS9.DB")
use \kenservice\data\LREPMAS9.DB
zap
endif
If file("\kenservice\data\PYMAST2.DB")
use \kenserve\idssys\pymast2.db
copy stru to  \kenservice\data\PYMAST2 para prod
endif
if file("\kenservice\data\PYMAST3.DB")
use \kenservice\data\PYMAST3.DB
zap
endif
if file("\kenservice\data\PYMAST4.DB")
use \kenservice\data\PYMAST4.DB
zap
endif
if file("\kenservice\data\PYMAST5.DB")
use \kenservice\data\PYMAST5.DB
zap
endif
if file("\kenservice\data\PYMAST6.DB")
use \kenservice\data\PYMAST6.DB
zap
endif
if file("\kenservice\data\PYMAST7.DB")
use \kenservice\data\PYMAST7.DB
zap
endif
if file("\kenservice\data\PYMAST8.DB")
use \kenservice\data\PYMAST8.DB
zap
endif
if file("\kenservice\data\PYMAST9.DB")
use \kenservice\data\PYMAST9.DB
zap
endif
If file("\kenservice\data\PYMASTS2.DBF")
use \kenservice\data\PYMASTS2.DBF
zap
endif
if file("\kenservice\data\PYMASTS3.DBF")
use \kenservice\data\PYMASTS3.DBF
zap
endif
if file("\kenservice\data\PYMASTS4.DBF")
use \kenservice\data\PYMASTS4.DBF
zap
endif
if file("\kenservice\data\PYMASTS5.DBF")
use \kenservice\data\PYMASTS5.DBF
zap
endif
if file("\kenservice\data\PYMASTS6.DBF")
use \kenservice\data\PYMASTS6.DBF
zap
endif
if file("\kenservice\data\PYMASTS7.DBF")
use \kenservice\data\PYMASTS7.DBF
zap
endif
if file("\kenservice\data\PYMASTS8.DBF")
use \kenservice\data\PYMASTS8.DBF
zap
endif
if file("\kenservice\data\PYMASTS9.DBF")
use \kenservice\data\PYMASTS9.DBF
zap
endif
If file("\kenservice\data\P9ATAX2.DBF")
use \kenservice\data\P9ATAX2.DBF
zap
endif
if file("\kenservice\data\P9ATAX3.DBF")
use \kenservice\data\P9ATAX3.DBF
zap
endif
if file("\kenservice\data\P9ATAX4.DBF")
use \kenservice\data\P9ATAX4.DBF
zap
endif
if file("\kenservice\data\P9ATAX5.DBF")
use \kenservice\data\P9ATAX5.DBF
zap
endif
if file("\kenservice\data\P9ATAX6.DBF")
use \kenservice\data\P9ATAX6.DBF
zap
endif
if file("\kenservice\data\P9ATAX7.DBF")
use \kenservice\data\P9ATAX7.DBF
zap
endif
if file("\kenservice\data\P9ATAX8.DBF")
use \kenservice\data\P9ATAX8.DBF
zap
endif
if file("\kenservice\data\P9ATAX9.DBF")
use \kenservice\data\P9ATAX9.DBF
zap
endif
if file("\kenservice\data\PYSTATE2.dbf")
use \kenservice\data\PYSTATE2.dbf
zap
endif
if file("\kenservice\data\PYSTATE3.dbf")
use \kenservice\data\PYSTATE3.dbf
zap
endif
if file("\kenservice\data\PYSTATE4.dbf")
use \kenservice\data\PYSTATE4.dbf
zap
endif
if file("\kenservice\data\PYSTATE5.dbf")
use \kenservice\data\PYSTATE5.dbf
zap
endif
if file("\kenservice\data\PYSTATE6.dbf")
use \kenservice\data\PYSTATE6.dbf
zap
endif
if file("\kenservice\data\PYSTATE7.dbf")
use \kenservice\data\PYSTATE7.dbf
zap
endif
if file("\kenservice\data\PYSTATE8.dbf")
use \kenservice\data\PYSTATE8.dbf
zap
endif
if file("\kenservice\data\PYSTATE9.dbf")
use \kenservice\data\PYSTATE9.dbf
zap
endif
If file("\kenservice\data\EDTMAST2.DB")
use \kenservice\data\EDTMAST2.DB
zap
endif
if file("\kenservice\data\EDTMAST3.DB")
use \kenservice\data\EDTMAST3.DB
zap
endif
if file("\kenservice\data\EDTMAST4.DB")
use \kenservice\data\EDTMAST4.DB
zap
endif
if file("\kenservice\data\EDTMAST5.DB")
use \kenservice\data\EDTMAST5.DB
zap
endif
if file("\kenservice\data\EDTMAST6.DB")
use \kenservice\data\EDTMAST6.DB
zap
endif
if file("\kenservice\data\EDTMAST7.DB")
use \kenservice\data\EDTMAST7.DB
zap
endif
if file("\kenservice\data\EDTMAST8.DB")
use \kenservice\data\EDTMAST8.DB
zap
endif
if file("\kenservice\data\EDTMAST9.DB")
use \kenservice\data\EDTMAST9.DB
zap
endif
If file("\kenservice\data\LOANMST2.DB")
use \kenservice\data\LOANMST2.DB
zap
endif
if file("\kenservice\data\LOANMST3.DB")
use \kenservice\data\LOANMST3.DB
zap
endif
if file("\kenservice\data\LOANMST4.DB")
use \kenservice\data\LOANMST4.DB
zap
endif
if file("\kenservice\data\LOANMST5.DB")
use \kenservice\data\LOANMST5.DB
zap
endif
if file("\kenservice\data\LOANMST6.DB")
use \kenservice\data\LOANMST6.DB
zap
endif
if file("\kenservice\data\LOANMST7.DB")
use \kenservice\data\LOANMST7.DB
zap
endif
if file("\kenservice\data\LOANMST8.DB")
use \kenservice\data\LOANMST8.DB
zap
endif
if file("\kenservice\data\LOANMST9.DB")
use \kenservice\data\LOANMST9.DB
zap
endif
If file("\kenservice\data\YTDMAS2.DB")
use \kenservice\data\YTDMAS2.DB
zap
endif
if file("\kenservice\data\YTDMAS3.DB")
use \kenservice\data\YTDMAS3.DB
zap
endif
if file("\kenservice\data\YTDMAS4.DB")
use \kenservice\data\YTDMAS4.DB
zap
endif
if file("\kenservice\data\YTDMAS5.DB")
use \kenservice\data\YTDMAS5.DB
zap
endif
if file("\kenservice\data\YTDMAS6.DB")
use \kenservice\data\YTDMAS6.DB
zap
endif
if file("\kenservice\data\YTDMAS7.DB")
use \kenservice\data\YTDMAS7.DB
zap
endif
if file("\kenservice\data\YTDMAS8.DB")
use \kenservice\data\YTDMAS8.DB
zap
endif
if file("\kenservice\data\YTDMAS9.DB")
use \kenservice\data\YTDMAS9.DB
zap
endif

If file("\kenservice\data\GRATMST2.DB")
use \kenservice\data\GRATMST2.DB
zap
endif
if file("\kenservice\data\GRATMST3.DB")
use \kenservice\data\GRATMST3.DB
zap
endif
if file("\kenservice\data\GRATMST4.DB")
use \kenservice\data\GRATMST4.DB
zap
endif
if file("\kenservice\data\GRATMST5.DB")
use \kenservice\data\GRATMST5.DB
zap
endif
if file("\kenservice\data\GRATMST6.DB")
use \kenservice\data\GRATMST6.DB
zap
endif
if file("\kenservice\data\GRATMST7.DB")
use \kenservice\data\GRATMST7.DB
zap
endif
if file("\kenservice\data\GRATMST8.DB")
use \kenservice\data\GRATMST8.DB
zap
endif
if file("\kenservice\data\GRATMST9.DB")
use \kenservice\data\GRATMST9.DB
zap
endif
If file("\kenservice\data\PYNAMES2.DB")
use \kenservice\data\PYNAMES2.DB
zap
endif
if file("\kenservice\data\PYNAMES3.DB")
use \kenservice\data\PYNAMES3.DB
zap
endif
if file("\kenservice\data\PYNAMES4.DB")
use \kenservice\data\PYNAMES4.DB
zap
endif
if file("\kenservice\data\PYNAMES5.DB")
use \kenservice\data\PYNAMES5.DB
zap
endif
if file("\kenservice\data\PYNAMES6.DB")
use \kenservice\data\PYNAMES6.DB
zap
endif
if file("\kenservice\data\PYNAMES7.DB")
use \kenservice\data\PYNAMES7.DB
zap
endif
if file("\kenservice\data\PYNAMES8.DB")
use \kenservice\data\PYNAMES8.DB
zap
endif
if file("\kenservice\data\PYNAMES9.DB")
use \kenservice\data\PYNAMES9.DB
zap
endif
If file("\kenservice\data\GRTMAS22.DB")
use \kenservice\data\GRTMAS22.DB
zap
endif
if file("\kenservice\data\GRTMAS23.DB")
use \kenservice\data\GRTMAS23.DB
zap
endif
if file("\kenservice\data\GRTMAS24.DB")
use \kenservice\data\GRTMAS24.DB
zap
endif
if file("\kenservice\data\GRTMAS25.DB")
use \kenservice\data\GRTMAS25.DB
zap
endif
if file("\kenservice\data\GRTMAS26.DB")
use \kenservice\data\GRTMAS26.DB
zap
endif
if file("\kenservice\data\GRTMAS27.DB")
use \kenservice\data\GRTMAS27.DB
zap
endif
if file("\kenservice\data\GRTMAS28.DB")
use \kenservice\data\GRTMAS28.DB
zap
endif
if file("\kenservice\data\GRTMAS29.DB")
use \kenservice\data\GRTMAS29.DB
zap
endif
If file("\kenservice\data\GRTMAS12.DB")
use \kenservice\data\GRTMAS12.DB
zap
endif
if file("\kenservice\data\GRTMAS13.DB")
use \kenservice\data\GRTMAS13.DB
zap
endif
if file("\kenservice\data\GRTMAS14.DB")
use \kenservice\data\GRTMAS14.DB
zap
endif
if file("\kenservice\data\GRTMAS15.DB")
use \kenservice\data\GRTMAS15.DB
zap
endif
if file("\kenservice\data\GRTMAS16.DB")
use \kenservice\data\GRTMAS16.DB
zap
endif
if file("\kenservice\data\GRTMAS17.DB")
use \kenservice\data\GRTMAS17.DB
zap
endif
if file("\kenservice\data\GRTMAS18.DB")
use \kenservice\data\GRTMAS18.DB
zap
endif
if file("\kenservice\data\GRTMAS19.DB")
use \kenservice\data\GRTMAS19.DB
zap
endif
If file("\kenservice\data\YTDGRAT2.DB")
use \kenservice\data\YTDGRAT2.DB
zap
endif
if file("\kenservice\data\YTDGRAT3.DB")
use \kenservice\data\YTDGRAT3.DB
zap
endif
if file("\kenservice\data\YTDGRAT4.DB")
use \kenservice\data\YTDGRAT4.DB
zap
endif
if file("\kenservice\data\YTDGRAT5.DB")
use \kenservice\data\YTDGRAT5.DB
zap
endif
if file("\kenservice\data\YTDGRAT6.DB")
use \kenservice\data\YTDGRAT6.DB
zap
endif
if file("\kenservice\data\YTDGRAT7.DB")
use \kenservice\data\YTDGRAT7.DB
zap
endif
if file("\kenservice\data\YTDGRAT8.DB")
use \kenservice\data\YTDGRAT8.DB
zap
endif
if file("\kenservice\data\YTDGRAT9.DB")
use \kenservice\data\YTDGRAT9.DB
zap
endif
If file("\kenservice\data\REFUND2.DB")
use \kenservice\data\REFUND2.DB
zap
endif
if file("\kenservice\data\REFUND3.DB")
use \kenservice\data\REFUND3.DB
zap
endif
if file("\kenservice\data\REFUND4.DB")
use \kenservice\data\REFUND4.DB
zap
endif
if file("\kenservice\data\REFUND5.DB")
use \kenservice\data\REFUND5.DB
zap
endif
if file("\kenservice\data\REFUND6.DB")
use \kenservice\data\REFUND6.DB
zap
endif
if file("\kenservice\data\REFUND7.DB")
use \kenservice\data\REFUND7.DB
zap
endif
if file("\kenservice\data\REFUND8.DB")
use \kenservice\data\REFUND8.DB
zap
endif
if file("\kenservice\data\REFUND9.DB")
use \kenservice\data\REFUND9.DB
zap
endif

If file("\kenservice\data\GRATREP2.DB")
use \kenservice\data\GRATREP2.DB
zap
endif
if file("\kenservice\data\GRATREP3.DB")
use \kenservice\data\GRATREP3.DB
zap
endif
if file("\kenservice\data\GRATREP4.DB")
use \kenservice\data\GRATREP4.DB
zap
endif
if file("\kenservice\data\GRATREP5.DB")
use \kenservice\data\GRATREP5.DB
zap
endif
if file("\kenservice\data\GRATREP6.DB")
use \kenservice\data\GRATREP6.DB
zap
endif
if file("\kenservice\data\GRATREP7.DB")
use \kenservice\data\GRATREP7.DB
zap
endif
if file("\kenservice\data\GRATREP8.DB")
use \kenservice\data\GRATREP8.DB
zap
endif
if file("\kenservice\data\GRATREP9.DB")
use \kenservice\data\GRATREP9.DB
zap
endif
If file("\kenservice\data\LOANREP2.DB")
use \kenservice\data\LOANREP2.DB
zap
endif
if file("\kenservice\data\LOANREP3.DB")
use \kenservice\data\LOANREP3.DB
zap
endif
if file("\kenservice\data\LOANREP4.DB")
use \kenservice\data\LOANREP4.DB
zap
endif
if file("\kenservice\data\LOANREP5.DB")
use \kenservice\data\LOANREP5.DB
zap
endif
if file("\kenservice\data\LOANREP6.DB")
use \kenservice\data\LOANREP6.DB
zap
endif
if file("\kenservice\data\LOANREP7.DB")
use \kenservice\data\LOANREP7.DB
zap
endif
if file("\kenservice\data\LOANREP8.DB")
use \kenservice\data\LOANREP8.DB
zap
endif
if file("\kenservice\data\LOANREP9.DB")
use \kenservice\data\LOANREP9.DB
zap
endif
If file("\kenservice\data\EDTREP2.DB")
use \kenservice\data\EDTREP2.DB
zap
endif
if file("\kenservice\data\EDTREP3.DB")
use \kenservice\data\EDTREP3.DB
zap
endif
if file("\kenservice\data\EDTREP4.DB")
use \kenservice\data\EDTREP4.DB
zap
endif
if file("\kenservice\data\EDTREP5.DB")
use \kenservice\data\EDTREP5.DB
zap
endif
if file("\kenservice\data\EDTREP6.DB")
use \kenservice\data\EDTREP6.DB
zap
endif
if file("\kenservice\data\EDTREP7.DB")
use \kenservice\data\EDTREP7.DB
zap
endif
if file("\kenservice\data\EDTREP8.DB")
use \kenservice\data\EDTREP8.DB
zap
endif
if file("\kenservice\data\EDTREP9.DB")
use \kenservice\data\EDTREP9.DB
zap
endif
If file("\kenservice\data\YTDMAS22.DB")
use \kenservice\data\YTDMAS22.DB
zap
endif
if file("\kenservice\data\YTDMAS23.DB")
use \kenservice\data\YTDMAS23.DB
zap
endif
if file("\kenservice\data\YTDMAS24.DB")
use \kenservice\data\YTDMAS24.DB
zap
endif
if file("\kenservice\data\YTDMAS25.DB")
use \kenservice\data\YTDMAS25.DB
zap
endif
if file("\kenservice\data\YTDMAS26.DB")
use \kenservice\data\YTDMAS26.DB
zap
endif
if file("\kenservice\data\YTDMAS27.DB")
use \kenservice\data\YTDMAS27.DB
zap
endif
if file("\kenservice\data\YTDMAS28.DB")
use \kenservice\data\YTDMAS28.DB
zap
endif
if file("\kenservice\data\YTDMAS29.DB")
use \kenservice\data\YTDMAS29.DB
zap
endif


If file("\kenservice\data\YTDMAS12.DB")
use \kenservice\data\YTDMAS12.DB
zap
endif
if file("\kenservice\data\YTDMAS13.DB")
use \kenservice\data\YTDMAS13.DB
zap
endif
if file("\kenservice\data\YTDMAS14.DB")
use \kenservice\data\YTDMAS14.DB
zap
endif
if file("\kenservice\data\YTDMAS15.DB")
use \kenservice\data\YTDMAS15.DB
zap
endif
if file("\kenservice\data\YTDMAS16.DB")
use \kenservice\data\YTDMAS16.DB
zap
endif
if file("\kenservice\data\YTDMAS17.DB")
use \kenservice\data\YTDMAS17.DB
zap
endif
if file("\kenservice\data\YTDMAS18.DB")
use \kenservice\data\YTDMAS18.DB
zap
endif
if file("\kenservice\data\YTDMAS19.DB")
use \kenservice\data\YTDMAS19.DB
zap
endif
If file("\kenservice\data\pyrmas12.DB")
use \kenservice\data\pyrmas12.DB
zap
endif
if file("\kenservice\data\pyrmas13.DB")
use \kenservice\data\pyrmas13.DB
zap
endif
if file("\kenservice\data\pyrmas14.DB")
use \kenservice\data\pyrmas14.DB
zap
endif
if file("\kenservice\data\pyrmas15.DB")
use \kenservice\data\pyrmas15.DB
zap
endif
if file("\kenservice\data\pyrmas16.DB")
use \kenservice\data\pyrmas16.DB
zap
endif
if file("\kenservice\data\pyrmas17.DB")
use \kenservice\data\pyrmas17.DB
zap
endif
if file("\kenservice\data\pyrmas18.DB")
use \kenservice\data\pyrmas18.DB
zap
endif
if file("\kenservice\data\pyrmas19.DB")
use \kenservice\data\pyrmas19.DB
zap
endif
If file("\kenservice\data\pyrmas22.DB")
use \kenservice\data\pyrmas22.DB
zap
endif
if file("\kenservice\data\pyrmas23.DB")
use \kenservice\data\pyrmas23.DB
zap
endif
if file("\kenservice\data\pyrmas24.DB")
use \kenservice\data\pyrmas24.DB
zap
endif
if file("\kenservice\data\pyrmas25.DB")
use \kenservice\data\pyrmas25.DB
zap
endif
if file("\kenservice\data\pyrmas26.DB")
use \kenservice\data\pyrmas26.DB
zap
endif
if file("\kenservice\data\pyrmas27.DB")
use \kenservice\data\pyrmas27.DB
zap
endif
if file("\kenservice\data\pyrmas28.DB")
use \kenservice\data\pyrmas28.DB
zap
endif
if file("\kenservice\data\pyrmas29.DB")
use \kenservice\data\pyrmas29.DB
zap
endif
If file("\kenservice\data\P9ATAX2.DB")
use \kenservice\data\P9ATAX2.DB
zap
endif
if file("\kenservice\data\P9ATAX3.DB")
use \kenservice\data\P9ATAX3.DB
zap
endif
if file("\kenservice\data\P9ATAX4.DB")
use \kenservice\data\P9ATAX4.DB
zap
endif
if file("\kenservice\data\P9ATAX5.DB")
use \kenservice\data\P9ATAX5.DB
zap
endif
if file("\kenservice\data\P9ATAX6.DB")
use \kenservice\data\P9ATAX6.DB
zap
endif
if file("\kenservice\data\P9ATAX7.DB")
use \kenservice\data\P9ATAX7.DB
zap
endif
if file("\kenservice\data\P9ATAX8.DB")
use \kenservice\data\P9ATAX8.DB
zap
endif
if file("\kenservice\data\P9ATAX9.DB")
use \kenservice\data\P9ATAX9.DB
zap
endif

If file("\kenservice\data\YTDREP2.DB")
use \kenservice\data\YTDREP2.DB
zap
endif
if file("\kenservice\data\YTDREP3.DB")
use \kenservice\data\YTDREP3.DB
zap
endif
if file("\kenservice\data\YTDREP4.DB")
use \kenservice\data\YTDREP4.DB
zap
endif
if file("\kenservice\data\YTDREP5.DB")
use \kenservice\data\YTDREP5.DB
zap
endif
if file("\kenservice\data\YTDREP6.DB")
use \kenservice\data\YTDREP6.DB
zap
endif
if file("\kenservice\data\YTDREP7.DB")
use \kenservice\data\YTDREP7.DB
zap
endif
if file("\kenservice\data\YTDREP8.DB")
use \kenservice\data\YTDREP8.DB
zap
endif
if file("\kenservice\data\YTDREP9.DB")
use \kenservice\data\YTDREP9.DB
zap
endif

If file("\kenservice\data\PYREPOT2.DB")
use \kenservice\data\PYREPOT2.DB
zap
endif
if file("\kenservice\data\PYREPOT3.DB")
use \kenservice\data\PYREPOT3.DB
zap
endif
if file("\kenservice\data\PYREPOT4.DB")
use \kenservice\data\PYREPOT4.DB
zap
endif
if file("\kenservice\data\PYREPOT5.DB")
use \kenservice\data\PYREPOT5.DB
zap
endif
if file("\kenservice\data\PYREPOT6.DB")
use \kenservice\data\PYREPOT6.DB
zap
endif
if file("\kenservice\data\PYREPOT7.DB")
use \kenservice\data\PYREPOT7.DB
zap
endif
if file("\kenservice\data\PYREPOT8.DB")
use \kenservice\data\PYREPOT8.DB
zap
endif
if file("\kenservice\data\PYREPOT9.DB")
use \kenservice\data\PYREPOT9.DB
zap
endif
If file("\kenservice\data\LONTAB12.DB")
use \kenservice\data\LONTAB12.DB
zap
endif
if file("\kenservice\data\LONTAB13.DB")
use \kenservice\data\LONTAB13.DB
zap
endif
if file("\kenservice\data\LONTAB14.DB")
use \kenservice\data\LONTAB14.DB
zap
endif
if file("\kenservice\data\LONTAB15.DB")
use \kenservice\data\LONTAB15.DB
zap
endif
if file("\kenservice\data\LONTAB16.DB")
use \kenservice\data\LONTAB16.DB
zap
endif
if file("\kenservice\data\LONTAB17.DB")
use \kenservice\data\LONTAB17.DB
zap
endif
if file("\kenservice\data\LONTAB18.DB")
use \kenservice\data\LONTAB18.DB
zap
endif
if file("\kenservice\data\LONTAB19.DB")
use \kenservice\data\LONTAB19.DB
zap
endif
If file("\kenservice\data\LONTAB22.DB")
use \kenservice\data\LONTAB22.DB
zap
endif
if file("\kenservice\data\LONTAB23.DB")
use \kenservice\data\LONTAB23.DB
zap
endif
if file("\kenservice\data\LONTAB24.DB")
use \kenservice\data\LONTAB24.DB
zap
endif
if file("\kenservice\data\LONTAB25.DB")
use \kenservice\data\LONTAB25.DB
zap
endif
if file("\kenservice\data\LONTAB26.DB")
use \kenservice\data\LONTAB26.DB
zap
endif
if file("\kenservice\data\LONTAB27.DB")
use \kenservice\data\LONTAB27.DB
zap
endif
if file("\kenservice\data\LONTAB28.DB")
use \kenservice\data\LONTAB28.DB
zap
endif
if file("\kenservice\data\LONTAB29.DB")
use \kenservice\data\LONTAB29.DB
zap
endif
If file("\kenservice\data\EDTABL12.DB")
use \kenservice\data\EDTABL12.DB
zap
endif
if file("\kenservice\data\EDTABL13.DB")
use \kenservice\data\EDTABL13.DB
zap
endif
if file("\kenservice\data\EDTABL14.DB")
use \kenservice\data\EDTABL14.DB
zap
endif
if file("\kenservice\data\EDTABL15.DB")
use \kenservice\data\EDTABL15.DB
zap
endif
if file("\kenservice\data\EDTABL16.DB")
use \kenservice\data\EDTABL16.DB
zap
endif
if file("\kenservice\data\EDTABL17.DB")
use \kenservice\data\EDTABL17.DB
zap
endif
if file("\kenservice\data\EDTABL18.DB")
use \kenservice\data\EDTABL18.DB
zap
endif
if file("\kenservice\data\EDTABL19.DB")
use \kenservice\data\EDTABL19.DB
zap
endif
If file("\kenservice\data\EDTABL22.DB")
use \kenservice\data\EDTABL22.DB
zap
endif
if file("\kenservice\data\EDTABL23.DB")
use \kenservice\data\EDTABL23.DB
zap
endif
if file("\kenservice\data\EDTABL24.DB")
use \kenservice\data\EDTABL24.DB
zap
endif
if file("\kenservice\data\EDTABL25.DB")
use \kenservice\data\EDTABL25.DB
zap
endif
if file("\kenservice\data\EDTABL26.DB")
use \kenservice\data\EDTABL26.DB
zap
endif
if file("\kenservice\data\EDTABL27.DB")
use \kenservice\data\EDTABL27.DB
zap
endif
if file("\kenservice\data\EDTABL28.DB")
use \kenservice\data\EDTABL28.DB
zap
endif
if file("\kenservice\data\EDTABL29.DB")
use \kenservice\data\EDTABL29.DB
zap
endif

If file("\kenservice\data\PAYROL22.DB")
use \kenservice\data\PAYROL22.DB
zap
endif
if file("\kenservice\data\PAYROL23.DB")
use \kenservice\data\PAYROL23.DB
zap
endif
if file("\kenservice\data\PAYROL24.DB")
use \kenservice\data\PAYROL24.DB
zap
endif
if file("\kenservice\data\PAYROL25.DB")
use \kenservice\data\PAYROL25.DB
zap
endif
if file("\kenservice\data\PAYROL26.DB")
use \kenservice\data\PAYROL26.DB
zap
endif
if file("\kenservice\data\PAYROL27.DB")
use \kenservice\data\PAYROL27.DB
zap
endif
if file("\kenservice\data\PAYROL28.DB")
use \kenservice\data\PAYROL28.DB
zap
endif
if file("\kenservice\data\PAYROL29.DB")
use \kenservice\data\PAYROL29.DB
zap
endif

If file("\kenservice\data\PAYROL12.DB")
use \kenservice\data\PAYROL12.DB
zap
endif
if file("\kenservice\data\PAYROL13.DB")
use \kenservice\data\PAYROL13.DB
zap
endif
if file("\kenservice\data\PAYROL14.DB")
use \kenservice\data\PAYROL14.DB
zap
endif
if file("\kenservice\data\PAYROL15.DB")
use \kenservice\data\PAYROL15.DB
zap
endif
if file("\kenservice\data\PAYROL16.DB")
use \kenservice\data\PAYROL16.DB
zap
endif
if file("\kenservice\data\PAYROL17.DB")
use \kenservice\data\PAYROL17.DB
zap
endif
if file("\kenservice\data\PAYROL18.DB")
use \kenservice\data\PAYROL18.DB
zap
endif
if file("\kenservice\data\PAYROL19.DB")
use \kenservice\data\PAYROL19.DB
zap
endif

if file("\kenservice\data\DDE09D2.DB")
use \kenservice\data\DDE09D2.DB
zap
endif
if file("\kenservice\data\DDE09D3.DB")
use \kenservice\data\DDE09D3.DB
zap
endif
if file("\kenservice\data\DDE09D4.DB")
use \kenservice\data\DDE09D4.DB
zap
endif
if file("\kenservice\data\DDE09D5.DB")
use \kenservice\data\DDE09D5.DB
zap
endif
if file("\kenservice\data\DDE09D6.DB")
use \kenservice\data\DDE09D6.DB
zap
endif
if file("\kenservice\data\DDE09D7.DB")
use \kenservice\data\DDE09D7.DB
zap
endif
if file("\kenservice\data\DDE09D8.DB")
use \kenservice\data\DDE09D8.DB
zap
endif
if file("\kenservice\data\DDE09D9.DB")
use \kenservice\data\DDE09D9.DB
zap
endif
if file("\kenservice\data\DDE08D2.DB")
use \kenservice\data\DDE08D2.DB
zap
endif
if file("\kenservice\data\DDE08D3.DB")
use \kenservice\data\DDE08D3.DB
zap
endif
if file("\kenservice\data\DDE08D4.DB")
use \kenservice\data\DDE08D4.DB
zap
endif
if file("\kenservice\data\DDE08D5.DB")
use \kenservice\data\DDE08D5.DB
zap
endif
if file("\kenservice\data\DDE08D6.DB")
use \kenservice\data\DDE08D6.DB
zap
endif
if file("\kenservice\data\DDE08D7.DB")
use \kenservice\data\DDE08D7.DB
zap
endif
if file("\kenservice\data\DDE08D8.DB")
use \kenservice\data\DDE08D8.DB
zap
endif
if file("\kenservice\data\DDE08D9.DB")
use \kenservice\data\DDE08D9.DB
zap
endif
if file("\kenservice\data\DDE07D2.DB")
use \kenservice\data\DDE07D2.DB
zap
endif
if file("\kenservice\data\DDE07D3.DB")
use \kenservice\data\DDE07D3.DB
zap
endif
if file("\kenservice\data\DDE07D4.DB")
use \kenservice\data\DDE07D4.DB
zap
endif
if file("\kenservice\data\DDE07D5.DB")
use \kenservice\data\DDE07D5.DB
zap
endif
if file("\kenservice\data\DDE07D6.DB")
use \kenservice\data\DDE07D6.DB
zap
endif
if file("\kenservice\data\DDE07D7.DB")
use \kenservice\data\DDE07D7.DB
zap
endif
if file("\kenservice\data\DDE07D8.DB")
use \kenservice\data\DDE07D8.DB
zap
endif
if file("\kenservice\data\DDE07D9.DB")
use \kenservice\data\DDE07D9.DB
zap
endif

if file("\kenservice\data\DDE06D2.DB")
use \kenservice\data\DDE06D2.DB
zap
endif
if file("\kenservice\data\DDE06D3.DB")
use \kenservice\data\DDE06D3.DB
zap
endif
if file("\kenservice\data\DDE06D4.DB")
use \kenservice\data\DDE06D4.DB
zap
endif
if file("\kenservice\data\DDE06D5.DB")
use \kenservice\data\DDE06D5.DB
zap
endif
if file("\kenservice\data\DDE06D6.DB")
use \kenservice\data\DDE06D6.DB
zap
endif
if file("\kenservice\data\DDE06D7.DB")
use \kenservice\data\DDE06D7.DB
zap
endif
if file("\kenservice\data\DDE06D8.DB")
use \kenservice\data\DDE06D8.DB
zap
endif
if file("\kenservice\data\DDE06D9.DB")
use \kenservice\data\DDE06D9.DB
zap
endif
if file("\kenservice\data\DDE05D2.DB")
use \kenservice\data\DDE05D2.DB
zap
endif
if file("\kenservice\data\DDE05D3.DB")
use \kenservice\data\DDE05D3.DB
zap
endif
if file("\kenservice\data\DDE05D4.DB")
use \kenservice\data\DDE05D4.DB
zap
endif
if file("\kenservice\data\DDE05D5.DB")
use \kenservice\data\DDE05D5.DB
zap
endif
if file("\kenservice\data\DDE05D6.DB")
use \kenservice\data\DDE05D6.DB
zap
endif
if file("\kenservice\data\DDE05D7.DB")
use \kenservice\data\DDE05D7.DB
zap
endif
if file("\kenservice\data\DDE05D8.DB")
use \kenservice\data\DDE05D8.DB
zap
endif
if file("\kenservice\data\DDE05D9.DB")
use \kenservice\data\DDE05D9.DB
zap
endif
if file("\kenservice\data\DDE03D2.DB")
use \kenservice\data\DDE03D2.DB
zap
endif
if file("\kenservice\data\DDE03D3.DB")
use \kenservice\data\DDE03D3.DB
zap
endif
if file("\kenservice\data\DDE03D4.DB")
use \kenservice\data\DDE03D4.DB
zap
endif
if file("\kenservice\data\DDE03D5.DB")
use \kenservice\data\DDE03D5.DB
zap
endif
if file("\kenservice\data\DDE03D6.DB")
use \kenservice\data\DDE03D6.DB
zap
endif
if file("\kenservice\data\DDE03D7.DB")
use \kenservice\data\DDE03D7.DB
zap
endif
if file("\kenservice\data\DDE03D8.DB")
use \kenservice\data\DDE03D8.DB
zap
endif
if file("\kenservice\data\DDE03D9.DB")
use \kenservice\data\DDE03D9.DB
zap
endif
if file("\kenservice\data\DDE02D2.DB")
use \kenservice\data\DDE02D2.DB
zap
endif
if file("\kenservice\data\DDE02D3.DB")
use \kenservice\data\DDE02D3.DB
zap
endif
if file("\kenservice\data\DDE02D4.DB")
use \kenservice\data\DDE02D4.DB
zap
endif
if file("\kenservice\data\DDE02D5.DB")
use \kenservice\data\DDE02D5.DB
zap
endif
if file("\kenservice\data\DDE02D6.DB")
use \kenservice\data\DDE02D6.DB
zap
endif
if file("\kenservice\data\DDE02D7.DB")
use \kenservice\data\DDE02D7.DB
zap
endif
if file("\kenservice\data\DDE02D8.DB")
use \kenservice\data\DDE02D8.DB
zap
endif
if file("\kenservice\data\DDE02D9.DB")
use \kenservice\data\DDE02D9.DB
zap
endif

if file("\kenservice\data\PAYDATA2.DB")
use \kenservice\data\PAYDATA2.DB
zap
endif
if file("\kenservice\data\PAYDATA3.DB")
use \kenservice\data\PAYDATA3.DB
zap
endif
if file("\kenservice\data\PAYDATA4.DB")
use \kenservice\data\PAYDATA4.DB
zap
endif
if file("\kenservice\data\PAYDATA5.DB")
use \kenservice\data\PAYDATA5.DB
zap
endif
if file("\kenservice\data\PAYDATA6.DB")
use \kenservice\data\PAYDATA6.DB
zap
endif
if file("\kenservice\data\PAYDATA7.DB")
use \kenservice\data\PAYDATA7.DB
zap
endif
if file("\kenservice\data\PAYDATA8.DB")
use \kenservice\data\PAYDATA8.DB
zap
endif
if file("\kenservice\data\PAYDATA9.DB")
use \kenservice\data\PAYDATA9.DB
zap
endif


if file("\kenservice\data\DDERUNS2.DB")
use \kenservice\data\DDERUNS2.DB
zap
endif
if file("\kenservice\data\DDERUNS3.DB")
use \kenservice\data\DDERUNS3.DB
zap
endif
if file("\kenservice\data\DDERUNS4.DB")
use \kenservice\data\DDERUNS4.DB
zap
endif
if file("\kenservice\data\DDERUNS5.DB")
use \kenservice\data\DDERUNS5.DB
zap
endif
if file("\kenservice\data\DDERUNS6.DB")
use \kenservice\data\DDERUNS6.DB
zap
endif
if file("\kenservice\data\DDERUNS7.DB")
use \kenservice\data\DDERUNS7.DB
zap
endif
if file("\kenservice\data\DDERUNS8.DB")
use \kenservice\data\DDERUNS8.DB
zap
endif
if file("\kenservice\data\DDERUNS9.DB")
use \kenservice\data\DDERUNS9.DB
zap
endif

if file("\kenservice\data\DDE03T2.DB")
use \kenservice\data\DDE03T2.DB
zap
endif
if file("\kenservice\data\DDE03T3.DB")
use \kenservice\data\DDE03T3.DB
zap
endif
if file("\kenservice\data\DDE03T4.DB")
use \kenservice\data\DDE03T4.DB
zap
endif
if file("\kenservice\data\DDE03T5.DB")
use \kenservice\data\DDE03T5.DB
zap
endif
if file("\kenservice\data\DDE03T6.DB")
use \kenservice\data\DDE03T6.DB
zap
endif
if file("\kenservice\data\DDE03T7.DB")
use \kenservice\data\DDE03T7.DB
zap
endif
if file("\kenservice\data\DDE03T8.DB")
use \kenservice\data\DDE03T8.DB
zap
endif
if file("\kenservice\data\DDE03T9.DB")
use \kenservice\data\DDE03T9.DB
zap
endif

if file("\kenservice\data\DDE04D2.DB")
use \kenservice\data\DDE04D2.DB
zap
endif
if file("\kenservice\data\DDE04D3.DB")
use \kenservice\data\DDE04D3.DB
zap
endif
if file("\kenservice\data\DDE04D4.DB")
use \kenservice\data\DDE04D4.DB
zap
endif
if file("\kenservice\data\DDE04D5.DB")
use \kenservice\data\DDE04D5.DB
zap
endif
if file("\kenservice\data\DDE04D6.DB")
use \kenservice\data\DDE04D6.DB
zap
endif
if file("\kenservice\data\DDE04D7.DB")
use \kenservice\data\DDE04D7.DB
zap
endif
if file("\kenservice\data\DDE04D8.DB")
use \kenservice\data\DDE04D8.DB
zap
endif
if file("\kenservice\data\DDE04D9.DB")
use \kenservice\data\DDE04D9.DB
zap
endif
if file("\kenservice\data\EDTMAS2.DB")
use \kenservice\data\EDTMAS2.DB
zap
endif
if file("\kenservice\data\EDTMAS3.DB")
use \kenservice\data\EDTMAS3.DB
zap
endif
if file("\kenservice\data\EDTMAS4.DB")
use \kenservice\data\EDTMAS4.DB
zap
endif
if file("\kenservice\data\EDTMAS5.DB")
use \kenservice\data\EDTMAS5.DB
zap
endif
if file("\kenservice\data\EDTMAS6.DB")
use \kenservice\data\EDTMAS6.DB
zap
endif
if file("\kenservice\data\EDTMAS7.DB")
use \kenservice\data\EDTMAS7.DB
zap
endif
if file("\kenservice\data\EDTMAS8.DB")
use \kenservice\data\EDTMAS8.DB
zap
endif
if file("\kenservice\data\EDTMAS9.DB")
use \kenservice\data\EDTMAS9.DB
zap
endif

if file("\kenservice\data\EDEDMAS2.DB")
use \kenservice\data\EDEDMAS2.DB
zap
endif
if file("\kenservice\data\EDEDMAS3.DB")
use \kenservice\data\EDEDMAS3.DB
zap
endif
if file("\kenservice\data\EDEDMAS4.DB")
use \kenservice\data\EDEDMAS4.DB
zap
endif
if file("\kenservice\data\EDEDMAS5.DB")
use \kenservice\data\EDEDMAS5.DB
zap
endif
if file("\kenservice\data\EDEDMAS6.DB")
use \kenservice\data\EDEDMAS6.DB
zap
endif
if file("\kenservice\data\EDEDMAS7.DB")
use \kenservice\data\EDEDMAS7.DB
zap
endif
if file("\kenservice\data\EDEDMAS8.DB")
use \kenservice\data\EDEDMAS8.DB
zap
endif
if file("\kenservice\data\EDEDMAS9.DB")
use \kenservice\data\EDEDMAS9.DB
zap
endif

if file("\kenservice\data\PYMAST2.DB")
use \kenservice\data\PYMAST2.DB
zap
endif
if file("\kenservice\data\PYMAST3.DB")
use \kenservice\data\PYMAST3.DB
zap
endif
if file("\kenservice\data\PYMAST4.DB")
use \kenservice\data\PYMAST4.DB
zap
endif
if file("\kenservice\data\PYMAST5.DB")
use \kenservice\data\PYMAST5.DB
zap
endif
if file("\kenservice\data\PYMAST6.DB")
use \kenservice\data\PYMAST6.DB
zap
endif
if file("\kenservice\data\PYMAST7.DB")
use \kenservice\data\PYMAST7.DB
zap
endif
if file("\kenservice\data\PYMAST8.DB")
use \kenservice\data\PYMAST8.DB
zap
endif
if file("\kenservice\data\PYMAST9.DB")
use \kenservice\data\PYMAST9.DB
zap
endif

if file("\kenservice\data\PYMASTS2.dbf")
use \kenservice\data\PYMASTS2.dbf
zap
endif
if file("\kenservice\data\PYMASTS3.dbf")
use \kenservice\data\PYMASTS3.dbf
zap
endif
if file("\kenservice\data\PYMASTS4.dbf")
use \kenservice\data\PYMASTS4.dbf
zap
endif
if file("\kenservice\data\PYMASTS5.dbf")
use \kenservice\data\PYMASTS5.dbf
zap
endif
if file("\kenservice\data\PYMASTS6.dbf")
use \kenservice\data\PYMASTS6.dbf
zap
endif
if file("\kenservice\data\PYMASTS7.dbf")
use \kenservice\data\PYMASTS7.dbf
zap
endif
if file("\kenservice\data\PYMASTS8.dbf")
use \kenservice\data\PYMASTS8.dbf
zap
endif
if file("\kenservice\data\PYMASTS9.dbf")
use \kenservice\data\PYMASTS9.dbf
zap
endif
if file("\kenservice\data\dde01d2.dbf")
use \kenservice\data\dde01d2.dbf
zap
endif
if file("\kenservice\data\dde01d3.dbf")
use \kenservice\data\dde01d3.dbf
zap
endif
if file("\kenservice\data\dde01d4.dbf")
use \kenservice\data\dde01d4.dbf
zap
endif
if file("\kenservice\data\dde01d5.dbf")
use \kenservice\data\dde01d5.dbf
zap
endif
if file("\kenservice\data\dde01d6.dbf")
use \kenservice\data\dde01d6.dbf
zap
endif
if file("\kenservice\data\dde01d7.dbf")
use \kenservice\data\dde01d7.dbf
zap
endif
if file("\kenservice\data\dde01d8.dbf")
use \kenservice\data\dde01d8.dbf
zap
endif
if file("\kenservice\data\dde01d9.dbf")
use \kenservice\data\dde01d9.dbf
zap
endif
USE \KENSERVE\IDSSYS\YEARS.DB
COPY STRU TO \KENSERVICE\DATA\YEARS PARA PROD
use \kenservice\data\pynames.db
zap

USE \KENSERVE\IDSSYS\PY00.DB
COPY STRU TO \KENSERVICE\DATA\PY00 PARA PROD
USE \KENSERVE\IDSSYS\DEPT.DB
COPY STRU TO \KENSERVICE\DATA\DEPT PARA PROD
USE \KENSERVE\IDSSYS\DDERUNS.DB
COPY STRU TO \KENSERVICE\DATA\DDERUNS PARA PROD
USE \KENSERVE\IDSSYS\SECT.DB
COPY STRU TO \KENSERVICE\DATA\SECT PARA PROD
USE \KENSERVE\IDSSYS\DIVN.DB
COPY STRU TO \KENSERVICE\DATA\DIVN PARA PROD
USE \KENSERVE\IDSSYS\DIRECT.DB
COPY STRU TO \KENSERVICE\DATA\DIRECT PARA PROD
USE \KENSERVE\IDSSYS\COMPANY.DB
COPY STRU TO \KENSERVICE\DATA\COMPANY PARA PROD

USE \KENSERVICE\DATA\py00.db
ZAP
USE \KENSERVICE\DATA\DDERUNS.DB
zap
IF .NOT. FILE("\kenservice\data\fgpaycoy.dbf")
USE \KENSERVE\IDSSYS\FGPAYCOY.DBF
COPY STRU TO \kenservice\data\fgpaycoy DBASE PROD
ENDIF
use \kenservice\data\fgpaycoy.dbf
zap
 use \kenservice\data\pystate.dbf
 zap
use \kenservice\data\py00.db
zap
use \KENSERVICE\data\SECT.DB
zap
use \KENSERVICE\data\DIVN.DB
zap
use \KENSERVICE\data\DIRECT.DB
zap
use \KENSERVICE\data\COMPANY.DB
zap
use \KENSERVICE\data\DEPT.DB
zap
zap
USE \KENSERVICE\data\LOANMAST.DB
ZAP
USE \KENSERVICE\DATA\DDE03T.DB 
ZAP
USE \KENSERVICE\DATA\EDEDMAST.DB EXCL
ZAP
use \kenservice\data\PROGREP.DBF
ZAP

use \kenservice\data\dde01.db
zap
use \kenservice\data\dde01d.db
zap
use \kenserve\idssys\dde01d.dbf
copy stru to  \kenservice\data\dde01d dbase prod
use \kenservice\data\dde02.db
zap
use \kenservice\data\dde02d.db
zap
*use \kenservice\data\dde02d.dbf
zap
use \kenservice\data\dde03.db
zap
use \kenservice\data\dde03d.db
zap
use \kenservice\data\dde04.db
zap
use \kenservice\data\dde04d.db
zap
use \kenservice\data\dde05.db
zap
use \kenservice\data\dde05d.db
zap
use \kenservice\data\dde06.db
zap
use \kenservice\data\dde06d.db
zap
use \kenservice\data\dde07.db
zap
use \kenservice\data\dde07d.db
zap
use \kenservice\data\dde08.db
zap
use \kenservice\data\dde08d.db
zap
use \kenservice\data\dde09.db
zap
use \kenservice\data\dde09d.db
zap
use  \kenserve\idssys\paydata.db
copy stru to \kenservice\data\paydata para prod

use \kenservice\data\pymast.db
zap
use \kenservice\data\pymastS.DBF
zap
USE \KENSERVE\IDSSYS\ytdmast.DB
COPY STRU TO \KENSERVICE\DATA\ytdmast PARA PROD
USE \KENSERVE\IDSSYS\loantab1.DB
COPY STRU TO \KENSERVICE\DATA\loantab1 PARA PROD
USE \KENSERVE\IDSSYS\pyreport.DB
COPY STRU TO \KENSERVICE\DATA\pyreport PARA PROD
USE \KENSERVE\IDSSYS\payroll1.DBF
COPY STRU TO \KENSERVICE\DATA\payroll1 DBASE PROD
USE \KENSERVE\IDSSYS\payroll2.DBF
COPY STRU TO \KENSERVICE\DATA\payroll2 DBASE PROD
USE \KENSERVE\IDSSYS\ytdmast1.DBF
COPY STRU TO \KENSERVICE\DATA\ytdmast1 DBASE PROD
USE \KENSERVE\IDSSYS\ytdmast2.DBF
COPY STRU TO \KENSERVICE\DATA\ytdmast2 DBASE PROD
USE \KENSERVE\IDSSYS\edtable1.DB
COPY STRU TO \KENSERVICE\DATA\edtable1 PARA PROD
USE \KENSERVE\IDSSYS\edtable2.DB
COPY STRU TO \KENSERVICE\DATA\edtable2 PARA PROD
use \kenserve\idssys\loantab2.db
copy stru to  \kenservice\data\loantab2 para prod
USE \KENSERVE\IDSSYS\p9atax.DB
COPY STRU TO \KENSERVICE\DATA\p9atax PARA PROD
USE \KENSERVE\IDSSYS\p9atax.DBF
COPY STRU TO \KENSERVICE\DATA\p9atax DBASE PROD
USE \KENSERVE\IDSSYS\YTDREP.DB
COPY STRU TO \KENSERVICE\DATA\YTDREP PARA PROD
USE \KENSERVE\IDSSYS\YTDGRAT.DB
COPY STRU TO \KENSERVICE\DATA\YTDGRAT PARA PROD
USE \KENSERVE\IDSSYS\LOANREP.DB
COPY STRU TO \KENSERVICE\DATA\LOANREP PARA PROD
USE \KENSERVE\IDSSYS\LOANMAST.DB
COPY STRU TO \KENSERVICE\DATA\LOANMAST PARA PROD
USE \KENSERVE\IDSSYS\GRATREP.DB
COPY STRU TO \KENSERVICE\DATA\GRATREP PARA PROD
USE \KENSERVE\IDSSYS\pyrmast1.DB
COPY STRU TO \KENSERVICE\DATA\pyrmast1 PARA PROD
USE \KENSERVE\IDSSYS\pyrmast2.DB
COPY STRU TO \KENSERVICE\DATA\pyrmast2 PARA PROD
USE \KENSERVE\IDSSYS\pymast1.DB
COPY STRU TO \KENSERVICE\DATA\pymast1 PARA PROD
USE \KENSERVE\IDSSYS\pymast2.DB
COPY STRU TO \KENSERVICE\DATA\pymast2 PARA PROD
use \kenserve\idssys\fgbank.dbf
copy stru to \kenservice\data\fgbank dbase prod
use \kenserve\idssys\fgbbrch.dbf
copy stru to \kenservice\data\fgbbrch dbase prod
use \kenserve\idssys\payroll1.dbf
copy stru to \kenservice\data\payroll1 dbase prod
use \kenserve\idssys\payroll2.dbf
copy stru to \kenservice\data\payroll2 dbase prod
use \kenserve\idssys\ytdmast1.dbf
copy stru to \kenservice\data\ytdmast1 dbase prod
use \kenserve\idssys\ytdmast2.dbf
copy stru to \kenservice\data\ytdmast2 dbase prod
use \kenserve\idssys\dde03t.dbf
copy stru to \kenservice\data\dde03t dbase prod
use \kenserve\idssys\pymast.dbf
copy stru to \kenservice\data\pymast dbase prod
use \kenserve\idssys\pymasts.dbf
copy stru to \kenservice\data\pymasts dbase prod
use \kenserve\idssys\pynames.dbf
copy stru to \kenservice\data\pynames dbase prod
use \kenserve\idssys\p9atax.dbf
copy stru to \kenservice\data\p9atax dbase prod
use \kenserve\idssys\ededmast.dbf
copy stru to \kenservice\data\ededmast dbase prod
use \kenserve\idssys\payroll1.db
copy stru to \kenservice\data\payroll1 paradox prod
use \kenserve\idssys\payroll2.db
copy stru to \kenservice\data\payroll2 paradox prod
use \kenserve\idssys\ytdmast1.db
copy stru to \kenservice\data\ytdmast1 paradox prod
use \kenserve\idssys\ytdmast2.db
copy stru to \kenservice\data\ytdmast2 paradox prod
use \kenserve\idssys\dde03t.db
copy stru to \kenservice\data\dde03t paradox prod
use \kenserve\idssys\pymast.db
copy stru to \kenservice\data\pymast paradox prod
use \kenserve\idssys\pynames.db
copy stru to \kenservice\data\pynames paradox prod
use \kenserve\idssys\p9atax.db
copy stru to \kenservice\data\p9atax paradox prod
use \kenserve\idssys\ededmast.db
copy stru to \kenservice\data\ededmast paradox prod
use \kenserve\idssys\dde01d.dbf
copy stru to \kenservice\data\dde01d dbase prod
use \kenserve\idssys\dde02d.dbf
copy stru to \kenservice\data\dde02d dbase prod
SET EXCLUSIVE OFF
else
quit
endif