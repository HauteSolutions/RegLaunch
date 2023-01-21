#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutMapster:  Digital Intelligence Map-O-Matic

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>

#RequireAdmin

Global $Title = "RegLaunch"
Global $Version="v1.00"
Global $ProgTitle=$Title & " " & $Version

Global $IniFile
Global $Launch=""

; Ensure we are running as Administrator (Alternate Admin Method vs #RequireAdmin compiler directive above)
;If Not IsAdmin() Then
;	ShellExecute(@AutoItExe, "", "", "runas")
;	ProcessClose(@AutoItPID)
;EndIf

; Ensure Master Script Directory is Set As Working Dir
FileChangeDir(@ScriptDir)

; Determine Local INI Config file name based on Name of the Script
$IniFile = StringTrimRight(@ScriptFullPath,4) & ".ini"

; Get Configuration Info
GetConfig()

; Apply the desired Registry Modifications BEFORE starting...
ProcessSections("Start")

; Start the Desired Process
If Not FileExists($Launch) Then ErrorHandler("File Does Not Exist: " & $Launch, 2)
Local $RetCode=ShellExecuteWait($Launch)

; Apply the desired Registry Modifications AFTER termination...
ProcessSections("End")

Exit

;--------------------------------------------------------------------------------------------------

Func GetConfig()
	If FileExists($IniFile) then
		$Launch = IniRead($IniFile, "Config", "Launch", $Launch)
	Else
		ErrorHandler("Config File (" & $IniFile & ") Not Found!", 1)
	EndIf
EndFunc

Func ProcessSections($Event)

	Local $SectionNames = IniReadSectionNames($IniFile)
	If @error Then
		MsgBox(4096, "", "Error occurred, probably no INI file.")
	Else

		$j = 0
		For $i = 1 To $SectionNames[0]
			if $SectionNames[$i] = "Config" then ContinueLoop

			Local $Section  = $SectionNames[$i]

			Local $Function = IniRead($IniFile, $Section, "Function", "")
			Local $Key      = IniRead($IniFile, $Section, "Key",      "")
			Local $Value    = IniRead($IniFile, $Section, "Value",    "")
			Local $Type     = IniRead($IniFile, $Section, "Type",     "")
			Local $Data     = IniRead($IniFile, $Section, "Data",     "")
			Local $UnSet    = IniRead($IniFile, $Section, "UnSet",    "")
			Local $Force64  = IniRead($IniFile, $Section, "Force64",  "N")

			CheckParameters($Function, $Key, $Value, $Type, $Data, $UnSet, $Force64)

			If $Force64 = "Y" Then $Key = Make64Key($Key)

			If $Event = "Start" Then
				If RegWrite($Key, $Value, $Type, $Data) = 0 Then
					ErrorHandler("Writing Registry Key (Code " & @error & ")", 20)
				EndIf
				Return
			EndIf

			; EVENT = "End"
			If $Function = "Create" Then
				If RegDelete($Key, $Value) = 2 Then
					ErrorHandler("Deleting Registry Key (Code " & @error & ")", 21)
				EndIf
			Else
				If RegWrite($Key, $Value, $Type, $Unset) = 0 Then
					ErrorHandler("Writing Registry Key (Code " & @error & ")", 22)
				EndIf
			EndIf

		Next

	EndIf

EndFunc

Func CheckParameters($Function, $Key, $Value, $Type, $Data, $UnSet, $Force64)

	Switch $Function
		Case "Create"
		Case "Set"
		Case Else
			ErrorHandler("FUNCTION must be specified as either CREATE or SET", 10)
	EndSwitch

	If $KEY = "" Then ErrorHandler("Registry KEY must be specified", 11)

	If $Value = "" Then ErrorHandler("Registry VALUE must be specified", 12)

	Switch $Type
		Case "REG_SZ"
		Case "REG_MULTI_SZ"
		Case "REG_EXPAND_SZ"
		Case "REG_DWORD"
		Case "REG_QWORD"
		Case "REG_BINARY"
		Case Else
			ErrorHandler("Valid data TYPE must be: REG_SZ, REG_BINARY, REG_MULTI_SZ, REG_EXPAND_SZ, REG_QWORD, or REG_DWORD", 13)
	EndSwitch

	If $Data = "" Then ErrorHandler("Registry DATA must be specified", 14)

	If $Function = "Set" And $Unset = "" Then  ErrorHandler("Registry UNSET value must be specified if using the SET function", 15)

	Switch $Force64
		Case "Y"
		Case "N"
		Case Else
			ErrorHandler("FORCE64 Parameter may only be specified as Y or N", 16)
	EndSwitch

EndFunc

Func Make64Key($KeyName)

	If @OSArch = "X86" Then Return $KeyName								; There is no WOW6432 node to worry about

	If (NOT StringTrimLeft($KeyName,5) = "HKLM\") And (NOT StringTrimLeft($KeyName,19) = "HKEY_LOCAL_MACHINE\") Then
		Return $KeyName													; Not an HKLM Entry
	EndIf

	$SlashPos=StringInStr($KeyName,"\")
	If $SlashPos=0 Then Return $KeyName

	$Branch=StringLeft($KeyName, $SlashPos-1)
	$RestOfKey=StringTrimLeft($Keyname, $SlashPos-1)

	If StringRight($Branch,2) = "64" Then Return $KeyName

	$NewKey = $Branch & "64" & $RestOfKey

	Return $NewKey
EndFunc

Func ErrorHandler($Msg, $Code)
	MsgBox($MB_ICONERROR, $ProgTitle, "Error (" & $Code & "): " & $Msg)
	Exit ($Code)
EndFunc
