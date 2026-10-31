# Course notes: definitions and exam-style answers

Based on a university Software Engineering course (ENSPY, Yaoundé), Sommerville and student notes. Use in **teaching mode** or to answer a theory question. For patterns, see `gof-patterns.md`; for components and services, `components-services.md`.

## Contents
1. Software engineering
2. Software process
3. Reuse
4. Patterns, frameworks, templates
5. Professional ethics
6. Frequent exam questions and answer outlines

---

## 1. Software engineering

- **Software**: programs and their associated documentation. **Generic** products (sold to any customer, the developer owns the specification) or **customized** products (commissioned by a customer, who owns the specification).
- **Software engineering**: an engineering discipline covering all aspects of software production, from specification to maintenance, under organizational and financial constraints. It also covers project management and tools. In one sentence: *the set of theories, methods and tools for producing quality software*.
- **Software engineering vs computer science**: computer science deals with theory and fundamentals; software engineering, with the practicalities of producing useful software.
- **Software engineering vs systems engineering**: systems engineering covers the whole computer-based system (hardware, software, process); software engineering is part of it.
- **Attributes of good software**: maintainability, dependability and security, efficiency, acceptability.
- **Challenges**: heterogeneity, business and social change, delivery time, security and trust, scale.
- **The software crisis**, and its remedies: impose a process; test, test, test; control cost and quality through industrialization (reusable building blocks, patterns); follow a project management method.
- **The three needs of software engineering** (the course's common thread): **structuring** (readability), **modularity** (mastering complexity), **reuse**. Techniques sit at 4 levels: **frameworks** (implementation), **design patterns** (design), **component-based development**, **MDE**, plus **SOA**.
- **CASE** (Computer-Aided Software Engineering): *upper-CASE* for requirements and design; *lower-CASE* for programming, debugging and testing.
- **The Web and software engineering**: reuse dominates; incremental and agile development; service-oriented systems; rich interfaces (AJAX, HTML5); the cloud, with pay-per-use.

## 2. Software process

- **Generic activities**: **specification** (what the system must do and its constraints), **development** (design and implementation), **validation** (checking it is what the customer wants), **evolution** (adapting to changing needs).
- **Process models**: waterfall (sequential phases, for stable requirements), V-model (each phase paired with its test level), incremental, spiral (Boehm, risk-driven), prototyping, RUP (phases: inception, elaboration, construction, transition), **agile** (Scrum: sprints, backlog, roles; XP: TDD, continuous integration, pair programming, small releases; Kanban), **reuse-oriented** (like the CBSE process), DevOps.
- **No universally best method**: a game is developed through successive prototypes, a safety-critical system requires a complete, analyzable specification.
- **Requirements engineering**: elicitation, analysis, specification, validation; **functional** or **non-functional** requirements; use cases, user stories (INVEST), acceptance criteria.
- **Agile Manifesto**: individuals and interactions over processes and tools; working software over comprehensive documentation; customer collaboration over contract negotiation; responding to change over following a plan.

## 3. Reuse

- **Levels**: application system reuse (COTS, application families), component reuse (from subsystem to object), object and function reuse.
- **Benefits**: increased dependability (software already proven in production), reduced process risk (better cost estimates), effective use of specialists, standards compliance (e.g. uniform UI menus), accelerated development.
- **Problems**: increased maintenance costs (sources unavailable, accumulating incompatibilities); lack of tool support (CASE tools ignore reuse); **Not Invented Here syndrome**; creating and maintaining a component library (costly, immature classification); finding, understanding and adapting components.
- **The reuse landscape**: design patterns; component-based development; application frameworks; legacy system wrapping; service-oriented systems; product lines; COTS integration; configurable vertical applications (ERP); program libraries; program generators; **aspect-oriented development** (cross-cutting concerns woven at compile time: AspectJ).
- **Concept reuse**: more abstract, implementation-independent; its two routes are **design patterns** and **generative programming**.
- **COTS**: *Commercial / Component Off-The-Shelf*, commercial components or systems.

## 4. Patterns, frameworks, templates

- **Design pattern**: a set of good practices reusing proven solutions to recurring design problems; named and documented knowledge.
- **Catalog**: creational (Abstract Factory, Builder, Factory Method, Prototype, Singleton); structural (Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy); behavioral (Chain of Responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor); sometimes concurrency is added (Active Object, Double-Checked Locking, Monitor Object, Reactor, Thread-Specific Storage).
- **Pattern description**: name, problem, solution, consequences (short version); or the full GoF template.
- **Architectural pattern**: a stylized description of a good, proven practice for the global organization of a system. Examples: MVC, layers, client-server, microservices, SOA, blackboard, P2P, pipes and filters, implicit invocation (event-driven), naked objects, repository, broker.
- **Design pattern vs architectural pattern**: the former acts on sections of code; the latter is a higher-level strategy concerning the components, properties and mechanisms of the whole system.
- **Pattern vs template**: a template is a concrete model you copy and fill with your data (a document template, a C++ template or a generic); a pattern is a concept, an abstract solution you reapply by adapting it.
- **Pattern vs framework**: see `architecture.md`, section 8 (more abstract, smaller, less specialized; knowledge versus executable software).
- **Patterns and UML**: they are not tied together, but UML (class and sequence diagrams) is used to describe a pattern's structure and collaborations.
- **Why three categories?** Because a set of collaborating classes raises three questions: how to instantiate (creational), how to connect (structural), how to interact (behavioral).

## 5. Professional ethics

- Responsibilities: **confidentiality**, **competence** (don't accept work beyond your competence), **intellectual property**, **no computer misuse**.
- **ACM/IEEE Code, 8 principles**: public, client and employer, product, judgment, management, profession, colleagues, self (lifelong learning).
- Dilemmas: disagreement with management, releasing an insufficiently tested safety-critical system, military systems.
- **For the agent**: never ship code known to be dangerous or untested without saying so; flag security and personal-data risks; respect licenses.

## 6. Frequent exam questions and answer outlines

| Question | Answer outline |
|---|---|
| What is a design pattern? | A named, proven solution to a recurring design problem in a context; a language-independent micro-architecture; with its 4 elements |
| Give the catalog and categories | 23 GoF patterns in 3 categories (+ concurrency), also classified by class or object scope |
| How is a pattern described? | Name, intent, motivation, applicability, structure, participants, collaborations, consequences, implementation, sample, known uses, related patterns |
| What is an architectural pattern? Examples? | Global organization of the system: MVC, layers, client-server, pipes and filters, blackboard, SOA, microservices, P2P |
| Design pattern vs architectural pattern | Local scope (classes) versus global scope (components, connectors) |
| Pattern vs template | Reapplied concept versus concrete template to copy |
| Pattern vs framework | Small abstract knowledge versus executable software realizing several patterns |
| White-box and black-box frameworks | Inheritance (Template Method, State) versus composition and configuration (Strategy, Decorator) |
| Why not replace a Singleton with a global variable? | Lazy creation, controlled instantiation, subclassable, encapsulated implementation, less namespace pollution |
| Factory Method and Abstract Factory | Abstract Factory methods are often Factory Methods; one product through inheritance versus a family through composition; the concrete factory is often a Singleton |
| Adapter or Facade | Convert versus simplify |
| What is a component? Component vs object? Component vs library? | Szyperski's definition; more abstract and coarser-grained than an object; deployable, provided and required interfaces; a library is static and not autonomous |
| Is OOP necessary for CBSE? | Neither necessary nor sufficient (with justification) |
| Component model: definition and elements | Standards for implementation, documentation and deployment; interfaces, usage information, deployment |
| Java / Microsoft / CORBA / Web services table | See `components-services.md`, section 4 |
| Composition and incompatibility types | Sequential, hierarchical, additive; parameter, operation, incompleteness; resolved by an adapter |
| EJB: definition, structure, deployment, communication, types | See `components-services.md`, section 5 |
| Component vs service | A service has no required interface, communicates by messages, is deployed at the provider's and is discoverable |
| SOAP, WSDL, UDDI, BPEL | Messaging, description, directory, composition |
| Orchestration vs choreography | Centralized with an owner, versus decentralized with shared rules |
| Is SOA a reality or a slogan? | Arguments for and against, then synthesis (`components-services.md`, section 7) |
| REST principles | The 6 constraints, resources and URIs, verbs, codes, statelessness, HATEOAS, Richardson model |
| MDA | CIM → PIM → PSM → code; metamodels; transformations |
| Design exercise | Identify what varies → choose the pattern → UML diagram → code → justify through the principles (OCP, DIP, composition) |

**Method for a "which pattern for this situation?" exercise**: (1) restate the problem in one sentence; (2) spot the keyword: *family*, *single instance*, *incompatible interface*, *tree*, *add dynamically*, *notify*, *undo*, *traverse*, *interchangeable algorithms*, *state*, *skeleton*, *grammar*, *new operations*; (3) give the pattern's intent; (4) draw the diagram with participants named after the domain; (5) give the consequences.
