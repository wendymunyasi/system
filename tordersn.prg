procedure tordersn
set safety off
use  \kenserve\idssys\tordersn.dbf
copy stru to \kenservice\data\tordersn dbase prod
close databases
set safety on