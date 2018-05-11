APP=sshtunnels
IMAGE=sshtunnels
CONTAINER=sshtunnels

PROXY_SERVER=sshtunnels.example.org    ### or IP of the proxy server
PROXY_SSH_PORT=22022

PORTS="$PROXY_SSH_PORT:22"

### email account for sending server notifications
GMAIL_ADDRESS=
GMAIL_PASSWD=
