; --- Directives ---
#Warn
#SingleInstance Force
#Requires AutoHotkey v2.0+
SetWorkingDir A_ScriptDir

; --- Script Body ---
FileCount := 0
Hotstring("::", "C") ; Global options: Case sensitive

Loop, Files, "*.md", "R"
{
    FileCount++
    
    FileNameFull := A_LoopFileName
    SplitPath(FileNameFull, &FileNameNoExt) ; v2 way to get parts
    
    Trigger := "/" . FileNameNoExt
    
    ; Bind the full file name to the RunCommand function
    Hotstring(Trigger, RunCommand.Bind(FileNameFull), "O")
}

MsgBox(FileCount . " dynamic hotstrings created from .md files.", "Dynamic Hotstrings", 64)
MsgBox("Try typing one of your hotstrings.", "Dynamic Hotstrings", 64)
return


; -------------------------------------------
; The Core Function: Reads File, Prompts User, Replaces, and Sends Text
; -------------------------------------------

RunCommand(FilePath)
{
    ; 1. Read the file
    Try
    {
        TextContent := FileRead(FilePath, "UTF-8")
    }
    Catch
    {
        MsgBox("Error: Could not read file: " . FilePath, "File Error", 16)
        return
    }

    ; 2. Define the Regex and find prompts
    PromptRegex := "\{\{([^\}]+)\}\}"
    NewText := TextContent
    MatchPos := 1
    
    Loop
    {
        ; Find the next match
        if !RegExMatch(NewText, PromptRegex, &Match, MatchPos)
        {
            ; No more prompts found, exit the loop
            break
        }
        
        ; Match[1] contains the prompt question
        PromptQuestion := Trim(Match[1])
        
        ; 3. Get user input
        UserInput := InputBox(PromptQuestion, "Input Required")
        
        if !UserInput.Value ; User pressed Cancel
        {
            MsgBox("Operation cancelled by user.", "Cancelled", 48)
            return
        }
        
        ; 4. Replace the prompt with the user's answer
        NewText := RegExReplace(NewText, PromptRegex, UserInput.Value,, 1, MatchPos)
    }

    ; 5. Copy to clipboard and paste
    OriginalClipboard := A_ClipboardAll()
    A_Clipboard := NewText
    
    if !ClipWait(2) ; Wait up to 2 seconds
    {
        MsgBox("Error: Failed to copy text to clipboard.", "Clipboard Error", 16)
        return
    }
    
    SendInput("^v") ; Send the paste command
    
    ; Restore original clipboard
    Sleep(100)
    A_Clipboard := OriginalClipboard
}