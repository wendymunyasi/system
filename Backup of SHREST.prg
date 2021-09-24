procedure SHREST
   parameter buser,blevel
   private pday,pshift
   SET SAFETY OFF
   set desig off
   buser='e'
   blvel=1
   blUSER = BUSER
   blLEVEL = BLEVEL
   IF EMPTY(blUSER) .OR. EMPTY(bLEVEL)
      QUIT
   ENDIF
   USE \kenslog\idssys\KENSLOG.DBF EXCLUSIVE
   *PACK
   
   
      RUN XCOPY \KENSERVICE\SYSDATA\data \KENSERVICE\DATA   /e /c /r /h /i /k /y
  close  databases