# SCP File Transfer (PC ↔ PC)

Reference notes for transferring files between machines on the local
network using `scp` (Secure Copy), built over SSH.

## Overview

`scp` copies files/folders between a local machine and a remote host (or
between two remote hosts) over an encrypted SSH connection. Syntax:

```bash
scp [options] source destination
```

Either `source` or `destination` can be remote, in the form:

```
user@host:/path/to/file
```

## Basic usage

### Push a file from local PC to remote host (home directory)

```bash
scp "file 0.docx" pseudo@192.168.1.XXX:~/
```

Quote filenames that contain spaces.

### Push a file into a specific remote folder

```bash
scp "file 0.docx" pseudo@192.168.1.XXX:~/Documents/
```

### Push a file and rename it on the destination

```bash
scp "file 0.docx" pseudo@192.168.1.XXX:~/backup_document.docx
```

### Pull a file from remote host to local PC

```bash
scp pseudo@192.168.1.XXX:~/"file 0.docx" ~/Downloads/
```

Escape spaces in the remote filename with `\ ` or wrap the whole
`user@host:path` in quotes.

## Useful flags

| Flag | Purpose |
|------|---------|
| `-r` | Recursively copy a whole directory |
| `-P` | Specify a non-default SSH port (`-P 2222`) |
| `-i` | Use a specific private key (`-i ~/.ssh/automation_key`) |
| `-C` | Compress data during transfer (helps on slow links) |
| `-p` | Preserve modification times, access times, and permissions |
| `-v` | Verbose output, useful for debugging connection issues |

Example — copy an entire folder using a specific key:

```bash
scp -r -i ~/.ssh/automation_key ~/Projects/myfolder pseudo@192.168.1.XXX:~/Backups/
```

## Notes on this setup

- Currently these transfers prompt for the remote account's password each
  time. If you've already set up [passwordless SSH key
  authentication](../ssh-automation/README.md), the same key works for
  `scp` automatically — no extra config needed, since `scp` rides on SSH.
- IP addresses above are local network (LAN) addresses and will differ per
  device/network. Replace `192.168.1.XXX` with the actual host IP or a
  hostname from your SSH config.
- For repeated transfers to the same host, consider adding an entry to
  `~/.ssh/config` so you can just run `scp file.docx myhost:~/` instead of
  typing the full user/IP each time:

  ```
  Host myhost
      HostName 192.168.1.XXX
      User pseudo
      IdentityFile ~/.ssh/automation_key
  ```

## Security notes

- `scp` traffic is encrypted end-to-end via SSH — safe to use over a trusted
  LAN or the internet.
- Avoid transferring files with sensitive data (private keys, credentials)
  to shared or less-trusted machines, even over an encrypted transfer.
- If both machines are on the same LAN and this is a recurring workflow,
  key-based auth (see the SSH automation README) removes the repeated
  password prompts and makes transfers scriptable.

## License

MIT (or your preference — update before publishing).
