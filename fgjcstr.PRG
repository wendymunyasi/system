Procedure FGJCSTR
close databases
USE \KENSERVE\IDSSYS\FGJOBCAD.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGJOBCAD.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGJOBCAD DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGJOBCAD.DBF
APPE FROM  \KENSERVE\IDSSYS\FGJOBCAD.DBF
USE \KENSERVE\IDSSYS\FGJOBCAD.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\FGNJCLIN.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGNJCLIN.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGNJCLIN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGNJCLIN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGNJCLIN.DBF
USE \KENSERVE\IDSSYS\FGNJCLIN.DBF exclusive
zap
endif
close databases
set safety on