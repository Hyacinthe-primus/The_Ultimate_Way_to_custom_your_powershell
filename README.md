<div align="center">
<img src="docs/Powershell.png" alt="custom_pwsh" width="110"/>
<h1>The Ultimate Way to Custom Your PowerShell</h1>

**A Linux-inspired PowerShell setup for Windows, themed with [Catppuccin Mocha](https://github.com/catppuccin/catppuccin), powered by [fastfetch](https://github.com/fastfetch-cli/fastfetch), with random ASCII art on every launch.**

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1_%7C_7-%235391FE.svg?style=for-the-badge)](https://github.com/PowerShell/PowerShell)
[![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-%234D4D4D.svg?style=for-the-badge)](https://github.com/microsoft/terminal)
[![Theme](https://img.shields.io/badge/Theme-Catppuccin_Mocha-cba6f7?style=for-the-badge)](https://github.com/catppuccin/catppuccin)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D4?style=for-the-badge)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-a6e3a1?style=for-the-badge)](LICENSE)

[Preview](#preview) | [Install](#installation) | [Commands](#built-in-commands) | [Customize](#customization) | [Troubleshoot](#troubleshooting)

</div>

---

## Features

- **Catppuccin Mocha everywhere**: welcome banner, prompt, command output and terminal color scheme.
- **Rainbow prompt**: each path segment gets its own Mocha color, and your user name is highlighted automatically.
- **Welcome message**: date, time and a random developer quote at every interactive startup.
- **Random ASCII art**: fastfetch shows a random character and a random color palette on each launch (8 palettes: Catppuccin Mocha, Catppuccin Latte, Dracula, Nord, Tokyo Night, Gruvbox, Everforest, Rose Pine).
- **10 built-in commands**: file search, directory bookmarks, weather, hashing, hex dumps and more (see the [command reference](#built-in-commands)).
- **One profile for both shells**: the same file works in Windows PowerShell 5.1 and PowerShell 7. It is pure ASCII, so no encoding tweaks are needed.
- **No PowerShell modules required**: only fastfetch and a Nerd Font.

---

## Preview

![Preview 1](docs/images/preview1.png)

<details>
<summary>More screenshots</summary>

<br/>

![Preview 2](docs/images/preview2.png)
![Preview 3](docs/images/preview3.png)
![Preview 4](docs/images/preview4.png)
![Preview 5](docs/images/preview5.png)

</details>

---

## How it works

```
Windows Terminal (settings.json: Catppuccin Mocha scheme + Nerd Font)
        |
        v
PowerShell profile (welcome message, custom commands, colored prompt)
        |
        v
fastfetch-random.ps1
        |-- picks a random ASCII art file from ~/.config/fastfetch/ascii/
        |-- picks a random color palette from 8 built-in palettes
        '-- runs fastfetch with the base config.jsonc and both choices
```

Everything runs locally at shell startup. There are no background processes and no telemetry. The only network call is made by `weather`, when you run it.

The banner and fastfetch only run in an interactive console. They are skipped when the output is redirected (for example `pwsh -Command ...` called from a script), so they never pollute captured output.

---

## Repository layout

| Path | Purpose |
|------|---------|
| `profile/Microsoft.PowerShell_profile.ps1` | PowerShell profile (Windows PowerShell 5.1 and PowerShell 7) |
| `fastfetch/config.jsonc` | Base fastfetch configuration (modules, padding, colors) |
| `fastfetch/fastfetch-random.ps1` | Launcher that picks a random logo and palette |
| `fastfetch/ascii/` | 24 ASCII art `.txt` files |
| `windows-terminal/settings.json` | Ready-to-use Windows Terminal settings |
| `install.ps1` | Installer (backs up existing files, supports `-WhatIf`) |
| `.github/` | CI that checks syntax, encoding and JSON validity |

---

## Requirements

| Tool | Required | Notes |
|------|----------|-------|
| [PowerShell 7](https://github.com/PowerShell/PowerShell) or Windows PowerShell 5.1 | Yes | One profile covers both |
| [Nerd Font](https://www.nerdfonts.com/) | Yes | JetBrainsMono Nerd Font recommended |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Yes | System info panel |
| [Windows Terminal](https://github.com/microsoft/terminal) | Recommended | Use the included `settings.json` |

---

## Installation

### 1. Install a Nerd Font and fastfetch

```powershell
winget install -e --id DEVCOM.JetBrainsMonoNerdFont
winget install fastfetch
```

fastfetch is also available through `scoop install fastfetch`, `choco install fastfetch`, or the [releases page](https://github.com/fastfetch-cli/fastfetch/releases).

### 2. Get the repository

Clone it, or download it with **Code > Download ZIP** and extract it.

### 3. Run the installer

From the repository folder, run it in **each shell you use** (Windows PowerShell and PowerShell 7 each have their own profile):

```powershell
# Windows PowerShell 5.1
powershell -ExecutionPolicy Bypass -File .\install.ps1

# PowerShell 7
pwsh -ExecutionPolicy Bypass -File .\install.ps1
```

The installer:

- copies the profile to the path stored in `$PROFILE` (this respects OneDrive-redirected Documents folders),
- copies the fastfetch config, launcher and ASCII art to `~/.config/fastfetch/`,
- backs up any existing file that differs as `<name>.bak-<timestamp>` and never deletes anything,
- unblocks the copied files so `RemoteSigned` accepts them.

Preview what it would do without changing anything:

```powershell
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -WhatIf
```

### 4. Apply the Windows Terminal settings

The included `settings.json` provides the Catppuccin Mocha scheme, acrylic transparency and the correct font. The installer can apply it for you (a backup is created first):

```powershell
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -IncludeTerminalSettings
```

Or do it manually: open **Windows Terminal > Settings > Open JSON file**, replace the content with [`windows-terminal/settings.json`](windows-terminal/settings.json) and save.

> [!NOTE]
> The included settings use Windows PowerShell as the default profile. If you prefer PowerShell 7, change it under **Settings > Startup > Default profile**.

### 5. Restart your terminal

You should see the ASCII art, the welcome message and the colored prompt. Type `help` to list every custom command.

### Manual installation

If you prefer not to use the installer:

1. Run `$PROFILE` to see where your profile must live, create it with `New-Item -Path $PROFILE -Type File -Force`, and copy `profile/Microsoft.PowerShell_profile.ps1` over it.
2. Create `~/.config/fastfetch/` (that is, `C:\Users\<you>\.config\fastfetch\`) and copy `fastfetch/config.jsonc` and `fastfetch/fastfetch-random.ps1` into it.
3. Copy the `fastfetch/ascii/` folder into `~/.config/fastfetch/ascii/`.

### Upgrading from an earlier version

Earlier versions shipped a separate PowerShell 5 profile and kept the `.txt` art files directly in `~/.config/fastfetch/`. Run the installer again, then delete the leftovers: `fastfetch-random-ps5.ps1` and the loose `.txt` files in `~/.config/fastfetch/`. The profile and launcher now read the art from the `ascii/` subfolder only.

---

## Built-in commands

Run `help` anytime, or filter with `help <keyword>`. If the keyword matches no custom command, `help` falls back to the standard `Get-Help`.

| Command | Category | Description |
|---------|----------|-------------|
| `ll` | Nav & Files | Detailed listing, including hidden files |
| `touch` | Nav & Files | Create empty files or update their timestamp |
| `mkcd` | Nav & Files | Create a directory and move into it |
| `show` | Nav & Files | File search with size and dates |
| `cdh` | Nav & Files | Directory bookmarks (save, jump, delete) |
| `hex` | Nav & Files | Hex dump of any file |
| `whereis` | Tools | Locate commands and installed apps (registry) |
| `hash` | Tools | SHA256, MD5 or SHA1, copied to the clipboard |
| `weather` | Tools | Current weather and 3-day forecast ([Open-Meteo](https://open-meteo.com)) |
| `help` | Tools | This reference, filterable by keyword |

### `show`: search files

```powershell
show main.py                    # exact file name in the current folder
show main                       # every name containing "main"
show .ps1                       # every .ps1 file in the current folder tree
show -u report.pdf              # search your whole user folder
show -deep ntdll.dll            # search the whole system drive (slow)
show -from "D:\Projects" src    # search from a specific folder
```

A name that contains a dot is matched exactly (wildcards `*` and `?` are allowed). A name without a dot is matched as a substring. Each result shows its size, creation date and last modification date.

### `whereis`: find commands and apps

```powershell
whereis git                    # resolves commands (PATH, cmdlets, functions, aliases)
whereis "Visual Studio Code"   # finds installed apps through the registry
```

Searches the HKLM and HKCU uninstall keys (32-bit and 64-bit views) and lists the `.exe` files found in the install location.

### `cdh`: directory bookmarks

```powershell
cdh                  # list bookmarks
cdh save             # bookmark the current folder (named after the folder)
cdh save myproject   # bookmark with a custom label
cdh myproject        # jump to it later
cdh del myproject    # remove a bookmark
```

Bookmarks are stored in `~/.config/hyacinthe/bookmarks.json`. The labels `save` and `del` are reserved.

### `weather`: forecast in the terminal

```powershell
weather          # default city (see Customization)
weather Tokyo    # any city worldwide
```

Shows current conditions (temperature, feels-like, humidity, wind, visibility) and a 3-day forecast.

### `hash` and `hex`: inspect files

```powershell
hash app.exe            # SHA256 (default), copied to the clipboard
hash app.exe -md5       # MD5 instead
hash -text "hello"      # hash a raw string

hex payload.bin         # first 256 bytes as hex and ASCII
hex payload.bin 512     # first 512 bytes
```

`hex` reads only the requested bytes, so it is safe on very large files.

---

## Customization

| What | Where | How |
|------|-------|-----|
| Default weather city, bookmark file, fastfetch folder | `$script:Settings` at the top of the profile | Edit the values |
| Colors | `$mochaHex` in the profile | Change any 6-digit hex value |
| Quotes | `$script:Quotes` in the profile | Add or remove quotes |
| Prompt icon and chevron | `PromptIcon` and `Chevron` in `$script:Glyph` | Use any code point from the [Nerd Font cheat sheet](https://www.nerdfonts.com/cheat-sheet) |
| ASCII art | `~/.config/fastfetch/ascii/*.txt` | Drop in your own `.txt` files; one is picked at random per launch |
| Color palettes | `$palettes` in `fastfetch-random.ps1` | Add a palette with 9 hex colors |
| Fixed logo or palette | The `& $fastfetchScript` call in the profile | Append `-Art itachi -Palette nord` |
| Transparency and font | `settings.json` | Edit `opacity`, `font.face`, `font.size` |

Your user name is highlighted in the prompt automatically through `$env:USERNAME`. Nothing is hard-coded.

ASCII art files use the color slots `$1` to `$9`; each slot is replaced by the matching color of the active palette.

---

## Troubleshooting

<details>
<summary><b>"running scripts is disabled on this system"</b></summary>

This is the Windows execution policy. Run once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
Unblock-File $PROFILE
Unblock-File "$HOME\.config\fastfetch\fastfetch-random.ps1"
```

Then reopen the terminal. The installer already unblocks the files it copies.
</details>

<details>
<summary><b>The profile does not load</b></summary>

Run `$PROFILE` in the shell you use and check that the file exists at exactly that path. Your Documents folder may be redirected to OneDrive, in which case the path is not `C:\Users\<you>\Documents\...`. The installer always uses the correct path.
</details>

<details>
<summary><b>Icons render as boxes or question marks</b></summary>

Make sure Windows Terminal uses a Nerd Font: check `"face": "JetBrainsMono Nerd Font Mono"` under `profiles.defaults.font` in the Terminal settings JSON.
</details>

<details>
<summary><b>No system info on startup</b></summary>

fastfetch may not be in your `PATH`. Test with `fastfetch --version`. If it fails, reinstall it with `winget install fastfetch` and reopen the terminal.
</details>

<details>
<summary><b>I need a clean shell without the profile</b></summary>

Start it with `pwsh -NoProfile` (or `powershell -NoProfile`).
</details>

---

## Uninstall

1. Delete the profile file shown by `$PROFILE` (or restore the `.bak-<timestamp>` backup next to it).
2. Delete `~/.config/fastfetch/` if you do not use fastfetch for anything else.
3. Delete `~/.config/username/` to remove your bookmarks.

---

## Development

CI runs `.github/scripts/validate.ps1` on Windows PowerShell 5.1 and PowerShell 7. It checks that every script parses, that scripts contain only ASCII characters, that the JSON files are valid and that ASCII art files use lowercase kebab-case names. You can run the same script locally:

```powershell
./.github/scripts/validate.ps1
```

---

## Credits

This project builds on the work of [SleepyCatHey](https://github.com/SleepyCatHey). The original concept and setup were presented in [his video](https://www.youtube.com/watch?v=z3NpVq-y6jU), which is worth watching if you want to understand the full stack or push your Windows terminal further.

Palette by [Catppuccin](https://github.com/catppuccin/catppuccin). System info by [fastfetch](https://github.com/fastfetch-cli/fastfetch).

The ASCII art depicts characters from anime and manga. It is fan art, and the characters belong to their respective owners.

## Support

If this setup made your terminal nicer, consider leaving a star or [sponsoring the project](https://github.com/sponsors/Hyacinthe-primus).

## License

Released under the [MIT License](LICENSE).
