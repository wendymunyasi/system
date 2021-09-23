*******************************************************************************
*  FILE:         messdlg.h
*
*  WRITTEN BY:   Borland Samples Group
*
*  DATE:         2/94
*
*  UPDATED:      5/95
*
*  REVISION:     $Revision:   1.21  $
*
*  VERSION:      Visual dBASE
*
*  DESCRIPTION:  This is a header file that can be used for making calls to
*                the msgBox() Visual dBASE function.  It contains definitions
*                for various messages and button combinations, as well as the
*                following shortcuts for frequently used message and button
*                combinations (m is message, t is title):
*
*                   PlainMessage(m,t)
*                   WarningMessage(m,t)
*                   ConfirmationMessage(m,t)
*                   AlertMessage(m,t)
*                   InformationMessage(m,t)
*
*
*
*  PARAMETERS:   None
*
*  CALLS:        None
*
*  USAGE:        (in a file)
*                #include <messdlg.h>
*
*******************************************************************************

#ifndef messdlg_H
#define messdlg_H

*** Message Box Styles
#define PLAIN_MESSAGE               0  && ok/cancel
#define WARNING_MESSAGE            16
#define CONFIRMATION_MESSAGE       32
#define ALERT_MESSAGE              48
#define INFORMATION_MESSAGE        64

*** Button Options

#define OK_BUTTON                  0
#define OK_CANCEL_BUTTONS          1
#define ABORT_RETRY_IGNORE_BUTTONS 2
#define YES_NO_CANCEL_BUTTONS      3
#define YES_NO_BUTTONS             4
#define RETRY_CANCEL_BUTTONS       5


*** Button Return Values
#define OK                         1
#define CANCEL                     2
#define ABORT                      3
#define RETRY                      4
#define IGNORE                     5
#define YES                        6
#define NO                         7

#define DESKTOP                    0

* Calling simplifications.  So user can call function instead of giving
* function type as an argument.
* m = message; t = title

#define PlainMessage(m,t)           msgBox(m,t,PLAIN_MESSAGE + OK_BUTTON)
#define WarningMessage(m,t)         msgBox(m,t,WARNING_MESSAGE + OK_CANCEL_BUTTONS)
#define ConfirmationMessage(m,t)    msgBox(m,t,CONFIRMATION_MESSAGE + YES_NO_BUTTONS)
#define ConfirmOrCancelMessage(m,t) msgBox(m,t,CONFIRMATION_MESSAGE + YES_NO_CANCEL_BUTTONS)
#define AlertMessage(m,t)           msgBox(m,t,ALERT_MESSAGE + OK_BUTTON)
#define InformationMessage(m,t)     msgBox(m,t,INFORMATION_MESSAGE + OK_BUTTON)

#endif
