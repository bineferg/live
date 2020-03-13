NAME := $(shell manifest name)
VERSION = $(shell artifact-manager package-version)

ZONE ?= db
COMPONENT ?= dj-booth

CONTAINER_BASENAME=docker.dev.s-cloud.net/live-stream

version:
	echo "$(VERSION)"

live-stream:
	docker build --tag=$(CONTAINER_BASENAME)$* .
	docker tag $(CONTAINER_BASENAME) $(CONTAINER_BASENAME):stable
	docker push $(CONTAINER_BASENAME):stable

publish-deploy:
	sc artifact-manager deploy publish --public --zone $(ZONE)  --pod=config/live-stream-pod.yaml\
		--component=dj-booth \
		--glimpse=rtmp.$(COMPONENT).prod.live-stream \
		--glimpse=http.$(COMPONENT).prod.live-stream \
		--ingress=http://dj-booth.live-stream.lb.db.s-cloud.net:http \
		--ingress=http://dj-booth.int.s-cloud.net:http

deploy:
	artifact-manager deploy run --zone $(ZONE) --component=$(COMPONENT) 
