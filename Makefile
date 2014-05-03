TAG=micktwomey/gamecraft

all: build

build:
	docker build -t $(TAG) .

shell:
	docker run --rm $(MOUNTS) $(LINKS) -i -t --entrypoint=/bin/bash $(TAG) -i
