all: run run_ui

run:
	docker compose up -d --remove-orphans

run_ui:
	docker compose -f docker-compose-ui.yml up -d

down:
	docker compose down

down_ui:
	docker compose -f docker-compose-ui.yml down