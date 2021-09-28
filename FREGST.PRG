procedure fregst
set safety off
if .not. file("\kenservice\data\fgregcds.dbf")
use \kenserve\idssys\fgregcds.dbf
copy stru to \kenservice\data\fgregcds dbase prod
endif
USE \KENSERVE\IDSSYS\fgregcds.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgregcds.DBF
COPY STRU TO \KENSERVICE\DATA\fgregcds DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgregcds.DBF
APPE FROM  \KENSERVE\IDSSYS\fgregcds.DBF
USE \KENSERVE\IDSSYS\fgregcds.DBF exclusive
zap
endif
set safety on