; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; audiosetter.ahk
; Sets the default audio device when launched
; 
; Dependencies:
;   - nircmd
;   - 7zip (to extract nircmd if needed)
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MIT License
; 
; Copyright (C) 2018 Raphael "rGunti" Guntersweiler
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;; Script Properties BEGIN ;;;
AppName := "Default Audio Setter"
AppVersion := "0.1"
AppAuthor := "rGunti"
AppLicense := "MIT"
; ;;;; Script Properties END ;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%
CurrentDir := A_ScriptDir

IniPath := CurrentDir . "/audio.ini"
NircmdPath := CurrentDir . "/nircmd.exe"
SevenZip := CurrentDir . "/7za.exe"

; ; ZIP Code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Unzip(zipFile, dst, sevenZipExec="") {
	global SevenZip
	if !sevenZipExec
		sevenZipExec := SevenZip
	RunWait, `"%sevenZipExec%`" x `"%zipFile%`" -o`"%dst%`"
}

UnzipFile(zipFile, dst, file, sevenZipExec="") {
	global SevenZip
	if !sevenZipExec
		sevenZipExec := SevenZip
	RunWait, `"%sevenZipExec%`" x `"%zipFile%`" -o`"%dst%`" `"%file%`"
}

; ; Resource Installation ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DownloadNircmd(Dst) {
	; Download nircmd
	UrlDownloadToFile, http://www.nirsoft.net/utils/nircmd.zip, %Dst%/nircmd.zip

	Sleep, 500
	; Unzip nircmd.exe from zip
	UnzipFile(Dst . "/nircmd.zip", Dst, "nircmd.exe")
	
	Sleep, 500
	; Delete zip
	FileDelete, %Dst%/nircmd.zip
}

Download7zip(Dst) {
	; Download 7zr (7z only), then download 7zip standalone package
	UrlDownloadToFile, https://www.7-zip.org/a/7zr.exe, %Dst%/7zr.exe
	UrlDownloadToFile, https://www.7-zip.org/a/7z1801-extra.7z, %Dst%/7zip.7z

	Sleep, 500
	; Unzip 7za.exe and 7za.dll from 7zip package
	UnzipFile(Dst . "/7zip.7z", Dst, "7za.exe", Dst . "/7zr.exe")
	UnzipFile(Dst . "/7zip.7z", Dst, "7za.dll", Dst . "/7zr.exe")

	Sleep, 500
	; Delete 7zr and 7zip.7z
	FileDelete, %Dst%/7zr.exe
	FileDelete, %Dst%/7zip.7z
}

Cleanup7zip(Dst) {
	; Deletes remaining 7zip files
	FileDelete, %Dst%/7za.exe
	FileDelete, %Dst%/7za.dll
}

; ; Audio Code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetDefaultAudioDevice(audioDevice, showMessageBox=True) {
	global NircmdPath
	if audioDevice {
		if showMessageBox
			MsgBox, Setting default audio device to `"%audioDevice%`"
		
		Run, `"%NircmdPath%`" setdefaultsounddevice `"%audioDevice%`"
		Run, `"%NircmdPath%`" setdefaultsounddevice `"%audioDevice%`" 2
	} else {
		MsgBox, No Audio Device has been defined. Set default audio device in audio.ini
	}
}

GetDefaultAudioDeviceFromIni(iniPath) {
	IniRead, IniSet_SoundDevice, %iniPath%, DefaultAudioDevice, Name, 
	return IniSet_SoundDevice
}

GetShowMessageBoxSetting(iniPath) {
	IniRead, IniSet_ShowMessageBox, %iniPath%, DefaultAudioDevice, ShowMessageBox, 0
	return IniSet_ShowMessageBox
}

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !FileExist(NircmdPath) {
	MsgBox, Nircmd could not be found. We're downloading it for you...
	
	if !FileExist(SevenZip) {
		ToolTip, Downloading 7zip...
		Download7zip(CurrentDir)
	}
	
	ToolTip, Downloading Nircmd...
	DownloadNircmd(CurrentDir)
	
	if FileExist(CurrentDir) {
		ToolTip, Cleaning up 7zip...
		Cleanup7zip(CurrentDir)
	}
	
	ToolTip
}

if !FileExist(IniPath) {
	IniWrite, Insert audio device name here, %IniPath%, DefaultAudioDevice, Name
	IniWrite, 0, %IniPath%, DefaultAudioDevice, ShowMessageBox
	
	MsgBox, An audio.ini has been created to help you configure this script. Configure it and restart the script.
	ExitApp
}

SetDefaultAudioDevice(GetDefaultAudioDeviceFromIni(IniPath), GetShowMessageBoxSetting(IniPath) = 1)
