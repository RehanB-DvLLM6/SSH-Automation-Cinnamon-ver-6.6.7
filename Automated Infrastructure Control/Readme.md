# Passwordless SSH Automation Setup
 
Reference notes for configuring key-based, passwordless SSH access between a
controller machine (e.g. laptop) and a remote server, so that scripts, cron
jobs, and configuration management tools (Ansible, CI pipelines, etc.) can
execute tasks without manual password prompts.
 
## Overview
 
Automated infrastructure control relies on SSH public-key authentication.
Once set up, the controller machine can run commands or scripts on the
remote host instantly, with no interactive login step.
 
## 1. Generate a dedicated SSH key pair
 
```bash
ssh-keygen -t ed25519 -C "automation-key" -f ~/.ssh/automation_key
```
 
- Uses the Ed25519 algorithm (fast, modern, secure).
- Giving the key its own filename (rather than the default `id_ed25519`)
  makes it easy to scope, rotate, or revoke independently of your personal
  login key.
- Leave the passphrase empty **only** if this key will be used for fully
  unattended automation (cron, CI runners). See [Security notes](#security-notes).
## 2. Copy the public key to the remote server
 
```bash
ssh-copy-id -i ~/.ssh/automation_key.pub user@remote-host
```
 
You'll be prompted for the remote account's password one final time. After
this, the public key is appended to `~/.ssh/authorized_keys` on the remote
host.
 
## 3. Verify passwordless access
 
```bash
ssh -i ~/.ssh/automation_key user@remote-host "uname -a && uptime"
```
 
If this returns output with no password prompt, the key-based login is
working.
 
## 4. Run remote commands / scripts
 
```bash
ssh -i ~/.ssh/automation_key user@remote-host \
  "mkdir -p ~/remote_logs && echo 'Automated check ran at $(date)' >> ~/remote_logs/run.log"
```
 
This is the same mechanism used under the hood by Ansible, GitHub Actions
deployment steps, and cron-triggered scripts.
 
## Security notes
 
- **Never commit private keys to a repository.** Only the `.pub` file
  should ever leave the controller machine, and it doesn't need to be
  secret. `.gitignore` should exclude `automation_key` (no extension) and
  any `*.pem` files.
- **Scope the key on the server** if it only needs to perform specific
  tasks. In `~/.ssh/authorized_keys` on the remote host, you can restrict
  what a given key is allowed to do:
```
  command="/home/user/allowed_script.sh",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-ed25519 AAAA...automation-key
```
 
  This forces the key to run only that command, even if it's ever used
  interactively.
- **Restrict file permissions** on the private key:
```bash
  chmod 600 ~/.ssh/automation_key
```
- **For CI/CD (e.g. GitHub Actions)**, store the private key as an
  encrypted repository/organization secret — never inline it in a workflow
  file or commit history.
- **Passphrase-less keys carry risk**: anyone who obtains the private key
  file has immediate access with no second factor. Prefer this only for
  genuinely unattended jobs, and treat the controller machine itself as
  security-sensitive (disk encryption, minimal exposed services, kept
  patched).
- Consider a separate key per purpose/host rather than one automation key
  for everything, so a compromise or rotation is contained.
## Example: Ansible inventory using this key
 
```ini
[servers]
remote-host ansible_user=user ansible_ssh_private_key_file=~/.ssh/automation_key
```
 
## License
 
MIT (or your preference — update before publishing).
