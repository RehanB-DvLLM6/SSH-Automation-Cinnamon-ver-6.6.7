# Killswitch — SSH Shell-Based Process Termination

A lightweight Bash script that terminates a target application over an SSH session with a single command. Demonstrated here using Firefox as the kill target.

---

## Overview

Killswitch is a minimal, no-dependency shell script designed to forcefully terminate a specified process on a remote machine via SSH. No GUI required, no bloated tooling — just a script, a target, and a kill signal.

**Use cases:**
- Remotely killing a hung or unresponsive application
- Automating session cleanup on headless/remote servers
- Scripted process management in CI/CD or admin workflows

---

## How It Works

The script identifies the target process by name using `pkill` / `kill` + `pgrep`, sends the termination signal, and confirms success or failure via stdout. Clean, single-purpose, does exactly what it says.

---

## Demo

### Script Definition

The custom Bash script targeting Firefox as the kill process.

![Killswitch Script](https://github.com/user-attachments/assets/12d4ec77-cd3d-4b9c-b8ca-e6f369e8aa62)

---

### Pre-Termination State

Firefox is running. The script has not been executed yet.

![Firefox Open](https://github.com/user-attachments/assets/ab091bbd-444f-4e07-9aff-b174a24a6e92)

---

### Post-Termination State

Script executed in the terminal. Firefox is closed. Termination success message confirmed in terminal output.

![Post Killswitch](https://github.com/user-attachments/assets/aa6b398e-9859-411a-8cc6-b1f93c6d8152)

---

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo/Killswitch
```

### 2. Make the script executable

```bash
chmod +x killswitch.sh
```

### 3. Run it

```bash
./killswitch.sh
```

To target a different application, open the script and update the `TARGET` variable:

```bash
TARGET="your-app-name"
```

---

## Script Breakdown

```bash

TARGET="firefox"

if pgrep -x "$TARGET" > /dev/null; then
    pkill -x "$TARGET"
    echo "[+] $TARGET terminated successfully."
else
    echo "[-] $TARGET is not running."
fi
```

| Component | Purpose |
|-----------|---------|
| `pgrep -x` | Checks for an exact process name match |
| `pkill -x` | Sends SIGTERM to the matched process |
| Exit messaging | Explicit success/failure feedback in terminal |

---

## Requirements

- Unix-based OS (Linux / macOS)
- Bash 4.x+
- SSH access to the target machine (for remote execution)
- Sufficient permissions to kill the target process

---

## Running Remotely Over SSH

```bash
ssh user@remote-host 'bash -s' < killswitch.sh
```

Or if the script is already on the remote machine:

```bash
ssh user@remote-host './killswitch.sh'
```

---

## Files

```
Killswitch/
└── killswitch.sh     # Main termination script
```

---

## Notes

- The script uses exact process name matching (`-x` flag) to avoid accidentally killing processes with similar names.
- For processes that ignore SIGTERM, swap `pkill` for `pkill -9` to force-kill.
- ## Tested on Mint Cinnamon 6.6.7. Should work on any POSIX-compliant system without modification.
