# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Deployment Infrastructure

**Docker Compose Management:**
- `make run` - Start core infrastructure services (PostgreSQL, MySQL, Redis, Kafka)
- `make run_ui` - Start management UI services (RedisInsight, Kafka UI)
- `make run_services` - Start application services (UI, Gateway, and microservices)
- `make run_all` - Start all infrastructure and application services
- `make down` - Stop core infrastructure services
- `make down_ui` - Stop management UI services
- `make down_services` - Stop application services
- `make down_all` - Stop all services
- `make logs_services` - Follow application service logs
- `make status` - Show status of all services
- `make all` - Default: start infrastructure, UI tools, and application services

**Service Architecture:**
- **Infrastructure**: PostgreSQL (5432), MySQL (3306), Redis (6379), Kafka (9092)
- **Application**: UI (3000) ↔ Gateway (8080) ↔ Microservices (8081-8084)
- **Management UI**: RedisInsight (5540), Kafka UI (8082)

**Direct Docker Commands:**
- `docker compose up -d --remove-orphans` - Start infrastructure services
- `docker compose -f docker-compose-ui.yml up -d` - Start management UI
- `docker compose -f docker-compose-services.yml up -d` - Start application services

### Individual Microservice Development

Each microservice (`accountsrv/`, `gatewaysrv/`, `ordersrv/`, `paymentsrv/`, `productsrv/`) follows consistent patterns:

**Build Commands:**
- `make init` - First-time setup (downloads tools and builds)
- `make build` - Full build with proto generation, dependencies, and compilation
- `make build_alone` - Quick build (binary only)
- `make clean` - Remove build artifacts

**Code Generation:**
- `make proto_gen` - Generate Protocol Buffer code using buf
- `make sqlc_gen` - Generate SQL code using sqlc (for services with databases)

**Development:**
- `make run` - Run the compiled binary
- `make run_dev` - Run with development configuration (gatewaysrv only)
- `make test` - Run tests
- `make test_coverage` - Run tests with coverage report
- `make lint` - Run golangci-lint
- `make fmt` - Format Go code

**Tool Management:**
- `make tool_download` - Download required development tools
- `make tool_update` - Update tools to latest versions

### UI Test Application

Located in `ui_test/` (React/Bun project):
- `bun dev` - Start development server with hot reload
- `bun start` - Start production server
- `bun run build` - Build for production

## Architecture Overview

This is a microservices-based e-commerce platform called "escape-ship" with the following structure:

### Core Services

**Gateway Service** (`gatewaysrv/`):
- API Gateway with gRPC-Gateway for HTTP/JSON API exposure
- JWT authentication middleware
- CORS, logging, recovery middleware
- Aggregates all microservice endpoints

**Account Service** (`accountsrv/`):
- User authentication and registration
- Kakao OAuth integration
- Redis session management
- PostgreSQL user data storage

**Product Service** (`productsrv/`):
- Product catalog management
- Category and option management
- PostgreSQL with database migrations
- Kafka event publishing

**Order Service** (`ordersrv/`):
- Order creation and management
- Order item handling
- MySQL database (different from other services)

**Payment Service** (`paymentsrv/`):
- Kakao Pay integration
- Payment processing (ready, approve, cancel)
- PostgreSQL with transaction support
- Kafka event streaming

### Infrastructure Components

**Database Layer:**
- **PostgreSQL**: Primary database for accounts, products, payments
- **MySQL**: Used specifically by order service
- **Redis**: Session storage and caching

**Message Streaming:**
- **Kafka**: Event-driven architecture for inter-service communication
- KRaft mode configuration with single-node setup

**Protocol Buffers:**
- Shared proto definitions in `protos/` directory
- Each service has its own generated code
- gRPC services with HTTP/JSON gateway support

### Development Environment

**Infrastructure Services:**
- PostgreSQL on port 5432 (accounts, products, payments)
- MySQL on port 3306 (orders)
- Redis on port 6379 (session storage, caching)
- Kafka on port 9092 (host) / 9093 (docker) - event streaming

**Application Services:**
- UI (React/Bun) on port 3000 - User interface
- Gateway Service on port 8080 - API gateway and authentication
- Account Service on port 8081 - User management and Kakao OAuth
- Product Service on port 8082 - Product catalog and inventory
- Order Service on port 8083 - Order processing and management  
- Payment Service on port 8084 - Kakao Pay integration

**Management UI:**
- RedisInsight on port 5540 - Redis management
- Kafka UI on port 8082 - Kafka topic and message monitoring

**Networking:**
- Separate Docker networks for each service type
- Health checks configured for all services

### Service Dependencies and Communication

**API Flow:**
1. Client requests → Gateway Service (HTTP/JSON or gRPC)
2. Gateway → Individual microservices (gRPC)
3. Services publish events to Kafka for async processing
4. Services store data in respective databases

**Authentication Flow:**
1. Kakao OAuth → Account Service
2. JWT token generation → Gateway Service middleware
3. Protected endpoints validated through JWT

**Event-Driven Integration:**
- Payment events → Order processing
- Product changes → Inventory updates
- Account changes → Session management

## Development Workflow

### First-Time Setup
1. Start infrastructure: `make run` (from deployment directory)
2. Initialize each service: `make init` (in each service directory)
3. Start UI tools: `make run_ui` (optional, for debugging)

### Daily Development
1. Ensure infrastructure is running: `make run`
2. For service changes: `make build` → `make run`
3. For quick iterations: `make build_alone` → `make run`
4. Always run `make lint` before committing

### Testing and Quality
1. Run tests: `make test`
2. Check coverage: `make test_coverage`
3. Validate configuration: `make validate_config` (gatewaysrv)
4. Format code: `make fmt`

### Protocol Buffer Changes
1. Edit `.proto` files in individual service directories
2. Run `make proto_gen` in affected services
3. Rebuild services with `make build`

## Configuration Management

- Services use YAML configuration files with environment variable overrides
- Database connection strings in `envs/` directory (development defaults)
- Kafka configuration supports both host and Docker communication
- JWT secrets and API keys configured via environment variables

## UI Test Application

Modern React application using:
- **Bun** as runtime and build tool
- **React 19** with TypeScript
- **Tailwind CSS** for styling
- **Radix UI** components
- **React Router** for navigation
- **React Hook Form** with Zod validation

The UI provides testing interfaces for all microservice APIs and handles Kakao OAuth callbacks.