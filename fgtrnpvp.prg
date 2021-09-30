Procedure fgtrnpvp
set talk off
set ldCheck off
set decimals to 4

set view to "fgtrnpvp.QBE"
set safety off
select fgtrnref
set order to mkey
eoffgtrnprv = .f.
do initial_rtn
close databases
procedure initial_rtn
private porder,pdate,psys,pdoc
select fgtrnprv
go top
if .not. eof()
do 
do rtn1
until eoffgtrnprv
endif

select fgtrnprv
zap
set safety on

procedure rtn1
   porder = fgtrnprv->o_order
   pdate = fgtrnprv->o_date
   psys = fgtrnprv->o_sys
   pdoc = fgtrnprv->o_doc
   
    pvalid = .f.
   pfile = ""
   if (pdoc = "24"  .or. pdoc = "21") .and. psys = "PO"
   pfile = "Pur"
   endif
  if pdoc = "51" .and. psys = "PC"
   pfile = "Pur"
   endif
   if pdoc = "54" .and. psys = "AP"
   pfile = "Pur"
   endif
   
   IF PFILE = "Pur"
   do pur_rtn
  endif
  if pdoc = "JC" .and. psys = "PS"
   pfile = "JOB"
   endif
   if pdoc = "JC" .and. psys = "CS"
   pfile = "JOB"
   endif
   
   IF PFILE = "JOB"
   do JOB_RTN
  endif
  if pdoc = "LP" .and. psys = "PS"
   pfile = "LPG"
   endif
  IF PFILE = "LPG"
   do LPG_RTN
  endif
   if pdoc = "LB" .and. psys = "PS"
   pfile = "LUB"
   endif
  IF PFILE = "LUB"
   do LPG_RTN
  endif



    if pdoc = "18" .and. psys = "OP"
   pfile = "INV"
   endif
   if pdoc = "19" .and. psys = "OP"
   pfile = "INV"
   endif
   
   IF PFILE = "INV"
   do INV_RTN
  endif
  
   if pdoc = "28" .and. psys = "AR"
   pfile = "VIS"
   endif
   if pdoc = "28" .and. psys = "CD"
   pfile = "VIS"
   endif
   
   IF PFILE = "VIS"
   do VIS_RTN
  endif
 
  if pdoc = "38" .and. psys = "DR"
   pfile = "CHQ"
   endif
   
   IF PFILE = "CHQ"
   do CHQ_RTN
  endif

    if pdoc = "18" .and. psys = "BR"
   pfile = "BRN"
   endif
   
   IF PFILE = "BRN"
   do BRN_RTN
  endif


    if pdoc = "18" .and. psys = "IS"
   pfile = "ISS"
   endif
   
   IF PFILE = "ISS"
   do ISS_RTN
  endif

    if pdoc = "24" .and. psys = "DV"
   pfile = "DIV"
   endif
   
   IF PFILE = "DIV"
   do DIV_RTN
  endif
  
  IF (PDOC = "20" .AND. PSYS = "OP") .OR. (PDOC = "20" .AND. PSYS = "PS") ;
  .OR. (PDOC = "18" .AND. PSYS = "OP") .OR. (PDOC = "18" .AND. PSYS = "PS") ;
  .OR. (PDOC = "20" .AND. PSYS = "GS")
  DO GEN_RTN
  ENDIF
  
select fgtrnprv
skip
if eof()
   eoffgtrnprv = .t.
   endif
   


PROCEDURE GEN_RTN
local l1,l2,l3,l4
  L1= fgtrnprv->o_order
  L2 = DTOS(FGTRNPRV->o_date)
  L3 = fgtrnprv->o_sys
   L4 = fgtrnprv->o_doc
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGTRNPRV->o_date
              REPLACE DOCTYPE WITH L4
              REPLACE SYSTEM WITH L3
              endif
              
 procedure pur_rtn
   eoffgnfpur = .f.
   select fgnfpur
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do pur_rtn2
      until eoffgnfpur
   endif

Procedure pur_rtn2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = fgnfpur->order_no
              l2 = dtos(fgnfpur->order_date)
              l3 = fgnfpur->doctype
              l4 = fgnfpur->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fgnfpur->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + fgnfpur->total
              if fgnfpur->qty < 0 .and. fgnfpur->total > 0
              replace qty with qty + fgnfpur->qty*-1
              else
              replace qty with qty + fgnfpur->qty
              endif
              select fgnfpur
              if .not. eof()
              skip
              endif
              if eof()
              eoffgnfpur = .t.
              endif
              

  
 procedure JOB_RTN
   eoffgJOBCAD = .f.
   select FGJOBCAD
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do JOB_RTN2
      until eofFGJOBCAD
   endif

Procedure JOB_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGJOBCAD->order_no
              l2 = dtos(FGJOBCAD->order_date)
              l3 = FGJOBCAD->doctype
              l4 = FGJOBCAD->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGJOBCAD->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGJOBCAD->total
              if FGJOBCAD->qty < 0 .and. FGJOBCAD->total > 0
              replace qty with qty + FGJOBCAD->qty*-1
              else
              replace qty with qty + FGJOBCAD->qty
              endif
              select FGJOBCAD
              if .not. eof()
              skip
              endif
              if eof()
              eofFGJOBCAD = .t.
              endif
              
 procedure LPG_RTN
   eoffgLPGCAD = .f.
   select FGLPGCAD
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do LPG_RTN2
      until eofFGLPGCAD
   endif

Procedure LPG_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGLPGCAD->order_no
              l2 = dtos(FGLPGCAD->order_date)
              l3 = FGLPGCAD->doctype
              l4 = FGLPGCAD->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGLPGCAD->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGLPGCAD->total
              if FGLPGCAD->qty < 0 .and. FGLPGCAD->total > 0
              replace qty with qty + FGLPGCAD->qty*-1
              else
              replace qty with qty + FGLPGCAD->qty
              endif
              select FGLPGCAD
              if .not. eof()
              skip
              endif
              if eof()
              eofFGLPGCAD = .t.
              endif

  
procedure INV_RTN
   EOFFGINVTRN = .F.
   select FGINVTRN
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do INV_RTN2
      until eofFGINVTRN
   endif

Procedure INV_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGINVTRN->order_no
              l2 = dtos(FGINVTRN->order_date)
              l3 = FGINVTRN->doctype
              l4 = FGINVTRN->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGINVTRN->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGINVTRN->total
              if FGINVTRN->qty < 0 .and. FGINVTRN->total > 0
              replace qty with qty + FGINVTRN->qty*-1
              else
              replace qty with qty + FGINVTRN->qty
              endif
              select FGINVTRN
              if .not. eof()
              skip
              endif
              if eof()
              eofFGINVTRN = .t.
              endif
              
  
 procedure VIS_RTN
EOFfgvistrn = .F.
   select fgvistrn
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do VIS_RTN2
      until eoffgvistrn
   endif

Procedure VIS_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = fgvistrn->order_no
              l2 = dtos(fgvistrn->order_date)
              l3 = fgvistrn->doctype
              l4 = fgvistrn->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH fgvistrn->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + fgvistrn->total
              if fgvistrn->qty < 0 .and. fgvistrn->total > 0
              replace qty with qty + fgvistrn->qty*-1
              else
              replace qty with qty + fgvistrn->qty
              endif
              select fgvistrn
              if .not. eof()
              skip
              endif
              if eof()
              eoffgvistrn = .t.
              endif
              

  
 procedure CHQ_RTN
EOFFGCHQTRN = .F.
   select FGCHQTRN
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do CHQ_RTN2
      until eofFGCHQTRN
   endif

Procedure CHQ_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGCHQTRN->order_no
              l2 = dtos(FGCHQTRN->order_date)
              l3 = FGCHQTRN->doctype
              l4 = FGCHQTRN->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGCHQTRN->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGCHQTRN->total
              if FGCHQTRN->qty < 0 .and. FGCHQTRN->total > 0
              replace qty with qty + FGCHQTRN->qty*-1
              else
              replace qty with qty + FGCHQTRN->qty
              endif
              select FGCHQTRN
              if .not. eof()
              skip
              endif
              if eof()
              eofFGCHQTRN = .t.
              endif
              

  
 procedure BRN_RTN
EOFFGISTRN = .F.
   select FGISTRN
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do BRN_RTN2
      until eofFGISTRN
   endif

Procedure BRN_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGISTRN->order_no
              l2 = dtos(FGISTRN->order_date)
              l3 = FGISTRN->doctype
              l4 = FGISTRN->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGISTRN->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGISTRN->total
              if FGISTRN->qty < 0 .and. FGISTRN->total > 0
              replace qty with qty + FGISTRN->qty*-1
              else
              replace qty with qty + FGISTRN->qty
              endif
              select FGISTRN
              if .not. eof()
              skip
              endif
              if eof()
              eofFGISTRN = .t.
              endif
              

  
 procedure ISS_RTN
EOFFGBSTRN = .F.
   select FGBSTRN
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do ISS_RTN2
      until eofFGBSTRN
   endif

Procedure ISS_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGBSTRN->order_no
              l2 = dtos(FGBSTRN->order_date)
              l3 = FGBSTRN->doctype
              l4 = FGBSTRN->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGBSTRN->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGBSTRN->total
              if FGBSTRN->qty < 0 .and. FGBSTRN->total > 0
              replace qty with qty + FGBSTRN->qty*-1
              else
              replace qty with qty + FGBSTRN->qty
              endif
              select FGBSTRN
              if .not. eof()
              skip
              endif
              if eof()
              eofFGBSTRN = .t.
              endif
              

  
 procedure DIV_RTN
EOFFGDIVTRN = .F.
   select FGDIVTRN
   set filter to order_date = pdate .and. order_no = porder ;
    .and. system = psys .and. doctype = pdoc
    go top
    if .not. eof()
       do
          do DIV_RTN2
      until eofFGDIVTRN
   endif

Procedure DIV_RTN2
pvalid = .t.
      local l1,l2,l3,l4
             l1 = FGDIVTRN->order_no
              l2 = dtos(FGDIVTRN->order_date)
              l3 = FGDIVTRN->doctype
              l4 = FGDIVTRN->system
            select fgtrnref
              seek l1+l2+l3+l4
              if .not. found()
              append blank
              replace mkey with l1+l2+l3+l4
              
              replace total with 0
              replace qty with 0
              REPLACE ORDER_NO WITH L1
              REPLACE ORDER_DATE WITH FGDIVTRN->ORDER_DATE
              REPLACE DOCTYPE WITH L3
              REPLACE SYSTEM WITH L4
              endif
              replace total with total + FGDIVTRN->total
              if FGDIVTRN->qty < 0 .and. FGDIVTRN->total > 0
              replace qty with qty + FGDIVTRN->qty*-1
              else
              replace qty with qty + FGDIVTRN->qty
              endif
              select FGDIVTRN
              if .not. eof()
              skip
              endif
              if eof()
              eofFGDIVTRN = .t.
              endif
              
