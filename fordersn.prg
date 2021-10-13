procedure fordersn
set safety off
use  \kenserve\idssys\fordersn.dbf
copy stru to \kenservice\data\fordersn dbase prod
close databases
set safety on