
cmd_tunnel-add_help() {
    cat <<_EOF
    tunnel-add <server-name> <server-port>
        Create the keys and scripts that are needed to create
        a ssh tunnel to a port on a remote server.

        The parameter <server-name> can be anything and is used
        to identify a server from the others.

        The parameter <server-port> is the port on the server
        that is made available through the ssh tunnel (can be 22
        or anything else).

_EOF
}

cmd_tunnel-add() {
    # get the arguments
    [ $# -lt 2 ] && fail "Usage:\n$(cmd_tunnel-add_help)"
    local server_name=$1
    local server_port=$2

    # delete the tunnel first, if it exists
    ds tunnel-del $server_name $server_port

    # find an unused port on the proxy server
    cat tunnels/*/port > tunnels/ports.txt 2>/dev/null
    local proxy_port=$(shuf -i 1025-65535 -n 1)
    while grep -qs $proxy_port tunnels/ports.txt; do
        proxy_port=$(shuf -i 1025-65535 -n 1)
    done
    rm tunnels/ports.txt
    mkdir -p tunnels/$server_name.$server_port/
    echo $proxy_port > tunnels/$server_name.$server_port/port

    # generate the key pair
    local keyfile=tunnels/$server_name.$server_port/key
    ssh-keygen -t rsa -f $keyfile -q -N ''

    # put some restrictions on the public key
    local restrictions='command="netstat -an | egrep 'tcp.*:$proxy_port.*LISTEN'",no-agent-forwarding,no-user-rc,no-X11-forwarding,permitopen="localhost:'$proxy_port'"'
    sed -e "s#^#$restrictions #" -i $keyfile.pub

    update_authorized_keys

    # build the script that starts the tunnel on the server side
    local port_share=tunnels/$server_name.$server_port/port-share.sh
    cp $APP_DIR/misc/port-share.sh $port_share
    sed -i $port_share \
        -e "/^PROXY_SSH_PORT=/ c PROXY_SSH_PORT=$PROXY_SSH_PORT" \
        -e "/^PROXY_PORT=/ c PROXY_PORT=$proxy_port" \
        -e "/^SERVER_PORT=/ c SERVER_PORT=$server_port" \
        -e "/^proxy_user=/ c proxy_user=sshtunnel" \
        -e "/^proxy_server=/ c proxy_server=$PROXY_SERVER" \
        -e "/-----BEGIN RSA PRIVATE KEY-----/,$ d"
    cat $keyfile >> $port_share

    # build the script that starts the tunnel on the client side
    local port_connect=tunnels/$server_name.$server_port/port-connect.sh
    cp $APP_DIR/misc/port-connect.sh $port_connect
    sed -i $port_connect \
        -e "/^PROXY_SSH_PORT=/ c PROXY_SSH_PORT=$PROXY_SSH_PORT" \
        -e "/^PROXY_PORT=/ c PROXY_PORT=$proxy_port" \
        -e "/^proxy_user=/ c proxy_user=sshtunnel" \
        -e "/^proxy_server=/ c proxy_server=$PROXY_SERVER" \
        -e "/-----BEGIN RSA PRIVATE KEY-----/,$ d"
    cat $keyfile >> $port_connect
}
