PROCEDURE FGCOYPUP
   CLOSE DATABASES
   SET SAFETY OFF
   USE \KENSERVE\IDSSYS\FGCOYS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGCOYS.DBF
COPY STRU TO \KENSERVICE\DATA\FGCOYS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGCOYS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGCOYS.DBF
USE \KENSERVE\IDSSYS\FGCOYS.DBF exclusive
zap
endif
 USE \KENSERVE\IDSSYS\fgpurchs.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgpurchs.DBF
COPY STRU TO \KENSERVICE\DATA\fgpurchs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgpurchs.DBF
APPE FROM  \KENSERVE\IDSSYS\fgpurchs.DBF
USE \KENSERVE\IDSSYS\fgpurchs.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGCOY.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGCOY.DBF
COPY STRU TO \KENSERVICE\DATA\FGCOY DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGCOY.DBF
APPE FROM  \KENSERVE\IDSSYS\FGCOY.DBF
USE \KENSERVE\IDSSYS\FGCOY.DBF exclusive
zap
endif
 USE \KENSERVE\IDSSYS\fgnfpur.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgnfpur.DBF
COPY STRU TO \KENSERVICE\DATA\fgnfpur DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgnfpur.DBF
APPE FROM  \KENSERVE\IDSSYS\fgnfpur.DBF
USE \KENSERVE\IDSSYS\fgnfpur.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fgpurch.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgpurch.DBF
COPY STRU TO \KENSERVICE\DATA\fgpurch DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgpurch.DBF
APPE FROM  \KENSERVE\IDSSYS\fgpurch.DBF
USE \KENSERVE\IDSSYS\fgpurch.DBF exclusive
zap
endif
CLOSE DATABASES
SET SAFETY ON