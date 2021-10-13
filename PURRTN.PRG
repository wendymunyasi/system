
PROCEDURE PURRTN
   CLOSE DATABASES
   SET SAFETY OFF
use \kenserve\idssys\fgnfpur.dbf EXCLUSIVE
zap
appe from \kenservice\data\fgnfpur.dbf
copy stru to \kenservice\data\fgnfpur dbase prod
USE \KENSERVICE\DATA\fgnfpur.DBf
appe from \kenserve\idssys\fgnfpur.dbf
use \kenserve\idssys\fgnfpur.dbf EXCLUSIVE
zap

USE \KENSERVE\IDSSYS\FGPURCH.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGPURCH.DBF
COPY STRU TO \KENSERVICE\DATA\FGPURCH DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGPURCH.DBF
APPE FROM  \KENSERVE\IDSSYS\FGPURCH.DBF
USE \KENSERVE\IDSSYS\FGPURCH.DBF exclusive
zap
endif
SET SAFETY ON