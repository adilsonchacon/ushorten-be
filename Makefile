ifneq (,$(wildcard ./.env))
	include .env
	export
endif

build:
ifdef VERSION
	docker build --rm \
		--build-arg DATABASE_URL=$(DATABASE_URL) \
		--build-arg SECRET_KEY_BASE=$(SECRET_KEY_BASE) \
		--build-arg MIX_ENV=prod \
		--build-arg GOOGLE_RECAPTCHA_API_URL=$(GOOGLE_RECAPTCHA_API_URL) \
		--build-arg GOOGLE_RECAPTCHA_PUBLIC_KEY=$(GOOGLE_RECAPTCHA_PUBLIC_KEY) \
		--build-arg GOOGLE_RECAPTCHA_SECRET_KEY=$(GOOGLE_RECAPTCHA_SECRET_KEY) \
		-t $(IMAGE_NAME):$(VERSION) .
else
	echo "VERSION not defined"
endif

start:
ifdef DATABASE_URL
ifdef SECRET_KEY_BASE
	docker run -d \
    --network $(NETWORK) \
		-p $(EXPOSED_PORT):$(APP_PORT) \
		-e DATABASE_URL=$(DATABASE_URL) \
		-e SECRET_KEY_BASE=$(SECRET_KEY_BASE) \
		-e MIX_ENV=prod \
		-e GOOGLE_RECAPTCHA_API_URL=$(GOOGLE_RECAPTCHA_API_URL) \
		-e GOOGLE_RECAPTCHA_PUBLIC_KEY=$(GOOGLE_RECAPTCHA_PUBLIC_KEY) \
		-e GOOGLE_RECAPTCHA_SECRET_KEY=$(GOOGLE_RECAPTCHA_SECRET_KEY) \
		--name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION)
else
	echo "SECRET_KEY_BASE not defined"
endif
else
	echo "DATABASE_URL not defined"
endif

restart:
ifdef DATABASE_URL
ifdef SECRET_KEY_BASE
	docker stop $(CONTAINER_NAME) && \
	docker rm $(CONTAINER_NAME) && \
	docker run -d \
    --network $(NETWORK) \
		-p $(EXPOSED_PORT):$(APP_PORT) \
		-e DATABASE_URL=$(DATABASE_URL) \
		-e SECRET_KEY_BASE=$(SECRET_KEY_BASE) \
		-e MIX_ENV=prod \
		-e GOOGLE_RECAPTCHA_API_URL=$(GOOGLE_RECAPTCHA_API_URL) \
		-e GOOGLE_RECAPTCHA_PUBLIC_KEY=$(GOOGLE_RECAPTCHA_PUBLIC_KEY) \
		-e GOOGLE_RECAPTCHA_SECRET_KEY=$(GOOGLE_RECAPTCHA_SECRET_KEY) \
		--name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION)
else
	echo "SECRET_KEY_BASE not defined"
endif
else
	echo "DATABASE_URL not defined"
endif

remove:
	docker stop $(CONTAINER_NAME) || true && docker rm $(CONTAINER_NAME) || true

test_app:
	mix test

exec:
	docker container exec -it \
		$(CONTAINER_NAME) sh

logs:
	docker container logs --follow --tail 100 \
		$(CONTAINER_NAME)

login:
	echo $(REGISTRY_PASSWORD) | docker login -u $(REGISTRY_USER) --password-stdin $(REGISTRY)

push:
	docker push $(IMAGE_NAME):$(VERSION)

latest:
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest
