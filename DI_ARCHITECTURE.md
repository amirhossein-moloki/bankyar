# BankYar Dependency Injection & Dependency Management Architecture Specification

**Project Name:** BankYar
**Classification:** Enterprise Architecture Specification (Dependency Injection & Lifecycle Management)
**Document Version:** 1.0.0
**Authors:** Principal Software Architect, Dependency Injection Expert, Clean Architecture Specialist, and Senior Flutter Engineer
**Status:** Approved / Production-Ready Baseline

---

## Executive Summary

BankYar is an intelligent, offline-first personal finance application with a strict zero-network constraint. It intercepts cellular SMS, extracts structured financial metadata, maintains an encrypted local ledger, and computes rich on-device statistics.

To ensure extreme modularity, testability, safety, and compatibility with future package extractions (e.g., separating the parser into an independent Dart package), BankYar implements a unified, compile-time safe **Dependency Injection (DI) and Dependency Management Architecture**.

Leveraging **Riverpod** as its central Provider Container and Dependency Injection framework, this architecture enforces the **Dependency Inversion Principle (DIP)** and avoids the dynamic Service Locator anti-pattern (such as untyped `GetIt` usage). It establishes explicit object lifecycles, clear ownership matrices, strict visibility boundaries, and a highly isolated testing strategy using dynamic dependency overrides.

---

## Table of Contents
1. [Dependency Philosophy](#1-dependency-philosophy)
2. [Dependency Ownership](#2-dependency-ownership)
3. [Dependency Graph](#3-dependency-graph)
4. [Object Lifetime Strategy](#4-object-lifetime-strategy)
5. [Singleton Strategy](#5-singleton-strategy)
6. [Scoped Objects](#6-scoped-objects)
7. [Factory Objects](#7-factory-objects)
8. [Lazy Initialization](#8-lazy-initialization)
9. [Dependency Registration](#9-dependency-registration)
10. [Dependency Resolution](#10-dependency-resolution)
11. [Dependency Visibility Rules](#11-dependency-visibility-rules)
12. [Cross-Feature Dependency Rules](#12-cross-feature-dependency-rules)
13. [Shared Services](#13-shared-services)
14. [Infrastructure Dependencies](#14-infrastructure-dependencies)
15. [Repository Injection](#15-repository-injection)
16. [Use Case Injection](#16-use-case-injection)
17. [Service Injection](#17-service-injection)
18. [Database Injection](#18-database-injection)
19. [Security Injection](#19-security-injection)
20. [Configuration Injection](#20-configuration-injection)
21. [Logging Injection](#21-logging-injection)
22. [Notification Injection](#22-notification-injection)
23. [Parser Injection](#23-parser-injection)
24. [Backup Injection](#24-backup-injection)
25. [Future Sync Injection](#25-future-sync-injection)
26. [Testing Strategy](#26-testing-strategy)
27. [Mock Injection Strategy](#27-mock-injection-strategy)
28. [Fake Implementation Strategy](#28-fake-implementation-strategy)
29. [Dependency Validation](#29-dependency-validation)
30. [Future Evolution Strategy](#30-future-evolution-strategy)
31. [Extensive Component Analysis](#31-extensive-component-analysis)
32. [Dependency Rules Matrix](#32-dependency-rules-matrix)
33. [Architectural Decision Records (ADR)](#33-architectural-decision-records-adr)
34. [Architectural Trade-off Analysis](#34-architectural-trade-off-analysis)
35. [Dependency Best Practices](#35-dependency-best-practices)

---

## 1. Dependency Philosophy

BankYar's dependency management is governed by four core architectural rules:

* **Explicit Over Implicit:** All class dependencies must be declared explicitly in their constructors using typed, final abstract interfaces. Dependencies must never be fetched implicitly inside method bodies or private initialization routines.
* **Dependency Inversion Principle (DIP):** High-level domain logic (Use Cases) and presentation view models must never depend on low-level details (concrete databases, cryptography, platforms). Instead, they must depend on abstract interface definitions. Implementation adapters reside on the outer data layer and are injected dynamically.
* **No Service Locator Anti-Pattern:** Global service locators (e.g., `GetIt.instance<T>()`) are prohibited. They obscure class dependencies, introduce runtime crash risks due to missing registrations, and make unit testing difficult. All dependency resolution is governed by Riverpod's compile-time checked Provider Container.
* **Zero Leakage of Frameworks:** Domain Use Cases are pure Dart components. They must remain completely free of framework references (such as Riverpod imports or platform-specific packages), depending strictly on pure Dart interfaces and constructor injection.

---

## 2. Dependency Ownership

In BankYar, dependency ownership follows a hierarchical, layered model derived from Clean Architecture principles. Each layer has strict permissions regarding what it can own, initialize, and reference:

```
+-----------------------------------------------------------------------------------------+
|                                LAYERED DEPENDENCY OWNERSHIP                             |
+-----------------------------------------------------------------------------------------+
|                                                                                         |
|  [ Presentation Layer ] ──► Owns ViewModels/Notifiers, Theme & Localization Helpers.     |
|         │                                                                               |
|         ▼ Reads / Watches                                                               |
|  [ Domain Layer ]       ──► Owns pure business Use Cases, Entities, & Abstract Interfaces|
|         ▲                                                                               |
|         │ Implements / Injects                                                          |
|  [ Data Layer ]         ──► Owns concrete Repositories, SQLCipher DAOs, Local Sources.  |
|         ▲                                                                               |
|         │ Adapts / Wraps                                                                |
|  [ Infrastructure ]     ──► Owns low-level Hardware storage, Keystore, OS API bindings. |
|                                                                                         |
+-----------------------------------------------------------------------------------------+
```

### Layer Ownership Boundaries:
1. **The Infrastructure Layer** owns raw operating system bindings and hardware APIs (e.g., Biometric sensors, SQLite databases, Android Broadcast Receivers). It has zero knowledge of domain business models.
2. **The Data Layer** owns implementations of domain repositories. It depends on database executors and platform services to translate raw DTOs into pure Domain Entities.
3. **The Domain Layer** is the sovereign owner of the application's business rules. It owns pure entities, value objects, and abstract repository contracts. It contains exactly zero external dependencies.
4. **The Presentation Layer** owns the visual layout and declarative view models. ViewModels/Notifiers are owned by their respective features and obtain data strictly by executing domain Use Cases.

---

## 3. Dependency Graph

The complete, unified compile-time checked dependency graph of BankYar establishes how components are wired from low-level systems up to user-facing screens:

```
                                  [ Hardware Biometric Sensor ]    [ OS Android Telephony ]
                                                │                              │
                                                ▼                              ▼
  [ Platform KeyStore / Enclave ]     [ localAuthenticationService ]  [ AndroidSmsReceiver ]
                │                               │                              │
                ▼                               ▼                              ▼
     [ secureStorageProvider ]       [ secureAuthNotifier ]         [ smsCaptureRepository ]
                │                               │                              │
                ├───────────────────────────────┤                              ▼
                │ (Provides Decryption Key)     │                      [ smsCaptureUseCase ]
                ▼                               ▼                              │
    [ databaseConnectionPool ]       [ App Lock Screen UI ]                    │
                │                                                              │
  ┌─────────────┼─────────────┐                                                │
  ▼             ▼             ▼                                                ▼
[sms_table] [tx_table] [logs_table]                                   [ smsParserEngine ]
                │                                                              │
                ▼                                                              │
    [ transactionRepository ] ◄────────────────────────────────────────────────┘
                │                (Auto-routes parsed transactions)
                ├─────────────────────────────────────────────┐
                ▼                                             ▼
     [ getTransactionsUseCase ]                 [ exportEncryptedBackupUseCase ]
                │                                             │
                ▼                                             ▼
     [ ledgerStateNotifier ]                      [ backupStateNotifier ]
                │                                             │
                ▼                                             ▼
       [ Ledger Dashboard UI ]                       [ Backup Settings UI ]
```

---

## 4. Object Lifetime Strategy

Object lifecycles are explicitly managed to protect sensitive data in memory and optimize device CPU and RAM utilization. The system categorizes dependency lifetimes using two core dimensions: **Scope** and **Loading Mode**.

### Summary Matrix of Lifetimes & Loading Modes

| Category | Lifecycle Scope | Loading Mode | Target Components | Verification & Disposal Action |
| :--- | :--- | :--- | :--- | :--- |
| **Infrastructure Singletons** | Application Lifecycle | Lazy Loaded | `secureStorageProvider`, `diagnosticLogRepository` | Persist for process duration; closed during OS termination. |
| **Session-Scoped Services** | Session Lifecycle | Lazy Loaded | `databaseConnectionPool`, `transactionRepository` | Immediately disposed and memory-zeroized when `SessionState` transitions to `LOCKED`. |
| **Feature-Scoped Presenters**| Feature Lifecycle | Lazy Loaded | `smsParserNotifier`, `backupNotifier` | Kept alive while the specific feature or background task is running. |
| **Transient Presenters** | Screen Lifecycle | Lazy Loaded | `ledgerNotifier`, `searchNotifier` | Automatically disposed (`.autoDispose`) when the user exits the associated screen. |
| **Request-Scoped Factories** | Temporary | Instant | Use Cases (e.g., `getTransactionsUseCase`) | Created on demand and immediately garbage collected after execution. |

---

## 5. Singleton Strategy

To ensure absolute system consistency, certain core components must exist as singletons. However, to keep code modular and highly testable, BankYar enforces strict rules on how singletons are defined and accessed:

* **No Static Class Singletons:** Declaring singletons using private constructors and static instances (e.g., `MyService.instance`) is strictly prohibited. Static singletons cannot be overridden during testing, creating tight coupling and test leakage.
* **Provider-Mediated Singletons:** Singletons are managed exclusively by Riverpod's Provider Container. Classes are written as standard, instantiable classes. Riverpod guarantees that only one instance is created and shared across the application.
* **Controlled Thread Isolation:** Singletons that access system hardware (such as database connection pools) utilize synchronized lock queues to process requests sequentially, preventing data race conditions.

---

## 6. Scoped Objects

Scoped objects exist only within a specific context or lifetime, automatically cleaning up when that context ends:

* **Feature-Scoped Objects:** Dependencies that support an active feature (e.g., `BackupRepository` or `SmsParserEngine`) are initialized on demand when the feature starts and are disposed when the feature's tasks complete.
* **Screen-Scoped Objects:** ViewModels/Notifiers that manage screen-level UI states are annotated with Riverpod's `.autoDispose` modifier. The moment the user exits the screen and its route is popped from the navigator, the notifier and all its local visual states are cleared from memory.
* **Session-Scoped Objects:** Secure resources—most notably the active decrypted SQLCipher database connection—are bound to the active user session. When the session locks (due to manual user action or a 5-minute background timeout), the database connection is closed, and its decryption key is explicitly zeroized in RAM.

---

## 7. Factory Objects

Factory objects are used when the application needs to generate new, independent instances of a dependency dynamically:

* **Use Case Factories:** Use Cases are stateless business components. They are configured as factory dependencies. Each time a Use Case provider is requested, a new, lightweight instance is created, executed, and immediately garbage collected.
* **Value Object Factories:** Creating domain value objects (e.g., mapping a monetary decimal and currency code into a `MonetaryAmount` instance) is handled by pure Dart factories, ensuring structural integrity and immutability before persistence.

---

## 8. Lazy Initialization

To maintain lightning-fast application boot times (sub-200ms cold starts), BankYar implements a lazy-loading initialization strategy:

* **Default Lazy Loading:** Every dependency managed by Riverpod is lazy-loaded by default. No services are instantiated during the main application execution path unless they are actively requested by the current screen.
* **Exemptions (Eager Loading):** Only critical startup components are eagerly loaded during the bootstrap sequence:
  1. `AppSettingsProvider`: Reads visual theme and language preferences from local file storage before rendering the first frame.
  2. `SecurityConfigRepository`: Verifies if biometrics or a security PIN is registered on-device to decide whether to direct the user to onboarding or the lock screen.

---

## 9. Dependency Registration

Dependency registration is strictly organized inside a dedicated configuration tier. Registrations are written as declarative providers, ensuring a clear, structured registry:

```dart
// Conceptual Registry Hierarchy (Strict Architectural Separation)

// 1. Infrastructure Providers
final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorageAdapter());
final databaseConnectionProvider = Provider<DatabasePool>((ref) => SqlCipherConnectionPool(ref.watch(secureStorageProvider)));

// 2. Data Layer Repository Providers
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dbPool = ref.watch(databaseConnectionProvider);
  return TransactionRepositoryImpl(dbPool);
});

// 3. Domain Use Case Providers (Factory Registration)
final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCase(repository);
});

// 4. Presentation ViewModel Notifier Providers (Auto-disposed)
final ledgerNotifierProvider = AutoDisposeAsyncNotifierProvider<LedgerNotifier, LedgerState>(() {
  return LedgerNotifier();
});
```

---

## 10. Dependency Resolution

Dependency resolution occurs automatically at compile-time, eliminating manual lookup code and service locator lookups:

* **Constructor-Based Dependency Injection:** Concrete classes declare all their dependencies inside their constructors. When a provider is resolved, Riverpod automatically maps and injects the required parameters.
* **No Context Leaks:** Presentation widgets resolve their state by watching providers using Riverpod's secure UI widget container (`ConsumerWidget`), ensuring that context lookups are confined strictly to the rendering layer.

---

## 11. Dependency Visibility Rules

To prevent code spaghetti and maintain clean architectural boundaries, BankYar enforces strict visibility rules:

```
[ Presentation Layer Views / Screens ]
                 │
                 ▼ Watches
[ Presentation Notifiers / ViewModels ]
                 │
                 ▼ Invokes
        [ Domain Use Cases ]
                 │
                 ▼ Queries
      [ Abstract Interfaces ]
                 ▲
                 │ Implemented By
      [ Concrete Repositories ]
                 │
                 ▼ Coordinates
   [ Infrastructure Database / OS ]
```

* **No Direct Implementation Access:** The presentation layer is strictly prohibited from importing or referencing concrete implementations (e.g., `TransactionRepositoryImpl`). It can reference only abstract interfaces (`TransactionRepository`).
* **Unidirectional Downward Reference:** Dependencies can reference only components in the same layer or layers below them. A component in the domain layer is completely pure and cannot import components from the data or presentation layers.

---

## 12. Cross-Feature Dependency Rules

Features must operate as isolated, self-contained functional modules. To maintain clean boundaries, BankYar implements strict cross-feature communication rules:

* **Zero Direct Presentation Cross-Imports:** No files inside `features/analytics/presentation` are allowed to import components or views from `features/transactions/presentation`.
* **Decoupled Data Queries:** If the analytics feature requires transaction data to compute spend velocities, it must obtain that data by referencing the abstract `TransactionRepository` interface, injected dynamically via Riverpod.
* **Asynchronous Communication (Domain Events):** When the SMS parsing engine successfully processes a transaction in the background, it dispatches an immutable domain event (`TransactionParsed`). The ledger feature observes this event reactively, updating the database and UI without direct compile-time coupling.

---

## 13. Shared Services

Shared services provide generic, reusable cross-cutting utilities with zero dependencies on specific business features. They are located inside `lib/core/` and are globally available:

* **`SystemPermissionService`:** Abstracts OS-specific authorization requests (such as requesting background SMS interception permissions).
* **`NotificationDisplayService`:** Manages native OS notification tray alerts.
* **`StaticLanguageService`:** Translates application text strings completely offline.

---

## 14. Infrastructure Dependencies

Infrastructure dependencies wrap low-level operating system APIs and storage systems. To prevent vendor lock-in and support future testing, all infrastructure adapters implement abstract contracts defined in the core layer:

* **SQLCipher Connection Pools:** Manage encrypted SQLite database states.
* **Biometric Hardware Sensors:** Interact with native fingerprint and facial scanners.
* **Platform Secure Storage:** Interacts with the secure Android Keystore and iOS Secure Enclave.

---

## 15. Repository Injection

Repositories map database models to pure domain entities. They are injected as singletons bound to the active user session:

```
                  [ databaseConnectionProvider ]
                                │
                                ▼ Injected Into
                    [ TransactionRepository ]
                                │
                 ┌──────────────┴──────────────┐
                 ▼                             ▼
   [ GetTransactionsUseCase ]    [ DeleteTransactionUseCase ]
```

* **Session Lifetime:** When the user session locks, the repository's active database handle is closed, preventing any subsequent queries until the database is successfully unlocked.

---

## 16. Use Case Injection

Use Cases contain pure, stateless business rules. They are injected as lightweight factories:

* **Pure Dart Implementation:** Use Case constructors accept abstract repository contracts. They are registered as factory dependencies, ensuring they are created on demand, executed, and immediately garbage collected, keeping the application's RAM footprint minimal.

---

## 17. Service Injection

Domain and system services coordinate operations across multiple aggregates:

* **`SMSRoutingService`:** Coordinates the SMS parsing pipeline. It is injected with the SMS repository to deduplicate messages, the rules repository to find matching templates, and the transaction repository to persist parsed records.

---

## 18. Database Injection

The SQLCipher database requires a valid decryption key before it can process reads or writes. To maintain extreme security, the decryption key is never stored on disk:

* **Key Delegation:** Upon successful user authentication, the secure authorization service retrieves the master key from the hardware-backed keystore and injects it directly into the database connection pool in memory.
* **Zeroization:** When the session locks or the application process is terminated, the connection pool is closed, and the memory address holding the key bytes is explicitly overwritten with zeros, leaving no encryption keys in volatile RAM.

---

## 19. Security Injection

The security module controls application access and access permissions:

* **`LocalAuthenticationService`:** Interfaces with native biometric hardware and PIN validators. It is injected into the secure auth state notifier to control the lock screen and manage lockout grace periods.

---

## 20. Configuration Injection

To manage compile-time environments safely, configuration variables are injected as immutable dependencies:

* **`AppConfig`:** Exposes compile-time flags (such as the secure database filename and diagnostic log caps) as read-only configurations, preventing environment-leak bugs.

---

## 21. Logging Injection

To support offline troubleshooting without compromising user privacy, logging dependencies implement strict PII scrubbing:

* **`AnonymizationService`:** Scrubs personal identifiable information (such as amounts or card numbers) from logs.
* **`DiagnosticLogRepository`:** Writes scrubbed log messages to the encrypted database, enforcing a strict 10,000-record FIFO size limit to prevent storage bloat.

---

## 22. Notification Injection

The notification system provides native tray alerts:

* **`NotificationDisplayService`:** Registered as a system singleton. It is injected into the SMS capture service to trigger visual tray alerts when background parsing completes successfully.

---

## 23. Parser Injection

The SMS parsing engine is designed to operate completely offline:

* **`ParserEngine`:** Compiled rules templates are cached in memory for high-speed regex matching. It is injected into the SMS routing service to process incoming carrier text payloads.

---

## 24. Backup Injection

The backup module manages password-encrypted exports:

* **`BackupRepository`:** Uses PBKDF2 with 100,000 iterations to derive an encryption key from a user-supplied password, encrypting serialized databases using AES-256-GCM before writing to the local sandboxed directory.

---

## 25. Future Sync Injection

The future sync architecture is designed to support seamless cloud synchronization:

* **`SyncRepository`:** Registered as an abstract contract. In Version 1, it exposes a static local-only adapter. In future updates, this interface can be replaced with a secure P2P or encrypted cloud adapter without requiring changes to core ledger or transaction services.

---

## 26. Testing Strategy

BankYar's DI architecture is built to support high-speed, automated testing. Because Riverpod manages the entire dependency graph, test suites can override any provider with mocked or fake implementations dynamically:

```
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                  DEPENDENCY OVERRIDE TEST SYSTEM                        |
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                                                                         |
|       [ Standard Production Registry ]                                                  |
|       - transactionRepositoryProvider ──► TransactionRepositoryImpl (SQLCipher Disk)     |
|                                                                                         |
|                      │ Overridden in Test Container                                     |
|                      ▼                                                                  |
|       [ Isolated Test Registry Container ]                                              |
|       - transactionRepositoryProvider ──► MockTransactionRepository (RAM Mockito)       |
|                                                                                         |
+─────────────────────────────────────────────────────────────────────────────────────────+
```

* **Complete Test Isolation:** By overriding database and hardware providers, unit and integration tests run entirely in-memory with zero disk or OS interactions, preventing test interference and ensuring execution speeds under 50ms per test.

---

## 27. Mock Injection Strategy

For unit tests, dependencies are replaced with highly configurable mock objects (using libraries like Mockito or Mocktail):

* **Behavior Verification:** Mocks are used to verify specific interaction behaviors, such as asserting that the `DeduplicationService` correctly queries the repository before parsing begins, and that duplicate messages are rejected.

---

## 28. Fake Implementation Strategy

For integration and UI widget tests, complex hardware systems are replaced with fast, lightweight in-memory fakes:

* **Fakes Over Mocks:** Systems like secure storage or the database are replaced with in-memory fakes (e.g., an in-memory SQLite database), allowing tests to verify complete transactional data flows under realistic conditions.

---

## 29. Dependency Validation

To prevent runtime errors, the dependency graph is validated programmatically:

* **Compile-Time Validation:** By avoiding dynamic string lookups or untyped service locators, Riverpod ensures that missing dependencies are caught at compile-time, guaranteeing that if the application builds, its dependency graph is fully resolved and safe.

---

## 30. Future Evolution Strategy

The dependency architecture is designed to scale with BankYar as it evolves:

* **Modular Package Extraction:** If the parsing engine is extracted into a reusable standalone package, the abstract `ParserEngine` contract remains unchanged. The new package is simply imported, and its adapter is registered in the provider registry, requiring zero changes to transactions or analytics code.
* **Zero Refactoring for Cloud Sync:** Adding cloud synchronization requires only replacing the V1 static local-only repository with a new encrypted sync adapter in the provider container, keeping the rest of the application unchanged.

---

## 31. Extensive Component Analysis

This section analyzes the twelve critical, architecture-level dependencies of BankYar across all 10 required architectural dimensions:

---

### 1. `databaseConnectionProvider`
* **Purpose:** Manages the thread-isolated SQLCipher database connection pool.
* **Owner:** Core Database Platform Team (`core_database`).
* **Lifetime:** Session-Scoped (recreated when the user logs in and unlocks the database).
* **Dependencies:** `secureStorageProvider` (to retrieve the encrypted database master key).
* **Consumers:** All data layer repositories (`TransactionRepositoryImpl`, `ParserTemplateRepositoryImpl`, etc.).
* **Creation Time:** Instantiated on demand when `SessionState` transitions to `ACTIVE`.
* **Disposal Time:** Disposed immediately when `SessionState` transitions to `LOCKED`.
* **Testing Strategy:** Overridden in test suites with an in-memory SQLite database connection.
* **Replacement Strategy:** Easily replaceable with an alternative relational database (such as ISAR or encrypted ObjectBox) by implementing the abstract connection interface.
* **Future Extensions:** Support for automatic background database vacuuming and localized integrity verification checks.

---

### 2. `secureStorageProvider`
* **Purpose:** Abstracts secure hardware key-value storage.
* **Owner:** Core Security & Platform Team (`core_security`).
* **Lifetime:** Application Singleton.
* **Dependencies:** None.
* **Consumers:** `databaseConnectionProvider` (to access master database credentials).
* **Creation Time:** Lazy-loaded upon first request during application launch.
* **Disposal Time:** Persists throughout the active application process lifecycle.
* **Testing Strategy:** Overridden in tests using an in-memory string-map fake.
* **Replacement Strategy:** Replaceable with platform-specific secure preference adapters.
* **Future Extensions:** Support for biometric-bound hardware keys on modern Android devices.

---

### 3. `transactionRepositoryProvider`
* **Purpose:** Maps database operations to pure transaction domain entities.
* **Owner:** Ledger Domain Team (`features/transactions`).
* **Lifetime:** Session-Scoped.
* **Dependencies:** `databaseConnectionProvider`.
* **Consumers:** Use Cases (e.g., `GetTransactionsUseCase`, `DeleteTransactionUseCase`).
* **Creation Time:** Lazy-loaded when a ledger transaction Use Case is first invoked.
* **Disposal Time:** Disposed when the active user session ends.
* **Testing Strategy:** Overridden in unit tests using a mock repository.
* **Replacement Strategy:** Replaceable with an alternative storage engine without affecting Use Cases.
* **Future Extensions:** Support for managing multiple independent, user-defined financial sub-ledgers.

---

### 4. `securityConfigRepositoryProvider`
* **Purpose:** Persists local app lock configurations and biometric preferences.
* **Owner:** Security & Platform Team (`features/secure_auth`).
* **Lifetime:** Application Singleton.
* **Dependencies:** `secureStorageProvider`.
* **Consumers:** Use Cases (e.g., `VerifyUserPinUseCase`, `GetSecurityConfigUseCase`).
* **Creation Time:** Eagerly loaded during the application bootstrap sequence.
* **Disposal Time:** Persists throughout the active application process.
* **Testing Strategy:** Overridden using in-memory mock repository instances.
* **Replacement Strategy:** Can be replaced with alternative encryption or biometric modules.
* **Future Extensions:** Implement a secure duress PIN that wipes the database when entered.

---

### 5. `smsCaptureRepositoryProvider`
* **Purpose:** Intercepts raw incoming cellular SMS payloads.
* **Owner:** Parsing & Engine Team (`features/sms_detection`).
* **Lifetime:** Feature-Scoped (active while the background SMS worker is running).
* **Dependencies:** Native Telephony API bindings.
* **Consumers:** `CaptureIncomingSmsUseCase`.
* **Creation Time:** Instantiated on boot when permissions are granted.
* **Disposal Time:** Closed if SMS permissions are revoked or the background task ends.
* **Testing Strategy:** Overridden with a mock stream controller in tests.
* **Replacement Strategy:** Replaceable with alternative push notification scraping modules.
* **Future Extensions:** Scraping banking app notification alerts directly from the system tray.

---

### 6. `parserEngineProvider`
* **Purpose:** Parses raw unstructured text using regular expressions.
* **Owner:** Parsing & Engine Team (`features/sms_detection`).
* **Lifetime:** Feature-Scoped.
* **Dependencies:** `ParserTemplateRepository`.
* **Consumers:** `ParseSmsPayloadUseCase`.
* **Creation Time:** Lazy-loaded when an SMS is intercepted.
* **Disposal Time:** Automatically disposed when parsing tasks complete.
* **Testing Strategy:** Verified by testing extraction outputs against static bank SMS texts.
* **Replacement Strategy:** Can be replaced with an on-device machine learning parser.
* **Future Extensions:** Scanning and parsing transaction templates using local QR codes.

---

### 7. `backupRepositoryProvider`
* **Purpose:** Manages password-encrypted database backup exports and restores.
* **Owner:** Security & Portability Team (`features/backup_restore`).
* **Lifetime:** Feature-Scoped (short-lived).
* **Dependencies:** `databaseConnectionProvider`.
* **Consumers:** Use Cases (e.g., `ExportEncryptedBackupUseCase`).
* **Creation Time:** Instantiated on demand when a backup or restore is initiated.
* **Disposal Time:** Disposed immediately after the backup file is written or restored.
* **Testing Strategy:** Overridden in integration tests using in-memory file write fakes.
* **Replacement Strategy:** Can be replaced with automated encrypted export services.
* **Future Extensions:** Secure P2P database syncing over local Wi-Fi.

---

### 8. `localAuthenticationServiceProvider`
* **Purpose:** Interfaces with device biometric sensors and manages lockouts.
* **Owner:** Security & Platform Team (`features/secure_auth`).
* **Lifetime:** Application Singleton.
* **Dependencies:** Native system biometric API bindings.
* **Consumers:** `VerifyUserPinUseCase`, `LocalAuthenticationNotifier`.
* **Creation Time:** Lazy-loaded upon first authentication prompt.
* **Disposal Time:** Persists throughout the active application process.
* **Testing Strategy:** Overridden with a fake biometric adapter that simulates success/failure states.
* **Replacement Strategy:** Replaceable with custom cryptographic key validation services.
* **Future Extensions:** Support for biometric-bound transaction confirmations.

---

### 9. `getTransactionsUseCaseProvider`
* **Purpose:** Fetches the chronological stream of transactions.
* **Owner:** Ledger Domain Team (`features/transactions`).
* **Lifetime:** Request-Scoped (Stateless Factory).
* **Dependencies:** `TransactionRepository`.
* **Consumers:** `ledgerNotifierProvider`.
* **Creation Time:** Created on demand when the ledger dashboard is opened.
* **Disposal Time:** Disposed immediately after execution completes.
* **Testing Strategy:** Tested by verifying that the Use Case applies filtering and sorting correctly.
* **Replacement Strategy:** Replaceable with custom querying services.
* **Future Extensions:** Support for smart budget queries and category forecasting.

---

### 10. `captureIncomingSmsUseCaseProvider`
* **Purpose:** Coordinates incoming SMS deduplication and ingestion.
* **Owner:** Parsing & Engine Team (`features/sms_detection`).
* **Lifetime:** Request-Scoped (Stateless Factory).
* **Dependencies:** `SmsCaptureRepository`, `DeduplicationService`.
* **Consumers:** `SmsCaptureBackgroundWorker`.
* **Creation Time:** Created on demand when a new SMS is received.
* **Disposal Time:** Disposed immediately after the SMS is processed or ignored.
* **Testing Strategy:** Unit-tested by verifying that duplicate messages are rejected.
* **Replacement Strategy:** Replaceable with alternative notification capture workflows.
* **Future Extensions:** Processing transaction payload metadata from messaging apps.

---

### 11. `exportEncryptedBackupUseCaseProvider`
* **Purpose:** Serializes and encrypts the database using a user-supplied password.
* **Owner:** Security & Portability Team (`features/backup_restore`).
* **Lifetime:** Request-Scoped (Stateless Factory).
* **Dependencies:** `BackupRepository`.
* **Consumers:** `backupNotifierProvider`.
* **Creation Time:** Created on demand when a backup export is triggered.
* **Disposal Time:** Disposed immediately after the backup file is written.
* **Testing Strategy:** Unit-tested by verifying that exported files cannot be decrypted with an incorrect password.
* **Replacement Strategy:** Replaceable with custom encryption or export modules.
* **Future Extensions:** Support for multi-device sync formats.

---

### 12. `diagnosticLogRepositoryProvider`
* **Purpose:** Captures PII-scrubbed system exception logs.
* **Owner:** Database Platform Team (`core_logging`).
* **Lifetime:** Application Singleton.
* **Dependencies:** `databaseConnectionProvider`.
* **Consumers:** All application services and repositories.
* **Creation Time:** Eagerly loaded during application startup.
* **Disposal Time:** Persists throughout the active application process.
* **Testing Strategy:** Overridden in unit tests using a mock repository.
* **Replacement Strategy:** Replaceable with alternative logging engines.
* **Future Extensions:** Support for exporting anonymized crash reports.

---

## 32. Dependency Rules Matrix

This matrix maps compile-time package imports and DI relationships between vertical features and core modules. A value of **"Allowed"** indicates that dependency injection and imports are permitted; **"Forbidden"** indicates compile-time imports are strictly blocked.

| Target Module $\rightarrow$ <br> Source Module $\downarrow$ | `secure_auth` | `sms_detection` | `transactions` | `analytics` | `backup_restore` | `core` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **`secure_auth`** | — | Forbidden | Forbidden | Forbidden | Forbidden | **Allowed** |
| **`sms_detection`** | Forbidden | — | **Event-Only** | Forbidden | Forbidden | **Allowed** |
| **`transactions`** | Forbidden | Forbidden | — | Forbidden | Forbidden | **Allowed** |
| **`analytics`** | Forbidden | Forbidden | **Allowed (Domain)** | — | Forbidden | **Allowed** |
| **`backup_restore`**| Forbidden | Forbidden | **Allowed (Domain)** | Forbidden | — | **Allowed** |
| **`core`** | Forbidden | Forbidden | Forbidden | Forbidden | Forbidden | — |

### Verification Rules:
1. **The Inward Dependency Flow:** Inside any feature, dependencies must flow strictly inward: Presentation $\longrightarrow$ Domain $\longleftarrow$ Data.
2. **Feature-to-Feature Isolation:** Features are compiled as isolated modules. Features cannot import concrete implementation files from other features.

---

## 33. Architectural Decision Records (ADR)

### ADR-001: Riverpod as Compile-Time Safe DI and State Management Framework
* **Status:** Approved
* **Context:** The application needs a lightweight dependency injection framework that is safe, testable, and compatible with future iOS migrations.
* **Decision:** Implement Riverpod as the unified DI and State Management framework.
* **Rationale:** It combines state management and dependency injection into a single, compile-time safe framework. It detects cyclic or missing dependencies at build time, eliminating the runtime crash risks of service locators (like `GetIt`).

### ADR-002: Session-Scoped Database Injection
* **Status:** Approved
* **Context:** Financial data is highly sensitive, and the decryption key must not remain in RAM when the application locks.
* **Decision:** Bind the database connection pool lifetime to the active user session, closing and zeroizing the key when the session locks.
* **Rationale:** Closing active database handles and zeroizing key bytes when the app is inactive ensures that sensitive data cannot be read from memory if the device is lost.

### ADR-003: Constructor-Only Injection for Domain Layer Use Cases
* **Status:** Approved
* **Context:** Domain Use Cases contain pure business rules and must remain independent of external frameworks.
* **Decision:** Use Cases declare their dependencies strictly using typed, final constructors, completely free of Riverpod imports.
* **Rationale:** Keeping the domain layer free of framework imports ensures that Use Cases are highly testable, modular, and portable for future package extractions.

---

## 34. Architectural Trade-off Analysis

Every design decision involves balancing multiple priorities. Below is the justification for the trade-offs made in BankYar's DI architecture:

### 1. Riverpod DI Container vs. GetIt Service Locator
* **The Choice:** Unified Riverpod Provider Container.
* **Trade-off Analysis:** Service locators (like `GetIt`) can be faster to set up in small projects. However, they lack compile-time safety and expose the application to runtime crashes if a registration is missing. Riverpod's compile-time checked graph ensures dependencies are resolved at build time, prioritizing stability over minor setup convenience.

### 2. Constructor-Only Injection vs. Property/Method Injection
* **The Choice:** Constructor-Only Injection.
* **Trade-off Analysis:** Property/Method injection can simplify object creation when classes have many optional dependencies. However, it allows objects to be instantiated in an incomplete or invalid state. Constructor-only injection guarantees that objects are fully configured and valid upon instantiation, prioritizing reliability over minor setup speed.

### 3. Session-Scoped Database Connection vs. Permanent Database Singleton
* **The Choice:** Session-Scoped Database connection.
* **Trade-off Analysis:** Keeping a permanent database connection open is simpler and reduces re-authentication overhead. However, it leaves sensitive financial data and decryption keys exposed in volatile memory (RAM) when the app is inactive. A session-scoped lifecycle prioritizing data security over minor performance gains is the correct choice for personal finance.

---

## 35. Dependency Best Practices

To optimize BankYar's architecture for both human developers and AI code-generation agents:

* **Declare Explicit Type Signatures:** Always declare explicit return types on provider definitions and class methods, helping AI models parse API contracts and generate valid code.
* **Utilize Abstract Interface Contracts:** All data repositories and system services must define abstract contracts in the core layer, allowing implementations to be swapped or mocked easily during testing.
* **Enforce Strict File Naming Conventions:** Keep directory structure organized and logical, ensuring file names match their specific Clean Architecture roles (e.g., `*_entity.dart`, `*_usecase.dart`, `*_notifier.dart`).

---
**End of Dependency Injection and Dependency Management Architecture Specification**
