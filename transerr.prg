* Visual dBASE .QBE error checking function
PROCEDURE TRANSERR
PARAMETERS nERRORno, cErrMessage, cProgram, nLineNo
DEFINE FORM Trans_headsUp from 5,20 TO 20,100;
PROPERTY MDI .F.,;
TEXT "An Error has occurred During Transaction Processing - Try Again Later!",;
SYSMENU .F.
DEFINE TEXT Line2 OF Trans_headsUp AT 3,2;
  PROPERTY Text "Error: " + cErrMessage,;
  Width 100
DEFINE TEXT Line3 OF Trans_headsUp AT 5,2;
  PROPERTY Text "Number: " + STR(nErrorno),;
  Width 22
DEFINE TEXT Line4 OF Trans_headsUp AT 7,2;
  PROPERTY Text "Program: "+ cProgram,;
  Width 70
DEFINE TEXT Line5 OF Trans_headsUp AT 9,2;
  PROPERTY Text "Line #: " + STR(nLineno),;
  Width 22
  DEFINE PUSHBUTTON Line6 OF Trans_headsUp AT 11,2;
  PROPERTY Text "EXIT",;
  Width 8,;
  ONCLICK {;ROLLBACK(); FORM.CLOSE()}
READMODAL(Trans_headsUp)
rollback()
if.not.  file("\kenservice\idssys\TRANSERR.dbf")
use \kenserve\idssys\TRANSERR.dbf
copy stru to \kenservice\idssys\TRANSERR dbase prod
endif
use   \kenservice\idssys\TRANSERR.dbf
append blank
repla dde_date with date()
replace dde_time with time()
replace errmsg with cErrMessage
replace errno with nErrorno
replace errprog with cProgram
replace errlno with nLineno
quit