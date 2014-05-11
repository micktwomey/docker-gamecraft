GIT_VERSION=0.0.9
REVISION=2
VERSION=$(GIT_VERSION)-$(REVISION)
TAG=micktwomey/gamecraft:$(VERSION)

all: build

build:
	sed -i -s "s/git checkout .*/git checkout $(GIT_VERSION)/" Dockerfile
	docker build -t $(TAG) .

shell:
	docker run --rm $(MOUNTS) $(LINKS) -i -t --entrypoint=/bin/bash $(TAG) -i

push:
	docker push $(TAG)
