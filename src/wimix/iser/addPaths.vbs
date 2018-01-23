
If WScript.Arguments.Count <= 0 Then
	WScript.Echo "Needs 1 or more arguments. Put it between quotes if necessary"
	WScript.Quit(1)
End If

Dim ObjShl, objEnv, objFso
Dim exitCode, sysVarName

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")
Set objFso = CreateObject("Scripting.FileSystemObject")

exitCode = 0
sysVarName = "Path"

For Each addPath In WScript.Arguments
Do
	curPath = objEnv(sysVarName)
	REM addPath = WScript.Arguments.Item(0)
	
	If Not objFso.FolderExists(addPath) Then
		WScript.Echo """" & addPath & """ is not a valid path."
		exitCode = exitCode Or 2
		Exit Do
	End If
	If UCase(addpath) <> UCase(objFso.GetAbsolutePathName(addpath)) Then
		WScript.Echo """" & addPath & """ is not an absolute path"
		exitCode = exitCode Or 2
		Exit Do
	End If

	If curPath = "" Then
		curPath = ""
	End If

	lenAPath = Len(addPath)
	lenCPath = Len(curPath)
	diffPath = lenCPath - lenAPath

	lackPath = True

	Rem StartsWith
	lackPath = lackPath And ( InStr(1, curPath,       addPath & ";") <> 1 )
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath & ";") <> 1 )

	Rem EndsWith
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath      ) <> diffPath     )
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath & ";") <> diffPath - 1 )

	Rem IsEqual
	lackPath = lackPath And ( curPath <>       addPath       )
	lackPath = lackPath And ( curPath <> ";" & addPath       )
	lackPath = lackPath And ( curPath <> ";" & addPath & ";" )
	lackPath = lackPath And ( curPath <>       addPath & ";" )

	Rem Contains
	lackPath = lackPath And ( InStr(1, curPath, ";" & addPath & ";") = 0 )

	If lackPath Then
		' Assert True, "Appending Path"
		
		prePath = ";"
		If Right(curPath, 1) = ";" Then
			prePath = ""
		End If
		
		newPath = curPath & prePath & addPath & ";"
		' Assert True, newPath
		
		objEnv(sysVarName) = newPath
	Else
		exitCode = exitCode Or 4
	End If
Loop While False
Next

WScript.Quit(exitCode)
