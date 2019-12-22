#! /bin/sh
#
# install.sh
# Copyright (C) 2019 zekin <zekin@DESKTOP-UR3A57I>
#
# Distributed under terms of the MIT license.
#

work_path=$(dirname $(readlink -f $0))

if ! [ -a ./backup-config ]
then
  mkdir backup-config
else
  rm -r backup-config/*
fi

if [ -a $HOME/.config/nvim ]
then
  mv $HOME/.config/nvim ./backup-config/nvim
fi
ln  -dfvs ${work_path}/vim   $HOME/.config/nvim

if [ -a $HOME/.config/pip ]
then
  mv $HOME/.config/pip ./backup-config/pip
fi
ln  -dfvs ${work_path}/pip   $HOME/.config/pip

if [ -a $HOME/.config/yay ]
then
  mv $HOME/.config/yay ./backup-config/yay
fi
ln  -dfvs ${work_path}/yay  $HOME/.config/yay

if [ -a $HOME/.zshrc ]
then
  mv $HOME/.zshrc ./backup-config/.zshrc
fi

ln  -fvs ${work_path}/zsh/.zshrc $HOME/.zshrc

if [ -a $HOME/.yarnrc ]
then
  mv $HOME/.yarnrc ./backup-config/.yarnrc
fi

ln  -fvs ${work_path}/yarn/.yarnrc $HOME/.yarnrc

if ! [ -a $HOME/.cargo ]
then
  mkdir $HOME/.cargo
else
  if [ -a $HOME/.cargo/config ]
  then
    mv $HOME/.yarnrc ./backup-config/.yarnrc
  fi
fi
ln  -fvs ${work_path}/cargo/config $HOME/.cargo/config

if [ -a $HOME/.config/go ]
then
  mv $HOME/.config/go ./backup-config/go
fi
ln  -dfvs ${work_path}/go  $HOME/.config/go
