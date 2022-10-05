DOCKER_USER := github-runner
COMMIT_TAG := $(shell git rev-parse --short HEAD)
include ENV

export
default:
	docker build . -t $(REPO).artifactory.sonos.com/$(IMAGE):$(COMMIT_TAG) --no-cache --network=host
	curl http://localhost:8200/v1/artifactory/token/github-runner | jq -r .data.access_token | docker login $(REPO).artifactory.sonos.com -u ${DOCKER_USER} --password-stdin
	docker push $(REPO).artifactory.sonos.com/$(IMAGE):$(COMMIT_TAG)
	docker tag $(REPO).artifactory.sonos.com/$(IMAGE):$(COMMIT_TAG) $(REPO).artifactory.sonos.com/$(IMAGE):$(VERSION)
	docker push $(REPO).artifactory.sonos.com/$(IMAGE):$(VERSION)
	docker tag $(REPO).artifactory.sonos.com/$(IMAGE):$(COMMIT_TAG) $(REPO).artifactory.sonos.com/$(IMAGE):latest
	docker push $(REPO).artifactory.sonos.com/$(IMAGE):latest
