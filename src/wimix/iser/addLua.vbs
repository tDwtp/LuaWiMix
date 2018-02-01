
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: addEnv.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objFso, objApp
Dim objSrc, objDst
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
If objFso.FolderExists(instDir & "\" & major & minor) Then
	WScript.Echo "Allready installed: """ & instDir & "\" & major & minor & """ is a valid directory."
	WScript.Quit(4)
End If

If Not objFso.FileExists(instDir & "\wimix\arc\lua"& major & minor &".zip") Then
	WScript.Echo "No archive (""lua"& major & minor &".zip"") found at """ & instDir & "\wimix\arc"""
	WScript.Quit(6)
End If

objFso.CreateFolder(instDir & "\" & major & minor)
Rem objFso.CreateFolder(instDir & "\" & major & minor & "\include")
Rem objFso.CreateFolder(instDir & "\" & major & minor & "\lib")
objFso.CreateFolder(instDir & "\" & major & minor & "\clibs")
Rem objFso.CreateFolder(instDir & "\" & major & minor & "\lua")
objFso.CreateFolder(instDir & "\" & major & minor & "\examples")
objFso.CreateFolder(instDir & "\" & major & minor & "\docs")

' Copy Zips
Set objApp = CreateObject("Shell.Application")
' 1556, as options to CopyHere

Set objSrc = objApp.NameSpace(instDir & "\wimix\arc\lua"& major & minor &".zip").Items()
Set objDst = objApp.NameSpace(instDir & "\" & major & minor)
objDst.CopyHere objSrc, 1556
