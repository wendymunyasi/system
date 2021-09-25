procedure passsect
pluser = "w"
plevel = 1
PPTOTAL = 0
if empty(pluser) .or. empty(plevel) .OR. .NOT. PLEVEL = 1
quit
endif
      select 1
         use \KENSERVICE\data\kenslogt.dbf 
         select kenslogt
         eofkenslogt = .f.
         go top
         if .not. eof()
            do
               do rtn1
          until eofkenslogt
      endif
    
      close databases
procedure rtn1
         pkenuser = ken_user
         pkenname = ken_name
         pkenpwd = ken_pwd
         pkengroup = ken_group
         pusername = user_name
         appMid = ""
          mCount = 1
           pkbad = .F.
  
     
         **
          do while mCount <= len(trim(pkenuser)) 
   MCHUCK = (chr(asc(substr(trim(pkenuser),mCount,1))-128)) 
   appmId = appmId + mChuck 
   mCount = mCount + 1 
   enddo 
   replace ken_user with appmId
       appMid = ""
          mCount = 1
          do while mCount <= len(trim(pkenname)) 
   MCHUCK = (chr(asc(substr(trim(pkenname),mCount,1))-128)) 
   appmId = appmId + mChuck 
   mCount = mCount + 1 
   enddo 
   replace ken_name with appmId
       appMid = ""
          mCount = 1
          do while mCount <= len(trim(pkenpwd)) 
   MCHUCK = (chr(asc(substr(trim(pkenpwd),mCount,1))-128)) 
   appmId = appmId + mChuck 
   mCount = mCount + 1 
   enddo 
   replace ken_pwd with pkenpwd
       appMid = ""
          mCount = 1
          do while mCount <= len(trim(pkengroup)) 
   MCHUCK = (chr(asc(substr(trim(pkengroup),mCount,1))-128)) 
   appmId = appmId + mChuck 
   mCount = mCount + 1 
   enddo 
   replace ken_group with appmId
       appMid = ""
          mCount = 1
          do while mCount <= len(trim(pusername)) 
   MCHUCK = (chr(asc(substr(trim(pusername),mCount,1))-128)) 
   appmId = appmId + mChuck 
   mCount = mCount + 1 
   enddo 
   replace user_name with appmId
          select kenslogt
         skip
         if eof()
         eofkenslogt =.t.
         endif


