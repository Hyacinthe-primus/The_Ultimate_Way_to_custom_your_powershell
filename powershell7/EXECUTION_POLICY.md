# Execution Policy — Windows PowerShell

Windows blocks unsigned `.ps1` scripts by default.
This README explains how to configure the execution policy to get this profile running.

---

## Why does this happen?

When you download files from the internet (or via OneDrive / GitHub), Windows applies an NTFS flag called **Zone.Identifier** that marks them as "potentially dangerous". PowerShell refuses to run them if the execution policy is too restrictive.

There are two distinct issues to solve:
1. The **execution policy** — what PowerShell is allowed to run
2. The **block flag** on each file — applied by Windows on download

---

## Full setup (one time only)

### Step 1 — Change the execution policy

Open PowerShell (no admin required) and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**What this means:**
- `RemoteSigned` → local scripts run freely, scripts downloaded from the internet must be signed
- `CurrentUser` → applies only to your account, not the entire machine (no admin needed)

### Step 2 — Unblock the profile files

```powershell
Unblock-File "$env:USERPROFILE\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
Unblock-File "$env:USERPROFILE\.config\fastfetch\fastfetch-random.ps1"
Get-ChildItem "$env:USERPROFILE\OneDrive\Documents\PowerShell\profile\*.ps1" | Unblock-File
```

> **Important:** repeat this step every time you replace or add a `.ps1` file to the `profile\` folder, as new files inherit the block flag.

---

## If you're using GitHub

When you clone the repo or download files through GitHub, Windows automatically applies the block flag. After each `git pull` or download, run:

```powershell
Get-ChildItem "$env:USERPROFILE\OneDrive\Documents\PowerShell\profile\*.ps1" | Unblock-File
```

You can also create a `setup.ps1` at the root of the repo to automate this:

```powershell
# setup.ps1 — run once after cloning
$profileRoot = "$env:USERPROFILE\OneDrive\Documents\PowerShell"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Unblock-File "$profileRoot\Microsoft.PowerShell_profile.ps1"
Get-ChildItem "$profileRoot\profile\*.ps1" | Unblock-File

Write-Host "Setup complete. Restart PowerShell." -ForegroundColor Green
```

---

## Check the current policy

```powershell
Get-ExecutionPolicy -List
```

Expected output after setup:

```
        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser    RemoteSigned   <- this one
 LocalMachine      Restricted
```

---

## Revert to default

```powershell
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
```

`Undefined` removes the policy at the `CurrentUser` level and lets the machine fall back to `Restricted` by default.

---

## Policy levels reference

| Policy | Description |
|---|---|
| `Restricted` | No scripts allowed (Windows default) |
| `AllSigned` | All scripts must be digitally signed |
| `RemoteSigned` | Local scripts run freely, remote scripts must be signed |
| `Unrestricted` | Everything allowed (not recommended) |
| `Bypass` | Nothing blocked, no warnings (not recommended) |
| `Undefined` | No policy defined at this scope |

---

## Quick reference

```powershell
# 1. Allow local scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. Unblock files (repeat after every update)
Get-ChildItem "$env:USERPROFILE\OneDrive\Documents\PowerShell\profile\*.ps1" | Unblock-File
Unblock-File "$env:USERPROFILE\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
```
