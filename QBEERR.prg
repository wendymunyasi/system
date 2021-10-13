* Visual dBASE .QBE error checking function
PROCEDURE qbeerr
PARAMETERS nERRORno, cErrMessage, cProgram, nLineNo
DEFINE FORM open_qbe_HeadsUp from 5,20 TO 20,100;
PROPERTY MDI .F.,;
TEXT "An Error has occurred in Opening Files - Try Again Later!",;
SYSMENU .F.
DEFINE TEXT Line2 OF open_qbe_HeadsUp AT 3,2;
  PROPERTY Text "Error: " + cErrMessage,;
  Width 100
DEFINE TEXT Line3 OF open_qbe_HeadsUp AT 5,2;
  PROPERTY Text "Number: " + STR(nErrorno),;
  Width 22
DEFINE TEXT Line4 OF open_qbe_HeadsUp AT 7,2;
  PROPERTY Text "Program: "+ cProgram,;
  Width 70
DEFINE TEXT Line5 OF open_qbe_HeadsUp AT 9,2;
  PROPERTY Text "Line #: " + STR(nLineno),;
  Width 22
  DEFINE PUSHBUTTON Line6 OF open_qbe_HeadsUp AT 11,2;
  PROPERTY Text "EXIT",;
  Width 8,;
  ONCLICK {; FORM.CLOSE()}
READMODAL(open_qbe_HeadsUp)
QUIT

