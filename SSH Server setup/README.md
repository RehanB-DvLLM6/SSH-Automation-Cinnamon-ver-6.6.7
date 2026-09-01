# SSH Server Setup

Reference notes for the initial setup of an OpenSSH server on a Linux Mint
(Cinnamon) machine — installing the server, enabling it to start on boot,
and configuring the firewall to allow SSH connections. This is the first
step in the project: everything else (passwordless key automation, SCP
transfers, sshfs mounts) depends on the server being installed, running,
and reachable.

> **Note:** The files in this folder (`1.update_dependencies.sh` through
> `4.firewall_and_Status chechup.sh`) are currently saved as terminal
> transcripts/logs from when these steps were originally run, rather than
> clean executable scripts. They're kept here as a record of exactly what
> was done and what output to expect. The commands below are the actual
> steps to run manually, in order.

## 1. Update dependencies

```bash
sudo apt update
```

Refreshes the package index so the SSH server package (and everything
else) installs from up-to-date sources.

> If you see a GPG/`NO_PUBKEY` warning about a third-party repository
> (e.g. Spotify), it's unrelated to SSH and can be ignored, or fixed
> separately by importing that repo's signing key.

## 2. Install the SSH server

```bash
sudo apt install openssh-server -y
```

Installs `openssh-server` along with its dependencies
(`openssh-sftp-server`, `ncurses-term`, `ssh-import-id`) and generates the
host's SSH key pairs (RSA, ECDSA, ED25519) on first install.

## 3. Enable and start SSH on boot

```bash
sudo systemctl enable ssh
```

By default, the SSH service may show as `inactive (dead)` right after
install. This enables it to start automatically on every boot (creates the
`multi-user.target.wants` symlink). To also start it immediately without
rebooting:

```bash
sudo systemctl start ssh
```

Check status any time with:

```bash
sudo systemctl status ssh
```

### Allow SSH through the firewall

```bash
sudo ufw allow ssh
```

Adds a rule permitting inbound traffic on port 22 (the default SSH port).

## 4. Enable the firewall and verify

```bash
sudo ufw enable
sudo ufw status
```

Turns on `ufw` (Uncomplicated Firewall) so it's active on every startup,
then confirms the SSH rule is in place. Expected output:

```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
```

## Result

After these four steps, the machine:
- Has `openssh-server` installed and running
- Starts SSH automatically on every boot
- Accepts inbound SSH connections (port 22) through the firewall

From here, you can move on to [passwordless key-based
authentication](../Automated%20Infrastructure%20Control/README.md) so
scripts and automation tools can connect without a password prompt.

## Security notes

- Port 22 is open to **any** source IP by default with `ufw allow ssh`. On
  a machine reachable from the internet (not just LAN), consider
  restricting this to known IPs (`sudo ufw allow from <ip> to any port
  22`) or changing the default port.
- Disable password authentication in `/etc/ssh/sshd_config`
  (`PasswordAuthentication no`) once key-based login is confirmed working,
  to close off brute-force password attempts entirely.
- Keep the system updated (`sudo apt update && sudo apt upgrade`)
  regularly, since `openssh-server` is a common target for scanning and
  exploits if left outdated.

## License

MIT (or your preference — update before publishing).
