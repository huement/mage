# Dotfiles Syncing

> NU Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place. 
> For example, /usr/local/bin could contain symlinks to files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin etc., and likewise recursively for any other subdirectories such as .../share, .../man, and so on.

To find out more information about Stow, checkout the documentation here:
[https://www.gnu.org/software/stow/manual/](https://www.gnu.org/software/stow/manual/)


### Who what where?

Stow is a tool for managing the installation of multiple software packages in the same run-time directory tree. One historical difficulty of this task has been the need to administer, upgrade, install, and remove files in independent packages without confusing them with other files sharing the same file system space. For instance, it is common to install Perl and Emacs in /usr/local. When one does so, one winds up with the following files1 in /usr/local/man/man1:

* a2p.1
* ctags.1
* emacs.1
* etags.1
* h2ph.1
* perl.1
* s2p.1

Now suppose it's time to uninstall Perl. Which man pages get removed? Obviously perl.1 is one of them, but it should not be the administrator's responsibility to memorize the ownership of individual files by separate packages.

The approach used by Stow is to install each package into its own tree, then use symbolic links to make it appear as though the files are installed in the common tree. Administration can be performed in the package's private tree in isolation from clutter from other packages. Stow can then be used to update the symbolic links. The structure of each private tree should reflect the desired structure in the common tree; i.e. (in the typical case) there should be a bin directory containing executables, a man/man1 directory containing section 1 man pages, and so on.

Stow was inspired by Carnegie Mellon's Depot program, but is substantially simpler and safer. Whereas Depot required database files to keep things in sync, Stow stores no extra state between runs, so there's no danger (as there was in Depot) of mangling directories when file hierarchies don't match the database. Also unlike Depot, Stow will never delete any files, directories, or links that appear in a Stow directory (e.g., /usr/local/stow/emacs), so it's always possible to rebuild the target tree (e.g., /usr/local).

For information about the latest version of Stow, you can refer to [http://www.gnu.org/software/stow/](http://www.gnu.org/software/stow/).

