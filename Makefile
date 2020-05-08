
VERSION=1.0.0
ACCOUNT?=fr123k
REPOSITORIES?=$(PWD)/../
export NAME=fr123k/git-server-docker
export IMAGE="${NAME}:${VERSION}"
export LATEST="${NAME}:latest"

build: ## Build the jenkins in docker image.
	docker build -t $(IMAGE) -f Dockerfile .

release: build ## Push docker image to docker hub
	docker tag ${IMAGE} ${LATEST}
	docker push ${NAME}

git-server:
	docker run -p 22:22 -it -v $(REPOSITORIES):/git-server -e ACCOUNT=$(ACCOUNT) --name github --rm ${IMAGE}
