PROCEDURE FRISTR
   USE \KENSERVICE\DATA\FRIGHTER.DBF exclusive
USE \KENSERVICE\DATA\frigtmes.DBF exclusive
close databases
USE \kenslog/idssys\FRIGHTER.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FRIGHTER.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FRIGHTER DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRIGHTER.DBF
APPE FROM  \kenslog/idssys\FRIGHTER.DBF
USE \kenslog/idssys\FRIGHTER.DBF exclusive
zap
endif
USE \kenslog/idssys\frigtmes.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\frigtmes.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\frigtmes DBASE PROD
COPY STRU TO \KENSERVICE\SYSDATA\DATA\frigtmes DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\frigtmes.DBF
APPE FROM  \kenslog/idssys\frigtmes.DBF
USE \kenslog/idssys\frigtmes.DBF exclusive
zap
endif
if .not. file('\kenservice\data\fgvisnos.dbf')
 USE  \kenslog/idssys\fgvisnos.dbf
 copy stru to \kenservice\data\fgvisnos dbase prod
else
USE \kenslog/idssys\fgvisnos.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fgvisnos.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fgvisnos DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgvisnos.DBF
APPE FROM  \kenslog/idssys\fgvisnos.DBF
USE \kenslog/idssys\fgvisnos.DBF exclusive
zap
endif
endif
close databases
set safety on