# git-server-docker
Git Server in Docker with Alpine Linux

### Basic Usage

How to make the image:

	$ docker build -t git-server-docker .

How to run the container in port 2222 with two volumes, keys volumen for public keys and repos volume for git repositories:

	$ docker run -d -p 2222:22 -v /Users/carlos/git-server/keys:/git-server/keys -v /Users/carlos/git-server/repos:/git-server/repos git-server-docker

How check that container works:

	$ ssh git@<ip-docker-server> -p 2222  -v

How clone a repository:

	$ git clone ssh://git@<ip-docker-server>:2222/git-server/repos/myrepo.git






