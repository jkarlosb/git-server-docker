# git-server-docker
A lightweight Git Server Docker image built with Alpine Linux. Available on [GitHub](https://github.com/jkarlosb/git-server-docker).

### Basic Usage

How to make the image:

	$ docker build -t git-server-docker .

How to run the container in port 2222 with two volumes, keys volumen for public keys and repos volume for git repositories:

	$ docker run -d -p 2222:22 -v /home/jkarlos/git-server/keys:/git-server/keys -v /home/jkarlos/git-server/repos:/git-server/repos jkarlos/git-server-docker

How check that container works:

	$ ssh git@<ip-docker-server> -p 2222 -v

How clone a repository:

	$ git clone ssh://git@<ip-docker-server>:2222/git-server/repos/myrepo.git

How generate a pair keys in client machine:

	$ ssh-keygen -t rsa

How upload quickly a public key:

	$ scp ~/.ssh/id_rsa.pub user@host:/home/jkarlos/git-server/keys
