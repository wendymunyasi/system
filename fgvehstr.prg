procedure fgvehstr
   close databases
   set safety off
   use \kenserve\idssys\fgveh.dbf
copy stru to \kenservice\data\fgveh dbase prod
use \kenserve\idssys\fgvehs.dbf
copy stru to \kenservice\data\fgvehs dbase prod
set safety on
close databases