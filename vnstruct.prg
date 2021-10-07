Procedure vnstruct
close databases
USE \KENSERVE\IDSSYS\vnstat.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\vnstat.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\vnstat DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\vnstat.DBF
APPE FROM  \KENSERVE\IDSSYS\vnstat.DBF
repl all dis_qty with 0, sup_qty with 0, ker_qty with 0, dis_price with 0, sup_price with 0, ker_price with 0, svc_amt with 0
USE \KENSERVE\IDSSYS\vnstat.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\venstat.DBF   EXCLUSIVE
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\venstat DBASE PROD
close databases
set safety on