#!/usr/bin/env bash

kitten themes --reload-in=all Catppuccin-Mocha
sed -i '/# BEGIN_KITTY_THEME/,/# END_KITTY_THEME/ {/^#/!b; /^# BEGIN_KITTY_THEME/b; /^# END_KITTY_THEME/b; d}' "$HOME/.config/kitty/kitty.conf"
