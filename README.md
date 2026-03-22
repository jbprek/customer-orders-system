# Customer Orders System

A Spring Boot microservices demo composed of three independent services that share a single PostgreSQL instance via separate schemas.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ customer-service│    │ product-service  │    │  order-service  │
│   :8081         │    │   :8082         │    │   :8083         │
└────────┬────────┘    └────────┬────────┘    └────────┬────────┘
         │                      │                      │
         │              ┌───────▼──────┐               │
         └──────────────►  PostgreSQL  ◄───────────────┘
                        │   :5432      │
                        │  ┌─────────┐ │
                        │  │customer │ │
                        │  │product  │ │
                        │  │orders   │ │
                        │  └─────────┘ │
                        └──────────────┘
```

Each service owns its own PostgreSQL schema (`customer`, `product`, `orders`) within a shared `appdb` database. The order service calls product-service over HTTP to validate products when creating orders.

## Services

| Service | Port | Schema | Description |
|---|---|---|---|
| customer-service | 8081 | `customer` | Manage customers |
| product-service | 8082 | `product` | Manage products and inventory |
| order-service | 8083 | `orders` | Create and track orders |

## Tech Stack

- **Java 21**, Spring Boot 3.5
- **Spring Data JPA** + Hibernate
- **PostgreSQL 16** (single instance, per-service schemas)
- **Lombok** for boilerplate reduction
- **Docker** / Docker Compose for local orchestration

## Prerequisites

- Java 21+
- Maven 3.9+
- Docker and Docker Compose

## Running with Docker Compose

The easiest way to run everything together:

```bash
# Build JARs first
mvn package -DskipTests

# Start all services + PostgreSQL
docker compose -f docker/docker-compose.yml up --build
```

Services will be available once PostgreSQL passes its health check. The database is initialised automatically from `postgres/init/`.

To stop and remove containers:

```bash
docker compose -f docker/docker-compose.yml down
```

To also remove the persistent volume:

```bash
docker compose -f docker/docker-compose.yml down -v
```

## Running Locally (without Docker)

Start PostgreSQL separately (or point to an existing instance), then run each service:

```bash
# Start PostgreSQL via Docker only
docker compose -f docker/docker-compose.yml up postgres -d

# Run each service in separate terminals
mvn spring-boot:run -pl customer-service
mvn spring-boot:run -pl product-service
mvn spring-boot:run -pl order-service
```

Default database connection: `localhost:5432/appdb` (user: `postgres`, password: `postgres`). Override with environment variables:

| Variable | Default | Description |
|---|---|---|
| `DB_HOST` | `localhost` | PostgreSQL host |
| `DB_PORT` | `5432` | PostgreSQL port |
| `DB_NAME` | `appdb` | Database name |
| `DB_USER` | `customer_user` / `product_user` / `orders_user` | Per-service DB user |
| `DB_PASSWORD` | `customer_pass` / `product_pass` / `orders_pass` | Per-service DB password |
| `PRODUCT_SERVICE_URL` | `http://localhost:8082` | order-service only |

## Building

Build all modules from the project root:

```bash
mvn package
```

Skip tests:

```bash
mvn package -DskipTests
```

Compile only:

```bash
mvn compile
```

Run tests:

```bash
mvn test
```

## API Reference

### Customer Service — `http://localhost:8081`

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/customers` | List all customers |
| GET | `/api/customers/{id}` | Get customer by ID |
| POST | `/api/customers` | Create a customer |
| PUT | `/api/customers/{id}` | Update a customer |
| DELETE | `/api/customers/{id}` | Delete a customer |

**Create customer request:**
```json
{
  "firstName": "Jane",
  "lastName": "Doe",
  "email": "jane@example.com",
  "phone": "555-1234",
  "address": "123 Main St"
}
```

### Product Service — `http://localhost:8082`

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/products` | List all products |
| GET | `/api/products/{id}` | Get product by ID |
| POST | `/api/products` | Create a product |
| PUT | `/api/products/{id}` | Update a product |
| DELETE | `/api/products/{id}` | Delete a product |

### Order Service — `http://localhost:8083`

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/orders` | List all orders |
| GET | `/api/orders/{id}` | Get order by ID |
| GET | `/api/orders/customer/{customerId}` | Orders for a customer |
| POST | `/api/orders` | Create an order |
| PATCH | `/api/orders/{id}/status` | Update order status |
| DELETE | `/api/orders/{id}` | Delete an order |

**Order status values:** `PENDING`, `CONFIRMED`, `PROCESSING`, `SHIPPED`, `DELIVERED`, `CANCELLED`

## Health Checks

Each service exposes Spring Actuator endpoints:

```
http://localhost:8081/actuator/health
http://localhost:8082/actuator/health
http://localhost:8083/actuator/health
```

## Project Structure

```
customer-orders-system/
├── pom.xml                  # Parent POM
├── docker/
│   ├── docker-compose.yml
│   └── postgres/
│       └── init/
│           ├── 01_schemas.sql   # Schema creation
│           ├── 02_tables.sql    # Table definitions
│           └── 03_data.sql      # Seed data
├── customer-service/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
├── product-service/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
└── order-service/
    ├── Dockerfile
    ├── pom.xml
    └── src/
```
