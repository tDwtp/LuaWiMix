
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: remReg.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objShell
Dim major, minor
Set objShl = CreateObject("WScript.Shell")
major = WScript.Arguments.Item(0)
minor = WScript.Arguments.Item(1)

objShell.RegDelete "HKCR\.lua"  & major & minor & "/"
objShell.RegDelete "HKCR\.wlua" & major & minor & "/"
objShell.RegDelete "HKCR\.luac" & major & minor & "/"

objShell.RegDelete "HKCR\Lua"  & major & minor & ".Compiled/"
objShell.RegDelete "HKCR\wLua" & major & minor & ".Script/"
objShell.RegDelete "HKCR\Lua"  & major & minor & ".Script/"