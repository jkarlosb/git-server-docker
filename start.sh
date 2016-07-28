#!/bin/sh

cd /home/git

# Si hay alguna clave pública en la carpeta de keys
# copia su contenido en authorized_keys
if [ "$(ls -A /git-server/keys/)" ]; then
  cat /git-server/keys/*.pub > .ssh/authorized_keys
  chown -R git:git .ssh
  chmod 700 .ssh
  chmod -R 600 .ssh/*
fi

# Bandera -D para que no se ejecute como demonio
/usr/sbin/sshd -D
