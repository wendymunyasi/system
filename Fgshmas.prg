 
                
**************************************************************************
*  PROGRAM:     Fgshmas.prg
*
*
*******************************************************************************

Procedure Fgshmas
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Extracting Stock Records in progress...Wait! ",MDI .F.,;
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
    ColorNormal "b+/Btnface"
    PROGREPS.OPEN()
create session
set talk off
set ldCheck off
set decimals to 4
SET ESCAPE OFF
SET EXACT ON
set view to "Fgshmas.QBE"
SET REPROCESS TO -1
select ststo
set order to sto
select fgcod
   set order to mkey
    select dshstmas
   
   set order to mkey
   select mshstmas
 
   set order to mkey
    select ashstmas
 
   set order to mkey
   SELECT SHSTMAST
   
SELECT MSHSTCST

SET ORDER TO MKEY
SELECT ASHSTCST

SET ORDER TO MKEY
SELECT FGDATMAS

SET ORDER TO MKEY
SELECT DACOYSUM

SET  ORDER TO MKEY
select fgshupiv

go top
if .not. eof() .AND. .NOT. EMPTY(SHIFT_DATE)
quit
endif
IF EOF()
append blank
ENDIF
replace shift_date with date()
replace dde_user with pluser
replace dde_time with time()
      do Fgshmas_RTN1
   set safety off
   select fgshupiv
   zap

      close databases
      progreps.close()
      CLEAR PROGRAM 
    *  do fgshcats.prg with pluser,plevel
      do fgnshmas.prg with pluser,plevel
      CLEAR PROGRAM 
      do fgshcat.prg with pluser,plevel
      CLEAR PROGRAM 
      do fgpurch.prg with pluser,plevel
      CLEAR PROGRAM 
      do fr3052ag.prg with pluser,plevel
      CLEAR PROGRAM 
      do fgshpits.prg with pluser,plevel
      do fgshpitn.prg with pluser,plevel
      CLEAR PROGRAM 
      DO frshtrn.prg with pluser,plevel
    
Procedure Fgshmas_RTN1
   private EOFST15F,eofshstmast,poshdate,poshno,pnshdate,pnshno,pok,ptyp,pcla,pcod,;
   pcoy,eofshstmwkf,poyy,pomm,pnyy,pnmm,eofshcatsum,pyy,pmm,pqtr,pnqtr,ppqtr,POSHID,PNSHID
   pok = .t.
   
  eofshstmast = .f.
  select shstmast
 * set order to mkey
  
    SET FILTER TO EMPTY(POST_DATE) .and. .not. empty(shift_date) .and. .not. empty(typ) ;
     .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(coy) ;
      .and. .not. empty(div) .and. .not. empty(cen) .and. .not. empty(sto) .AND. ;
      .not. (bbf = 0 .and. on_hand=0 .and. phy=0 .and. trans_in = 0 .and. trans_out = 0 ;
    .and. cr_purch = 0 .and. cs_purch = 0 .and. cr_sales=0 .and. CS_SALES = 0 .AND. adj_in = 0 .and. adj_out = 0)
   go top
  if .not. eof()
     do
        do shstmast_rtn1
        until eofshstmast
     endif


     
  procedure shstmast_rtn1
    local l1,L2,L3,L4
    L2 = DTOS(SHSTMAST->SHIFT_DATE) && YYYYMMDD
    L3 = LEFT(L2,6) && YYYYMM
      pyy = LEFT(L2,4) && YYYY
      pmm  = RIGHT(L3,2) && MM
      ppdate = shstmast->shift_date - 1
      pndate = shstmast->shift_date + 1
      poshdate = shstmast->shift_date
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
      
      pcoy = shstmast->coy
      pdiv = shstmast->div
   ptyp = shstmast->TYP
   pcla = shstmast->cla
   pcod = shstmast->cod
   psto = shstmast->sto
   pcen = shstmast->cen
   pcost = 0
   pvat = 0
   PPRICE = 0
   select ststo
   seek psto
   select fgcod
   seek ptyp+pcla+pcod
   if found()
      pcost = cost_price
      PPRICE = SALE_PRICE
       pvat = vat
      endif
     
       select DACOYSUM
          seek dtos(poshdate)+pcoy
          if .not. found()
          append blank
          replace coy with pcoy
          replace shift_date with poshdate
          replace cs_sal_shs with 0
          replace cr_sal_shs with 0
          replace cs_pur_shs with 0
          replace cr_pur_shs with 0
            replace ds_cash with 0
         replace ds_credits with 0
         replace ds_debits with 0
         replace ds_chqs with 0

          endif
*   if .not. (shstmast->cs_purch_a = 0 .and. shstmast->adj_out = 0 ;
    .and. shstmast->cr_sales_a = 0 .and. shstmast->cr_purch_a = 0 ;
     .and. shstmast->cs_purch = 0 .and. shstmast->cr_purch = 0 ;
      .and. shstmast->trans_in = 0 .and. shstmast->adj_in = 0 ;
       .and. shstmast->trans_out = 0 .and. shstmast->phy = 0 ;
        .and. shstmast->cs_sales = 0 .and. shstmast->cr_sales = 0 ;
         .and. shstmast->on_hand = 0 .and. shstmast->bbf = 0)
   
    select dshstmas
   seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+dtos(poshdate)
   if .not. found()
   append blank
   replace yy with pyy
   replace div with pdiv
   replace mm with pmm
    replace coy with pcoy
    replace sto with psto
     replace cen with PCEN
      
   
      replace shift_date with poshdate
      replace typ with shstmast->tyP
      replace cla with shstmast->cla
      replace cod with shstmast->cod
        replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
      replace bbf with shstmast->bbf
      replace ep_phy with 0
      replace phy    with shstmast->phy
      replace on_hand with shstmast->bbf
      replace cs_purch with 0
     
      replace cr_purch with 0
      
      replace cs_sales with 0
      
      replace cr_sales with 0
      replace trans_in with 0
      replace trans_out with 0
      replace adj_in with 0
      replace adj_out with 0
       
         endif
    
      replace ep_phy with ststo->tank_cap
      replace std_cost with pcost
    replace std_vat with pvat
    REPLACE SALE_pRICE WITH PPRICE
   
  
  replace cs_purch with shstmast->cs_purch + cs_purch
      replace cr_purch with shstmast->cr_purch + cr_purch
       replace cs_sales with shstmast->cs_sales  + cs_sales
      replace cr_sales with shstmast->cr_sales + cr_sales
      replace trans_in with shstmast->trans_in + trans_in
      replace trans_out with shstmast->trans_out + trans_out
      replace adj_in with shstmast->adj_in + adj_in
      replace adj_out with shstmast->adj_out + adj_out
      replace phy    with shstmast->phy
      
      replace on_hand with on_hand + shstmast->cs_purch + shstmast->cr_purch;
                                   + shstmast->trans_in + shstmast->adj_in - shstmast->adj_out;
                                   - shstmast->trans_out - shstmast->cs_sales ;
                                   - shstmast->cr_sales


         if div = "1" .and. phy = 0 && forecourt stores
         replace phy with on_hand
         endif


  select FGDATMAS
    seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+dtos(poshdate)
 if .not. found()
   append blank
   replace SHIFT_DATE WITH poshdate
     replace coy with dshstmas->coy
    replace div with pdiv
    replace cen with pcen
    REPLACE STO WITH psto
      replace typ with dshstmas->tyP
      replace cla with dshstmas->cla
      replace cod with dshstmas->cod
         replace purch with 0
      replace sales with 0
      replace trans with 0
      replace adj with 0
 
      endif
      replace purch with dshstmas->cs_purch + dshstmas->cr_purch
      replace sales with dshstmas->cs_sales +  dshstmas->cr_sales
      replace trans with dshstmas->trans_in - dshstmas->trans_out
      replace adj with dshstmas->adj_in - dshstmas->adj_out
      replace bbf with dshstmas->bbf
      replace phy    with dshstmas->phy
      replace on_hand with dshstmas->on_hand
         replace std_cost with dshstmas->std_cost
    replace std_vat with dshstmas->std_vat
    REPLACE SALE_pRICE WITH dshstmas->sale_PRICE
  

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
        REPLACE SALE_PRICE WITH 0
      REPLACE STD_COST WITH 0
      ENDIF
      REPLACE  CS_SALES WITH CS_SALES + SHSTMAST->CS_SALES
      REPLACE  CR_SALES WITH CR_SALES + SHSTMAST->CR_SALES
         REPLACE  CS_PURCH WITH CS_PURCH + SHSTMAST->CS_PURCH
      REPLACE  CR_PURCH WITH CR_PURCH + SHSTMAST->CR_PURCH
      PPQTY = CR_PURCH + CS_PURCH
    PPVAL = 0
    PSQTY = CR_SALES+ CS_SALES
    PSVAL = 0
    
    replace std_cost with dshstmas->std_cost
   * replace std_vat with dshstmas->std_vat
    REPLACE SALE_pRICE WITH dshstmas->sale_PRICE
  


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
      REPLACE  CS_SALES WITH CS_SALES + shstmast->CS_SALES
      REPLACE  CR_SALES WITH CR_SALES + shstmast->CR_SALES
      REPLACE  CS_PURCH WITH CS_PURCH + shstmast->CS_PURCH
      REPLACE  CR_PURCH WITH CR_PURCH + shstmast->CR_PURCH
      PPQTY = CR_PURCH + CS_PURCH
   replace std_cost with dshstmas->std_cost
 *   replace std_vat with dshstmas->std_vat
    REPLACE SALE_pRICE WITH dshstmas->sale_PRICE
  
    
 
    
    
       select mshstmas
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy+pmm
   if .not. found()
   append blank
   replace yy with pyy
   replace mm with pmm
   replace sto with psto
    replace coy with shstmast->coy
    replace div with pdiv
    replace cen with pcen
      replace typ with shstmast->tyP
      replace cla with shstmast->cla
      replace cod with shstmast->cod
      replace cs_purch with shstmast->cs_purch
      replace cr_purch with shstmast->cr_purch
      replace cs_sales with shstmast->cs_sales
       replace cr_sales with shstmast->cr_sales
      replace trans_in with shstmast->trans_in
      replace trans_out with shstmast->trans_out
      replace adj_in with shstmast->adj_in
      replace adj_out with shstmast->adj_out
      replace bbf with shstmast->bbf
      replace phy    with shstmast->phy
   
      replace on_hand with shstmast->on_hand
        
         
    else
    
  replace cs_purch with shstmast->cs_purch + cs_purch
      replace cr_purch with shstmast->cr_purch + cr_purch
      replace cs_sales with shstmast->cs_sales  + cs_sales
      replace cr_sales with shstmast->cr_sales + cr_sales
      replace trans_in with shstmast->trans_in + trans_in
      replace trans_out with shstmast->trans_out + trans_out
      replace adj_in with shstmast->adj_in + adj_in
      replace adj_out with shstmast->adj_out + adj_out
      replace phy    with shstmast->phy
   
      replace on_hand with on_hand + shstmast->cs_purch + shstmast->cr_purch;
                                   + shstmast->trans_in + shstmast->adj_in - shstmast->adj_out;
                                   - shstmast->trans_out - shstmast->cs_sales ;
                                   - shstmast->cr_sales
    endif
    replace ep_phy with ststo->tank_cap
     replace std_cost with dshstmas->std_cost
 *   replace std_vat with dshstmas->std_vat
    REPLACE SALE_pRICE WITH dshstmas->sale_PRICE
     if div = "1" .and. phy = 0 && forecourt stores
         replace phy with on_hand
         endif
         if .not. shstmast->phy = 0
         replace phy with shstmast->phy
         endif
    
                 select ashstmas
   
 seek pcoy+pdiv+pcen+psto+ptyp+pcla+pcod+pyy
   if .not. found()
   append blank
   replace yy with pyy
   replace sto with psto
    replace coy with shstmast->coy
    replace div with pdiv
    replace cen with pcen
      replace typ with shstmast->tyP
      replace cla with shstmast->cla
      replace cod with shstmast->cod
      replace cs_purch with shstmast->cs_purch
      replace cr_purch with shstmast->cr_purch
      replace cs_sales with shstmast->cs_sales
       replace cr_sales with shstmast->cr_sales
      replace trans_in with shstmast->trans_in
      replace trans_out with shstmast->trans_out
      replace adj_in with shstmast->adj_in
      replace adj_out with shstmast->adj_out
      replace bbf with shstmast->bbf
      replace phy    with shstmast->phy
      replace on_hand with shstmast->on_hand
         
         
    else
    
  replace cs_purch with shstmast->cs_purch + cs_purch
      replace cr_purch with shstmast->cr_purch + cr_purch
      replace cs_sales with shstmast->cs_sales  + cs_sales
      replace cr_sales with shstmast->cr_sales + cr_sales
      replace trans_in with shstmast->trans_in + trans_in
      replace trans_out with shstmast->trans_out + trans_out
      replace adj_in with shstmast->adj_in + adj_in
      replace adj_out with shstmast->adj_out + adj_out
      replace phy    with shstmast->phy
   
      replace on_hand with on_hand + shstmast->cs_purch + shstmast->cr_purch;
                                   + shstmast->trans_in + shstmast->adj_in - shstmast->adj_out;
                                   - shstmast->trans_out - shstmast->cs_sales ;
                                   - shstmast->cr_sales
    endif
     replace std_cost with dshstmas->std_cost
  *  replace std_vat with dshstmas->std_vat
    REPLACE SALE_pRICE WITH dshstmas->sale_PRICE
  
    
      if div = "1" .and. phy = 0 && forecourt stores
         replace phy with on_hand
         endif
         if .not. shstmast->phy = 0
         replace phy with shstmast->phy
         endif
*         endif
            
              select shstmast
      replace post_date with date()
      skip
      if eof()
      eofshstmast = .t.
      endif
  
