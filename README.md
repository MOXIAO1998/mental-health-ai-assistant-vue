# Mental Health Assistant

An AI-powered mental health support platform that provides streaming, conversational psychological consultation through a web interface.

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.15-brightgreen)
![Spring AI](https://img.shields.io/badge/Spring%20AI-1.0.0-blue)
![Vue](https://img.shields.io/badge/Vue-3-42b883)
![Vite](https://img.shields.io/badge/Vite-8-646cff)
![MySQL](https://img.shields.io/badge/MySQL-8-4479a1)
![License](https://img.shields.io/badge/License-Not%20Specified-lightgrey)

> **Disclaimer:** This project is a software tool for emotional support and self-reflection. It is **not** a substitute for professional medical advice, diagnosis, or treatment. If you are in crisis, please contact your local emergency services or a licensed professional.

## Table of Contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Core Features](#core-features)
- [Technology Stack](#technology-stack)
- [System Architecture](#system-architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [API Usage Examples](#api-usage-examples)
- [Testing](#testing)
- [Deployment](#deployment)
- [FAQ](#faq)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

Mental Health Assistant is a full-stack application that lets users hold a supportive, real-time chat with an AI assistant. The backend uses Spring AI to connect to an OpenAI-compatible chat model and streams responses back to the browser over Server-Sent Events (SSE), producing a typewriter-style conversational experience. User accounts are secured with JWT-based authentication, and consultation sessions and messages are persisted in MySQL.

**Target users:** individuals seeking accessible, low-friction emotional support and self-reflection tools, as well as developers who want a reference implementation of a Spring AI + Vue streaming chat application.

## Screenshots

> Replace the placeholder paths below with real screenshots.

![Home](docs/images/home.png)
![Consultation Chat](docs/images/consultation.png)

## Core Features

- **Streaming AI consultation** — real-time, token-by-token psychological support chat delivered over SSE.
- **Session management** — start a consultation session, persist messages, and revisit past conversations.
- **JWT authentication** — user registration, login, and stateless token-based access control.
- **Supporting content views** — knowledge/article pages, an emotion diary, and dashboard views on the frontend.

## Technology Stack

**Backend**
- Java 17, Spring Boot 3.5.15
- Spring Web, Spring Security (stateless JWT)
- Spring AI (`spring-ai-starter-model-openai` 1.0.0)
- MyBatis-Plus 3.5.7, Spring Data JDBC
- MySQL (`mysql-connector-j`)
- `java-jwt` (auth0) 4.4.0, Hutool 5.8.25, Lombok
- Maven (with wrapper)

**Frontend**
- Vue 3, Vite 8
- Vue Router 4, Pinia 4
- Element Plus, ECharts
- Axios, `@microsoft/fetch-event-source` (SSE client)
- WangEditor (rich text), Sass

## System Architecture

```text
                 ┌──────────────────────────────┐
                 │        Browser (Vue 3)         │
                 │  Element Plus · Pinia · Axios  │
                 │  fetch-event-source (SSE)      │
                 └───────────────┬────────────────┘
                                 │  HTTP / SSE  (/api/**)
                                 ▼
                 ┌──────────────────────────────┐
                 │      Spring Boot Backend       │
                 │  Controllers → Services        │
                 │  Spring Security (JWT filter)  │
                 │  MyBatis-Plus / Spring JDBC    │
                 └───────┬───────────────┬────────┘
                         │               │
                         ▼               ▼
            ┌────────────────┐   ┌──────────────────────┐
            │     MySQL       │   │  OpenAI-compatible    │
            │  users,         │   │  Chat API (Spring AI) │
            │  sessions,      │   │  streaming completions│
            │  messages       │   └──────────────────────┘
            └────────────────┘
```

**Streaming flow:** the client calls `POST /api/psychological-chat/session/start` to create a session, then opens `POST /api/psychological-chat/stream` and consumes SSE events (`message` fragments followed by a terminal `done` event).

## Project Structure

```text
mental-health-assistant/
├── backend/                        # Spring Boot application
│   ├── pom.xml
│   ├── mvnw / mvnw.cmd
│   └── src/
│       ├── main/
│       │   ├── java/com/gym/aispringboot/
│       │   │   ├── AiSpringbootApplication.java
│       │   │   ├── AiService/       # Spring AI prompt & chat services
│       │   │   ├── controller/      # User, PsychologicalChat, Test
│       │   │   ├── service/         # business services + converters
│       │   │   ├── mapper/          # MyBatis-Plus mappers
│       │   │   ├── entity/          # User, ConsultationSession, ConsultationMessage
│       │   │   ├── DTO/             # command / response DTOs
│       │   │   ├── config/          # Security, JWT, ChatClient config
│       │   │   ├── util/            # JWT filter & token utils
│       │   │   ├── common/          # Result, ResultCode, exception handler
│       │   │   ├── enumClass/       # UserStatus, UserType
│       │   │   └── exception/       # BusinessException
│       │   └── resources/
│       │       ├── application.yml
│       │       └── application-local.yml.example
│       └── test/
└── frontend/                       # Vue 3 + Vite application
    ├── package.json
    ├── vite.config.js
    ├── index.html
    └── src/
        ├── main.js
        ├── App.vue
        ├── api/                     # frontend & admin API clients
        ├── components/              # layouts, navbar, editors, renderers
        ├── views/                   # home, login, register, consultation, etc.
        ├── router/                  # vue-router config
        ├── stores/                  # Pinia stores
        ├── config/                  # base URL config
        ├── utils/                   # axios request wrapper
        └── assets/                  # images & icons
```

## Getting Started

The backend and frontend are separate applications and are run independently.

### Prerequisites

- **JDK 17+**
- **Node.js 18+** and npm (Vite 8 requires a modern Node.js release)
- **MySQL 8+**
- An **OpenAI-compatible API key** for the chat model

### Clone the Repository

```bash
git clone <PROJECT_URL>
cd mental-health-assistant
```

### 1. Backend Setup

#### Configure local secrets

The app activates the `local` Spring profile by default and loads `application-local.yml` (gitignored). Copy the template and add your key:

```bash
cd backend/src/main/resources
cp application-local.yml.example application-local.yml
```

Edit `application-local.yml` and set your API key:

```yaml
spring:
  ai:
    openai:
      api-key: <YOUR_OPENAI_API_KEY>
```

You can also provide the key via the `OPENAI_API_KEY` environment variable, which `application.yml` reads by default.

> **Note:** `backend/src/main/resources/application.yml` currently contains placeholder datasource credentials and a JWT secret. Move real secrets into `application-local.yml` or environment variables and **do not commit them**. See [Environment Variables](#environment-variables).

#### Initialize the database

Create the schema referenced by the datasource URL (`mental_health_assistant`):

```sql
CREATE DATABASE mental_health_assistant
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

> **TODO:** No SQL migration/DDL scripts are checked into the repository yet. Add table definitions for `users`, `consultation_sessions`, and `consultation_messages` (matching the `entity/` classes), or a schema initializer, so the database can be provisioned reproducibly.

#### Run the backend

**macOS / Linux**

```bash
cd backend
./mvnw spring-boot:run
```

**Windows**

```bat
cd backend
mvnw.cmd spring-boot:run
```

The backend starts on **`http://localhost:1236`** (see `server.port` in `application.yml`).

### 2. Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

Vite serves the app in development (default `http://localhost:5173`).

> **Important:** `frontend/vite.config.js` and `frontend/src/config/index.js` currently point the `/api` proxy and file base URL at a remote host (`http://159.75.169.224:1235`). To develop against your local backend, update the proxy target to `http://localhost:1236`:
>
> ```js
> // frontend/vite.config.js
> server: {
>   proxy: {
>     '/api': { target: 'http://localhost:1236', changeOrigin: true },
>   },
> },
> ```

## Environment Variables

| Variable          | Required | Example Value             | Description                                                                 |
| ----------------- | -------- | ------------------------- | --------------------------------------------------------------------------- |
| `OPENAI_API_KEY`  | Yes      | `<YOUR_OPENAI_API_KEY>`   | API key for the OpenAI-compatible chat model used by Spring AI.             |
| `DB_URL`          | Optional | `jdbc:mysql://localhost:3306/mental_health_assistant?useSSL=false&serverTimezone=UTC` | JDBC URL for MySQL. Currently hardcoded in `application.yml`; externalize for production. |
| `DB_USERNAME`     | Optional | `<DB_USERNAME>`           | MySQL username. Externalize instead of hardcoding in `application.yml`.     |
| `DB_PASSWORD`     | Optional | `<DB_PASSWORD>`           | MySQL password. Externalize instead of hardcoding in `application.yml`.     |
| `JWT_SECRET`      | Optional | `<JWT_SECRET>`            | Signing secret for JWTs. **Do not use the placeholder committed in `application.yml`.** Externalize for production. |
| `SERVER_PORT`     | Optional | `1236`                    | Backend HTTP port (`server.port`).                                          |

> **Security note:** The repository's `application.yml` ships with example datasource credentials and a JWT secret for local convenience. Replace these with your own values via `application-local.yml` or environment variables, and never commit real secrets, tokens, or keys.

## API Usage Examples

Base URL (local): `http://localhost:1236`

All responses use a common envelope:

```json
{ "code": "200", "msg": "success", "data": { } }
```

Public endpoints: `POST /api/user/login`, `POST /api/user/add`. All other endpoints require an `Authorization: Bearer <token>` header.

### Register a user

```http
POST /api/user/add
Content-Type: application/json
```

Request body:

```json
{
  "username": "jane_doe",
  "email": "jane@example.com",
  "nickname": "Jane",
  "phone": "1234567890",
  "password": "secret123",
  "confirmPassword": "secret123",
  "gender": 2,
  "userType": 1
}
```

Success response:

```json
{
  "code": "200",
  "msg": "success",
  "data": {
    "id": 1,
    "username": "jane_doe",
    "email": "jane@example.com",
    "nickname": "Jane",
    "userType": 1,
    "status": 1
  }
}
```

Common error responses:

```json
{ "code": "400", "msg": "parameter error", "data": "username length must be between 3 and 50" }
```

```json
{ "code": "6001", "msg": "The username already exists.", "data": null }
```

### Log in

```http
POST /api/user/login
Content-Type: application/json
```

Request body:

```json
{ "username": "jane_doe", "password": "secret123" }
```

Success response:

```json
{
  "code": "200",
  "msg": "success",
  "data": {
    "token": "<JWT_TOKEN>",
    "roleType": "USER",
    "userInfo": { "id": 1, "username": "jane_doe", "email": "jane@example.com" }
  }
}
```

Common error response:

```json
{ "code": "6002", "msg": "The username does not exists.", "data": null }
```

### Start a consultation session

```http
POST /api/psychological-chat/session/start
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

Request body:

```json
{
  "sessionTitle": "Feeling anxious about work",
  "initialMessage": "I've been feeling overwhelmed lately and can't focus."
}
```

Success response:

```json
{
  "code": "200",
  "msg": "success",
  "data": {
    "sessionId": "<SESSION_ID>",
    "userHash": 1,
    "initialMessage": "I've been feeling overwhelmed lately and can't focus.",
    "startTime": 1735689600000,
    "expiryTime": 1735776000000,
    "messageCount": 1,
    "status": "active"
  }
}
```

Common error response:

```json
{ "code": "401", "msg": "not logged in or token has expired", "data": null }
```

### Stream a chat message (SSE)

```http
POST /api/psychological-chat/stream
Content-Type: application/json
Accept: text/event-stream
Authorization: Bearer <JWT_TOKEN>
```

Request body:

```json
{
  "sessionId": "<SESSION_ID>",
  "userMessage": "What can I do to feel calmer right now?"
}
```

Successful response (SSE stream):

```text
event: message
data: {"code":"200","msg":"success","data":{"content":"Let's","type":"normal"}}

event: message
data: {"code":"200","msg":"success","data":{"content":" take a breath","type":"normal"}}

event: done
data: {}
```

Common error response (SSE stream):

```text
event: error
data: {"code":"401","msg":"not logged in or token has expired","data":"user has not login yet"}
```

> **TODO:** No Swagger/OpenAPI UI is currently configured. Consider adding `springdoc-openapi` to expose interactive API docs at `/swagger-ui.html`.

## Testing

**Backend** (JUnit via `spring-boot-starter-test`):

```bash
cd backend
./mvnw test        # macOS / Linux
mvnw.cmd test      # Windows
```

> The current test suite contains only the default `AiSpringbootApplicationTests` context-load test. **TODO:** add unit and integration tests for authentication and consultation flows.

**Frontend:** no test runner is configured yet. **TODO:** add a test setup (e.g. Vitest) and tests for key views/components.

## Deployment

No deployment tooling (Dockerfiles, CI workflows, or Kubernetes manifests) is included in the repository yet. A typical deployment would look like:

**Backend**

```bash
cd backend
./mvnw clean package -DskipTests
java -jar target/ai-spingboot-0.0.1-SNAPSHOT.jar
```

Provide secrets at runtime, for example:

```bash
OPENAI_API_KEY=<YOUR_OPENAI_API_KEY> \
JWT_SECRET=<JWT_SECRET> \
java -jar target/ai-spingboot-0.0.1-SNAPSHOT.jar
```

**Frontend**

```bash
cd frontend
npm run build      # outputs static assets to dist/
npm run preview    # optional: preview the production build locally
```

Serve `frontend/dist/` behind a static web server or CDN, and reverse-proxy `/api` to the backend.

> **TODO:** Add a `Dockerfile` per service, a `docker-compose.yml` (app + MySQL), and a CI pipeline (e.g. GitHub Actions) if containerized/automated deployment is required.

## FAQ

**The chat returns a 401 error.**
Consultation endpoints require authentication. Log in first and send the returned token as `Authorization: Bearer <JWT_TOKEN>`.

**The frontend cannot reach my local backend.**
The default `/api` proxy target in `vite.config.js` points to a remote host. Change it to `http://localhost:1236` (see [Frontend Setup](#2-frontend-setup)).

**Where do I put my OpenAI API key?**
In `application-local.yml` (copied from the template) or the `OPENAI_API_KEY` environment variable. Never commit real keys.

**Which chat model is used?**
The model is configured under `spring.ai.openai.chat.model` in `application.yml`. Set it to a model available to your account/provider.

## Roadmap

- [ ] Add database migration/DDL scripts for reproducible setup
- [ ] Externalize all secrets out of `application.yml`
- [ ] Add OpenAPI/Swagger documentation
- [ ] Expand backend and frontend test coverage
- [ ] Add Docker and CI/CD configuration
- [ ] Session history and message retrieval endpoints on the frontend

> Project status: **In Development.**

## Contributing

Contributions are welcome. A typical workflow:

1. Fork the repository and create a feature branch: `git checkout -b feature/my-feature`
2. Make your changes with clear, focused commits.
3. Ensure the backend builds and tests pass (`./mvnw test`).
4. Open a pull request describing the change and its motivation.

> **TODO:** Add a `CONTRIBUTING.md` and code style guidelines if this project accepts external contributions.

## License

No license file is currently present in the repository. **License: Not Specified.** Add a `LICENSE` file (e.g. MIT or Apache 2.0) to clarify usage rights.

## Contact

- Author: `<YOUR_NAME_OR_GITHUB_USERNAME>`
- Repository: `<PROJECT_URL>`

Built with Spring Boot, Spring AI, and Vue 3.
