APP=sshtunnels
IMAGE=sshtunnels
CONTAINER=sshtunnels

PROXY_SERVER=sshtunnels.example.org    ### or IP of the proxy server
PROXY_SSH_PORT=22022

PORTS="$PROXY_SSH_PORT:22"

### Gmail account for notifications. This will be used by ssmtp.
### You need to create an application specific password for your account:
### https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882
GMAIL_ADDRESS=
GMAIL_PASSWD=
