pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ ssh pseudo@192.168.1.XXX
pseudo@192.168.1.5's password: 

3 devices have a firmware upgrade available.
Run `fwupdmgr get-upgrades` for more information.

3 devices have a firmware upgrade available.
Run `fwupdmgr get-upgrades` for more information.

Last login: Tue Sep  1 20:02:50 2026 from 192.168.1.XXX
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ scp "file 0.docx" pseudo@192.168.1.XXX:~/
pseudo@192.168.1.5's password: 
file 0.docx                                   100%   13    26.7KB/s   00:00    
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ scp "file 0.docx" pseudo@192.168.1.XXX:~/
pseudo@192.168.1.XXX's password: 
file 0.docx                                   100%   13    14.9KB/s   00:00    
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ scp "file 0.docx" pseudo@192.168.1.XXX:~/Documents/
pseudo@192.168.1.XXX's password: 
file 0.docx                                   100%   13    15.8KB/s   00:00    
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ scp "file 0.docx" pseudo@192.168.1.XXX:~/backup_document.docx
pseudo@192.168.1.XXX's password: 
file 0.docx                                   100%   13    16.1KB/s   00:00    
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ scp pseudo@192.168.1.XXX:~/file\ 0.docx ~/Downloads/
pseudo@192.168.1.XXX's password: 
file 0.docx                                   100%   13     8.5KB/s   00:00    
pseudo@pseudo-IdeaPad-Gaming-3-15ARH05:~$ 
