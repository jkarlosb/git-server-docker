# git-server-docker
A lightweight Git Server Docker image built with Alpine Linux. Available on [GitHub](https://github.com/jkarlosb/git-server-docker) and [Docker Hub](https://hub.docker.com/r/jkarlos/git-server-docker/)

### Basic Usage

How to run the container in port 2222 with two volumes, keys volume for public keys and repos volume for git repositories:

	$ docker run -d -p 2222:22 -v /home/jkarlos/git-server/keys:/git-server/keys -v /home/jkarlos/git-server/repos:/git-server/repos jkarlos/git-server-docker

How check that container works (you must to have a key):

	$ ssh git@<ip-docker-server> -p 2222 -v

How clone a repository:

	$ git clone ssh://git@<ip-docker-server>:2222/git-server/repos/myrepo.git

### Arguments

	* **Expose ports**: 22
	* **Volumes**:
	 * */git-server/keys*: Volume to store the users public keys
	 * */git-server/repos*: Volume to store the repositories

### SSH Keys

How generate a pair keys in client machine:

	$ ssh-keygen -t rsa

How upload quickly a public key to host volume:

	$ scp ~/.ssh/id_rsa.pub user@host:/home/jkarlos/git-server/keys

### Build Image

How to make the image:

	$ docker build -t git-server-docker .
