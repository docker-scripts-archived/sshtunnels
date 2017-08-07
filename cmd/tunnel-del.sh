
cmd_tunnel-del_help() {
    cat <<_EOF
    tunnel-del <server-name> <server-port>
        Delete the keys and scripts of a given ssh tunnel.

_EOF
}

cmd_tunnel-del() {
    # get the arguments
    [ $# -lt 2 ] && fail "Usage:\n$(cmd_tunnel-add_help)"
    local server_name=$1
    local server_port=$2

    # remove the files related to this tunnel
    rm -rf tunnels/$server_name.$server_port/

    update_authorized_keys
}
