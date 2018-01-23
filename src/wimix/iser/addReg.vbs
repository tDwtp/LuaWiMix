
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: addReg.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objFso
Dim objShell
Dim instDir
Dim major, minor

Set objFso = CreateObject("Scripting.FileSystemObject")

instDir = objFso.GetParentFolderName(objFso.GetParentFolderName(objFso.GetParentFolderName(WScript.ScriptFullName)))
If Not objFso.FolderExists(instDir) Then
	WScript.Echo "Invalid script location: """ & instDir & """ is not a valid directory."
	WScript.Quit(2)
End If
If Not objFso.FolderExists(instDir & "\wimix") Then
	WScript.Echo "Invalid script location: """ & instDir & "\wimix"" is not a valid directory."
	WScript.Quit(3)
End If

major = WScript.Arguments.Item(0)
minor = WScript.Arguments.Item(1)
If Not objFso.FolderExists(instDir & "\" & major & minor) Then
	WScript.Echo "Not installed: """ & instDir & "\" & major & minor & """ is not a valid directory."
	WScript.Quit(4)
End If
If Not objFso.FileExists(instDir & "\" & major & minor & "\lua" & major & minor & ".exe") Then
	WScript.Echo "Incomplete installation: """ & instDir & "\" & major & minor & "\lua" & major & minor & ".exe"" is not a valid file."
	WScript.Quit(5)
End If
If Not objFso.FileExists(instDir & "\" & major & minor & "\wlua" & major & minor & ".exe") Then
	WScript.Echo "Incomplete installation: """ & instDir & "\" & major & minor & "\wlua" & major & minor & ".exe"" is not a valid file."
	WScript.Quit(5)
End If
If Not objFso.FileExists(instDir & "\" & major & minor & "\luac" & major & minor & ".exe") Then
	WScript.Echo "Incomplete installation: """ & instDir & "\" & major & minor & "\luac" & major & minor & ".exe"" is not a valid file."
	WScript.Quit(5)
End If


Set objShell = CreateObject("WScript.Shell")

objShell.RegWrite "HKCR\.lua"  & major & minor & "\",  "Lua" & major & minor & ".Script",   "REG_SZ"
objShell.RegWrite "HKCR\.wlua" & major & minor & "\", "wLua" & major & minor & ".Script",   "REG_SZ"
objShell.RegWrite "HKCR\.luac" & major & minor & "\",  "Lua" & major & minor & ".Compiled", "REG_SZ"
objShell.RegWrite "HKCR\.lua"  & major & minor & "\ContentType\",   "text/plain", "REG_SZ"
objShell.RegWrite "HKCR\.lua"  & major & minor & "\PerceivedType\", "text", "REG_SZ"
objShell.RegWrite "HKCR\.wlua" & major & minor & "\ContentType\",   "text/plain", "REG_SZ"
objShell.RegWrite "HKCR\.wlua" & major & minor & "\PerceivedType\", "text", "REG_SZ"

objShell.RegWrite "HKCR\Lua"  & major & minor & ".Compiled\", "Lua " & major & "." & minor & " compiled Script", "REG_SZ"
objShell.RegWrite "HKCR\wLua" & major & minor & ".Script\",   "Lua " & major & "." & minor & " promptless Script File", "REG_SZ"
objShell.RegWrite "HKCR\Lua"  & major & minor & ".Script\",   "Lua " & major & "." & minor & " Script File", "REG_SZ"
objShell.RegWrite "HKCR\Lua"  & major & minor & ".Script\Shell\Open\Command\",   """" & instDir & major & minor & "\lua"  & major & minor & ".exe"" ""%1"" %*", "REG_EXPAND_SZ"
objShell.RegWrite "HKCR\wLua" & major & minor & ".Script\Shell\Open\Command\",   """" & instDir & major & minor & "\wlua" & major & minor & ".exe"" ""%1"" %*", "REG_EXPAND_SZ"
objShell.RegWrite "HKCR\Lua"  & major & minor & ".Compiled\Shell\Open\Command\", """" & instDir & major & minor & "\luac" & major & minor & ".exe"" ""%1"" %*", "REG_EXPAND_SZ"
objShell.RegWrite "HKCR\Lua"  & major & minor & ".Compiled\DefaultIcon\", instDir & "\wimix\icon\luac-file.ico", "REG_SZ"
objShell.RegWrite "HKCR\wLua" & major & minor & ".Script\DefaultIcon\",   instDir & "\wimix\icon\lua-file.ico",  "REG_SZ"
objShell.RegWrite "HKCR\Lua"  & major & minor & ".Script\DefaultIcon\",   instDir & "\wimix\icon\lua-file.ico",  "REG_SZ"
objShell.RegWrite "HKCR\Lua"  & major & minor & ".Script\Shell\Edit\Command\", """" & instDir & "\wimix\SciTE\SciTE.exe"" ""%1""", "REG_EXPAND_SZ"
objShell.RegWrite "HKCR\wLua" & major & minor & ".Script\Shell\Edit\Command\", """" & instDir & "\wimix\SciTE\SciTE.exe"" ""%1""", "REG_EXPAND_SZ"

REM objShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\LUA_DEV_${major}_${minor}", "$INSTDIR\" & major & minor & ""
