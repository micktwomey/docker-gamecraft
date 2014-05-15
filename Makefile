GIT_VERSION=0.0.14
REVISION=1
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
	git push origin master
	git push --tags origin
	docker push $(TAG)
	docker push micktwomey/gamecraft:latest
