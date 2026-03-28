## My Dotfiles

> Managed with [GNU Stow](https://www.gnu.org/software/stow/)

### Clone

```bash
cd ~
git clone git@github.com:medevdk/dotfiles.git
cd dotfiles
```

### macOS

```bash
stow shared
stow mac
stow git
stow ssh
stow zsh
stow .tmux
stow vim
stow yazi
```

### Fedora (Asahi Linux)

```bash
stow shared
stow linux
stow git
stow ssh
stow zsh
```

### Tmux plugins

```bash
cd ~/dotfiles/.tmux
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
```

Then in tmux: `CTRL-A + SHIFT I` to install plugins

### Neovim

Plugins are managed via lazy.nvim and install automatically on first launch.

### Brew (macOS only)

Restore packages after stowing:

```bash
xargs brew install < ~/dotfiles/mac/brew/leaves.txt
xargs brew install --cask < ~/dotfiles/mac/brew/casks.txt
```

### Reload shell

```bash
reload
```

### Structure

```
dotfiles/
  shared/     # symlinked on both macOS and Fedora
  mac/        # symlinked on macOS only
  linux/      # symlinked on Fedora only
  git/        # .gitconfig, .gitignore_global
  ssh/        # ~/.ssh/config (keys are not stored)
  zsh/        # .zshrc, .zsh_plugins.txt
  vim/        # .vimrc
  .tmux/      # tmux config + plugins
  yazi/       # yazi file manager config
```

### SSH Keys

Keys are **not** stored in this repo. Generate on each machine:

```bash
ssh-keygen -t ed25519 -C "your-description"
ssh-add ~/.ssh/id_ed25519
```

Then add the public key to [GitHub](https://github.com/settings/keys).
