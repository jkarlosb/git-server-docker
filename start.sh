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

# add ${ACCOUNT} user to support git clone for https://github.com/account as well.
adduser -D --home /home/${ACCOUNT} --shell /bin/sh ${ACCOUNT}
PASSWORD=$(date | md5sum | cut -d " " -f 0)
echo "${ACCOUNT}:${PASSWORD}" | chpasswd
addgroup ${ACCOUNT} git

if [ "$(ls -A /git-server/.keys/)" ]; then
  mkdir /home/${ACCOUNT}/.ssh
  cat /git-server/.keys/*.pub > /home/${ACCOUNT}/.ssh/authorized_keys
  chown -R ${ACCOUNT}:git /home/${ACCOUNT}/.ssh
  chmod 700 /home/${ACCOUNT}/.ssh
  chmod -R 600 /home/${ACCOUNT}/.ssh/*
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
