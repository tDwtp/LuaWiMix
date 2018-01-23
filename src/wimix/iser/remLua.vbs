
'TODO:
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: remLuaEnv.vbs <major> <minor>"
	WScript.Quit(1)
End If

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")
objEnv.Remove(WScript.Arguments.Item(0))
