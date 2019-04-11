#!/usr/bin/env python3
import re
from pathlib import Path
from subprocess import run, PIPE
from sys import argv


dev_name = argv[1]
HERE = Path.home() / 'dotfiles' / 'music' / 'mpd'
devs = run(['aplay', '-l'], stdout=PIPE).stdout.decode()
dev_lines = devs.strip().split('\n')
for line in dev_lines:
    if dev_name in line:
        card, dev = re.match(r'card\s*(\d+).*device\s*(\d+).*', line).groups()
        break


template = """\
############################################################################
### begin of mpd configuration file
### created by `mpd-configure' (version 0.9.7) on 2018-04-14T16:11:24-04:00.
### see: https://github.com/ronalde/mpd-configure/
############################################################################
## start processing `01_output-audio-alsa.conf'
audio_output {
	type             "alsa"
	name             "Audio - USB Audio"
	# device           "hw:%s,%s"
	auto_resample    "no"
	auto_format      "no"
	auto_channels    "no"
	replay_gain_handler "none"
	# mixer_type                 "none"
}
replaygain                 "off"
## done processing

## start processing `02_paths.conf'
music_directory                   "~/Music"
log_file                          "~/.mpd/log"
playlist_directory                "~/.mpd/playlists/"
pid_file                          "~/.mpd/pid"
state_file                        "~/.mpd/state"
sticker_file                      "~/.mpd/sticker.sql"
save_absolute_paths_in_playlists  "no"
## done processing

## start processing `03_general.conf'
filesystem_charset    "UTF-8"
id3v1_encoding        "UTF-8"
log_level             "default"
auto_update           "yes"
auto_update_depth     "4096"
## done processing

## start processing `04_client-limits.conf'
connection_timeout     "60"
max_connections        "10"
max_playlist_length    "1319154"
max_command_list_size  "164894"
max_output_buffer_size "659577"
## done processing

## start processing `05_network.conf'
bind_to_address "127.0.0.1:6666"
## done processing

## start processing `06_zeroconf.conf'
zeroconf_enabled    "True"
## done processing

############################################################################
### end of mpd configuration file
############################################################################"""

with open(HERE / 'mpd.conf', 'w+') as f:
    f.write(template % (card, dev))
