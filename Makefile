all: run

run:
	docker compose up -d --remove-orphans

down:
	docker compose down