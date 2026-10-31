# Design principles

## Contents
1. Software qualities
2. Cohesion and coupling
3. SOLID (with violations and fixes)
4. OO principles (Head First / GoF)
5. GRASP
6. Pragmatic principles (DRY, KISS, YAGNI, Demeter, CQS, fail fast…)
7. Tensions between principles

---

## 1. Software qualities (Sommerville)

| Quality | Meaning | Design consequence |
|---|---|---|
| Maintainability | Software must evolve with changing needs | Modularity, loose coupling, tests, readability |
| Dependability | Safety, security, availability, reliability | Error handling, validation, redundancy, tests |
| Efficiency | No wasteful use of resources (CPU, memory, network) | Suitable algorithms, avoid needless indirection |
| Acceptability | Understandable, usable, compatible with other systems | Usability, interoperability, standards |

Complementary standard (ISO/IEC 25010): functional suitability, performance efficiency, compatibility, usability, reliability, security, maintainability (modularity, reusability, analysability, modifiability, testability), portability.

Maintenance often costs **more than development** (long-lived systems). Designing for maintenance pays off.

## 2. Cohesion and coupling

**Cohesion**: how closely the elements of a module work on a single responsibility. Aim for **high** cohesion.
Scale (worst to best): coincidental → logical → temporal → procedural → communicational → sequential → **functional**.

**Coupling**: how much a module depends on another's details. Aim for **low** coupling.
Scale (worst to best): content (modifying another's internals) → common (global variables) → external → control (passing a flag that drives the other) → stamp (passing a whole structure for one field) → **data** (simple parameters) → message.

Practical indicators:
- Afferent coupling (Ca): how many modules depend on me. Efferent coupling (Ce): how many modules I depend on.
- Instability I = Ce / (Ca + Ce). **Stable Dependencies Principle**: depend on what is more stable than you.
- No cyclic dependencies between packages (ADP, Acyclic Dependencies Principle).

## 3. SOLID

### S: Single Responsibility Principle
> A class should have only one reason to change.

A "reason to change" maps to an actor (the accountant, the DBA, the UI team). Violation signals: the class is called `Manager`, `Utils` or `Helper`; it mixes business logic, persistence and formatting; its tests need many different mocks.

```java
// Violation: business + persistence + presentation
class Invoice {
  double total() { ... }
  void saveToDatabase() { ... }
  String toHtml() { ... }
}
// Fix
class Invoice { double total() { ... } }
interface InvoiceRepository { void save(Invoice i); }
class InvoiceHtmlRenderer { String render(Invoice i) { ... } }
```

### O: Open/Closed Principle
> Software entities should be open for extension but closed for modification.

Signal: a `switch`/`if-else` on a type, copied in several places, that must be edited for each new case (see `orderPizza(String type)` in Head First).
Mechanisms: polymorphism, Strategy, Decorator, Template Method, plugins, dependency injection.
Nuance: close the code against **likely** changes. A single `switch` inside a Factory is acceptable: that is where the variation is concentrated.

### L: Liskov Substitution Principle
> Objects of a subtype must be usable in place of the supertype without altering program correctness.

Rules: preconditions no stronger, postconditions no weaker, invariants preserved, no new unexpected exceptions.
Classic violations: `Square extends Rectangle` (setWidth changes the height); `Ostrich extends Bird` with `fly()` throwing; an overridden method that does nothing (`throw new UnsupportedOperationException()`).
Fix: rethink the hierarchy (`Flyer` interface, immutable `Shape`), compose instead of inheriting.

### I: Interface Segregation Principle
> No client should be forced to depend on methods it does not use.

Signal: implementations full of empty methods or "not supported" exceptions. Fix: split into role interfaces (`Readable`, `Writable`) or per-client interfaces.

### D: Dependency Inversion Principle
> High-level modules should not depend on low-level modules; both depend on abstractions. Abstractions do not depend on details.

```java
// Violation
class OrderService { private MySqlOrderDao dao = new MySqlOrderDao(); }
// Fix: the interface belongs to the domain, the implementation is injected
interface OrderRepository { void save(Order o); }
class OrderService {
  private final OrderRepository repo;
  OrderService(OrderRepository repo) { this.repo = repo; }
}
```
Don't confuse: **DIP** (principle), **IoC** (the framework calls your code), **DI** (technique: dependencies supplied from outside, preferably through the constructor).

## 4. OO principles (Head First Design Patterns)

1. **Encapsulate what varies**: isolate the changing part behind an interface (pizza creation → Factory; duck flying behavior → Strategy).
2. **Favor composition over inheritance**: inheritance is static, freezes behavior at compile time and causes combinatorial explosion (Beverage × condiments). Composition can change at runtime.
3. **Program to an interface (a supertype), not an implementation.**
4. **Strive for loosely coupled designs between objects that interact** (Observer: the subject only knows the Observer interface).
5. **Open/closed** (see OCP).
6. **Depend on abstractions, not concrete classes** (see DIP).
7. **Least knowledge**: talk only to your immediate friends.
8. **Hollywood principle**: low-level components hook in, high-level components decide when to call them (Template Method, frameworks).
9. **A class should have only one reason to change** (see SRP).

## 5. GRASP (Larman): who gets a responsibility?

| Principle | Rule |
|---|---|
| Information Expert | Assign the responsibility to the class that has the needed information |
| Creator | B creates A if B contains or aggregates A, records A, closely uses A, or has A's initialization data |
| Controller | A non-UI object receives and coordinates system events (use case, domain facade) |
| Low Coupling | Pick the assignment that minimizes dependencies |
| High Cohesion | Pick the assignment that keeps classes focused |
| Polymorphism | Handle type-based behavior variations through polymorphism, not conditionals |
| Pure Fabrication | Create a class with no domain counterpart (Repository, Service) to preserve cohesion and coupling |
| Indirection | Introduce an intermediary to decouple (Adapter, Facade, Mediator) |
| Protected Variations | Shield variation points behind a stable interface |

## 6. Pragmatic principles

- **DRY** (*Don't Repeat Yourself*): every piece of knowledge has a single, authoritative representation. It is about knowledge, not text: two identical validations for two distinct business rules may stay separate.
- **KISS**: simplicity is a design goal.
- **YAGNI**: don't implement what is not asked for.
- **Rule of three**: duplicating once is tolerated; on the third time, factor it out.
- **Law of Demeter**: a method only calls methods of `this`, its parameters, objects it creates and its direct fields. *Tell, don't ask*: tell the object to do something instead of reading its state to decide for it.
- **CQS** (*Command Query Separation*): a method either changes state (command) or returns information (query), not both.
- **Fail fast**: detect and report errors as early as possible, at the boundaries.
- **Principle of least surprise**: code behaves as its name says.
- **Separation of concerns**: business, persistence, presentation, transport, cross-cutting concerns (logging, security, transactions → AOP, middleware, container).
- **Encapsulation, information hiding (Parnas)**: a module hides a design decision likely to change.
- **Design by contract (Meyer)**: preconditions, postconditions, invariants.
- **Composition over inheritance**, **immutability by default**, **value objects** against primitive obsession.
- **Boy Scout Rule**: leave the code a bit cleaner than you found it (without drifting outside the requested scope).

### Package principles (Robert C. Martin)
- Cohesion: REP (the unit of reuse is the unit of release), CCP (group what changes together), CRP (don't force dependence on what isn't used).
- Coupling: ADP (no cycles), SDP (depend toward stability), SAP (a stable package should be abstract).

## 7. Tensions between principles: how to decide

| Tension | Decision |
|---|---|
| DRY vs decoupling | If two modules would share code but evolve for different reasons, duplicate |
| OCP vs YAGNI | Only open for extension the real or announced axes of variation |
| Flexibility (patterns) vs efficiency | Each indirection has a cost (readability, performance, debugging). Justify it |
| SRP vs number of classes | Split by actor and reason to change, not by method |
| Singleton vs testability | Prefer a single instance managed by the DI container |
| Inheritance vs composition | Inheritance only for a true "is-a" relation that respects LSP |
