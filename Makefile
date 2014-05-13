GIT_VERSION=0.0.11
REVISION=1
VERSION=$(GIT_VERSION)-$(REVISION)
TAG=micktwomey/gamecraft:$(VERSION)

all: build

build:
	sed -e "s^git checkout .*^git checkout $(GIT_VERSION)^" -i "" Dockerfile
	docker build -t $(TAG) .

shell:
	docker run --rm -i -t --entrypoint=/bin/bash $(TAG) -i

test:
	docker run --rm -i -t --entrypoint=/usr/local/bin/django-admin $(TAG) test --settings=gamecraft.settings gamecraft

push:
	docker push $(TAG)
