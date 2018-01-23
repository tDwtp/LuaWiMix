
If WScript.Arguments.Count <> 1 Then
	WScript.Echo "Usage: remEnv.vbs ""NAME"""
	WScript.Quit(1)
End If

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")
objEnv.Remove(WScript.Arguments.Item(0))
