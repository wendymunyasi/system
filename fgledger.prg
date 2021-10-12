
**************************************************************************
*  PROGRAM:      fgledger
*
*******************************************************************************

Procedure fgledger
 PARAMETER BUSER,BLEVEL
pluser = buser
plevel = blevel
if empty(pluser) .or. empty(plevel)
quit
endif
   DO NGLJNLS.PRG WITH PLUSER,PLEVEL && ORDINARY JOURNALS  29.08.2010
   
   DO NGLSTKS.PRG WITH PLUSER,PLEVEL && CLOSING STOCKS
   
  do nglbdeps.prg WITH PLUSER,PLEVEL && Cash Deposits only 05/09/2009
  
    do nglmrs.prg WITH PLUSER,PLEVEL && miscellaneous receipts doc type 52 05/09/2010
    do ngldebit.PRG WITH PLUSER,PLEVEL  && 25/08/2009 CUST DEBIT/CREDIT NOTES
  do nglpurch.PRG WITH PLUSER,PLEVEL  && vat input 22/09/2010
   do nglpaym.PRG WITH PLUSER,PLEVEL  && vat input 22/09/2010
   do nglapcdr.PRG WITH PLUSER,PLEVEL  && 25/08/2009 CUST DEBIT/CREDIT NOTES
   do NGLDSCDR.prg WITH PLUSER,PLEVEL  && 25/08/2009 CUST service charge/costs
   do ngltrans.prg WITH PLUSER,PLEVEL  && 11/01/2016 stock transfers/adjustments
     do ngladjs.prg WITH PLUSER,PLEVEL  && 11/01/2016 stock transfers/adjustments
  do ngljobs.PRG WITH PLUSER,PLEVEL && 26/08/2009 post job cards 18.09.2010
  do nglinvs.PRG WITH PLUSER,PLEVEL && 26/08/2009 post invoices 18.09.2010
 do nglcads.PRG WITH PLUSER,PLEVEL && 26/08/2009 post credit cards 18.09.2010
  do nglpgjob.PRG WITH PLUSER,PLEVEL && 26/08/2009 post lpgs/lubes 18.09.2010
 do nglcsals.PRG WITH PLUSER,PLEVEL && 26/08/2009 fgshtran POST NEW FORECOURT SHIFT CASH SALES  18.09.2010
*do nglninvs.PRG WITH PLUSER,PLEVEL && 01/09/2018 post new invoices 


     
   *  progreps.close()
    CLOSE DATABASES
