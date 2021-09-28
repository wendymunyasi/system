procedure frvest
set safety off
if .not. file("\kenservice\data\frveregs.dbf")
use \kenserve\idssys\frveregs.dbf
copy stru to \kenservice\data\frveregs dbase prod
endif
USE \KENSERVE\IDSSYS\frveregs.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\frveregs.DBF
COPY STRU TO \KENSERVICE\DATA\frveregs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\frveregs.DBF
APPE FROM  \KENSERVE\IDSSYS\frveregs.DBF
USE \KENSERVE\IDSSYS\frveregs.DBF exclusive
zap
endif
set safety on