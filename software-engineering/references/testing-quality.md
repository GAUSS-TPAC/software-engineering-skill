# Testing, quality and delivery

## Contents
1. Verification and validation
2. Test levels and types
3. Strategy and the pyramid
4. TDD and BDD
5. Test doubles
6. Writing good tests
7. Quality metrics
8. CI/CD, Docker, observability

---

## 1. Verification and validation

- **Verification**: are we building the product right (conformance to the specification)?
- **Validation**: are we building the right product (conformance to the customer's real need)?
- Testing shows the presence of defects, never their absence (Dijkstra).
- Rough costs (Sommerville): about 60% development and 40% testing; for custom software, evolution often costs more than development.

## 2. Levels and types

| Level | Target | Tools (examples) |
|---|---|---|
| Unit | One class or function, isolated | JUnit 5, pytest, Jest/Vitest, xUnit, `flutter_test` |
| Integration | An adapter with a real resource (database, broker) | Testcontainers, `@DataJpaTest`, in-memory database |
| Contract | The agreement between an API consumer and provider | Pact, Spring Cloud Contract, OpenAPI validation |
| Component / service | A whole service with simulated dependencies | WireMock, MockServer, `@SpringBootTest` |
| End-to-end (E2E) | A full user journey | Playwright, Cypress, `integration_test` |
| Non-functional | Load, performance, security, accessibility | k6, JMeter, Gatling, OWASP ZAP, axe |
| Property-based / fuzzing | Invariants checked on generated inputs | jqwik, Hypothesis, fast-check |
| Mutation | The quality of the tests themselves | PIT, mutmut, Stryker |

Black-box (from the specification: equivalence partitioning, boundary values, decision tables, state transitions) or white-box (from the code: statement, branch, path coverage).

## 3. Strategy

- **Pyramid**: many fast unit tests, fewer integration tests, few E2E tests. Variant for services: the "trophy" or "honeycomb", with more integration tests.
- **What to test**: business logic, edge cases, errors, regressions (one test per fixed bug). Don't test the framework itself or trivial getters.
- **Testability** is a design criterion: with dependency injection, pure functions and an isolated domain, tests are simple. A test that is hard to write signals a design problem.

## 4. TDD and BDD

- **TDD**: *Red* (write a failing test) → *Green* (minimal code to pass it) → *Refactor* (clean up, tests green). Tests drive interface design.
- **BDD**: `Given / When / Then` scenarios (Gherkin, Cucumber), written in the domain's language.
- Test structure: **Arrange / Act / Assert** (or Given / When / Then).

## 5. Test doubles (Meszaros)

| Double | Role |
|---|---|
| Dummy | Fills a parameter, never used |
| Stub | Returns preprogrammed answers |
| Spy | A stub that records the calls it receives |
| Mock | Verifies expected interactions |
| Fake | A simplified working implementation (in-memory repository) |

Only mock what you own, behind a port. Prefer **fakes** to mocks for the domain, which makes tests less brittle. Don't mock value objects.

## 6. Writing good tests

- **FIRST**: Fast, Independent, Repeatable, Self-validating, Timely.
- One behavior per test; a name describing the behavior (`shouldRejectWithdrawalAboveBalance`).
- No logic (loops, `if`) in tests; explicit test data (Test Data Builder, Object Mother).
- Determinism: inject the clock, random generators and UUIDs.
- Parameterized tests for case tables.

## 7. Quality metrics

- **Cyclomatic complexity** (McCabe): number of independent paths. Above 10 per function, split it.
- **Cognitive complexity** (SonarQube).
- **Coverage**: useful to find untested code, but not a goal in itself (aim for branch coverage on the domain).
- **Coupling and cohesion**: Ca, Ce, instability, LCOM, depth of inheritance (DIT), number of children (NOC), CBO, RFC (Chidamber and Kemerer metrics).
- **Duplication**, function and class **size**.
- Tools: SonarQube, linters (ESLint, Ruff, Checkstyle, PMD, SpotBugs, `dart analyze`), ArchUnit (architecture tests: "the domain does not depend on infrastructure").

## 8. CI/CD, Docker, observability

- **CI**: on every push, build, lint, tests, static analysis and dependency scanning (SCA). A broken build is fixed first.
- **CD**: automated deployment, identical environments, versioned schema migrations (Flyway, Liquibase), *feature flags*, blue/green or canary deployment, rollback.
- **Docker**: one immutable image per version. Multi-stage Dockerfile; minimal base image; non-root user; `.dockerignore`; one process per container; configuration through environment variables; `docker-compose` for the local environment (app, database, broker); volumes for data; networks for isolation.
- **Observability**: structured logs (JSON, with a correlation ID), metrics (RED: Rate, Errors, Duration; USE: Utilization, Saturation, Errors), distributed tracing (OpenTelemetry), health checks (liveness, readiness).
- **Configuration and version management**: Git, short-lived branches or *trunk-based development*, Conventional Commits, SemVer (MAJOR.MINOR.PATCH), CHANGELOG.
