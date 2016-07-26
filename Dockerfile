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

# COn -D no creamos password, con -s le cambiamos la shell
RUN adduser -D git \
  && su git \
  && mkdir .ssh \
  && deluser git \
  && adduser -D -s /usr/bin/git-shell git \
  && exit \
  && cat /cert/*.pub > .ssh/authorized_keys

EXPOSE 22

# Bandera -D para que no se ejecute como demonio
CMD ["/usr/sbin/sshd", "-D"]
