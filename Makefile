
BUILD_TAG = 1.6-r0

COMPONENT := alpine-build-dev-haproxy
IMAGE = aledbf/$(COMPONENT):$(BUILD_TAG)
BUILD_IMAGE := $(COMPONENT)-build

build:
	docker build -t $(BUILD_IMAGE) .
	docker cp `docker run --name $(BUILD_IMAGE) -d $(BUILD_IMAGE) /bin/sh`:/work/haproxy/x86_64/haproxy-$(BUILD_TAG).apk .
	docker rm -f $(BUILD_IMAGE)

clean:
	rm -f haproxy*.gz
	docker rmi $(BUILD_IMAGE)

release: build
	rm -rf release && mkdir release
	cp haproxy*.apk release
	gh-release create $(IMAGE) $(BUILD_TAG) $(shell git rev-parse --abbrev-ref HEAD)
