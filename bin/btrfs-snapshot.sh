#!/bin/sh
btrfs subvolume snapshot / /snapshots/@root-auto-$(date --iso-8601)
