class MyReportTitleText(parentObj) of TEXT(parentObj) custom
	with (this)
		alignHorizontal := 1 // Center
		alignVertical := 1 // Middle
		fontItalic := true
		fontName := "Arial"
		fontSize := 18
		height := 0.3229
		metric := 3 // Inches
		text := "This is a Main Report Title"
		transparent := true
		width := 3.5313
		wrap := true
	endwith
endclass

class MyStandardText(parentObj) of TEXT(parentObj) custom
	with (this)
		alignHorizontal := 0 // Left
		alignVertical := 0 // Top
		fontName := "Arial"
		fontSize := 10
		height := 0.18
		metric := 3 // Inches
		text := "MyStandardText"
		transparent := true
		width := 1.1667
	endwith
endclass

class MyDateText(parentObj) of MyStandardText(parentObj) custom
	with (this)
		alignHorizontal := 1 // center
		alignVertical := 1 // Middle
		text := {||"Date: "+date()}
	endwith
endclass

class MyFieldHeadingText(parentObj) of MyStandardText(parentObj) custom
	with (this)
		height := 0.18
		width := 0.75
		alignHorizontal := 2 // Right
		text := "FieldHeading: "
		fontBold := true
	endwith
endclass

class MyFieldText(parentObj) of MyStandardText(parentObj) custom
	with (this)
		width := 1.2188
		variableHeight := true
		// This needs to be modified for each instance/field
		text := {||"field codeblock"}
	endwith
endclass

// Start with a base shape class:
class MyRectangleShape(parentObj) of SHAPE(parentObj) custom
	with (this)
		width := 2.9479
		height := 0.4063
		metric := 3 // Inches
		colorNormal := "BLACK/WHITE"
		penStyle := 0 // Solid
		penWidth := 2
		shapeStyle := 1 // Rectangle
	endwith
endclass

class MyLine(parentObj) of LINE(parentObj) custom
	with (this)
		left := 0
		right := 4.4722
		top := 0
		bottom := this.top
		fixed := false
		width := 2
		metric := 3 // Inches
	endwith
endclass