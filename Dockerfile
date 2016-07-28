FROM alpine:3.4

MAINTAINER José Carlos Bernárdez "jkarlosb@gmail.com"

# --no-cache es nuevo en Alpine 3.3 y evita tener que utilizar
# --update + rm -rf /var/cache/apk/* (borrar el caché)
RUN apk add --no-cache \
  openssh=7.2_p2-r1 \
  git=2.8.3-r0

# Generamos las claves del servidor
RUN ssh-keygen -A

# Para que ssh se auto-arranque
# RUN rc-update add sshd

WORKDIR /git-server/

# Con -D no creamos password, con -s le cambiamos la shell
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

# En sshd_config habilitamos acceso por key y deshabilitamos por password
COPY sshd_config /etc/ssh/sshd_config
COPY start.sh start.sh

EXPOSE 22

CMD ["sh", "start.sh"]
