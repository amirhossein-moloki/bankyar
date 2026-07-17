# BankYar Coding Standards and AI Development Constitution

**Document Status:** Official & Enforced
**Engineering Authority:** Level 0 (Highest)
**Applicability:** All Humans, AI Models, Autonomous Agents, and Code Generation Tools
**Target Architecture:** Clean Architecture & Feature-First vertical slices (Flutter/Dart context)

---

## Part I: Foundations & Governance

### 1. Engineering Philosophy
The BankYar engineering culture is governed by three fundamental pillars: **Privacy by Design**, **Absolute Simplicity**, and **AI-First Maintainability**.
* **Zero-Trust Network Principle:** Privacy is not a feature; it is our core identity. The codebase must be engineered to function 100% offline, under the permanent assumption that no network socket is available.
* **Deterministic Dominance:** Business rules must rely on deterministic pipelines. Heuristics are accepted only as a secondary, sandboxed fallback.
* **Uncompromising Decoupling:** Every software component must exist in isolation, exposing only the minimum surface area required for feature composition.

### 2. Coding Principles
Development in BankYar requires adherence to four core principles:
1. **Explicit over Implicit:** Avoid magic numbers, obscure routing, implicit conversions, or implicit state changes. Everything must be declared and visible.
2. **Defensive Coding:** Every incoming input, platform channel message, and file read must be validated at its boundary. Do not allow raw errors to bubble into business logic.
3. **Single Source of Truth (SSOT):** State and data must live in a single authorized container (e.g., Riverpod state providers or the local SQLite instance). Never duplicate state across UI elements.
4. **Immutability First:** All domain models, events, and data states must be strictly immutable to avoid side effects in highly asynchronous mobile environments.

---

### 3. SOLID Rules
All code structures must conform strictly to SOLID guidelines:

| Principle | Core Directive | Measurement Metric | Target Application |
| :--- | :--- | :--- | :--- |
| **S**ingle Responsibility (SRP) | A class or module must have exactly one reason to change. | Class length < 250 lines; < 5 public methods. | Separate parsing, formatting, database operations, and state notifier actions into dedicated classes. |
| **O**pen/Closed (OCP) | Software entities should be open for extension, but closed for modification. | Use of polymorphic interfaces over conditional type checks. | Extend parser rules via custom JSON templates, never by appending hardcoded logic inside the core parsing engine. |
| **L**iskov Substitution (LSP) | Subtypes must be completely substitutable for their base types. | 0 occurrences of type downcasting or runtime type-exception bypasses. | Repositories must behave identically whether backed by production SQLite or in-memory mocks. |
| **I**nterface Segregation (ISP) | Clients should not be forced to depend on methods they do not use. | Interface signatures restricted to < 3 functional behaviors. | Split large repositories into discrete, query-specific interfaces (e.g., separating write hooks from analytical read-only streams). |
| **D**ependency Inversion (DIP) | High-level modules must not depend on low-level modules; both must depend on abstractions. | 100% of data sources injected via constructors of abstract repository contracts. | No direct database, file system, or key store access from state holders. Use injected interface abstractions. |

---

### 4. Clean Code Rules
* **No Side Effects:** Functions must not alter global states, static variables, or parameters passed by reference.
* **Intention-Revealing Names:** Variable names must express their conceptual purpose, not their data type (e.g., use `reconciliationCutoffDate` instead of `dateVal`).
* **Clean Conditionals:** Extract complex boolean conditions into descriptively named variables.
* **Fail Fast:** Place guard clauses at the beginning of functions to return or throw early, reducing indentation levels.

---

## Part II: Architecture & Structure

### 5. Clean Architecture Rules
The system is divided into three physical layers with strict boundaries:

```
+-------------------------------------------------------------+
|                     PRESENTATION LAYER                      |
| (UI Widgets, Pages, Riverpod Notifiers, Presentation Models) |
+------------------------------+------------------------------+
                               |
                               | Depends on (Inward only)
                               v
+-------------------------------------------------------------+
|                        DOMAIN LAYER                         |
| (Core Entities, Use Cases, Abstract Repository Interfaces)  |
+-------------------------------------------------------------+
                               ^
                               | Implements (Inward only)
                               |
+-------------------------------------------------------------+
|                         DATA LAYER                          |
| (SQLCipher DAOs, Models/DTOs, Secure Storage, Mappers)      |
+-------------------------------------------------------------+
```

* **No Outer Framework Leaks in Domain:** The `domain/` directory must be written in pure Dart. It must not import `flutter/material.dart`, Riverpod packages, SQLCipher drivers, or platform integrations.
* **No Database in UI:** UI screens must never reference table names, SQL statements, or cursor mappings.

---

### 6. Feature Isolation Rules
BankYar uses a strict **Feature-First** structure.
* **Directory Cohesion:** A feature must reside entirely under `lib/features/[feature_name]/`.
* **Zero Cross-Layer Violations:** A feature's presentation folder cannot import the data folder of another feature.
* **Inter-Feature Communication:**
  - Standard features communicate only via abstract Domain Interfaces.
  - Shared capabilities (e.g., security, standard exceptions, databases) must live in `lib/core/` and can be imported across features.

---

### 7. Naming Conventions

| Component | Case Rule | Suffix Requirement | Architectural Example Pattern |
| :--- | :--- | :--- | :--- |
| **Entities** | PascalCase | `Entity` | `[FeatureName]Entity` |
| **Data Models (DTOs)** | PascalCase | `Dto` or `Model` | `[FeatureName]Dto` |
| **Use Cases** | PascalCase | `UseCase` | `[Verb][Noun]UseCase` |
| **Repositories (Abstract)** | PascalCase | `Repository` | `I[FeatureName]Repository` |
| **Repositories (Concrete)**| PascalCase | `RepositoryImpl` | `[FeatureName]RepositoryImpl` |
| **State Notifiers** | PascalCase | `Notifier` | `[ScreenName]Notifier` |
| **UI Widgets** | PascalCase | `Widget` / `Screen` | `[ScreenName]Screen` |
| **Data Sources** | PascalCase | `DataSource` | `[SourceName]DataSource` |

---

### 8. Folder Conventions
Every feature under `lib/features/[feature_name]/` must strictly adhere to the following folder structure:
* `data/`
  * `datasources/` (Concrete data fetchers, SQLite DAOs, Secure Storage bindings)
  * `models/` (JSON models, database-specific DTOs)
  * `repositories/` (Concrete implementations of the domain interfaces)
* `domain/`
  * `entities/` (Immutable business entities)
  * `repository/` (Abstract contracts defining data access)
  * `usecases/` (Single-purpose use case interaction classes)
* `presentation/`
  * `screens/` (Full screen views)
  * `widgets/` (Isolated UI components)
  * `state/` (Riverpod state notifiers, UI state objects)

---

### 9. File Organization Rules
To maintain searchability and ease of navigation:
* **Single Class per File:** Every file must contain exactly one primary class. Small, highly-related helper classes or enums can exist in the same file only if they do not exceed 20 lines.
* **Ordering of Members:** Members inside any Dart class must follow this strict ordering:
  1. Static constants and static methods.
  2. Instance variables (final first, then non-final).
  3. Constructor definitions.
  4. Factory constructors.
  5. Public methods.
  6. Private methods.
  7. Overridden methods (e.g., `toString`, `hashCode`, `==`).

---

## Part III: Quality, Metrics & Constraints

### 10. Maximum File Size
No file in the repository may exceed **300 lines of code** (excluding comments and imports). If a file exceeds this threshold, it is a clear architectural indicator that the component is violating the Single Responsibility Principle and must be modularized.

### 11. Maximum Class Size
No class may contain more than **250 lines of code** or define more than **5 public methods**. Private helper methods must be extracted to pure utility modules if they grow past 3 methods.

### 12. Maximum Function Size
* **Public Functions:** Maximum **30 lines of code**.
* **Private Helpers:** Maximum **15 lines of code**.
* **Cyclomatic Complexity:** The complexity metric of any function must not exceed **8**. High complexity (nested switches, excessive loops) must be split into polymorphism or smaller pure functions.

### 13. Widget Composition Rules
* **No Monolithic Widgets:** A widget file must never exceed **150 lines**.
* **Build Method Limit:** The `build` method of any widget must not exceed **40 lines**.
* **Extraction over Nesting:** If a widget tree has a nesting depth exceeding **3 levels**, the nested subtree must be extracted into a separate private widget or custom stateless component.
* **No Business Logic in Widgets:** Widgets must only parse UI state and trigger actions on state notifiers. Calculations, sorting, formatting, or data validation must occur inside use cases, repositories, or presentation state notifiers.

---

## Part IV: Layer-Specific Rules & Patterns

### 14. State Management Rules
* **Riverpod Exclusivity:** Riverpod is the sole approved state management and dependency injection framework. Service locators (e.g., GetIt) or manual DI classes are strictly prohibited.
* **Unidirectional Flow:** UI widgets read state and send intents. Notifiers update state immutably. Use cases stream data from repositories. No component may bypass this flow.
* **State Immutability:** All UI state models must be declared final, utilizing standard copy-with methodologies for updates.

### 15. Repository Rules
* **Abstract Contracts First:** All features must declare their data requirements via an abstract repository interface inside the `domain/repository/` folder.
* **Exception Translation:** Repository implementations must catch database-specific exceptions (SQLite, Cryptographic key issues) and map them cleanly to domain-specific `Failure` objects before returning.

### 16. Use Case Rules
* **Single Action Principle:** A Use Case must perform exactly one business action. It must declare a single public executing method (e.g., `call` or `execute`).
* **No State Retention:** Use Cases must be stateless. They contain dependencies (repositories, other use cases) injected via constructor, but retain no execution-state fields.

### 17. Service Rules
* **External Integration Isolation:** Services represent low-level platform APIs (e.g., native SMS listeners, Keystore hooks). They must reside in `core/` or `data/datasources/` and be wrapped behind abstract adapters.

### 18. Entity Rules
* **Zero Library Dependencies:** Entities are pure business records. They must be completely clear of external models, third-party JSON serialization packages, database engines, or UI components.
* **Immutability:** Every field inside an Entity must be marked `final`.

### 19. DTO (Data Transfer Object) Rules
* **Serialization Boundary:** DTOs represent database rows or external file structures. They must reside in `data/models/` and contain all JSON parsing/mapping helper functions.
* **No Leakage:** DTOs must never leak into the `presentation` layer. They must be converted into Entities before leaving the `data` layer boundary.

### 20. Mapper Rules
* **Explicit Conversions Only:** Data layer entities must provide explicit, clean conversion hooks (e.g., `toEntity()` and `fromEntity()`) to map between DTOs and pure domain entities. Avoid implicit typing or dynamic casts.

### 21. Dependency Rules
* **Inward Directives:** Dependencies must only point inward toward the Domain.
* **Circular Dependencies:** Circular imports between files, folders, or features are strictly forbidden. Any dependency cycle will result in an immediate build block.

---

## Part V: Reliability, Privacy & Security

### 22. Error Handling Rules
* **Result Pattern Enforced:** Do not throw unhandled exceptions across architectural layers. All public operations in repositories and use cases must return a type-safe `Result` container (e.g., functional `Either` or standard union types) capturing a `Failure` or a `Success`.
* **Zero UI Crashes:** The presentation layer must map failures to clear, friendly user prompts. No raw system stack trace or SQL exception is allowed to be visible on screen.

### 23. Logging Rules
* **Strict PII Scrubbing:** All financial figures, bank identifiers, custom notes, names, or raw SMS body texts must be scrubbed from logs before persisting. Replace numeric strings with `[REDACTED_NUM]` and merchant info with generic markers.
* **Offline-Only Logging:** Diagnostics must be written to an encrypted, localized log file with automatic log rotation at **2MB** (retaining a maximum of 3 files). Remote telemetry, Firebase Analytics, or Sentry are strictly prohibited.

### 24. Documentation Rules
* **100% Public API Documentation:** Every public class, method, property, and interface in the repository must be documented using standard triple-slash `///` Dart documentation comments.
* **Explain the 'Why':** Documentation must focus on architectural intent, invariants, and edge-cases, rather than explaining trivial language syntax.

### 25. Comment Policy
* **Self-Documenting Code First:** Code must express itself through clean names and simple structures. Comments should only exist to explain complex algorithms, hardware-backed Keystore workarounds, or regulatory constraints.
* **No Commented-Out Code:** Dead or commented-out blocks of code are considered technical pollution. They must be deleted immediately. Use version control history to recover old code.

### 26. TODO Policy
* **Standard Format:** Every TODO comment must include the author's identifier, issue tracker reference (if applicable), and clear action items.
  * Pattern: `// TODO(username, #issue): Clear actionable task description.`
* **Pre-Release Clean:** No code can be merged into stable or release branches containing open TODO comments.

### 27. Deprecation Policy
* **Explicit Annotations:** Deprecated code must be explicitly annotated using `@deprecated` with clear documentation pointing to the modern replacement.
* **Scheduled Deletion:** Deprecated components must be completely deleted in the next minor version release.

---

### 28. Security Rules
* **No Plaintext Keys:** Cryptographic keys, credentials, or sensitive configurations must never be stored in plaintext. They must be generated and managed inside secure hardware (Android Keystore / iOS Secure Enclave).
* **Screen Privacy:** Enable secure UI overlay protections natively (`FLAG_SECURE` on Android) to completely redact transaction totals, balances, and dashboard metrics from screenshots, screen recorders, and recent-app multitasking switchers.
* **No Database Bypass:** All persistent financial items must be routed through the encrypted SQLCipher instance. Directly writing to unsecured text files, shared preferences, or device storage caches is strictly prohibited.

---

### 29. Performance Rules
* **Main-Thread Purity:** The main UI isolate thread must remain unblocked at all times to maintain a minimum of **60fps/120fps**.
* **Off-Thread Processing:** All file operations, SQLCipher writes, regular expression compilations, and complex mathematical aggregations must execute asynchronously or in custom background isolates.
* **Const Constructors:** Use `const` constructors on UI widgets wherever possible to minimize frame redrawing overhead.

---

### 30. Memory Rules
* **Key Eviction:** Master database decryption keys must be immediately scrubbed from RAM memory if the application remains in the background for more than 5 minutes.
* **Resource Cleanup:** All streams, database connections, animations, and controller objects must be explicitly disposed of inside the appropriate lifecycle hooks.

### 31. Async Rules
* **Avoid `async Void`:** Async actions must return `Future<void>`, never `void`, to ensure caller synchronization is possible.
* **Strict Timeout Controls:** All database lookups and file interactions must be guarded with explicit timeouts (maximum **5 seconds**) to prevent cold locks in UI threads.

---

## Part VI: Testing & Validation

### 32. Testing Rules
* **Testing Pyramid Requirements:**
  - Unit Tests: 70% of coverage (focus on SMS parsing engines, heuristic mappers, and domain logic).
  - Integration Tests: 20% of coverage (database operations, state flow).
  - Golden/UI Tests: 10% of coverage (screen layout correctness, biometric screens).
* **Minimum Test Coverage Gates:**
  - Core SMS parsing & metadata extraction logic: **100% test coverage**.
  - Rest of the codebase: **85% test coverage**.
* **No Flaky Tests:** Test execution must be deterministic. Any test containing arbitrary delays (`sleep`, manual long timeouts) must be refactored to use mock clocks, fake timers, or mock schedulers.

---

## Part VII: Engineering Process & Checklists

### 33. Code Review Checklist
Before any Pull Request is assigned to a reviewer, the author must verify that:
- [ ] Code strictly compiles with 0 errors, 0 warnings, and 0 linter hints.
- [ ] No file exceeds the maximum 300-line threshold.
- [ ] 100% of public APIs are documented using `///` comments.
- [ ] No TODO comments or commented-out code blocks remain.
- [ ] No database operations or platform-specific APIs are called from UI files.
- [ ] Unit test coverage on the affected code meets or exceeds the required 85% threshold (100% for parsers).

---

### 34. Static Analysis Rules
* **Strict Compiler Options:** The compiler is configured in `analysis_options.yaml` with:
  - `strong-mode: implicit-casts: false`
  - `strong-mode: implicit-dynamic: false`
* **Treat Warnings as Errors:** All warnings flagged by the compiler must be resolved. The build system will reject any pull request containing a warning.

### 35. Lint Rules
The project enforces strict, pedantic Dart rules. Mandatory inclusions:
* `always_declare_return_types`
* `avoid_empty_else`
* `avoid_relative_lib_imports`
* `cancel_subscriptions`
* `close_sinks`
* `prefer_const_constructors`
* `unawaited_futures`

### 36. Formatting Rules
* **Strict Formatting Enforcement:** All Dart files must be formatted using the official Dart formatter:
  - Line limit: **80 characters**
  - Indentation: **2 spaces**
  - Run formatting checks inside local pre-commit hooks and CI pipelines.

---

### 37. Refactoring Rules
* **Boy Scout Rule:** Always leave the codebase cleaner than you found it. If you touch a file, fix minor linter issues or format warnings in that file.
* **Safe Refactoring Bounds:** Refactoring must not alter existing unit tests unless the underlying business domain rule has been explicitly modified by an approved product change.

### 38. Merge Requirements
For a branch to be eligible for merge into the main branch, it must satisfy:
1. Green compilation on all target platform environments.
2. 100% pass rate on all unit, integration, and UI tests.
3. Successful completion of static analysis and formatting validation.
4. Mandatory approval from at least one Principal/Lead Architect.

### 39. Release Readiness Rules
A release is ready to build when:
* **Security Audit Pass:** Manifest has been inspected to verify 100% absence of `android.permission.INTERNET`.
* **Zero Warnings:** Static analyzer returns 0 items.
* **Backup Verification:** Complete import/export flows have been verified to restore transaction ledgers cleanly.

---

## Part VIII: AI Coding & Constitution

This section outlines mandatory constraints for AI models, automated agents, and code-generation tools. AI models must recognize that these rules sit above implementation prompts in operational authority.

### 40. AI Coding Rules
* **Never Violate Clean Architecture:** AI must reject any request that places database logic in the UI layer or imports framework code into the domain layer.
* **No Direct DB Access:** AI must never bypass the abstract Repository layer. Direct access to the database or preferences from view screens or state providers is strictly forbidden.
* **Generate Immutable Models:** All models, state objects, and entities generated by AI must utilize final properties and include immutability support helpers.
* **No Business Logic Duplication:** Do not write duplicate calculations or parsing rules. Reuse existing domain logic use cases.
* **No Circular Dependencies:** Verify that any new import introduced does not cause a dependency circle.

### 41. AI Prompt Rules
When requesting changes or code reviews, the prompt structure must enforce:
* Specifying the precise target file and layer (Presentation, Domain, or Data).
* Providing the exact linter expectations.
* Mandating that any generated change must match existing architecture specifications.

### 42. AI Self-Review Rules
Before outputting code or completing a task, the AI model must run a self-evaluation:
* Did I introduce any external framework dependencies into the `domain/` directory?
* Are all properties in my generated classes immutable?
* Have I kept the cyclomatic complexity of my routines below 8?
* Did I document all new public structures?

### 43. AI Refactoring Rules
* AI refactoring must maintain existing unit tests.
* If the AI refactors a class, it must break it down into smaller, single-purpose classes if it exceeds the 250-line maximum limit.

### 44. AI Quality Gates
AI is structurally constrained by the following numeric thresholds:

```
+-----------------------------------------------------------+
|                     AI QUALITY GATES                      |
+-----------------------------------------------------------+
|  Metric                           | Strict Limit          |
+-----------------------------------+-----------------------+
|  Maximum File Size                | 300 lines of code     |
|  Maximum Class Size               | 250 lines of code     |
|  Maximum Widget File Size         | 150 lines of code     |
|  Maximum Method / Function Size   | 30 lines of code      |
|  Maximum Cyclomatic Complexity    | 8                     |
|  Maximum Nesting Depth            | 3 levels              |
|  Maximum Method Parameters        | 4 parameters          |
|  Maximum Public Methods per Class | 5 public methods      |
|  Minimum Public API Doc Coverage  | 100%                  |
|  Minimum Base Unit Test Coverage  | 85% (100% for parser) |
+-----------------------------------------------------------+
```

---

### 45. Architecture Compliance Rules
To maintain code consistency, any change must satisfy this structural compliance matrix:

| Action | Allowed Path | Forbidden Action | Compliance Verification Mechanism |
| :--- | :--- | :--- | :--- |
| **Read Transaction Ledger** | Presentation watches use case stream. | UI directly reading SQLite DAO. | Check UI imports; reject on `sqflite` or `sqlcipher` references. |
| **Add Transaction** | Presentation calls `AddTransactionUseCase`. | Notifier directly accessing Database Source. | Verify that the state notifier depends exclusively on domain use cases. |
| **Parse SMS text** | Ingestion pipeline triggers `SmsParserEngine`. | Platform SMS receiver performing regex parsing. | Confirm platform channels hand off raw text to Dart data source directly. |
| **Encrypt Master Key** | Security layer binds KeyStore during setup. | Saving password or database key to standard plaintext. | Check that no SharedPreferences contains keys or raw encryption strings. |

---

### 46. Technical Debt Policy
* **Refactoring Budget:** 20% of engineering time during each iteration cycle must be dedicated to resolving technical debt or updating linter findings.
* **Debt Tracking:** All known technical debt items must be filed in the tracker with clear technical descriptions and estimated remediation times.

---

### 47. Definition of Done (DoD)
A task is considered **Done** only when:
1. The code has been fully implemented in accordance with this Constitution.
2. The code passes the official static analyzer and linter with 0 findings.
3. Formatter has been executed across all modified files.
4. Unit tests have been written, covering 100% of the newly added business logic.
5. All local tests run and pass without failures.
6. Code contains zero networking references, conforming to the absolute offline guarantee.
7. PR has been approved by the architecture lead.

### 48. Definition of Ready (DoR)
A backlog task is considered **Ready** for implementation only when:
1. It contains clear, non-ambiguous functional requirements.
2. It lists concrete acceptance criteria.
3. Its dependency features are already implemented and stable.
4. It is aligned with previous architectural specifications.

---

### 49. Engineering Checklist
* [ ] Compiles cleanly on local environment with zero errors or warnings.
- [ ] No file exceeds 300 lines of code.
- [ ] No class exceeds 250 lines of code.
- [ ] All functions have complexity < 8 and parameters < 4.
- [ ] No external dependencies are added to the pure Dart Domain layer.
- [ ] All public APIs have `///` documentation comments.
- [ ] Database access is strictly confined to Data sources and wrapped in Repositories.
- [ ] Code is 100% offline-ready, with no networking permissions or connections.

---

### 50. Future Evolution Strategy
* **Modular Package Extraction:** As the feature set scales, vertical feature slices under `lib/features/` should be extracted into isolated Dart/Flutter packages (multi-package workspace architecture) to enforce physical modular boundaries at the compilation level.
* **On-Device Intelligent Classifiers:** While current parsing relies on deterministic regular expressions, future updates can introduce on-device heuristic ML models (e.g., TensorFlow Lite). The state management and use case layers must remain agnostic to this transition, requiring only updates in the isolated parser data source layer.

---

## Part IX: Anti-pattern Catalog & Trade-off Analysis

To prevent architectural drift under rapid development, this catalog defines key anti-patterns to avoid, references core Architectural Decision Records (ADRs), and addresses technical trade-offs.

### Anti-pattern Catalog

#### 1. The "Network Leak" (The Silent Breach)
* **Description:** Introducing a package or platform module that implicitly initializes external network communication (e.g., a third-party analytical tool or telemetry visualizer).
* **Consequence:** Immediate violation of the privacy guarantee, leading to a permanent failure of security audits.
* **Remediation:** Keep the OS-level Manifest clear of `android.permission.INTERNET` under all circumstances.

#### 2. The "Smart UI Widget" (The Fat Widget)
* **Description:** Writing logic for text extraction, monetary conversion, or state formatting inside the build method of a screen widget.
* **Consequence:** Results in highly nested UI, frame drops during rendering, and un-testable business rules.
* **Remediation:** Keep build methods strictly declarative. Move processing logic to the presentation state holder (Riverpod Notifier) or the domain use case.

#### 3. The "Abstract Bypass" (The Direct Pipeline)
* **Description:** Accessing database DAOs, key-value stores, or secure storage systems directly inside the presentation layer or from state notifiers.
* **Consequence:** Breaks the decoupling of layers, making it impossible to mock resources for unit tests or swap platforms.
* **Remediation:** Always inject abstract Repository interfaces into use cases or state managers.

#### 4. The "Circular Loop" (The Cycle Trap)
* **Description:** Importing files from feature A into feature B, while feature B imports files from feature A, forming a direct cyclic reference.
* **Consequence:** Increases compilation times, leads to memory leaks, and breaks the clean multi-package extraction roadmap.
* **Remediation:** Move shared entities or configurations to the `core/` folder or communicate exclusively via injected domain interfaces.

---

### Architectural Decision Record (ADR) References

The coding standards defined in this constitution align directly with the following baseline ADRs:
* **ADR-001 (Clean & Feature-First Architecture):** Enforces separation of presentation, domain, and data layers inside vertical, isolated feature directories under `lib/features/`.
* **ADR-002 (SQLCipher Encryption):** Mandates that all persistent transaction logs utilize relational table models page-encrypted via AES-256.
* **ADR-003 (Riverpod DI & State):** Establishes Riverpod as the exclusive framework for dependency injection and unidirectional state presentation.
* **ADR-004 (Secure Hardware Keys):** Requires that the master database key is stored securely in platform-native KeyStore/Secure Enclave via secure storage interfaces.
* **ADR-005 (Platform-Independent Parser):** Mandates that all core parsing rules are executed in pure Dart, ensuring consistent behavior across Android and iOS environments.

---

### Trade-off Analysis

#### 1. Immutability vs. Heap Allocation
* **The Choice:** Enforce strict immutability for all entities, models, and UI state objects.
* **The Trade-off:** Immutability requires frequent allocations of new objects using `copyWith` methods, introducing minor garbage collection overhead on older devices. However, this is heavily outweighed by the elimination of multi-threaded race conditions, predictable reactive state updates, and robust testability.

#### 2. Dependency Injection via Riverpod vs. Native Service Locators
* **The Choice:** Exclusively utilize Riverpod for both dependency injection and state management.
* **The Trade-off:** Riverpod requires minor configuration boilerplate for provider declarations. However, it provides compile-time safety for dependency injection, removes runtime initialization errors, and allows mock overrides during unit tests without complex mock libraries.

#### 3. Pure Dart Domain vs. Direct Framework Integration
* **The Choice:** Keep the domain layer 100% written in pure Dart, free of any Flutter, Riverpod, or third-party database imports.
* **The Trade-off:** Requires writing extra boilerplate use case wrappers and explicit repository contracts. However, this guarantees that core financial rules are highly portable, can be tested in standard command-line environments without virtual devices, and are completely isolated from future framework updates.
