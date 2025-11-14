; --- Directives ---
#Warn
#SingleInstance Force
#Requires AutoHotkey v2.0+
SetWorkingDir A_ScriptDir

; --- Script Body ---
FileCount := 0
Hotstring("Case") ; Global options: Case sensitive ; Global options: Case sensitive
Global MyTriggers := []

Loop Files, "commands\*.md", "R"
{
    ; Get the full path for the function to read
    ; (e.g., C:\My Script\commands\example.md)
    FullFilePath := A_LoopFileFullPath

    ; Get the filename without extension for the trigger
    ; A_LoopFileName is just "example.md"
    SplitPath(A_LoopFileName, , , , &FileNameNoExt)

    ; Validate the filename to ensure it only contains safe characters
    if !RegExMatch(FileNameNoExt, "^[a-zA-Z0-9_-]+$")
    {
        MsgBox('The command file "' . A_LoopFileName . '" has an invalid name.'
            . '`n`nFilenames can only contain letters, numbers, hyphens (-), and underscores (_).'
            . '`n`nThis file will be skipped.',
            "Invalid Command Name", 48)
        continue ; Skip to the next file
    }

    FileCount++ ; Increment count only for valid files
    Trigger := ":*:" . "/" . FileNameNoExt

    MyTriggers.Push(Trigger)

    Hotstring(Trigger, RunCommand.Bind(FullFilePath))
}

; --- Check for FileCount (Unchanged) ---
if (FileCount = 0)
{
    MsgBox("No command files (.md) were found in the 'commands' subfolder."
        . "`n`nPlease check the README.md file for setup instructions.",
        "No Commands Loaded", 48)
}
else
{
    MsgBox(FileCount . " dynamic hotstrings created from .md files.", "Dynamic Hotstrings", 64)
}

; 1. Add tray menu items for easy control
A_TrayMenu.Add("&List My Triggers", (*) => ShowMyTriggers())
A_TrayMenu.Add("&Reload Script", (*) => Reload())
A_TrayMenu.Add("E&xit Script", (*) => ExitApp())

; 2. Add a hotkey to pop up the list
; Press Ctrl+Alt+H to see the list
^!h:: ShowMyTriggers()

return ; End of auto-execute section

ShowMyTriggers() { ; <--- 4. MODIFY THIS: This function is new

    ; 1. Build the list of dynamic triggers from our array
    Local TriggerList := ""
    if (MyTriggers.Length > 0)
    {
        TriggerList := "Dynamically Created Hotstrings:`n`n"
        For Index, sTrigger in MyTriggers
        {
            TriggerList .= Index . ": " . sTrigger . "`n"
        }
    }
    else
    {
        TriggerList := "No dynamic hotstrings were found in the array."
    }

    ; 2. Show our custom list
    MsgBox(TriggerList, "Dynamic Triggers List", 64)

    ; 3. Show the static list (which should now include /hw)
    ListHotkeys()
}

ReloadScript() {
    Reload()
}

ExitScript() {
    ExitApp()
}

; -------------------------------------------
; The Core Function: Reads File, Prompts User, Replaces, and Sends Text
; -------------------------------------------

; --- THIS IS THE FIX ---
; Added ', *' to the function definition.
; 'FilePath' will receive the first parameter (the one you .Bind-ed).
; '*' will accept all (any) other parameters, such as the
; trigger name that the Hotstring() function sends by default.
RunCommand(FilePath, *)
{
    ; We can remove the initial MsgBox now
    ; MsgBox("RunCommand was called!`nFile path is: " . FilePath)

    ; 1. Read the file (Unchanged)
    Try
    {
        TextContent := FileRead(FilePath, "UTF-8")
    }
    Catch
    {
        MsgBox("Error: Could not read file: " . FilePath, "File Error", 16)
        return
    }

    ; --- THIS IS THE FIX ---
    ; Assign TextContent to NewText first
    NewText := TextContent

    ; 2. Check if the file was empty (or only whitespace)
    if (Trim(NewText) == "")
    {
        ; Set the output text to the error message
        NewText := "<<Prompt file is empty.>>"
    }
    else
    {
        ; 3. --- REFINED REGEX SECTION ---
        ; This whole section now only runs if the file was NOT empty.
        
        PromptRegex := "s)\{\{(.*?)\}\}"
        MatchPos := 1

        Loop
        {
            if !RegExMatch(NewText, PromptRegex, &Match, MatchPos)
                break ; No more prompts found

            PromptQuestion := Trim(Match[1])

            ; Get user input
            UserInput := InputBox(PromptQuestion, "Input Required")

            if !UserInput.Value ; User pressed Cancel
            {
                MsgBox("Operation cancelled by user.", "Cancelled", 48)
                return
            }

            ; Replace the prompt with the user's answer
            NewText := RegExReplace(NewText, PromptRegex, UserInput.Value,, 1, MatchPos)

            ; Update MatchPos to start searching *after* the text we just inserted
            MatchPos := Match.Pos(0) + StrLen(UserInput.Value)
        }
    }

    ; Copy to clipboard and paste 
    OriginalClipboard := ClipboardAll()
    A_Clipboard := NewText
    If ClipWait(0.5)
        Send "^v"
        Sleep 300
    A_Clipboard := OriginalClipboard
    OriginalClipboard := ""

}