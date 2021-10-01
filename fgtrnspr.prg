procedure fgtrnspr
   close databases
   set safety off
   use \kenserve\idssys\fgtrnsp.dbf
copy stru to \kenservice\data\fgtrnsp dbase prod
use \kenserve\idssys\fgtrnsps.dbf
copy stru to \kenservice\data\fgtrnsps dbase prod
set safety on
close databases