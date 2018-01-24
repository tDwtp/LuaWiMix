
Sub DefaultVersion
	WScript.Echo "wimix"
	WScript.Quit(0)
End Sub

If WScript.Arguments.Count < 1 Then
	DefaultVersion
End If

Dim objFso, iserDir

Set objFso = CreateObject("Scripting.FileSystemObject")
Const valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
iserDir = objFso.GetParentFolderName(objFso.GetParentFolderName(objFso.GetParentFolderName(WScript.ScriptFullName)))



Function ValidNameLength(name)
	validLength = Len(name)
	
	For index = 1 To Len(name)
		current = Mid(name, index, 1)
		
		If InStr(valid, current) = 0 Then
			validLength = index - 1
		End If
	Next
	
	ValidNameLength = validLength
End Function

Function IsValidName(name)
	isValid = False
	
	If ValidNameLength(name) <> Len(name) Then
		IsValidName = False
		Exit Function
	End If
	
	If objFso.FolderExists(iserDir & "\" & name) Then
		If objFso.FileExists(iserDir & "\" & name & "\lua" & name & ".exe") Then
			isValid = True
		End If
	End If
	
	If name = "wimix" Then
		isValid = False
	End If
	
	IsValidName = isValid
End Function



Do
	first = WScript.Arguments.Item(0)
	
	If Mid(first, 1, 1) = "-" Or objFso.FileExists(first) Then
		Exit Do
	End If
	
	If ValidNameLength(first) <> Len(first) Then
		Exit Do
	End If
	
	If Not IsValidName(first) Then
		Exit Do
	End If
	
	WScript.Echo first
	WScript.Quit(0)
	
Loop Until True



Dim file
ignore = False

For index = 0 To WScript.Arguments.Count - 1
	
	Do While Not ignore
		current = WScript.Arguments.Item(index)
		ignore = False
		
		If Mid(current, 1,1) = "-" Then
			
			If Len(current) = 2 Then
				Select Case Mid(current, 2,1)
					
					Case "e", "l"
						ignore = True
						
					Case "-"
						If objFso.FileExists(current) Then
							Set file = objFso.GetFile(current)
						End If
						Exit Do
						
					Case Else
						ignore = False
						
				End Select
			ElseIf Len(current) = 1 Then
				
				Exit For
				
			End If
			
		ElseIf objFso.FileExists(current) Then
			Set file = objFso.GetFile(current)
			Exit Do
		End If
		
		Exit Do
	Loop
	ignore = False
	
Next



Dim line

If VarType(file) <> vbEmpty Then
	Dim stream
	
	If file.Size < 1 Then
		DefaultVersion
	End If
	
	Set stream = file.OpenAsTextStream(1)
	line = stream.ReadLine
	stream.Close
	
	If Mid(line, 1,9) <> "#!by lua " And Mid(line, 1,10) <> "#!by luac " Then
		DefaultVersion
	End If
	If Mid(line, 9,1) = " " Then
		line = Mid(line, 10)
	Else
		line = Mid(line, 11)
	End If
	
	validLength = ValidNameLength(line)
	If validLength > 0 Then
		line = Mid(line, 1,validLength)
	Else
		line = ""
	End If
	
	If IsValidName(line) Then
		WScript.Echo line
		WScript.Quit(0)
	End If
End If

DefaultVersion
