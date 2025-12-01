# Docker Services:
#   up - Start services (use: make up [service...] or make up MODE=prod, ARGS="--build" for options)
#   down - Stop services (use: make down [service...] or make down MODE=prod, ARGS="--volumes" for options)
#   build - Build containers (use: make build [service...] or make build MODE=prod)
#   logs - View logs (use: make logs [service] or make logs SERVICE=backend, MODE=prod for production)
#   restart - Restart services (use: make restart [service...] or make restart MODE=prod)
#   shell - Open shell in container (use: make shell [service] or make shell SERVICE=gateway, MODE=prod, default: backend)
#   ps - Show running containers (use MODE=prod for production)
#
# Convenience Aliases (Development):
#   dev-up - Alias: Start development environment
#   dev-down - Alias: Stop development environment
#   dev-build - Alias: Build development containers
#   dev-logs - Alias: View development logs
#   dev-restart - Alias: Restart development services
#   dev-shell - Alias: Open shell in backend container
#   dev-ps - Alias: Show running development containers
#   backend-shell - Alias: Open shell in backend container
#   gateway-shell - Alias: Open shell in gateway container
#   mongo-shell - Open MongoDB shell
#
# Convenience Aliases (Production):
#   prod-up - Alias: Start production environment
#   prod-down - Alias: Stop production environment
#   prod-build - Alias: Build production containers
#   prod-logs - Alias: View production logs
#   prod-restart - Alias: Restart production services
#
# Backend:
#   backend-build - Build backend TypeScript
#   backend-install - Install backend dependencies
#   backend-type-check - Type check backend code
#   backend-dev - Run backend in development mode (local, not Docker)
#
# Database:
#   db-reset - Reset MongoDB database (WARNING: deletes all data)
#   db-backup - Backup MongoDB database
#
# Cleanup:
#   clean - Remove containers and networks (both dev and prod)
#   clean-all - Remove containers, networks, volumes, and images
#   clean-volumes - Remove all volumes
#
# Utilities:
#   status - Alias for ps
#   health - Check service health
#
# Help:
#   help - Display this help message

# Variables
COMPOSE_DEV_FILE := docker/compose.development.yaml
COMPOSE_PROD_FILE := docker/compose.production.yaml
COMPOSE_FILE := $(if $(filter prod,$(MODE)),$(COMPOSE_PROD_FILE),$(COMPOSE_DEV_FILE))
SERVICE ?= 
MODE ?= dev
SERVICE_CMD ?= backend
DOCKER_COMPOSE := docker compose --env-file .env
SHELL := /bin/bash

.PHONY: help up down build logs restart shell ps dev-up dev-down dev-build dev-logs dev-restart dev-shell dev-ps backend-shell gateway-shell mongo-shell prod-up prod-down prod-build prod-logs prod-restart backend-build backend-install backend-type-check backend-dev db-reset db-backup clean clean-all clean-volumes status health

help:
	@echo "Available targets:"
	@echo ""
	@echo "Docker Services:"
	@echo "  make up [SERVICE...]           - Start services (use: make up MODE=prod, ARGS=\"--build\")"
	@echo "  make down [SERVICE...]         - Stop services (use: make down MODE=prod, ARGS=\"--volumes\")"
	@echo "  make build [SERVICE...]        - Build containers (use: make build MODE=prod)"
	@echo "  make logs [SERVICE...]         - View logs (use: make logs SERVICE=backend, MODE=prod)"
	@echo "  make restart [SERVICE...]      - Restart services (use: make restart MODE=prod)"
	@echo "  make shell [SERVICE...]        - Open shell in container (default: backend)"
	@echo "  make ps                        - Show running containers (use MODE=prod for production)"
	@echo ""
	@echo "Development Convenience Aliases:"
	@echo "  make dev-up                    - Start development environment"
	@echo "  make dev-down                  - Stop development environment"
	@echo "  make dev-build                 - Build development containers"
	@echo "  make dev-logs                  - View development logs"
	@echo "  make dev-restart               - Restart development services"
	@echo "  make dev-shell                 - Open shell in backend container"
	@echo "  make dev-ps                    - Show running development containers"
	@echo "  make backend-shell             - Open shell in backend container"
	@echo "  make gateway-shell             - Open shell in gateway container"
	@echo "  make mongo-shell               - Open MongoDB shell"
	@echo ""
	@echo "Production Convenience Aliases:"
	@echo "  make prod-up                   - Start production environment"
	@echo "  make prod-down                 - Stop production environment"
	@echo "  make prod-build                - Build production containers"
	@echo "  make prod-logs                 - View production logs"
	@echo "  make prod-restart              - Restart production services"
	@echo ""
	@echo "Backend Tasks:"
	@echo "  make backend-build             - Build backend TypeScript"
	@echo "  make backend-install           - Install backend dependencies"
	@echo "  make backend-type-check        - Type check backend code"
	@echo "  make backend-dev               - Run backend in development mode (local, not Docker)"
	@echo ""
	@echo "Database Operations:"
	@echo "  make db-reset                  - Reset MongoDB database (WARNING: deletes all data)"
	@echo "  make db-backup                 - Backup MongoDB database"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean                     - Remove containers and networks (both dev and prod)"
	@echo "  make clean-all                 - Remove containers, networks, volumes, and images"
	@echo "  make clean-volumes             - Remove all volumes"
	@echo ""
	@echo "Utilities:"
	@echo "  make status                    - Alias for ps"
	@echo "  make health                    - Check service health"

up:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

build:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f

restart:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) restart

shell:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) exec $(SERVICE_CMD) sh

ps:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

dev-up:
	$(MAKE) up MODE=dev

dev-down:
	$(MAKE) down MODE=dev

dev-build:
	$(MAKE) build MODE=dev

dev-logs:
	$(MAKE) logs MODE=dev

dev-restart:
	$(MAKE) restart MODE=dev

dev-shell:
	$(MAKE) shell MODE=dev SERVICE_CMD=backend

dev-ps:
	$(MAKE) ps MODE=dev

backend-shell:
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) exec backend sh

gateway-shell:
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) exec gateway sh

mongo-shell:
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) exec mongo mongosh

prod-up:
	$(MAKE) up MODE=prod

prod-down:
	$(MAKE) down MODE=prod

prod-build:
	$(MAKE) build MODE=prod

prod-logs:
	$(MAKE) logs MODE=prod

prod-restart:
	$(MAKE) restart MODE=prod

# Backend Tasks
backend-build:
	cd backend && npm run build

backend-install:
	cd backend && npm install

backend-type-check:
	cd backend && npm run type-check

backend-dev:
	cd backend && npm run dev
db-backup:
	@mkdir -p ./backups
	@echo "Creating backup..."
	@read -p "Enter Mongo Username: " db_user; \
	read -s -p "Enter Mongo Password: " db_pass; \
	echo ""; \
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) exec -T mongo \
		mongodump -u $$db_user -p $$db_pass --authenticationDatabase admin --archive > ./backups/mongodb_backup_$$(date +%Y%m%d_%H%M%S).archive
	@echo "Backup saved to ./backups/"

db-reset:
	read -p "Enter Mongo Username: " db_user; \
	read -s -p "Enter Mongo Password: " db_pass; \
	echo ""; \
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) exec -T mongo \
		mongosh -u $$db_user -p $$db_pass --authenticationDatabase admin --eval "db.adminCommand('listDatabases').databases.forEach(function(d){if(d.name!='admin' && d.name!='config' && d.name!='local'){db.getSiblingDB(d.name).dropDatabase()}})"
	@echo "Database reset complete."

# Cleanup
clean:
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) down
	$(DOCKER_COMPOSE) -f $(COMPOSE_PROD_FILE) down

clean-all:
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) down -v --rmi all
	$(DOCKER_COMPOSE) -f $(COMPOSE_PROD_FILE) down -v --rmi all

clean-volumes:
	$(DOCKER_COMPOSE) -f $(COMPOSE_DEV_FILE) down -v
	$(DOCKER_COMPOSE) -f $(COMPOSE_PROD_FILE) down -v

status: ps

health:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps
	@echo ""
	@echo "Running containers health check:"
	docker ps --format "table {{.Names}}\t{{.Status}}"
	@echo "Checking Gateway:"
	curl http://localhost:5921/health
	@echo "Checking API:"
	curl http://localhost:5921/api/health

