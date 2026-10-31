# Software architecture

## Contents
1. Definitions
2. Architectural styles (with components and connectors)
3. Domain-centric architectures: hexagonal, clean, onion
4. Enterprise patterns (Fowler)
5. DDD: Domain-Driven Design
6. Modular monolith, microservices, SOA
7. Distributed and resilience patterns
8. Frameworks, IoC and DI
9. MDE / MDA
10. Choosing an architecture: decision grid
11. ADR: recording a decision

---

## 1. Definitions

- **Software architecture** (Bass, Clements, Kazman): the structure or structures of the system, comprising software components (and connectors), their externally visible properties and the relationships among them.
- It addresses **functional and non-functional** requirements and supports evaluation (by stakeholders, experts or quality attributes), configuration management and dynamic reconfiguration.
- **Architectural style**: defines a family of systems (hence reuse) by its component types, connector types, configurations and constraints.
- **Architectural pattern or design pattern**: the former is a high-level strategy concerning the components and mechanisms of the whole system; the latter concerns a code fragment (a few classes).

## 2. Architectural styles

| Style | Components | Connectors | Examples | Strengths | Weaknesses |
|---|---|---|---|---|---|
| Pipes and filters | Filters | Pipes (data streams) | Unix shell, compilers, ETL, image processing | Reuse, composition, parallelism | Poor fit for interactive systems, format conversion cost |
| Layered | Layers | Layer interaction protocols | OSI/TCP-IP, OS, presentation / business / data apps | Separation, replaceable layers | Traversal cost, pass-through layers |
| Client-server | Clients, servers | RPC, HTTP | Web, databases | Centralized data, sharing | Single point of failure, server load |
| Object-oriented | Objects | Messages and method calls | OO applications | Encapsulation | Identity dependencies between objects |
| Blackboard (shared space) | Central data structure and knowledge sources | Reads and writes on the board | Speech recognition, AI, IDEs | Opportunistic problem solving | Hard control, contention |
| Event-driven (implicit invocation) | Emitters, subscribers | Event bus | GUIs, Kafka, IDEs | Decoupling, extensibility | Flow hard to follow and test |
| State transition system | States | Transitions | Protocols, workflows, automata | Verifiable behavior | State explosion |
| MVC | Model, view, controller | Observer, calls | Spring MVC, Rails, ASP.NET | Separates presentation and business | Fat controllers |
| MVP / MVVM | Model, view, presenter or view-model | Data binding | Android, WPF, Flutter (BLoC, Provider) | UI testability | Binding code |
| Peer-to-peer | Peers | P2P protocols | BitTorrent, blockchain | No central point | Consistency and security |
| Microkernel / plugins | Core, plugins | Extension interfaces | Eclipse, VS Code, browsers | Extensibility | Extension contract to stabilize |
| Interpreter / virtual machine | Engine, program, state | Interpretation | JVM, rule engines | Portability | Performance |
| Repository | Central store | Data access | Databases, IDEs | Data sharing | Coupling to the schema |
| Service-oriented / microservices | Services | Messages (HTTP, queues) | See section 6 | Independence, scaling | Distributed complexity |

## 3. Domain-centric architectures

**Hexagonal (ports and adapters, Cockburn)**, **Clean Architecture (Martin)**, **onion architecture (Palermo)**: the same idea.
- The **domain** (entities, business rules) is at the center and depends on nothing external.
- **Use cases** (application services) orchestrate the domain.
- **Ports** are interfaces defined by the core: **inbound** ports (what the application offers, i.e. a provided interface) and **outbound** ports (what it needs, i.e. a required interface).
- **Adapters** implement the ports: REST controller, CLI or message consumer inbound; JPA repository, HTTP client or email sender outbound.
- **Dependency rule**: source code dependencies always point inward.

Typical layout:
```
src/
  domain/          entities, value objects, domain services, outbound ports (interfaces)
  application/     use cases, command and response DTOs, inbound ports
  infrastructure/  adapters: persistence, messaging, external clients, configuration
  interfaces/      (or web/, api/) controllers, serialization
```

Organize by **feature** (`order/`, `payment/`) rather than only by technical layer once the project grows (*package by feature*).

## 4. Enterprise patterns (Fowler, PoEAA)

| Pattern | Role |
|---|---|
| Repository | An in-memory-like collection of domain objects that hides persistence |
| Data Mapper | Moves data between objects and the database without either knowing the other (ORM) |
| Active Record | The object carries its own persistence methods (Rails, Eloquent). Simple, but couples business to the database |
| Unit of Work | Tracks changes and commits them in a single transaction |
| Identity Map | Ensures one in-memory object per record |
| Lazy Load | Loads data when needed (beware the N+1 problem) |
| Service Layer | The application boundary; orchestrates use cases and transactions |
| Domain Model or Transaction Script | Rich model for complex business; procedural script for simple business |
| DTO | Transfer object between layers or processes, without logic |
| Value Object | Immutable object compared by value (Money, Address) |
| Gateway | Encapsulates access to an external system |
| Front Controller | Single entry point for requests (DispatcherServlet) |
| Registry, Service Locator | Global access point to services. Prefer dependency injection |
| Specification | Combinable business rule (`and`, `or`, `not`) |

## 5. DDD: Domain-Driven Design (Evans)

- **Ubiquitous language**: the same words in the code and in the mouths of domain experts.
- **Bounded Context**: a boundary within which a model is consistent; a *context map* describes their relationships (anti-corruption layer = Adapter and Facade between contexts).
- **Entity** (identity), **value object** (immutable, equality by value), **aggregate** (consistency and transaction boundary, accessed only through its root), **domain service**, **domain event**, **repository** (one per aggregate), **factory**.
- Avoid the **anemic domain model** (entities that are only getters and setters, with all logic in services) when the business is complex.

## 6. Modular monolith, microservices, SOA

- **Modular monolith**: a single deployable, but modules with strict boundaries (public interfaces, no direct access to another module's tables). A good default.
- **Microservices**: small, autonomous, independently deployable services, each with its own database, organized around business capabilities, each owned by one team.
  - Use when: several teams, different scaling needs per part, independent deployments essential.
  - Costs: unreliable network, eventual consistency, observability, deployment, end-to-end testing.
  - Anti-pattern: the **distributed monolith** (coupled services that must be deployed together, or share the same database).
- **SOA**: reusable enterprise services, formal contracts, often an ESB and orchestration (see `components-services.md`). Microservices are an evolution of SOA, with *dumb pipes, smart endpoints*.
- **The 8 fallacies of distributed computing**: the network is reliable; latency is zero; bandwidth is infinite; the network is secure; topology doesn't change; there is one administrator; transport cost is zero; the network is homogeneous.
- **CAP theorem**: under a network partition, choose between consistency and availability.

## 7. Distributed and resilience patterns

| Pattern | Problem solved |
|---|---|
| API Gateway / BFF | Single entry point, aggregation, authentication; one backend per client type |
| Service Discovery | Finding service instances (a registry, like UDDI for SOA) |
| Circuit Breaker | Stop calling a failing service and fail fast |
| Retry with exponential backoff and jitter | Transient errors (only on **idempotent** operations) |
| Timeout, Bulkhead | Isolate failures, bound resources |
| Idempotency Key | Replay a request without double effects |
| Saga (orchestrated or choreographed) | Distributed transaction through local steps and **compensations** (close to BPEL *compensation handlers*) |
| Transactional Outbox | Publish an event atomically with the database update |
| CQRS | Separate the write model (commands) from the read model (queries) |
| Event Sourcing | Store events rather than current state |
| Strangler Fig | Migrate a legacy system progressively by wrapping it |
| Anti-Corruption Layer | Protect your model from an external system (Adapter and Facade) |
| Sidecar, Service Mesh | Cross-cutting network concerns outside the code |
| Cache-aside, Read-through | Read performance |
| Database per Service | Data autonomy |

**Twelve-Factor App**: one codebase; explicitly declared dependencies; config in the environment; backing services as attached resources; separate build, release and run; stateless processes; port binding; concurrency through processes; disposability; dev/prod parity; logs as event streams; admin tasks as one-off processes.

## 8. Frameworks, IoC and DI

- **Framework**: an integrated set of artifacts (classes, objects, components) that collaborate to provide a reusable architecture for a family of applications; a semi-complete application. It is extended by adding concrete subclasses and methods called in response to the events it recognizes.
- **White-box**: reused through inheritance; requires understanding the implementation (Template Method, State). **Black-box**: reused through configuration and assembly (Strategy, Decorator).
- **Benefits**: reuse of design, implementation and validation.
- **Limits**: hard to learn and even harder to build; tricky debugging because of inversion of control; tricky verification because of late binding; performance cost of indirection.
- **Framework or library**: you call a library; a framework calls your code (Hollywood principle).
- **Pattern or framework**: a pattern is more abstract, smaller and less specialized; it is knowledge. A framework is executable software realizing one or more patterns. "Frameworks implement pattern languages."
- **Spring / Spring Boot**: an IoC container managing beans (singleton by default), DI (preferably by constructor), AOP through proxies (`@Transactional`), MVC (Front Controller with `DispatcherServlet`), starters and auto-configuration, Spring Data (Repository).

## 9. MDE / MDA

- **MDE** (Model-Driven Engineering): the model is the primary artifact, and code is generated from it through transformations.
- **MDA** (OMG): **CIM** (requirements model, computation-independent) → **PIM** (platform-independent) → **PSM** (platform-specific) → code. Transformations are model-to-model (ATL, QVT) then model-to-text (Acceleo, Xtend).
- Metamodeling: a model conforms to its metamodel, which conforms to the meta-metamodel (MOF, EMF's Ecore).
- Current forms: code generation from OpenAPI or protobuf, generated ORMs, domain-specific languages (DSL), low-code.

## 10. Choosing an architecture: decision grid

1. Is the business **complex**? If yes: domain model, DDD, hexagonal architecture. For simple CRUD: layers and Transaction Script, or Active Record.
2. **Team size** and number of teams? One team: modular monolith. Several autonomous teams: consider microservices.
3. **Dominant non-functional requirements**: latency (caching, async), throughput (event-driven, queues), availability (redundancy, circuit breaker), strong consistency (local transactions, avoid distribution).
4. **Integration**: heterogeneous, cross-organization systems, hence services and contracts (REST, gRPC, messages); legacy, hence wrapping (Adapter, Strangler).
5. **Data flow**: batch processing, hence pipes and filters; real time, hence event-driven or reactive architecture.
6. **User interface**: MVC, MVVM or MVP to separate presentation.

## 11. ADR: recording a decision

```
# ADR-NNN: <title>
Status: proposed | accepted | superseded by ADR-XXX
Context: forces at play, constraints, quality requirements
Decision: what we do
Alternatives considered: and why they were rejected
Consequences: positive, negative, risks, what becomes easier or harder
```
