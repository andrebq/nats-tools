.PHONY: build run run-host

tag?=latest
build:
	docker build -t andrebq/nats-tools:$(tag) .

push-github-registry: build
	echo $$GITHUB_TOKEN | docker login ghcr.io -u andrebq --password-stdin
	docker tag andrebq/nats-tools:$(tag) ghcr.io/andrebq/nats-tools:$(tag)
	docker push ghcr.io/andrebq/nats-tools:$(tag)

cmd?=sh
run: build
	docker run --rm -ti andrebq/nats-tools:latest $(cmd)

run-host: build
	docker run --rm -ti --network=host andrebq/nats-tools:latest $(cmd)
