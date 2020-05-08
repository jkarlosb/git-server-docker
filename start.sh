#!/bin/sh

printenv | sort
ls -lha /git-server

# If there is some public key in keys folder
# then it copies its contain in authorized_keys file
if [ "$(ls -A /git-server/.keys/)" ]; then
  cat /git-server/.keys/*.pub > /home/git/.ssh/authorized_keys
  chown -R git:git /home/git/.ssh
  chmod 700 /home/git/.ssh
  chmod -R 600 /home/git/.ssh/*
fi

mkdir /${ACCOUNT}

cd /${ACCOUNT}
for d in /git-server/*/ ; do
    repo=$(basename $d)
    ln -s /git-server/$repo /${ACCOUNT}/$repo.git
done

# -D flag avoids executing sshd as a daemon
if [ -z "$DEBUG" ]
then
    /usr/sbin/sshd -D
else
    /usr/sbin/sshd -D -E /var/log/auth.log
fi
