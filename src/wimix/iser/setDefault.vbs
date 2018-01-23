
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: setDefault.vbs <major> <minor>"
	WScript.Quit(1)
End If

' Modifier for reading files or something?
' 1540
Dim objFso, objShl
Dim iserDir
Dim major, minor
Dim  lua1,  lua2
Dim fLua, fLuac, fwLua, fiLua
Dim fRocks, faRocks, fwRocks

Dim sLua, sRocks


Set objFso = CreateObject("Scripting.FileSystemObject")
iserDir = objFso.GetParentFolderName(objFso.GetParentFolderName(objFso.GetParentFolderName(WScript.ScriptFullName)))

major = WScript.Arguments.Item(1)
minor = WScript.Arguments.Item(2)
If Not objFso.FolderExists(iserDir & "\" & major & minor) Then
	WScript.Echo """" & iserDir & "\" & major & minor & """ is not a valid directory"
	WScript.Quit(4)
End If
If Not objFso.FileExists(iserDir & "\" & major & minor & "\lua" & major & minor & ".exe") Then
	WScript.Echo """" & iserDir & "\" & major & minor & """ is not a valid file"
	WScript.Quit(5)
End If


sLua = "@ECHO OFF" & vbCrLf & _
		"GOTO HANDLE" & vbCrLf & _
		"" & vbCrLf & _
		":APPEND_PATH" & vbCrLf & _
		"FOR %%# IN (%~n0%1.exe) DO IF NOT ""%%~$PATH:#"" == """" GOTO END" & vbCrLf & _
		"PUSHD ." & vbCrLf & _
		"CD /D ""%~dp0\..\%1""" & vbCrLf & _
		"SET ""Path=%Path%;%CD%""" & vbCrLf & _
		"POPD" & vbCrLf & _
		"GOTO END" & vbCrLf & _
		"" & vbCrLf & _
		":HANDLE" & vbCrLf & _
		"IF NOT EXIST ""%~dp0\..\%1\%~n0%1.exe"" GOTO USEDEFAULT" & vbCrLf & _
		"CALL :APPEND_PATH %1" & vbCrLf & _
		"%~n0%*" & vbCrLf & _
		"GOTO END" & vbCrLf & _
		"" & vbCrLf & _
		":USEDEFAULT" & vbCrLf & _
		"CALL :APPEND_PATH %1" & vbCrLf & _
		"%~n0"&major&""&minor&" %*" & vbCrLf & _
		"" & vbCrLf & _
		":END" & vbCrLf

siLua = "@ECHO OFF" & vbCrLf & _
		"GOTO HANDLE" & vbCrLf & _
		"" & vbCrLf & _
		":APPEND_PATH" & vbCrLf & _
		"FOR %%# IN (%~n0%1.bat) DO IF NOT ""%%~$PATH:#"" == """" GOTO END" & vbCrLf & _
		"PUSHD ." & vbCrLf & _
		"CD /D ""%~dp0\..\%1""" & vbCrLf & _
		"SET ""Path=%Path%;%CD%""" & vbCrLf & _
		"POPD" & vbCrLf & _
		"GOTO END" & vbCrLf & _
		"" & vbCrLf & _
		":HANDLE" & vbCrLf & _
		"IF NOT EXIST ""%~dp0\..\%1\%~n0%1.exe"" GOTO USEDEFAULT" & vbCrLf & _
		"CALL :APPEND_PATH %1" & vbCrLf & _
		"%~n0%*" & vbCrLf & _
		"GOTO END" & vbCrLf & _
		"" & vbCrLf & _
		":USEDEFAULT" & vbCrLf & _
		"CALL :APPEND_PATH %1" & vbCrLf & _
		"%~n0"&major&""&minor&" %*" & vbCrLf & _
		"" & vbCrLf & _
		":END" & vbCrLf

sRocks = "@ECHO OFF" & vbCrLf & _
		"GOTO HANDLE" & vbCrLf & _
		"" & vbCrLf & _
		":APPEND_PATH" & vbCrLf & _
		"FOR %%# IN (%~n0%1.bat) DO IF NOT ""%%~$PATH:#"" == """" GOTO END" & vbCrLf & _
		"PUSHD ." & vbCrLf & _
		"CD /D ""%~dp0\rocks\%1""" & vbCrLf & _
		"SET ""Path=%Path%;%CD%""" & vbCrLf & _
		"POPD" & vbCrLf & _
		"GOTO END" & vbCrLf & _
		"" & vbCrLf & _
		":HANDLE" & vbCrLf & _
		"IF NOT EXIST ""%~dp0\rocks\%1\%~n0%1.bat"" GOTO USEDEFAULT" & vbCrLf & _
		"CALL :APPEND_PATH %1" & vbCrLf & _
		"%~n0%*" & vbCrLf & _
		"GOTO END" & vbCrLf & _
		"" & vbCrLf & _
		":USEDEFAULT" & vbCrLf & _
		"CALL :APPEND_PATH %1" & vbCrLf & _
		"%~n053 %*" & vbCrLf & _
		"" & vbCrLf & _
		":END" & vbCrLf

' ..\lua.cmd'
' ..\wlua.cmd'
' ..\luac.cmd'

objShl = CreateObject("WScript.Shell")
objEnv = objShl.Environment("SYSTEM")
objEnv("LUA_DEV") = iserDir & "\" & major & minor;

fLua  = objFso.CreateTextFile(iserDir & "\wimix\" & "lua.cmd")
fLua.Write  sLua
fLua.Close()

fLuac = objFso.CreateTextFile(iserDir & "\wimix\" & "luac.cmd")
fLuac.Write  sLua
fLuac.Close()

fwLua = objFso.CreateTextFile(iserDir & "\wimix\" & "wlua.cmd")
fwLua.Write  sLua
fwLua.Close()

' ..\ilua.cmd'

fiLua = objFso.CreateTextFile(iserDir & "\wimix\" & "ilua.cmd")
fiLua.Write siLua
fiLua.Close()

' ..\luarocks.cmd'
' ..\luarocks-admin.cmd'
' ..\luarocksw.cmd'

fRocks = objFso.CreateTextFile(iserDir & "\wimix\" & "luarocks.cmd")
fRocks.Write sRocks
fRocks.Close()

fRocksa = objFso.CreateTextFile(iserDir & "\wimix\" & "luarocks-admin.cmd")
fRocksa.Write sRocks
fRocksa.Close()

fwRocks = objFso.CreateTextFile(iserDir & "\wimix\" & "luarocksw.cmd")
fwRocks.Write sRocks
fwRocks.Close()
