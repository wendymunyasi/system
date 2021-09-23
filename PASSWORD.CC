*******************************************************************************
*  FILE:         Password.cc
*
*  WRITTEN BY:   Borland Samples Group
*
*  DATE:         10/94
*
*  UPDATED:      03/2015
*
*  REVISION:     $Revision:   1.6  $
*
*  VERSION:      Visual dBASE
*
*  DESCRIPTION:  This file contains a custom control, PasswordEntry,
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
*                You must assign a correctPassword property in your code
*                by using the SetCorrectPassword() method.  After the password
*                is entered, you can verify that it was correct by using the
*                IsEnteredPasswordOk() method.
*
********************************************************************************
#include <Messdlg.h>

#define BACKSPACE_KEY     8     && -- ASCII value of Backspace key
#define DELETE_KEY        127   && -- ASCII value of Delete key
#define PASSWORD_CHAR     "*"   && -- Character to be displayed for each entered
                                &&    letter of the password


*******************************************************************************
*******************************************************************************
class PasswordEntry(f,n) of Entryfield(f,n) custom

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
   this.Key = CLASS::KEY


   ****************************************************************************
   Procedure OnOpen(nChar, nPosition)
   ****************************************************************************

   *** Custom properties
   if type("this.enteredPassword") = "U"
      this.enteredPassword = ""
      this.correctPassword = ""    && This property must be manually assigned
                                   && whereever this control is instantiated
   endif

   *** Protect properties
   protect enteredPassword, correctPassword


   ****************************************************************************
   Procedure SetCorrectPassword(password)

   * Assigns value to this.correctPassword
   ****************************************************************************
   private passwordLen

   passwordLen = len(password)
   this.width = passwordLen
   this.maxLength = passwordLen
   this.correctPassword = password
   this.enteredPassword = ""


   ****************************************************************************
   Function IsEnteredPasswordOk
   ****************************************************************************

   return (this.enteredPassword == this.correctPassword)


   ****************************************************************************
   Procedure Key(nChar, nPosition)

   * Handles keys entered in the password entryfield
   ****************************************************************************
   private enteredChar, returnValue

   enteredChar = chr(nChar)
   returnValue = .T.                 && By default output whatever key was typed
   do case                           && Check for keys that modify the value
      case nChar = BACKSPACE_KEY
         this.enteredPassword = ;
            stuff(this.enteredPassword, nPosition - 1, 1, "")
      case nChar = DELETE_KEY
         this.enteredPassword = ;
            stuff(this.enteredPassword, nPosition, 1, "")
      otherwise
         if CLASS::IsValidChar(enteredChar)     && Check if alphanumeric
            this.enteredPassword = ;
               stuff(this.enteredPassword, nPosition, 1, enteredChar)
            returnValue = asc(PASSWORD_CHAR)    && Output camouflage character
         endif
   endcase

   return returnValue


   ****************************************************************************
   Procedure IsValidChar(char)

   * Make sure entered key is alphanumeric
   ****************************************************************************
   private returnValue

   do case
      case isalpha(char)                        && Letter?
         returnValue = .T.
      case char >= "0" .and. char <= "9"        && Digit?
         returnValue = .T.
      otherwise                                 && Invalid?
         returnValue = .F.
   endcase

   return returnValue

endclass


