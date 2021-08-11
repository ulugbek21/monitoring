CURRENT_DIR=$(shell pwd)

export BASE_PROMETHEUS_PATH = $(if $(DOCKER_HOST),$(REMOTE_PROMETHEUS_PATH),$(LOCAL_PROMETHEUS_PATH))
export BASE_ALERTMANAGER_PATH = $(if $(DOCKER_HOST),$(REMOTE_ALERTMANAGER_PATH),$(LOCAL_ALERTMANAGER_PATH))
export BASE_BLACKBOXPROBER_PATH = $(if $(DOCKER_HOST),$(REMOTE_BLACKBOXPROBER_PATH),$(LOCAL_BLACKBOXPROBER_PATH))

ifneq (,$(wildcard ./.env))
	include .env
endif

sync:
	docker-machine scp -d -r ./monitoring/prometheus/ $(SSH_USER)@$(MACHINE_NAME):$(REMOTE_PROMETHEUS_PATH)
	docker-machine scp -d -r ./monitoring/alertmanager/ $(SSH_USER)@$(MACHINE_NAME):$(REMOTE_ALERTMANAGER_PATH)
	docker-machine scp -d -r ./monitoring/blackboxprober/ $(SSH_USER)@$(MACHINE_NAME):$(REMOTE_BLACKBOXPROBER_PATH)

up:
	$(if $(DOCKER_HOST), make sync,)
	docker-compose -f monitoring/docker-compose.yml up -d --build --remove-orphans

restart:
	$(if $(DOCKER_HOST), make sync,)
	docker-compose -f monitoring/docker-compose.yml restart

down:
	docker-compose -f monitoring/docker-compose.yml down

create-env:
	cp ./env.example ./.env

set-env:
	./scripts/set-env.sh ${CURRENT_DIR}

copy-sample-configs:
	cp monitoring/blackboxprober/config.sample.yml monitoring/blackboxprober/config.yml && \
	cp monitoring/alertmanager/config.sample.yml monitoring/alertmanager/config.yml && \
	cp monitoring/prometheus/prometheus.sample.yml monitoring/prometheus/prometheus.yml && \
	cp monitoring/prometheus/service.sample.yml monitoring/prometheus/service.yml