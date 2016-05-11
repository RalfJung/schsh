# schsh: Restricted file access via SSH

## Introduction

Welcome to [schsh](https://www.ralfj.de/projects/schsh), a schroot-based shell.

Its purpose is simple: I want to provide users with scp, sftp and rsync access
to my server, such that they can only operate in a certain subdirectory.
There are plenty of solutions for this problem out there, and all have one
drawback in common:
You need to manually set up a bunch of chroots, and copy the files needed for
scp, sftp and rsync into them.

I didn't like that, so here is my alternative solution: Use schroot for the
chroots. This gets OpenSSH out of the loop when it comes to chroots, instead
the relevant users get a special shell (schsh, the schroot shell). That shell
essentially calls schroot and runs the desired command inside the chroot. It
also provides some very basic command restriction (so that you can allow scp,
sftp and rsync and nothing else).

Unfortunately, this still needs a (s)chroot to be set up for each user, but at
least no files have to be copied: Instead, schroot is configured to bind-mount
the relevant system folders into the user-chroot. Hence no files are
duplicated, and system updates to the relevant tools are applied inside the
chroots automatically. For additional hardening, these bind-mounts are
configured to be read-only and no-setuid, while the only user-writeable folder
is no-exec.

## Setup

Before you start, make sure you have the dependencies installed:
schsh needs [Python 3](http://www.python.org) (I tested it with
version 3.2) and [schroot](https://wiki.debian.org/Schroot)
(version 1.6 or newer).

Installation is simple: Just run `make install`. That will copy some files
to `/usr/local/bin`, and some configuration to `/etc/schroot/`.
Before you create any users, make sure the directory `/var/lib/schsh` and a
group called `schsh` exist.

You should also set up SSH to disallow port forwarding for users controlled by
schsh. See `sshd_config` in the source folder for an appropriate snippet
of OpenSSH configuration.

Before you can set up schsh for a user, you need to create it first:

    adduser sandboxed --disabled-password

Any existing user can be "sandboxed" by running:

    makeschsh sandboxed

This does the following:

* Change the user's shell to `/usr/local/bin/schsh`
* Create a chroot base in `/var/lib/schsh/sandboxed` with some empty
  subfolders as well as `/etc/passwd` and `/etc/group` containing
  only root, this user and the `schsh` group
* Add the user to the `schsh` group
* Set up a schroot called `schsh-sandboxed` for the given folder, and an
  fstab file in `/etc/schroot/schsh` used by this schroot

Now if the user logs in via SSH, `/usr/local/bin/schsh` will be executed,
and it will lock the user into the schroot `schsh-sandboxed`. It will
only see some system folders and a folder called `/data` mapped to
`/home/sandboxed/data`. If you want to give the user access to more
folders, or another folder, simply edit `/etc/schroot/schsh/sandboxed.fstab`.
The only part of schsh writing any files is `makeschsh`, so you can change
the users' schroot configurations at your will.

## Configuration

There is not much to configure at the moment. However, there are some
global variables at the top of both `schsh` and `makeschsh` to
change the base paths, and to tell which commands are allowed.

## Source, License

You can find the sources in the [git 
repository](https://git.ralfj.de/schsh.git) (also available [on
GitHub](https://github.com/RalfJung/schsh)). They are provided under the 
[GPLv3](https://www.gnu.org/licenses/gpl.html). In addition, all files except 
for `schsh-rrsync` are provided under the 
[GPLv2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) or (at your 
option) any later version of the GPL. See the file `LICENSE-GPL3` for more 
details.

## Contact

If you found a bug, or want to leave a comment, please
[send me a mail](mailto:post-AT-ralfj-DOT-de).
