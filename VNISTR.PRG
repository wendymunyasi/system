PROCEDURE vnistr
   USE \KENSERVICE\DATA\VENDOR.DBF exclusive
USE \KENSERVICE\DATA\vennames.DBF exclusive
close databases
USE \kenslog/idssys\VENDOR.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\VENDOR.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\VENDOR DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\VENDOR.DBF
APPE FROM  \kenslog/idssys\VENDOR.DBF
USE \kenslog/idssys\VENDOR.DBF exclusive
zap
endif
USE \kenslog/idssys\vennames.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\vennames.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\vennames DBASE PROD
COPY STRU TO \KENSERVICE\SYSDATA\DATA\vennames DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\vennames.DBF
APPE FROM  \kenslog/idssys\vennames.DBF
USE \kenslog/idssys\vennames.DBF exclusive
zap
endif
close databases
set safety on