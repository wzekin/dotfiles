#! /bin/sh
#
# install.sh
# Copyright (C) 2019 zekin <zekin@DESKTOP-UR3A57I>
#
# Distributed under terms of the MIT license.
#

work_path=$(dirname $(readlink -f $0))
ln  -dfvs ${work_path}/vim   $HOME/.config/nvim
ln  -dfvs ${work_path}/pip   $HOME/.config/pip
ln  -dfvs ${work_path}/yay  $HOME/.config/yay
ln -fvs ${work_path}/zsh/.zshrc $HOME/.zshrc
