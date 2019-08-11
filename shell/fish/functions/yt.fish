function yt-play
    youtube-dl $1 -o - | mpv -
end

function yt-best
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 $1

