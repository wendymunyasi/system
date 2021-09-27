/*
	START.PRG
	Author: Wycliffe Nyongesa
	Date: September 27, 2021
	
	FMS START program
*/

	//update this for application version changes:
	#define AppVersion "1.0" // Version 1 of this FMS project
	set talk off
	// set the private directory for the BDE
	// uses BDE (IDAPI) API Code below the TutorialApp
	// definition -- this uses a default folder,
	// no need to pass a value:
	setPrivateDir()
	// set up the application object:
	local app
	set procedure to GenericMDIApp.cc
	app = new FMSApp()
	app.open()
return

/*
	FMSApp is a subclass of the "GenericMDIApp" contained
	in the .cc file of the same name:
*/
class FMSApp of GenericMDIApp
	// set any specific code for the subclassed
	// MDI application here - note this uses the AppVersion constant
	// created above for the version number:
	this.FrameWinText = "FMS Project -- vers. " + AppVersion
	// note this is not the file name -- the
	// SETUP program must execute "set procedure ..." that
	// will open the file "kenslog.wfm" ... the class
	// will be available from that point on. This is
	// the classname of the menu:
	this.FormClassName = "LoginForm"
endclass

/*
	Code that deals with setting the private folder for the BDE
	to write _QSQLnnnn.dbf files, this is API code and a bit involved.
	Provided by Wian in the dBASE newsgroups, but appears to have
	been originally provided by Rick Miller.
*/
function setPrivateDir( cPath )
	if not type("DbiSetPrivateDir") == "FP"
		extern CUSHORT DbiSetPrivateDir(CSTRING) idapi32 from "DbiSetPrivateDir"
	endif
	Local cDir
	if type("argVector(1)") == "C"
		cDir = cPath
	else
		// when cDir == null, reset to default.
		cDir = null
	endif
return iif( DbiSetPrivateDir( cDir ) == 0, true, false )