Procedure fragdrcr
set date to british
set century on
PARAMETER BLUSER,BLEVEL
IF EMPTY(BLUSER) .OR. EMPTY(BLEVEL)
QUIT
ENDIF
  set design off
 SHELL(.F.)
   DEFINE FORM PROGREPS FROM 12,20 TO 15,100;
  PROPERTY Text "Compiling Data For Aging Debtors In progress...Pease Wait! ",MDI .F.,;
  sysmenu .f.,;
  MAXIMIZE .F.,;
  MINIMIZE .F.,;
    OnClose {;SET CUAENTER ON}
   DEFINE TEXT Exit OF PROGREPS AT 1,10;
    PROPERTY Text "Please do not interrupt, will take 10-30 ss.",;
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
set view to "fragdrcr.QBE"
   private EOFfragedrs,PSDATE,PSTIME,PSYS,PDOC,PREF,psource,PDATE,PTOTAL,PALLOC,;
   EOFfrcrbal,EOFfrdrbal,pFRIGHTER,eoffrageddr,EOFfrcrbal,EOFfrdrbal,EOFfrdrbal,EOFfrcrbal,;
   PTRANSERR,PCHANGESMADE,psource,pcustno,pallocamt, pcrtotal,pcrallamt,PCTTYP,pagedate
    pterror = .F.
    ptexp = 0
    PTRANSERR = .F.
    PCHANGESMADE = .T.
   eoffragedrs = .f.
   eoffragecrs = .f.
   pfirst = .t.
   prvyy = ""
   prvsrce = ''
   prvftyp = ""
   prvpmod = ""
   prvno = ""
   prvmm = ""
   select frmtrage
   set order to frighter
   select frageddr
   set order to frighter
   PAGEDATE = DASUM->trans_date
 LOCAL LD1,LD2
 LD1 = DTOS(PAGEDATE) && YYYYMMDD
 LD2 = LEFT(LD1,6) && YYYYMM
 PYY = LEFT(LD2,4)
 PMM = RIGHT(LD2,2)
 pmmyy = pmm+pyy
 placcr = ""
 placdr = ""
 select frighter
 set order to frighter
 select fragedrs
 set order to frighter
 set filter to trans_date <= pagedate
 go top
 if .not. eof()
 do
    do fragedbal_rtn
  until eoffragedrs
 endif
 eoffragecrs = .f.
 select fragecrs
 set order to frighter
  set filter to trans_date <= pagedate
 go top
 if .not. eof()
 do 
 do frageddr_rtn
 until eoffragecrs
 endif
 eoffrageddr = .f.
 select frageddr
 set filter to credits > 0
 go top
 if .not. eof()
    do
       do aged_analysis
   until eoffrageddr
 endif
 select frageddr
 set filter to
 GO TOP
 replace all bal_due with total - CR_ALLOC
 replace all bal_due with cr_bal*-1 for cr_bal > 0
 close databases
 progreps.close()
procedure aged_analysis
select frageddr
      if bal_120 > 0
        if bal_120 < cr_bal
            pall =  bal_120
            replace  bal_120 with 0
            replace cr_alloc with cr_alloc + pall
            replace cr_bal with cr_bal - pall
            do aged_90
          else
             pall = cr_bal
             replace bal_120 with bal_120 - pall
             replace cr_alloc with cr_alloc + pall
             replace cr_bal with 0
             endif
             else
             do aged_90
             endif
           select frageddr
           skip
           if eof()
              eoffrageddr = .t.
              endif
procedure aged_90
if bal_90 > 0
        if bal_90 < cr_bal
            pall =  bal_90
            replace  bal_90 with 0
            replace cr_alloc with cr_alloc + pall
            replace cr_bal with cr_bal - pall
            do aged_60
          else
             pall = cr_bal
             replace bal_90 with bal_90 - pall
             replace cr_alloc with cr_alloc + pall
             replace cr_bal with 0
             endif
             else
             do aged_60
             endif
procedure aged_60
if bal_60 > 0
        if bal_60 < cr_bal
            pall =  bal_60
            replace  bal_60 with 0
            replace cr_alloc with cr_alloc + pall
            replace cr_bal with cr_bal - pall
            do aged_30
          else
             pall = cr_bal
             replace bal_60 with bal_60 - pall
             replace cr_alloc with cr_alloc + pall
             replace cr_bal with 0
             endif
             else
             do aged_30
             endif

procedure aged_30
if bal_30 > 0
        if bal_30 < cr_bal
            pall =  bal_30
            replace  bal_30 with 0
            replace cr_alloc with cr_alloc + pall
            replace cr_bal with cr_bal - pall
            do aged_15
          else
             pall = cr_bal
             replace bal_30 with bal_30 - pall
             replace cr_alloc with cr_alloc + pall
             replace cr_bal with 0
             endif
             else
             do aged_15
             endif            
procedure aged_15
if bal_15 > 0
        if bal_15 < cr_bal
            pall =  bal_15
            replace  bal_15 with 0
            replace cr_alloc with cr_alloc + pall
            replace cr_bal with cr_bal - pall
            do aged_this
          else
             pall = cr_bal
             replace bal_15 with bal_15 - pall
             replace cr_alloc with cr_alloc + pall
             replace cr_bal with 0
             endif
             else
             do aged_this
             endif
             
procedure aged_this
if bal_this > 0
        if bal_this < cr_bal
            pall =  bal_this
            replace  bal_this with 0
            replace cr_alloc with cr_alloc + pall
            replace cr_bal with cr_bal - pall
          else
             pall = cr_bal
             replace bal_this with bal_this - pall
             replace cr_alloc with cr_alloc + pall
             replace cr_bal with 0
             endif
            endif           
procedure frageddr_rtn
p1 = fragecrs->source
p2 = fragecrs->ftyp
p3 = fragecrs->pmod
p4 = fragecrs->frighter_n
p5 = fragecrs->total
psys = fragecrs->system
p7 = pagedate- trans_date  && d
p8 = dtos(fragecrs->trans_date) && yyyymmdd
ptyy = left(p8,4) && yyyy
p10 = left(p8,6) && yyyymm
ptmm = right(p10,2) && mm
ptmmyy = ptmm+ptyy && mmyyyy
select frmtrage
seek p1+p2+p3+p4
if .not. found()
append blank
replace source with p1
replace ftyp with p2
replace pmod with p3
replace frighter_n with p4
replace yy with pyy
replace mm with pmm
replace bbf with 0
replace bal_due with 0
replace l_pay_amt with 0
replace l_inv_amt with 0
select frighter
seek p1+p2+p3+p4
select frmtrage
replace category with frighter->category
replace catname with frighter->catname
replace cdep_amt with frighter->cdep_amt
replace credit_lmt with frighter->credit_lmt
endif
**
if .not. (month(fragecrs->trans_date) = month(pagedate) .and.  year(fragecrs->trans_date) = year(pagedate))
replace bbf with bbf + p5
replace bal_due with bal_due + p5
else
replace bal_due with bal_due + p5
if psys = 'SB' .or. psys = 'GL' .or. psys = 'DS' && payment
   replace l_pay_amt with l_pay_amt + p5
   else
replace l_inv_amt with l_inv_amt + p5
endif
endif
select frageddr
seek p1+p2+p3+p4
if .not. found()
select frighter
seek p1+p2+p3+p4
select frageddr
append blank
replace source with p1
replace ftyp with p2
replace pmod with p3
replace frighter_n with p4
replace bal_this with 0
replace bal_15 with 0
replace bal_30 with 0
replace bal_60 with 0
replace bal_90 with 0
replace bal_120 with 0
replace total with 0
replace credits with 0
replace cr_alloc with 0
replace cr_bal with 0
replace category with frighter->category
replace name with frighter->name
replace age_date with dasum->trans_date
replace cdep_amt with frighter->cdep_amt
replace credit_lmt with frighter->credit_lmt
REPLACE BBF WITH 0
REPLACE L_PAY_AMT WITH 0
REPLACE L_INV_AMT WITH 0
REPLACE YY WITH PYY
REPLACE MM WITH PMM
endif
replace credits with credits + fragecrs->total * -1
replace cr_bal with credits
    select fragecrs
    skip
    if eof()
    eoffragecrs = .t.
    endif
    
 
procedure fragedbal_rtn
p1 = fragedrs->source
p2 = fragedrs->ftyp
p3 = fragedrs->pmod
p4 = fragedrs->frighter_n
p5 = fragedrs->total
psys = fragedrs->system
p7 = pagedate - trans_date  && days
p8 = dtos(fragedrs->trans_date) && yyyymmdd
ptyy = left(p8,4) && yyyy
p10 = left(p8,6) && yyyymm
ptmm = right(p10,2) && mm
ptmmyy = ptmm+ptyy && mmyyyy
select frmtrage
seek p1+p2+p3+p4
if .not. found()
append blank
replace source with p1
replace ftyp with p2
replace pmod with p3
replace frighter_n with p4
replace yy with pyy
replace mm with pmm
replace bbf with 0
replace bal_due with 0
replace l_pay_amt with 0
replace l_inv_amt with 0
select frighter
seek p1+p2+p3+p4
select frmtrage
replace category with frighter->category
replace catname with frighter->catname
replace cdep_amt with frighter->cdep_amt
replace credit_lmt with frighter->credit_lmt
endif
if .not. (month(fragedrs->trans_date) = month(pagedate) .and.  year(fragedrs->trans_date) = year(pagedate))
replace bbf with bbf + p5
replace bal_due with bal_due + p5
else
replace bal_due with bal_due + p5
if psys = 'SB' .or. psys = 'GL' .or. psys = 'DS' && payment
   replace l_pay_amt with l_pay_amt + p5
   else
replace l_inv_amt with l_inv_amt + p5 
endif
endif
select frageddr
seek p1+p2+p3+p4
if .not. found()
select frighter
seek p1+p2+p3+p4
select frageddr
append blank
replace source with p1
replace ftyp with p2
replace pmod with p3
replace frighter_n with p4
replace bal_this with 0
replace bal_15 with 0
replace bal_30 with 0
replace bal_60 with 0
replace bal_90 with 0
replace bal_120 with 0
replace total with 0
replace credits with 0
replace cr_alloc with 0
replace cr_bal with 0
replace category with frighter->category
replace name with frighter->name
replace age_date with dasum->trans_date
replace cdep_amt with frighter->cdep_amt
replace credit_lmt with frighter->credit_lmt
REPLACE BBF WITH 0
REPLACE L_PAY_AMT WITH 0
REPLACE L_INV_AMT WITH 0
REPLACE YY WITH PYY
REPLACE MM WITH PMM
endif
replace total with total + p5
if p7 < 15
replace bal_this with bal_this + p5
else
if  p7 < 30
replace bal_15 with bal_15 + p5
else
if  p7 < 60
replace bal_30 with bal_30 + p5
else
if  p7 < 90
replace bal_60 with bal_60 + p5
else
if  p7 < 120
replace bal_90 with bal_90 + p5
else
replace bal_120 with bal_120 + p5
endif
endif
endif
endif
endif
select fragedrs
skip
if eof()
eoffragedrs = .t.
endif

