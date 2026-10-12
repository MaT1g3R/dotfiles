#!/bin/sh
set -e
btrfs subvolume snapshot / "/snapshots/@root-auto-$(date --iso-8601)"
if [ "$(echo /snapshots/* | wc -w)" -gt 7 ]; then
    delete="$(echo /snapshots/* | cut -d ' ' -f1)"
    if [ -n "$delete" ]; then
        btrfs subvolume delete "$delete"
    fi
fi
