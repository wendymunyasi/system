Procedure AR30CINV
    PARAMETER BUSER,BLEVEL
create session
   set talk off                           && Set these for the new session
   set ldCheck off
    set exact on
    SET VIEW TO "AR30CINV.QBE"
         PLUSER = BUSER  && PRIVATE VARIABLES
    PLEVEL = BLEVEL
   

select ARCINVUP
set order to mkey
   PRIVATE P1,P2,PCOY,PDIV,PCEN,PSTO,PTYP,PCOD,PCOD,PCOY2,PDIV2,PCEN2,PSTO2,P14,pfrighter,;
            PCUS,PST15F,Pfgmast,Parcinvs,psttt,PTYP,PCLA,PCOD,psub,pshdate,;
            pshno,PSHID2,pftyp,p18,p19,p20,ptsdte,pfc,ppfc,pposted
            pposted = .f.

      eofARCILINE = .f.
      select fgcoy
      go top
      if pospost = "Yes"
      ppfc = .t.
      ? "ppfc"
      ? ppfc
      else
      ppfc = .f.
      endif
      select arcinvs
      go top
      if .not. eof()
       select ARCILINE
    set filter to order_no = arcinvs->order_no .and. empty(post_date) .AND. .NOT. (TOTAL = 0 ;
     .and. qty = 0)  .and. .not. empty(coy) .and. .not. empty(div)   .and. .not. empty(cen);
     .and. .not. empty(typ) .and. .not. empty(cla) .and. .not. empty(cod) .and. .not. empty(sto) ;
    .and. .not. empty(stock_no)   .and. empty(post_date) .and. .not. empty(st_coy) ;
     .and. .not. empty(st_div) .and. .not. empty(st_cen) .and. .not. empty(st_sto) ;
      .and. .not. empty(trantype)  .and. .not. empty(off) ;
       .and. .not. empty(cashier_no) .and. .not. empty(driver)
   
           go top
                if .not. eof()
   ? "STEP 2"
   pposted = .t.
                do
                do line_rtn
                until eofARCILINE
                  select arcinvsn
                go top
                if eof()
                append blank
                endif
                replace order_no with arcinvs->order_no
          endif
          endif
                close databases

procedure line_rtn
            local l1,l2,l11,l22,l3,lok, lerr
            lerr = .t.
              select ARCINVUP
            seek ARCILINE->order_no+dtos(arcinvs->order_date)+ARCILINE->stock_no+ARCILINE->dde_time
            if .not. found()
            append blank
            replace order_no with ARCILINE->order_no
            replace order_date with arcinvs->order_date
            replace stock_no with ARCILINE->stock_no
            replace dde_time with ARCILINE->dde_time
            lerr = .f.
            endif
            if empty(ARCILINE->post_date)
            lerr = .f.
            endif
             if .not. lerr   
         
       pdoc = "18"
    
       
      DO ARCILINE_3018RTN2
    ? "done"
    select ARCILINE
    replace post_date with date()
   SELECT ARCINVUP
    replace post_date with date()
    endif
       select fgcoy
        flush
   select ARCILINE   
       SKIP
    IF EOF()
     eofARCILINE = .T.
    ENDIF
 
         
 
      
  PROCEDURE ARCILINE_3018RTN2
  
    padjin = 0
    padjout = 0
    ptranin = 0
    ptranout = 0
    pcss = 0
    PCSSA = 0
    pcspa = 0
    PCSP = 0
    pcrs = 0
    pcrsa = 0
    pcrp = 0
    pcrpa = 0
    ptvols = 0
    ptvolp = 0
    pvol = 0
    ptcost = 0
      psys   = "PS"  && point of sale
      pdoc   = "18"  && job card
      pstockno = ARCILINE->stock_no
    
        select fgquotrs
           append blank
         replace system with psys
         replace doctype with pdoc
         replace order_no with arcinvs->order_no
         replace order_date with arcinvs->order_date
         replace stock_no with  ARCILINE->stock_no
         replace coy with ARCILINE->st_coy
            replace div with ARCILINE->st_div
            replace cen with ARCILINE->st_cen
              replace sto with ARCILINE->st_sto
              replace st_coy with ARCILINE->coy
            replace st_div with ARCILINE->div
            replace st_cen with ARCILINE->cen
              replace st_sto with ARCILINE->sto
              replace shift_no with arcinvs->shiftno
               replace shift_id with arcinvs->shiftid
                replace serialno with arcinvs->serialno
                replace dde_date with date()
                replace dde_time with time()
                replace dde_user with PLUSER
                replace driver with ARCILINE->driver
                replace scashier  with arcinvs->cashier_no 
                replace soff with arcinvs->off
               replace cashier_no  with ARCILINE->cashier_no 
            replace typ with ARCILINE->typ
            replace cla with ARCILINE->cla
            replace cod with ARCILINE->cod
            replace qty with ARCILINE->qty * -1
            replace unit_cost with ARCILINE->cost_price
            replace new_bal with 0
            replace total with ARCILINE->total
            replace list_price with ARCILINE->list_price
            replace tax_rate with ARCILINE->tax_rate
            replace tax_amt with ARCILINE->tax_amt
            replace off with ARCILINE->off
            replace reg  with arcinvs->reg
            replace gross_amt with ARCILINE->gross_amt
            REPLACE MILEAGE WITH arcinvs->MILEAGE
            replace pay_method  with arcinvs->pay_method
            replace lpo with arcinvs->lpo
           REPLACE source WITH arcinvs->source
          REPLACE ftyp WITH arcinvs->ftyp
           REPLACE PMOD WITH arcinvs->PMOD
           REPLACE FRIGHTER_N WITH arcinvs->FRIGHTER_N
            
             replace total_amt with ARCILINE->total_amt
            
             replace nonvat    with ARCILINE->nonvat   
             replace nonvat_amt with ARCILINE->nonvat_amt
           
          
    
  