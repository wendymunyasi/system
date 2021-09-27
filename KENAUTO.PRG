**************************************************************************
*  PROGRAM:      KENAUTO.prg
*
*
*******************
***********************************************************
Procedure KENAUTO
 PARAMETER BUSER,BLEVEL,BTYPE
   PLUSER = BUSER
   PLEVEL = BLEVEL
   PTYPE =  BTYPE
   MOusePOinter = 11
   if empty(pluser) .or. empty(plevel)
   quit
   endif
create session
set talk off
set ldCheck off
set decimals to 4
SET VIEW TO "Kenautob.QBE"
SELECT FGSYS
   go top
   if .not. opsys = "Yes"
   wait "NO Back Up has Taken Place - check to confirm this O/S does not allow auto back up"
   quit
   endif
      do initial_rtn
     close databases
   quit

Procedure initial_rtn
   LOCAL LDAY,LTIME,LDATA,LGLS,LKENPAY,LDATA,ldate,lok,LWKT,LHH,lmth
   lok = .f. 
   
    select KENAUTOB
  append blank
  replace back_date with date()
  replace back_time with time()
  replace back_user with pluser
  SELECT KENBEXTN
  GO  TOP
  IF EOF()
   append blank
   ENDIF
  replace back_date with date()
  replace back_time with time()
  replace back_user with pluser

 LDAY =  DTOS(DATE())   && YYYYMMDD
   PDAY = day(DATE()) && day of the month
   PMONTH = MONTH(DATE())  && month of the year
PYEAR= DTOS(DATE())
PYEAR = LEFT(PYEAR,4)
PYEAR = VAL(RIGHT(PYEAR,1))

   if ptype = 1 && daily back up
   do day_rtn
   else
   if btype = 2
   do month_rtn
   else
   do year_rtn
   endif
   endif
   
procedure day_rtn    
 DO CASE
    CASE PDAY = 1
    IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY1\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PDAY = 2
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY2\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
CASE PDAY = 3
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY3\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
CASE PDAY = 4
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY4\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
  
  CASE PDAY = 5
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY5\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PDAY = 6
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY6\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 
 CASE PDAY = 7
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY7\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
            
  CASE PDAY = 8
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY8\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                           
  CASE PDAY = 9
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY9\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
                             
 CASE PDAY = 10
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY10\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
                             
                               
 CASE PDAY = 11
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY11\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
        CASE PDAY = 12
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY12\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  CASE PDAY = 13
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY13\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
  CASE PDAY = 14
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY14\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
    
     CASE PDAY = 15
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY15\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
   CASE PDAY = 16
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY16\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PDAY = 17
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY17\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  CASE PDAY = 18
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY18\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                               
   CASE PDAY = 19
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY19\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  CASE PDAY = 20
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY20\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  CASE PDAY = 21
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY21\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                            
   CASE PDAY = 22
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY22\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDI
                       
    CASE PDAY = 23
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY23\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
   CASE PDAY = 24
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY24\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PDAY = 25
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY25\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
   CASE PDAY = 26
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY26\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
             CASE PDAY = 27
             
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY27\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  CASE PDAY = 28
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY28\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
    CASE PDAY = 29
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY29\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  CASE PDAY = 30
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY30\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
       CASE PDAY = 31
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY31\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
        
  OTHERWISE
   IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DAY00\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  
  ENDCASE
 quit
 
 
procedure month_rtn    
 DO CASE
    CASE PMONTH = 1
    IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\JAN\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PMONTH = 2
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\FEB\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
CASE PMONTH = 3
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\MAR\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
CASE PMONTH = 4
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\APR\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
  
  CASE PMONTH = 5
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\MAY\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PMONTH = 6
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\JUN\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 
 CASE PMONTH = 7
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\JUL\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
            
  CASE PMONTH = 8
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\AUG\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                           
  CASE PMONTH = 9
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\SEP\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
                             
 CASE PMONTH = 10
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\OCT\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
                             
                               
 CASE PMONTH = 11
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
        CASE PMONTH = 12
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
   OTHERWISE
   IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\MON00\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  
  ENDCASE
 quit
 
procedure year_rtn    
 DO CASE
    CASE PYEAR = 1
    IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR1\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PYEAR = 2
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR2\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
CASE PYEAR = 3
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR3\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
CASE PYEAR = 4
        IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR4\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
  
  CASE PYEAR = 5
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR5\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 CASE PYEAR = 6
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR6\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
 
 CASE PYEAR = 7
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR7\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
            
  CASE PYEAR = 8
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR8\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                           
  CASE PYEAR = 9
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR9\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
                             
 CASE PYEAR = 10
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR0\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             
                             
                               
 CASE PYEAR = 11
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\NOV\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
        CASE PYEAR = 12
         IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\DEC\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
   OTHERWISE
   IF VALIDDRIVE("M:") 
           ! xcopy \kenservice M:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("L:") 
           ! xcopy \kenservice L:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("K:") 
           ! xcopy \kenservice K:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("J:") 
           ! xcopy \kenservice J:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
         ELSE
         IF VALIDDRIVE("I:") 
           ! xcopy \kenservice I:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("H:") 
           ! xcopy \kenservice H:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
         IF VALIDDRIVE("G:") 
           ! xcopy \kenservice G:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("F:") 
           ! xcopy \kenservice F:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("E:") 
           ! xcopy \kenservice E:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
        IF VALIDDRIVE("D:") 
           ! xcopy \kenservice D:\KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
        ELSE
           ! xcopy \kenservice \KENAUTOS\YEAR00\KENSERVICE /e /c /r /h /i /k /y /d
           ENDIF
              ENDIF
                 ENDIF
                    ENDIF
                       ENDIF
                          ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
                             ENDIF
  
  ENDCASE
 quit