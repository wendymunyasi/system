Procedure nglsetup
* Visual dBASE .QBE file 9
*quit
PARAMETER BUSER,BLEVEL
PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    use \kenserve\idssys\keninitg.dbf exclusive
    go top
     if plevel < 2 .and. day(ken_date) = 1 .and. month(ken_date) = month(date()) .and. ;
    year(ken_date) = year(date()) .and. .not. eof() .and. empty(ken_init) .and. empty(ken_user) 
    replace ken_init with date()
    replace ken_user with pluser
SET EXACT ON
SET EXCLUSIVE ON
set safety off
*quit
*CD \KENSERVICe\data
USE  \KENSERVE\IDSSYS\FGSUMSLS.DBF
COPY STRU TO \KENSERVICE\DATA\FGSUMSLS DBASE PROD
use \kenserve\idssys\NGLACCP.dbf
copy stru to  \KENSERVICE\DATA\NGLACCP dbase prod
use \kenserve\idssys\nglmastp.dbf
copy stru to  \KENSERVICE\DATA\NGLMASTP dbase prod
USE \KENSERVICE\DATA\NGTAMAST.DBF
ZAP
use \kenserve\idssys\ngtrialb.dbf
copy stru to  \KENSERVICE\DATA\NGTRIALB dbase prod
use \kenserve\idssys\glmast.dbf
copy stru to  \KENSERVICE\DATA\glmast dbase prod

use \kenserve\idssys\ngledger.dbf
copy stru to \kenservice\data\ngledger dbase prod
USE \KENSERVICE\DATA\KENINIT.DBF
ZAP
use \kenservice\data\nglyears.dbf
zap
use \kenserve\idssys\ngfgnlif.dbf
copy stru to  \KENSERVICE\data\NGFGNlif dbase prod
use \kenserve\idssys\nlprofit.dbf
copy stru to  \kenservice\data\nlprofit dbase prod

use \kenserve\idssys\fgglpur.dbf
copy stru to  \KENSERVICE\DATA\fgGLpur dbase prod
use \kenservice\data\gltrnref.dbf
zap
use \kenservice\data\glpurch.dbf
zap
use \kenservice\data\GVfgrns.dbf
zap
use \kenservice\data\GVfgrnsl.dbf
zap
use \kenservice\data\GVfgrnsd.dbf
zap
*use \kenservice\data\GVfgrnsn.dbf
zap
use \kenservice\data\GVfgrnup.dbf
zap
use \kenservice\data\GVfgrlin.dbf
zap

USE \KENSERVICE\DATA\GLCOYSUM.DBF
ZAP

use \kenservice\data\GVcgrns.dbf
zap
use \kenservice\data\GVcgrnsl.dbf
zap
use \kenservice\data\GVcgrnsd.dbf
zap
*use \kenservice\data\GVcgrnsn.dbf
zap
use \kenservice\data\GVcgrnup.dbf
zap
use \kenservice\data\GVcgrlin.dbf
zap

use \kenservice\data\GVPGrns.dbf
zap
use \kenservice\data\GVPGrnsl.dbf
zap
use \kenservice\data\GVPGrnsd.dbf
zap
*use \kenservice\data\GVPGrnsn.dbf
zap
use \kenservice\data\GVPGrnup.dbf
zap
use \kenservice\data\GVPGrlin.dbf
zap

use \kenservice\data\gpcgrns.dbf
zap
use \kenservice\data\gpcgrnsl.dbf
zap
use \kenservice\data\gpcgrnsd.dbf
zap
*use \kenservice\data\gpcgrnsn.dbf
zap
use \kenservice\data\gpcgrnup.dbf
zap
use \kenservice\data\gpcgrlin.dbf
zap

use \kenservice\data\pgrepls.dbf
zap
use \kenservice\data\pgreplsl.dbf
zap
use \kenservice\data\pgreplsd.dbf
zap
*use \kenservice\data\pgreplsn.dbf
zap
use \kenservice\data\pgrepupd.dbf
zap
use \kenservice\data\pgreplin.dbf
zap
USE  \KENSERVICE\DATA\DSHSTMAS.DBF
REPLACE ALL POST_DATE WITH {}
USE \KENSERVICE\DATA\fgadasto.DBF
DELETE ALL FOR system= "FG" .AND. doctype = "10" .AND. REASON = "V" .AND. ORDER_NO = "000001" .AND. DAY(ORDER_DATE+1) = 1
USE \kenservice\data\fgglmth.DBf 
ZAP      
USE \KENSERVICE\DATA\FGLPRD.DBF 
ZAP
use \kenservice\data\fglprds.dbf 
ZAP
USE \KENSERVICE\DATA\fgglmthS.DBF 
ZAP
use \kenservice\data\gpogrns.dbf
zap
use \kenservice\data\gpogrnsl.dbf
zap
use \kenservice\data\gpogrnsd.dbf
zap
*use \kenservice\data\gpogrnsn.dbf
*zap
use \kenservice\data\gpogrnup.dbf
zap
use \kenservice\data\gpogrlin.dbf
zap

use \kenservice\data\gpfgrns.dbf
zap
use \kenservice\data\gpfgrnsl.dbf
zap
use \kenservice\data\gpfgrnsd.dbf
zap
use \kenservice\data\gpfgrnup.dbf
zap
use \kenservice\data\gpfgrlin.dbf
zap
USE \KENSERVICE\DATA\NGFGNLIF.DBF
ZAP
USE \KENSERVICE\DATA\FGSTKS.DBF 
ZAP
USE \KENSERVICE\DATA\FGSTKSL.DBF 
ZAP
USE \KENSERVICE\DATA\FGSTKSD.DBF 
ZAP
*USE \KENSERVICE\DATA\FGSTKSN.DBF 
ZAP
USE \KENSERVICE\DATA\FGSTKSUP.DBF 
ZAP
USE \KENSERVICE\DATA\FGSTKLIN.DBF 
ZAP
use \kenserve\idssys\nltyp.dbf
copy stru to \KENSERVICE\data\NLTYP dbase prod
use \kenserve\idssys\nlcla.dbf
copy stru to \KENSERVICE\data\NLcla dbase prod
use \kenserve\idssys\nlacc.dbf
copy stru to \KENSERVICE\data\nlacc dbase prod

select 4
USE \kenservice\data\NLBS.DBF EXCLUSIVE
zap
select 5
USE \kenservice\data\NLIE.DBF EXCLUSIVE
zap
select 6
USE \kenservice\data\NLBS.DBF EXCLUSIVE
zap
select 7
USE \kenservice\data\NLTA.DBF EXCLUSIVE
zap
select 8
USE \kenservice\data\NLIELEV.DBF EXCLUSIVE
zap
select 9
USE \kenservice\data\NLBSLEV.DBF EXCLUSIVE
zap
select 10
USE \kenservice\data\NLTALEV.DBF EXCLUSIVE
zap
select 11
USE \kenservice\data\NLBSLEL.DBF EXCLUSIVE
zap
select 12
USE \kenservice\data\NLTALEL.DBF EXCLUSIVE
zap
USE \KENSERVICE\data\NGLMAST.DBF 
zap
use \kenservice\data\ngperiod.dbf 
zap
USE \KENSERVICE\DATA\NLBANKc.DBF 
zap
USE \KENSERVICE\DATA\NLCASHc.DBF 
zap
USE \KENSERVICE\DATA\NLBANK.DBF 
zap
USE \KENSERVICE\DATA\NLCASH.DBF 
zap
use \kenservice\data\ngltran.dbf
zap
else
quit
endif
close databases
do nglstruc.prg
close databases

SET EXCLUSIVE OFF
set safety off
*CD \KENSERVICE\IDSSYS
