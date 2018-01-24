
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: remEnv.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objEnv, objShell
Dim major, minor
Dim suffix

If major = 5 And minor = 1 Then
	suffix = ""
Else
	suffix = "_" & major & "_" & minor
End If

Set objShl = CreateObject("WScript.Shell")
Set objEnv = objShl.Environment("SYSTEM")

objEnv.Remove("LUA_DEV_" & major & "_" & minor)
objEnv.Remove("LUA_CPATH" & suffix)
objEnv.Remove("LUA_PATH" & suffix)
