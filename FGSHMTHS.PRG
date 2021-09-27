
                
**************************************************************************
*  PROGRAM:     fgshmths.prg
*
*
*******************************************************************************

Procedure fgshmths
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Updating monthly stock movement in progress... ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power, will take 10-30 ss.",;
    width 80,;
    height 2.5,;
    FontBold .t.,;
    FontSize 11,;
    MousePOinter 11,;
    ColorNormal "n+"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
SET EXACT ON
set view to "fgshmths.QBE"
SET REPROCESS TO 10
SELECT FGCOD
SET ORDER TO MKEY
SELECT FGDATMAS
SET ORDER TO MKEY
SELECT MSHSTCST
SET ORDER TO MKEY
SELECT ASHSTCST
SET ORDER TO MKEY
SELECT DACOYSUM
SET ORDER TO MKEY

select mshstmas
set order to mkey
select Ashstmas
set order to mkey
select dshstmas
set order to mkey
go top
if .not. eof()
      do fgshmths_RTN1
   set safety off
  
 endif
 eofhshstmon = .f.
 select hshstmon
 go top
    if .not. eof()
       do
          do hshstmon_rtn
      until eofhshstmon
  endif
* EOFMSHSTMAS = .F.
 * SELECT MSHSTMAS
*  SET FILTER TO STD_COST = 0 .OR. SALE_PRICE = 0
*  GO TOP
*  IF .NOT. EOF()
*     DO
*        DO FINISH_RTN
*      UNTIL EOFMSHSTMAS
*      ENDIF
      
      close databases
      progreps.close()
      QUIT

PROCEDURE FINISH_RTN
      PCOY = MSHSTMAS->COY
      PTYP = MSHSTMAS->TYP
      PCLA = MSHSTMAS->CLA
      PCOD = MSHSTMAS->COD
      PYY = MSHSTMAS->YY
      PMM = MSHSTMAS->MM
      SELECT MSHSTCST
      SEEK PCOY+PTYP+PCLA+PCOD+PYY+PMM
      IF FOUND() 
      SELECT MSHSTMAS
      REPLACE STD_COST WITH MSHSTCST->STD_COST
      REPLACE SALE_price with mshstcst->sale_price
     endif
     select mshstmas
     if .not. eof()
     skip
     else
     eofmshstmas = .t.
     endif
     if eof()
     eofmshstmas = .t.
     endif
Procedure hshstmon_rtn
         pcoy = hshstmon->coy
         pdiv = hshstmon->div
         pcen = hshstmon->cen
         psto = hshstmon->sto
         ptyp = hshstmon->typ
         pcla = hshstmon->cla
         pcod = hshstmon->cod
         pyy = hshstmon->yy
         pmm = hshstmon->mm
          select mshstmas
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy+pmm
   if  found()
   replace phy with   hshstmon->phy
   endif
           select Ashstmas
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy
   if  found()
   replace phy with   hshstmon->phy
   endif
   select   hshstmon
   if .not. eof()
   skip
   else
   eofhshstmon = .t.
   endif
   if eof()
   eofhshstmon = .t.
   endif

Procedure fgshmths_RTN1
   private EOFST15F,eofdshstmas,poshdate,poshno,pnshdate,pnshno,pok,ptyp,pcla,pcod,;
   pcoy,eofshstmwkf,poyy,pomm,pnyy,pnmm,eofshcatsum,pyy,pmm,pqtr,pnqtr,ppqtr,POSHID,PNSHID,;
   ppqty,ppval,psqty,psval
   pok = .t.
        eofdshstmas = .f.
  select dshstmas
  SET FILTER TO .not. empty(shift_date) .and. .not. empty(typ) ;
     .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(coy) ;
      .and. .not. empty(div) .and. .not. empty(cen) .and. .not. empty(sto)
  GO TOP
     IF .NOT. EOF()
      do
        do dshstmas_rtn1
        until eofdshstmas
        ENDIF
         
   procedure dshstmas_rtn1
    local l1,L2,L3,L4
    L2 = DTOS(dshstmas->SHIFT_DATE) && YYYYMMDD
    L3 = LEFT(L2,6) && YYYYMM
      pyy = LEFT(L2,4) && YYYY
      pmm  = RIGHT(L3,2) && MM
      ppdate = dshstmas->shift_date - 1
      pndate = dshstmas->shift_date + 1
      poshdate = dshstmas->shift_date
       l1 = val(pmm)
      pqtr = "9"
      ppqtr = "9"
      pnqtr = "9"
      if l1 = 1  .or. l1 = 2 .or. l1 = 3
      pqtr = "1"
      ppqtr = "4"
      pnqtr = "2"
      endif
       if l1 = 4  .or. l1 = 5 .or. l1 = 6
      pqtr = "2"
      ppqtr = "1"
      pnqtr = "3"
      endif
       if l1 = 7  .or. l1 = 8 .or. l1 = 9
      pqtr = "3"
      ppqtr = "2"
      pnqtr = "4"
      endif
       if l1 = 10 .or. l1 = 11 .or. l1 = 12
      pqtr = "4"
      ppqtr = "3"
      pnqtr = "1"
      endif
        if pmm = "12"
      pnmm = "01"
      pnyy = str(val(pyy)+1,4)
      else
      pnmm = str(val(pmm)+1,2)
      pnyy = pyy
      endif
      if pmm = "01"
      ppmm = "12"
      ppyy = str(val(pyy)-1,4)
      else
      ppmm = str(val(pmm)-1,2)
      ppyy = pyy
      endif
       LOCAL L1,L2,L3,L4,L5,L6
   L1 = DAY(poshdate)
   L2 = MONTH(poshdate)
   L3 = YEAR(poshdate)
   IF L2 = 1
   L2 = 12
   L3 = L3 - 1
   ELSE
   L2 = L2 - 1
   ENDIF
   L6 = STR(L1,2)+"/"+STR(L2,2)+"/"+STR(L3,4)
      
      pcoy = dshstmas->coy
      pdiv = dshstmas->div
   ptyp = dshstmas->TYP
   pcla = dshstmas->cla
   pcod = dshstmas->cod
   psto = dshstmas->sto
   pcen = dshstmas->cen
   pcost = 0
   pvat = 0
   PPRICE = 0
   SELECT FGCOD
   SEEK PTYP+PCLA+PCOD
   IF FOUND() 
   PCOST = COST_PRICE
   PPRICE = SALE_PRICE
   ELSE
   PCOST = 0
   PPRICE = 0
   ENDIF
   if   dshstmas->std_cost > 0
   pcost = dshstmas->std_cost
   endif
   
SELECT ASHSTCST
      SEEK PCOY+PTYP+PCLA+PCOD+pyy
      IF .NOT. FOUND()
      APPEND BLANK
      replace coy with pcoy
      replace typ with ptyp
      replace cla with pcla
      replace cod with pcod
      replace yy with pyy
      REPLACE CS_SALES WITH 0
      REPLACE CS_PURCH WITH 0
      REPLACE CR_SALES WITH 0
      REPLACE CR_PURCH WITH 0
      REPLACE CS_SALES_A WITH 0
      REPLACE CS_PURCH_A WITH 0
      REPLACE CR_SALES_A WITH 0
      REPLACE CR_PURCH_A WITH 0
      REPLACE SALE_PRICE WITH 0
      REPLACE STD_COST WITH 0
      ENDIF
      REPLACE  CS_SALES WITH CS_SALES + DSHSTMAS->CS_SALES
      REPLACE  CR_SALES WITH CR_SALES + DSHSTMAS->CR_SALES
      REPLACE  CS_SALES_A WITH CS_SALES_A + DSHSTMAS->CS_SALES_A
      REPLACE  CR_SALES_A WITH CR_SALES_A + DSHSTMAS->CR_SALES_A
      REPLACE  CS_PURCH WITH CS_PURCH + DSHSTMAS->CS_PURCH
      REPLACE  CR_PURCH WITH CR_PURCH + DSHSTMAS->CR_PURCH
      REPLACE  CS_PURCH_A WITH CS_PURCH_A + DSHSTMAS->CS_PURCH_A
      REPLACE  CR_PURCH_A WITH CR_PURCH_A + DSHSTMAS->CR_PURCH_A
    PPQTY = CR_PURCH + CS_PURCH
    PPVAL = CR_PURCH_A + CS_PURCH_A
    PSQTY = CR_SALES+ CS_SALES
    PSVAL = CR_SALES_A + CS_SALES_A
    
    IF .NOT. PPQTY = 0 .and. .not. pcost > 0
    REPLACE STD_COST WITH PPVAL/PPQTY
    if dshstmas->std_vat > 0 
    pvatr = dshstmas->std_vat + 100
    replace std_cost with std_cost/pvatr*100
    endif
    ELSE
  REPLACE STD_COST WITH PCOST
    ENDIF
    
      IF .NOT. PSQTY = 0
    REPLACE SALE_PRICE WITH PSVAL/PSQTY
    ELSE
    REPLACE SALE_PRICE WITH PPRICE
    ENDIF
    
 
   SELECT MSHSTCST
      SEEK PCOY+PTYP+PCLA+PCOD+pyy+pmm
      IF .NOT. FOUND()
      APPEND BLANK
        replace coy with pcoy
      replace typ with ptyp
      replace cla with pcla
      replace cod with pcod
      replace yy with pyy
      replace mm with pmm
      REPLACE CS_SALES WITH 0
      REPLACE CS_PURCH WITH 0
      REPLACE CR_SALES WITH 0
      REPLACE CR_PURCH WITH 0
      REPLACE CS_SALES_A WITH 0
      REPLACE CS_PURCH_A WITH 0
      REPLACE CR_SALES_A WITH 0
      REPLACE CR_PURCH_A WITH 0
      REPLACE SALE_PRICE WITH 0
      REPLACE STD_COST WITH 0
      ENDIF
      REPLACE  CS_SALES WITH CS_SALES + DSHSTMAS->CS_SALES
      REPLACE  CR_SALES WITH CR_SALES + DSHSTMAS->CR_SALES
      REPLACE  CS_SALES_A WITH CS_SALES_A + DSHSTMAS->CS_SALES_A
      REPLACE  CR_SALES_A WITH CR_SALES_A + DSHSTMAS->CR_SALES_A
      REPLACE  CS_PURCH WITH CS_PURCH + DSHSTMAS->CS_PURCH
      REPLACE  CR_PURCH WITH CR_PURCH + DSHSTMAS->CR_PURCH
      REPLACE  CS_PURCH_A WITH CS_PURCH_A + DSHSTMAS->CS_PURCH_A
      REPLACE  CR_PURCH_A WITH CR_PURCH_A + DSHSTMAS->CR_PURCH_A
    PPQTY = CR_PURCH + CS_PURCH
    PPVAL = CR_PURCH_A + CS_PURCH_A
    PSQTY = CR_SALES+ CS_SALES
    PSVAL = CR_SALES_A + CS_SALES_A
    
   IF .NOT. PPQTY = 0 .and. .not. pcost > 0
    REPLACE STD_COST WITH PPVAL/PPQTY
    if dshstmas->std_vat > 0 
    pvatr = dshstmas->std_vat + 100
    replace std_cost with std_cost/pvatr*100
    endif
    ELSE
  REPLACE STD_COST WITH PCOST
    ENDIF
    
      IF .NOT. PSQTY = 0
    REPLACE SALE_PRICE WITH PSVAL/PSQTY
    ELSE
    REPLACE SALE_PRICE WITH PPRICE
    ENDIF
    
  
  
       select mshstmas
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy+pmm
   if .not. found()
   append blank
   replace yy with pyy
   replace mm with pmm
   replace sto with psto
    replace coy with dshstmas->coy
    replace div with pdiv
    replace cen with pcen
      replace typ with dshstmas->tyP
      replace cla with dshstmas->cla
      replace cod with dshstmas->cod
      replace cs_purch with dshstmas->cs_purch
      replace cr_purch with dshstmas->cr_purch
      replace cs_sales with dshstmas->cs_sales
       replace cr_sales with dshstmas->cr_sales
      replace trans_in with dshstmas->trans_in
      replace trans_out with dshstmas->trans_out
      replace adj_in with dshstmas->adj_in
      replace adj_out with dshstmas->adj_out
      replace bbf with dshstmas->bbf
      replace phy    with dshstmas->phy
   
      replace on_hand with dshstmas->on_hand
      replace cs_purch_a with dshstmas->cs_purch_a
      replace cr_purch_a with dshstmas->cr_purch_a
      replace cs_sales_a with dshstmas->cs_sales_a
       replace cr_sales_a with dshstmas->cr_sales_a
         
    else
    
    replace cs_purch_a with dshstmas->cs_purch_a + cs_purch_a
      replace cr_purch_a with dshstmas->cr_purch_a + cr_purch_a
      replace cs_sales_a with dshstmas->cs_sales_a  + cs_sales_a
      replace cr_sales_a with dshstmas->cr_sales_a + cr_sales_a
  replace cs_purch with dshstmas->cs_purch + cs_purch
      replace cr_purch with dshstmas->cr_purch + cr_purch
      replace cs_sales with dshstmas->cs_sales  + cs_sales
      replace cr_sales with dshstmas->cr_sales + cr_sales
      replace trans_in with dshstmas->trans_in + trans_in
      replace trans_out with dshstmas->trans_out + trans_out
      replace adj_in with dshstmas->adj_in + adj_in
      replace adj_out with dshstmas->adj_out + adj_out
      replace phy    with dshstmas->phy
   
      replace on_hand with on_hand + dshstmas->cs_purch + dshstmas->cr_purch;
                                   + dshstmas->trans_in + dshstmas->adj_in - dshstmas->adj_out;
                                   - dshstmas->trans_out - dshstmas->cs_sales ;
                                   - dshstmas->cr_sales
    endif
    PPQTY = CR_PURCH + CS_PURCH
    PPVAL = CR_PURCH_A + CS_PURCH_A
    PSQTY = CR_SALES+ CS_SALES
    PSVAL = CR_SALES_A + CS_SALES_A
    
   IF .NOT. PPQTY = 0 .and. .not. pcost > 0
    REPLACE STD_COST WITH PPVAL/PPQTY
    if dshstmas->std_vat > 0 
    pvatr = dshstmas->std_vat + 100
    replace std_cost with std_cost/pvatr*100
    endif
    ELSE
  REPLACE STD_COST WITH PCOST
    ENDIF
    
      IF .NOT. PSQTY = 0
    REPLACE SALE_PRICE WITH PSVAL/PSQTY
    ELSE
    REPLACE SALE_PRICE WITH PPRICE
    ENDIF
    
  replace std_vat with dshstmas->std_vat
      if div = "1" .and. phy = 0 && forecourt stores
         replace phy with on_hand
         endif
         if .not. dshstmas->phy = 0
         replace phy with dshstmas->phy
         endif
         
 
  
       select FGDATMAS
      seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+DTOS(DSHSTMAS->SHIFT_DATE)
      IF .NOT. FOUND()
   append blank
   replace SHIFT_DATE WITH DSHSTMAS->SHIFT_DATE
     replace coy with dshstmas->coy
    replace div with pdiv
    replace cen with pcen
    REPLACE STO WITH psto
      replace typ with dshstmas->tyP
      replace cla with dshstmas->cla
      replace cod with dshstmas->cod
      replace purch with dshstmas->cs_purch + dshstmas->cr_purch
      replace sales with dshstmas->cs_sales +  dshstmas->cr_sales
      replace trans with dshstmas->trans_in - dshstmas->trans_out
      replace adj with dshstmas->adj_in - dshstmas->adj_out
      replace bbf with dshstmas->bbf
      replace phy    with dshstmas->phy
      replace on_hand with dshstmas->on_hand
      replace Purch_a with dshstmas->cs_purch_a + dshstmas->cr_purch_a
      replace sales_a with dshstmas->cs_sales_a + dshstmas->cr_sales_a
       replace std_cost with dshstmas->std_cost
    replace std_vat with dshstmas->std_vat
    REPLACE SALE_pRICE WITH dshstmas->sale_PRICE
    ENDIF
      
         
         
       select ASHSTMAS
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy
   if .not. found()
   append blank
   replace yy with pyy
   replace sto with psto
    replace coy with dshstmas->coy
    replace div with pdiv
    replace cen with pcen
      replace typ with dshstmas->tyP
      replace cla with dshstmas->cla
      replace cod with dshstmas->cod
      replace cs_purch with dshstmas->cs_purch
      replace cr_purch with dshstmas->cr_purch
      replace cs_sales with dshstmas->cs_sales
       replace cr_sales with dshstmas->cr_sales
      replace trans_in with dshstmas->trans_in
      replace trans_out with dshstmas->trans_out
      replace adj_in with dshstmas->adj_in
      replace adj_out with dshstmas->adj_out
      replace bbf with dshstmas->bbf
      replace phy    with dshstmas->phy
      replace on_hand with dshstmas->on_hand
      replace cs_purch_a with dshstmas->cs_purch_a
      replace cr_purch_a with dshstmas->cr_purch_a
      replace cs_sales_a with dshstmas->cs_sales_a
       replace cr_sales_a with dshstmas->cr_sales_a
    
         
    else
    
    replace cs_purch_a with dshstmas->cs_purch_a + cs_purch_a
      replace cr_purch_a with dshstmas->cr_purch_a + cr_purch_a
      replace cs_sales_a with dshstmas->cs_sales_a  + cs_sales_a
      replace cr_sales_a with dshstmas->cr_sales_a + cr_sales_a

  
  replace cs_purch with dshstmas->cs_purch + cs_purch
      replace cr_purch with dshstmas->cr_purch + cr_purch
      replace cs_sales with dshstmas->cs_sales  + cs_sales
      replace cr_sales with dshstmas->cr_sales + cr_sales
      replace trans_in with dshstmas->trans_in + trans_in
      replace trans_out with dshstmas->trans_out + trans_out
      replace adj_in with dshstmas->adj_in + adj_in
      replace adj_out with dshstmas->adj_out + adj_out
      replace phy    with dshstmas->phy
   
      replace on_hand with on_hand + dshstmas->cs_purch + dshstmas->cr_purch;
                                   + dshstmas->trans_in + dshstmas->adj_in - dshstmas->adj_out;
                                   - dshstmas->trans_out - dshstmas->cs_sales ;
                                   - dshstmas->cr_sales
    endif
      
  PPQTY = CR_PURCH + CS_PURCH
    PPVAL = CR_PURCH_A + CS_PURCH_A
    PSQTY = CR_SALES+ CS_SALES
    PSVAL = CR_SALES_A + CS_SALES_A
    IF .NOT. PPQTY = 0 .and. .not. pcost > 0
    REPLACE STD_COST WITH PPVAL/PPQTY
    if dshstmas->std_vat > 0 
    pvatr = dshstmas->std_vat + 100
    replace std_cost with std_cost/pvatr*100
    endif
    ELSE
  REPLACE STD_COST WITH PCOST
    ENDIF
    
      IF .NOT. PSQTY = 0
    REPLACE SALE_PRICE WITH PSVAL/PSQTY
    ELSE
    REPLACE SALE_PRICE WITH PPRICE
    ENDIF
  
    replace std_vat with dshstmas->std_vat
      if div = "1" .and. phy = 0 && forecourt stores
         replace phy with on_hand
         endif
         if .not. dshstmas->phy = 0
         replace phy with dshstmas->phy
         endif
     
     PCOY = "1"
    IF .NOT. EMPTY(DSHSTMAS->SHIFT_DATE)
    select DACOYSUM
          seek dtos(DSHSTMAS->SHIFT_DATE)+pcoy
          if .not. found()
          append blank
          replace coy with pcoy
          replace shift_date with DSHSTMAS->SHIFT_DATE
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0

          endif
          ENDIF
 
         
            
              select dshstmas
              if .not. eof()
      skip
      else
       eofdshstmas = .t.
       endif
      if eof()
      eofdshstmas = .t.
      endif
  
