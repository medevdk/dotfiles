## my Dotfiles

```
cd ~
git clone https://github.com/medevdk/dotfiles.git
```

Get _zsh_ up and running (not using a plugin manager)

```
cd ~/dotfiles/zsh/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
```

Get _tmux_ up and running

```
cd ~/dotfiles/.tmux
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
```

Symlink

```
cd ~/dotfiles
stow zsh
stow .tmux
stow vim
```

Open the terminal

```
reload
tmux source ~/.tmux.conf
CTRL-A + SHIFT I
```
