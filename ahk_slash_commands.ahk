; --- Directives ---
#Warn
#SingleInstance Force
#Requires AutoHotkey v2.0+
SetWorkingDir A_ScriptDir

; --- Main Body ---
file_count := 0
Hotstring("Case") ; Global options: Case sensitive 
command_list := []

Loop Files, "commands\*.md", "R"
{
    ; Get the full path for the function to read
    ; (e.g., C:\My Script\commands\example.md)
    full_file_path := A_LoopFileFullPath

    ; Get the filename without extension for the trigger
    ; A_LoopFileName is just "example.md"
    SplitPath(A_LoopFileName, , , , &file_name_no_ext)

    ; Validate the filename to ensure it only contains safe characters
    if !RegExMatch(file_name_no_ext, "^[a-zA-Z0-9_-]+$")
    {
        MsgBox('The command file "' . A_LoopFileName . '" has an invalid name.'
            . '`n`nFilenames can only contain letters, numbers, hyphens (-), and underscores (_).'
            . '`n`nThis file will be skipped.',
            "Invalid Command Name", 48)
        continue ; Skip to the next file
    }

    file_count++ ; Increment count only for valid files
    trigger := ":*:" . "/" . file_name_no_ext

    command_list.Push("/" . file_name_no_ext)

    Hotstring(trigger, RunCommand.Bind(full_file_path))
}

; --- Setup Tray Menu with Command Status ---
if (file_count = 0)
{
    MsgBox("No command files (.md) were found in the 'commands' subfolder."
        . "`n`nPlease check the README.md file for setup instructions.",
        "No Commands Loaded", 48)
    A_TrayMenu.Add() ; Separator
    status_text := "No commands found. Check the README.md file for setup instructions."
    A_TrayMenu.Add(status_text, (*) => 0)
    A_TrayMenu.Disable(status_text)
}
else
{
    status_text := file_count . " command(s) loaded:"
    A_TrayMenu.Add() ; Separator
    A_TrayMenu.Add(status_text, (*) => 0)
    A_TrayMenu.Disable(status_text)

    For Index, command in command_list
    
    {
        A_TrayMenu.Add(command, (*) => 0)
        A_TrayMenu.Disable(command)
    }
}

return 

; --- Main Body - END ---



; -------------------------------------------
; The Core Function: Reads File, Prompts User, Replaces, and Sends Text
; -------------------------------------------

; 'file_path' will receive the first parameter, the full filename.
; '*' will accept all (any) other parameters, such as the
; trigger name that the Hotstring() function sends by default.
RunCommand(file_path, *)
{
    ; Read the file
    Try
    {
        file_content := FileRead(file_path, "UTF-8")
    }
    Catch
    {
        MsgBox("Error: Could not read file: " . file_path, "File Error", 16)
        return
    }

    ; Check if the file was empty (or only whitespace)
    if (Trim(file_content) == "")
    {
        ; Set the output text to the error message
        file_content := "<<Prompt file is empty.>>"
    }
    else
    {
        ; REGEX to find prompts
        PromptRegex := "s)\{\{(.*?)\}\}"
        MatchPos := 1

        Loop
        {
            if !RegExMatch(file_content, PromptRegex, &Match, MatchPos)
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
            file_content := RegExReplace(file_content, PromptRegex, UserInput.Value,, 1, MatchPos)

            ; Update MatchPos to start searching *after* the text we just inserted
            MatchPos := Match.Pos(0) + StrLen(UserInput.Value)
        }
    }

    ; Copy to clipboard and paste 
    OriginalClipboard := ClipboardAll()
    A_Clipboard := file_content
    If ClipWait(0.5)
        Send "^v"
        Sleep 300
    A_Clipboard := OriginalClipboard
    OriginalClipboard := ""

}