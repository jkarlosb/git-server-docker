# git-server-docker
A lightweight Git Server Docker image built with Alpine Linux. Available on [GitHub](https://github.com/fr123k/git-server-docker) and [Docker Hub](https://hub.docker.com/r/fr123k/git-server-docker/)

## Use Case

### Local Jenkins use Local Git Repository

The major motivation for the local git server docker container is to provide a way for a local jenkins running in docker to use local git repositories instead of github for example.

The following steps describe a way to use the local git server in jenkins without changing the github url of the jobs in jenkins. They can still point to the original github respositories.

#### Local DNS

Setup a domain like `local.github.com` that is then used by jenkins.

```bash
echo "192.168.65.2 local.github.com" >> /etc/hosts
```

The ip address `192.168.65.2` is specific to your operating system and only works from within a docker container.
**This ip address work on MacOS.**

#### Git Config

Add or change the `%{JENKINS_HOME}/.gitconfig` with the following setting.
```
[url "ssh://git@local.github.com"]
	insteadOf = https://github.com/

[url "ssh://git@local.github.com/"]
	insteadOf = git@github.com:
```

#### Local Github Server

Run the docker git server container on the port 22 (sshd) and specify the github account like `fr123k`.

`docker run -p 22:22 -it -v $(PWD)/../:/git-server `**`-e ACCOUNT=fr123k`**` --name github --rm fr123k/git-server-docker`

If something is not as expected check the [Troubleshooting](#Troubleshooting) section.

## Basic Usage

### Arguments

* **Expose ports**: 22
* **Volumes**:
	* **/git-server/**: Volume to store the repositories
* **Environment Variables**:
	* **ACCOUNT**: Name of the git account
	* **DEBUG**: If exits enable debug logging of the sshd to the file `/var/log/auth.log`. Useful for troubleshooting

### Git Repository Volume

The volume has to be mounted to /git-server mount point.
It has to contain the `.keys` folder with all the public keys
for the ssh authentication.

* -v (local_git_repository):/git-server/

Example mount directory that is above the current one as a git repository.

`docker run -p 2222:22 -it `**`-v $(PWD)/../:/git-server`**` --name github --rm fr123k/git-server-docker`

### Git Account Name

The name of the git repository.
* -e ACCOUNT=(name of the git account) default: helmet

For example
`docker run -p 2222:22 -it -v $(PWD)/../:/git-server `**`-e ACCOUNT=fr123k`**` --name github --rm fr123k/git-server-docker`

### Git Account Name

The name of the git repository.
* -e DEBUG=true

For example
`docker run -p 2222:22 -it -v $(PWD)/../:/git-server `**`-e DEBUG=true`**` --name github --rm fr123k/git-server-docker`

### Local SSH Git Server

How to run the container in port 22 (sshd).

`docker run -d -p `**`22:22`**` -v ~/git-server/repos:/git-server/ fr123k/git-server-docker/`

### Local Git Repositories

**After adding git repository described below the docker container has to be always restarted.**
How to create a new repo:

```bash
mkdir local-git-repo
cd local-git-repo/
git init --shared=true
git add .
git commit -m "my first commit"
```

How to upload a repo:

From host:
```bash
mv local-git-repo ~/git-server/
```
From remote:
```bash
scp -r local-git-repo user@host:~/git-server/
```

How clone a repository:

```bash
git clone ssh://git@127.0.0.1:22/helmet/local-git-repo.git
```

## Troubleshooting

### Validate Local SSH Git Server

How to check that container and the authentication keys works.
`ssh git@127.0.0.1 -p 22`
The expected output looks like this.
```
Welcome to git-server-docker!

Provided to you from

https://hub.docker.com/r/fr123k/git-server-docker/
https://github.com/fr123k/git-server-docker

You've successfully authenticated, but I do not
provide interactive shell access.
Connection to 127.0.0.1 closed.
```

### SSH Keys

How generate a pair keys in client machine:

```bash
ssh-keygen -t rsa
```

How upload quickly a public key to host volume:

```bash
scp ~/.ssh/id_rsa.pub user@host:~/git-server/.keys
```

## Docker Image

All `make` commands can only be from the folder where the Makefile is located.

### Build

How to build the docker image:

```bash
make build
```
or
```bash
docker build -t git-server-docker .
```

### Run

How to run the image:

```bash
make REPOSITORIES=$(PWD)/../ ACCOUNT=fr123k git-server
```
or
```bash
docker run -p 22:22 -it -v $(PWD)/../ :/git-server -e ACCOUNT=fr123k --name github --rm "fr123k/git-server-docker"
```

# Todo

* support multiple accounts
