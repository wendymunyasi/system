 
                
**************************************************************************
*  PROGRAM:     FGpurch.prg
*
*
*******************************************************************************

Procedure FGpurch
PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Extracting purchases Records in progress... Wait!",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt or disconnect power.",;
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
set view to "FGpurch.QBE"
PLUSER = BUSER
PLEVEL = BLEVEL

SET REPROCESS TO -1
select fgglpurs
set order to mkey
go top
if eof()
pfirst =.t.
else
pfirst =.f.
endif
if flock()
SELECT FGPURCH
IF FLOCK()
SELECT FGNFPUR
IF FLOCK()
select fgshuppu
IF FLOCK()
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
      do FGpurch_RTN1
      set safety off
select fgshuppu
zap
set safety on
ELSE
WAIT 'UNABLE TO LOCK TABLES - TRY AGAIN LATER!'
QUIT
ENDIF
ENDIF
ENDIF
endif
if pfirst
select fgnfpur
set filter to fgnfpur->system = 'PO' .OR. fgnfpur->SYSTEM = 'DS'.or. fgnfpur->system = 'GL'
eoffgnfpur = .f.
go top
if .not. eof()
   do
   do fgglpurs_rtn
 until eoffgnfpur
endif
endif

      close databases
      progreps.close()
       
procedure fgglpurs_rtn
      psd = fgnfpur->inv_date
      if empty(psd)
      psd = fgnfpur->order_date
      endif
      pco = fgnfpur->coy
      pty = fgnfpur->typ
      pcl = fgnfpur->cla
      pcd = fgnfpur->cod
      select fgglpurs
      seek dtos(psd)+pco+pty+pcl+pcd
      if .not. found()
      append blank
      replace order_date with psd
      replace coy with pco
      replace typ with pty
      replace cla with pcl
      replace cod with pcd
      replace po_qty with 0
      replace po_total with 0
       replace gl_qty with 0
      replace gl_total with 0
       replace fg_qty with 0
      replace fg_total with 0
       replace jv_qty with 0
      replace jv_total with 0
       replace ds_qty with 0
      replace ds_total with 0
      endif
      IF FGNFPUR->SYSTEM ='PO'
      replace po_qty with po_qty + fgnfpur->qty
      replace po_total with po_total + fgnfpur->total
      ELSE
       IF FGNFPUR->SYSTEM ='GL'
      replace gl_qty with gl_qty + fgnfpur->qty
      replace gl_total with gl_total + fgnfpur->total
       ELSE
       IF FGNFPUR->SYSTEM ='DS'
      replace ds_qty with ds_qty + fgnfpur->qty
      replace ds_total with ds_total + fgnfpur->total
   endif
   endif
   endif
      
      if pfirst
      select fgnfpur
      skip
      if eof()
      eoffgnfpur =.t.
      endif
      endif
      
Procedure FGpurch_RTN1
   private EOFST15F,eoffgnfpur,poshdate,poshno,pnshdate,pnshno,pok,ptyp,pcla,pcod,;
   pcoy,eofshstmwkf,poyy,pomm,pnyy,pnmm,eofshcatsum,pyy,pmm,pqtr,pnqtr,ppqtr,POSHID,PNSHID
   pok = .t.
    select fgpurch
   set order to mkey
   
  eoffgnfpur = .f.
  select fgnfpur
  set filter to empty(purch_date)
   go top
  if .not. eof()
     do
        do fgnfpur_rtn
        until eoffgnfpur
     endif
          
      
   Procedure fgnfpur_rtn
  pjorder = fgnfpur->job_order  
  pdate =  fgnfpur->order_date
  psys = fgnfpur->system
  pdoc = fgnfpur->doctype
  porder = fgnfpur->order_no
  pstk = fgnfpur->stock_no
   ptyp = fgnfpur->TYP
  pcla = fgnfpur->cla
   pcod = fgnfpur->cod
   if empty(pjorder)
   pjorder = fgnfpur->typ
   endif
  select fgpurch
     append blank
     replace job_order with pjorder
     replace order_date with pdate
     replace system with psys
     replace doctype with pdoc
     replace order_no with porder
     replace stock_no with pstk
     replace typ with ptyp
     replace cla with pcla
     replace cod with pcod
     replace qty with fgnfpur->qty
     replace nonvat with fgnfpur->return_qty
     replace nonvat_amt with fgnfpur->new_bal    
     replace net_amt with fgnfpur->unit_cost  
     replace gross_amt with fgnfpur->gross_amt
     replace tax_amt with fgnfpur->tax_amt
     replace tax_rate with fgnfpur->tax_rate
     replace total with fgnfpur->total
     replace serialno with fgnfpur->serialno
     replace inv_no with fgnfpur->inv_no
     replace reg with fgnfpur->reg
     replace vsrce with fgnfpur->vsrce
     replace vpmod with fgnfpur->vpmod
     replace vtyp with fgnfpur->vtyp
     replace vendor_n with fgnfpur->vendor_n
     replace pay_method with fgnfpur->pay_method
     replace lpo with fgnfpur->lpo
     replace inv_date with fgnfpur->inv_date
     replace unused_f with fgnfpur->unused_f
       replace source with fgnfpur->source
     replace pmod with fgnfpur->pmod
     replace ftyp with fgnfpur->ftyp
     replace frighter_n with fgnfpur->frighter_n
       replace paysrce with fgnfpur->paysrce
     replace paymod with fgnfpur->paymod
     replace paytyp with fgnfpur->paytyp
     replace pay_n with fgnfpur->pay_n
     REPLACE DIP_Q_BOF WITH fgnfpur->DIP_Q_BOF 
     REPLACE DIP_Q_AOF WITH fgnfpur->DIP_Q_AOF
     REPLACE DRIVER WITH fgnfpur->DRIVER   
     REPLACE OFLD_NAME WITH fgnfpur->OFLD_NAME
     REPLACE OFLD_TIME WITH FGNFPUR->OFLD_TIME
       REPLACE GRN_ASHIP WITH FGNFPUR->GRN_ASHIP
       replace transp with fgnfpur->transp
            REPLACE SHIP_NAME WITH FGNFPUR->SHIP_NAME
            replace sale_qty with fgnfpur->sale_qty
            IF TYP = "00"
             REPLACE EXP_DIP_Q WITH DIP_Q_BOF + QTY
            REPLACE OFLD_VAR WITH DIP_Q_AOF - EXP_DIP_Q + sale_qty
            IF .NOT. QTY = 0
            REPLACE OFLD_VPERC WITH (DIP_Q_AOF - EXP_DIP_Q + sale_qty)/QTY * 100
            ENDIF
            ENDIF
            if .not. pfirst .AND. (fgnfpur->system = 'PO' .OR. fgnfpur->SYSTEM = 'DS' .OR. fgnfpur->SYSTEM = 'GL')
            do fgglpurs_rtn
            endif
                                       select fgnfpur
 
   replace purch_date with date()
   if .not. eof()
      skip
      endif
      if eof()
      eoffgnfpur = .t.
      endif
 