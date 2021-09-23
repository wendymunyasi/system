*******************************************************************************
*  FILE:         passwdc.cc
*
*  WRITTEN BY:   W Nyongesa
*
*  DATE:         10/94
*
*  UPDATED:      10/2009
*
*  REVISION:     $Revision:   1.6  $
*
*  VERSION:      Visual dBASE
*
*  DESCRIPTION:  This file contains a custom control, NPasswordEntry,
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
*                You must assign a correctNPassword property in your code
*                by using the SetcorrectNPassword() method.  After the password
*                is entered, you can verify that it was correct by using the
*                IsenteredNPasswordOk() method.
*
********************************************************************************
#include <Messdlg.h>

#define BACKSPACE_KEY     8     && -- ASCII value of Backspace key
#define DELETE_KEY        127   && -- ASCII value of Delete key
#define PASSWORD_CHAR     "*"   && -- Character to be displayed for each entered
                                &&    letter of the password


*******************************************************************************
*******************************************************************************
class NPasswordEntry(f,n) of Entryfield(f,n) custom

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
   this.Key = CLASS::NKEY


   ****************************************************************************
   Procedure OnOpen(nChar, nPosition)
   ****************************************************************************

   *** Custom properties
   if type("this.enteredNPassword") = "U"
      this.enteredNPassword = ""
      this.correctNPassword = ""    && This property must be manually assigned
                                   && whereever this control is instantiated
   endif

   *** Protect properties
   protect enteredNPassword, correctNPassword


   ****************************************************************************
   Procedure SetcorrectNPassword(password)

   * Assigns value to this.correctNPassword
   ****************************************************************************
   private NpasswordLen

   NpasswordLen = len(password)
   this.width = NpasswordLen
   this.maxLength = NpasswordLen
   this.correctNPassword = password
   this.enteredNPassword = ""


   ****************************************************************************
   Function IsenteredNPasswordOk
   ****************************************************************************

   return (this.enteredNPassword == this.correctNPassword)


   ****************************************************************************
   Procedure Nkey(nChar, nPosition)

   * Handles keys entered in the password entryfield
   ****************************************************************************
   private NenteredChar, NreturnValue

   NenteredChar = chr(nChar)
   NreturnValue = .T.                 && By default output whatever key was typed
   do case                           && Check for keys that modify the value
      case nChar = BACKSPACE_KEY
         this.enteredNPassword = ;
            stuff(this.enteredNPassword, nPosition - 1, 1, "")
      case nChar = DELETE_KEY
         this.enteredNPassword = ;
            stuff(this.enteredNPassword, nPosition, 1, "")
      otherwise
         if CLASS::IsValidNChar(NenteredChar)     && Check if alphanumeric
            this.enteredNPassword = ;
               stuff(this.enteredNPassword, nPosition, 1, NenteredChar)
            NreturnValue = asc(PASSWORD_CHAR)    && Output camouflage character
         endif
   endcase

   return NreturnValue


   ****************************************************************************
   Procedure IsValidNChar(char)

   * Make sure entered key is alphanumeric
   ****************************************************************************
   private NreturnValue

   do case
      case isalpha(char)                        && Letter?
         NreturnValue = .T.
      case char >= "0" .and. char <= "9"        && Digit?
         NreturnValue = .T.
      otherwise                                 && Invalid?
         NreturnValue = .F.
   endcase

   return NreturnValue

endclass


