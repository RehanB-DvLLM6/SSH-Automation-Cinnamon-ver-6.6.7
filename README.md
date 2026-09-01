<img width="1465" height="250" alt="Untitled design" src="https://github.com/user-attachments/assets/3d62d2d1-6ed6-4af2-844c-03f14d338327" />
<p align="left<img width="1465" height="857" alt="Screenshot from 2026-09-01 22-37-37" src="https://github.com/user-attachments/assets/d42de17e-d48e-4e33-81b7-c6d03449ce40" />

A collection of scripts and guides for setting up, securing, and automating
SSH-based remote administration on Linux Mint (Cinnamon), covering server
setup, passwordless key authentication, file transfer, remote mounting,
telemetry, and a manual killswitch.

<p align="center">
  <img width="1465" height="857" alt="Screenshot from 2026-09-01 22-37-37" src="https://github.com/user-attachments/assets/69d92738-c60a-403f-a407-5246036b649b" />
</p>

## Overview

This project documents an end-to-end SSH workflow for managing a Linux
server (or a second PC acting as one) from a client machine — starting
from a fresh install of `openssh-server` through to fully automated,
passwordless remote execution and file transfer.

## Project structure

| Folder | Description |
|---|---|
| [`SSH Server setup/`](./SSH%20Server%20setup/) | Install and enable `openssh-server`, start SSH on boot, and configure the firewall (`ufw`) to allow SSH traffic. Start here. |
| [`Automated Infrastructure Control/`](./Automated%20Infrastructure%20Control/) | Set up passwordless SSH key authentication (Ed25519) so scripts, cron jobs, and tools like Ansible can run commands on the remote server without a password prompt. |
| [`SCP File Transfer/`](./SCP%20File%20Transfer/) | Copy files between machines over SSH using `scp` — pushing, pulling, renaming on transfer, and using an SSH config alias for shorter commands. |
| [`Mounting Remote Server Folder sshfs/`](./Mounting%20Remote%20Server%20Folder%20sshfs/) | Mount a remote server's folder directly into the local filesystem using `sshfs`, so remote files can be browsed and edited like local ones. |
| [`Memory_Telemetry Utility/`](./Memory_Telemetry%20Utility/) | Utility for monitoring memory/system telemetry on the remote server. |
| [`killswitch/`](./killswitch/) | A manual killswitch script/mechanism for cutting off remote access or automation if needed. |

Each folder has its own `README.md` with setup steps, commands, and notes
specific to that part of the project.

## Suggested order

1. **SSH Server setup** — get SSH installed, running, and reachable.
2. **Automated Infrastructure Control** — switch to passwordless key-based
   login.
3. **SCP File Transfer** / **Mounting Remote Server Folder sshfs** — move
   and access files between machines.
4. **Memory_Telemetry Utility** — monitor the remote server once it's up
   and reachable.
5. **killswitch** — keep on hand as a manual override for the automation
   set up above.

## Requirements

- A Linux Mint (Cinnamon) machine acting as the server, and a second
  machine (or another PC) acting as the client/controller.
- `openssh-server` on the server, `openssh-client` on the controller
  (installed as part of the SSH Server setup steps).
- `ufw` for firewall management (default on Linux Mint).
- Basic familiarity with the terminal — every step in this project is
  driven from the command line.

## Security notes

- Passwordless SSH keys used for automation carry real risk if the
  private key is exposed — see the notes in
  [`Automated Infrastructure Control/README.md`](./Automated%20Infrastructure%20Control/README.md)
  for scoping and protecting them.
- Consider disabling SSH password authentication entirely once key-based
  login is confirmed working (`PasswordAuthentication no` in
  `/etc/ssh/sshd_config`).
- Keep the server's packages up to date, especially `openssh-server`.

## License

MIT (or your preference — update before publishing).
