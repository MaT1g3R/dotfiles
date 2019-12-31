function yt-play
    youtube-dl $1 -o - | mpv -
end
