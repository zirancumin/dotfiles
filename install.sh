#!/usr/bin/env bash
FILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd)"
TARGET_DIR="$HOME/.config"

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -pv "$TARGET_DIR"
fi

for f in "$FILE_DIR/config"/*; do
    filename=$(basename "$f")
    target=$TARGET_DIR/$filename
    if [[ -e $target ]]; then
	echo "$target already exists; do nothing"
        continue
    else
        ln -snvf $f $target
    fi
done

if [[ -e $HOME/.vimrc ]]; then
    echo "$HOME/.vimrc already exists; do nothing"
else
    ln -snvf $FILE_DIR/.vimrc $HOME/.vimrc
fi

if [[ -e $HOME/.emacs.d ]]; then
    echo "$HOME/.emacs.d already exists; do nothing"
else
    ln -snvf $FILE_DIR/.emacs.d $HOME/.emacs.d
fi
