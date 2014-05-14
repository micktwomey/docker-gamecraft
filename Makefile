GIT_VERSION=0.0.12
REVISION=2
VERSION=$(GIT_VERSION)-$(REVISION)
TAG=micktwomey/gamecraft:$(VERSION)

all: build

build:
	sed -e "s^git checkout .*^git checkout $(GIT_VERSION)^" -i "" Dockerfile
	docker build -t $(TAG) .
	docker tag $(TAG) micktwomey/gamecraft:latest

shell:
	docker run --rm -i -t --entrypoint=/bin/bash $(TAG) -i

test:
	docker run --rm -i -t --entrypoint=/usr/local/bin/django-admin $(TAG) test --settings=gamecraft.settings gamecraft

push:
	docker push $(TAG)
	docker push micktwomey/gamecraft:latest
