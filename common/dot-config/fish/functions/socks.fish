#!/usr/bin/fish
function socks-on --description "set socks5 proxy on HOST PORT" -a host port
    set usage "Usage: socks-on HOST PORT"
    if [ -z "$host" ]
        echo $usage
        return 1
    end
    if [ -z "$port" ]
        echo $usage
        return 1
    end
    echo turning on socks proxy to $host:$port
    set running_pid (ps ax | rg "ssh -D $port -f -C -q -N $host" | rg -v rg | awk '{ print $1 }')
    if [ -z "$running_pid" ]
        echo ssh tunnel not running, establishing connection
        ssh -D $port -f -C -q -N $host
    else
        echo ssh tunnel already running
    end
    set -U -x http_proxy socks5://127.0.0.1:$port
    set -U -x https_proxy $http_proxy

    # set gcloud proxy
    gcloud config set proxy/type socks5
    gcloud config set proxy/address 127.0.0.1
    gcloud config set proxy/port $port
end

function socks-off --description "turn off socks5 proxy and kill all ssh tunnels"
    echo turning off socks proxy
    # kill all running ssh tunnels
    for pid in (ps ax | rg "ssh -D" | rg -v rg | awk '{ print $1 }')
        kill $pid
    end
    set -e http_proxy
    set -e https_proxy

    # unset gcloud proxy
    gcloud config unset proxy/type
    gcloud config unset proxy/address
    gcloud config unset proxy/port
end
