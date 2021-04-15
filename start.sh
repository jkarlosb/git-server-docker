#!/bin/sh

# copy kyes and repos to /git-server/keys and /git-server/repos
cp -R /keys/* /git-server/keys/
cp -R /http /git-server/repos/

# copy its pub keys in authorized_keys file
cd /home/git
cat /git-server/keys/*.pub > .ssh/authorized_keys
chown -R git:git .ssh
chmod 700 .ssh
chmod -R 600 .ssh/*

# Checking permissions and fixing SGID bit in repos folder
# More info: https://github.com/jkarlosb/git-server-docker/issues/1
cd /git-server/repos
chown -R git:git .
chmod -R ug+rwX .
find . -type d -exec chmod g+s '{}' +

# -D flag avoids executing sshd as a daemon
/usr/sbin/sshd -D
