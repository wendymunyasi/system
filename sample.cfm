////////////////////////////////////////////////////////////////////////////////
// Output Filename: C:\KENSERVICE\IDSSYS\SAMPLE_FCV.CFM                       //
// Created By:      dBASE Form Converter Wizard                               //
// Created On:      Saturday September 25, 2021 At 12:54:37                   //
// Object Count:    4                                                         //
////////////////////////////////////////////////////////////////////////////////
*****************************************************************************
*  FILE:         Sample.cfm
*
*  WRITTEN BY:   Borland Samples Group
*
*  DATE:         5/93
*
*  UPDATED:      6/95
*
*  REVISION:     $Revision:   1.1  $
*
*  VERSION:      Visual dBASE
*
*  DESCRIPTION:  This is a sample custom form file used by the Visual dBASE
*                samples.  It contains a definition for SearchFormClass,
*                which is a simple form for basic searching.  Search.wfm
*                contains a form derived from this class.
*
*  PARAMETERS:   None
*
*  CALLS:        Buttons.cc         (Custom Controls file)
*
*  USAGE:        1.  From Form Designer:
*                    Select "File", "Set Custom Form Class..." menu choices.
*                    Select this file from the tool dialog, or just type it
*                    into the "File Name Containing Class" entryfield.
*                    Select SearchFormClass from "Class Name" combobox.
*                    Press OK button, and you are set.
*
*                2.  From a program:
*                    Define your form class to be inherited from
*                    SearchFormClass as follows:
*
*                    CLASS <your class name> of SearchFormClass From "SAMPLE.CFM"
*                    ...
*                    ENDCLASS
*
*******************************************************************************
CLASS SearchFormClass OF FORM Custom
   Set Procedure to Buttons.cc Additive
   this.Metric = 6  // Pixels
   this.Left = 200
   this.Top = 68
   this.Text = "Search"
   this.Maximize = .F.
   this.Minimize = .F.
   this.MousePointer = 1
   this.ColorNormal = "BtnText/BtnFace"
   this.Height = 80
   this.Width = 221

   DEFINE RECTANGLE SEARCHRECT OF THIS;
       PROPERTY;
         Left 8,;
         Top 3,;
         Text "&Search for",;
         ColorNormal "BtnText/BtnFace",;
         Height 40,;
         Width 206,;
       FontName "MS Sans Serif",;
       FontSize 8,;
       FontBold .T.

   DEFINE ENTRYFIELD SEARCHENTRY OF THIS;
       PROPERTY;
         Left 16,;
         Top 19,;
         ColorHighLight "B+/W*",;
         Value "            ",;
         ColorNormal "B/BtnFace",;
         Height 20,;
         Width 190,;
       FontName "MS Sans Serif",;
       FontSize 8,;
       FontBold .T.

   DEFINE OKBUTTON OKSEARCHBUTTON OF THIS;
       PROPERTY;
         Left 24,;
         Top 51,;
         Group .T.,;
         Default .T.,;
         Height 26,;
         Width 85,;
       FontName "MS Sans Serif",;
       FontSize 8,;
       FontBold .T.

   DEFINE CANCELBUTTON CANCELSEARCHBUTTON OF THIS;
       PROPERTY;
         Left 117,;
         Top 51,;
         Group .F.,;
         ID 0,;
         Height 26,;
         Width 85,;
       FontName "MS Sans Serif",;
       FontSize 8,;
       FontBold .T.

ENDCLASS
