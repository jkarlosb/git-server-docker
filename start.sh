#!/bin/sh

cd /home/git

# If there is some public key in keys folder
# then it copies its contain in authorized_keys file
if [ "$(ls -A /git-server/keys/)" ]; then
  cat /git-server/keys/*.pub > .ssh/authorized_keys
  chown -R git:git .ssh
  chmod 700 .ssh
  chmod -R 600 .ssh/*
fi

# -D flag avoids executing sshd as a daemon
/usr/sbin/sshd -D
