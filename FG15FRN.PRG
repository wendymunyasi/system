PROCEDURE FG15FRN
CLOSE DATABASES
SET SAFETY OFF
USE \KENSERVE\IDSSYS\ST15FHIS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ST15FHIS.DBF
COPY STRU TO \KENSERVICE\DATA\ST15FHIS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ST15FHIS.DBF
APPE FROM  \KENSERVE\IDSSYS\ST15FHIS.DBF
USE \KENSERVE\IDSSYS\ST15FHIS.DBF exclusive
zap
endif
CLOSE DATABASES
SET SAFETY ON