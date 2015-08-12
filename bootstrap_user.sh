#!/usr/bin/env bash

echo "#### RUNNING USER MODE SCRIPTS ####"
mv .emacs.d .emacs.bak
git clone --recursive https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d && git pull -r && git submodule update && cd ~/

# Added zsh shell.
#wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh 

# Change the oh my zsh default theme.
#sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="3den"/g' ~/.zshrc

echo "Copying the Spacemacs profile"
cp /vagrant/.spacemacs ~/.spacemacs
