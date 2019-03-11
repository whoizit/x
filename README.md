# `x` is a wrapper around any package manager
*(inspired by ArchLinux AUR helper `yay`)*

`x` **without parameter** is always `u` - **update/upgrade**  
`x` **with one parameter** is a search (by default)

You can overwrite defaults here:  
`~/.config/x/config.yml`  
`~/.config/x/pm/{file}.yml`  

Example output for xbps:  
```
$ x -h
u    update            sudo xbps-install -Su
i    install           sudo xbps-install -S
r    remove            sudo xbps-remove -R
s    search            xbps-query -Rs
in   info              xbps-query -S
l    list files        xbps-query -f
o    owned by          xbps-query -o
ob   owned by (binary) xbps-query -o $(readlink -f $(which {}))

$ x
[*] Updating `http://ftp.lysator.liu.se/pub/voidlinux/current/x86_64-repodata' ...
[*] Updating `http://ftp.lysator.liu.se/pub/voidlinux/current/nonfree/x86_64-repodata' ...
[*] Updating `http://ftp.lysator.liu.se/pub/voidlinux/current/multilib/x86_64-repodata' ...
[*] Updating `http://ftp.lysator.liu.se/pub/voidlinux/current/multilib/nonfree/x86_64-repodata' ...
(nothing to upgrade)

$ x mypy
[*] python3-mypy-0.670_2 Optional static typing for Python3

$ x o /etc/fstab
base-files-0.140_3: /etc/fstab (configuration file)

$ x ob vim
vim-8.1.1002_1: /usr/bin/vim-normal (regular file)

# explicit running command without parameter
$ x :u
...
```

Any PR's are welcome
