# Code smells, refactoring and anti-patterns

## Contents
1. Smells: symptom, violated principle, refactoring, target pattern
2. Design and architecture anti-patterns
3. Safe refactoring method
4. Technical debt

---

## 1. Code smells (Fowler, Beck)

| Smell | Symptom | Violated principle | Refactoring | Target pattern |
|---|---|---|---|---|
| Long Method | Function over 30 to 50 lines, several levels of abstraction | SRP, readability | Extract Method, Decompose Conditional | Template Method, Composed Method |
| Large Class / God Object | Many fields and methods, several reasons to change | SRP, cohesion | Extract Class, Extract Interface | Facade, Strategy, State |
| Long Parameter List | More than 3 or 4 parameters | Coupling | Introduce Parameter Object, Preserve Whole Object | Builder |
| Primitive Obsession | `String email`, `double amount` everywhere | Encapsulation | Replace Primitive with Object | Value Object |
| Data Clumps | The same groups of data repeated | Cohesion | Extract Class | Value Object |
| Switch Statements | A `switch` or `if` on a type repeated in several places | OCP | Replace Conditional with Polymorphism | Strategy, State, Factory |
| Duplicate Code | Copy-paste | DRY | Extract Method, Pull Up Method | Template Method |
| Divergent Change | One class changed for different reasons | SRP | Extract Class | |
| Shotgun Surgery | One change touches N classes | Cohesion (CCP) | Move Method, Move Field | Facade, group by feature |
| Feature Envy | A method mostly using another class's data | Information Expert | Move Method | |
| Message Chains | `a.getB().getC().getD()` | Law of Demeter | Hide Delegate | Facade |
| Middle Man | A class that only delegates | YAGNI | Remove Middle Man, Inline Class | |
| Inappropriate Intimacy | Classes accessing each other's internals | Encapsulation | Move Method, Extract Class | Mediator |
| Refused Bequest | A subclass ignoring or cancelling what it inherits | LSP | Replace Inheritance with Delegation | Composition, Strategy |
| Parallel Inheritance Hierarchies | Each new subclass here requires one there | Coupling | Move Method | Bridge, Visitor |
| Lazy Class / Speculative Generality | Abstractions or parameters "for later" | YAGNI, KISS | Inline Class, Collapse Hierarchy | Remove the pattern |
| Temporary Field | A field only set in some cases | Cohesion | Extract Class | Null Object |
| Data Class | Only getters and setters, logic lives elsewhere | Information Expert | Move Method into Data Class | Rich domain model |
| Comments | Comments explaining obscure code | Readability | Extract Method, Rename | |
| Mysterious Name | Vague names (`data`, `tmp`, `doStuff`) | Readability | Rename | |
| Global Data / Mutable Data | Shared, mutable state | Common coupling | Encapsulate Variable, make immutable | DI instead of Singleton |
| Nulls everywhere | Repeated `null` checks | Fail fast | Introduce Null Object, Optional | Null Object |
| Flag Argument | `doIt(true)` | SRP, control coupling | Remove Flag Argument (split into two methods) | |

## 2. Anti-patterns

**Design**
- **God Object / Blob**: one class that knows and does everything.
- **Anemic Domain Model**: entities without behavior; logic scattered across services.
- **Singletonitis**: singletons everywhere, hence global state and untestable code.
- **Poltergeist**: short-lived classes with no responsibility that only call another class.
- **Golden Hammer**: applying the same tool or pattern to every problem.
- **Pattern Fever**: stacking patterns that no problem justifies.
- **Spaghetti Code**, **Lava Flow** (dead code nobody dares remove), **Copy-Paste Programming**, **Magic Numbers / Strings**, **Hard Coding**.
- **Constant Interface**, **Call Super** (a subclass forced to call `super`), **Yo-yo Problem** (an overly deep inheritance hierarchy).
- **Sequential Coupling**: methods that must be called in a specific order with nothing enforcing it (use Builder, Template Method or State).
- **Service Locator** used instead of dependency injection.

**Architecture**
- **Big Ball of Mud**: no discernible structure.
- **Distributed monolith**: coupled microservices.
- **Shared database** as an integration mechanism.
- **Skipped layers** or **pass-through layers**.
- **Cyclic dependencies** between modules.
- **Vendor lock-in**: the domain depends directly on a vendor.
- **Chatty API**: too many network round trips for a single operation.
- **Stovepipe System**: subsystems integrated ad hoc, with no common architecture.
- **Reinventing the wheel / Not Invented Here**: rewriting what already exists.

**Process**
- No tests, big late merges, no review, premature optimization ("premature optimization is the root of all evil", Knuth), *Big Design Up Front* on an uncertain domain, or conversely no design at all on a critical domain.

## 3. Safe refactoring method

1. **Safety net**: make sure tests cover the current behavior. Otherwise, first write **characterization tests** (golden master).
2. **One transformation at a time**, small and named (Fowler's catalog).
3. **Run the tests after each step.** On red, revert the step rather than debugging for long.
4. **Do not change behavior** during a refactoring. New features go into a separate change.
5. For a big change: **Branch by Abstraction** or **Strangler Fig**. Introduce an interface, let old and new implementations coexist, switch over, then remove the old one.
6. For legacy code without tests (Feathers): find the **seams**, break dependencies (Extract Interface, Parameterize Constructor), get it under test, then change it.

Most useful refactorings: Rename, Extract Method / Function, Inline, Extract Class, Move Method / Field, Extract Interface, Introduce Parameter Object, Replace Conditional with Polymorphism, Replace Type Code with State/Strategy, Replace Constructor with Factory, Replace Inheritance with Delegation, Encapsulate Collection, Replace Magic Number with Constant, Decompose Conditional, Guard Clauses (early returns instead of nested `if`s).

Example: replacing a `switch` with Strategy.
```java
// Before
double fee(Order o) {
  switch (o.shipping()) {
    case "STANDARD": return 5;
    case "EXPRESS":  return 15 + o.weight() * 0.5;
    case "PICKUP":   return 0;
    default: throw new IllegalArgumentException();
  }
}
// After
interface ShippingMode { double fee(Order o); }
enum Shipping implements ShippingMode {
  STANDARD { public double fee(Order o) { return 5; } },
  EXPRESS  { public double fee(Order o) { return 15 + o.weight() * 0.5; } },
  PICKUP   { public double fee(Order o) { return 0; } };
}
// A new mode = a new constant, no client changed (OCP)
```

## 4. Technical debt

- **Fowler's quadrant**: deliberate or inadvertent, × prudent or reckless.
- Make debt **visible**: tickets, ADRs, `TODO(ticket)` comments.
- **Prioritize** by: how often the area changes (*hotspots*: change frequency × complexity), risk, and the cost of waiting.
- Pay it back progressively (Boy Scout rule, time budget per iteration) rather than through a "big rewrite".
