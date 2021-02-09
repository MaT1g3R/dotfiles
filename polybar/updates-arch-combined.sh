#!/bin/sh

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

# if ! updates_aur=$(cower -u 2> /dev/null | wc -l); then
if ! updates_aur=$(yay -Su --aur --quiet | wc -l); then
    updates_aur=0
fi

echo $updates_arch  $updates_aur
