*******************************************************************************
*  FILE:         PASWDCON.CC
*
*  WRITTEN BY:   W Nyongesa
*
*  DATE:         10/94
*
*  UPDATED:      03/2015
*
*  REVISION:     $Revision:   1.6  $
*
*  VERSION:      Visual dBASE
*
*  DESCRIPTION:  This file contains a custom control, CNPasswordEntry,
*                which allows entering a password.
*
*  PARAMETERS:   None
*
*  CALLS:        None
*
*  USAGE:        When creating a form, select the "Set Up Custom Controls"
*                menu from the "File" menu.  Then select "Add" button on the
*                "dBASE Custom Controls" page of the "Set Up Custom Controls"
*                dialog. Select this file from the file selection dialog
*                that comes up.  The controls in this file will be available
*                on the "Custom" page of the "Controls" window.
*
*                You must assign a correctCNPassword property in your code
*                by using the SetcorrectCNPassword() method.  After the password
*                is entered, you can verify that it was correct by using the
*                IsenteredCNPasswordOk() method.
*
********************************************************************************
#include <Messdlg.h>

#define BACKSPACE_KEY     8     && -- ASCII value of Backspace key
#define DELETE_KEY        127   && -- ASCII value of Delete key
#define PASSWORD_CHAR     "*"   && -- Character to be displayed for each entered
                                &&    letter of the password


*******************************************************************************
*******************************************************************************
class CNPasswordEntry(f,n) of Entryfield(f,n) custom

*  CONTROL:      Password Entryfield
*
*  DESCRIPTION:  This control allows entering a password, and provides
*                methods that other classes can use to set the password
*                and verify if the password was correct.
*
*******************************************************************************

   this.Border = .T.
   this.Left = 5
   this.PageNo = 1
   this.Value = ""

   this.MaxLength = 15
   this.Top = 3.0
   this.Height = 1
   this.Width = 20
   this.Key = CLASS::CNkey


   ****************************************************************************
   Procedure OnOpen(nChar, nPosition)
   ****************************************************************************

   *** Custom properties
   if type("this.enteredCNPassword") = "U"
      this.enteredCNPassword = ""
      this.correctCNPassword = ""    && This property must be manually assigned
                                   && whereever this control is instantiated
   endif

   *** Protect properties
   protect enteredCNPassword, correctCNPassword


   ****************************************************************************
   Procedure SetcorrectCNPassword(password)

   * Assigns value to this.correctCNPassword
   ****************************************************************************
   private CNpasswordLen

   CNpasswordLen = len(password)
   this.width = CNpasswordLen
   this.maxLength = CNpasswordLen
   this.correctCNPassword = password
   this.enteredCNPassword = ""


   ****************************************************************************
   Function IsenteredCNPasswordOk
   ****************************************************************************

   return (this.enteredCNPassword == this.correctCNPassword)


   ****************************************************************************
   Procedure CNkey(nChar, nPosition)

   * Handles keys entered in the password entryfield
   ****************************************************************************
   private CNenteredChar, CNreturnValue

   CNenteredChar = chr(nChar)
   CNreturnValue = .T.                 && By default output whatever key was typed
   do case                           && Check for keys that modify the value
      case nChar = BACKSPACE_KEY
         this.enteredCNPassword = ;
            stuff(this.enteredCNPassword, nPosition - 1, 1, "")
      case nChar = DELETE_KEY
         this.enteredCNPassword = ;
            stuff(this.enteredCNPassword, nPosition, 1, "")
      otherwise
         if CLASS::IsValidCNChar(CNenteredChar)     && Check if alphanumeric
            this.enteredCNPassword = ;
               stuff(this.enteredCNPassword, nPosition, 1, CNenteredChar)
            CNreturnValue = asc(PASSWORD_CHAR)    && Output camouflage character
         endif
   endcase

   return CNreturnValue


   ****************************************************************************
   Procedure IsValidCNChar(char)

   * Make sure entered key is alphanumeric
   ****************************************************************************
   private CNreturnValue

   do case
      case isalpha(char)                        && Letter?
         CNreturnValue = .T.
      case char >= "0" .and. char <= "9"        && Digit?
         CNreturnValue = .T.
      otherwise                                 && Invalid?
         CNreturnValue = .F.
   endcase

   return CNreturnValue

endclass


