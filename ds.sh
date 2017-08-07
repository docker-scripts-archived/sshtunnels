
rename_function cmd_start orig_cmd_start
cmd_start() {
    orig_cmd_start && sleep 3 && update_authorized_keys
}

rename_function cmd_restart orig_cmd_restart
cmd_restart() {
    orig_cmd_restart && sleep 3 && update_authorized_keys
}

update_authorized_keys() {
    ds exec /usr/local/sbin/update-authorized-keys.sh
}
