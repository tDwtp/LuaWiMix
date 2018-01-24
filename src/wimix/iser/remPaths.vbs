
If WScript.Arguments.Count <= 0 Then
	Rem no argument given
	WScript.Echo "Needs 1 ore more arguments. Put it between Quotes if necessary"
	WScript.Quit(1)
End If

Dim ObjShl, objEnv, objFso
Dim exitCode, sysVarName

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")

exitCode = 0
sysVarName = "Path"

For Each addPath In WScript.Arguments
Do
	curPath = objEnv(sysVarName)
	Rem remPath = WScript.Arguments.Item(0)

	If curPath = "" Then
		curPath = ""
	End If

	lenRPath = Len(remPath)
	lenCPath = Len(curPath)
	diffPath = lenCPath - lenRPath


	If curPath = "" Then
		Rem "IsEmpty"
		exitCode = exitCode Or 4
		Exit Do
	End If

	pPos = InStr(1, curPath, ";" & remPath & ";")
	If pPos <> 0 Then
		Rem Contains
		
		lPath =  Left(curPath, pPos)
		rPath = Right(curPath, diffPath - pPos - 1)
		newPath = lPath & rPath
		
		' Assert True, newPath
		objEnv(sysVarName) = newPath
		Exit Do
	End If

	pPos = InStr(1, curPath, remPath & ";")
	If pPos = 1 Then
		Rem StartsWith
		
		newPath = Right(curPath, diffPath - pPos)
		
		' Assert True, newPath
		objEnv(sysVarName) = newPath
		Exit Do
	End If

	pPos = InStr(1, curPath, ";" & remPath)
	lenRPath = Len(remPath)
	If pPos = lenRPath Or pPos = lenRPath - 1 Then
		Rem EndsWith
		
		newPath = Left(curPath, diffPath)
		
		' Assert True, newPath
		objEnv(sysVarName) = newPath
		Exit Do
	End If

	If curPath = remPath Or curPath = (";" & remPath) Or curPath = (";" & remPath & ";") Or curPath = (remPath & ";") Then
		Rem IsEqual
		objEnv(sysVarName) = ""
		Exit Do
	End If

	If curPath = remPath Or curPath = (";" & remPath) Then
		Rem IsEqual
		objEnv(sysVarName) = ""
		Exit Do
	End If
	
	exitCode = exitCode Or 2
Loop While False
Next

WScript.Quit(exitCode)
