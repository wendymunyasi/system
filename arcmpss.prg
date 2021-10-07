Procedure arcmpss
set safety off
 USE  \kenserve\idssys\arcmpsn.dbf
 copy stru to \kenservice\data\arcmpsn dbase prod
close databases
set safety on
