//------------------------------------------------------------------------
//
//  DataButtons.CC  
//
//  Custom control library for data navigation and editing.
//
//  Usage:   set procedure to ":custom:\cc\DataButtons.cc" additive
//
//  Control         Function 
//  ----------      -----------------------------------------------
//  BarDataVCR      Container consisting of BitmapFirst,
//                  BitmapPrevious, BitmapNext and BitmapLast.
//
//  BarDataEdit     Container consisting of BitmapAppend,
//                  BitmapDelete, BitmapSave, BitmapAbandon, 
//                  BitmapFilter and BitmapLocate.
//
//  BitmapAppend    Add a new row.
//               
//  BitmapDelete    Remove current row without confirmation.
//
//  BitmapSave      Save changes to current row.
//
//  BitmapAbandon   Abandon changes to current row.
//
//  BitmapFilter    Switch to or run filter by form. 
//
//  BitmapLocate    Switch to or run query by form.
//
//  BitmapEdit      Switch to edit state from browse state.
//                  This has no effect when rowset.autoEdit 
//                  is true.
//
//  BitmapFirst     Move to first row.
//
//  BitmapPrevious  Move to previous row.
//
//  BitmapNext      Move to next row.
//
//  BitmapLast      Move to last row.
//
//  RowState        Displays current rowset state as: Closed,
//                  Read Only, Update, Append, Filter or Locate.
//
//  All controls operate on the current form rowset. 
//
//  All DataButton controls except the current control are hidden 
//  when switching to a filter or locate state. All DataButtons are 
//  shown when switching out of a filter or locate state.
//
//  Button Control    Same Function As
//  --------------    ----------------
//  ButtonAppend      BitmapAppend
//  ButtonDelete      BitmapDelete
//  ButtonSave        BitmapSave
//  ButtonAbandon     BitmapAbandon
//  ButtonFilter      BitmapFilter
//  ButtonLocate      BitmapLocate
//  ButtonEdit        BitmapEdit
//  ButtonFirst       BitmapFirst
//  ButtonPrevious    BitmapPrevious
//  ButtonNext        BitmapNext
//  ButtonLast        BitmapLast
//
//  dBASE Samples Group
//  $Revision:   1.7  $
//
//  Copyright (c) 1997-1998, Borland International, Inc. 
//  Copyright (c) 2000, dBASE, Inc.
//  All rights reserved.
//
//------------------------------------------------------------------------

#define DATACONTROLS1 "BITMAPAPPEND,BITMAPDELETE,BITMAPSAVE,BITMAPABANDON,BITMAPLOCATE,BITMAPFILTER,BITMAPEDIT"
#define DATACONTROLS2 ",BUTTONAPPEND,BUTTONDELETE,BUTTONSAVE,BUTTONABANDON,BUTTONLOCATE,BUTTONFILTER,BUTTONEDIT"
#define DATACONTROLS3 ",BITMAPFIRST,BITMAPPREVIOUS,BITMAPNEXT,BITMAPLAST"
#define DATACONTROLS4 ",BUTTONFIRST,BUTTONPREVIOUS,BUTTONNEXT,BUTTONLAST"
#define DATACONTROLS5 ",BARDATAEDIT,BARDATAVCR"

// Bitmap Buttons

class BitmapData(ParentObj) of PushButton(ParentObj) custom 
   SET TALK OFF
   with ( this )
      onOpen   := class::dataButton_onOpen
      speedBar := true
      text     := null
      width    := 32
      height   := 32
      metric   := 6 // pixels
      fontSize := 8
   endwith

   function dataButton_onOpen
      private rType
      rType = this.form.rowset
      this.visible = ( TYPE( "rType" ) <> "U" )
   return ( this.visible )

   function toggleSearch( current )  
      local bSearch, sControlList
      local vProp

      bSearch = ( this.form.rowset.state == 4 ) OR ;
                ( this.form.rowset.state == 5 )
      sControlList = UPPER( DATACONTROLS1 + DATACONTROLS2 + ;
                            DATACONTROLS3 + DATACONTROLS4 )
      sBarList     = UPPER( DATACONTROLS5 )
                    
      for i = 1 to this.form.elements.size

          if ( UPPER( this.form.elements[i].className ) $ sControlList )
             if ( this.form.elements[i] <> current ) 
                this.form.elements[i].enabled = ( NOT bSearch ) 
             endif      
          endif

          if ( UPPER( this.form.elements[i].className ) $ sBarList )
             this.form.elements[i].barToggle( bSearch, current )
          endif
      next
      class::refreshRowState()

   return ( bSearch )

   function refreshRowState      
      // Refresh the RowState control if found.
      local thisForm, bFound

      thisForm = form
      bFound   = false
                    
      for i = 1 to thisForm.elements.size
          if ( UPPER( thisForm.elements[i].className ) == "ROWSTATE" )
             thisForm.elements[i].refreshText()
             bFound := true
          endif
      next
   return ( bFound )
endclass


class BitmapAppend( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_APPEND"
      speedTip := "Add Row"
      onClick  := { ; this.form.rowset.beginAppend() ;
                    ; super::RefreshRowState() }
   endwith
endclass

class BitmapDelete( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_DELETE"
      speedTip := "Delete Row"
      onClick  := class::BitmapDelete_onClick
   endwith

   function BitmapDelete_onClick
      local bDelete
      bDelete = false

      if ( not this.form.rowset.endOfSet )

         if ( MSGBOX("You are about to delete the current row." ;
              + CHR(13) ;
              + "Click Yes to delete the current row.", ;
              "Alert", ;
              4 ) == 6 )

            bDelete := this.form.rowset.delete()

            if ( this.form.rowset.endOfSet )
              this.form.rowset.last()
            endif

         endif

      endif

      super::refreshRowState()
   return ( bDelete )

endclass

class BitmapSave( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_SAVE"
      speedTip := "Save Row"
      onClick  := { ; this.form.rowset.save() ;
                    ; super::refreshRowState() }
   endwith
endclass
                               
class BitmapAbandon( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_ABANDON"
      speedTip := "Abandon"
      onClick  := { ; this.form.rowset.abandon() ;
                    ; super::refreshRowState() }
   endwith
endclass

class BitmapLocate(ParentObj) of BitmapData( ParentObj ) custom
   with ( this )
      upBitmap := "RESOURCE:2 PS_LOCATE"
      speedTip := "Find Row"
      onClick  := class::bitmapLocate_onClick
   endwith

   function bitmapLocate_onClick
      // Change image and toggle other controls
      // when entering and exiting search mode.

      if ( this.form.rowset.state == 5 ) 
         this.upBitmap = "RESOURCE:2 PS_LOCATE"
         this.speedTip = "Find Row"
         this.form.rowset.applyLocate()
      else
         this.upBitmap = "RESOURCE:2 PS_RUN"
         this.speedTip = "Start Search" 
         this.form.rowset.beginLocate()
      endif
      super::toggleSearch(this)
   return ( this.form.rowset.state )
endclass

class BitmapFilter( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_FILTER"
      speedTip := "Filter Rowset"
      onClick  := class::bFilter_onClick
   endwith

   function bFilter_onClick
      // Change image and toggle other controls
      // when entering and exiting search mode.

      if ( this.form.rowset.state == 4 ) 
         this.upBitmap = "RESOURCE:2 PS_FILTER"
         this.speedTip = "Filter Rowset"
         this.form.rowset.applyFilter()     
      else
         this.upBitmap = "RESOURCE:2 PS_RUN"
         this.speedTip = "Apply Filter"
         this.form.rowset.beginFilter()
      endif
      super::toggleSearch(this)
   return ( this.form.rowset.state )
endclass

class BitmapEdit(ParentObj) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_EDIT"
      speedTip := "Edit Row"
      onClick  := { ; this.form.rowset.beginEdit() ;
                    ; super::RefreshRowState() }
   endwith
endclass


class BitmapFirst( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_FIRST"
      speedTip := "First Row"
      onClick  := { ; this.form.rowset.first() ;
                    ; super::RefreshRowState() }
   endwith
endclass

class BitmapPrevious( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_PREV"
      speedTip := "Previous Row"
      onClick  := { ; if ( NOT this.form.rowset.next(-1)) ;
                    ;    this.form.rowset.next() ; 
                    ; endif ;
                    ; super::RefreshRowState() }
   endwith
endclass

class BitmapNext( ParentObj ) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_NEXT"
      speedTip := "Next Row"
      onClick  := { ; if ( NOT this.form.rowset.next() ) ;
                    ;    this.form.rowset.next(-1) ;
                    ; endif ;
                    ; super::RefreshRowState() }
   endwith
endclass

class BitmapLast(ParentObj) of BitmapData( ParentObj ) custom 
   with ( this )
      upBitmap := "RESOURCE:2 PS_LAST"
      speedTip := "Last Row"
      onClick  := { ; this.form.rowset.last() ;
                    ; super::RefreshRowState() }
   endwith
endclass

class BarDataEdit( ParentObj, Name ) of Container( ParentObj, Name ) custom
   SET TALK OFF
   with ( this )
      width  := 192
      height := 32
      metric := 6 // pixels
      borderStyle := 3 // none
   endwith

   this.bitmapAppend = new BitmapAppend( this )
                            
   this.bitmapDelete = new BitmapDelete( this )
   with ( this.bitmapDelete )
      left     := 32
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith

   this.bitmapSave = new BitmapSave( this )
   with ( this.bitmapSave )
      left     := 64
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith
        
   this.bitmapAbandon = new BitmapAbandon( this )
   with ( this.bitmapAbandon )
      left     := 96
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith

   this.bitmapFilter = new BitmapFilter( this )
   with ( this.bitmapFilter )
      left     := 128
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith
        
   this.bitmapLocate = new BitmapLocate( this )
   with ( this.bitmapLocate )
      left     := 160
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith

   function barToggle( bSearch, current )
      with ( this )
         bitmapAppend.enabled  := ( not bSearch )
         bitmapDelete.enabled  := ( not bSearch )
         bitmapSave.enabled    := ( not bSearch )
         bitmapAbandon.enabled := ( not bSearch )
      endwith
      if ( current <> this.bitmapFilter )
         this.BitmapFilter.enabled := ( not bSearch )
      endif
      if ( current <> this.bitmapLocate )
         this.BitmapLocate.enabled := ( not bSearch )
      endif
   return ( bSearch )

endclass


class BarDataVCR( ParentObj, Name ) of Container( ParentObj, Name ) custom
   SET TALK OFF
   with ( this )
      width  := 128
      height := 32
      metric := 6 // pixels
      borderStyle := 3 // none
   endwith

   this.bitmapFirst = new BitmapFirst( this )

   this.bitmapPrevious = new BitmapPrevious( this )
   with ( this.bitmapPrevious )
      left     := 32
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith

   this.bitmapNext = new BitmapNext( this )
   with ( this.bitmapNext )
      left     := 64
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith
        
   this.bitmapLast = new BitmapLast( this )
   with ( this.bitmapLast )
      left     := 96
      width    := 32
      height   := 32
      fontSize := 8
      metric   := 6 // pixels
   endwith

   function barToggle( bSearch, current )
      with ( this )
         bitmapFirst.enabled    := ( not bSearch )
         bitmapPrevious.enabled := ( not bSearch )
         bitmapNext.enabled     := ( not bSearch )
         bitmapLast.enabled     := ( not bSearch )
      endwith
   return ( bSearch )

endclass



// State

class RowState( ParentObj ) of Text( ParentObj ) custom
   SET TALK OFF
   with ( this )
      onOpen     := class::RefreshText
      height     := 1
      width      := 18
      metric     := 0
      text       := "Unknown State"
      fontSize   := 8
      fontBold   := false
      fontItalic := true
   endwith
     
   function refreshText
      // Refresh text property
      local   nState
      private rType
      rType = this.form.rowset
      if ( TYPE( "rType" ) == "U" )
         this.text = "Rowset Not Found"
      else
         nState = this.form.rowset.state
         do case 
            case ( nState == 0 )
                 this.text := "Closed" 
            case ( nState == 1 )
                 this.text := "Read Only"
            case ( nState == 2 )
                 this.text := "Update"
            case ( nState == 3 )
                 this.text := "Append"
            case ( nState == 4 )
                 this.text := "Filter"
            case ( nState == 5 )
                 this.text := "Locate"
            otherwise
                 this.text := "Unknown State"
         endcase
      endif
   return ( this.text )
endclass

// Push Buttons

class ButtonData( ParentObj ) of PushButton( ParentObj ) custom 
   SET TALK OFF
   with ( this )
      onOpen   := class::buttonData_onOpen
      fontSize := 8
      fontBold := false 
      width    := 10
      height   := 1.2
      metric   := 0
   endwith

   function buttonData_onOpen
      private rType
      rType = this.form.rowset
      this.visible = ( TYPE( "rType" ) <> "U" )
   return ( this.visible )

   function toggleSearch( current )  
      local bSearch, sControlList
      bSearch = ( this.form.rowset.state == 4 ) OR ;
                ( this.form.rowset.state == 5 )
      sControlList = DATACONTROLS1 + DATACONTROLS2 + ;
                     DATACONTROLS3 + DATACONTROLS4

      for i = 1 to this.parent.elements.size
          if ( this.parent.elements[i].className $ sControlList )
             if ( this.parent.elements[i] <> current ) 
                this.parent.elements[i].visible = ( not bSearch ) 
             endif
          endif
      next
                    
   return ( bSearch )

   function refreshRowState
      // Refresh the RowState if found.
      local vProp, bRefresh
      bREfresh = false

      for i = 1 to this.parent.elements.size
          if ( UPPER( this.parent.elements[i].className ) == "ROWSTATE" )
             this.parent.elements[i].refreshText()
             bRefresh := true
          endif
      next

   return ( bRefresh )

endclass

class ButtonAppend( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Add"
      onClick := { ; this.form.rowset.beginAppend() ;
                   ; super::RefreshRowState() }
   endwith
endclass

class ButtonDelete(ParentObj ) of ButtonData( ParentObj ) custom 
   with ( this )
      text    := "Delete"
      onClick := class::buttonDelete_onClick
   endwith

   function buttonDelete_onClick
      local bDelete
      bDelete = false

      if ( not this.form.rowset.endOfSet )

         if ( MSGBOX("You are about to delete the current row." ;
              + CHR(13) ;
              + "Click Yes to delete the current row.", ;
              "Alert", ;
              4 ) == 6 )

            bDelete := this.form.rowset.delete()

            if (this.form.rowset.endOfSet)
               this.form.rowset.last()
            endif

         endif

      endif

      super::refreshRowState()
   return ( bDelete )

endclass

class ButtonSave( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
       text    := "Save"
       onClick := { ; this.form.rowset.save() ;
                    ; super::RefreshRowState() }
   endwith
endclass

class ButtonAbandon( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Abandon"
      onClick := { ; this.form.rowset.abandon() ;
                   ; super::RefreshRowState() }
   endwith
endclass

class ButtonLocate( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Locate"
      onClick := class::buttonLocate_onClick
   endwith
 
   function buttonLocate_onClick
      // Change text and toggle other controls
      // when entering and exiting search mode.

      if ( this.form.rowset.state == 5 ) 
         this.text = "Locate"
         this.form.rowset.applyLocate()
      else 
         this.text = "Start Search"
         this.form.rowset.beginLocate()
      endif
      super::toggleSearch(this)
   return ( this.form.rowset.state )
endclass

class ButtonFilter( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Filter"
      onClick := class::buttonFilter_onClick
   endwith

   function buttonFilter_onClick 
      // Change text and toggle other controls
      // when entering and exiting search mode.

      if ( this.form.rowset.state == 4 ) 
         this.text = "Filter"
         this.form.rowset.applyFilter()      
      else 
         this.text = "Start Search"
         this.form.rowset.beginFilter()
      endif
      super::toggleSearch(this)
   return ( this.form.rowset.state )
endclass


class ButtonEdit( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Edit"
      onClick := { ; this.form.rowset.beginEdit() ;
                   ; super::RefreshRowState() }
   endwith
endclass

class ButtonFirst( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "First"
      onClick := { ; this.form.rowset.first() ;
                   ; super::RefreshRowState() }
   endwith
endclass

class ButtonPrevious( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Previous"
      onClick := { ; if ( NOT this.form.rowset.next(-1) ) ;
                   ;    this.form.rowset.next() ; 
                   ; endif ;
                   ; super::RefreshRowState() }
   endwith
endclass

class ButtonNext( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Next"
      onClick := { ; if ( NOT this.form.rowset.next() ) ;
                   ;    this.form.rowset.next(-1) ; 
                   ; endif ;
                   ; super::RefreshRowState() }
   endwith
endclass

class ButtonLast( ParentObj ) of ButtonData( ParentObj ) custom
   with ( this )
      text    := "Last"
      onClick := { ; this.form.rowset.last() ;
                   ; super::RefreshRowState() }
   endwith
endclass


