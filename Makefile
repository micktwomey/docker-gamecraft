VERSION=0.0.9
TAG=micktwomey/gamecraft:$(VERSION)

all: build

build:
	sed -i -s "s/git checkout .*/git checkout $(VERSION)/" Dockerfile
	docker build -t $(TAG) .

shell:
	docker run --rm $(MOUNTS) $(LINKS) -i -t --entrypoint=/bin/bash $(TAG) -i
