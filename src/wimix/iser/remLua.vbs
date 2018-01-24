
'TODO:
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: remLua.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objFso
Dim instDir
Dim major, minor

Set objFso = CreateObject("Scripting.FileSystemObject")

instDir = objFso.GetParentFolderName(objFso.GetParentFolderName(objFso.GetParentFolderName(WScript.ScriptFullName)))
major = WScript.Arguments.Item(0)
minor = WScript.Arguments.Item(1)

If Not objFso.FolderExists(instDir & "\" & major & minor) Then
	WScript.Echo "Invalid script location: """ & instDir & """ is not a valid directory."
	WScript.Quit(2)
End If

objFso.DeleteFolder(instDir & "\" & major & minor)

