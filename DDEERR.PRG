* Visual dBASE .QBE error checking function
PROCEDURE ddeerr
on error quit
PARAMETERS nERRORno, cErrMessage, cProgram, nLineNo
DEFINE FORM DDE_hEADSuP from 5,20 TO 20,120;
PROPERTY MDI .F.,;
TEXT "An Error has occurred During Processing of Form - Try Again Later!",;
SYSMENU .F.
DEFINE TEXT Line2 OF DDE_hEADSuP AT 3,2;
  PROPERTY Text "Error: " + cErrMessage,;
  Width 100
  DEFINE TEXT Line3 OF DDE_hEADSuP AT 5,2;
  PROPERTY Text "Number: " + STR(nErrorno),;
  Width 22
DEFINE TEXT Line4 OF DDE_hEADSuP AT 7,2;
  PROPERTY Text "Program: "+ cProgram,;
  Width 70
DEFINE TEXT Line5 OF DDE_hEADSuP AT 9,2;
  PROPERTY Text "Line #: " + STR(nLineno),;
  Width 22
  DEFINE PUSHBUTTON Line6 OF DDE_hEADSuP AT 11,2;
  PROPERTY Text "EXIT",;
  Width 8,;
  ONCLICK {; FORM.CLOSE()}
READMODAL(DDE_hEADSuP)
IF .NOT. ACCESS() = 1
QUIT
ENDIF
cancel