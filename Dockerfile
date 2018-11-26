FROM    alpine:3.8

LABEL   maintainer='Carlos Bernárdez <carlos@z4studios.com>'

RUN     apk add --no-cache openssh git

WORKDIR /git-server/

RUN     mkdir -p keys-host/etc/ssh && \
        ssh-keygen -A -f keys-host  && \
        mv keys-host/etc/ssh/* keys-host && \
        rm -rf keys-host/etc

# -D flag avoids password generation
# -s flag changes user's shell
RUN     mkdir keys && \
        adduser -D -s /usr/bin/git-shell git && \
        echo git:12345 | chpasswd && \
        mkdir /home/git/.ssh

# This is a login shell for SSH accounts to provide restricted Git access.
# It permits execution only of server-side Git commands implementing the
# pull/push functionality, plus custom commands present in a subdirectory
# named git-shell-commands in the user’s home directory.
# More info: https://git-scm.com/docs/git-shell
COPY    git-shell-commands /home/git/git-shell-commands

RUN     echo '' > /etc/motd

# sshd_config file is edited for enable access key and disable access password
COPY    sshd_config /etc/ssh/sshd_config

COPY    start.sh start.sh

EXPOSE  22

VOLUME  ["/git/server/keys", "/git-server/keys-host", "/git-server/repos"]

CMD     ["sh", "start.sh"]
