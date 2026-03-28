## Stow Cheatsheet

### Basic usage

```bash
stow <package>        # symlink package to home directory
stow -D <package>     # unlink/remove package
stow -R <package>     # relink (unlink then link again)
```

### Useful flags

```
-v    verbose output
-n    dry run, shows what would happen without doing it
-D    delete/unlink
-R    restow (purge and relink)
```

### Dry run before stowing (recommended)

```bash
stow -nv <package>
```

### How it works

Stow mirrors the directory structure inside the package to the target (default: `~`).
So `shared/.config/nvim/` becomes `~/.config/nvim/`

### Examples

```bash
cd ~/dotfiles
stow shared           # symlink shared config
stow -D shared        # remove shared symlinks
stow -R shared        # relink shared (useful after adding new files)
```
