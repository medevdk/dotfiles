## my Dotfiles

```
cd ~
git clone https://github.com/medevdk/dotfiles.git
```

#### Get _tmux plugins_ up and running

```
cd ~/dotfiles/.tmux
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
```

#### Symlink

```
cd ~/dotfiles

stow zsh
stow .tmux
stow vim
```

#### In the terminal

```
reload

CTRL-A + SHIFT I
```
