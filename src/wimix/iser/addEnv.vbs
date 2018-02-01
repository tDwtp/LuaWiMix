
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: addEnv.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objFso
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


Dim objEnv, objShl
Dim envLoc, suffix
Dim luaDev, luaCPath, luaPath

If major = 5 And minor = 1 Then
	suffix = ""
Else
	suffix = "_" & major & "_" & minor
End If

Set objShl = CreateObject("WScript.Shell")
envLoc = "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\"

luaDev = instDir & "\" & major & minor
luaCPath = _
	".\?.dll;" & _
	".\?" & major & minor & ".dll;" & _
	instDir & "\" & major & minor & "\clibs\?.dll;" & _
	instDir & "\" & major & minor & "\clibs\?" & major & minor & ".dll;" & _
	instDir & "\" & major & minor & "\loadall.dll;" & _
	instDir & "\" & major & minor & "\clibs\loadall.dll" ' & _
	' instDir & "\" & major & minor & "\?.dll;" & _
	' instDir & "\" & major & minor & "\?" & major & minor & ".dll;" & _
luaPath = _
	".\?.lua;" & _
	".\?.lua" & major & minor & ";" & _
	".\?\init.lua;" & _
	".\?\init.lua" & major & minor & ";" & _
	instDir & "\" & major & minor & "\lua\?.lua;" & _
	instDir & "\" & major & minor & "\lua\?.lua" & major & minor & ";" & _
	instDir & "\" & major & minor & "\lua\?\init.lua;" & _
	instDir & "\" & major & minor & "\lua\?\init.lua" & major & minor & ";" & _
	instDir & "\" & major & minor & "\lua\?.luac;" & _
	instDir & "\" & major & minor & "\lua\?.luac" & major & minor & ";" ' & _
	' instDir & "\" & major & minor & "\?.lua;" & _
	' instDir & "\" & major & minor & "\?.lua" & major & minor & ";" & _
	' instDir & "\" & major & minor & "\?\init.lua;" & _
	' instDir & "\" & major & minor & "\?\init.lua" & major & minor & ";" & _

objShl.RegWrite envLoc & "LUA_DEV_" & major & "_" & minor, luaDev, "REG_SZ"
objShl.RegWrite envLoc & "LUA_CPATH" & suffix, luaCPath, "REG_SZ"
objShl.RegWrite envLoc & "LUA_PATH" & suffix, luaPath, "REG_SZ"

' read the values to update the environment properly
Set objEnv = objShl.Environment("System")
objEnv("LUA_DEV_" & major & "_" & minor) = luaDev
objEnv("LUA_CPATH" & suffix) = luaCPath
objEnv("LUA_PATH"  & suffix) = luaPath