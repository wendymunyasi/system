 
                
**************************************************************************
*  PROGRAM:     fgshid.prg
*
*
*******************************************************************************

Procedure fgshid
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Restoring and Rebuilding Temporary Indexes in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 10-30 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePOinter 11,;
    ColorNormal "n+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
IF .NOT. FILE ('\kenservice\data\fghqupld.dbf')
USE \KENSERVE\IDSSYS\FGHQUPLD.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQUPLD DBASE PROD
ENDIF
CLOSE DATABASES
ON ERROR DO QBEERR WITH ERROR(), MESSAGE(),;
PROGRAM(), LINENO()
CLOSE DATABASES
SET EXCLUSIVE ON
set safety off
SET EXACT ON
** phase 2
if .not. file("\kenservice\data\fgmcclb.dbf")
use \kenserve\idssys\fgmcclb.dbf
copy stru to \kenservice\data\fgmcclb dbase prod
endif
USE \KENSERVE\IDSSYS\fgmcclb.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmcclb.DBF
COPY STRU TO \KENSERVICE\DATA\fgmcclb DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmcclb.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmcclb.DBF
USE \KENSERVE\IDSSYS\fgmcclb.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGSALPUR.dbf")
use \kenserve\idssys\FGSALPUR.dbf
copy stru to \kenservice\data\FGSALPUR dbase prod
endif
USE \KENSERVE\IDSSYS\FGSALPUR.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGSALPUR.DBF
COPY STRU TO \KENSERVICE\DATA\FGSALPUR DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGSALPUR.DBF
APPE FROM  \KENSERVE\IDSSYS\FGSALPUR.DBF
USE \KENSERVE\IDSSYS\FGSALPUR.DBF exclusive
zap
endif
If .not. file("\kenservice\data\FMSSAGE.dbf")
use \kenserve\idssys\FMSSAGE.dbf
copy stru to \kenservice\data\FMSSAGE dbase prod
endif
USE \KENSERVE\IDSSYS\FMSSAGE.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FMSSAGE.DBF
COPY STRU TO \KENSERVICE\DATA\FMSSAGE DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FMSSAGE.DBF
APPE FROM  \KENSERVE\IDSSYS\FMSSAGE.DBF
USE \KENSERVE\IDSSYS\FMSSAGE.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmcclg.dbf")
use \kenserve\idssys\fgmcclg.dbf
copy stru to \kenservice\data\fgmcclg dbase prod
endif
USE \KENSERVE\IDSSYS\fgmcclg.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmcclg.DBF
COPY STRU TO \KENSERVICE\DATA\fgmcclg DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmcclg.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmcclg.DBF
USE \KENSERVE\IDSSYS\fgmcclg.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgsumsls.dbf")
use \kenserve\idssys\fgsumsls.dbf
copy stru to \kenservice\data\fgsumsls dbase prod
endif
USE \KENSERVE\IDSSYS\fgsumsls.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgsumsls.DBF
COPY STRU TO \KENSERVICE\DATA\fgsumsls DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgsumsls.DBF
APPE FROM  \KENSERVE\IDSSYS\fgsumsls.DBF
USE \KENSERVE\IDSSYS\fgsumsls.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FRCUSTBL.dbf")
use \kenserve\idssys\FRCUSTBL.dbf
copy stru to \kenservice\data\FRCUSTBL dbase prod
endif
USE \KENSERVE\IDSSYS\FRCUSTBL.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FRCUSTBL.DBF
COPY STRU TO \KENSERVICE\DATA\FRCUSTBL DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRCUSTBL.DBF
APPE FROM  \KENSERVE\IDSSYS\FRCUSTBL.DBF
USE \KENSERVE\IDSSYS\FRCUSTBL.DBF exclusive
zap
endif

if .not. file("\kenservice\data\FGHQTYP.dbf")
use \kenserve\idssys\FGHQTYP.dbf
copy stru to \kenservice\data\FGHQTYP dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQTYP.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQTYP.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQTYP DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQTYP.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQTYP.DBF
USE \KENSERVE\IDSSYS\FGHQTYP.DBF exclusive
zap
endif
if .not. file("\kenservice\data\ARDSCTRN.dbf")
use \kenserve\idssys\ARDSCTRN.dbf
copy stru to \kenservice\data\ARDSCTRN dbase prod
endif
USE \KENSERVE\IDSSYS\ARDSCTRN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ARDSCTRN.DBF
COPY STRU TO \KENSERVICE\DATA\ARDSCTRN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ARDSCTRN.DBF
APPE FROM  \KENSERVE\IDSSYS\ARDSCTRN.DBF
USE \KENSERVE\IDSSYS\ARDSCTRN.DBF exclusive
zap
endif
if .not. file("\kenservice\data\st15dmtr.dbf")
use \kenserve\idssys\st15dmtr.dbf
copy stru to \kenservice\data\st15dmtr dbase prod
endif
USE \KENSERVE\IDSSYS\st15dmtr.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\st15dmtr.DBF
COPY STRU TO \KENSERVICE\DATA\st15dmtr DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\st15dmtr.DBF
APPE FROM  \KENSERVE\IDSSYS\st15dmtr.DBF
USE \KENSERVE\IDSSYS\st15dmtr.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGHQCLA.dbf")
use \kenserve\idssys\FGHQCLA.dbf
copy stru to \kenservice\data\FGHQCLA dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQCLA.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQCLA.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQCLA DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQCLA.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQCLA.DBF
USE \KENSERVE\IDSSYS\FGHQCLA.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGHQCUS.dbf")
use \kenserve\idssys\FGHQCUS.dbf
copy stru to \kenservice\data\FGHQCUS dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQCUS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQCUS.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQCUS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQCUS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQCUS.DBF
USE \KENSERVE\IDSSYS\FGHQCUS.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fglpgtrn.dbf")
use \kenserve\idssys\fglpgtrn.dbf
copy stru to \kenservice\data\fglpgtrn dbase prod
endif
USE \KENSERVE\IDSSYS\fglpgtrn.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fglpgtrn.DBF
COPY STRU TO \KENSERVICE\DATA\fglpgtrn DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fglpgtrn.DBF
APPE FROM  \KENSERVE\IDSSYS\fglpgtrn.DBF
USE \KENSERVE\IDSSYS\fglpgtrn.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGHQCUSS.dbf")
use \kenserve\idssys\FGHQCUSS.dbf
copy stru to \kenservice\data\FGHQCUSS dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQCUSS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQCUSS.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQCUSS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQCUSS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQCUSS.DBF
USE \KENSERVE\IDSSYS\FGHQCUSS.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGHQUPLD.dbf")
use \kenserve\idssys\FGHQUPLD.dbf
copy stru to \kenservice\data\FGHQUPLD dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQUPLD.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQUPLD.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQUPLD DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQUPLD.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQUPLD.DBF
USE \KENSERVE\IDSSYS\FGHQUPLD.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGHQCOD.dbf")
use \kenserve\idssys\FGHQCOD.dbf
copy stru to \kenservice\data\FGHQCOD dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQCOD.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQCOD.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQCOD DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQCOD.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQCOD.DBF
USE \KENSERVE\IDSSYS\FGHQCOD.DBF exclusive
zap
endif
if .not. file("\kenservice\data\FGHQCODS.dbf")
use \kenserve\idssys\FGHQCODS.dbf
copy stru to \kenservice\data\FGHQCODS dbase prod
endif
USE \KENSERVE\IDSSYS\FGHQCODS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGHQCODS.DBF
COPY STRU TO \KENSERVICE\DATA\FGHQCODS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGHQCODS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGHQCODS.DBF
USE \KENSERVE\IDSSYS\FGHQCODS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\ST15F.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ST15F.DBF
COPY STRU TO \KENSERVICE\DATA\ST15F DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ST15F.DBF
APPE FROM  \KENSERVE\IDSSYS\ST15F.DBF
USE \KENSERVE\IDSSYS\ST15F.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\scashrec.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\scashrec.DBF
COPY STRU TO \KENSERVICE\DATA\scashrec DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\scashrec.DBF
APPE FROM  \KENSERVE\IDSSYS\scashrec.DBF
USE \KENSERVE\IDSSYS\scashrec.DBF exclusive
zap
endif

if .not. file("\kenservice\idssys\KENSLOGN.dbf")
use \kenserve\idssys\KENSLOGN.dbf
copy stru to \kenservice\idssys\KENSLOGN dbase prod
endif
USE \KENSERVE\IDSSYS\KENSLOGN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\idssys\KENSLOG.DBF
COPY STRU TO \KENSERVICE\idssys\KENSLOG DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\idssys\KENSLOG.DBF
APPE FROM  \KENSERVE\IDSSYS\KENSLOGN.DBF
USE \KENSERVE\IDSSYS\KENSLOGN.DBF exclusive
zap
endif

use \kenserve\idssys\kentrylg.dbf
copy stru to \kenservice\idssys\kentrylg dbase prod

if .not. file("\kenservice\idssys\kenslogd.dbf")
use \kenserve\idssys\kenslogd.dbf
copy stru to \kenservice\idssys\kenslogd dbase prod
endif
USE \KENSERVE\IDSSYS\kenslogd.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\idssys\kenslogd.DBF
COPY STRU TO \KENSERVICE\idssys\kenslogd DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\idssys\kenslogd.DBF
APPE FROM  \KENSERVE\IDSSYS\kenslogd.DBF
USE \KENSERVE\IDSSYS\kenslogd.DBF exclusive
zap
endif

if .not. file("\kenservice\idssys\kenslog1.dbf")
use \kenserve\idssys\kenslog1.dbf
copy stru to \kenservice\idssys\kenslog1 dbase prod
endif
USE \KENSERVE\IDSSYS\kenslog1.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\idssys\kenslog1.DBF
COPY STRU TO \KENSERVICE\idssys\kenslog1 DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\idssys\kenslog1.DBF
APPE FROM  \KENSERVE\IDSSYS\kenslog1.DBF
USE \KENSERVE\IDSSYS\kenslog1.DBF exclusive
zap
endif

if .not. file("\kenservice\data\kenslogt.dbf")
use \kenserve\idssys\kenslogt.dbf
copy stru to \kenservice\data\kenslogt dbase prod
endif
USE \KENSERVE\IDSSYS\kenslogt.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\kenslogt.DBF
COPY STRU TO \KENSERVICE\DATA\kenslogt DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\kenslogt.DBF
APPE FROM  \KENSERVE\IDSSYS\kenslogt.DBF
USE \KENSERVE\IDSSYS\kenslogt.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgpaymts.dbf")
use \kenserve\idssys\fgpaymts.dbf
copy stru to \kenservice\data\fgpaymts dbase prod
endif
USE \KENSERVE\IDSSYS\fgpaymts.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgpaymts.DBF
COPY STRU TO \KENSERVICE\DATA\fgpaymts DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgpaymts.DBF
APPE FROM  \KENSERVE\IDSSYS\fgpaymts.DBF
USE \KENSERVE\IDSSYS\fgpaymts.DBF exclusive
zap
endif
if .not. file("\kenservice\data\ARDRCPST.dbf")
use \kenserve\idssys\ARDRCPST.dbf
copy stru to \kenservice\data\ARDRCPST dbase prod
endif
USE \KENSERVE\IDSSYS\ARDRCPST.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ARDRCPST.DBF
COPY STRU TO \KENSERVICE\DATA\ARDRCPST DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ARDRCPST.DBF
APPE FROM  \KENSERVE\IDSSYS\ARDRCPST.DBF
USE \KENSERVE\IDSSYS\ARDRCPST.DBF exclusive
zap
endif
if .not. file("\kenservice\data\JNDRCPST.dbf")
use \kenserve\idssys\JNDRCPST.dbf
copy stru to \kenservice\data\JNDRCPST dbase prod
endif
USE \KENSERVE\IDSSYS\JNDRCPST.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\JNDRCPST.DBF
COPY STRU TO \KENSERVICE\DATA\JNDRCPST DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\JNDRCPST.DBF
APPE FROM  \KENSERVE\IDSSYS\JNDRCPST.DBF
USE \KENSERVE\IDSSYS\JNDRCPST.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgtransf.dbf")
use \kenserve\idssys\fgtransf.dbf
copy stru to \kenservice\data\fgtransf dbase prod
endif
USE \KENSERVE\IDSSYS\fgtransf.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgtransf.DBF
COPY STRU TO \KENSERVICE\DATA\fgtransf DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgtransf.DBF
APPE FROM  \KENSERVE\IDSSYS\fgtransf.DBF
USE \KENSERVE\IDSSYS\fgtransf.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgpurchs.dbf")
use \kenserve\idssys\fgpurchs.dbf
copy stru to \kenservice\data\fgpurchs dbase prod
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
  use \kenserve\idssys\custmmyy.dbf
 copy stru to \kenservice\data\custmmyy DBase Prod
  use \kenserve\idssys\custyymm.dbf
 copy stru to \kenservice\data\custyymm DBase Prod
  use \kenserve\idssys\custmmyy.dbf
 copy stru to \kenservice\sysdata\data\custmmyy DBase Prod
  use \kenserve\idssys\custyymm.dbf
 copy stru to \kenservice\sysdata\data\custyymm DBase Prod
 if file("\kenservice\data\shiftcoy.dbf")
   ERASE   \kenservice\data\shiftcoy.dbf
     endif
   if file("\kenservice\data\shiftcoy.mdx")
   ERASE   \kenservice\data\shiftcoy.mdx
   endif
 
 if file("\kenservice\data\shiftcla.dbf")
   ERASE   \kenservice\data\shiftcla.dbf
   endif
   if file("\kenservice\data\shiftcla.mdx")
   ERASE   \kenservice\data\shiftcla.mdx
   endif
   
    use \kenservice\sysdata\data\shiftcoy.dbf
 copy stru to \kenservice\data\shiftcoy DBase Prod

USE \KENSERVE\IDSSYS\FGCEN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGCEN.DBF
COPY STRU TO \KENSERVICE\DATA\FGCEN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGCEN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGCEN.DBF
USE \KENSERVE\IDSSYS\FGCEN.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fghqstrn.dbf")
use \kenserve\idssys\fghqstrn.dbf
copy stru to \kenservice\data\fghqstrn dbase prod
endif
USE \KENSERVE\IDSSYS\fghqstrn.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fghqstrn.DBF
COPY STRU TO \KENSERVICE\DATA\fghqstrn DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fghqstrn.DBF
APPE FROM  \KENSERVE\IDSSYS\fghqstrn.DBF
USE \KENSERVE\IDSSYS\fghqstrn.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmtyp.dbf")
use \kenserve\idssys\fgmtyp.dbf
copy stru to \kenservice\data\fgmtyp dbase prod
endif
USE \KENSERVE\IDSSYS\fgmtyp.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmtyp.DBF
COPY STRU TO \KENSERVICE\DATA\fgmtyp DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmtyp.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmtyp.DBF
USE \KENSERVE\IDSSYS\fgmtyp.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgcprice.dbf")
use \kenserve\idssys\fgcprice.dbf
copy stru to \kenservice\data\fgcprice dbase prod
endif
USE \KENSERVE\IDSSYS\fgcprice.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgcprice.DBF
COPY STRU TO \KENSERVICE\DATA\fgcprice DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgcprice.DBF
APPE FROM  \KENSERVE\IDSSYS\fgcprice.DBF
USE \KENSERVE\IDSSYS\fgcprice.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgsprice.dbf")
use \kenserve\idssys\fgsprice.dbf
copy stru to \kenservice\data\fgsprice dbase prod
endif
USE \KENSERVE\IDSSYS\fgsprice.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgsprice.DBF
COPY STRU TO \KENSERVICE\DATA\fgsprice DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgsprice.DBF
APPE FROM  \KENSERVE\IDSSYS\fgsprice.DBF
USE \KENSERVE\IDSSYS\fgsprice.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmtyps.dbf")
use \kenserve\idssys\fgmtyps.dbf
copy stru to \kenservice\data\fgmtyps dbase prod
endif
USE \KENSERVE\IDSSYS\fgmtyps.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmtyps.DBF
COPY STRU TO \KENSERVICE\DATA\fgmtyps DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmtyps.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmtyps.DBF
USE \KENSERVE\IDSSYS\fgmtyps.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmcod.dbf")
use \kenserve\idssys\fgmcod.dbf
copy stru to \kenservice\data\fgmcod dbase prod
endif
USE \KENSERVE\IDSSYS\fgmcod.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmcod.DBF
COPY STRU TO \KENSERVICE\DATA\fgmcod DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmcod.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmcod.DBF
USE \KENSERVE\IDSSYS\fgmcod.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgdasals.dbf")
use \kenserve\idssys\fgdasals.dbf
copy stru to \kenservice\data\fgdasals dbase prod
endif
USE \KENSERVE\IDSSYS\fgdasals.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgdasals.DBF
COPY STRU TO \KENSERVICE\DATA\fgdasals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgdasals.DBF
APPE FROM  \KENSERVE\IDSSYS\fgdasals.DBF
USE \KENSERVE\IDSSYS\fgdasals.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmcods.dbf")
use \kenserve\idssys\fgmcods.dbf
copy stru to \kenservice\data\fgmcods dbase prod
endif
USE \KENSERVE\IDSSYS\fgmcods.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmcods.DBF
COPY STRU TO \KENSERVICE\DATA\fgmcods DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmcods.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmcods.DBF
USE \KENSERVE\IDSSYS\fgmcods.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fgmcust.dbf")
use \kenserve\idssys\fgmcust.dbf
copy stru to \kenservice\data\fgmcust dbase prod
endif
USE \KENSERVE\IDSSYS\fgmcust.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmcust.DBF
COPY STRU TO \KENSERVICE\DATA\fgmcust DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmcust.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmcust.DBF
USE \KENSERVE\IDSSYS\fgmcust.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fghqsals.dbf")
use \kenserve\idssys\fghqsals.dbf
copy stru to \kenservice\data\fghqsals dbase prod
endif
USE \KENSERVE\IDSSYS\fghqsals.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fghqsals.DBF
COPY STRU TO \KENSERVICE\DATA\fghqsals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fghqsals.DBF
APPE FROM  \KENSERVE\IDSSYS\fghqsals.DBF
USE \KENSERVE\IDSSYS\fghqsals.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fgmcusts.dbf")
use \kenserve\idssys\fgmcusts.dbf
copy stru to \kenservice\data\fgmcusts dbase prod
endif
USE \KENSERVE\IDSSYS\fgmcusts.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmcusts.DBF
COPY STRU TO \KENSERVICE\DATA\fgmcusts DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmcusts.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmcusts.DBF
USE \KENSERVE\IDSSYS\fgmcusts.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgplant.dbf")
use \kenserve\idssys\fgplant.dbf
copy stru to \kenservice\data\fgplant dbase prod
endif
USE \KENSERVE\IDSSYS\fgplant.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgplant.DBF
COPY STRU TO \KENSERVICE\DATA\fgplant DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgplant.DBF
APPE FROM  \KENSERVE\IDSSYS\fgplant.DBF
USE \KENSERVE\IDSSYS\fgplant.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgplants.dbf")
use \kenserve\idssys\fgplants.dbf
copy stru to \kenservice\data\fgplants dbase prod
endif
USE \KENSERVE\IDSSYS\fgplants.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgplants.DBF
COPY STRU TO \KENSERVICE\DATA\fgplants DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgplants.DBF
APPE FROM  \KENSERVE\IDSSYS\fgplants.DBF
USE \KENSERVE\IDSSYS\fgplants.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fghqoff.dbf")
use \kenserve\idssys\fghqoff.dbf
copy stru to \kenservice\data\fghqoff dbase prod
endif
USE \KENSERVE\IDSSYS\fghqoff.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fghqoff.DBF
COPY STRU TO \KENSERVICE\DATA\fghqoff DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fghqoff.DBF
APPE FROM  \KENSERVE\IDSSYS\fghqoff.DBF
USE \KENSERVE\IDSSYS\fghqoff.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fghqoffs.dbf")
use \kenserve\idssys\fghqoffs.dbf
copy stru to \kenservice\data\fghqoffs dbase prod
endif
USE \KENSERVE\IDSSYS\fghqoffs.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fghqoffs.DBF
COPY STRU TO \KENSERVICE\DATA\fghqoffs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fghqoffs.DBF
APPE FROM  \KENSERVE\IDSSYS\fghqoffs.DBF
USE \KENSERVE\IDSSYS\fghqoffs.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgglpurs.dbf")
use \kenserve\idssys\fgglpurs.dbf
copy stru to \kenservice\data\fgglpurs dbase prod
endif

USE \KENSERVE\IDSSYS\fgtaxtpS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgtaxtpS.DBF
COPY STRU TO \KENSERVICE\DATA\fgtaxtpS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgtaxtpS.DBF
APPE FROM  \KENSERVE\IDSSYS\fgtaxtpS.DBF
USE \KENSERVE\IDSSYS\fgtaxtpS.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\fgtaxtyp.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgtaxtyp.DBF
COPY STRU TO \KENSERVICE\DATA\fgtaxtyp DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgtaxtyp.DBF
APPE FROM  \KENSERVE\IDSSYS\fgtaxtyp.DBF
USE \KENSERVE\IDSSYS\fgtaxtyp.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\fgglpurs.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgglpurs.DBF
COPY STRU TO \KENSERVICE\DATA\fgglpurs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgglpurs.DBF
APPE FROM  \KENSERVE\IDSSYS\fgglpurs.DBF
USE \KENSERVE\IDSSYS\fgglpurs.DBF exclusive
zap
endif
if .not. file("\kenservice\data\cashiers.dbf")
use \kenserve\idssys\cashiers.dbf
copy stru to \kenservice\data\cashiers dbase prod
endif
USE \KENSERVE\IDSSYS\cashiers.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\cashiers.DBF
COPY STRU TO \KENSERVICE\DATA\cashiers DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\cashiers.DBF
APPE FROM  \KENSERVE\IDSSYS\cashiers.DBF
USE \KENSERVE\IDSSYS\cashiers.DBF exclusive
zap
endif
if .not. file("\kenservice\data\nglnlif.dbf")
use \kenserve\idssys\nglnlif.dbf
copy stru to \kenservice\data\nglnlif dbase prod
endif
USE \KENSERVE\IDSSYS\nglnlif.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\nglnlif.DBF
COPY STRU TO \KENSERVICE\DATA\nglnlif DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\nglnlif.DBF
APPE FROM  \KENSERVE\IDSSYS\nglnlif.DBF
USE \KENSERVE\IDSSYS\nglnlif.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgoffsal.dbf")
use \kenserve\idssys\fgoffsal.dbf
copy stru to \kenservice\data\fgoffsal dbase prod
endif
USE \KENSERVE\IDSSYS\fgoffsal.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgoffsal.DBF
COPY STRU TO \KENSERVICE\DATA\fgoffsal DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgoffsal.DBF
APPE FROM  \KENSERVE\IDSSYS\fgoffsal.DBF
USE \KENSERVE\IDSSYS\fgoffsal.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fgoff.dbf")
use \kenserve\idssys\fgoff.dbf
copy stru to \kenservice\data\fgoff dbase prod
endif
USE \KENSERVE\IDSSYS\fgoff.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgoff.DBF
COPY STRU TO \KENSERVICE\DATA\fgoff DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgoff.DBF
APPE FROM  \KENSERVE\IDSSYS\fgoff.DBF
USE \KENSERVE\IDSSYS\fgoff.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgoffs.dbf")
use \kenserve\idssys\fgoffs.dbf
copy stru to \kenservice\data\fgoffs dbase prod
endif
SET SAFETY OFF
USE \KENSERVE\IDSSYS\fgoffs.DBF  EXCLUSIVE
COPY STRU TO \KENSERVICE\DATA\fgoffs DBASE PROD
USE \KENSERVICE\DATA\fgoffs.DBF
APPEND FROM \KENSERVICE\DATA\fgoff.DBF

if .not. file("\kenservice\data\daysal.dbf")
use \kenserve\idssys\daysal.dbf
copy stru to \kenservice\data\daysal dbase prod
endif
USE \KENSERVE\IDSSYS\daysal.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\daysal.DBF
COPY STRU TO \KENSERVICE\DATA\daysal DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\daysal.DBF
APPE FROM  \KENSERVE\IDSSYS\daysal.DBF
USE \KENSERVE\IDSSYS\daysal.DBF exclusive
zap
endif
if .not. file("\kenservice\data\shiftsal.dbf")
use \kenserve\idssys\shiftsal.dbf
copy stru to \kenservice\data\shiftsal dbase prod
endif
USE \KENSERVE\IDSSYS\shiftsal.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\shiftsal.DBF
COPY STRU TO \KENSERVICE\DATA\shiftsal DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\shiftsal.DBF
APPE FROM  \KENSERVE\IDSSYS\shiftsal.DBF
USE \KENSERVE\IDSSYS\shiftsal.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgpitsvc.dbf")
use \kenserve\idssys\fgpitsvc.dbf
copy stru to \kenservice\data\fgpitsvc dbase prod
endif
USE \KENSERVE\IDSSYS\fgpitsvc.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgpitsvc.DBF
COPY STRU TO \KENSERVICE\DATA\fgpitsvc DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgpitsvc.DBF
APPE FROM  \KENSERVE\IDSSYS\fgpitsvc.DBF
USE \KENSERVE\IDSSYS\fgpitsvc.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmastf.dbf")
use \kenserve\idssys\fgmastf.dbf
copy stru to \kenservice\data\fgmastf dbase prod
endif
USE \KENSERVE\IDSSYS\fgmastf.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmastf.DBF
COPY STRU TO \KENSERVICE\DATA\fgmastf DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmastf.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmastf.DBF
USE \KENSERVE\IDSSYS\fgmastf.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgstkflw.dbf")
use \kenserve\idssys\fgstkflw.dbf
copy stru to \kenservice\data\fgstkflw dbase prod
endif
USE \KENSERVE\IDSSYS\fgstkflw.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgstkflw.DBF
COPY STRU TO \KENSERVICE\DATA\fgstkflw DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgstkflw.DBF
APPE FROM  \KENSERVE\IDSSYS\fgstkflw.DBF
USE \KENSERVE\IDSSYS\fgstkflw.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgfcsals.dbf")
use \kenserve\idssys\fgfcsals.dbf
copy stru to \kenservice\data\fgfcsals dbase prod
endif
USE \KENSERVE\IDSSYS\fgfcsals.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgfcsals.DBF
COPY STRU TO \KENSERVICE\DATA\fgfcsals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgfcsals.DBF
APPE FROM  \KENSERVE\IDSSYS\fgfcsals.DBF
USE \KENSERVE\IDSSYS\fgfcsals.DBF exclusive
zap
endif
if .not. file("\kenservice\data\shiftmtr.dbf")
use \kenserve\idssys\shiftmtr.dbf
copy stru to \kenservice\data\shiftmtr dbase prod
endif
USE \KENSERVE\IDSSYS\shiftmtr.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\shiftmtr.DBF
COPY STRU TO \KENSERVICE\DATA\shiftmtr DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\shiftmtr.DBF
APPE FROM  \KENSERVE\IDSSYS\shiftmtr.DBF
USE \KENSERVE\IDSSYS\shiftmtr.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgmonsal.dbf")
use \kenserve\idssys\fgmonsal.dbf
copy stru to \kenservice\data\fgmonsal dbase prod
endif
USE \KENSERVE\IDSSYS\fgmonsal.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmonsal.DBF
COPY STRU TO \KENSERVICE\DATA\fgmonsal DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmonsal.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmonsal.DBF
USE \KENSERVE\IDSSYS\fgmonsal.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fgstkcal.dbf")
use \kenserve\idssys\fgstkcal.dbf
copy stru to \kenservice\data\fgstkcal dbase prod
endif
USE \KENSERVE\IDSSYS\fgstkcal.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgstkcal.DBF
COPY STRU TO \KENSERVICE\DATA\fgstkcal DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgstkcal.DBF
APPE FROM  \KENSERVE\IDSSYS\fgstkcal.DBF
USE \KENSERVE\IDSSYS\fgstkcal.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fgdasal.dbf")
use \kenserve\idssys\fgdasal.dbf
copy stru to \kenservice\data\fgdasal dbase prod
endif
USE \KENSERVE\IDSSYS\fgdasal.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgdasal.DBF
COPY STRU TO \KENSERVICE\DATA\fgdasal DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgdasal.DBF
APPE FROM  \KENSERVE\IDSSYS\fgdasal.DBF
USE \KENSERVE\IDSSYS\fgdasal.DBF exclusive
zap
endif
if .not. file("\kenservice\data\dayfgmas.dbf")
use \kenserve\idssys\dayfgmas.dbf
copy stru to \kenservice\data\dayfgmas dbase prod
endif
USE \KENSERVE\IDSSYS\dayfgmas.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\dayfgmas.DBF
COPY STRU TO \KENSERVICE\DATA\dayfgmas DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\dayfgmas.DBF
APPE FROM  \KENSERVE\IDSSYS\dayfgmas.DBF
USE \KENSERVE\IDSSYS\dayfgmas.DBF exclusive
zap
endif
if .not. file("\kenservice\data\monsales.dbf")
use \kenserve\idssys\monsales.dbf
copy stru to \kenservice\data\monsales dbase prod
endif
USE \KENSERVE\IDSSYS\monsales.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\monsales.DBF
COPY STRU TO \KENSERVICE\DATA\monsales DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\monsales.DBF
APPE FROM  \KENSERVE\IDSSYS\monsales.DBF
USE \KENSERVE\IDSSYS\monsales.DBF exclusive
zap
endif

if .not. file("\kenservice\data\monpurch.dbf")
use \kenserve\idssys\monpurch.dbf
copy stru to \kenservice\data\monpurch dbase prod
endif
USE \KENSERVE\IDSSYS\monpurch.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\monpurch.DBF
COPY STRU TO \KENSERVICE\DATA\monpurch DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\monpurch.DBF
APPE FROM  \KENSERVE\IDSSYS\monpurch.DBF
USE \KENSERVE\IDSSYS\monpurch.DBF exclusive
zap
endif


    use \kenserve\idssys\st15fwkf.dbf
 copy stru to \kenservice\data\st15fwkf DBase Prod
if .not. file("\kenservice\data\FGTRNSP.DBf")
use \kenserve\idssys\FGTRNSP.DBf
copy stru to \kenservice\data\FGTRNSP dbase prod
endif

if .not. file("\kenservice\data\FGTRNSPS.DBf")
use \kenserve\idssys\FGTRNSPS.DBf
copy stru to \kenservice\data\FGTRNSPS dbase prod
endif
 use \kenservice\sysdata\data\shiftcla.dbf
 copy stru to \kenservice\data\shiftcla DBase Prod

 
     use \kenserve\IDSSYS\FGMASTP.dbf
 copy stru to \kenservice\data\FGMASTP DBase Prod


     use \kenserve\IDSSYS\appymts.dbf
 copy stru to \kenservice\data\appymts DBase Prod


     use \kenserve\IDSSYS\frcustat.dbf
 copy stru to \kenservice\data\frcustat DBase Prod


USE \KENSERVE\IDSSYS\FGSHTRAN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGSHTRAN.DBF
COPY STRU TO \KENSERVICE\DATA\FGSHTRAN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGSHTRAN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGSHTRAN.DBF
USE \KENSERVE\IDSSYS\FGSHTRAN.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\FGCODS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGCODS.DBF
COPY STRU TO \KENSERVICE\DATA\FGCODS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGCODS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGCODS.DBF
USE \KENSERVE\IDSSYS\FGCODS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGTYPS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGTYPS.DBF
COPY STRU TO \KENSERVICE\DATA\FGTYPS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGTYPS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGTYPS.DBF
USE \KENSERVE\IDSSYS\FGTYPS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGCLAS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGCLAS.DBF
COPY STRU TO \KENSERVICE\DATA\FGCLAS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGCLAS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGCLAS.DBF
USE \KENSERVE\IDSSYS\FGCLAS.DBF exclusive
zap
endif
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
USE \KENSERVE\IDSSYS\FGCENS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGCENS.DBF
COPY STRU TO \KENSERVICE\DATA\FGCENS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGCENS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGCENS.DBF
USE \KENSERVE\IDSSYS\FGCENS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGDIV.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGDIV.DBF
COPY STRU TO \KENSERVICE\DATA\FGDIV DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGDIV.DBF
APPE FROM  \KENSERVE\IDSSYS\FGDIV.DBF
USE \KENSERVE\IDSSYS\FGDIV.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGDIVS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGDIVS.DBF
COPY STRU TO \KENSERVICE\DATA\FGDIVS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGDIVS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGDIVS.DBF
USE \KENSERVE\IDSSYS\FGDIVS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\STSTOS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\STSTOS.DBF
COPY STRU TO \KENSERVICE\DATA\STSTOS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\STSTOS.DBF
APPE FROM  \KENSERVE\IDSSYS\STSTOS.DBF
USE \KENSERVE\IDSSYS\STSTOS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\STSTO.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\STSTO.DBF
COPY STRU TO \KENSERVICE\DATA\STSTO DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\STSTO.DBF
APPE FROM  \KENSERVE\IDSSYS\STSTO.DBF
USE \KENSERVE\IDSSYS\STSTO.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fgmmperf.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmmperf.DBF
COPY STRU TO \KENSERVICE\DATA\fgmmperf DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmmperf.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmmperf.DBF
USE \KENSERVE\IDSSYS\fgmmperf.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\shstmast.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\shstmast.DBF
COPY STRU TO \KENSERVICE\DATA\shstmast DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\shstmast.DBF
APPE FROM  \KENSERVE\IDSSYS\shstmast.DBF
USE \KENSERVE\IDSSYS\shstmast.DBF exclusive
zap
endif
if .not. file("\kenservice\data\mocoysum.dbf")
use \kenserve\idssys\mocoysum.dbf
copy stru to \kenservice\data\mocoysum dbase prod
endif
USE \KENSERVE\IDSSYS\mocoysum.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\mocoysum.DBF
COPY STRU TO \KENSERVICE\DATA\mocoysum DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\mocoysum.DBF
APPE FROM  \KENSERVE\IDSSYS\mocoysum.DBF
USE \KENSERVE\IDSSYS\mocoysum.DBF exclusive
zap
endif

if .not. file("\kenservice\data\ancoysum.dbf")
use \kenserve\idssys\ancoysum.dbf
copy stru to \kenservice\data\ancoysum dbase prod
endif
USE \KENSERVE\IDSSYS\ancoysum.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ancoysum.DBF
COPY STRU TO \KENSERVICE\DATA\ancoysum DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ancoysum.DBF
APPE FROM  \KENSERVE\IDSSYS\ancoysum.DBF
USE \KENSERVE\IDSSYS\ancoysum.DBF exclusive
zap
endif

if .not. file("\kenservice\data\arwinvce.dbf")
use \kenserve\idssys\arwinvce.dbf
copy stru to \kenservice\data\arwinvce dbase prod
endif
USE \KENSERVE\IDSSYS\arwinvce.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\arwinvce.DBF
COPY STRU TO \KENSERVICE\DATA\arwinvce DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\arwinvce.DBF
APPE FROM  \KENSERVE\IDSSYS\arwinvce.DBF
USE \KENSERVE\IDSSYS\arwinvce.DBF exclusive
zap
endif
if .not. file("\kenservice\data\jnwinvce.dbf")
use \kenserve\idssys\jnwinvce.dbf
copy stru to \kenservice\data\jnwinvce dbase prod
endif
USE \KENSERVE\IDSSYS\jnwinvce.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\jnwinvce.DBF
COPY STRU TO \KENSERVICE\DATA\jnwinvce DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\jnwinvce.DBF
APPE FROM  \KENSERVE\IDSSYS\jnwinvce.DBF
USE \KENSERVE\IDSSYS\jnwinvce.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fglpsals.dbf")
use \kenserve\idssys\fglpsals.dbf
copy stru to \kenservice\data\fglpsals dbase prod
endif
USE \KENSERVE\IDSSYS\fglpsals.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fglpsals.DBF
COPY STRU TO \KENSERVICE\DATA\fglpsals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fglpsals.DBF
APPE FROM  \KENSERVE\IDSSYS\fglpsals.DBF
USE \KENSERVE\IDSSYS\fglpsals.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fglusals.dbf")
use \kenserve\idssys\fglusals.dbf
copy stru to \kenservice\data\fglusals dbase prod
endif
USE \KENSERVE\IDSSYS\fglusals.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fglusals.DBF
COPY STRU TO \KENSERVICE\DATA\fglusals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fglusals.DBF
APPE FROM  \KENSERVE\IDSSYS\fglusals.DBF
USE \KENSERVE\IDSSYS\fglusals.DBF exclusive
zap
endif
if .not. file("\kenservice\data\fgjcsals.dbf")
use \kenserve\idssys\fgjcsals.dbf
copy stru to \kenservice\data\fgjcsals dbase prod
endif
USE \KENSERVE\IDSSYS\fgjcsals.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgjcsals.DBF
COPY STRU TO \KENSERVICE\DATA\fgjcsals DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgjcsals.DBF
APPE FROM  \KENSERVE\IDSSYS\fgjcsals.DBF
USE \KENSERVE\IDSSYS\fgjcsals.DBF exclusive
zap
endif

if .not. file("\kenservice\data\fgviscad.dbf")
use \kenserve\idssys\fgviscad.dbf
copy stru to \kenservice\data\fgviscad dbase prod
endif
USE \KENSERVE\IDSSYS\fgviscad.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgviscad.DBF
COPY STRU TO \KENSERVICE\DATA\fgviscad DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgviscad.DBF
APPE FROM  \KENSERVE\IDSSYS\fgviscad.DBF
USE \KENSERVE\IDSSYS\fgviscad.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGLPGCAD.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGLPGCAD.DBF
COPY STRU TO \KENSERVICE\DATA\FGLPGCAD DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGLPGCAD.DBF
APPE FROM  \KENSERVE\IDSSYS\FGLPGCAD.DBF
USE \KENSERVE\IDSSYS\FGLPGCAD.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\arnivces.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\arnivces.DBF
COPY STRU TO \KENSERVICE\DATA\arnivces DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\arnivces.DBF
APPE FROM  \KENSERVE\IDSSYS\arnivces.DBF
USE \KENSERVE\IDSSYS\arnivces.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGNCLPGS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGNCLPGS.DBF
COPY STRU TO \KENSERVICE\DATA\FGNCLPGS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGNCLPGS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGNCLPGS.DBF
USE \KENSERVE\IDSSYS\FGNCLPGS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGNJCADS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGNJCADS.DBF
COPY STRU TO \KENSERVICE\DATA\FGNJCADS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGNJCADS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGNJCADS.DBF
USE \KENSERVE\IDSSYS\FGNJCADS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\ARNICADS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ARNICADS.DBF
COPY STRU TO \KENSERVICE\DATA\ARNICADS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ARNICADS.DBF
APPE FROM  \KENSERVE\IDSSYS\ARNICADS.DBF
USE \KENSERVE\IDSSYS\ARNICADS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\arniclin.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\arniclin.DBF
COPY STRU TO \KENSERVICE\DATA\arniclin DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\arniclin.DBF
APPE FROM  \KENSERVE\IDSSYS\arniclin.DBF
USE \KENSERVE\IDSSYS\arniclin.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fragedrs.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fragedrs.DBF
COPY STRU TO \KENSERVICE\DATA\fragedrs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fragedrs.DBF
APPE FROM  \KENSERVE\IDSSYS\fragedrs.DBF
USE \KENSERVE\IDSSYS\fragedrs.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fragecrs.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fragecrs.DBF
COPY STRU TO \KENSERVICE\DATA\fragecrs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fragecrs.DBF
APPE FROM  \KENSERVE\IDSSYS\fragecrs.DBF
USE \KENSERVE\IDSSYS\fragecrs.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\FGPRINT.DBF  EXCLUSIVE
ZAP
go top
APPEND FROM \KENSERVICE\DATA\FGPRINT.DBF
COPY STRU TO \KENSERVICE\DATA\FGPRINT DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGPRINT.DBF
APPE FROM  \KENSERVE\IDSSYS\FGPRINT.DBF
USE \KENSERVE\IDSSYS\FGPRINT.DBF exclusive
zap

USE \KENSERVE\IDSSYS\FRMODEBT.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FRMODEBT.DBF
COPY STRU TO \KENSERVICE\DATA\FRMODEBT DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRMODEBT.DBF
APPE FROM  \KENSERVE\IDSSYS\FRMODEBT.DBF
USE \KENSERVE\IDSSYS\FRMODEBT.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\fgdacash.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgdacash.DBF
COPY STRU TO \KENSERVICE\DATA\fgdacash DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgdacash.DBF
APPE FROM  \KENSERVE\IDSSYS\fgdacash.DBF
USE \KENSERVE\IDSSYS\fgdacash.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\fgmocash.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgmocash.DBF
COPY STRU TO \KENSERVICE\DATA\fgmocash DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgmocash.DBF
APPE FROM  \KENSERVE\IDSSYS\fgmocash.DBF
USE \KENSERVE\IDSSYS\fgmocash.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\ARINVS.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ARINVS.DBF
COPY STRU TO \KENSERVICE\DATA\ARINVS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ARINVS.DBF
APPE FROM  \KENSERVE\IDSSYS\ARINVS.DBF
USE \KENSERVE\IDSSYS\ARINVS.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGINVTRN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGINVTRN.DBF
COPY STRU TO \KENSERVICE\DATA\FGINVTRN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGINVTRN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGINVTRN.DBF
USE \KENSERVE\IDSSYS\FGINVTRN.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\FGJOBCAD.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGJOBCAD.DBF
COPY STRU TO \KENSERVICE\DATA\FGJOBCAD DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGJOBCAD.DBF
APPE FROM  \KENSERVE\IDSSYS\FGJOBCAD.DBF
USE \KENSERVE\IDSSYS\FGJOBCAD.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\fgnjclin.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgnjclin.DBF
COPY STRU TO \KENSERVICE\DATA\fgnjclin DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgnjclin.DBF
APPE FROM  \KENSERVE\IDSSYS\fgnjclin.DBF
USE \KENSERVE\IDSSYS\fgnjclin.DBF exclusive
zap
endif

IF .NOT. FILE('\KENSERVICE\DATA\FRMTRAGE.DBF')
USE \KENSERVE\IDSSYS\FRMTRAGE.DBF 
COPY STRU TO \KENSERVICE\DATA\FRMTRAGE DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\FRMTRAGE.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FRMTRAGE.DBF
COPY STRU TO \KENSERVICE\DATA\FRMTRAGE DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRMTRAGE.DBF
APPE FROM  \KENSERVE\IDSSYS\FRMTRAGE.DBF
USE \KENSERVE\IDSSYS\FRMTRAGE.DBF exclusive
zap
endif
IF .NOT. FILE('\KENSERVICE\DATA\FRMTRBAL.DBF')
USE \KENSERVE\IDSSYS\FRMTRBAL.DBF 
COPY STRU TO \KENSERVICE\DATA\FRMTRBAL DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\FRMTRBAL.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FRMTRBAL.DBF
COPY STRU TO \KENSERVICE\DATA\FRMTRBAL DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRMTRBAL.DBF
APPE FROM  \KENSERVE\IDSSYS\FRMTRBAL.DBF
USE \KENSERVE\IDSSYS\FRMTRBAL.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FRDDEBTP.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FRDDEBTP.DBF
COPY STRU TO \KENSERVICE\DATA\FRDDEBTP DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRDDEBTP.DBF
APPE FROM  \KENSERVE\IDSSYS\FRDDEBTP.DBF
USE \KENSERVE\IDSSYS\FRDDEBTP.DBF exclusive
zap
endif

 USE \KENSERVE\IDSSYS\fgadasto.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgadasto.DBF
COPY STRU TO \KENSERVICE\DATA\fgadasto DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgadasto.DBF
APPE FROM  \KENSERVE\IDSSYS\fgadasto.DBF
USE \KENSERVE\IDSSYS\fgadasto.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGTRAN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGTRAN.DBF
COPY STRU TO \KENSERVICE\DATA\FGTRAN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGTRAN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGTRAN.DBF
USE \KENSERVE\IDSSYS\FGTRAN.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\FGNFPUR.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FGNFPUR.DBF
COPY STRU TO \KENSERVICE\DATA\FGNFPUR DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGNFPUR.DBF
APPE FROM  \KENSERVE\IDSSYS\FGNFPUR.DBF

USE \KENSERVE\IDSSYS\FGNFPUR.DBF exclusive
zap
endif

 if .not.  file("\kenservice\data\fgtrand.dbf")
    USE \KENSERVE\IDSSYS\FGTRAND.DBF
copy stru to \kenservice\data\fgtrand dBase prod
endif
USE \KENSERVE\IDSSYS\FGTRAND.DBF  EXCLUSIVE
go top
if eof() 
APPEND FROM \KENSERVICE\DATA\FGTRAND.DBF
COPY STRU TO \KENSERVICE\DATA\FGTRAND DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGTRAND.DBF
APPE FROM  \KENSERVE\IDSSYS\FGTRAND.DBF
USE \KENSERVE\IDSSYS\FGTRAND.DBF exclusive
zap
endif


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

USE \KENSERVE\IDSSYS\NLCASH.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NLCASH.DBF
COPY STRU TO \KENSERVICE\DATA\NLCASH DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NLCASH.DBF
APPE FROM  \KENSERVE\IDSSYS\NLCASH.DBF
USE \KENSERVE\IDSSYS\NLCASH.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\FRIGHTER.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\FRIGHTER.DBF
COPY STRU TO \KENSERVICE\DATA\FRIGHTER DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRIGHTER.DBF
APPE FROM  \KENSERVE\IDSSYS\FRIGHTER.DBF
USE \KENSERVE\IDSSYS\FRIGHTER.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\VENDOR.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\VENDOR.DBF
COPY STRU TO \KENSERVICE\DATA\VENDOR DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\VENDOR.DBF
APPE FROM  \KENSERVE\IDSSYS\VENDOR.DBF
USE \KENSERVE\IDSSYS\VENDOR.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\NLCASHC.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NLCASHC.DBF
COPY STRU TO \KENSERVICE\DATA\NLCASHC DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NLCASHC.DBF
APPE FROM  \KENSERVE\IDSSYS\NLCASHC.DBF
USE \KENSERVE\IDSSYS\NLCASHC.DBF exclusive
zap
endif



USE \KENSERVE\IDSSYS\NLBANK.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NLBANK.DBF
COPY STRU TO \KENSERVICE\DATA\NLBANK DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NLBANK.DBF
APPE FROM  \KENSERVE\IDSSYS\NLBANK.DBF
USE \KENSERVE\IDSSYS\NLBANK.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\NLBANKC.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NLBANKC.DBF
COPY STRU TO \KENSERVICE\DATA\NLBANKC DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NLBANKC.DBF
APPE FROM  \KENSERVE\IDSSYS\NLBANKC.DBF
USE \KENSERVE\IDSSYS\NLBANKC.DBF exclusive
zap
endif



USE \KENSERVE\IDSSYS\NGLTRAN.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NGLTRAN.DBF
COPY STRU TO \KENSERVICE\DATA\NGLTRAN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NGLTRAN.DBF
APPE FROM  \KENSERVE\IDSSYS\NGLTRAN.DBF
USE \KENSERVE\IDSSYS\NGLTRAN.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\NGLMAST.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NGLMAST.DBF
COPY STRU TO \KENSERVICE\DATA\NGLMAST DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NGLMAST.DBF
APPE FROM  \KENSERVE\IDSSYS\NGLMAST.DBF
USE \KENSERVE\IDSSYS\NGLMAST.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\ngfgnlif.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\ngfgnlif.DBF
COPY STRU TO \KENSERVICE\DATA\ngfgnlif DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ngfgnlif.DBF
APPE FROM  \KENSERVE\IDSSYS\ngfgnlif.DBF
USE \KENSERVE\IDSSYS\ngfgnlif.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\NGTRIALB.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\NGTRIALB.DBF
COPY STRU TO \KENSERVICE\DATA\NGTRIALB DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\NGTRIALB.DBF
APPE FROM  \KENSERVE\IDSSYS\NGTRIALB.DBF
USE \KENSERVE\IDSSYS\NGTRIALB.DBF exclusive
zap
endif



USE \KENSERVE\IDSSYS\fgcla.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgcla.DBF
COPY STRU TO \KENSERVICE\DATA\fgcla DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgcla.DBF
APPE FROM  \KENSERVE\IDSSYS\fgcla.DBF
USE \KENSERVE\IDSSYS\fgcla.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fgcod.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgcod.DBF
COPY STRU TO \KENSERVICE\DATA\fgcod DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgcod.DBF
APPE FROM  \KENSERVE\IDSSYS\fgcod.DBF
USE \KENSERVE\IDSSYS\fgcod.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\fgtyp.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\fgtyp.DBF
COPY STRU TO \KENSERVICE\DATA\fgtyp DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgtyp.DBF
APPE FROM  \KENSERVE\IDSSYS\fgtyp.DBF
USE \KENSERVE\IDSSYS\fgtyp.DBF exclusive
zap
endif
IF FILE("\KENSERVE\IDSSYS\SHIFTBK.DBF")
USE \KENSERVE\IDSSYS\SHIFTBK.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\SHIFTBK.DBF
COPY STRU TO \KENSERVICE\DATA\SHIFTBK DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\SHIFTBK.DBF
APPE FROM  \KENSERVE\IDSSYS\SHIFTBK.DBF
USE \KENSERVE\IDSSYS\SHIFTBK.DBF exclusive
zap
ELSE
IF .NOT. FILE("\KENSERVICE\DATA\SHIFTBK.DBF")
CLOSE DATABASES
RENAME TABLE \KENSERVE\IDSSYS\SHIFTBK.DBF TO \KENSERVICE\DATA\SHIFTBK.DBF
ENDIF
endif
ENDIF

  if .not.  file("\kenservice\data\arccvisa.dbf")
    USE \KENSERVE\IDSSYS\arccvisa.DBF
copy stru to \kenservice\data\arccvisa dBase prod
endif

USE \KENSERVE\IDSSYS\arccvisa.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\arccvisa.DBF
COPY STRU TO \KENSERVICE\DATA\arccvisa DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\arccvisa.DBF
APPE FROM  \KENSERVE\IDSSYS\arccvisa.DBF
USE \KENSERVE\IDSSYS\arccvisa.DBF exclusive
zap
endif


USE \KENSERVE\IDSSYS\dacasrec.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\dacasrec.DBF
COPY STRU TO \KENSERVICE\DATA\dacasrec DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\dacasrec.DBF
APPE FROM  \KENSERVE\IDSSYS\dacasrec.DBF
USE \KENSERVE\IDSSYS\dacasrec.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\HCASHREC.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\HCASHREC.DBF
COPY STRU TO \KENSERVICE\DATA\HCASHREC DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\HCASHREC.DBF
APPE FROM  \KENSERVE\IDSSYS\HCASHREC.DBF
USE \KENSERVE\IDSSYS\HCASHREC.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FGTRNREF.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGTRNREF.DBF
COPY STRU TO \KENSERVICE\DATA\FGTRNREF DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGTRNREF.DBF
APPE FROM  \KENSERVE\IDSSYS\FGTRNREF.DBF
USE \KENSERVE\IDSSYS\FGTRNREF.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\shiftwet.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\shiftwet.DBF
COPY STRU TO \KENSERVICE\DATA\shiftwet DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\shiftwet.DBF
APPE FROM  \KENSERVE\IDSSYS\shiftwet.DBF
USE \KENSERVE\IDSSYS\shiftwet.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\shiftwst.DBF  EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\shiftwst.DBF
COPY STRU TO \KENSERVICE\DATA\shiftwst DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\shiftwst.DBF
APPE FROM  \KENSERVE\IDSSYS\shiftwst.DBF
USE \KENSERVE\IDSSYS\shiftwst.DBF exclusive
zap
endif
IF FILE("\KENSERVE\IDSSYS\DSHIFTBK.DBF")
USE \KENSERVE\IDSSYS\DSHIFTBK.DBF  EXCLUSIVE
go top
if eof()
APPEND FROM \KENSERVICE\DATA\DSHIFTBK.DBF
COPY STRU TO \KENSERVICE\DATA\DSHIFTBK DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\DSHIFTBK.DBF
APPE FROM  \KENSERVE\IDSSYS\DSHIFTBK.DBF
USE \KENSERVE\IDSSYS\DSHIFTBK.DBF exclusive
zap
ELSE
IF .NOT. FILE("\KENSERVICE\DATA\DSHIFTBK.DBF")
CLOSE DATABASES
RENAME TABLE \KENSERVE\IDSSYS\DSHIFTBK.DBF TO \KENSERVICE\DATA\DSHIFTBK.DBF
ENDIF
endif
ENDIF



USE \KENSERVE\IDSSYS\shcatsum.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\shcatsum.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\shcatsum DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\shcatsum.DBF
APPE FROM  \KENSERVE\IDSSYS\shcatsum.DBF
USE \KENSERVE\IDSSYS\shcatsum.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\MSHSTMAS.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\MSHSTMAS.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\MSHSTMAS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\MSHSTMAS.DBF
APPE FROM  \KENSERVE\IDSSYS\MSHSTMAS.DBF
USE \KENSERVE\IDSSYS\MSHSTMAS.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\SHIFTMN.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\SHIFTMN.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\SHIFTMN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\SHIFTMN.DBF
APPE FROM  \KENSERVE\IDSSYS\SHIFTMN.DBF
USE \KENSERVE\IDSSYS\SHIFTMN.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\DSHIFTMN.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\DSHIFTMN.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\DSHIFTMN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\DSHIFTMN.DBF
APPE FROM  \KENSERVE\IDSSYS\DSHIFTMN.DBF
repl all CL_MM_Q_27 WITH 0, OP_MM_Q_27 WITH 0
USE \KENSERVE\IDSSYS\DSHIFTMN.DBF exclusive
zap
endif
IF .NOT. FILE("\KENSERVICE\DATA\FGDATMAS.DBF")
USE  \KENSERVE\IDSSYS\FGDATMAS.DBF
COPY STRU TO \KENSERVICE\DATA\FGDATMAS DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\FGDATMAS.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGDATMAS.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGDATMAS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGDATMAS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGDATMAS.DBF
USE \KENSERVE\IDSSYS\FGDATMAS.DBF exclusive
zap
endif

IF .NOT. FILE("\KENSERVICE\DATA\DACATSUM.DBF")
USE  \KENSERVE\IDSSYS\DACATSUM.DBF
COPY STRU TO \KENSERVICE\DATA\DACATSUM DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\DACATSUM.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\DACATSUM.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\DACATSUM DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\DACATSUM.DBF
APPE FROM  \KENSERVE\IDSSYS\DACATSUM.DBF
USE \KENSERVE\IDSSYS\DACATSUM.DBF exclusive
zap
endif
IF .NOT. FILE("\KENSERVICE\DATA\MONTHSAL.DBF")
USE  \KENSERVE\IDSSYS\MONTHSAL.DBF
COPY STRU TO \KENSERVICE\DATA\MONTHSAL DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\MONTHSAL.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\MONTHSAL.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\MONTHSAL DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\MONTHSAL.DBF
APPE FROM  \KENSERVE\IDSSYS\MONTHSAL.DBF
USE \KENSERVE\IDSSYS\MONTHSAL.DBF exclusive
zap
endif
IF .NOT. FILE("\KENSERVICE\DATA\FGVISTRN.DBF")
USE  \KENSERVE\IDSSYS\FGVISTRN.DBF
COPY STRU TO \KENSERVICE\DATA\FGVISTRN DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\FGVISTRN.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGVISTRN.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGVISTRN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGVISTRN.DBF
APPE FROM  \KENSERVE\IDSSYS\FGVISTRN.DBF
USE \KENSERVE\IDSSYS\FGVISTRN.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\ASHSTMAS.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\ASHSTMAS.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\ASHSTMAS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\ASHSTMAS.DBF
APPE FROM  \KENSERVE\IDSSYS\ASHSTMAS.DBF
USE \KENSERVE\IDSSYS\ASHSTMAS.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\FGMAST.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGMAST.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGMAST DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGMAST.DBF
APPE FROM  \KENSERVE\IDSSYS\FGMAST.DBF
USE \KENSERVE\IDSSYS\FGMAST.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\dacoysum.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\dacoysum.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\dacoysum DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\dacoysum.DBF
APPE FROM  \KENSERVE\IDSSYS\dacoysum.DBF
USE \KENSERVE\IDSSYS\dacoysum.DBF exclusive
zap
endif

close databases
use \kenserve\idssys\querrors.dbf excl
COPY STRU TO \kenservice\idssys\querrors DBASE PROD

use \kenserve\idssys\TRANSERR.dbf excl
COPY STRU TO \kenservice\idssys\TRANSERR DBASE PROD

USE \KENSERVE\IDSSYS\FRSTAT.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FRSTAT.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FRSTAT DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRSTAT.DBF
APPE FROM  \KENSERVE\IDSSYS\FRSTAT.DBF
USE \KENSERVE\IDSSYS\FRSTAT.DBF exclusive
zap
endif
USE \KENSERVE\IDSSYS\FRSHTRN.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FRSHTRN.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FRSHTRN DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FRSHTRN.DBF
APPE FROM  \KENSERVE\IDSSYS\FRSHTRN.DBF
USE \KENSERVE\IDSSYS\FRSHTRN.DBF exclusive
zap
endif
IF .NOT. FILE("\KENSERVICE\DATA\fgvisnos.DBF")
USE  \KENSERVE\IDSSYS\fgvisnos.DBF
COPY STRU TO \KENSERVICE\DATA\fgvisnos DBASE PROD
ENDIF
close databases
USE \KENSERVE\IDSSYS\fgvisnos.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fgvisnos.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fgvisnos DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgvisnos.DBF
APPE FROM  \KENSERVE\IDSSYS\fgvisnos.DBF
USE \KENSERVE\IDSSYS\fgvisnos.DBF exclusive
zap
endif
  IF .NOT. FILE("\KENSERVICE\DATA\frveregs.DBF")
USE  \KENSERVE\IDSSYS\frveregs.DBF
COPY STRU TO \KENSERVICE\DATA\frveregs DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\frveregs.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\frveregs.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\frveregs DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\frveregs.DBF
APPE FROM  \KENSERVE\IDSSYS\frveregs.DBF
USE \KENSERVE\IDSSYS\frveregs.DBF exclusive
zap
endif

IF .NOT. FILE("\KENSERVICE\DATA\FGOFFCAS.DBF")
USE  \KENSERVE\IDSSYS\FGOFFCAS.DBF
COPY STRU TO \KENSERVICE\DATA\FGOFFCAS DBASE PROD
ENDIF
USE \KENSERVE\IDSSYS\FGOFFCAS.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\FGOFFCAS.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\FGOFFCAS DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\FGOFFCAS.DBF
APPE FROM  \KENSERVE\IDSSYS\FGOFFCAS.DBF
USE \KENSERVE\IDSSYS\FGOFFCAS.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\fgcsales.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\fgcsales.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\fgcsales DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\fgcsales.DBF
APPE FROM  \KENSERVE\IDSSYS\fgcsales.DBF
USE \KENSERVE\IDSSYS\fgcsales.DBF exclusive
zap
endif
CLOSE DATABASES
USE \KENSERVE\IDSSYS\VNSTAT.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\VNSTAT.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\VNSTAT DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\VNSTAT.DBF
APPE FROM  \KENSERVE\IDSSYS\VNSTAT.DBF
USE \KENSERVE\IDSSYS\VNSTAT.DBF exclusive
zap
endif

USE \KENSERVE\IDSSYS\DACATPUR.DBF   EXCLUSIVE
go top
if  eof()
APPEND FROM \KENSERVICE\DATA\DACATPUR.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\DACATPUR DBASE PROD
CLOSE DATABASES
USE \KENSERVICE\DATA\DACATPUR.DBF
APPE FROM  \KENSERVE\IDSSYS\DACATPUR.DBF
USE \KENSERVE\IDSSYS\DACATPUR.DBF exclusive
zap
endif
set safety on
      close databases
      progreps.close()
      QUIT

