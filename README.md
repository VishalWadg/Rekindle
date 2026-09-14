# Rekindle

> A quiet rediscovery app that surfaces thoughts, notes, and quotes you once cared about during idle moments — with zero streaks, zero due dates, and zero pressure.

Rekindle is explicitly **not** a spaced-repetition or productivity tool. It does not test you or ask what you are overdue to review. Instead, it asks: *"what would you enjoy rediscovering right now?"*

---

## Documentation

- **[System Architecture](docs/architecture.md)** — In-depth system design, domain concepts, Thompson Sampling bandit math, JPA data models, and API specifications.

---

## Tech Stack

- **Backend**: Java 25, [Spring Boot 3](https://spring.io/projects/spring-boot), [Spring Data JPA](https://spring.io/projects/spring-data-jpa), [Hibernate](https://hibernate.org/)
- **Migrations**: [Flyway](https://flywaydb.org/)
- **Recommendation Engine**: Bayesian Multi-Armed Bandit via Thompson Sampling (`Beta-Bernoulli`) implemented with [Apache Commons Math](https://commons.apache.org/proper/commons-math/) + Redis recency filter
- **OpenAPI & Docs**: [springdoc-openapi](https://springdoc.org/) (`/v3/api-docs` and Swagger UI)
- **Database**: PostgreSQL 16 (port 5433 host)
- **Cache**: Redis 7 (24h cooldown recency cache)
- **Frontend**: React, TypeScript, [Vite](https://vitejs.dev/), Progressive Web App (PWA)

---

## Project Structure

```text
rekindle/
├── docs/             # Architecture specifications and diagrams
├── backend/          # Spring Boot 3 application (Java, JPA, Commons Math)
├── frontend/         # React PWA client
├── docker-compose.yml# Local PostgreSQL and Redis setup
└── README.md
```
