DIR_NAME := $(shell pwd | sed -n '{s@.*/@@; p}')
IMAGE_NAME = microfpga-$(DIR_NAME)
IMAGE_TAG = 0.1

CONTAINER_NAME = $(IMAGE_NAME)

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run:
	docker run --rm --privileged -it \
	-v $(shell pwd)/.micro/:/root/config/micro \
	-v $(shell pwd)/prj/:/root/prj \
	--name $(CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)

stop:
	docker stop $(CONTAINER_NAME)

inspect:
	docker exec -it $(CONTAINER_NAME) /bin/bash

clean:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: clean build run stop inspect