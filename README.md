# AHKSlashCommands
Slash Commands via AutoHotkey

Dynamic Text Paster (AutoHotkey v2)
This AutoHotkey v2 script dynamically creates hotstrings from Markdown (.md) files located in a commands subfolder.

When you type a hotstring (derived from the filename), the script reads the corresponding file, prompts you for input to fill in any placeholders, and then pastes the completed text into your active window.

Features
Dynamic Hotstrings: Automatically creates hotstrings from all .md files found in the commands folder on startup.

Interactive Prompts: Uses a simple {{question}} syntax to get user input for variable-driven templates.

Clipboard Safe: Your system clipboard is preserved. The script uses it temporarily but restores its original content immediately after pasting.

Simple to Use: Create a new command simply by adding a new .md file to the commands folder.

Requirements
AutoHotkey v2.0 or newer.

Setup
Ensure you have AutoHotkey v2 installed.

Place the script (e.g., Paster.ahk) in a folder.

In that same folder, create a subfolder named exactly commands.

Place your text templates as .md files inside the commands folder.

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

The hotstring for this file will be the filename, prefixed with a /.

email.md becomes /email

bug_report.md becomes /bug_report

Type the hotstring (e.g., /email) in any text editor, email client, or browser window.

If the email.md file contains any prompts (like {{Subject}}), an input box will appear asking for that information.

Fill in the prompts one by one and press OK.

The completed text will be pasted for you.

How to Create New Commands
Navigate to your commands folder.

Create a new text file and save it with a .md extension (e.g., meeting.md).

The filename (meeting) automatically creates the hotstring (/meeting).

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

Note: The script scans for files on startup. If you add a new command, you must reload the script (e.g., by double-clicking it again, or via its tray icon) for the new hotstring to become active.