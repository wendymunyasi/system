Procedure fgcenupd
close databases
	create session
	select 1
	use \kenservice\data\fgcen.dbf
	select 2
	use  \kenservice\data\fgcens.dbf excl
	select 3
	use \kenservice\data\nlcc.dbf order tag ccentre
	set safety off
   private eoffgcen,p1,p2
   eoffgcen = .f.
   set safety off
   select fgcens
    set order to mkey
      set safety on
   select fgcen
   go top
   if .not. eof()
      do
         do rtn1
         until eoffgcen
     endif
close databases
procedure rtn1
       p1 = fgcen->name
      if .not. empty(p1)
      do rtn2
      endif
   select fgcen
   skip
   if eof()
   eoffgcen = .t.
   endif

Procedure rtn2
   select fgcens
      seek fgcen->coy+fgcen->div+fgcen->cen
      if .not. found()
      append blank
       replace coy with fgcen->coy
      REPLACE DIV WITH fgcen->DIV
      replace CEN with fgcen->cen
      endif
      replace expense with fgcen->expense
      replace cen1 with fgcen->cen1
      replace div1 with fgcen->div1
      replace coy1 with fgcen->coy1
      replace used with fgcen->used
      replace day_rate with fgcen->day_rate
      replace night_rate with fgcen->night_rate
      replace fuels with fgcen->fuels
      REPLACE CUST_NO WITH FGCEN->CUST_NO
      REPLACE CUSTNAME WITH FGCEN->CUSTNAME
      replace plant_code with fgcen->plant_code
      replace plantname with fgcen->plantname
       replace name with p1
      select nlcc
      seek fgcen->coy+fgcen->div+fgcen->cen
      if .not. found()
      append blank
      replace coy with fgcen->coy
      replace ccentre with fgcen->div
      replace pcentre with fgcen->cen
      endif
      replace  lname with fgcen->name
      replace sname with fgcen->name

	