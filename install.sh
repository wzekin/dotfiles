#! /bin/sh
#
# install.sh
# Copyright (C) 2019 zekin <zekin@DESKTOP-UR3A57I>
#
# Distributed under terms of the MIT license.
#

work_path=$(pwd)
ln  -fvs ${work_path}/vim   $HOME/.config/nvim
ln  -fvs ${work_path}/pip   $HOME/.config/pip
#ln  -dfvs ${work_path}/yay  $HOME/.config/yay
ln  -fvs ${work_path}/zsh/.zshrc $HOME/.zshrc


ln  -fvs ${work_path}/yarn/.yarnrc $HOME/.yarnrc

ln  -fvs ${work_path}/cargo/config $HOME/.cargo/config
