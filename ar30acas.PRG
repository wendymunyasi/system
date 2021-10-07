
Procedure ar30acas
   PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
   set reprocess to 10000
    set exact on
    SET VIEW TO "ar30acas.QBE"
     PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
    select st15f
     if flock()
    set order to mkey
    go top
    select fgtran
     eofaracasln = .f.
     go top
     select scashrec
      if flock()
     set order to mkey
     select cashiers
      if flock()
     set order to cashier
     select arcasupd
     
set order to mkey
       SELECT arcashs
       
     GO TOP
     IF .NOT. EOF()
         select aracasln
    set filter to order_no = arcashs->order_no .and. EMPTY(post_DATE) ;
    .AND. .NOT.TOTAL = 0 ;
     .and. (pay_method = "Brought forward" .or. pay_method = "Current shift")
              go top
                if .not. eof()
                do
                do line_rtn
                until eofaracasln
                 select arcashsn
                go top
                if eof()
                append blank
                endif
                replace order_no with arcashs->order_no
              endif
              endif
              SELECT FGCOY
              flush
              else
              wait 'Unable to Lock Tables - Try Again Later!'
              quit
              endif
             endif
             endif
              
              close databases
                
 
procedure line_rtn
      local l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11, lerr
            lerr = .t.
            select arcasupd
            seek aracasln->order_no+dtos(arcashs->order_date)+aracasln->stock_no+aracasln->dde_time
            if .not. found()
            append blank
            replace order_no with aracasln->order_no
            replace order_date with arcashs->order_date
            replace stock_no with aracasln->stock_no
            replace dde_time with aracasln->dde_time
            lerr = .f.
            endif
            if empty(aracasln->post_date)
            lerr = .f.
            endif
             if .not. lerr   
           l7 = aracasln->order_no
         l8 = aracasln->order_date
         l9 = aracasln->stock_no
         l10 = "CB"
         l11 = "57"
         if empty(l8)
         l8 = arcashs->order_date
         endif
         select fgcoy
         go top
         if pospost = "Yes"
         select st15f
         go top
         pshno = shift_no
         pshid = shift_id
         else
         pshno = "0"
         pshid = "0"
         endif
         
       pbbf = .f.
       pcurr = .f.
        if aracasln->pay_method = "Brought forward"
       pbbf = .t.
      ELSE
        pcurr = .t.
       endif
      
       
         select fgtran
         append blank
         replace system with l10
         REPLACE COY WITH "1"
           REPLACE DIV WITH "5"
            REPLACE CEN WITH "1"
             REPLACE STO WITH "A1"
              REPLACE TYP WITH "C0"
               REPLACE CLA WITH "00"
                REPLACE COD WITH "01"
         
         replace doctype with l11
         replace order_no with l7
         replace order_date with l8
         replace stock_no with l9
              replace actype  with "4"  && CURRENT ASSETS
            replace qty with 0
            replace unit_cost with 0
            replace new_bal with 0
            replace total with aracasln->total
            REPLACE QTY_ALLOC WITH 0
            replace list_price with 0
            replace levy_rate with 0
            replace tax_rate with 0
            replace disc_rate with 0
            replace tax_amt with 0
            replace levy_amt with 0
            replace disc_amt with 0
            replace curr_rate with 0
            replace inv_py_amt with 0
            replace off with arcashs->off
            replace inv_py_amt with 0
            replace gross_amt with 0
            replace basic_amt with 0
            replace dsc  WITH 0
            replace TRANtype with "Actual Cash"
            replace pay_method  with aracasln->pay_method
               replace shift_no with pshno
           replace shift_id with pshid
               REPLACE SHIFT_NO WITH arcashs->SHIFTNO
           REPLACE SHIFT_ID WITH arcashs->SHIFTID
           REPLACE DDE_DATE WITH DATE()
           REPLACE DDE_TIME WITH TIME()
           REPLACE DDE_USER WITH PLUSER
       
         DO aracasln_RTN1
   select aracasln
    REPLACE POST_DATE WITH DATE()
    SELECT arcasupd
    replace post_date with date()
    ENDIF
  select aracasln
  
    if .not. eof()
   skip
   endif
   if eof()
   eofaracasln = .t.
   endif
  
  
  
  
  
 PROCEDURE aracasln_RTN1
    PRIVATE P1,P2,P3,P4,P5,P6,ptyp,pcod,pcod,pcoy,pdiv,pcen,psto,porder,pcustno,;
            PCUS,PST15F,ST15C,PSTMAST,Parcashs,pstt,pftyp,psource,ppmod,p20,ptsdate
            local lld1,lld2
              ptsdate = aracasln->ORDER_DATE
            SELECT FGCOY
            GO TOP
    if fgcoy->pospost = "Yes"
    select st15f
    go top
    
    pshdate = shift_date
    pshno = shift_no
    pshid = shift_id
    else
    pshdate = arcashs->order_date
     pshno = "0"
    pshid = "0"
    endif
   * pterror = .f.  
      ptyp ="99"
      pcla = "99"
      pcod = "99"
      pcoy = "1"
      pdiv = "5"
      pcen = "1"
      psto = "A1"
       porder = aracasln->order_no
       pftyp = ""
       pcustno = ""
       psource = ""
       ppmod = ""
       p20 = ""
       pbbfRNO = ""
          Parcashs = .F.
                      pbbfrno = arcashs->cashier_no
                    if empty(pbbfrno)
                      pbbfrno = "1"
                      endif
           
           select scashrec
   seek dtos(pshdate)+pshno+pshid+pbbfrno+pcen+psto+ptyp+pcla+pcod
   if .not. found()
   append blank
   replace cashr_no with  pbbfrno
   replace shift_date with pshdate
   replace shift_no with pshno
   replace shift_id with pshid
   replace cen with pcen
    replace sto with psto
   replace typ with ptyp
   replace cla with pcla
   replace cod with pcod
  replace non_cash with 0
   replace exp_cash with 0
    replace exp_sales with 0
  REPLACE COYVISA WITH 0
   REPLACE BBKVISA WITH 0
   REPLACE GENVISA WITH 0
   REPLACE CHQS WITH 0
   REPLACE PAYMNTS WITH 0
   REPLACE RECEPTS WITH 0
   REPLACE PURCH WITH 0
   replace A_CASH with 0
   replace shortage with 0
   replace cr_notes with 0
   replace dr_notes with 0
   replace pdebits with 0
   replace pcredits with 0
   replace ppurch with 0
   replace fc_sales with 0
   
replace  cash_bank with 0
replace  dbcredits with 0
replace  dbdebits  with 0
replace  chqs_bank with 0
replace  reserved1 with 0
replace  reserved2 with 0
replace  reserved3 with 0
replace  reserved4 with 0
replace  reserved5 with 0
replace a_c_inhand with 0
replace off with arcashs->off
   endif
   
   SELECT CASHIERS
   SEEK pbbfrno
   if found()
  replace coy with pcoy
  replace div with pdiv
  replace cen with pcen
               endif
      select st15f
   GO TOP
         replace shift_post with date()
         if pbbf
               replace st15f->a_cash with st15f->a_cash + aracasln->total  && BBF
         endif
          if pcurr
               replace st15f->a_c_inhand with st15f->a_c_inhand+ aracasln->total && CURR
         endif
      
        SELECT SCASHREC  
        REPLACE a_c_inhand WITH a_c_inhand + aracasln->total
        