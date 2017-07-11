Sub Assert(boolCheck, strMessage)
	If boolCheck Then
		WScript.Echo "Assert:", strMessage
		Rem WScript.Echo "Assert:", strMessage
	End If
End Sub

If WScript.Arguments.Count <= 0 Then
	Rem no argument given
	Assert True, "Needs 1 ore more arguments. Put it between Quotes if necessary"
	WScript.Quit(1)
End If

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")
Set objFso = CreateObject("Scripting.FileSystemObject")

sysVarName = "Path"

For Each addPath In WScript.Arguments
Do
	curPath = objEnv(sysVarName)
	REM addPath = WScript.Arguments.Item(0)

	If Not objFso.FolderExists(addPath) Then
		Assert True, "Not a valid path"
		Exit Do
	End If

	If curPath = "" Then
		curPath = ""
	End If

	lenAPath = Len(addPath)
	lenCPath = Len(curPath)
	diffPath = lenCPath - lenAPath

	dontAssert = False

	lackPath = True

	Rem StartsWith
	lackPath = lackPath And ( InStr(1, curPath,       addPath & ";") <> 1 )
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath & ";") <> 1 )
	Assert ( Not lackPath ) And Not dontAssert, "StartsWith"
	dontAssert = Not lackPath

	Rem EndsWith
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath      ) <> diffPath     )
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath & ";") <> diffPath - 1 )
	Assert ( Not lackPath ) And Not dontAssert, "EndsWith"
	dontAssert = Not lackPath

	Rem IsEqual
	lackPath = lackPath And ( curPath <>       addPath       )
	lackPath = lackPath And ( curPath <> ";" & addPath       )
	lackPath = lackPath And ( curPath <> ";" & addPath & ";" )
	lackPath = lackPath And ( curPath <>       addPath & ";" )
	Assert ( Not lackPath ) And Not dontAssert, "IsEqual"
	dontAssert = Not lackPath

	Rem Contains
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath & ";") = 0 )
	Assert ( Not lackPath ) And Not dontAssert, "Contains"
	dontAssert = Not lackPath

	If lackPath Then
		Assert True, "Appending Path"
		
		prePath = ";"
		If Right(curPath, 1) = ";" Then
			prePath = ""
		End If
		
		newPath = curPath & prePath & addPath & ";"
		Assert True, newPath
		
		objEnv(sysVarName) = newPath
	Else
		Assert Not lackPath, "Found the path"
	End If
Loop While False
Next
