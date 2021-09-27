procedure STSTOH
ON ERROR DO QBEERR WITH ERROR(), MESSAGE(),;
PROGRAM(), LINENO()
close databases
EOFSTSTOH = .F.
USE \KENSERVE\IDSSYS\STSTOS.DBF
SET SAFETY OFF
COPY STRU TO \KENSERVICE\DATA\STSTOS DBASE PROD
USE \KENSERVICE\DATA\STSTOS.DBF
APPE FROM \KENSERVICE\DATA\STSTO.DBF
CLOSE DATABASES

SET EXACT ON
      select 1
         use \KENSERVE\IDSSYS\STSTOH.DBF
         SELECT 2
         USE \KENSERVICE\DATA\STSTO.DBF
         SELECT 3
         USE \KENSERVICE\DATA\FGCEN.DBF
         SELECT 4
         use \KENSERVE\IDSSYS\FGCENH.DBF
         SELECT 5
         USE \KENSERVICE\DATA\FGTYP.DBF
          SELECT 6
         use \KENSERVE\IDSSYS\FGTYPH.DBF
         SELECT 7
         USE \KENSERVICE\DATA\FGTYPS.DBF
         
          SELECT 8
         USE \KENSERVICE\DATA\fgdiv.DBF
          SELECT 9
         use \KENSERVE\IDSSYS\fgdivH.DBF
         SELECT 10
         USE \KENSERVICE\DATA\fgdivS.DBF
         
 
          SELECT 11
         USE \KENSERVICE\DATA\FGCLA.DBF
          SELECT 12
         use \KENSERVE\IDSSYS\FGCLAH.DBF
         SELECT 13
         USE \KENSERVICE\DATA\FGCLAS.DBF
         select 14
         use \kenservice\data\fgcod.dbf && delete items with no fgcla and no fgtyp
         select 15
         use \kenservice\data\fgmast.dbf
         SELECT 16
         USE \KENSERVE\IDSSYS\FGCODH.DBF
         SELECT 17
         USE \KENSERVICE\DATA\FRIGHTER.DBF
          SELECT 18
         USE \KENSERVICE\DATA\VENDOR.DBF
           select 20
         use \kenservice\data\fgcods.dbf && delete items with no fgcla and no fgtyp
               SELECT 25
         USE \KENSERVICE\DATA\FGUNIT.DBF
          SELECT 26
         use \KENSERVE\IDSSYS\FGUNITH.DBF
         SELECT 27
         USE \KENSERVICE\DATA\FGUNITS.DBF
         select 19
         use \kenservice\data\fgcoy.dbf
         go TOP
         ptransp = .f.
         if doc14
         ptransp = .t.
         endif
         if .not. ptransp
          SELECT STSTO
         SET ORDER TO STO
         SELECT STSTOH
         SET FILTER TO .NOT. EMPTY(STO) .AND. .NOT. EMPTY(NAME)
         GO TOP
         IF .NOT. EOF()
            DO
               DO RTN1
             UNTIL EOFSTSTOH
           ENDIF
        EOFFGCENH = .F.
        SELECT FGCEN
        SET ORDER TO MKEY
        SELECT FGCENH
        SET FILTER TO .NOT. EMPTY(COY) .AND. .NOT. EMPTY(DIV) .AND. .NOT. EMPTY(CEN) .AND. .NOT. EMPTY(NAME) ;
        .AND. .NOT. EMPTY(COY1) .AND. .NOT. EMPTY(DIV1) .AND. .NOT. EMPTY(CEN1)
        GO TOP
        IF .NOT. EOF()
           DO
              DO RTN3
              UNTIL EOFFGCENH
           ENDIF
           
      EOFFGTYPH = .F.
        SELECT FGTYP
        SET ORDER TO TYP
        SELECT FGTYPH
        SET FILTER TO .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(NAME)
        GO TOP
        IF .NOT. EOF()
           DO
              DO RTN5
              UNTIL EOFFGTYPH
           ENDIF
            EOFFGUNITH = .F.
           SELECT FGUNIT
        SET ORDER TO UNIT
        SELECT FGUNITH
        SET FILTER TO .NOT. EMPTY(UNIT) .AND. .NOT. EMPTY(NAME) .AND. VOLUME > 0
        GO TOP
        IF .NOT. EOF()
           DO
              DO FGUNIT_RTN
              UNTIL EOFFGUNITH
           ENDIF
           EOFfgdivH = .F.
        SELECT fgdiv
        SET ORDER TO mkey
        SELECT fgdivH
        SET FILTER TO .NOT. EMPTY(coy) .AND. .NOT. EMPTY(NAME) .and. .not. empty(div)
        GO TOP
        IF .NOT. EOF()
           DO
              DO RTN51
              UNTIL EOFfgdivH
           ENDIF
           endif
? 'vendor'
        SELECT VENDOR
              SET ORDER TO VENDOR
              SEEK "1"+"1"+"1"+"0001"
              IF .NOT. FOUND()
            APPEND BLANK
         REPLACE VTYP WITH "1"
         REPLACE VPMOD WITH "1"
         REPLACE VSRCE WITH "1"
         REPLACE VENDOR_N WITH "0001"
         REPLACE NAME WITH "PETTY CASH"
            replace bal_this with 0   
     replace bal_30 with 0    
     replace bal_60 with 0    
     replace bal_90 with 0    
     replace bal_120 with 0    
     replace bbf with 0    
    replace bal_due with 0
     replace bal_due_dr with 0
     replace bal_due_cr with 0   
     replace bbf_cr with 0    
     replace bbf_dr with 0   
     replace bal_15 with 0
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace cdep_amt with 0
     REPLACE CREDIT_LMT WITH 0
         replace open_bal with 0
         replace debits with 0
         replace credits with 0
         replace bl_due with 0
         REPLACE OPEN_USER WITH "SYSTEM"
         REPLACE OPEN_TIME WITH TIME()
       ENDIF
      
 if .not. ptransp
    EOFFGCLAH = .F.
        SELECT FGCLA
        SET ORDER TO mkey
        SELECT FGCLAH
        SET FILTER TO .NOT. EMPTY(TYP) .AND. .NOT. EMPTY(NAME) .and. .not. empty(CLA)
        GO TOP
        IF .NOT. EOF()
           DO
              DO RTN61
              UNTIL EOFFGCLAH
           ENDIF
           endif
        select fgcla
set order to mkey
select fgtyp
set order to typ
EOFfgcod = .F.
select fgmast
set order to mkey2
           
    EOFFGCODH = .F.
    select fgcods
    set order to mkey
        SELECT FGCOD
         SET ORDER TO mkey
        SELECT FGCODH
        if  ptransp
        set filter to typ > '9Z' .and. .not. typ = 'E0'
        go top
        endif
         GO TOP
        IF .NOT. EOF()
           DO
              DO FGCOD_NEW_RTN
              UNTIL EOFFGCODH
           ENDIF
            SELECT FRIGHTER
              SET ORDER TO FRIGHTER
                SEEK "1"+"1"+"1"+"0001"
              IF .NOT. FOUND()
            APPEND BLANK
         REPLACE FTYP WITH "1"
         REPLACE PMOD WITH "1"
         REPLACE SOURCE WITH "1"
         REPLACE FRIGHTER_N WITH "0001"
         REPLACE NAME WITH "CASH SALES"
         REPLACE CATEGORY WITH "1"
         REPLACE CATNAME WITH "CASH"
       replace bal_this with 0   
     replace bal_30 with 0    
     replace bal_60 with 0    
     replace bal_90 with 0    
     replace bal_120 with 0    
     replace bbf with 0    
    replace bal_due with 0
     replace bal_due_dr with 0
     replace bal_due_cr with 0   
     replace bbf_cr with 0    
     replace bbf_dr with 0   
     replace bal_15 with 0
     replace turnover with 0
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace cdep_amt with 0
     replace cr_days with 0
     REPLACE CREDIT_LMT WITH 0
         replace open_bal with 0
         replace debits with 0
         replace credits with 0
         replace bl_due with 0
         REPLACE OPEN_USER WITH "SYSTEM"
         REPLACE OPEN_TIME WITH TIME()
       ENDIF
            SEEK "3"+"3"+"3"+"0001"
              IF .NOT. FOUND()
            APPEND BLANK
         REPLACE FTYP WITH "3"
         REPLACE PMOD WITH "3"
         REPLACE SOURCE WITH "3"
         REPLACE FRIGHTER_N WITH "0001"
         REPLACE NAME WITH "COMPANY CREDIT CARD (POS)"
         REPLACE CATEGORY WITH "3"
         REPLACE CATNAME WITH "CREDIT CARDS"
       replace bal_this with 0   
     replace bal_30 with 0    
     replace bal_60 with 0    
     replace bal_90 with 0    
     replace bal_120 with 0    
     replace bbf with 0    
    replace bal_due with 0
     replace bal_due_dr with 0
     replace bal_due_cr with 0   
     replace bbf_cr with 0    
     replace bbf_dr with 0   
     replace bal_15 with 0
     replace turnover with 0
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace cdep_amt with 0
     replace cr_days with 0
     REPLACE CREDIT_LMT WITH 0
         replace open_bal with 0
         replace debits with 0
         replace credits with 0
         replace bl_due with 0
         REPLACE OPEN_USER WITH "SYSTEM"
         REPLACE OPEN_TIME WITH TIME()
       ENDIF
            SEEK "7"+"7"+"7"+"0001"
              IF .NOT. FOUND()
            APPEND BLANK
         REPLACE FTYP WITH "7"
         REPLACE PMOD WITH "7"
         REPLACE SOURCE WITH "7"
         REPLACE FRIGHTER_N WITH "0001"
         REPLACE NAME WITH "TOP UP (COMPANY CARD)"
         REPLACE CATEGORY WITH "7"
         REPLACE CATNAME WITH "TOP-UP (COMPANY CARD)"
       replace bal_this with 0   
     replace bal_30 with 0    
     replace bal_60 with 0    
     replace bal_90 with 0    
     replace bal_120 with 0    
     replace bbf with 0    
    replace bal_due with 0
     replace bal_due_dr with 0
     replace bal_due_cr with 0   
     replace bbf_cr with 0    
     replace bbf_dr with 0   
     replace bal_15 with 0
     replace turnover with 0
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace cdep_amt with 0
     replace cr_days with 0
     REPLACE CREDIT_LMT WITH 0
         replace open_bal with 0
         replace debits with 0
         replace credits with 0
         replace bl_due with 0
         REPLACE OPEN_USER WITH "SYSTEM"
         REPLACE OPEN_TIME WITH TIME()
       ENDIF
       SEEK "9"+"9"+"9"+"0001"
              IF .NOT. FOUND()
            APPEND BLANK
         REPLACE FTYP WITH "9"
         REPLACE PMOD WITH "9"
         REPLACE SOURCE WITH "9"
         REPLACE FRIGHTER_N WITH "0001"
         REPLACE NAME WITH "CASH EXCESS"
         REPLACE CATEGORY WITH "9"
         REPLACE CATNAME WITH "STAFF"
         REPLACE VAGE WITH "C"
       replace bal_this with 0   
     replace bal_30 with 0    
     replace bal_60 with 0    
     replace bal_90 with 0    
     replace bal_120 with 0    
     replace bbf with 0    
    replace bal_due with 0
     replace bal_due_dr with 0
     replace bal_due_cr with 0   
     replace bbf_cr with 0    
     replace bbf_dr with 0   
     replace bal_15 with 0
     replace turnover with 0
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace cdep_amt with 0
     replace cr_days with 0
     REPLACE CREDIT_LMT WITH 0
         replace open_bal with 0
         replace debits with 0
         replace credits with 0
         replace bl_due with 0
         REPLACE OPEN_USER WITH "SYSTEM"
         REPLACE OPEN_TIME WITH TIME()
       ENDIF
       SEEK "S"+"S"+"S"+"0001"
              IF .NOT. FOUND()
            APPEND BLANK
         REPLACE FTYP WITH "S"
         REPLACE PMOD WITH "S"
         REPLACE SOURCE WITH "S"
         REPLACE FRIGHTER_N WITH "0001"
         REPLACE NAME WITH "HQ STAFF"
         REPLACE CATEGORY WITH "S"
         REPLACE CATNAME WITH "HQ STAFF"
         REPLACE VAGE WITH ""
       replace bal_this with 0   
     replace bal_30 with 0    
     replace bal_60 with 0    
     replace bal_90 with 0    
     replace bal_120 with 0    
     replace bbf with 0    
    replace bal_due with 0
     replace bal_due_dr with 0
     replace bal_due_cr with 0   
     replace bbf_cr with 0    
     replace bbf_dr with 0   
     replace bal_15 with 0
     replace turnover with 0
     replace l_pay_amt with 0
     replace l_inv_amt with 0
     replace cdep_amt with 0
     replace cr_days with 0
     REPLACE CREDIT_LMT WITH 0
     REPLACE CLOSE_DATE WITH DATE()
         replace open_bal with 0
         replace debits with 0
         replace credits with 0
         replace bl_due with 0
         REPLACE OPEN_USER WITH "SYSTEM"
         REPLACE OPEN_TIME WITH TIME()
        ENDIF
       
      close databases
PROCEDURE FGCOD_NEW_RTN
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()
      SELECT FGCOD
      SEEK FGCODH->TYP+FGCODH->CLA+FGCODH->COD
      IF .NOT. FOUND()
      APPEND BLANK
      REPLACE TYP WITH FGCODH->TYP
      REPLACE CLA WITH FGCODH->CLA
      REPLACE COD WITH FGCODH->COD
      REPLACE NAME WITH FGCODH->NAME
      REPLACE SCODE WITH FGCODH->SCODE
      REPLACE SALE_PRICE WITH 0
      REPLACE UNIT WITH FGCODH->UNIT
      REPLACE VAT WITH FGCODH->VAT
      REPLACE ITEMS_UNIT WITH FGCODH->ITEMS_UNIT
      REPLACE TAX_TYPE WITH FGCODH->TAX_TYPE
      REPLACE ACTIVE WITH FGCODH->ACTIVE
      REPLACE UNITNAME WITH FGCODH->UNITNAME
      REPLACE TAXNAME WITH FGCODH->TAXNAME
      REPLACE CNAME  WITH FGCODH->CNAME
      REPLACE COY WITH FGCODH->COY
      REPLACE DIV WITH FGCODH->DIV
      REPLACE CEN WITH FGCODH->CEN
      REPLACE TAX_NAME WITH FGCODH->TAX_NAME
      REPLACE UNIT_NAME WITH FGCODH->UNIT_NAME
      REPLACE STO WITH FGCODH->STO
      REPLACE VOLUME WITH FGCODH->VOLUME
      REPLACE CAPACITY WITH FGCODH->CAPACITY
      REPLACE SHS_AUTO WITH FGCODH->SHS_AUTO
      REPLACE QTY WITH FGCODH->QTY
      REPLACE ACTIVE WITH 'Yes'
      REPLACE STONAME WITH FGCODH->STONAME  
      REPLACE FCPURCH WITH FGCODH->FCPURCH
      select fgcods
       APPEND BLANK
       REPLACE VAT WITH FGCODH->VAT
      REPLACE TYP WITH FGCODH->TYP
      REPLACE CLA WITH FGCODH->CLA
      REPLACE COD WITH FGCODH->COD
      REPLACE NAME WITH FGCODH->NAME
      REPLACE SCODE WITH FGCODH->NAME
      REPLACE SALE_PRICE WITH 0
      REPLACE UNIT WITH FGCODH->UNIT
      REPLACE ITEMS_UNIT WITH FGCODH->ITEMS_UNIT
      REPLACE TAX_TYPE WITH FGCODH->TAX_TYPE
      REPLACE ACTIVE WITH FGCODH->ACTIVE
        REPLACE COY WITH FGCODH->COY
      REPLACE DIV WITH FGCODH->DIV
      REPLACE CEN WITH FGCODH->CEN
      REPLACE TAX_NAME WITH FGCODH->TAX_NAME
      REPLACE UNIT_NAME WITH FGCODH->UNIT_NAME
      REPLACE STO WITH FGCODH->STO
      REPLACE VOLUME WITH FGCODH->VOLUME
      REPLACE CAPACITY WITH FGCODH->CAPACITY
      REPLACE SHS_AUTO WITH FGCODH->SHS_AUTO
      REPLACE QTY WITH FGCODH->QTY
      REPLACE ACTIVE WITH 'Yes'
*      REPLACE STONAME WITH FGCODH->STONAME  
      REPLACE FCPURCH WITH FGCODH->FCPURCH
         IF .NOT. EMPTY(FGCODH->cOY) .AND. .NOT. EMPTY(FGCODH->DIV) .AND. .NOT. EMPTY(FGCODH->CEN);
    .AND. .NOT. EMPTY(FGCODH->STO) .AND. .NOT. EMPTY(FGCODH->TYP) .AND. .NOT. EMPTY(FGCODH->CLA);
    .AND. .NOT. EMPTY(FGCODH->COD)
   select fgmast
              append blank
         replace coy with FGCODH->COY
         replace div with FGCODH->DIV
         replace cen with FGCODH->CEN
         replace typ with FGCODH->TYP
         replace cla with FGCODH->CLA
         replace cod with FGCODH->COD
         replace sto with FGCODH->STO
         replace bbf with 0
         replace on_hand with 0
         replace phy with 0
         replace alloc with 0
         replace trans_in with 0
         replace trans_out with 0
         replace purch with 0
         replace sales with 0
         replace adj_in with 0
         replace adj_out with 0
         REPLACE CR_PURCH WITH 0
         REPLACE CS_PURCH WITH 0
         REPLACE CR_SALES  WITH 0
         REPLACE CS_SALES WITH 0
         REPLACE BBF_PHY WITH 0
         REPLACE TEMP_QTY WITH 0
         REPLACE TEMP_PURCH WITH 0
         REPLACE PHY_QTY WITH 0
         REPLACE BCF WITH 0
         REPLACE M_PHY WITH 0
         REPLACE M_VAR WITH 0
         REPLACE OPEN_BAL WITH 0
         REPLACE LAST_PHY WITH 0
         REPLACE  TEMP_PHY WITH 0
         ENDIF
      ENDIF
      COMMIT()
      SELECT FGCODH
      SKIP
      IF EOF()
      EOFFGCODH = .T.
      ENDIF
procedure rtn1
         SELECT STSTO
         SEEK STSTOH->STO
         IF .NOT. FOUND()
            DO RTN2
        ENDIF
        SELECT STSTOH
        SKIP
        IF EOF()
           EOFSTSTOH = .T.
           ENDIF
           
    
PROCEDURE RTN2
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

   SELECT STSTO
   APPEND BLANK
   REPLACE STO WITH STSTOH->STO
   REPLACE PUM WITH STSTOH->PUM
   REPLACE NAME WITH STSTOH->NAME
   REPLACE STO1 WITH STSTOH->STO1
   REPLACE NAME1 WITH STSTOH->NAME1
   REPLACE SNAME WITH STSTOH->SNAME
   REPLACE DAY_RATE WITH 0
   REPLACE NIGHT_RATE WITH 0
   COMMIT()
   
procedure rtn3
         SELECT FGCEN
         SEEK FGCENH->COY+FGCENH->DIV+FGCENH->CEN
         IF .NOT. FOUND()
            DO RTN4
        ENDIF
        SELECT FGCENH
        SKIP
        IF EOF()
           EOFFGCENH = .T.
           ENDIF
           
    
PROCEDURE RTN4
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

   SELECT FGCEN
   APPEND BLANK
   REPLACE COY WITH FGCENH->COY
   REPLACE DIV WITH FGCENH->DIV
   REPLACE CEN WITH FGCENH->CEN
   REPLACE COY1 WITH FGCENH->COY1
   REPLACE DIV1 WITH FGCENH->DIV1
   REPLACE CEN1 WITH FGCENH->CEN1
   REPLACE FUELS WITH FGCENH->FUELS
   REPLACE DAY_RATE WITH 0
   REPLACE NIGHT_RATE WITH 0
   REPLACE NAME WITH FGCENH->NAME
   COMMIT()
   
procedure rtn5
         SELECT FGTYP
         SEEK FGTYPH->TYP
         IF .NOT. FOUND()
            DO RTN6
        ENDIF
        SELECT FGTYPH
        SKIP
        IF EOF()
           EOFFGTYPH = .T.
           ENDIF
           
    
PROCEDURE RTN6
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

   SELECT FGTYP
   APPEND BLANK
   REPLACE TYP WITH FGTYPH->TYP
   REPLACE ACTYPE  WITH FGTYPH->ACTYPE
   REPLACE LNAME WITH FGTYPH->LNAME
    REPLACE TAX_TYPE WITH FGTYPH->TAX_TYPE
   REPLACE RATE WITH FGTYPH->RATE
   REPLACE QTY WITH  FGTYPH->QTY
    REPLACE NAME WITH FGTYPH->NAME
    SELECT FGTYPS
     APPEND BLANK
   REPLACE TYP WITH FGTYPH->TYP
    REPLACE LNAME WITH FGTYPH->LNAME
    REPLACE NAME WITH FGTYPH->NAME
COMMIT()

  procedure FGUNIT_RTN
         SELECT FGUNIT
         SEEK FGUNITH->UNIT
         IF .NOT. FOUND()
            DO FGUNIT_RTN1
        ENDIF
        SELECT FGUNITH
        SKIP
        IF EOF()
           EOFFGUNITH = .T.
           ENDIF
           
    
PROCEDURE FGUNIT_RTN1
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

   SELECT FGUNIT
   APPEND BLANK
   REPLACE UNIT WITH FGUNITH->UNIT
   REPLACE VOLUME WITH  FGUNITH->VOLUME
    REPLACE NAME WITH FGUNITH->NAME
    SELECT FGUNITS
     APPEND BLANK
    REPLACE UNIT WITH FGUNITH->UNIT
   REPLACE VOLUME WITH  FGUNITH->VOLUME
    REPLACE NAME WITH FGUNITH->NAME
  
COMMIT()
         
              
procedure rtn51
         SELECT fgdiv
         SEEK fgdivH->coy+fgdivh->div
         IF .NOT. FOUND()
            DO RTN52
        ENDIF
        SELECT fgdivH
        SKIP
        IF EOF()
           EOFfgdivH = .T.
           ENDIF
           
    
PROCEDURE RTN52
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

   SELECT fgdiv
   APPEND BLANK
   REPLACE coy WITH fgdivH->coy
   REPLACE div  WITH fgdivH->div
   REPLACE NAME WITH fgdivH->NAME
       SELECT fgdivS
     APPEND BLANK
   REPLACE coy WITH fgdivH->coy
   REPLACE div  WITH fgdivH->div
   REPLACE NAME WITH fgdivH->NAME
COMMIT()

procedure rtn61
         SELECT FGCLA
         SEEK FGCLAH->TYP+FGCLAh->CLA
         IF .NOT. FOUND()
            DO rtn62
        ENDIF
        SELECT FGCLAH
        SKIP
        IF EOF()
           EOFFGCLAH = .T.
           ENDIF
           
    
PROCEDURE rtn62
          begintrans()
           on error DO transerr WITH ERROR(), MESSAGE(), PROGRAM(), LINENO()

   SELECT FGCLA
   APPEND BLANK
   REPLACE TYP WITH FGCLAH->TYP
   REPLACE CLA  WITH FGCLAH->CLA
   REPLACE NAME WITH FGCLAH->NAME
   REPLACE VAT WITH FGCLAH->VAT
       SELECT FGCLAS
     APPEND BLANK
   REPLACE TYP WITH FGCLAH->TYP
   REPLACE CLA  WITH FGCLAH->CLA
   REPLACE NAME WITH FGCLAH->NAME
COMMIT()
