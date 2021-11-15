DIR_NAME := $(shell cd .. && pwd | sed -n '{s@.*/@@; p}')
IMAGE_NAME = $(DIR_NAME)
IMAGE_TAG = 0.1

CONTAINER_NAME = $(IMAGE_NAME)

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

create:
	docker run --privileged -it \
	-v $(shell pwd)/micro/:/root/config/micro \
	-v $(shell pwd)/../:/root/prj \
	--name $(CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)

start:
	docker start $(CONTAINER_NAME)

stop:
	docker stop $(CONTAINER_NAME)

inspect:
	docker exec -it $(CONTAINER_NAME) /bin/bash

clean:
	docker rm $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: clean build run stop inspect