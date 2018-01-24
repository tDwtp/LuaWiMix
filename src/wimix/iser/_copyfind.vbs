
Dim objFso, iserDir
Dim outFile, inFile
Set objFso = CreateObject("Scripting.FileSystemObject")
iserDir = objFso.GetParentFolderName(WScript.ScriptFullName)

Set outFile = objFso.CreateTextFile(iserDir & "\out.vbs", True, False)
Set inFile  = objFso.OpenTextFile(iserDir & "\findVer.vbs", 1, False, 0)

outFile.WriteLine("")
outFile.WriteLine("Sub DefaultVersion")
outFile.WriteLine("	WScript.Echo ""53""")
outFile.WriteLine("	WScript.Quit(0)")
outFile.WriteLine("End Sub")
outFile.WriteLine("")

Dim line
Do
	line = inFile.ReadLine()
Loop Until line = "End Sub"

inFile.ReadLine()

Do While Not inFile.AtEndOfStream
	outFile.WriteLine(inFile.ReadLine())
Loop