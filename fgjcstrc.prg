Procedure fgjcstrc
close databases
if .not. file("\kenservice\data\fgjcsals.dbf")
use \kenserve\idssys\fgjcsals.dbf
copy stru to \kenservice\data\fgjcsals dbase prod
endif
if .not. file("\kenservice\data\arwinvce.dbf")
use \kenserve\idssys\arwinvce.dbf
copy stru to \kenservice\data\arwinvce dbase prod
endif
if .not. file("\kenservice\data\fgviscad.dbf")
use \kenserve\idssys\fgviscad.dbf
copy stru to \kenservice\data\fgviscad dbase prod
endif
USE \KENSERVE\IDSSYS\fgjcsals.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fgjcsals.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fgjcsals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgjcsals.DBF
APPE FROM  \KENSERVE\IDSSYS\fgjcsals.DBF
USE \KENSERVE\IDSSYS\fgjcsals.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\arwinvce.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\arwinvce.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\arwinvce DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\arwinvce.DBF
APPE FROM  \KENSERVE\IDSSYS\arwinvce.DBF
USE \KENSERVE\IDSSYS\arwinvce.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fgviscad.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fgviscad.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fgviscad DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgviscad.DBF
APPE FROM  \KENSERVE\IDSSYS\fgviscad.DBF
USE \KENSERVE\IDSSYS\fgviscad.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\SHCATSUM.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\SHCATSUM.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\SHCATSUM DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\SHCATSUM.DBF
APPE FROM  \KENSERVE\IDSSYS\SHCATSUM.DBF
USE \KENSERVE\IDSSYS\SHCATSUM.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fglusals.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fglusals.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fglusals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fglusals.DBF
APPE FROM  \KENSERVE\IDSSYS\fglusals.DBF
USE \KENSERVE\IDSSYS\fglusals.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fglpsals.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fglpsals.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fglpsals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fglpsals.DBF
APPE FROM  \KENSERVE\IDSSYS\fglpsals.DBF
USE \KENSERVE\IDSSYS\fglpsals.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGNLPLIN.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGNLPLIN.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGNLPLIN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGNLPLIN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGNLPLIN.DBF
USE \KENSERVE\IDSSYS\FGNLPLIN.DBF exclusive
zap
endif
set safety on