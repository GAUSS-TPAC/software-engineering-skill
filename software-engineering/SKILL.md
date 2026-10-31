---
name: software-engineering
description: Applies software engineering discipline when designing, writing, refactoring or reviewing code and architectures. Covers SOLID, GRASP, DRY, KISS and YAGNI, the 23 GoF design patterns and enterprise patterns, architectural styles (layered, MVC, hexagonal, microservices, SOA, event-driven), component-based engineering (provided and required interfaces), services (REST, SOAP/WSDL, orchestration, BPEL), testing, code smells and refactoring. Use when the user asks to design a class, module or system, pick a design pattern, make code extensible or maintainable, review a design, reduce technical debt, or explain a software engineering concept (course, exam).
license: MIT
metadata:
  sources: "Software Engineering course (ENSPY, Yaoundé), Sommerville, GoF, Head First Design Patterns, plus SOLID, GRASP, Clean Architecture, DDD and Fowler"
  version: "1.0.0"
---

# Software engineering: design, code and review with method

Software engineering pursues three goals: **structuring** (readability), **modularity** (mastering complexity) and **reuse**. Every design decision must serve at least one of them without degrading the expected qualities of software: **maintainability, dependability (safety, security), efficiency, acceptability**.

Golden rule: **change is the problem**. Structure code so that likely changes stay local. Do not structure for imaginary changes.

## 1. Pick the working mode

| Request | Mode | What to produce |
|---|---|---|
| "Design / architect / model…" | **Design** | Variability analysis, then a model (classes or components), the rationale for each choice, the trade-offs |
| "Write / implement / add…" | **Implementation** | Code that follows the principles, tests, nothing superfluous |
| "Review / audit / what's wrong…" | **Review** | Findings ranked by severity, each with the violated principle, a concrete scenario and a fix (see `references/review-checklist.md`) |
| "Refactor / clean up / tech debt…" | **Refactoring** | Smells identified, then small safe steps, behavior preserved, tests green after each step |
| "Explain / what is / difference between…" | **Teaching** | Definition, motivation, structure, example, comparison (see `references/course-notes.md` for course definitions) |

## 2. Design process (follow in this order)

1. **Understand the domain and the requirements.** Identify functional requirements, non-functional requirements (performance, security, availability, scalability) and constraints (language, mandated framework, team, deadlines). If a missing piece of information would change the design, ask; otherwise pick the sensible default and state it.
2. **Identify what varies and what stays the same.** This is the first OO principle: *"Identify the aspects that vary and separate them from what stays the same."* List the axes of variation that are **real or explicitly announced**: new types, new algorithms, new data sources, new business rules, new platforms.
3. **Look for reuse first.** Standard library, framework already in the project, internal component, external service (COTS). Only write new code when reuse costs more (adaptation, trust, licensing, maintenance without sources). Beware of the *Not Invented Here* syndrome.
4. **Split into highly cohesive, loosely coupled modules.** One responsibility per module; dependencies point toward stable abstractions (the domain), never toward details (database, framework, UI, network).
5. **Define interfaces before implementations.** For each module: its **provided** interface (what it offers) and its **required** interface (what it needs). Program to an interface, not an implementation.
6. **Apply a pattern only when a recurring problem justifies it.** Use the decision table in section 4. Name the pattern in code or docs (the name is part of the design vocabulary).
7. **Check against the principles** (section 3) and against **testability**: if a class is hard to test in isolation, the design is too coupled.
8. **Record significant decisions** as a short ADR: context, decision, alternatives, consequences.

## 3. Principles to apply at all times

Details, examples and typical violations: `references/principles.md`.

**SOLID**
- **S**RP: a class has only one reason to change, i.e. one business actor driving its evolution.
- **O**CP: open for extension, closed for modification. Add behavior by adding code, not by editing an existing `switch`.
- **L**SP: a subtype must be substitutable for its supertype without surprises (no strengthened preconditions, no weakened postconditions, no unexpected exceptions).
- **I**SP: many small, focused interfaces beat one fat interface; no client depends on methods it does not use.
- **D**IP: high-level and low-level modules both depend on abstractions; the abstraction belongs to the client (the domain).

**OO principles (Head First, GoF)**
- Encapsulate what varies.
- Favor composition over inheritance (inheritance causes class explosion, see the Beverage case).
- Program to an interface, not an implementation.
- Strive for loose coupling between interacting objects (Observer).
- Hollywood principle: "don't call us, we'll call you" (Template Method, frameworks, IoC).
- Principle of least knowledge (Law of Demeter): talk only to your immediate friends, no `a.getB().getC().doIt()`.

**Pragmatism**
- **KISS**: the simplest solution that works.
- **YAGNI**: don't build for a hypothetical need.
- **DRY**: each piece of knowledge has a single representation. Careful: two identical pieces of code that change for different reasons are **not** duplication.
- **Rule of three**: abstract on the third occurrence, not the first.
- **Fail fast**: validate at the boundaries, raise an explicit error early.
- **CQS**: a method either changes state or returns a value, not both.
- **GRASP**: Information Expert, Creator, Controller, Low Coupling, High Cohesion, Polymorphism, Pure Fabrication, Indirection, Protected Variations.

## 4. Choosing a pattern: from problem to solution

Full sheets for the 23 patterns (intent, signals, contraindications, pitfalls, language idioms): `references/gof-patterns.md`.

| If the problem is… | Candidate pattern |
|---|---|
| `if/switch` on a type to **create** objects, repeated in several places | Factory Method / Simple Factory |
| Creating **families** of consistent objects (UI theme, database, region) | Abstract Factory |
| A complex object with many optional parameters or construction steps | Builder |
| Creating by copying a configured model, or classes known only at runtime | Prototype |
| A single shared instance (config, pool, registry) | Singleton, but **prefer a single instance injected** by the DI container |
| An incompatible interface to plug in (external lib, legacy) | Adapter |
| A complicated subsystem to use | Facade |
| Two dimensions varying independently (shape × renderer, message × channel) | Bridge |
| A part-whole tree structure handled uniformly | Composite |
| Adding combinable responsibilities at runtime without subclass explosion | Decorator |
| Controlling access: lazy loading, remote, security, caching | Proxy |
| A huge number of similar small objects (memory) | Flyweight |
| Several interchangeable algorithms chosen at runtime | Strategy |
| Behavior depends on internal **state** (state machine, `if (state == …)` everywhere) | State |
| Same algorithm skeleton, varying steps | Template Method |
| Notifying several objects of a change without knowing them | Observer (or event bus) |
| Encapsulating a request: queuing, undo, logging, macros | Command |
| Saving and restoring state without breaking encapsulation (undo) | Memento |
| Traversing a collection without exposing its representation | Iterator |
| A request handled by the first capable handler (middleware, filters, validation) | Chain of Responsibility |
| Many objects all talking to each other (mesh coupling) | Mediator |
| New operations on a stable hierarchy (AST, export, computations) | Visitor |
| A small language or grammar to evaluate (rules, filters, expressions) | Interpreter |

**Guardrails against over-engineering.** Before introducing a pattern, check that:
1. the problem exists **now** or is **explicitly announced**, not merely imagined;
2. the simple version (a function, an `if`, a `Map` of lambdas) would really be costlier to evolve;
3. the language does not already provide the solution: first-class functions for Strategy and Command, native iterators and generators, Python decorators, `enum` with behavior for State, the framework's DI for Singleton and Factory, `copy`/`clone` for Prototype.

## 5. Architecture

Details: `references/architecture.md` (styles, enterprise patterns, DDD, microservices, resilience) and `references/components-services.md` (CBSE, EJB, SOA, SOAP/WSDL, REST, BPEL).

- **Design pattern or architectural pattern?** The former acts on a code fragment (a few classes); the latter organizes the whole system (components, connectors, constraints).
- **Default style** for a business application: layered architecture or, better, **hexagonal (ports and adapters)**: the domain at the center with no dependency on frameworks; adapters (REST, database, messaging) at the edges.
- **Component**: a unit of composition with contractual interfaces, independently deployable (Szyperski). **Provided** and **required** interfaces; incompatibilities resolved by an **adapter**; assembly through *glue code* or automatically by a framework (container, DI, JNDI registry).
- **Service**: an autonomous component with no required interface, accessed through messages, discoverable, bound by a contract. Orchestration (a central conductor, BPEL) or choreography (no owner, events).
- **Microservices** only if teams, independent deployment and scaling justify them. Otherwise, a well-partitioned **modular monolith**.
- **Framework**: a semi-complete application implementing patterns. White-box: extended through inheritance (Template Method). Black-box: configured through composition (Strategy, Decorator). It imposes inversion of control.

## 6. Writing code

- Follow **the existing project's conventions first** (style, architecture, naming, libraries). Local consistency beats personal preference.
- Intention-revealing names; short functions at a single level of abstraction; few parameters; no hidden side effects.
- Immutability by default; value objects for business concepts (Money, Email, Period) instead of primitives.
- Errors: exceptions or explicit result types, never silently swallowed; useful messages; validation at the boundaries.
- Dependencies injected through the constructor; no `new` of a concrete service inside the domain.
- Security by design: validate input, parameterized queries, no secrets in code, least privilege.
- Tests: unit tests on the domain, integration tests on adapters, contract tests for services. See `references/testing-quality.md`.

## 7. Review and refactoring

- Spot **code smells** and map them to their refactoring and target pattern: `references/smells-refactoring.md`.
- Review finding format: **[severity] file:line — violated principle — concrete breaking scenario — proposed fix**. Do not report a style preference as a defect.
- Refactor in **small steps**, keeping behavior identical, with tests green between steps. Never mix refactoring and new features in the same change.

## 8. Expected deliverables

Depending on the request, produce:
- **Design**: a UML diagram (class, component or sequence) in Mermaid or PlantUML, the list of responsibilities, the patterns used **with their justification**, the trade-offs and what was ruled out.
- **Code**: implementation, tests, and a short explanation naming the principles and patterns applied.
- **Review**: findings ranked (critical, major, minor), then a summary.
- **Teaching**: the pattern description template (name, intent, motivation, applicability, structure, participants, collaborations, consequences, implementation, example, known uses, related patterns).

## Reference files (load as needed)

| File | Read when… |
|---|---|
| `references/principles.md` | justifying or checking a choice: SOLID, GRASP, cohesion and coupling, DRY, KISS, YAGNI, Demeter |
| `references/gof-patterns.md` | choosing, implementing or explaining one of the 23 GoF patterns, or a concurrency pattern |
| `references/architecture.md` | choosing an architectural style; enterprise patterns (Repository, Unit of Work, DTO), DDD, CQRS, microservices, resilience |
| `references/components-services.md` | components, EJB, component models, SOA, SOAP/WSDL/UDDI, REST, BPEL, orchestration |
| `references/smells-refactoring.md` | code review, technical debt, refactoring, anti-patterns |
| `references/testing-quality.md` | test strategy, TDD, test doubles, metrics, CI/CD, Docker |
| `references/review-checklist.md` | performing a full design or code review |
| `references/course-notes.md` | course definitions and comparisons (exam-style answers), software process, reuse, MDE, ethics |
