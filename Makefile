build:
	docker build -t bcw222/action-kaniko .

run: build
	docker run \
		-v $(shell pwd):/tmp \
		-e GITHUB_REPOSITORY \
		-e GITHUB_REF \
		-e GITHUB_ACTOR \
		-e GITHUB_TOKEN \
		-e GITHUB_WORKSPACE="/tmp" \
		-e INPUT_IMAGE \
		-e INPUT_CACHE \
		-e INPUT_CACHE_TTL \
		-e INPUT_CACHE_REGISTRY \
		-e INPUT_STRIP_TAG_PREFIX \
		-e INPUT_SKIP_UNCHANGED_DIGEST \
	bcw222/action-kaniko

shell: build
	docker run \
		-ti \
		--entrypoint sh \
	bcw222/action-kaniko
