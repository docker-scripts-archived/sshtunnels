#!/bin/bash -x

### create a user 'sshtunnel'
useradd --system --create-home sshtunnel
mkdir -p /home/sshtunnel/.ssh
chown sshtunnel:sshtunnel /home/sshtunnel/.ssh
chmod 700 /home/sshtunnel/.ssh

### create a script to update /home/sshtunnel/.ssh/authorized_keys inside the container
cat <<'EOF' > /usr/local/sbin/update-authorized-keys.sh
#!/bin/bash
keys=/home/sshtunnel/.ssh/authorized_keys
cat /home/sshtunnel/tunnels/*/key.pub > $keys 2>/dev/null
chown sshtunnel:sshtunnel $keys
chmod 600 $keys
EOF
chmod +x /usr/local/sbin/update-authorized-keys.sh

### customize the configuration of sshd
sed -i /etc/ssh/sshd_config \
    -e 's/^GatewayPorts/#GatewayPorts/' \
    -e 's/^PermitRootLogin/#PermitRootLogin/' \
    -e 's/^PasswordAuthentication/#PasswordAuthentication/' \
    -e 's/^X11Forwarding/#X11Forwarding/' \
    -e 's/^UseLogin/#UseLogin/' \
    -e 's/^AllowUsers/#AllowUsers/'

sed -i /etc/ssh/sshd_config \
    -e '/^### sshtunnel config/,$ d'

cat <<EOF >> /etc/ssh/sshd_config
### sshtunnel config
GatewayPorts yes
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
UseLogin no
AllowUsers sshtunnel
EOF

### modify ssmtp config files
[[ -n $GMAIL_ADDRESS ]] && cat <<_EOF >> /etc/ssmtp/revaliases
sshtunnel:$GMAIL_ADDRESS:smtp.gmail.com:587
_EOF
