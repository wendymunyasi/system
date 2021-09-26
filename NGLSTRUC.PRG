Procedure nglstruc
close databases
set exclusive on
set safety off
ON ERROR
use \kenservice\data\fgadasto.dbf
REPLACE ALL GL_pOST WITH {}
DELE ALL FOR DOCTYPE = '10' .AND. SYSTEM = 'FG'
on error do pur_rtn
use  \kenservice\data\fgnfpur.dbf
? gl_post
use  \kenservice\data\fgnfpur.dbf
replace all gl_post with {}
on error do chq_rtn
USE \KENSERVICE\DATA\fgchqtrn.DBF
? gl_post
USE \KENSERVICE\DATA\fgchqtrn.DBF
replace all gl_post with {}
on error do sh_rtn
USE \KENSERVICE\DATA\FGshtran.DBf
? gl_post
USE \KENSERVICE\DATA\FGshtran.DBf
replace all gl_post with {}
on error do tran_rtn
use \kenservice\data\fgtran.dbf
? gl_post
use \kenservice\data\fgtran.dbf
replace all gl_post with {}
on error do inv_rtn
use \kenservice\data\fginvtrn.dbf
? gl_post
use \kenservice\data\fginvtrn.dbf
replace all gl_post with {}
if file('kenservice\data\fginvtrs.bf')
use \kenservice\data\fginvtrs.dbf
replace all gl_post with {}
endif
if file('kenservice\data\fglpgtrs.bf')
use \kenservice\data\fglpgtrs.dbf
replace all gl_post with {}
endif
on error do vis_rtn
use \kenservice\data\fgvistrn.dbf
? gl_post
use \kenservice\data\fgvistrn.dbf
repl all gl_post with {}
on error do job_rtn
use \kenservice\data\fgjobcad.dbf
? gl_post
use \kenservice\data\fgjobcad.dbf
repl all gl_post with {}
on error do lpg_rtn
use \kenservice\data\fgLPGcad.dbf
repl all gl_post with {}
on error
use \kenservice\data\nglnlif.dbf
repla all gl_post with {}

procedure lpg_rtn
use \kenserve\idssys\fgLPGcad.dbf
go top
if eof()
appe from \kenservice\data\fgLPGcad.dbf
copy stru to \kenservice\data\fgLPGcad dbase prod
USE \KENSERVICE\DATA\fgLPGcad.DBf
appe from \kenserve\idssys\fgLPGcad.dbf
endif



procedure job_rtn

use \kenserve\idssys\fgjobcad.dbf 
zap
appe from \kenservice\data\fgjobcad.dbf
copy stru to \kenservice\data\fgjobcad dbase prod
USE \KENSERVICE\DATA\fgjobcad.DBf
appe from \kenserve\idssys\fgjobcad.dbf
use \kenserve\idssys\fgjobcad.dbf 
zap
procedure vis_rtn
use \kenserve\idssys\fgvistrn.dbf
zap
appe from \kenservice\data\fgvistrn.dbf
copy stru to \kenservice\data\fgvistrn dbase prod
USE \KENSERVICE\DATA\fgvistrn.DBf
appe from \kenserve\idssys\fgvistrn.dbf
use \kenserve\idssys\fgvistrn.dbf
zap

procedure inv_rtn
use \kenserve\idssys\fginvtrn.dbf
zap
appe from \kenservice\data\fginvtrn.dbf
copy stru to \kenservice\data\fginvtrn dbase prod
USE \KENSERVICE\DATA\fginvtrn.DBf
appe from \kenserve\idssys\fginvtrn.dbf
use \kenserve\idssys\fginvtrn.dbf
zap

procedure tran_rtn

use \kenserve\idssys\fgtran.dbf
zap
appe from \kenservice\data\fgtran.dbf
copy stru to \kenservice\data\fgtran dbase prod
USE \KENSERVICE\DATA\fgtran.DBf
appe from \kenserve\idssys\fgtran.dbf
use \kenserve\idssys\fgtran.dbf
zap

procedure sh_rtn
use \kenserve\idssys\FGshtran.dbf
zap
appe from \kenservice\data\FGshtran.dbf
copy stru to \kenservice\data\FGshtran dbase prod
USE \KENSERVICE\DATA\FGshtran.DBf
appe from \kenserve\idssys\FGshtran.dbf
use \kenserve\idssys\FGshtran.dbf
zap

procedure pur_rtn
use \kenserve\idssys\fgnfpur.dbf
zap
appe from \kenservice\data\fgnfpur.dbf
copy stru to \kenservice\data\fgnfpur dbase prod
USE \KENSERVICE\DATA\fgnfpur.DBf
appe from \kenserve\idssys\fgnfpur.dbf
use \kenserve\idssys\fgnfpur.dbf
zap
Procedure chq_rtn
use \kenserve\idssys\fgchqtrn.dbf
zap
appe from \kenservice\data\fgchqtrn.dbf
copy stru to \kenservice\data\fgchqtrn dbase prod
use 
USE \KENSERVICE\DATA\fgchqtrn.DBF
appe from \kenserve\idssys\fgchqtrn.dbf
use \kenserve\idssys\fgchqtrn.dbf
zap

