ssh tunnels
===========

These scripts help to create ssh tunnels between two computers that
don't have public IP.  One of them is called the **server** because it
shares a port through the ssh tunnel, and the other one is the
**client** because it connects to that port on the server through the
ssh tunnel. This is done with the help of a **proxy** server which has
a public IP, and can be seen from both parts, and acts as an
intermediary between them. These scripts are installed on the proxy
server.


```
                           PROXY_SSH_PORT=2221
                          +------------------+
            +------>----->|  PROXY_PORT=2475 |<-----<---+
            | +------<-----------<---------<----------+ |
            | | +-->----->|                  |<-----+ | |
            | | |         +------------------+      | | |
            | | |               PROXY               | | |
            | | |                                   | | |
            | | |                                   | | |
            | | | SERVER                     CLIENT | | |
     +------+ | +-----+                      +------+ | +------+
     | SERVER_PORT=22 |                      | CLIENT_PORT=2201|
     |  port-share.sh |                      |  port-connect.sh|
     +----------------+                      +-----------------+
                                         ssh -p 2201 user@localhost
```

For more details about sshtunnels see: http://dashohoxha.fs.al/sshtunnels/


## Installation

  - First install `ds`:
     + https://github.com/docker-scripts/ds#installation

  - Then get the scripts from github: `ds pull sshtunnels`

  - Create a directory for the container: `ds init sshtunnels @ssht`

  - Fix the settings:
    ```
    cd /var/ds/ssht/
    vim settings.sh
    ds info
    ```

  - Build image, create the container and configure it:
    ```
    ds build
    ds create
    ds config
    ```


## Usage

  - Create tunnels:
    ```
    cd /var/ds/ssht/
    ds tunnel-add server1 22
    ds tunnel-add server1 1022
    ds tunnel-add server1 443
    ds tunnel-add server2 22
    ```

  - Copy to **server1** the scripts
    `tunnels/server1.22.port-share.sh`,
    `tunnels/server1.1022.port-share.sh` and
    `tunnels/server1.443.port-share.sh` and run them. Copy to
    **server2** the script `tunnels/server2.22.port-share.sh` and run
    it. These will open the ssh tunnel from the server side, and watch
    it, and try to keep it always open.

  - Copy to a client computer the scripts
    `tunnels/server1.22.port-connect.sh`,
    `tunnels/server2.22.port-connect.sh`, etc. and try them like this:
    ```
    server1.22.port-connect.sh 2201
    server2.22.port-connect.sh 2202
    ssh -p 2201 user1@localhost
    ssh -p 2202 user2@localhost
    ```

    The first two commands will establish the ssh tunnel from the
    client side. Then, the following `ssh` commands will try to login
    through the ssh tunnel to the accounts **user1@server1** and
    **user2@server2**.
