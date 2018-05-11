cmd_create_help() {
    cat <<_EOF
    create
        Create the wsproxy container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    mkdir -p tunnels
    orig_cmd_create \
        --mount type=bind,src=$(pwd)/tunnels,dst=/home/sshtunnel/tunnels
}
