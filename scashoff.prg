PROCEDURE scashoff
SET SAFETY OFF
USE \KENSERVE\IDSSYS\fgoffs.DBF 
copy stru to \kenservice\data\fgoffs dbase prod
use \kenservice\data\fgoffs.dbf
appe from  \kenservice\data\fgoff.dbf
USE \KENSERVE\IDSSYS\oftitles.DBF 
copy stru to \kenservice\data\oftitles dbase prod
use \kenservice\data\oftitles.dbf
appe from  \kenservice\data\oftitle.dbf
USE \KENSERVE\IDSSYS\fgclas.DBF 
copy stru to \kenservice\data\fgclas dbase prod
use \kenservice\data\fgclas.dbf
appe from  \kenservice\data\fgcla.dbf
USE \KENSERVE\IDSSYS\fgtyps.DBF 
copy stru to \kenservice\data\fgtyps dbase prod
use \kenservice\data\fgtyps.dbf
appe from  \kenservice\data\fgtyp.dbf
USE \KENSERVE\IDSSYS\fgcods.DBF 
copy stru to \kenservice\data\fgcods dbase prod
use \kenservice\data\fgcods.dbf
appe from  \kenservice\data\fgcod.dbf

close databases
SET SAFETY ON