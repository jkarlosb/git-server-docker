FROM alpine:3.4

MAINTAINER José Carlos Bernárdez "jkarlosb@gmail.com"

# --no-cache es nuevo en Alpine 3.3 y evita tener que utilizar
# --update + rm -rf /var/cache/apk/* (borrar el caché)
RUN apk add --no-cache \
  openssh \
  git

# Generamos las claves del servidor
RUN ssh-keygen -A

# Para que ssh se auto-arranque
# RUN rc-update add sshd

WORKDIR /git-server/

# Con -D no creamos password, con -s le cambiamos la shell
RUN mkdir /git-server/keys \
  && adduser -D -s /usr/bin/git-shell git \
  && mkdir /home/git/.ssh

COPY sshd_config /etc/ssh/sshd_config
COPY start.sh start.sh

EXPOSE 22

CMD ["sh", "start.sh"]
