#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;; Force this script to only allow one instance of itself to run at a time. If you run it twice, it will override the existing instance:
#SingleInstance, Force  



GLOBAL ConfigFile := "Potshots.cfg"  ;;;; Sets the name of the cfg file that houses the script's customization settings later on below

GLOBAL ConfigFileLocation := A_ScriptDir . "\"   ;;;; Sets the location (folder) of the script's cfg file (A_ScriptDir just defaults to the folder your script is currently in)

GLOBAL ConfigFileCombined := ConfigFileLocation . ConfigFile  ;;;; Combine the two above lines together to make "ConfigFileCombined" point directly at the script's cfg file.



    If FileExist(ConfigFileCombined)  ;;;; Check to see if the script's config file exists
    {
        ;;;; Yay the config file already exists if it executed this part inbetween these braces!
        ;;;; Now we will read the current settings of all of the options inside of the config file since it already exists:
        RefreshCfgSettingsFunction()
    }
     Else  ;;;; We ONLY EVER hit the "Else" section HERE if the config file did NOT exist at the specified location. OTHERWISE, IT SKIPS OVER THIS PART
        {
            ;;;; Okay so the config file did not exist, let's create a fresh one at the current location your script is at by calling one of the function at the bottom of the script:
            BuildCfgFileFunction()
        }


Menu, Tray, NoStandard
Menu, Tray, Add, Configure Script Settings, TrayButton_ConfigureSettings  ;;;;; Creates a new menu item.
Menu, Tray, Add  ;;;;; Creates a new line separator between the above and below buttons in the tray menu
Menu, Tray, Add, Refresh Settings From Cfg, TrayButton_RefreshSettingsCfgChanges  ;;;;; Creates a new menu item.
Menu, Tray, Add  ;;;;; Creates a new line separator between the above and below buttons in the tray menu
Menu, Tray, Add, Reset Cfg To Defaults, TrayButton_ResetToDefaults  ;;;;; Creates a new menu item.
Menu, Tray, Add  ;;;;; Creates a new line separator between the above and below buttons in the tray menu
Menu, Tray, Add, Exit, TrayButton_Exit  ;;;;; Creates a new menu item.
Return




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                                               ;;;; 
;;;;                WEAPON FIRING EVENTS ARE BELOW                 ;;;; 
;;;;                                                               ;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RapidFireEvent:
; RefreshCfgSettingsFunction()
	While ( GetKeyState(RapidFireKeySetting,"P") ) {

		Click

		Sleep, 90

	}

Return

BurstFireEvent:
; RefreshCfgSettingsFunction()
	While ( GetKeyState(BurstFireKeySetting,"P" ) ) {

		Click

		Sleep, %BurstFireSpeed%

	}

Return




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                                               ;;;; 
;;;;          TRAY RIGHT CLICK MENU BUTTON EVENTS ARE BELOW        ;;;; 
;;;;                                                               ;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TrayButton_ConfigureSettings:
Run, notepad.exe %ConfigFileCombined%
Return


TrayButton_RefreshSettingsCfgChanges:
RefreshCfgSettingsFunction()
Return



TrayButton_ResetToDefaults:
ResetAllCfgSettingsFunction()
Return


TrayButton_Exit:
ExitApp




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                                               ;;;; 
;;;;       CONFIG FILE BUILDING AND READING FUNCTIONS BELOW        ;;;; 
;;;;                                                               ;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BuildCfgFileFunction()
{
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;;; Okay so the config file did not exist, let's create a fresh one at the current location your script is at:
    FileAppend,, %ConfigFileCombined%
    ;;;; Now we will write all of the settings to this new config file, with their default values.
    ;;; CREATE THE 'RapidFireHotkey' SETTING IN THE CFG FILE UNDER THE [HOTKEYS] SECTION, SET ITS DEFAULT VALUE TO THE SIDE MOUSE FORWARD BUTTON.
    IniWrite, Xbutton2, %ConfigFileCombined%, HOTKEYS, RapidFireHotkey
    ;;; CREATE THE 'BurstFireHotkey' SETTING IN THE CFG FILE UNDER THE [HOTKEYS] SECTION, SET ITS DEFAULT VALUE TO THE SIDE MOUSE BACK BUTTON.
    IniWrite, Xbutton1, %ConfigFileCombined%, HOTKEYS, BurstFireHotkey
    ;;; CREATE THE 'ExitScriptHotkey' SETTING IN THE CFG FILE UNDER THE [HOTKEYS] SECTION, SET ITS DEFAULT VALUE TO F8.
    IniWrite, F8, %ConfigFileCombined%, HOTKEYS, ExitScriptHotkey
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ; ;;; CREATE THE 'RapidFireSpeed' SETTING IN THE CFG FILE UNDER THE [GUNFIRE_SPEEDS] SECTION, SET ITS DEFAULT VALUE TO 80 miliseconds (1000 miliseconds = 1 second).
    ; IniWrite, 23, %ConfigFileCombined%, GUNFIRE_SPEEDS, RapidFireSpeed
    ;;; CREATE THE 'BurstFireSpeed' SETTING IN THE CFG FILE UNDER THE [GUNFIRE_SPEEDS] SECTION, SET ITS DEFAULT VALUE TO 100 miliseconds (1000 miliseconds = 1 second).
    IniWrite, 130, %ConfigFileCombined%, GUNFIRE_SPEEDS, BurstFireSpeed
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; NOW WE READ ALL OF THESE NEWLY WRITTEN DEFAULT SETTINGS INTO STRING WE CAN POINT AT THE EXECUTION LOGIC BELOW:
    IniRead, aRapidFireKeySetting, %ConfigFileCombined%, HOTKEYS, RapidFireHotkey
    GLOBAL RapidFireKeySetting := aRapidFireKeySetting
    IniRead, aBurstFireKeySetting, %ConfigFileCombined%, HOTKEYS, BurstFireHotkey
    GLOBAL BurstFireKeySetting := aBurstFireKeySetting
    IniRead, aExitScriptKeySetting, %ConfigFileCombined%, HOTKEYS, ExitScriptHotkey
    GLOBAL ExitScriptKeySetting := aExitScriptKeySetting
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ; IniRead, aRapidFireSpeed, %ConfigFileCombined%, GUNFIRE_SPEEDS, RapidFireSpeed
    ; GLOBAL RapidFireSpeed := aRapidFireKeySetting
    IniRead, aBurstFireSpeed, %ConfigFileCombined%, GUNFIRE_SPEEDS, BurstFireSpeed
    GLOBAL BurstFireSpeed := aBurstFireSpeed
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    Hotkey, $%RapidFireKeySetting%, RapidFireEvent, On
    Hotkey, $%BurstFireKeySetting%, BurstFireEvent, On
    Hotkey, $%ExitScriptKeySetting%, TrayButton_Exit, On
}


ResetAllCfgSettingsFunction()
{
    FileDelete, %ConfigFileCombined%
    Sleep, 150
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;;; Okay so the config file did not exist, let's create a fresh one at the current location your script is at:
    FileAppend,, %ConfigFileCombined%
    ;;;; Now we will write all of the settings to this new config file, with their default values.
    ;;; CREATE THE 'RapidFireHotkey' SETTING IN THE CFG FILE UNDER THE [HOTKEYS] SECTION, SET ITS DEFAULT VALUE TO THE SIDE MOUSE FORWARD BUTTON.
    IniWrite, Xbutton2, %ConfigFileCombined%, HOTKEYS, RapidFireHotkey
    ;;; CREATE THE 'BurstFireHotkey' SETTING IN THE CFG FILE UNDER THE [HOTKEYS] SECTION, SET ITS DEFAULT VALUE TO THE SIDE MOUSE BACK BUTTON.
    IniWrite, Xbutton1, %ConfigFileCombined%, HOTKEYS, BurstFireHotkey
    ;;; CREATE THE 'ExitScriptHotkey' SETTING IN THE CFG FILE UNDER THE [HOTKEYS] SECTION, SET ITS DEFAULT VALUE TO F8.
    IniWrite, F8, %ConfigFileCombined%, HOTKEYS, ExitScriptHotkey
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ; ;;; CREATE THE 'RapidFireSpeed' SETTING IN THE CFG FILE UNDER THE [GUNFIRE_SPEEDS] SECTION, SET ITS DEFAULT VALUE TO 80 miliseconds (1000 miliseconds = 1 second).
    ; IniWrite, 23, %ConfigFileCombined%, GUNFIRE_SPEEDS, RapidFireSpeed
    ;;; CREATE THE 'BurstFireSpeed' SETTING IN THE CFG FILE UNDER THE [GUNFIRE_SPEEDS] SECTION, SET ITS DEFAULT VALUE TO 100 miliseconds (1000 miliseconds = 1 second).
    IniWrite, 130, %ConfigFileCombined%, GUNFIRE_SPEEDS, BurstFireSpeed
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; NOW WE READ ALL OF THESE NEWLY WRITTEN DEFAULT SETTINGS INTO STRING WE CAN POINT AT THE EXECUTION LOGIC BELOW:
    IniRead, aRapidFireKeySetting, %ConfigFileCombined%, HOTKEYS, RapidFireHotkey
    GLOBAL RapidFireKeySetting := aRapidFireKeySetting
    IniRead, aBurstFireKeySetting, %ConfigFileCombined%, HOTKEYS, BurstFireHotkey
    GLOBAL BurstFireKeySetting := aBurstFireKeySetting
    IniRead, aExitScriptKeySetting, %ConfigFileCombined%, HOTKEYS, ExitScriptHotkey
    GLOBAL ExitScriptKeySetting := aExitScriptKeySetting
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ; IniRead, aRapidFireSpeed, %ConfigFileCombined%, GUNFIRE_SPEEDS, RapidFireSpeed
    ; GLOBAL RapidFireSpeed := aRapidFireKeySetting
    IniRead, aBurstFireSpeed, %ConfigFileCombined%, GUNFIRE_SPEEDS, BurstFireSpeed
    GLOBAL BurstFireSpeed := aBurstFireSpeed
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    Hotkey, $%RapidFireKeySetting%, RapidFireEvent, On
    Hotkey, $%BurstFireKeySetting%, BurstFireEvent, On
    Hotkey, $%ExitScriptKeySetting%, TrayButton_Exit, On
    Return
}


RefreshCfgSettingsFunction()
{
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; NOW WE READ ALL OF THESE NEWLY WRITTEN DEFAULT SETTINGS INTO STRING WE CAN POINT AT THE EXECUTION LOGIC BELOW:
        IniRead, aRapidFireKeySetting, %ConfigFileCombined%, HOTKEYS, RapidFireHotkey
        GLOBAL RapidFireKeySetting := aRapidFireKeySetting
        IniRead, aBurstFireKeySetting, %ConfigFileCombined%, HOTKEYS, BurstFireHotkey
        GLOBAL BurstFireKeySetting := aBurstFireKeySetting
        IniRead, aExitScriptKeySetting, %ConfigFileCombined%, HOTKEYS, ExitScriptHotkey
        GLOBAL ExitScriptKeySetting := aExitScriptKeySetting
        ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
        ; IniRead, aRapidFireSpeed, %ConfigFileCombined%, GUNFIRE_SPEEDS, RapidFireSpeed
        ; GLOBAL RapidFireSpeed := aRapidFireKeySetting
        IniRead, aBurstFireSpeed, %ConfigFileCombined%, GUNFIRE_SPEEDS, BurstFireSpeed
        GLOBAL BurstFireSpeed := aBurstFireSpeed
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    ;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;;;
    Hotkey, $%RapidFireKeySetting%, RapidFireEvent, On
    Hotkey, $%BurstFireKeySetting%, BurstFireEvent, On
    Hotkey, $%ExitScriptKeySetting%, TrayButton_Exit, On
    Return
}



