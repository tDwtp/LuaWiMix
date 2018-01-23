
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: addEnv.vbs ""NAME"" ""VALUE"""
	Rem no argument given
	WScript.Quit(1)
End If

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")
objEnv(WScript.Arguments.Item(0)) = WScript.Arguments.Item(1)
