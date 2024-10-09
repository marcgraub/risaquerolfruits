## --------------------------------------------------------------------------------
## |
.PHONY: help
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

## |	build-prod		build the images defined in the docker-compose file for the production server
## |
.PHONY: build-prod
build-prod:
	@docker-compose --file docker-compose-prod.yml build --pull
	@docker image prune -f

## |	build-prod		build the images defined in the docker-compose file for development
## |
.PHONY: build-dev
build-dev:
	@docker-compose --file docker-compose-dev.yml build --pull
	@docker image prune -f

## |	deploy-dev		deploys all the stack to run this project in development mode
## |
.PHONY: deploy-dev
deploy-dev:
	@docker stack deploy -c docker-compose-dev.yml risa-querol

## |	deploy-prod		deploys all the stack to run this project in production mode
## |
.PHONY: deploy-prod
deploy-prod:
	@docker stack deploy -c docker-compose-prod.yml risa-querol

## |	undeploy		remove all the stack
## |
.PHONY: undeploy
undeploy:
	@docker stack rm risa-querol

## |	make caddy-comm 	COMMAND= execute a command in the caddy container
## |	  				Example: make caddy-comm COMMAND="ls"
## |
.PHONY: caddy-comm
caddy-comm:
	@./docker/utils/execute-command caddy root "/bin/sh -c" "$(COMMAND)"

## |	caddy-term		enter in the caddy shell container
## |
.PHONY: caddy-term
caddy-term:
	@./docker/utils/term caddy /bin/sh ||:

## |	make caddy-kill		kill the caddy container
## |
.PHONY: caddy-kill
caddy-kill:
	@./docker/utils/docker-kill caddy

## |	make caddy-logs		show the caddy container logs
## |
.PHONY: caddy-logs
caddy-logs:
	@./docker/utils/docker-logs caddy

## |	caddy-reload		reload the caddy file
## |
.PHONY: caddy-reload
caddy-reload:
	@$(MAKE) -s caddy-comm COMMAND="caddy reload --config /etc/caddy/Caddyfile"

## |	make php-comm 		COMMAND= execute a command in the php container
## |	  				Example: make php-comm COMMAND="ls"
## |
.PHONY: php-comm
php-comm:
	@./docker/utils/execute-command php root "/bin/bash" "$(COMMAND)"

## |	php-term		enter in the php shell container
## |
.PHONY: php-term
php-term:
	@./docker/utils/term php /bin/bash ||:

## |	make php-kill		kill the php container
## |
.PHONY: php-kill
php-kill:
	@./docker/utils/docker-kill php

## |	make php-logs		show the php container logs
## |
.PHONY: php-logs
php-logs:
	@./docker/utils/docker-logs php

## |	make mariadb-logs		show the mariadb container logs
## |
.PHONY: mariadb-logs
mariadb-logs:
	@./docker/utils/docker-logs db

## |	docker-clean		remove all the stack
## |
.PHONY: docker-clean
docker-clean:
	@./docker/utils/docker-clean

## |	ps			same as docker ps	 ¯\_(ツ)_/¯
## |
.PHONY: ps
ps:
	@docker ps

## --------------------------------------------------------------------------------
