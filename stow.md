stow <name> -v -R -t <target directory>

-v verbose
-R purge old files first
-t target 

Example

mkdir -p ~/.config/yazi
cd dotfiles
stow yazi -v -R -t ~/.config/yazi
