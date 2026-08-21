# Mounting a Remote Linux Mint Server Folder with sshfs

This guide walks through mounting a folder from a remote Linux Mint server (`mint-server`) onto a local laptop (IdeaPad running Linux Mint) using `sshfs`.

<img width="966" height="230" alt="s1" src="https://github.com/user-attachments/assets/3220a098-d6ad-46fa-935e-52a25755cd15" />


## Step 1: Install `sshfs` on Your Laptop

Open a local terminal on your IdeaPad and install the filesystem client:

```bash
sudo apt update && sudo apt install sshfs -y
```

## Step 2: Create a Local Mount Point

Create an empty folder on your laptop where the server's files will appear:

```bash
mkdir -p ~/mint-drive
```

## Step 3: Mount the Server Folder

Mount your server's home directory into that folder using your SSH shortcut:

```bash
sshfs mint-server:/home/pseudo ~/mint-drive
```

## Step 4: Check It Out

Open your local file manager, or run this command on your laptop:

```bash
ls ~/mint-drive
```

You should see the files living on your Linux Mint server.
<img width="1185" height="844" alt="s2" src="https://github.com/user-attachments/assets/76502dc1-ffa2-4f68-8cbc-6ea539848c54" />


## Step 5: Unmount When Done

When you're finished, safely unmount the remote folder:

```bash
fusermount -u ~/mint-drive
```

---

**Notes:**
- Replace `mint-server` with your actual SSH host alias (defined in `~/.ssh/config`) or `user@ip-address`.
- The screenshots above show a working example: installing `sshfs`, mounting `mint-server:/home/pseudo` to `~/mint-drive`, listing its contents, then unmounting with `fusermount -u`.
