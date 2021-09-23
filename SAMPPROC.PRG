*******************************************************************************
*  PROGRAM:      Sampproc.prg
*
*  WRITTEN BY:   Borland Samples Group
*
*  DATE:         6/94
*
*  UPDATED:      5/95
*
*  REVISION:     $Revision:   1.48  $
*
*  VERSION:      Visual dBASE
*
*  DESCRIPTION:  This is a general procedure file containing useful functions
*                called by some of the sample programs.
*
*  PARAMETERS:   None
*
*  CALLS:        None
*
*  USAGE:        SET PROCEDURE TO Sampproc.prg ADDITIVE
*
********************************************************************************
#include <Messdlg.h>

InformationMessage("Sampproc.prg is a procedure file used by the samples.","Info")

********************************************************************************
function FormatStr(string)

* Could have 0 or more parameters.
* This function will replace occurrences of "%<n>" with the corresponding
* parameter string.  It will also replace all occurrences of "\n" with a Carriage
* Return, and all occurrences of "\t" with a Tab.
*
* Example: x = FormatStr("Hello \n %1", "World") &&prints Hello World on 2 lines
********************************************************************************
#define ENTER  chr(13)
#define TAB    chr(9)
local i, strPos, strCnt, tmpStr

tmpStr = string
for i = 2 to argc()    && while have something to search for
   tmpStr = StrTran(tmpStr, "%" + ltrim(str(i - 1)), argv(i))
next
tmpStr = StrTran(tmpStr, "\n", ENTER)
tmpStr = StrTran(tmpStr, "\t", TAB)

return tmpStr


*******************************************************************************
function StrTran(string,curStr,repStr)

* Replaces all occurrences of curStr in string with repStr
*******************************************************************************
local strPos, lenCurStr, tmpStr

tmpStr = string
lenCurStr = len(curStr)
strPos = at(curStr, tmpStr)
do while strPos > 0
   tmpStr = stuff(tmpStr, strPos, lenCurStr, repStr)
   strPos = at(curStr, tmpStr)
enddo
return tmpStr



*******************************************************************************
procedure SetEnvironment

* Environment settings used by most samples (not necessarily this proc, though)
*******************************************************************************
set talk off
set ldCheck off


*******************************************************************************
*******************************************************************************
CLASS SAMPINFOFORM(sampleName) OF FORM

* Class for displaying information from the samples.  This information is
* extracted from Samples.txt.
*******************************************************************************
   this.Top = 10
   this.Height = 7.2344
   this.ColorNormal = "GB+"
   this.PageNo = 1
   this.Text = sampleName
   this.TopMost = .F.
   this.Width = 65    &&31.333
   this.Left = 18
   this.MDI = .F.
   this.Sizeable = .F.
   this.Maximize = .F.
   this.Minimize = .F.
   this.Sysmenu = .F.
   this.OnClose = CLASS::Form_OnClose

   DEFINE EDITOR INFOEDITOR OF THIS;
       PROPERTY;
         CUATab .T.,;
         Top 1.2,;
         Height 6.0,;
         FontBold .F.,;
         ColorNormal "B+/GB+",;
         PageNo 1,;
         Border .F.,;
         Width 64,;
         Wrap .F.,;
         Left 1,;
         Value "",;
         Modify .F.

   DEFINE PUSHBUTTON CLOSEBUTTON OF THIS;
       PROPERTY;
         Top 0,;
         Height 1.1172,;
         ColorNormal "BtnText/BtnFace",;
         PageNo 1,;
         Text "",;
         Width 3.5,;
         UpBitmap "RESOURCE #36",;
         Group .T.,;
         Left 0,;
         OnClick {;form.Close()}

   this.fileName = CLASS::CreateTempFile(sampleName)
   if .not. empty(this.fileName)
      this.infoEditor.dataLink = "file " + this.fileName
   endif


   ****************************************************************************
   Procedure Form_OnClose

   * Close info form, and delete info file, if it exists.
   ****************************************************************************
   private fileName

   if .not. empty(this.fileName)
      fileName = this.fileName
      this.infoEditor.dataLink = ""
      erase &fileName
   endif


   ****************************************************************************
   Function CreateTempFile(sampleName)

   * Create temporary file containing information about sampleName, extracted
   * from Samples.txt
   ****************************************************************************
   #define END_SAMPLE_DESCRIPT   "*"
   private tempFileName, fhSamplesTxt, fhTempFile, line, bSampleFound, result

   tempFileName = ""
   fhSamplesTxt = fopen("Samples.txt", "R")     && Open Samples.txt Read-only
   if fhSamplesTxt = 0
      InformationMessage("Samples.txt was not found, or couldn't be opened.",;
                         "Info")
   else
      bSampleFound = .F.
      do while .not. bSampleFound .and. .not. feof(fhSamplesTxt)
         line = fgets(fhSamplesTxt)             && Search until find sampleName
         if upper(rtrim(line)) = upper(sampleName)
            bSampleFound = .T.
         endif
      enddo
      if .not. bSampleFound                     && Reached end of file
         InformationMessage("Information about " + sampleName +;
                               " was not found in Samples.txt.",;
                            "Sorry")
      else                                      && Save info to temp file
         tempFileName = fUnique()
         fhTempFile = fCreate(tempFileName, "RW")
         if fhTempFile = 0                      && Couldn't create file
            InformationMessage("Couldn't create temp file.",;
                               "Sorry")
         else                                   && Temp file was created
            line = fgets(fhSamplesTxt)          && Underscore line
            line = fgets(fhSamplesTxt)
            do while rtrim(line) <> END_SAMPLE_DESCRIPT .and.;
                  .not. feof(fhSamplesTxt)
               result = fputs(fhTempFile, line)
               line = fgets(fhSamplesTxt)
            enddo

            result = fclose(fhTempFile)
         endif
      endif
      result = fclose(fhSamplesTxt)
   endif

   return tempFileName


ENDCLASS


