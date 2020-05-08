FROM alpine:latest

LABEL Maintainer="Frank Ittermann frank.ittermann@yahoo.de"

RUN apk update && \
  apk add --no-cache \
  openssh \
  git

# generate host keys
RUN ssh-keygen -A

WORKDIR /git-server

# -D flag avoids password generation
# -s flag changes user's shell
RUN mkdir /git-server/keys \
  && adduser -D -s /usr/bin/git-shell git \
  && echo git:12345 | chpasswd \
  && mkdir /home/git/.ssh

# This is a login shell for SSH accounts to provide restricted Git access.
# It permits execution only of server-side Git commands implementing the
# pull/push functionality, plus custom commands present in a subdirectory
# named git-shell-commands in the user’s home directory.
# More info: https://git-scm.com/docs/git-shell
COPY git-shell-commands /home/git/git-shell-commands

# sshd_config file is edited for enable access key and disable access password
COPY sshd_config /etc/ssh/sshd_config
COPY start.sh /start.sh
COPY motd /etc

ENV ACCOUNT helmet

EXPOSE 22

CMD ["sh", "/start.sh"]
