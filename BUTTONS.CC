************************************************************************************
*  PROGRAM:      Buttons.cc
*
*  WRITTEN BY:   Borland Samples Group
*
*  DATE:         2/94
*
*  UPDATED:      7/95
*
*  REVISION:     $Revision:   1.13  $
*
*  VERSION:      Visual dBASE
*
*
*  DESCRIPTION:  This is a procedure file containing class definitions for
*                pushbuttons most frequently used in Visual dBASE forms.
*                These buttons contain both bitmaps, which are located in
*                <_dbwinhome>\designer\form\Resource.dll, and text.
*                Current Classes:
*                   OkButton
*                   CloseButton
*                   CancelButton
*                   YesButton
*                   NoButton
*                   NextButton
*                   PrevButton
*                   HelpButton
*                   InfoButton
*                   ToolButton
*                   ReportButton
*                   BrowseButton
*
*  PARAMETERS:   Each custom button control in this file requires 2 arguments:
*                F    -- Object -- Reference to the parent form
*                Name -- String -- Name of the control being created
*                Example:
*                   f = new form()
*                   p = new OkButton(f,"myOkButton")
*
*  CALLS:        None
*
*  USAGE:        set procedure to Buttons.cc additive, then use these classes
*                with:
*
*                NEW syntax:     x = new OkButton(f,"myOkButton"),
*                DEFINE syntax:  define OkButton x of f
*                FORMS DESIGNER: <Select Buttons.cc from the
*                                 "Set Up Custom Controls" dialog, and then
*                                 select the classes you want from the
*                                 "Custom" page of the Controls Palette.>
*
*******************************************************************************
#include <Messdlg.h>

*******************************************************************************
*******************************************************************************
class OkButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #20"
   this.disabledbitmap = "Resource #21"
   this.text = "OK"
   this.statusMessage = "Ok to close form"
   this.speedTip = "Ok to close form"

endclass

*******************************************************************************
class CloseButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #1005"
   this.disabledbitmap = "Resource #1006"
   this.text = "C&lose"
   this.OnClick = {;form.Close()}
   this.statusMessage = "Close this form."
   this.speedTip = "Close this form"

endclass

*******************************************************************************
*******************************************************************************
class CancelButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #28"
   this.disabledbitmap = "Resource #29"
   this.text = "Cancel"
   this.OnClick = {;form.Close()}
   this.statusMessage = "Cancel this form."
   this.speedTip = "Cancel this form"

endclass

*******************************************************************************
*******************************************************************************
class HelpButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #32"
   this.disabledbitmap = "Resource #33"
   this.text = "Help"
   this.speedTip = "Help with current topic"

endclass

*******************************************************************************
*******************************************************************************
class YesButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #36"
   this.disabledbitmap = "Resource #37"
   this.text = "&Yes"
   this.speedTip = "Answer Yes"

endclass


*******************************************************************************
*******************************************************************************
class NoButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #24"
   this.disabledbitmap = "Resource #25"
   this.text = "&No"
   this.speedTip = "Answer No"

endclass

*******************************************************************************
*******************************************************************************
class NextButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #100"
   this.text = "&Next"
   this.statusMessage = "Go to next record."
   this.speedTip = "Next Record"

   ****************************************************************************
   procedure OnClick
   ****************************************************************************
   if .not. empty(dbf()) .and. .not. eof()       && if a table is open in the current workarea
      skip
      if eof()
         go bottom
         AlertMessage("At the last record","Alert")
      endif
   else
      InformationMessage("There is no table open in the current workarea.",;
         "Info")
   endif
endclass

*******************************************************************************
*******************************************************************************
class PrevButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #104"
   this.text = "&Previous"
   this.statusMessage = "Go to previous record."
   this.speedTip = "Previous Record"

   ****************************************************************************
   procedure OnClick
   ****************************************************************************
   if .not. empty(dbf()) .and. .not. bof()       && if a table is open in the current workarea
      skip - 1
      if bof()
         go top
         AlertMessage("At the first record","Alert")
      endif
   else
     InformationMessage("There is no table open in the current workarea.",;
         "Info")
   endif

endclass


*******************************************************************************
*******************************************************************************
class InfoButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.height = 1.50
   this.width = 14.11
   this.upbitmap = "Resource #112"
   this.text = "&Info"
   this.speedTip = "View Information"

endclass

*******************************************************************************
*******************************************************************************
*class ToolButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

 *  this.height = 1.50
 *  this.width = 4
 *  this.upbitmap = "Resource #144"
 *  this.text = ""
 *  this.tabstop = .f.
 *  this.speedTip = "Tool"

*endclass

*******************************************************************************
*******************************************************************************
class ReportButton(f,n) of Pushbutton(f,n) custom
*******************************************************************************

   this.upBitmap = "RESOURCE #614"
   this.text = "Report"
   this.height = 1.50
   this.width = 14.11
   this.speedTip = "Show Report"

   ****************************************************************************
   procedure OnClick
   ****************************************************************************
   report form ?

endclass

*******************************************************************************
*******************************************************************************
class BrowseButton(f,n) of PushButton(f,n) custom
*******************************************************************************

   this.upBitmap = "RESOURCE #610"
   this.text = "Browse"
   this.height = 1.50
   this.width = 14.11
   this.speedTip = "Browse Data"

   ****************************************************************************
   procedure OnClick
   ****************************************************************************
   browse nowait

endclass


