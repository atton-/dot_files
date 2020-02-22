#!/bin/sh
cd `dirname $0`

set -eux
nvim --version

which bash curl git bash pip3 gcc
bash python-init.sh 'NO_AWS'

installer_path='/tmp/installer.sh'
curl -s https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $installer_path
bash $installer_path $HOME/.config/nvim/dein
rm $installer_path

mkdir -p $HOME/.config/nvim/eskk
curl -s https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L > $HOME/.config/nvim/eskk/SKK-JISYO.L

nvim -c ':call dein#install()' -c ':UpdateRemotePlugins' -c ':quit'
test -d $HOME/.config/nvim/dein/repos/github.com/atton/gundo.vim
test -d $HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim
test -d $HOME/.config/nvim/dein/repos/github.com/Shougo/deoplete.nvim
test -f $HOME/.config/nvim/eskk/SKK-JISYO.L

checkhealth_path='/tmp/checkhealth.txt'
nvim -c ':checkhealth' -c ":write $checkhealth_path" -c ':quitall'
cat $checkhealth_path
rm $checkhealth_path
