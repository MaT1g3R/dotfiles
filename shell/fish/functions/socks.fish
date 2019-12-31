#!/usr/bin/fish
function socks-on --description "set socks proxy on HOST PORT"
    set host $argv[1]
    set port $argv[2]
    set usage "Usage: socks-on HOST PORT"
    if [ -z $host ] || [ $host = "" ]
        echo $usage
        return 1
    end
    if [ -z $port ] || [ $port = "" ]
        echo $usage
        return 1
    end
    echo turning on socks proxy to $host:$port
    set running_pid (ps ax | rg "ssh -D $port -f -C -q -N $host" | rg -v rg | awk '{ print $1 }')
    if [ -z $running_pid ] || [ "$running_pid" = "" ]
        echo ssh tunnel not running, establishing connection
        ssh -D $port -f -C -q -N $host
    else
        echo ssh tunnel already running
    end
    set -U -x http_proxy socks5://127.0.0.1:$port
    set -U -x https_proxy $http_proxy
end

function socks-off
    echo turning off socks proxy
    # kill all pids running ssh tunnels
    for pid in (ps ax | rg "ssh -D" | rg -v rg | awk '{ print $1 }')
        kill $pid
    end
    set -e http_proxy
    set -e https_proxy
end
