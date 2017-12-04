# Dotfile Version Control

> GNU Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place. 
> For example, /usr/local/bin could contain symlinks to files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin etc., and likewise recursively for any other subdirectories such as .../share, .../man, and so on.

### Download and Documentation
To find out more information about Stow, checkout the documentation here:
[https://www.gnu.org/software/stow/manual/](https://www.gnu.org/software/stow/manual/)

For information about the latest version of Stow, you can refer to [http://www.gnu.org/software/stow/](http://www.gnu.org/software/stow/).

### Tutorials
For more detailed instructions checkout the following articles
[https://spin.atomicobject.com/2014/12/26/manage-dotfiles-gnu-stow/](https://spin.atomicobject.com/2014/12/26/manage-dotfiles-gnu-stow/)
[http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)

## Using Stow

The syntax of the stow command is:
```bash
stow [options] [action flag] package ...
```

## Example
```bash
cd ~/mage/dotsync/
mkdir ./bash
mv ~/.bashrc ./bash
[move other relevant files]
stow --ignore="(^\.DS_Store)" -t ~/ bash
```

