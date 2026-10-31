# Design patterns (GoF and more)

## Contents
- Basics: definition, description, classification
- Creational: Singleton, Factory Method (and Simple Factory), Abstract Factory, Builder, Prototype
- Structural: Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy
- Behavioral: Chain of Responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor
- Concurrency patterns
- Commonly confused patterns
- Language idioms
- Classic exercises and their typical solution

---

## Basics

**Definition.** A design pattern names and abstracts a recurring design structure. It offers a proven solution to a problem that recurs within a given context. It is a micro-architecture (a "society of objects"), independent of language and implementation.

**History.** 1977-1979: Christopher Alexander, architect (*A Pattern Language*, *The Timeless Way of Building*). 1987: Ward Cunningham and Kent Beck at OOPSLA. 1995: the "Gang of Four" (Gamma, Helm, Johnson, Vlissides), *Design Patterns: Elements of Reusable Object-Oriented Software*.

**The 4 essential elements**: name; problem (context, forces, applicability); solution (elements, relationships, responsibilities, collaborations); consequences (results and trade-offs).

**Full GoF description**: name and classification, intent, also known as, motivation, applicability, structure (UML), participants, collaborations, consequences, implementation, sample code, known uses, related patterns.

**Classification.**
- By **purpose**: creational (instantiation), structural (composition of classes and objects), behavioral (distribution of responsibilities and communication).
- By **scope**: class (static relationships, inheritance: Factory Method, class Adapter, Interpreter, Template Method) or object (dynamic relationships, composition: all the others).
- In short: "creational is about instantiation; structural is the blueprint; behavioral is the pattern of relationships among objects".

---

## Creational patterns

They abstract instantiation and make the system independent of how its objects are created. A **class** creational pattern uses inheritance to vary the instantiated class; an **object** creational pattern delegates instantiation to another object.

### Singleton
- **Intent**: ensure a class has only one instance and provide a global point of access to it.
- **When**: exactly one instance must exist (registry, configuration, pool, logger), reachable from a well-known access point; the sole instance should be extensible by subclassing.
- **Consequences**: + controlled access, less namespace pollution, easy to switch to N instances; − hidden global state, coupling, **hard to test**, concurrency pitfalls.
- **Safe implementation (Java)**: `enum Singleton { INSTANCE; }`, the *holder* idiom (static nested class), or double-checked locking with `volatile`. The naive lazy version is **not thread-safe**.
- **Recommendation**: in practice, let the DI container manage a single instance (`@Singleton`, Spring's singleton scope) and inject the interface.
- **Why not a global variable?** A Singleton can be created lazily (on first use), controls its instantiation, can be subclassed and hides its implementation.

### Simple Factory (idiom, not a GoF pattern)
- Move conditional `new` code into a dedicated object (`SimplePizzaFactory.createPizza(type)`). A first step toward encapsulating creation.

### Factory Method
- **Intent**: define an interface for creating an object, but let subclasses decide which class to instantiate.
- **When**: a class cannot anticipate the class of objects it must create; subclasses should decide (`PizzaStore.createPizza()` is abstract, `NYPizzaStore` and `ChicagoPizzaStore` override it).
- **Participants**: Creator (with the factory method and the code using the product), ConcreteCreator, Product, ConcreteProduct.
- **Consequences**: + removes dependencies on concrete classes, respects OCP; − one Creator subclass per product.

### Abstract Factory
- **Intent**: provide an interface for creating **families** of related or dependent objects without specifying their concrete classes.
- **When**: the system must be configured with one of several product families (regional pizza ingredients, Windows or Mac widgets, database drivers); products of a family must be used together.
- **Relation to other patterns**: each Abstract Factory method is often a Factory Method; it can also use Prototypes; the concrete factory is often a Singleton.
- **Consequences**: + family consistency, easy family swap; − adding a **new product type** forces changes to every factory.
- **Factory Method or Abstract Factory?** Factory Method creates **one** product through inheritance (a method). Abstract Factory creates **a family** of products through composition (a factory object).

### Builder
- **Intent**: separate the construction of a complex object from its representation so the same construction process can create different representations.
- **When**: many optional parameters (the *telescoping constructor*), step-by-step construction, immutable objects, several representations (HTML, PDF or Markdown document).
- **Participants**: Builder, ConcreteBuilder, Director (optional), Product.
- **Modern variant**: the fluent builder (`Pizza.builder().size(L).cheese().build()`), with validation in `build()`.

### Prototype
- **Intent**: specify the kinds of objects to create using a prototypical instance, and create new objects by copying it.
- **When**: classes to instantiate are known at runtime; to avoid a factory hierarchy parallel to the product hierarchy; creating an object is expensive and copying is cheaper.
- **Consequences**: + add and remove products at runtime, fewer subclasses; − each prototype must implement `clone`, circular references are hard to clone.
- **Implementation**: a prototype manager (registry); choose between **shallow and deep copy**.

### Exercise: the SmartVille bank
Several account types (savings, checking, Islamic…), new types added under competitive pressure, branches in several regions. Typical solution: abstract `Account` and its subclasses; **Factory Method** (`Branch.openAccount(type)` overridden by regional branches) or **Abstract Factory** if each region has its own product family (account, card, rates); adding an account type = adding a class without touching clients (OCP).

---

## Structural patterns

They describe how to assemble classes and objects into larger structures. Object composition allows the structure to change at runtime, which static inheritance does not.

### Adapter (Wrapper)
- **Intent**: convert the interface of a class into another interface clients expect. It lets classes with incompatible interfaces work together.
- **When**: integrating a third-party library, a legacy system or a component whose interface cannot change (the `TurkeyAdapter` posing as a `Duck`).
- **Variants**: **object** adapter, through composition (recommended); **class** adapter, through multiple inheritance (of target and adaptee).
- **Exercise** (a `DuckAdapter` turning a `Duck` into a `Turkey`): a turkey only flies short distances. To simulate the gap, the adapter can call `duck.fly()` only once out of N, at random. Adapting semantics is a genuine responsibility of the adapter.
- **In CBSE**: the adapter reconciles incompatible required and provided interfaces (parameters, operation names, incompleteness).

### Facade
- **Intent**: provide a unified, higher-level interface to a set of interfaces in a subsystem, making it easier to use.
- **When**: a complex subsystem (the *home theater*: turn on amp, projector, screen, lights…; a compiler: scanner, parser, code generator); to decouple clients from the subsystem; to layer a system.
- **Consequences**: + simplicity, loose coupling; − risk of a "god object" if the facade grows. Clients can still access the subsystem directly.
- **Adapter or Facade?** Both can wrap several classes. The Adapter **converts** an interface into an expected one; the Facade **simplifies** an interface.

### Bridge
- **Intent**: decouple an abstraction from its implementation so the two can vary independently.
- **When**: two orthogonal dimensions would cause subclass explosion (`Shape × DrawingAPI`, `Notification × Channel`, `Remote × Device`); choosing or switching implementation at runtime.
- **Difference with Adapter**: the Bridge is decided **at design time**; the Adapter fixes an incompatibility **after the fact**.

### Composite
- **Intent**: compose objects into tree structures to represent part-whole hierarchies; clients treat individual objects and compositions uniformly.
- **When**: menus and submenus, file systems, org charts, bills of materials, scene graphs, ASTs.
- **Participants**: Component (common operations), Leaf, Composite (children; `add`, `remove`, `getChild`).
- **Trade-off**: transparency (child operations in Component) **or** safety (only in Composite). Head First's `MenuComponent` picks transparency, hence default methods throwing `UnsupportedOperationException`.
- **Exercise**: the `Waitress` printing vegetarian items. Combine Composite and Iterator (a composite iterator walking the whole tree).

### Decorator
- **Intent**: attach additional responsibilities to an object dynamically. A flexible alternative to subclassing for extending functionality.
- **When**: combinations of optional responsibilities (beverages and condiments: `new Whip(new Mocha(new Mocha(new DarkRoast())))`); Java I/O streams (`BufferedInputStream(FileInputStream)`); middleware, logging, caching, retry around a service.
- **Key facts**: a decorator has the same supertype as the decorated object; decorators can be stacked; it adds behavior before or after delegating; decoration can happen at runtime.
- **Consequences**: + avoids class explosion, respects OCP; − many small objects, object identity changes, decorator order matters, code relying on the concrete type breaks.
- **Decorator or Proxy?** Same structure. The Decorator **adds** responsibilities; the Proxy **controls access** to the same service.

### Flyweight
- **Intent**: use sharing to support large numbers of fine-grained objects efficiently.
- **Principle**: separate **intrinsic** state (shared, immutable) from **extrinsic** state (supplied by the context). A factory caches shared instances.
- **When**: characters in a text editor, particles, trees on a game map, tiles. Real examples: `Integer.valueOf` caching −128..127, string interning.

### Proxy (Surrogate)
- **Intent**: provide a surrogate for another object to control access to it.
- **Variants**: **remote** (RMI stub, EJB, client generated from a WSDL), **virtual** (lazy loading of an image or a JPA entity), **protection** (access rights), **smart** (reference counting, caching, logging). Spring AOP and `@Transactional` rely on dynamic proxies.

---

## Behavioral patterns

They deal with algorithms and the assignment of responsibilities between objects, and describe how they communicate. **Class** behavioral patterns use inheritance (Template Method, Interpreter); **object** ones use composition.

### Chain of Responsibility
- **Intent**: avoid coupling a request's sender to its receiver by giving several objects a chance to handle it; the request travels along a chain until one handles it.
- **When**: servlet filters, HTTP middleware, validation chains, hierarchical approval (an amount approved by the manager, then the director…), UI event handling.
- **Pitfall**: a request may be handled by no one; provide a default link.

### Command
- **Intent**: encapsulate a request as an object, to parameterize clients with requests, queue them, log them and support undo.
- **Participants**: Command (`execute`, `undo`), ConcreteCommand, Invoker (remote control, button, queue), Receiver (light, document), Client.
- **When**: undo/redo, macros, job queues, transactions, replay logs, UI buttons decoupled from the action.

### Interpreter
- **Intent**: given a language, define a representation for its grammar along with an interpreter that uses it to interpret sentences. Map a domain to a language, the language to a grammar, and the grammar to a hierarchical OO design.
- **Structure**: AbstractExpression (`interpret(Context)`), TerminalExpression, NonterminalExpression (one class per grammar rule: `AndExpression`, `OrExpression`), Context, Client (builds the AST). The AST is a **Composite**.
- **When**: a **simple** grammar where efficiency is not critical (business rules, filters, boolean expressions). For complex grammars, use a parser generator (ANTLR).

### Iterator
- **Intent**: access the elements of an aggregate sequentially without exposing its underlying representation.
- **When**: traversing heterogeneous collections uniformly (the diner menu as an array and the pancake house menu as an `ArrayList`); several simultaneous traversals. In modern languages, use the native iterator (`Iterable`, generators, `yield`).

### Mediator
- **Intent**: define an object that encapsulates how a set of objects interact. It reduces coupling by keeping objects from referring to each other directly.
- **When**: interdependent form widgets, an air traffic control tower, a chat room. Pitfall: the mediator can become a "god object".

### Memento
- **Intent**: without violating encapsulation, capture and externalize an object's internal state so it can be restored later.
- **Participants**: Originator (creates and restores the memento), Memento (state opaque to others), Caretaker (keeps the history without reading its content).
- **When**: undo, checkpoints, rollback. **Command or Memento for undo?** Command undoes by running the inverse operation; Memento restores a snapshot. They are often combined.

### Observer (Publish-Subscribe)
- **Intent**: define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.
- **Structure**: Subject (`attach`, `detach`, `notify`), ConcreteSubject (state, `getState`), Observer (`update`), ConcreteObserver.
- **When**: an abstraction has two dependent aspects; a change must trigger others without knowing how many; notifying without knowing the receivers (the weather station, MVC model and views, UI events).
- **Loose coupling**: the subject only knows the Observer interface; observers can be added without changing the subject; subjects and observers are reusable independently.
- **Push or pull**: the subject sends the data, or the observer fetches it.
- **Pitfalls**: memory leaks (unsubscribe), notification order not guaranteed, update cascades, exceptions stopping notification. `java.util.Observable` is **deprecated** since Java 9; use `PropertyChangeListener`, Flow/Reactive Streams or an event bus.

### State
- **Intent**: allow an object to alter its behavior when its internal state changes; the object appears to change its class.
- **When**: state conditionals in many methods (gumball machine, order `Created → Paid → Shipped → Delivered`, TCP connection, document workflow).
- **Structure**: Context (holds the current state and delegates), State (interface), ConcreteStates (handle transitions).
- **State or Strategy?** Same structure. In State, states **replace themselves** and the client does not choose them; in Strategy, the **client chooses** the algorithm.

### Strategy (Policy)
- **Intent**: define a family of algorithms, encapsulate each one and make them interchangeable; the algorithm varies independently of the clients using it.
- **Participants**: Strategy (`SortStrategy`), ConcreteStrategy (`QuickSort`, `MergeSort`), Context (`SortedList`, holding a reference to a Strategy).
- **Examples**: `Collections.sort(list, comparator)`; payment methods or shipping fee computation in an online shop; duck flying or quacking behavior.
- **Modern idiom**: a functional interface and lambdas, or a `Map<Key, Strategy>` replacing a `switch`.

### Template Method
- **Intent**: define the skeleton of an algorithm in a method, deferring some steps to subclasses. Subclasses redefine those steps without changing the algorithm's structure.
- **Head First example**: `CaffeineBeverage.prepareRecipe()` is `final` and calls `boilWater()`, `brew()` (abstract), `pourInCup()` and `addCondiments()` (abstract); `Coffee` and `Tea` only override the varying steps.
- **Hooks**: methods with a default implementation that a subclass may override (`customerWantsCondiments()`).
- **Hollywood principle**: the parent class calls the subclasses, not the other way around. The central pattern of white-box frameworks.
- **Template Method or Strategy?** Inheritance and variation of **steps**, versus composition and variation of **the whole algorithm**.

### Visitor
- **Intent**: represent an operation to be performed on the elements of an object structure. Define a new operation without changing the element classes.
- **Mechanism**: **double dispatch**. `element.accept(visitor)` calls `visitor.visitConcreteElementX(this)`.
- **When**: the hierarchy is **stable** but operations change often (compiler AST: type checking, code generation, pretty printing; XML, JSON or PDF export; price or tax computations).
- **Trade-off**: adding an operation is easy, adding an element type is hard (every visitor must change). Modern alternative: sealed types and *pattern matching* (Java 21, Kotlin, Rust, TypeScript discriminated unions).

---

## Concurrency patterns

| Pattern | Role |
|---|---|
| Active Object | Decouple method execution from invocation (request queue, dedicated thread, futures) |
| Monitor Object | Synchronize access to an object's methods (lock and conditions, `synchronized`) |
| Double-Checked Locking | Cheap thread-safe lazy initialization (requires `volatile` in Java) |
| Reactor | Demultiplex I/O events to handlers on an event loop (Node.js, Netty, WebFlux) |
| Proactor | Same with asynchronous I/O and completion callbacks |
| Thread-Specific Storage | Per-thread global state (`ThreadLocal`) |
| Producer-Consumer | A blocking queue between producers and consumers |
| Thread Pool | Reuse a fixed set of threads (`ExecutorService`) |
| Read-Write Lock | Concurrent reads, exclusive writes |

---

## Commonly confused patterns

| Pair | Difference |
|---|---|
| Adapter / Facade | Convert an interface / simplify a subsystem |
| Adapter / Bridge | After the fact, for compatibility / at design time, to vary two dimensions |
| Decorator / Proxy | Add responsibilities / control access |
| Decorator / Composite | One wrapped component adding behavior / several children, aggregating |
| Strategy / State | Chosen by the client / internal transitions |
| Strategy / Template Method | Composition, whole algorithm / inheritance, a few steps |
| Factory Method / Abstract Factory | One product, through inheritance / a family, through composition |
| Command / Memento (undo) | Inverse operation / snapshot restore |
| Observer / Mediator | One-to-many broadcast / centralized many-to-many coordination |
| Chain of Responsibility / Decorator | A link can stop the chain / every decorator runs |

## Language idioms

- **Java / C#**: GoF patterns apply as-is. Prefer `enum` for simple Singleton and State, functional interfaces and lambdas for Strategy and Command, records for value objects, `sealed` interfaces and pattern matching instead of Visitor when possible.
- **Python**: first-class functions (Strategy, Command), the module as a singleton, `@decorator` (careful: a Python decorator wraps a **function**, which is not exactly the Decorator pattern), `__iter__` and generators (Iterator), `copy.deepcopy` (Prototype), `abc.ABC` and `Protocol` for interfaces.
- **JavaScript / TypeScript**: functions and closures, ES modules as singletons, `EventEmitter` or `EventTarget` (Observer), native `Proxy`, discriminated unions and exhaustive `switch` instead of Visitor.
- **Kotlin**: `object` (Singleton), `by` (delegation, handy for Decorator), `sealed class` (State, Visitor), higher-order functions.
- **Go**: implicit interfaces, composition by embedding, no inheritance. Template Method becomes a function taking an interface; Strategy becomes an interface or a function.
- **Dart / Flutter**: `factory` constructors, `mixin`, `Stream` (Observer), `ChangeNotifier`.
- **Rust**: traits (Strategy), `enum` with `match` (State, Visitor), native `Iterator`, newtype (Adapter), RAII (resource Proxy).

## Classic exercises and their typical solution

| Situation | Pattern |
|---|---|
| Part-whole hierarchical structure | Composite |
| Instantiating a family of consistent objects | Abstract Factory |
| Interpreting a small language | Interpreter |
| Undoing operations | Command and/or Memento |
| Traversing a collection without exposing its structure | Iterator |
| Combinable beverages and condiments (Starbuzz) | Decorator |
| Franchised pizza stores with different styles | Factory Method, plus Abstract Factory for ingredients |
| Weather station and its displays | Observer |
| Coffee and tea with similar recipes | Template Method |
| Home theater | Facade |
| A turkey posing as a duck | Adapter |
| Sorting by different criteria (`Collections.sort`) | Strategy |
| Cafeteria (menu, items, ingredients, orders, invoice) | Composite (menu), Decorator (extras), Observer (kitchen notified), State (order lifecycle), Strategy (pricing), Iterator |
