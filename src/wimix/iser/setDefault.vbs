
If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: setDefault.vbs <major> <minor>"
	WScript.Quit(1)
End If

Dim objFso
Dim iserDir, tmpDir
Dim major, minor
Dim outFile, inFile

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


iserDir = objFso.GetParentFolderName(WScript.ScriptFullName)
tmpDir = 

objFso.CopyFile(iserDir&"/findVer.vbs", iserDir&"/tmpVer.vbs", True)

Set outFile = objFso.CreateTextFile(iserDir & "\findVer.vbs", True, False)
Set inFile  = objFso.OpenTextFile(iserDir & "\dummyVer.vbs", 1, False, 0)

outFile.WriteLine("")
outFile.WriteLine("Sub DefaultVersion")
outFile.WriteLine("	WScript.Echo ""53""")
outFile.WriteLine("	WScript.Quit(0)")
outFile.WriteLine("End Sub")

Dim line
Do
	line = inFile.ReadLine()
Loop Until line = "End Sub"
Do While Not inFile.AtEndOfStream
	outFile.WriteLine(inFile.ReadLine())
Loop
