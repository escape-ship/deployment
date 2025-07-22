all: run run_ui run_services

run:
	docker compose up -d --remove-orphans

run_ui:
	docker compose -f docker-compose-ui.yml up -d

run_services:
	docker compose -f docker-compose-services.yml up -d --remove-orphans

run_all: run run_ui run_services

down:
	docker compose down

down_ui:
	docker compose -f docker-compose-ui.yml down

down_services:
	docker compose -f docker-compose-services.yml down

down_all: down_ui down_services down

logs_services:
	docker compose -f docker-compose-services.yml logs -f

status:
	docker compose ps
	docker compose -f docker-compose-ui.yml ps
	docker compose -f docker-compose-services.yml ps