Sub Assert(boolCheck, strMessage)
	If boolCheck Then
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
		Assert True, "IsEmpty"
		Exit Do
	End If

	pPos = InStr(1, curPath, ";" & remPath & ";")
	If pPos <> 0 Then
		Assert True, "Contains"
		
		lPath =  Left(curPath, pPos)
		rPath = Right(curPath, diffPath - pPos - 1)
		newPath = lPath & rPath
		
		Assert True, newPath
		objEnv(sysVarName) = newPath
		Exit Do
	End If

	Rem StartsWith
	pPos = InStr(1, curPath, remPath & ";")
	If pPos = 1 Then
		Assert True, "StartsWith"
		
		newPath = Right(curPath, diffPath - pPos)
		
		Assert True, newPath
		objEnv(sysVarName) = newPath
		Exit Do
	End If

	Rem EndsWith
	pPos = InStr(1, curPath, ";" & remPath)
	lenRPath = Len(remPath)
	If pPos = lenRPath Or pPos = lenRPath - 1 Then
		Assert True, "StartsWith"
		
		newPath = Left(curPath, diffPath)
		
		Assert True, newPath
		objEnv(sysVarName) = newPath
		Exit Do
	End If

	Rem IsEqual
	If curPath = remPath Or curPath = (";" & remPath) Then
		Assert True, "IsEqual"
		objEnv(sysVarName) = ""
		Exit Do
	End If
Loop While False
Next