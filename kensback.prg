procedure kensback
  PARAMETER BUSER,BLEVEL
   PLUSER = BUSER
   PLEVEL = BLEVEL
   if empty(pluser) .or. empty(plevel)
   wait 'Blank User Not Required!'
   quit
   endif
   private pday,pshift
   SET SAFETY OFF
   set desig off
   select 1
   
   use \kenservice\data\st15f.dbf
   select 2
   use \kenservice\data\kensback.dbf
   select 3
   use \kenservice\data\fgsys.dbf
  select 10
USE \KENSERVICE\DATA\shcongt0.dbf 
select 11
USE \KENSERVICE\DATA\shcongt1.dbf 
select 4
USE \KENSERVICE\DATA\shcongt2.dbf 
select 5
USE \KENSERVICE\DATA\shcongt3.dbf 
select 6
USE \KENSERVICE\DATA\shcongt4.dbf 
select 7
USE \KENSERVICE\DATA\shcongt5.dbf 
select fgsys
   go top
   if .not. opsys = "Yes"
   wait "NO Back Up has Taken Place - check to confirm this O/S does not allow auto back up"
   quit
   endif
       SELECT SHCONGT0
    GO TOP
    IF .NOT. EOF()
    wait "Error encountered during shift closing in phase 0!"
    QUIT
    ENDIF
    SELECT SHCONGT1
    GO TOP
    IF .NOT. EOF()
    wait "Error encountered during shift closing in phase 1!"
    QUIT
    ENDIF
    SELECT SHCONGT2
    GO TOP
    IF .NOT. EOF()
    wait "Error encountered during shift closing in phase 2!"
    QUIT
    ENDIF
    SELECT SHCONGT3
    GO TOP
    IF .NOT. EOF()
    wait "Error encountered during shift closing in phase 3!"
    QUIT
    ENDIF
    SELECT SHCONGT4
    GO TOP
    IF .NOT. EOF()
    wait "Error encountered during shift closing in phase 4!"
    QUIT
    ENDIF
    SELECT SHCONGT5
    GO TOP
    IF .NOT. EOF()
    wait "Error encountered during shift closing in phase 5!"
    QUIT
    ENDIF
 
   select st15f
   set filter to .not. empty(shift_post) .or. empty(shift_date)
   go top
   if .not. eof()
       wait "Check Errors in Shift Master!"
   quit
   endif
   set filter to
   go top
   pday = dow(shift_date)
   pshift = shift_no
   pid=shift_id
   select kensback
   set order to shiftid
   seek dtos(st15f->shift_date)+st15f->shift_no+st15f->shift_id
   if .not. found()
   append blank
   replace shift_date with st15f->shift_date
   replace shift_no with st15f->shift_no
   replace shift_id with st15f->shift_id
   endif
   replace bdate with date()
   replace buser with pluser
   replace btime with time()
   close databases
     DO CASE
   CASE PDAY = 1
   DO sun_rtn
   CASE PDAY = 2
   DO mon_rtn
   CASE PDAY = 3
   DO Tue_rtn
   CASE PDAY = 4
   DO wed_rtn
   CASE PDAY = 5
   DO thu_rtn
   CASE PDAY = 6
   DO fri_rtn
   CASE PDAY = 7
   DO sat_rtn
   CASE PDAY = 8
   DO d8_RTN
   CASE PDAY = 9
   DO d9_RTN
   CASE PDAY = 10
   DO d10_RTN
   CASE PDAY = 11
   DO d11_RTN
   CASE PDAY = 12
   DO d12_RTN
   CASE PDAY = 13
   DO d13_RTN
   CASE PDAY = 14
   DO d14_RTN
   CASE PDAY = 15
   DO d15_RTN
   CASE PDAY = 16
   DO d16_RTN
   CASE PDAY = 17
   DO d17_RTN
   CASE PDAY = 18
   DO d18_RTN
   CASE PDAY = 19
   DO d19_RTN
   CASE PDAY = 20
   DO d20_RTN
   CASE PDAY = 21
   DO d21_RTN
   CASE PDAY = 22
   DO d22_RTN
   CASE PDAY = 23
   DO d23_RTN
   CASE PDAY = 24
   DO d24_RTN
   CASE PDAY = 25
   DO d25_RTN
   CASE PDAY = 26
   DO d26_RTN
   CASE PDAY = 27
   DO d27_RTN
   CASE PDAY = 28
   DO d28_RTN
   CASE PDAY = 29
   DO d29_RTN
   CASE PDAY = 30
   DO d30_RTN
   CASE PDAY = 31
   DO d31_RTN
   OTHERWISE
    WAIT "UNABLE TO BACK UP - CALL SYSTEM TEAM"
   QUIT
     ENDCASE
   
   PROCEDURE sun_rtn
             if pshift = "0"  && morning shift
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                *run xcopy \kenservice \KENSBACK\sun\shiftb\kenservice\data /e /c /r /h /i /k /y /d
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES1\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                 QUIT
              *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 
 PROCEDURE mon_rtn
             if pshift = "0"  && morning shift
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                *run xcopy \kenservice \KENSBACK\sun\shiftb\kenservice\data /e /c /r /h /i /k /y /d
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES2\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                 QUIT
             *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 PROCEDURE Tue_rtn
             if pshift = "0"  && morning shift
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                *run xcopy \kenservice \KENSBACK\sun\shiftb\kenservice\data /e /c /r /h /i /k /y /d
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES3\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                 *WAIT "BACK UP SUCCESSFUL"
                QUIT
             *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 
 PROCEDURE wed_rtn
           if pshift = "0"  && morning shift
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                *run xcopy \kenservice \KENSBACK\sun\shiftb\kenservice\data /e /c /r /h /i /k /y /d
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES4\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                 QUIT
              *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 
 PROCEDURE thu_rtn
           if pshift = "0"  && morning shift
                IF pID='0'
                    run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                *run xcopy \kenservice \KENSBACK\sun\shiftb\kenservice\data /e /c /r /h /i /k /y /d
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES5\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                *WAIT "BACK UP SUCCESSFUL"
                QUIT
              *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 
 PROCEDURE fri_rtn
           if pshift = "0"  && morning shift
                IF pID='0'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                 IF pID='0'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES6\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                  QUIT
            *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 
 PROCEDURE sat_rtn
           if pshift = "0"  && morning shift
                IF pID='0'
                   *run xcopy \kenservice \KENSBACK\sun\shifta\kenservice\data /e /c /r /h /i /k /y /d
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH0\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             else
                IF pID='0'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID0 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='1'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID1 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='2'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID2 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='3'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID3 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='4'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID4 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='5'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID5 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='6'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID6 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='7'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID7 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='8'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID8 /e /c /r /h /i /k /y /d
                ENDIF
                IF pID='9'
                   run xcopy \kenservice \IKS\VDB\BIN\VER\PROGS\IDS\SERIES7\SH1\ID9 /e /c /r /h /i /k /y /d
                ENDIF
             endif
                   *WAIT "BACK UP SUCCESSFUL"
                QUIT
             *WAIT "BACK UP SUCCESSFUL"
             CLOSE DATABASES
 
 