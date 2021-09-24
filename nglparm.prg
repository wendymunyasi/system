**************************************************************************
*  PROGRAM:      nglparm
*
*******************************************************************************

Procedure nglparm
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
   clear program
   #include <messdlg.h>
create session
set talk off
set ldCheck off
set decimals to 4
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,10 TO 15,130;
  PROPERTY Text "Updating General Ledger Chart of Accounts in progress....Wait! ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 12,;
    MousePointer 11
PROGREPS.OPEN()

     do initial_rtn
     
     progreps.close()
  close databases
  
Procedure initial_rtn
   set view to "nglparm.qbe"
PRIVATE EOFfgcod,PYEAR,PPERIOD,PCOY,Ptypn,PACTYP,PACCLASS,PACC,psys,pclan,pshid,pshno,;
pdoc,pdocref,pamt,pqty,PVAT,PTVAT,PCOST,PTCOST,pcshdate,pcshno,pcshid,;
ppcost,pfirst,pccost,ppprod,pcprod,pweek,ptyp,pcla,pcod,ppwk,paccn,pcwk,Per
set safety off
select fgmast 
set order to mkey2
   select fgcoy
   go top
      SELECT nlcoy
      set order to coy
      SEEK Fgcoy->COY
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE COY WITH Fgcoy->COY
      ENDIF
      REPLACE LNAME WITH Fgcoy->STREET
      REPLACE NAME WITH FGCOY->NAME


SELECT NGLACCP
SET ORDER TO MKEY
set safety on
select nlcc
set order to ccentre
   select nltyp
   set order to actype
   select nlcla
   set order to acclass
   select nlacc
   set order to acc
   select nlbs
   set order to bs
   select nlbslel
   set order to bslevel2
   select nlbslev
   set order to bslevel1
   select nlie
   set order to ie
   select nlielev
   set order to ielevel1
   select nlta
   set order to ta
   select nltalel
   set order to talevel2
   select nltale3
   set order to talevel3
   select nltalev
   set order to talevel1
   select fgcla
   SET ORDER TO MKEY
   set filter to .not. empty(name)
   select fgtyp
   SET ORDER TO TYP
   set filter to .not. empty(name)
    
   EOFfgcod = .F.

      SELECT fgcod
      SET ORDER TO MKEY
      set filter to .not. empty(name) 
      GO TOP
      IF .NOT. EOF()
         DO 
            DO ngl_rtn
            UNTIL EOFfgcod
            endif
            
        eofnlacc = .f.
        select nlacc
        go top
        if .not. eof()
        do
           do nlaccs_rtn
        until eofnlacc
        endif
         eofnlacc = .f.
        select nlacc
        SET FILT TO ACCLASS = 'G0'  && STOCKS
        go top
        if .not. eof()
        do
           do nlaccsstocks_rtn
        until eofnlacc
        endif
procedure nlaccsstocks_rtn
       pcoy = '1'
       pcc = '5'
       PPC = '1'
      
       select nlcc
       seek pcoy+pcc+ppc
      pactype = nlacc->actype
      select nltyp
      seek pactype
      if found()
      pacclass = 'G0'
      PACC = nlacc->acc
         PACCE = PACTYPE+PACCLASS+PACC
        PACCn = left(NLACC->Lname,33)
  *     pactypn = left(nltyp->lname,18)
  pactypn = 'CURRENT ASSETS'
       ploc = LEFT(nlcc->lname,16)
        psp = " -"
           pname = trim(UPPER(paccn+psp+pactypn+psp+ploc +psp+ pactype+pacclass+pacc) )
    IF .NOT. EMPTY(pname)
       select nglACCP
       seek pcoy+pcc+ppc+pactype+pacclass+pacc
       if .not. found()
          append blank
          replace name with pname
          replace acclass with PACCLASS
          replace acc with PACC
          replace ACTYPE with pACTYPE
          replace coy with pcoy
          replace ccentre with pcc
          replace pcentre with ppc
          ENDIf
          endif
          endif
        select nlacc
   skip
   if eof()
   eofnlacc = .t.
   endif
procedure nlaccs_rtn
   select nlaccs
   append blank
   replace actype with nlacc->actype
   replace acclass with nlacc->acclass
   replace acc with nlacc->acc
   replace scode with actype+acclass+acc+nlacc->lname
   select fgcod
   seek nlacc->acclass+left(nlacc->acc,2)+right(nlacc->acc,2)
   PTYP = TYP
   PCLA = CLA
   PCOD = COD
   select nlaccs
      pACTYPE = ACTYPE
       PACCLASS = ACCLASS
       PACC = ACC
        select nlacc
      pACTYPE = ACTYPE
       PACCLASS = ACCLASS
       PACC = ACC
       EOFFGMAST = .F.
       SELECT FGMAST
      SET FILT TO TYP = PTYP .AND. CLA= PCLA .AND. COD = PCOD
     GO TOP
       IF .NOT. EOF()
          DO 
             DO FGMAST_RTNNEW
             UNTIL EOFFGMAST
             ENDIF
              select nlacc
   skip
   if eof()
   eofnlacc = .t.
   endif
 PROCEDURE FGMAST_RTNNEW
       
         
       pcoy = FGMAST->COY
       pcc = FGMAST->DIV
       PPC = FGMAST->CEN
      
       select nltyp
       seek pactype
       select nlcla
        seek pactype+pacclass
       select  nlcc
        seek pcoy+pcc+ppc
       PACCE = PACTYPE+PACCLASS+PACC
    *  PACCLASSn = left(NLacc->claName,21)
       PACCn = left(NLACC->Lname,33)
       pactypn = left(nltyp->lname,18)
       ploc = LEFT(nlcc->lname,16)
        psp = " -"
           pname = trim(UPPER(paccn+psp+pactypn+psp+ploc +psp+ pactype+pacclass+pacc) )
    IF .NOT. EMPTY(pname)
       select nglACCP
       seek pcoy+pcc+ppc+pactype+pacclass+pacc
       if .not. found()
          append blank
          replace name with pname
          replace acclass with PACCLASS
          replace acc with PACC
          replace ACTYPE with pACTYPE
          replace coy with pcoy
          replace ccentre with pcc
          replace pcentre with ppc
          ENDIf
          endif
  select fgmast
  skip
  if eof()
  eoffgmast = .t.
  endif
 
 PROCEDURE ngl_rtn
    per = .f.
    select fgcod
    ptyp = typ
    pcla = cla
    pcod = cod
    select fgtyp
    seek ptyp
    select fgcla
    seek ptyp+pcla
    if ptyp > "9Z" .and. empty(fgtyp->actype)
    per = .t.
    endif
    if .not. per
    do ngl_rtn1
    endif
    
    select fgcod
    skip
    if eof()
    eoffgcod = .t.
    endif
    
 Procedure ngl_rtn1
    if ptyp >= "00" .and. ptyp <= "9Z"
    do ngl_rtn2
    else
    do ngl_rtn3
    endif
Procedure ngl_rtn2
       pactype = "1"  && income
       ptypn = "SALES"
       Do general_rtn  
       do SALES_rtn
       Ptypn = "COST OF SALES"
       pactype = "8"  && cost of sales
       do general_rtn
       do cost_sales_rtn
       Ptypn = "STOCK LOSS"
       if .not. LEFT(ptyp,1) = "7"
       pactype = "B"  && stock loss
       do general_rtn
       do cost_sales_rtn
       Pactype = "7"  && purchases
       ptypn = "PURCHASES"
       do general_rtn
       do cost_sales_rtn
       pactype = "4"  && CURRENT ASSETS
       ptypn = "CURRENT ASSETS"
       DO GENERAL_RTN2 &&new
       do PROVISIONS_RTN99  && new
        endif
  
procedure general_rtn3  && Liabilities
    select nltyp
    seek pactype
    if .not. found()
    append blank
    replace actype with pactype
    endif
    replace lname with PTYPN
    pacclass = "L0"  && CURRENT LIABILITIES
    select nlcla
    seek pactype+pacclass
    if .not. found()
    append blank
    replace actype with pactype
    replace acclass with pacclass
    endif
    replace lname with "TRADE CREDITORS"
    pacc = ptyp+pcla  && typname+typclass
    select nlacc
    seek pactype+pacclass+pacc
    if .not. found()
    append blank
     replace actype with pactype
    replace acclass with pacclass
  replace acc with pacc
  endif
  replace lname with fgcla->name
  replace claname with fgtyp->name
  
   
procedure general_rtn2  && stocks
   if PTYP >="00" .and. Ptyp <="9Z" .and. .not. left(Ptyp,1) ="7"
    select nltyp
    seek pactype
    if .not. found()
    append blank
    replace actype with pactype
    endif
    replace lname with PTYPN
    pacclass = "G0"  && STOCKS
    select nlcla
    seek pactype+pacclass
    if .not. found()
    append blank
    replace actype with pactype
    replace acclass with pacclass
    endif
    replace lname with "STOCKS"
    pacc = ptyp+pcla  && typname+typclass
    select nlacc
    seek pactype+pacclass+pacc
    if .not. found()
    append blank
     replace actype with pactype
    replace acclass with pacclass
  replace acc with pacc
  endif
  replace lname with fgcla->name
  replace claname with fgtyp->name
  endif
 
        
  Procedure ngl_rtn3
   PTYPN = fgtyp->name
   pactype = fgtyp->actype
   ptyp= fgtyp->typ
   do general_rtn
   if pactype = "1"
      do SALES_rtn
      endif
        if pactype = "2"
         do provisions_rtn
        endif
        if pactype = "0"
           do expenses_rtn
           endif
           if pactype = "3"
              do provisions_RTN
              endif
              if pactype = "4"
                 do PROVISIONS_RTN
                 endif
                 if pactype = "5"
                 do PROVISIONS_RTN
                 endif
                 if pactype = "6"
                 do PROVISIONS_RTN
                 endif
                 if pactype = "7" .or. pactype = "8" .or. pactype = "B"
                 do COST_SALES_RTN
                 endif
                  if pactype = "9"
                 do capital_rtn
                 endif
                 
             
 procedure general_rtn
    select nltyp
    seek pactype
    if .not. found()
    append blank
    replace actype with pactype
    endif
    replace lname with PTYPN
    pacclass = ptyp
    select nlcla
    seek pactype+pacclass
    if .not. found()
    append blank
    replace actype with pactype
    replace acclass with pacclass
    endif
    replace lname with fgtyp->name
    pacc = pcla+pcod
    select nlacc
    seek pactype+pacclass+pacc
    if .not. found()
    append blank
     replace actype with pactype
    replace acclass with pacclass
  replace acc with pacc
  endif
  replace lname with fgcod->name
  replace claname with fgcla->name
    
 Procedure SALES_rtn
    do nlta1_rtn
    do nlbs1_rtn
    do nlie1_rtn
Procedure nlta1_rtn  	 && trading account
  select nlTA
    seek "1"+PTYP+PCLA+PCOD && surplus
    if .not. found()
    append blank
    replace TA with PCOD
    replace TAlevel1 with "1"
    replace TAlevel2 with PTYP
    REPLACE TALEVEL3 WITH PCLA
    endif
    replace lname with fgcod->NAME
    select nlTAlev
    seek "1"
    if .not. found()
    append blank
    replace TAlevel1 with "1"
    endif
    replace lname with "SALES"
    REPLACE SNAME WITH "S"
    SELECT NLTALEL
    SEEK "1"+PTYP
    IF .NOT. FOUND()
    APPEND BLANK
    replace TAlevel1 with "1"
    replace TAlevel2 with PTYP
    ENDIF
    REPLACE LNAME WITH fgtyp->NAME
    SELECT NLTALE3
    SEEK "1"+PTYP+PCLA
    IF .NOT. FOUND()
    APPEND BLANK
    replace TAlevel1 with "1"
    replace TAlevel2 with PTYP
    REPLACE TALEVEL3 WITH PCLA
    ENDIF
    REPLACE LNAME WITH fgcla->NAME
  
    select nlacc
    replace talevel1 with "1"
    REPLACE TALEVEL2 WITH PTYP
    replace talevel3 with pCLA
    replace ta with PCOD
    
Procedure nlie1_rtn  	

  select NLIE
    seek "1"+"0001" && surplus
    if .not. found()
    append blank
    replace IE with "0001"
    replace IElevel1 with "1"
     endif
    replace lname with "GROSS PROFIT"
    select NLIElev
    seek "1"
    if .not. found()
    append blank
    replace IElevel1 with "1"
    endif
    replace lname with "INCOME"
   
    select nlacc
    replace ielevel1 with "1"
    replace ie with "0001"  && GROSS PROFIT
    
  Procedure nlbs1_rtn  	
    select nlacc
    replace bslevel1 with "2"
    replace bslevel2 with "W0"
    replace bs with "0001"  && GROSS PROFIT
    select nlbs
    seek "2"+"W0"+"0001"  && surplus
    if .not. found()
    append blank
    replace bs with "0001"
    replace bslevel1 with "2"
    replace bslevel2 with "W0"
    endif
    replace lname with "DEFICIT (SURPLUS)"
    select nlbslev
    seek "2"
    if .not. found()
    append blank
    replace bslevel1 with "2"
    endif
    replace lname with "OWNER'S EQUITY"
    SELECT NLBSLEL
    SEEK "2"+"W0"
    IF .NOT. FOUND()
    APPEND BLANK
    replace bslevel1 with "2"
    replace bslevel2 with "W0"
    ENDIF
    REPLACE LNAME WITH "FINANCED BY:"
   
  
  

   
    
Procedure EXPENSES_rtn
    do nlbs1_rtn
    do nlie3_rtn

Procedure nlie3_rtn  	
   LOCAL L1
   L1 = ptyp+PCLA
  select NLIE
    seek "2"+L1 && 
    if .not. found()
    append blank
    replace IE with L1
    replace IElevel1 with "2"
     endif
    replace lname with fgcla->NAME
    select NLIElev
    seek "2"
    if .not. found()
    append blank
    replace IElevel1 with "2"
    endif
    replace lname with "EXPENSES"
   
    select nlacc
    replace ielevel1 with "2"
    replace ie with L1  && GROSS PROFIT
    
  
  Procedure PROVISIONS_RTN99
   LOCAL L1
     if fgtyp->typ >="00" .and. fgtyp->typ <="9Z" .and. .not. left(fgtyp->typ,1) ="7"
    pacc = ptyp+pcla+"0"
      L1 = PTYP+PCLA
          pacclass = "G0"  && stocks
 
   select nlacc
    replace bslevel1 with "1"
    replace bslevel2 with pacclass
    replace bs with L1 
    select nlbs
    seek "1"+pacclass+L1 
    if .not. found()
    append blank
    replace bs with L1
    replace bslevel1 with "1"
    replace bslevel2 with pacclass
    endif
    replace lname with left(fgtyp->name,15)+" - "+left(fgcla->NAME,15)
    select nlbslev
    seek "1"
    if .not. found()
    append blank
    replace bslevel1 with "1"
    endif
    replace lname with "ASSETS AND LIABILITIES"
    SELECT NLBSLEL
    SEEK "1"+pacclass
    IF .NOT. FOUND()
    APPEND BLANK
    replace bslevel1 with "1"
    replace bslevel2 with pacclass
    ENDIF
    REPLACE LNAME WITH "STOCKS"
    endif
    
  
   Procedure provisions_rtn
    LOCAL L1
    L1 = pcla+pcod
   select nlacc
    replace bslevel1 with "1"
    replace bslevel2 with PTYP
    replace bs with L1  
    select nlbs
    seek "1"+PTYP+L1 
    if .not. found()
    append blank
    replace bs with L1
    replace bslevel1 with "1"
    replace bslevel2 with PTYP
    endif
    replace lname with fgcod->NAME
    select nlbslev
    seek "1"
    if .not. found()
    append blank
    replace bslevel1 with "1"
    endif
    replace lname with "ASSETS AND LIABILITIES"
    SELECT NLBSLEL
    SEEK "1"+PTYP
    IF .NOT. FOUND()
    APPEND BLANK
    replace bslevel1 with "1"
    replace bslevel2 with PTYP
    ENDIF
    REPLACE LNAME WITH fgtyp->NAME   
    
     
   Procedure CAPITAL_RTN
    LOCAL L1
    L1 = PCLa+pcod
   select nlacc
    replace bslevel1 with "2"
    replace bslevel2 with PTYP
    replace bs with L1  && GROSS PROFIT
    select nlbs
    seek "2"+PTYP+L1 && surplus
    if .not. found()
    append blank
    replace bs with L1
    replace bslevel1 with "2"
    replace bslevel2 with PTYP
    endif
    replace lname with fgcod->NAME
    select nlbslev
    seek "2"
    if .not. found()
    append blank
    replace bslevel1 with "2"
    endif
    replace lname with "OWNER'S EQUITY"
    SELECT NLBSLEL
    SEEK "2"+PTYP
    IF .NOT. FOUND()
    APPEND BLANK
    replace bslevel1 with "2"
    replace bslevel2 with PTYP
    ENDIF
    REPLACE LNAME WITH "FINANCED BY"  
    
Procedure cost_sales_rtn
    do nlta2_rtn
    do nlbs1_rtn
    do nlie1_rtn
Procedure nlta2_rtn  	 && trading account
  select nlTA
    seek "2"+PTYP+PCLA+PCOD && surplus
    if .not. found()
    append blank
    replace TA with PCOD
    replace TAlevel1 with "2"
    replace TAlevel2 with PTYP
    REPLACE TALEVEL3 WITH PCLA
    endif
    replace lname with fgcod->NAME
    
    
    select nlTAlev
    seek "2"
    if .not. found()
    append blank
    replace TAlevel1 with "2"
    endif
    replace lname with "COST OF SALES"
    REPLACE SNAME WITH "C O S"
    SELECT NLTALEL
    seek "2"+PTYP
    IF .NOT. FOUND()
    APPEND BLANK
    replace TAlevel1 with "2"
    replace TAlevel2 with PTYP
    ENDIF
    REPLACE LNAME WITH fgtyp->NAME
    SELECT NLTALE3
    seek "2"+PTYP+PCLA
    IF .NOT. FOUND()
    APPEND BLANK
    replace TAlevel1 with "2"
    replace TAlevel2 with PTYP
   REPLACE TALEVEL3 WITH PCLA
    
    ENDIF
    REPLACE LNAME WITH fgcla->NAME
  
    select nlacc
    replace talevel1 with "2"
    replace talevel2 WITH PTYP
    REPLACE TALEVEL3 WITH PCLA
    REPLACE TA WITH PCOD
    
    
Procedure cost_sales_rtn3
    do nlta2_rtn3
    do nlbs1_rtn
    do nlie1_rtn
   
Procedure nlta2_rtn3  	 && trading account
  select nlTA
    seek "2"+PTYP+PCLA+"00" && surplus
    if .not. found()
    append blank
    replace TA with "00"
    replace TAlevel1 with "2"
    replace TAlevel2 with PTYP
    REPLACE TALEVEL3 WITH PCLA
    endif
    replace lname with fgcla->NAME
    REPLACE UNIT WITH ""
    
    select nlTAlev
    seek "2"
    if .not. found()
    append blank
    replace TAlevel1 with "2"
    endif
    replace lname with "COST OF SALES"
    SELECT NLTALEL
    seek "2"+PTYP
    IF .NOT. FOUND()
    APPEND BLANK
    replace TAlevel1 with "2"
    replace TAlevel2 with PTYP
    ENDIF
    REPLACE LNAME WITH fgtyp->NAME
    SELECT NLTALE3
    seek "2"+PTYP+PCLA
    IF .NOT. FOUND()
    APPEND BLANK
    replace TAlevel1 with "2"
    replace TAlevel2 with PTYP
   REPLACE TALEVEL3 WITH PCLA
    
    ENDIF
    REPLACE LNAME WITH fgcla->NAME
  
    select nlacc
    replace talevel1 with "2"
    replace talevel2 WITH PTYP
    REPLACE TALEVEL3 WITH PCLA
    REPLACE TA WITH "00"
   
  