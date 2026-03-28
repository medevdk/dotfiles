## My Dotfiles

### Clone

```bash
cd ~
git clone https://github.com/medevdk/dotfiles.git
```

### Stow everything

```bash
cd ~/dotfiles
stow git
stow ssh
stow zsh
stow .tmux
stow vim
stow config
stow yazi
```

### Git

Your `.gitconfig` and `.gitignore_global` are now managed here.

### SSH

Your `~/.ssh/config` is managed here. Keys are **not** stored — add them manually:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-add ~/.ssh/id_ed25519
```

### Tmux plugins

```bash
cd ~/dotfiles/.tmux
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
```

Then in tmux: `CTRL-A + SHIFT I` to install plugins

### Neovim

Plugins are managed via lazy.nvim and install automatically on first launch.

### Brew

Restore packages:

```bash
xargs brew install < ~/dotfiles/brew/leaves.txt
xargs brew install --cask < ~/dotfiles/brew/casks.txt
```

### Reload shell

```bash
reload
```
