pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ ssh-keygen -t ed25519 -C "ideaPad-automation"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/pseudo/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/pseudo/.ssh/id_ed25519
Your public key has been saved in /home/pseudo/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:rtPb0tBlxNn2OdyvAGPLz6eKaiX9S/VGiqZ8Wr8UvPg ideaPad-automation
The key's randomart image is:
+--[ED25519 256]--+
|           . o   |
|            + o  |
|           . ...o|
|          +.o  +o|
|       .S+ *+ . o|
|      ..+ ++.*  .|
|       +.+*o+.o. |
|      oooB++o.o  |
|     .oo*=+oE+   |
+----[SHA256]-----+
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ ssh-copy-id pseudo@192.168.1.XX
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/pseudo/.ssh/id_ed25519.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
pseudo@192.168.1.XX's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'pseudo@192.168.1.XX'"
and check to make sure that only the key(s) you wanted were added.

pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ ssh pseudo@192.168.1.XX "mkdir -p ~/remote_logs && echo 'Automated check ran at $(date)' >> ~/remote_logs/run.log"
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ 

