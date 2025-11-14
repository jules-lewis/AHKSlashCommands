# AHKSlashCommands

AHKSlashCommands is a simple but powerful tool that lets you create your own custom "slash commands" that work in any application on Windows. It's perfect for building a personal library of reusable prompts for AI chat models like Gemini or ChatGPT, but it's flexible enough for any text you use frequently.

Whether you're drafting AI prompts, answering emails, filling out bug reports, or writing journal entries, AHKSlashCommands streamlines your workflow. Just type your command (e.g., `/translate`), fill in any dynamic parts, and the complete text is pasted for you instantly.

This AutoHotkey v2 script dynamically creates these commands from simple Markdown (`.md`) files you create in a `📁commands` folder.

When you type a Hotstring (derived from the filename), the script reads the corresponding file, prompts you for input to fill in any placeholders, and then pastes the completed text into your active window.

## Features

- **Dynamic Hotstrings:** Automatically creates Hotstrings from all `.md` files found in the `/commands` folder on startup.

- **Interactive Prompts:** Uses a simple {{question}} syntax to get user input for variable-driven templates.

- **Clipboard Safe:** Your system clipboard is preserved. The script uses it temporarily but restores its original content immediately after pasting.

- **Simple to Use:** Create a new command simply by adding a new .md file to the commands folder, and reloading the script. The script adds hot reloading to its system tray menu.

## Requirements

AutoHotkey v2.0 or later.

## Installation

1. Download `ahk_slash_commands.ahk` to a folder on your Windows

2. Create a subfolder called `commands` and start adding prompts as markdown files. Whatever you use before `.md` becomes the Hotstring. For example, a markdown file named `translate.md` generates the Hotstring `/translate`. (*For this reason a prompt file can't contain any spaces or special characters.*)

3. 






Your file structure should look like this:

MyScriptFolder/
│
├── Paster.ahk      (The main script)
│
└── commands/
    ├── email.md
    ├── bug_report.md
    └── ... (your other templates)
Run Paster.ahk. If no commands are found, it will notify you.

How to Use
Make sure the script is running.

Find a file in your commands folder (e.g., email.md).

The Hotstring for this file will be the filename, prefixed with a /.

email.md becomes /email

bug_report.md becomes /bug_report

Type the Hotstring (e.g., /email) in any text editor, email client, or browser window.

If the email.md file contains any prompts (like {{Subject}}), an input box will appear asking for that information.

Fill in the prompts one by one and press OK.

The completed text will be pasted for you.

How to Create New Commands
Navigate to your commands folder.

Create a new text file and save it with a .md extension (e.g., meeting.md).

The filename (meeting) automatically creates the Hotstring (/meeting).

Write your template inside the file.

Wherever you need user input, use the double-curly-brace format: {{Your Question Here}}.

Example meeting.md file:
Markdown

### Meeting Follow-up

Hello {{Contact Name}},

Just following up on our meeting today about {{Topic}}.

I've attached the notes and will action the following points:
- {{Action Point 1}}
- {{Action Point 2}}

Best,
Jules
When you type /meeting, you will be prompted for:

Contact Name

Topic

Action Point 1

Action Point 2

Note: The script scans for files on startup. If you add a new command, you must reload the script (e.g., by double-clicking it again, or via its tray icon) for the new Hotstring to become active.

## TODO

- [ ] **Improve Startup Notification:** Replace the initial `MsgBox` that shows the command count with a less intrusive notification.
- [ ] **System Tray Command Count:** Add a non-clickable menu item to the system tray menu that displays the number of currently loaded commands (e.g., "Commands Loaded: 5"). This item should update when the script is reloaded.
- [ ] **Code Refactoring:**
    - [ ] Create a dedicated `LoadCommands()` function to encapsulate the logic for finding `.md` files, creating hotstrings, and updating the tray menu count.
    - [ ] Create a `SetupTrayMenu()` function to initialize the tray menu items cleanly.
    - [ ] Ensure the "Reload" tray menu option calls the `LoadCommands()` function to refresh the hotstrings and the command count.