# Design and code review checklist

Go through it in order. Only report what has a **concrete impact**: a bug, a risk, an evolution cost. Do not report a style preference the project does not follow.

## 1. Correctness (always first)
- [ ] The code does what is asked, including edge cases (empty, null, zero, negative, very large, Unicode, time zones).
- [ ] Errors are handled: no swallowed exception, no overly broad `catch`, resources released (try-with-resources, `with`, `finally`).
- [ ] Concurrency: shared state protected, no race conditions, replayed processing is idempotent.
- [ ] Transactions: correct boundaries, no network call inside a database transaction.

## 2. Security
- [ ] Input validated at the boundaries; parameterized queries (no SQL, command or path injection).
- [ ] Authentication and authorization checked server-side, per resource (no IDOR).
- [ ] No secrets in code or logs; personal data minimized.
- [ ] Dependencies up to date and free of known vulnerabilities.

## 3. Design
- [ ] **SRP**: each class or module has a single reason to change.
- [ ] **OCP**: adding a foreseeable case does not require editing existing code in several places.
- [ ] **LSP**: no subclass cancels, disables or throws on an inherited method.
- [ ] **ISP**: no catch-all interface forced on clients.
- [ ] **DIP**: the domain depends on neither framework, database nor network; dependencies are injected.
- [ ] Coupling: no cyclic dependency, no `a.b().c().d()` chain, no access to another module's internals.
- [ ] Cohesion: what changes together is grouped together.
- [ ] Patterns used are **justified** by a real problem; no over-engineering (YAGNI).
- [ ] A pattern is missing where a smell calls for it (repeated `switch` on a type, subclass explosion…).
- [ ] Composition is preferred to inheritance, except for a true "is-a" relation.
- [ ] Clear API contracts: DTOs separate from entities, correct HTTP codes, standard errors, versioning.

## 4. Readability and maintainability
- [ ] Names reveal intent and follow the domain language.
- [ ] Short functions at a single level of abstraction; little nesting (guard clauses).
- [ ] No duplicated **knowledge**; no magic numbers.
- [ ] Comments explain the **why**, not the what; no dead or commented-out code.
- [ ] Consistent with the project's existing conventions.

## 5. Tests
- [ ] New behaviors and fixed bugs have tests.
- [ ] Tests are deterministic, isolated and readable; they test behavior, not implementation.
- [ ] Error cases and edge cases are covered.

## 6. Performance (if relevant)
- [ ] No N+1 queries, no needless full loads, pagination present.
- [ ] Algorithmic complexity fits the volume; caching justified and correctly invalidated.
- [ ] Network calls have timeouts; no blocking I/O on an event loop.

## 7. Operations
- [ ] Useful, structured logs without sensitive data; metrics and traces on critical paths.
- [ ] Externalized configuration; versioned, reversible schema migrations.
- [ ] Backward compatibility of APIs and messages (existing consumers).

---

## Report format

```
## Summary
<2 or 3 sentences: overall state, main risks>

## Findings
### Critical
- `path/file.ext:42` — <violated principle or rule> — <concrete scenario: which input or state produces which wrong result> — **Fix**: <proposal, with a code snippet if useful>

### Major
- ...

### Minor
- ...

## Strengths
- <what is well designed and should be kept>
```

Severity:
- **Critical**: bug, security flaw, data loss or corruption.
- **Major**: principle violation that will make foreseeable changes costly or risky; missing tests on critical logic.
- **Minor**: readability, naming, small duplication.
