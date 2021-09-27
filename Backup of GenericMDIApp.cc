/*
	GenericMDIApp.cc
	Author: Wycliffe Nyongesa
	Date : September 27, 2021
	An application class object designed to handle the setup and shut down of
	an application using MDI (Multiple Document Interface).
	This code should be subclassed for a specific application.
*/
class GenericMDIApp

	// This custom property should be overwritten
	// in a subclass, or after the class is created, but
	// before the Open() method is invoked:
	this.FrameWinText = "Generic MDI application"
	
	// The same goes for this custom property:
	this.FormClassName = "MyMainForm"
	
	// We assume here that every MDI app will have
	// a SETUP.PRG
	do setup
	
	// Assign a property to _app.frameWin, which is
	// a reference to this object: "this".
	_app.framewin.app = this
	
	function Open
		// set a reference to the login form
		private c
		
		// build the command (a 'macro'):
		c = 'this.rootForm = new '+this.FormClassName+;
		'(_app.framewin,"Root")'
		// execute it:
		&c.
		
		// Make sure no forms are open
		*close forms
		
		// Make sure we're not in "design mode"
		set design off
		
		// set the <Escape> key "off" but store the
		// current setting:
		this.OldEscape = set("ESCAPE")
		set escape off
		
		// Turn off the dBASE™ PLUS shell, but
		// leave the MDI frame window:
		shell( false, true )
		
		// Turn off the application's speedBar, statusBar, and tabBar
		// however, for a true MDI app, you may actually want
		// the tabBar turned on:
		_app.speedbar := false
		_app.statusBar := false
		_app.tabBar := false
		
		// Set the text property for the application's framewin,
		// but keep a reference to the original text so we can re-set it
		_app.framewin.oldText = _app.framewin.text
		_app.framewin.text := this.FrameWinText
	return
	
	function close
		// close any forms that might have been left open
		*close forms
		
		// if we are in the "runtime" environment (the executable),
		// we want to "quit" (otherwise the framewin will
		// be left on screen and dBASE™ PLUSRun.exe will be left
		// in memory!)
		if ( "runtime" $ lower( version(0) ) )
			quit
		else
		// otherwise we're in the IDE, let's reset some
		// values:
			with ( _app )
				framewin.app := null
				framewin.text := framewin.OldText
				speedbar := true
				statusBar := true
				tabBar := true
			endwith
			
			// go back to design mode:
			set design on
			
			// set escape back to whatever it's previous
			// state was:
			cEscape = this.oldEscape
			set escape &cEscape.
			
			// close any open procedures
			close procedure
			
			// release the form
			_app.framewin.root.release()
			
			// set the shell back ...
			shell( true, true )
		endif
	return
endclass