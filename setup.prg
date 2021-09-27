/*
	SETUP.PRG
	The "setup program" for the MDI Tutorial
	application ... open any and all files
	needed to run the application and/or develop
	the application.
*/

// These always get me -- if the program
// crashes, and they usually do while developing --
// (due to programmer error), the speedBar and the
// statusBar in the IDE is not available ... this
// just puts them back. the MDI application class turns
// them back off ...
_app.speedbar := true
_app.statusBar := true
_app.tabBar := true

// this can also cause problems:
set design on

// Set procedures ...:
set procedure to start

// make sure the form is available:
set procedure to Kenslog.wfm

// custom controls used by the application
set procedure to Buttons.cc
set procedure to Databuttons.cc
set procedure to Passwdc.cc
set procedure to Password.cc
set procedure to Paswdcon.cc
set procedure to Fgmast.wfm
set procedure to Fgprint.wfm
set procedure to FRIGTMES.wfm
set procedure to kenalloc.wfm
set procedure to KENAUDIT.wfm
set procedure to Kenautos.wfm
set procedure to kencoy.wfm
set procedure to KENDDE.wfm
set procedure to kENFC.wfm
set procedure to KenMis.wfm
set procedure to kenpurch.wfm
set procedure to KenRecPy.wfm
set procedure to kensales.wfm
set procedure to kenslog.wfm
set procedure to KENSLOGD.wfm
set procedure to kenslogf.wfm
set procedure to KENSLOGL.wfm
set procedure to KENSLOGR.wfm
set procedure to KENSLOGS.wfm
set procedure to search.wfm
set procedure to VenNAMES.wfm
