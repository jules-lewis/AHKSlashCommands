# AHKSlashCommands

`AHKSlashCommands` is a simple but powerful tool that lets you create your own custom "slash commands" that work in any application on Windows. It's perfect for building a personal library of reusable prompts for AI chat models like Gemini or ChatGPT, but it's flexible enough for any text you use frequently.

Just type your command (e.g., `/translate`), fill in any dynamic parts, and the completed text is pasted to your context. The commands are dynamically created from simple Markdown (`.md`) files you create in a `📁commands` subfolder.


## Features

- **Dynamic Hotstrings:** Automatically creates Hotstrings from all `.md` files found in the `/commands` folder on startup.

- **Interactive Prompts:** Uses a simple {{question}} syntax to get user input for variable-driven templates.

- **Clipboard Safe:** Your system clipboard is preserved. The script uses it temporarily but restores its original content immediately after pasting.

- **Easy to Use:** Create a new command simply by adding a new `.md` file to the `📁commands` folder, and reloading the script. The script adds hot reloading to its system tray menu.


## Requirements

AutoHotkey v2.0 or later — install [here](https://www.autohotkey.com/v2/).


## Installation

1. Download `ahk_slash_commands.ahk` to a folder on your Windows device

2. Create a subfolder called `commands` and start adding prompts as markdown files. (You can start with the examples in this repo if you want.) Whatever you use before `.md` becomes the Hotstring. For example, a markdown file named `translate.md` generates the Hotstring `/translate`. (*For this reason a prompt file can't contain any spaces or special characters.*)

3. Run or reload the script.


## Usage

Your markdown files should look something like this:

**`translate.md`**

```markdown
Translate the following text into {{Enter target language.}}: 
{{Enter text to translate.}}
```

When you you reload the script, you will now have a slash command that is triggered every time you type `/translate` in an editable field (e.g. a chat box). You will be prompted with any question contained between the double braces `{{` and `}}`. As you can see, you can have multiple prompts (and none if you wish).


## To Do

There are a couple of features I plan to add in the short term, but wanted to get out an MVP for now:

- [ ] **Improve Startup/Reload Notification:** Replace the initial `MsgBox` that shows the command count with a less intrusive notification.
- [ ] **System Tray Command Count:** Add a non-clickable menu item to the system tray menu that displays the number of currently loaded commands (e.g., "Commands loaded: 5"). This item should update when the script is reloaded.
- [ ] **Descriptions:** Add a description for the command, maybe in front-matter?
- [ ] **Code Refactoring:**
    - [ ] Create a dedicated `LoadCommands()` function to encapsulate the logic for finding `.md` files, creating hotstrings, and updating the tray menu count.
    - [ ] Create a `SetupTrayMenu()` function to initialize the tray menu items cleanly.
    - [ ] Ensure the "Reload" tray menu option calls the `LoadCommands()` function to refresh the hotstrings and the command count.