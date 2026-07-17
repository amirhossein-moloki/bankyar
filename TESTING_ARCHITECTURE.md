# BankYar Testing & Quality Assurance Architecture Specification

**Project Name:** BankYar
**Classification:** Enterprise Testing Strategy & QA Architecture
**Document Version:** 1.0.0
**Authors:** Principal QA Architect, Test Automation Engineer, Software Quality Expert, and Enterprise Flutter Architect
**Status:** Approved / Quality Baseline

---

## Executive Summary

BankYar is an offline-first, highly secure mobile application that intercepts cellular SMS, extracts structured financial metadata, maintains an encrypted local ledger, and computes rich on-device statistics. It operates with an absolute **zero-network footprint** (no internet permission declared), ensuring that no user data ever leaves the device.

To guarantee enterprise-level reliability, correctness, and long-term maintainability under collaborative human-AI development workflows, this document defines the comprehensive **Testing and Quality Assurance Strategy** for the BankYar application. This architecture ensures high-precision validation of the parsing engine, robust isolation of features, hardened verification of security boundaries, and predictable quality gates—all while remaining strictly at the **Architectural Level**, without compiling executable test cases or CI configuration files.

---

## Table of Contents
- [1. Testing Philosophy](#1-testing-philosophy)
- [2. Testing Pyramid](#2-testing-pyramid)
- [3. Test Architecture](#3-test-architecture)
- [4. Test Layers](#4-test-layers)
- [5. Unit Testing Strategy](#5-unit-testing-strategy)
- [6. Domain Testing Strategy](#6-domain-testing-strategy)
- [7. Use Case Testing](#7-use-case-testing)
- [8. Repository Testing](#8-repository-testing)
- [9. Database Testing](#9-database-testing)
- [10. Parser Testing](#10-parser-testing)
- [11. Regex Testing](#11-regex-testing)
- [12. Widget Testing](#12-widget-testing)
- [13. Integration Testing](#13-integration-testing)
- [14. End-to-End Testing](#14-end-to-end-testing)
- [15. Golden Testing](#15-golden-testing)
- [16. Snapshot Testing](#16-snapshot-testing)
- [17. Security Testing](#17-security-testing)
- [18. Permission Testing](#18-permission-testing)
- [19. Performance Testing](#19-performance-testing)
- [20. Memory Testing](#20-memory-testing)
- [21. Battery Consumption Testing](#21-battery-consumption-testing)
- [22. Backup & Restore Testing](#22-backup--restore-testing)
- [23. Import / Export Testing](#23-import--export-testing)
- [24. Notification Testing](#24-notification-testing)
- [25. Accessibility Testing](#25-accessibility-testing)
- [26. Localization Testing](#26-localization-testing)
- [27. Regression Testing](#27-regression-testing)
- [28. Smoke Testing](#28-smoke-testing)
- [29. Acceptance Testing](#29-acceptance-testing)
- [30. AI Validation Strategy](#30-ai-validation-strategy)
- [31. Code Coverage Policy](#31-code-coverage-policy)
- [32. Quality Gates](#32-quality-gates)
- [33. Test Data Management](#33-test-data-management)
- [34. Mocking Strategy](#34-mocking-strategy)
- [35. Fake Objects Strategy](#35-fake-objects-strategy)
- [36. Test Fixtures](#36-test-fixtures)
- [37. Continuous Testing Strategy](#37-continuous-testing-strategy)
- [38. Release Validation](#38-release-validation)
- [39. Risk-Based Testing](#39-risk-based-testing)
- [40. Future Testing Roadmap](#40-future-testing-roadmap)
- [41. Feature Test Matrix](#41-feature-test-matrix)
- [42. Quality Gate Tables](#42-quality-gate-tables)
- [43. AI Testing Workflow](#43-ai-testing-workflow)
- [44. Architectural Decision Records (TADR)](#44-architectural-decision-records-tadr)
- [45. Trade-off Analysis](#45-trade-off-analysis)
- [46. Best Practices](#46-best-practices)

---

## 1. Testing Philosophy

BankYar's QA philosophy is built upon the dual foundations of **Reliability by Design** and **Correctness by Verification**. Because BankYar operates with a strict zero-network constraint and houses highly sensitive financial data, software quality is not a post-development step—it is a core engineering constraint.

The quality philosophy is governed by five core tenets:
* **The Single Source of Truth for Correctness:** All validations must run locally and deterministically. Testing suites must simulate cellular telecommunications, database failures, and platform security boundaries hermetically on-device without cloud dependencies.
* **Shift-Left Integration:** Verification begins at the earliest possible stage. Business invariants are asserted during domain modeling, regular expressions are validated for ReDoS safety during template construction, and unit tests execute automatically on every local commit.
* **Unidirectional, Deterministic Flows (UDF):** By utilizing Clean Architecture with Feature-First modularity and Riverpod state managers, we ensure that every application state mutation is predictable. The UI reacts solely to immutable state models, allowing automated tests to reproduce and verify any visual condition directly from state histories.
* **AI-First Maintainability:** As an AI-assisted codebase, test suites are structured to be highly readable for both human engineers and LLM agents. Strict naming conventions, modular test boundaries, and explicit mock definitions allow AI agents to generate, run, and self-correct unit tests with minimal friction.
* **Total Privacy-Preserving Verification:** Testing must never expose personally identifiable information (PII) or financial parameters. Test data sets are generated using synthetic mock profiles, and raw messages are scrubbed before storage verification.

---

## 2. Testing Pyramid

To balance execution speed, execution cost, and system-level confidence, BankYar implements a custom, offline-first **Testing Pyramid**. The distribution of tests is designed to maximize compile-time safety and minimize execution times.

```
                  /\
                 /  \     End-to-End Tests (< 1%) [Manual / Native WorkManager]
                /    \
               /      \   Golden & Accessibility UI Tests (~ 4%)
              /────────\
             /          \  Integration & State Flow Tests (~ 15%) [Riverpod Overrides]
            /────────────\
           /              \  Widget & Component Tests (~ 20%) [Isolated UI Layouts]
          /────────────────\
         /                  \  Unit, Domain & Regex Tests (~ 60%) [Pure Dart, Fast RAM]
        /────────────────────\
```

### Allocation & Rationale:
* **Unit & Regex Layer (60%):** Validates pure business logic, domain invariants, entity structures, regex compilations, and cryptographic utilities. Runs in RAM inside pure Dart containers with zero UI or database disk overhead, completing in `< 10ms` per test.
* **Widget Layer (20%):** Tests visual layout components in isolation. Verifies that design system tokens, empty states, and input forms render correctly without launching full application routers or active databases.
* **Integration Layer (15%):** Tests interactions between features, Riverpod state notifiers, and database adapters using in-memory SQLite files. Verifies unidirectional data flows from local SMS broadcasts down to persistent storage.
* **Golden & Accessibility Layer (4%):** Performs snapshot-based visual validations across multiple screen resolutions and locales, asserting that text layouts do not clipping under various system scales.
* **End-to-End Layer (1%):** Validates the critical user paths from native telephony SMS receipt to database decryption, biometric unlocks, and backup recovery. Runs on native emulators with hardware stubs.

---

## 3. Test Architecture

The testing architecture mirrors BankYar's **Clean Architecture** layout, ensuring a direct, logical separation of concerns.

```
       +───────────────────────────────────────────────────────────+
       │                      TEST ARCHITECTURE                    │
       +─────────────────────────────┬─────────────────────────────+
                                     │
                                     ▼
       +─────────────────────────────┴─────────────────────────────+
       │                     Presentation Tests                    │
       │  - Widget isolated interactions, theme variations         │
       │  - Golden visual snapshot matches                         │
       │  - State Notifier transition verifications                 │
       +─────────────────────────────┬─────────────────────────────+
                                     │ Depends On
                                     ▼
       +─────────────────────────────┴─────────────────────────────+
       │                        Domain Tests                       │
       │  - Pure Dart business Use Case executions                 │
       │  - Entity invariant checks (Strict Type validations)      │
       │  - Regex safety (ReDoS checks) and Parser mapping rules   │
       +─────────────────────────────┬─────────────────────────────+
                                     │ Depends On
                                     ▼
       +─────────────────────────────┴─────────────────────────────+
       │                        Data Tests                         │
       │  - SQLCipher in-memory table operations, indices, and DAOs │
       │  - Repository implementations catching platform errors    │
       │  - Secure Storage key wrapping configurations             │
       +───────────────────────────────────────────────────────────+
```

* **Hermetic Boundary Rule:** Test suites are strictly prohibited from crossing architectural boundaries without explicit mocking. A Unit Test validating a Domain Use Case must never instantiate a physical SQLCipher connection; it must interact with an abstract repository interface stub.

---

## 4. Test Layers

BankYar isolates verifications into five highly structured Test Layers, each with specific execution parameters, isolation rules, and mocking requirements:

| Test Layer | Targeted Components | Primary Execution Tool | Mocking Policy | Speed Target |
| :--- | :--- | :--- | :--- | :--- |
| **Unit** | Pure Dart Entities, Value Objects, Regexes, and Cryptography. | Standard Dart Test VM | Strictly mocked databases and hardware platform APIs. | `< 10ms` / test |
| **Widget** | UI Widgets, Forms, Theme loaders, and localized layouts. | Flutter Widget Tester | Providers overridden with mock values; navigation routes mocked. | `< 50ms` / test |
| **Integration**| Use Cases, Notifiers, and Database Repositories. | Riverpod `ProviderContainer` | SQLCipher configured to run in-memory; biometrics mocked. | `< 200ms` / test|
| **UI Golden** | Visual Screens, Custom Charts, and Form layouts. | Flutter Golden Test Engine | Strict platform stubs; fonts and theme assets pinned. | `< 500ms` / test|
| **End-to-End** | Telephony workers, Keystore decrypts, and Backup restores. | Flutter Driver / Emulator | Real SQLite file system; platform biometrics stubbed. | `< 5s` / test |

---

## 5. Unit Testing Strategy

Unit Testing forms the foundation of BankYar's correctness validation. It verifies that individual modules, utilities, and helper classes perform as expected under isolated conditions.

* **Target Components:** Cryptographic key derivation functions (PBKDF2), PII scrubbing log filters, date calculators, string normalizers, and JSON serializers.
* **Isolation Rules:** Unit tests must operate entirely in-memory with zero dependencies on disk storage, native OS frameworks, or UI rendering pipelines.
* **Assertion Pattern:** Strictly implements the **AAA Pattern (Arrange-Act-Assert)**:
  1. *Arrange:* Configure the class inputs, setup expected mock behaviors, and initialize system state.
  2. *Act:* Execute the target function under test.
  3. *Assert:* Verify that return parameters match expectations, or that expected exceptions are propagated correctly within custom `Result` structures.

---

## 6. Domain Testing Strategy

The Domain Layer houses pure, platform-independent business rules. Domain Testing ensures that BankYar's core financial rules and entities remain structurally correct and free of external package dependencies.

* **Target Components:** `Transaction` aggregates, `MonetaryAmount` value objects, `ParserTemplate` models, and auto-categorization structures.
* **Verification Methods:** Assert that domain invariants are enforced during instantiation (e.g., verifying that a transaction amount is always greater than zero, or that currency codes conform to three-character ISO 4217 uppercase parameters).
* **Immutable Mutation Testing:** Ensures that copy-with mutation helpers correctly return fresh, modified instances while keeping original objects intact, protecting the main UI thread from concurrent-write bugs.

---

## 7. Use Case Testing

Use Cases orchestrate the business logic of the application. Use Case Testing verifies that these workflows interact correctly with repository interfaces.

```
[ Arrange: Instantiate Mock Repository ] ──► [ Inject Into Use Case Constructor ]
                                                     │
                                                     ▼ Act
                                        [ Execute UseCase.call() ]
                                                     │
                                                     ▼ Assert
                                    [ Verify Result State is Success/Failure ]
                                    [ Verify Repository Invoked Exactly Once ]
```

* **Target Components:** `GetTransactionsStreamUseCase`, `AddManualTransactionUseCase`, `DeleteTransactionUseCase`, `ProcessSmsUseCase`.
* **Mocking Policy:** Repositories are replaced with Mockito or Mocktail stubs, allowing tests to configure mock database return values and verify that use cases invoke repository write statements exactly once.
* **Failure Propagation Checks:** Verifies that when a repository returns a database error, the use case captures the failure, maps it to a domain-specific `Failure` type, and returns it cleanly inside a `Result` structure without raising a runtime crash.

---

## 8. Repository Testing

Repository Testing validates that concrete data-layer adapters correctly translate database tables and DTOs into pure domain entities, while wrapping low-level platform errors safely.

* **Target Components:** `TransactionRepositoryImpl`, `SmsCaptureRepositoryImpl`, `SecurityConfigRepositoryImpl`.
* **Database Stubs:** Utilizes SQLCipher connection pools configured to run in-memory, ensuring that SQL statements compile, indexes are utilized, and transactional rollbacks operate correctly.
* **Error Handling Audits:** Verifies that when SQLCipher raises a page locked or filesystem out-of-space exception, the repository catch-blocks intercept the error, redact any sensitive file paths or data, write a warning to diagnostic logs, and return a clean `DatabaseCorruptionFailure` or `StorageDiskFullFailure`.

---

## 9. Database Testing

Database Testing ensures that the local SQLCipher storage engine is highly performant, resilient to power failures, and structurally correct.

### Target Areas of Validation:
1. **Schema Integrity:** Verifies table columns, data types, nullability constraints, and unique indices against database specification files.
2. **Referential Integrity (Foreign Keys):** Tests cascading deletion rules (e.g., asserting that deleting a category updates related transactions to "Uncategorized", and that deleting a transaction purges related notes and tag associations).
3. **Migration Safe-Runs:** Runs automated step-by-step schema migrations (e.g., migrating v1 schema files up to v2), verifying that existing transaction logs are preserved and indexes are rebuilt.
4. **Transaction Rollback Resilience:** Simulates write failures during batch processes (such as importing a 1,000-row CSV statement) and verifies that the database rolls back to its pre-transaction state, leaving no partial data.

---

## 10. Parser Testing

The SMS parsing pipeline is BankYar's primary data-ingestion mechanism. Parser Testing must be robust and exhaustive to prevent regressions when new bank formats or language dialects are introduced.

* **Target Components:** Deterministic regex engines, keyword matchers, and fallback heuristic tokenizers.
* **Mock Ingestion Pipeline:** Replays historical SMS carrier texts in-memory, checking that metadata (amounts, currencies, merchant names, card indexes, timestamps) are extracted correctly and match expectations.
* **Low Confidence Flags Validation:** Verifies that when the deterministic parser fails, the heuristicfallback classifier processes key figures and flags the transaction as "Parsed - Low Confidence", highlighting fields in the UI for user verification.
* **Deduplication Tests:** Verifies that the deduplication hash checks correctly identify and reject duplicate cellular messages.

---

## 11. Regex Testing

Regular expressions can be vulnerable to catastrophic backtracking (Regular Expression Denial of Service - ReDoS). Regex Testing ensures that all patterns compile safely and execute efficiently.

* **Backtracking Audits:** Analyzes regular expression patterns to ensure they do not contain nested quantifiers or overlapping structures (e.g., `(a+)+`), which can cause exponential evaluation times when matched against complex inputs.
* **Regex Timeout Enforcement:** Verifies that regex matching operations are configured with strict execution timeout limits (typically 100 milliseconds), aborting evaluations if they exceed limits.
* **Edge-Case Inputs Testing:** Tests regular expressions against malformed inputs, truncated strings, and long non-matching strings to ensure they reject invalid data without causing execution delays or app crashes.

---

## 12. Widget Testing

Widget Testing verifies that user interface components (pages, cards, buttons, charts) render correctly and process user inputs predictably in isolation.

* **Target Components:** Chronological ledger list cards, monthly cash-flow charts, custom category selectors, and PIN entry keypads.
* **Scoped State Injection:** Tests use Riverpod container overrides to inject mock states into widgets, bypassing databases and background workers.
* **Input Action Verification:** Simulates user gestures (taps, drags, text entry) and verifies that:
  - Tapping a transaction card expands the detail inspector instantly.
  - Entering an incorrect PIN displays red warning text and disables submit buttons.
  - Selecting date filters triggers the appropriate state notifier commands.

---

## 13. Integration Testing

Integration Testing verifies that multiple modules, state providers, and repositories interact correctly under realistic execution environments.

```
   [ SMS Captured Worker ] ──► [ Deduplication Hash Check ]
                                          │
                                          ▼ If Unique
                             [ Regex Pattern Matching ]
                                          │
                                          ▼ If Parsed
                            [ In-Memory SQLCipher Write ]
                                          │
                                          ▼ Reactive Push
                       [ UI Ledger Widget Refresh (60fps+) ]
```

* **Scope of Validation:** Verifies the complete unidirectional flow from raw SMS ingestion to database write and reactive UI updates.
* **Execution Environment:** Runs in-memory with Riverpod provider configurations, testing state synchronization across ledger screens, cash-flow charts, and category editors.
* **Lifecycle State Transitions:** Verifies that background tasks can write to the database concurrently while the main UI thread is active, ensuring smooth 60fps+ scrolling with zero frame-drops.

---

## 14. End-to-End Testing

End-to-End (E2E) Testing validates complete, high-priority user journeys from boot to shutdown, running on native emulators with hardware stubs.

### Targeted Critical Flows:
1. **The First-Run Experience:** Onboarding tutorial sequence $\rightarrow$ PIN registration $\rightarrow$ Master DB key generation $\rightarrow$ Landing on an empty Ledger view.
2. **The Secure Resume:** Background suspension $\rightarrow$ 5-minute timeout countdown $\rightarrow$ Memory key eviction and database close $\rightarrow$ App resume $\rightarrow$ Biometric authentication prompt $\rightarrow$ Restored dashboard.
3. **The Disaster Recovery:** Database corruption alert $\rightarrow$ Open clean database $\rightarrow$ File picker select backup file $\rightarrow$ PIN decryption validation $\rightarrow$ Restored transaction ledger.

---

## 15. Golden Testing

Golden Testing prevents visual regressions by comparing screenshots of rendered widgets against approved "golden" reference images.

* **Target Components:** Spending allocation pie charts, monthly cash-flow graphs, and multi-parameter filter cards.
* **Visual Parity Rules:** Pinned custom typography fonts, exact device screen sizes (e.g. 1080x1920), and strict theme modes (Light vs Dark) are enforced during golden renders to avoid minor pixel mismatches caused by native system renders.
* **Scale and Contrast Verification:** Renders pages under high-contrast settings and larger system text scales to verify that layout boxes expand dynamically without clipping text.

---

## 16. Snapshot Testing

Snapshot Testing ensures that serialized outputs (JSON schemas, custom template configurations, backup headers, and local configurations) remain structurally consistent and backward-compatible.

* **Target Configurations:** Exported backup JSON structures, custom QR-code rule formats, and local preferences schemas.
* **Backward Compatibility Audits:** Verifies that older backup versions can be successfully parsed and migrated by the current import engine, ensuring users can restore data across app updates.

---

## 17. Security Testing

Because BankYar handles sensitive financial information, security verification is a critical quality gate.

```
              ┌──────────────────────────────────────────────┐
              │               SECURITY TESTING               │
              └──────────────────────┬───────────────────────┘
                                     │
         ┌───────────────────────────┼───────────────────────────┐
         ▼                           ▼                           ▼
┌──────────────────┐        ┌──────────────────┐        ┌──────────────────┐
│ SANDBOX BREACH   │        │ CRYPTO HARDENING │        │ INTERNET CHECK   │
│ - Bypass biometric│        │ - PBKDF2 GCM tags│        │ - Manifest audits│
│ - Inspect SQLite │        │ - Key RAM evict  │        │ - Port scanning  │
└──────────────────┘        └──────────────────┘        └──────────────────┘
```

### Critical Security Assertions:
1. **Sandbox Breach Protection:** Attempts to read sandboxed database files without credentials, asserting that SQLCipher rejects connections and leaks 0% plaintext.
2. **Cryptographic Hardening Verification:** Verifies backup files are encrypted using standard AES-GCM-256 and derived using PBKDF2 with 100,000 iterations.
3. **Volatile Key Eviction Check:** Simulates background suspension, verifying that after 5 minutes, database keys are zeroized in RAM and database connections are closed.
4. **Internet Permission Absence Audits:** Programmatically inspectscompiled manifest files to confirm `android.permission.INTERNET` is absent, guaranteeing zero network transmissions.

---

## 18. Permission Testing

Permission Testing ensures that the application behaves predictably when OS-level permissions are modified or revoked.

* **SMS Ingestion Fallback:** Simulates the user denying background SMS capture permissions, verifying that background listeners are disabled and the UI displays fallback copy-paste manual indicators prominently.
* **Storage Access Fallback:** Verifies that when storage permissions are missing, backup and CSV import features are disabled, displaying helpful instructions guiding the user to system settings to grant permissions.

---

## 19. Performance Testing

Performance Testing ensures that BankYar remains highly responsive on low-end hardware, maintaining a fast and smooth user experience.

* **Target Benchmarks:**
  - Database search queries must resolve in `< 50ms`.
  - Background SMS parsing and database insertion must execute in `< 300ms`.
  - App cold startup duration must complete in `< 500ms`.
  - Scrolling on the main ledger must maintain a stable 60fps+ (and up to 120fps on supporting displays) with zero frame-drops.
* **Isolate Isolation Checks:** Verifies that heavy database queries, bulk CSV statement imports, and backup encryption tasks run in separate background isolates, keeping the main UI thread responsive.

---

## 20. Memory Testing

Memory Testing prevents memory leaks and out-of-memory (OOM) crashes on resource-constrained devices.

* **Auto-Disposal Audits:** Verifies that transient screen-level providers (e.g. form states, search query buffers) are fully disposed and cleared from RAM when the user exits the screen.
* **Low-Memory Reaction checks:** Simulates operating system low-memory warnings (`onTrimMemory` on Android) and verifies that the app clears in-memory caches and flushes unused state providers to free up memory.
* **RAM String Clean-ups:** Verifies that sensitive variables (such as plaintext database keys or PIN byte arrays) are zeroized immediately after usage, leaving no plaintexts in garbage-collectable memory.

---

## 21. Battery Consumption Testing

Operating background capture workers can impact mobile battery life. Battery Testing ensures BankYar remains efficient.

* **Target Metrics:** Background SMS monitoring and metadata parsing must consume less than **0.5%** of the total daily battery usage.
* **Power State Verification:** Verifies background processes use native scheduling managers (e.g. Android `WorkManager`) to schedule heavy database optimizations during device charging and idle cycles, reducing battery drain.

---

## 22. Backup & Restore Testing

This test suite verifies the integrity of the user-controlled backup system, protecting historical records from data loss.

* **Encryption Strength Validation:** Verifies that backups are securely encrypted using AES-GCM-256, and that decryption attempts with incorrect passwords are rejected, leaving the local database unchanged.
* **Integrity Tag Checks:** Verifies that the restore service checks GCM authentication tags and schema versions before writing data, protecting the database from corrupted backup files.
* **Full Recovery Loop Verification:** Performs full backup-to-restore cycles, verifying that transactions, notes, categories, tags, and custom templates are restored perfectly with zero data loss.

---

## 23. Import / Export Testing

Import and Export testing verifies data portability across formats and handles malformed statements safely.

* **CSV Parser Safety:** Tests the CSV import pipeline against malformed statements, empty rows, invalid date structures, and missing column indices to ensure it parses valid rows and flags errors without crashing.
* **Bulk Import Performance:** Measures performance when importing a 10,000-row CSV statement, verifying that processing and deduplication are executed off the main thread in background isolates, maintaining a responsive UI.

---

## 24. Notification Testing

Notification Testing verifies that native tray alerts are displayed correctly and respect user privacy.

* **Redacted Lockscreen Previews:** Verifies that notifications are set to `VISIBILITY_PRIVATE`, ensuring that sensitive details (amounts, merchants, currencies) are hidden on secure lock screens and are only visible when the device is unlocked.
* **Channel Registration Validation:** Verifies that notification channels (e.g. High Importance channels for transactions, Medium Importance channels for system warnings) are registered correctly on startup.

---

## 25. Accessibility Testing

Accessibility Testing ensures BankYar is highly usable for all individuals, including those with visual, auditory, or physical impairments.

* **Screen Reader Compatibility:** Verifies that all UI controls, charts, and form fields contain accurate semantic labels (`Semantics` in Flutter) for screen readers (Google TalkBack).
* **Text Scaling Adjustments:** Tests page layouts under extreme system font scales (e.g., 200%), verifying that text wraps dynamically and does not clip or overflow layout boundaries.
* **Minimum Touch Targets:** Asserts that all interactive buttons, lists, and sliders have a minimum touch target size of 48x48 logical pixels to support physical accuracy.

---

## 26. Localization Testing

Localization Testing verifies that the application translates text and formats layouts correctly across supported languages completely offline.

* **Layout Parity (RTL vs LTR):** Verifies that Farsi (RTL) layouts mirror alignments and icons correctly, and that English (LTR) layouts render left-aligned text with standard margins.
* **Dictionary Keys Integrity:** Scans localization files (ARB) to ensure that no translation keys are missing, and that monetary symbols and calendar formats are formatted correctly.

---

## 27. Regression Testing

Regression Testing ensures that new features or refactorings do not introduce bugs into previously verified code paths.

* **Automated Test Runs:** Regression test suites run on every commit and pull request, covering core parsing pipelines, database migrations, and security authentication states.
* **No Telemetry Pushes:** Asserts that regression test runs do not generate external network connections, preserving BankYar's zero-network promise.

---

## 28. Smoke Testing

Smoke Testing is a fast, automated test suite that verifies critical core functions are working after a new build compilation.

* **Target Areas of Verification:**
  - The app boots successfully to the secure PIN registration or lock screen.
  - The Keystore decodes and decrypts test strings correctly.
  - The SQLCipher database initializes and decrypts test connections successfully.
  - An incoming mock SMS is parsed and inserted into the database.

If any of these critical checks fail, the build is rejected immediately before further testing.

---

## 29. Acceptance Testing

Acceptance Testing verifies that the application matches the business criteria defined in the Product Requirements Document (PRD).

* **User Acceptance Testing (UAT):** Real-world users test pre-release builds (Beta) to verify that banking SMS messages are captured and parsed with high accuracy, that cash-flow reports are helpful, and that the app lock operates securely.
* **Compliance Checks:** Ensures that all PRD functional requirements (FR-1.1 to FR-4.4) are met, and that zero external network connections are initialized under any operational scenario.

---

## 30. AI Validation Strategy

As an AI-assisted codebase, BankYar implements a specialized, AI-first testing and validation workflow to prevent architectural drift:

```
[ AI Generates Code Changes ] ──► [ Running Arch-Compliance Script ]
                                                │
                                                ▼ If Violations Found (e.g. Leak)
                                   [ Reject Merge & Flag Code Block ]
                                                │
                                                ▼ If Clean
                                   [ Run Pinned Unit & Regex Tests ]
```

### 1. Static Architecture Compliance Checks
Automated scripts analyze imports inside code contributions to enforce layer isolation rules:
- Verifies that files inside the `domain` layer contain exactly **zero references** to framework libraries (such as Riverpod, Material UI, or SQLCipher drivers).
- Verifies that `android.permission.INTERNET` remains completely absent from manifest configurations.

### 2. Automated Prompt Reviews
Ensures that developer prompts and AI-generated test files conform to Clean Architecture patterns, pinned dependency versions, and PII scrubbing guidelines.

### 3. Automated Refactoring Verifications
Validates that refactorings preserve core database models and migration schemas by running historical migration tests, ensuring 100% backward compatibility.

---

## 31. Code Coverage Policy

To ensure high reliability, BankYar enforces strict, non-negotiable code coverage thresholds on core modules:

$$\text{Overall Target: } \mathbf{> 85\% \text{ Unit \& Integration Test Coverage}}$$

```
┌────────────────────────────────────────────────────────┐
│                   MINIMUM COVERAGE MATRICES            │
├────────────────────────────────────────────────────────┤
│ - Domain Layer Use Cases: 100%                         │
│ - Parser Regex Templates: 100%                         │
│ - Database Repositories & Migrations: 90%              │
│ - Presentation Notifiers & State Notifiers: 80%        │
│ - UI Widgets & Golden Tests: 60%                       │
└────────────────────────────────────────────────────────┘
```

* **Automatic Checks:** Code coverage is calculated programmatically on every build. Pull requests that drop coverage levels below these thresholds are blocked from merging.

---

## 32. Quality Gates

Quality Gates are measurable quality requirements that must be satisfied before any release is approved.

### Measurable Quality Requirements:
1. **Zero Runtime Crashes:** The application must maintain a crash-free rate of **100%** on parsed, unrecognized, or duplicate SMS text structures.
2. **Strict Performance Thresholds:** App cold boot must complete in `< 500ms`, transaction parsing must execute in `< 200ms`, and database writes must complete in `< 100ms`.
3. **No PII Leaks:** Direct audits of diagnostic logs must verify that plaintext balances, raw cellular SMS strings, and account numbers are fully scrubbed.
4. **Complete Offline Guarantees:** Compilation logs must verify that no internet permissions are declared, and that network transmissions remain at exactly **0 bytes**.

---

## 33. Test Data Management

Managing test data requires high security to prevent PII leaks and ensure realistic test conditions.

* **Synthetic Data Generation:** Test data sets (simulating transaction ledgers, categories, and tags) are generated using synthetic mock profiles. Real-world financial figures and bank credentials are never committed to the repository.
* **Hermetic Sandbox Separation:** Test data is generated in in-memory SQLite instances, ensuring that tests do not leave residual files on developer machines.

---

## 34. Mocking Strategy

Mocking isolates components and speeds up test execution. BankYar implements a strict mocking strategy:

* **Mocking Boundary:** We mock external platform adapters and hardware systems (e.g. secure preferences, biometric scanners, and telephony APIs).
* **Behavior Verification:** Mocks are used to verify interactions, such as asserting that the `DeduplicationService` correctly queries the SMS repository before parsing begins, and that duplicate messages are rejected.

---

## 35. Fake Objects Strategy

Fakes provide lightweight, in-memory implementations of complex system components, making them ideal for integration and UI tests.

* **Fakes Over Mocks:** Instead of creating complex mock expectations for every test, we replace systems like secure storage and databases with lightweight in-memory fakes:
  - `FakeSecureStorage`: A simple string-map representation of secure preferences.
  - `In-Memory SQLite Database`: An in-memory database that executes actual SQL statement transactions and rollbacks in RAM.

---

## 36. Test Fixtures

Test Fixtures provide stable, pre-configured test data sets to keep tests consistent and readable.

* **Core Fixtures Catalog:**
  - `sms_fixtures.dart`: Contains static, raw bank SMS messages representing standard credit, debit, and balance alerts across multiple institutions.
  - `transaction_fixtures.dart`: Contains pre-configured transaction entities with standard categories, notes, and tags.
  - `template_fixtures.dart`: Contains pre-compiled regex templates and capture group indices.

---

## 37. Continuous Testing Strategy

Because BankYar contains no cloud connections, our automated quality checks run locally and during isolated build pipeline runs:

```
[ Code Commit ] ──► [ Run Smoke Tests ] ──► [ Run Unit & Regex Tests ]
                                                      │
                                                      ▼
                                       [ Run Integration & Golden Tests ]
                                                      │
                                                      ▼
                                       [ Compute Code Coverage & Quality Gates ]
```

* **Local Verification Hooks:** Pre-commit hooks run smoke tests, code linters, and core regex backtracking checks on the developer's machine before code is pushed to the repository.
* **Automated Builds Checks:** Run tests in isolated containers with network access completely disabled, verifying that all unit, integration, and golden tests pass successfully and satisfy coverage limits.

---

## 38. Release Validation

Before any application release is approved for distribution on public app stores, it must pass a rigorous Release Validation process:

- [ ] **Zero Internet Permission:** Confirm `android.permission.INTERNET` is completely absent from the Android Manifest.
- [ ] **Zero Telemetry Packages:** Verify that no third-party telemetry, crash-tracking (e.g. Crashlytics), or analytics (e.g. Firebase) SDKs are bundled in the compilation assets.
- [ ] **100% Quality Gates Passed:** Confirm overall code coverage exceeds 85%, and all smoke, golden, and integration tests pass successfully.
- [ ] **Active Code Obfuscation:** Verify that compilation flags (`--obfuscate`) are applied, replacing class and variable names with non-descriptive tokens.
- [ ] **Verified Database Decryption:** Confirm that attempting to read the database file without credentials results in a decryption failure.

---

## 39. Risk-Based Testing

Risk-Based Testing prioritizes test execution on high-impact, high-probability failure points.

| Risk ID | High-Risk Scenario | Severity | QA Countermeasure / Testing Action |
| :--- | :--- | :---: | :--- |
| **QR-01** | **Database Corruption:** Device power loss during transaction writes corrupts database file headers. | Critical | Run stress tests simulating sudden write interruptions, verifying that transactions are rolled back safely and database page integrity remains intact. |
| **QR-02** | **Regex Backtracking (ReDoS):** Complex user-defined rules patterns hang the CPU. | High | Run automated backtracking analyses on all regular expression templates, and enforce strict execution timeout limits (100ms) on parsing matches. |
| **QR-03** | **Key Eviction Failures:** Database decryption keys remain cached in memory when the app is suspended. | High | Run memory audits and dump RAM bytes, asserting that database keys and PIN byte arrays are completely zeroized after 5 minutes of background inactivity. |
| **QR-04** | **Unrecognized SMS Capture:** Bank updates its SMS layouts, breaking deterministic regex matches. | Medium | Test parser fallbacks, verifying that unrecognized messages are logged as unparsed transactions and saved to secure fallback tables. |

---

## 40. Future Testing Roadmap

The QA testing roadmap defines sequential phases to continuously expand BankYar's quality and testing capabilities:

* **Phase 1: Native Android Core (Current Target):** Establish standard unit, widget, and in-memory integration testing frameworks; verify regex ReDoS safety and database rollback integrity.
* **Phase 2: Universal Cross-Platform Verification:** Build Golden visual tests to support the upcoming iOS migration, and expand E2E testing to verify the iOS clipboard auto-detection and CSV statement import workflows.
* **Phase 3: Automated On-Device Performance Profiling:** Build automated performance profiling suites that monitor RAM footprints, battery consumption, and execution latencies directly on physical test devices, logging warning metrics inside diagnostic logs.

---

## 41. Feature Test Matrix

This matrix maps BankYar's core features to their target testing methods and coverage requirements, ensuring that every feature is thoroughly verified:

| Feature Name | Unit Testing | Integration Testing | Golden Testing | E2E Testing | Target Coverage | Primary QA Focus |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **SMS Capture** | **Yes** | **Yes** | No | **Yes** | **90%** | Validate background WorkManager listeners and telephony streams. |
| **SMS Parser** | **Yes** | **Yes** | No | **Yes** | **100%** | Validate deterministic regex and fallback heuristics. |
| **Bank Detection**| **Yes** | **Yes** | No | No | **95%** | Verify normalized sender ID lookups and keyword matching. |
| **Transactions Ledger**| **Yes** | **Yes** | **Yes** | **Yes** | **90%** | Verify seek-pagination, filters, and manual transaction entries. |
| **Notes & Tags** | **Yes** | **Yes** | No | No | **90%** | Validate aggregate boundaries and notes size constraints. |
| **Search (FTS)** | **Yes** | **Yes** | No | No | **90%** | Verify search queries and database trigger synchronization. |
| **Statistics** | **Yes** | **Yes** | **Yes** | No | **85%** | Verify cash-flow report calculations and charts layouts. |
| **Backup Export** | **Yes** | **Yes** | No | **Yes** | **95%** | Verify GCM-256 encryption, PBKDF2 iterations, and file directories. |
| **Restore Import** | **Yes** | **Yes** | No | **Yes** | **95%** | Verify tag checks, schema version validation, and database reboots. |
| **Notifications** | **Yes** | **Yes** | No | No | **80%** | Validate lockscreen redactions and visibility flags. |
| **Permissions** | **Yes** | No | No | **Yes** | **80%** | Verify fallback UI when SMS or storage permissions are denied. |
| **Settings** | **Yes** | **Yes** | **Yes** | No | **85%** | Verify dark theme transitions and localized dictionary loaders. |
| **Security Lock** | **Yes** | **Yes** | No | **Yes** | **95%** | Verify biometric prompts, PIN lockout limits, and key RAM evictions. |
| **Database Core** | **Yes** | **Yes** | No | No | **90%** | Verify ACID transaction rollbacks and database migrations. |

---

## 42. Quality Gate Tables

The table below defines our non-negotiable quality metrics and their measurable thresholds that must be satisfied before any release is approved:

| Quality Metric | Target Threshold | Primary Verification Method | Failure Action |
| :--- | :---: | :--- | :--- |
| **Unit Test Coverage** | **> 85%** | Automated coverage calculation scripts. | Block pull requests from merging. |
| **Critical Flow Coverage**| **100%** | Direct use case and E2E verification tests. | Block release approval. |
| **Parser Accuracy** | **> 98%** | Ingest static bank SMS test sets. | Block parsing template releases. |
| **Startup Duration** | **< 500ms** | Measures time from boot to lock screen. | Log performance warning in diagnostics. |
| **SMS Ingestion Latency**| **< 300ms** | Time from cellular SMS receipt to DB save. | Log performance warning in diagnostics. |
| **Database Query Speed** | **< 50ms** | Seek-pagination and search benchmarks. | Log performance warning in diagnostics. |
| **Battery Impact** | **< 0.5%** | Device-specific battery consumption monitors.| Optimize background WorkManager tasks. |
| **Memory Footprint** | **< 50MB** | RAM monitoring over scrolls and reports calculations. | Flush unused state providers; clean caches. |
| **Crash-Free Rate** | **100%** | Runs smoke and integration testing pipelines.| Block release approval; roll back build. |

---

## 43. AI Testing Workflow

BankYar leverages an automated, AI-first testing workflow to ensure code quality and prevent architectural regressions:

```
[ AI Code Contribution ] ──► 1. Run Static Code Linting
                                    │
                                    ▼
                             2. Run Architectural Compliance checks
                                    │ (Assert domain layer contains zero framework imports)
                                    ▼
                             3. Run Pinned Unit & Regex tests
                                    │ (Assert ReDoS safety and 100% parsing accuracy)
                                    ▼
                             4. Run Database Migration validation checks
                                    │ (Assert schemas compile and update backward-compatible)
                                    ▼
                       [ Approve & Merge Pull Request ]
```

### Static Analysis Safeguard Rule:
- Any file matching `lib/features/*/domain/` that imports `package:flutter_riverpod`, `package:sqflite`, or `package:flutter/material.dart` triggers an architectural violation, rejecting the pull request automatically.
- Any manifestation containing `android.permission.INTERNET` triggers a security violation, blocking compilation instantly.

---

## 44. Architectural Decision Records (TADR)

The testing and quality assurance architecture of BankYar is governed by three core Testing Architectural Decision Records:

### TADR-001: Pinned In-Memory Relational Integration Testing
* **Status:** Approved
* **Context:** Running integration tests on physical databases leaves stale files on disk, causes test interference, and degrades execution performance.
* **Decision:** We commit to standardizing integration and repository test environments using SQLCipher databases configured to run in-memory (`:memory:`).
* **Rationale:** In-memory databases are fast, run entirely in RAM, and are destroyed automatically when tests complete, ensuring clean and isolated testing states.

### TADR-002: Dynamic Riverpod Provider Overrides
* **Status:** Approved
* **Context:** Testing widgets in isolation requires bypassing active databases and system hardware scanners.
* **Decision:** Standardize on Riverpod's `ProviderContainer` overrides to inject mock repositories and fakes into tests.
* **Rationale:** This decouples UI widgets from platform dependencies, enabling fast, isolated widget testing without complex setup.

### TADR-003: Double-Sanitizer Regex Verifications
* **Status:** Approved
* **Context:** Automated testing of error logs and stack traces risks exposing sensitive transaction details or personal information in test outputs.
* **Decision:** Enforce the same PII-scrubbing regex pipeline inside testing utilities, redacting amounts and account numbers before writing test outputs to disk.
* **Rationale:** This ensures complete privacy compliance, preventing accidental leaks of financial information during automated QA runs.

---

## 45. Trade-off Analysis

Every architectural decision involves balancing multiple priorities. Below is the justification for the trade-offs made in BankYar's testing strategy:

### 1. In-Memory SQLite Fakes vs. Mocking Repository Interfaces
* **The Choice:** We use in-memory SQLite fakes for Integration testing, and mock repository interfaces for Use Case testing.
* **Trade-off Analysis:** Mocking repository interfaces is faster and requires less setup. However, it fails to verify that raw SQL queries compile and that database constraints function correctly. In-memory SQLite fakes are slower but execute actual SQL queries and check relational constraints, prioritizing correctness over minor setup convenience.

### 2. Golden Visual Screen Tests vs. Logical Layout Assertions
* **The Choice:** Golden visual tests.
* **Trade-off Analysis:** Writing logical layout assertions (e.g. checking widget text hierarchies) is simple and does not require managing reference images. However, logical assertions cannot detect visual bugs (such as clipping text or overflowing layout boundaries). Golden tests require managing reference assets but guarantee visual correctness across screens and themes.

### 3. Pinned Dependency Versions vs. Auto-Updates
* **The Choice:** Pinned dependency versions.
* **Trade-off Analysis:** Allowing automatic updates keeps packages current. However, it introduces risks of unverified or breaking changes compromising build stability. Pinning package versions requires manual updates but guarantees predictable builds, prioritizing reliability.

---

## 46. Best Practices

To optimize BankYar's testing architecture for both human developers and AI code-generation agents:

* **Strict File Naming Conventions:** Keep test files organized and matching their source files:
  - Unit tests: `test/*_test.dart`
  - Widget tests: `test/*_widget_test.dart`
  - Integration tests: `test/*_integration_test.dart`
* **Maintain 100% Parsing Accuracy:** Ensure that parser test suites cover all registered bank SMS templates, verifying metadata extraction is correct under various text layouts.
* **Enforce Clean Domain Boundaries:** Use cases must be verified using Pure Dart testing suites. Keep the domain layer completely free of framework imports to ensure tests are fast, modular, and portable.

---
**End of Testing & Quality Assurance Strategy Document**
