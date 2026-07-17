# BankYar System Architecture Document (SAD)

**Project Name:** BankYar
**Product Type:** Offline-First Android Application (with future iOS migration readiness)
**Framework Constraints:** Flutter (latest stable), Dart, Riverpod, SQLCipher (encrypted SQLite)
**Role:** Principal Software Architect, Flutter Enterprise Architect, and Mobile Security Specialist
**Document Version:** 1.0.0
**Status:** Approved / Architecture Baseline

---

## 1. Architectural Vision

BankYar is designed as an enterprise-grade, offline-first mobile personal finance management system. It sits on the device as a secure, sandboxed utility that automatically captures banking SMS messages, extracts complex financial metadata, organizes a transaction ledger, and renders interactive statistical insights.

The architecture is governed by four core design pillars:
1. **Absolute Offline Guarantee (Privacy by Design):** The application explicitly excludes the `android.permission.INTERNET` permission at the Manifest/OS level. Telemetry, cloud synchronization, and remote crash tracking are strictly prohibited.
2. **Hardened Local Security (Security by Design):** All persistent data resides in a locally encrypted database (SQLCipher, AES-256) secured by keys generated and retained in hardware-backed storage (Android Keystore / iOS Secure Enclave).
3. **Flutter-Native Synergy (Portability & Maintenance):** Although Phase 1 is focused on Android First, the system utilizes Flutter to share 95% of its code (Domain layer, Data models, State Management, UI widgets, Utilities) across platforms. Low-level operating system hooks (like Android SMS listening and hardware biometric authenticators) are abstracted behind platform interfaces and accessed via Flutter MethodChannels.
4. **AI-Assisted Maintainability (AI-First Development):** To support rapid, error-free development by human-AI collaborative teams, the architecture enforces a strict **Feature-First Clean Architecture** with highly isolated modules, unidirectional data flows, and explicit dependency injection. This structure ensures that both automated agents and human developers can reason about, refactor, and test specific features in absolute isolation without side effects.

---

## 2. High-Level Architecture

The system is organized as a decoupled, event-driven topology. The primary trigger of data in the system is a physical OS-level event (Android SMS broadcast or manual clipboard/user input).

```
+--------------------------------------------------------------------------------------------------------+
|                                              OPERATING SYSTEM                                          |
|                                                                                                        |
|  +-----------------------------+      +------------------------------+      +-----------------------+  |
|  | Android SMS Broadcast       |      | Device Cryptographic Hardware|      | Secure Biometrics/PIN |  |
|  | (Telephony SMS_RECEIVED)    |      | (KeyStore / TEE / StrongBox) |      | (OS Authenticator)    |  |
|  +--------------+--------------+      +--------------+---------------+      +-----------+-----------+  |
+-----------------|------------------------------------|----------------------------------|--------------+
                  |                                    |                                  |
                  | Trigger Intent                     | Fetch / Unlock DB Key            | Auth Verify
                  v                                    v                                  v
+-----------------|------------------------------------|----------------------------------|--------------+
| FLUTTER ENGINE  |                                    |                                  |              |
|                 v                                    v                                  v              |
|  +--------------+--------------+      +--------------+---------------+      +-----------+-----------+  |
|  | Native Android Host         |      | Flutter Secure Storage       |      | Local Authentication  |  |
|  | (MethodChannel/EventChannel)|      | Platform Implementation      |      | Platform Plugin       |  |
|  +--------------+--------------+      +--------------+---------------+      +-----------+-----------+  |
|                 |                                    |                                  |              |
|                 | Stream Raw SMS payload             | Master Key (AES-256)             | Lock Status  |
|                 v                                    v                                  v              |
|  +--------------+--------------+      +--------------+---------------+      +-----------+-----------+  |
|  | sms_detection Feature Data  |      | Core Security Layer          |      | secure_auth Feature   |  |
|  | Ingestion & Queue           |      | (Key Lifecycle Manager)      |      | Presentation/Domain   |  |
|  +--------------+--------------+      +--------------+---------------+      +-----------+-----------+  |
|                 |                                    |                                  |              |
|                 | Parse (Deterministic / Heuristics) | Unlock DB Hook                   | Authorize    |
|                 v                                    v                                  v              |
|  +---------------------------------------------------+----------------------------------------------+  |
|  |                                  CORE DATA ACCESS LAYER                                          |  |
|  |                                                                                                  |  |
|  |  +--------------------------------------------------------------------------------------------+  |  |
|  |  | SQLCipher Local Encrypted Database (SQLite + AES-256)                                      |  |  |
|  |  | - Transactions, Tags, Categories, User Notes, Local Diagnostic Logs                        |  |  |
|  |  +--------------------------------------------+-----------------------------------------------+  |  |
|  +-----------------------------------------------|--------------------------------------------------+  |
|                                                  | Emits Streams / Flow Updates                        |
|                                                  v                                                     |
|  +-----------------------------------------------+--------------------------------------------------+  |
|  |                                 CORE STATE MANAGEMENT LAYER                                      |  |
|  |                                                                                                  |  |
|  |  +--------------------------------------------+-----------------------------------------------+  |  |
|  |  | Riverpod Provider Container / Notifiers    | (Reactive Domain Aggregations & Use Cases)    |  |  |
|  |  +--------------------------------------------+-----------------------------------------------+  |  |
|  +-----------------------------------------------|--------------------------------------------------+  |
|                                                  | Unidirectional UI State Updates                     |
|                                                  v                                                     |
|  +-----------------------------------------------+--------------------------------------------------+  |
|  |                                   FLUTTER PRESENTATION LAYER                                     |  |
|  |                                                                                                  |  |
|  |  +--------------------------------------------------------------------------------------------+  |  |
|  |  | Declarative UI Widgets (Ledger, Analytics, Rules Builder, Diagnostics, Access Locks)       |  |  |
|  |  +--------------------------------------------------------------------------------------------+  |  |
|  +--------------------------------------------------------------------------------------------------+  |
+--------------------------------------------------------------------------------------------------------+
```

### Component Breakdown & Rationale:
* **Native Host Gateway:** A light native Kotlin layer on Android that implements a standard background `BroadcastReceiver` listening for `SMS_RECEIVED`. It extracts the raw SMS bytes, packages them, and dispatches them to Dart via an event stream.
* **Core Security Layer:** Orchestrates key extraction and memory persistence. It uses `flutter_secure_storage` as the interface to the OS's Keystore, retrieving a master database key on app launch.
* **SQLCipher Database Wrapper:** Opens a highly optimized encrypted local database. SQLCipher is configured to use standard AES-256 (with PBKDF2 key derivation and random salts) to encrypt every database page.
* **Riverpod State Management:** Riverpod serves as the state preservation and dependency injection infrastructure. Presentation components subscribe to Riverpod providers, which reactively pull data from the domain use cases.

---

## 3. Layered Architecture

BankYar strictly implements **Clean Architecture** combined with **Feature-First Organization**. Within every vertical feature module, code is structured into three highly decoupled logical layers: Presentation, Domain, and Data.

```
       +-------------------------------------------------------+
       |                  PRESENTATION LAYER                   |
       |  - UI Widgets (Pages, Cards, Forms)                   |
       |  - ViewModels / Riverpod StateNotifier Providers      |
       |  - UI State Entities                                  |
       +--------------------------+----------------------------+
                                  |
                                  | Depends on (UDF State)
                                  v
       +-------------------------------------------------------+
       |                     DOMAIN LAYER                      |
       |  - Pure Business Rules (Pure Dart)                    |
       |  - Core Entities (Transaction, Category, Template)    |
       |  - Use Cases (GetTransactions, ProcessSms, Backup)     |
       |  - Abstract Repository Interfaces                     |
       +--------------------------+----------------------------+
                                  ^
                                  | Implements / Satisfies contract
                                  |
       +--------------------------+----------------------------+
       |                      DATA LAYER                       |
       |  - Repository Implementations                         |
       |  - Data Transfer Objects (DTOs / Models)              |
       |  - Local Data Sources (SQLite DAO, SecurePrefs)       |
       |  - External Platform Channel Adapters                 |
       +-------------------------------------------------------+
```

### Layer Boundary & Dependency Crossings
The **Dependency Rule** dictates that dependencies can only point *inward* toward the Domain layer.
* **The Domain Layer** contains no references to any external framework, Flutter package (including Riverpod or Material UI), database driver, or native platform channels. It is pure Dart.
* **The Presentation Layer** communicates with the Domain Layer via Use Cases. When a user acts (e.g., clicks "Add Custom Tag"), the Presentation State Holder (Riverpod Notifier) invokes a specific Use Case (e.g., `AddTagUseCase`).
* **The Data Layer** contains the physical implementations of the abstract interfaces declared in the Domain Layer (Dependency Inversion). For instance, `TransactionRepositoryImpl` (Data) implements the `TransactionRepository` interface (Domain).

---

## 4. Feature Modules

To maximize feature isolation, maintainability, and compatibility with AI-assisted code generation, the application's source code is organized into self-contained feature slices under the `lib/features/` folder. Common shared elements exist in `lib/core/`.

```
lib/
├── core/                                   # Shared core utilities and abstractions
│   ├── security/                           # Master Cryptographic key managers
│   ├── database/                           # Base SQLite connection, migrations, and schema drivers
│   ├── theme/                              # Application design tokens (Color, Typography, Metrics)
│   └── errors/                             # Standard Failures and Exception types
│
└── features/                               # Vertical functional slices
    ├── secure_auth/                        # Feature: App PIN/Biometric Authentication
    │   ├── data/
    │   │   ├── datasources/auth_local_source.dart
    │   │   └── repositories/auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── repository/auth_repository.dart
    │   │   └── usecases/authenticate_user.dart
    │   └── presentation/
    │       ├── state/auth_state_notifier.dart
    │       └── screens/biometric_lock_screen.dart
    │
    ├── sms_detection/                      # Feature: Capturing and parsing raw SMS
    │   ├── data/
    │   │   ├── datasources/platform_sms_receiver.dart
    │   │   ├── datasources/local_parser_rules_source.dart
    │   │   ├── models/sms_payload_dto.dart
    │   │   ├── parser/sms_parser_engine.dart
    │   │   └── repositories/sms_parser_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/parser_template_entity.dart
    │   │   ├── repository/sms_parser_repository.dart
    │   │   └── usecases/process_incoming_sms.dart
    │   └── presentation/                   # In iOS fallback, rules template updates are exposed here
    │       ├── state/rules_notifier.dart
    │       └── screens/template_builder_screen.dart
    │
    ├── transactions/                       # Feature: Ledger, custom tags, and transaction annotations
    │   ├── data/
    │   │   ├── datasources/transaction_sqlite_dao.dart
    │   │   ├── models/transaction_dto.dart
    │   │   └── repositories/transaction_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/transaction_entity.dart
    │   │   ├── repository/transaction_repository.dart
    │   │   └── usecases/
    │   │       ├── get_transactions_stream.dart
    │   │       ├── update_transaction_details.dart
    │   │       └── add_transaction_manually.dart
    │   └── presentation/
    │       ├── state/ledger_notifier.dart
    │       └── screens/
    │           ├── ledger_dashboard_screen.dart
    │           └── transaction_detail_screen.dart
    │
    ├── analytics/                          # Feature: Offline aggregation charts and statistics
    │   ├── domain/
    │   │   ├── entities/cash_flow_report_entity.dart
    │   │   └── usecases/generate_category_breakdown_usecase.dart
    │   └── presentation/
    │       ├── state/analytics_notifier.dart
    │       └── screens/charts_dashboard_screen.dart
    │
    └── backup_restore/                     # Feature: Local encrypted backup & recovery
        ├── data/
        │   └── datasources/file_storage_source.dart
        ├── domain/
        │   └── usecases/
        │       ├── export_encrypted_backup.dart
        │       └── import_encrypted_backup.dart
        └── presentation/
            ├── state/backup_notifier.dart
            └── screens/backup_settings_screen.dart
```

---

## 5. Responsibilities of Each Layer

Below is a detailed matrix of the technical responsibilities, allowable content, and strict boundaries of each architectural layer.

| Layer | Primary Responsibilities | Acceptable Dependencies / Libraries | Forbidden Elements / Practices |
| :--- | :--- | :--- | :--- |
| **Presentation** | Renders UI, listens to user input events, triggers state adjustments, represents UI state machines, format formatting for human presentation. | Material Design, Flutter UI Widgets, Riverpod providers, UI state-notifiers, Animation controllers. | Direct calls to DB drivers, raw file handling, native platform channels, executing cryptographic calculations, parsing raw SMS strings. |
| **Domain** | Contains pure business models, orchestrates business rules through use-cases, defines abstractions for data synchronization, ensures domain rule integrity. | Pure Dart standard library, functional libraries (e.g. `fpdart`), metadata annotations (`meta`). | Any Flutter/Widget reference, Riverpod imports, SQLite databases, file-system directories, network components, platform-specific code. |
| **Data** | Fetches and persists structured models, maps database tables to Domain entities, listens to platform-specific channels (SMS), parses text formats, executes encryption algorithms. | SQLCipher (sqflite wrapper), `flutter_secure_storage`, JSON serializers, native platform interfaces, regular expression drivers, Cryptographic packages. | Triggering UI screens, direct mutations of UI state variables, violating domain contracts, exposing raw database cursor maps outside repositories. |

---

## 6. Dependency Rules

To preserve architectural cleanliness and guarantee that AI and human engineers do not create circular references or layer leaks, the following architectural boundaries are strictly enforced:

### The Golden Rule: Inward-Only Dependency Flow
Code in any outer layer can only access classes or variables declared in layers further inward.
$$\text{Presentation Layer} \longrightarrow \text{Domain Layer} \longleftarrow \text{Data Layer}$$
* **No Outward Leaks:** Domain entities (e.g., `TransactionEntity`) must not reference Data Models (e.g., `TransactionDto`). Data Models must extend or map to Domain Entities using explicit mapper extension methods (e.g., `toEntity()` and `fromEntity()`).
* **No Database in UI:** UI files must never directly reference SQFlite, SQLCipher, or file paths.

### Feature Isolation & Interaction Rules
Feature modules are designed to represent vertical functional slices. To ensure high testability and feature isolation:
* **Feature Autonomy:** A feature (e.g., `analytics`) must never import files from the `data` or `presentation` layers of another feature (e.g., `transactions`).
* **Permissible Feature Intercommunication:**
  1. **Domain-Level Sharing:** Features can share core domain models via a unified central structure if necessary, or pass parameters through domain use-cases.
  2. **Core Composition:** Features import shared code from `lib/core/` (such as common exceptions, design tokens, or database connections).
  3. **Inversion of Control (Riverpod Providers):** If feature A requires data from feature B (e.g., `analytics` needs to observe transaction streams), it must depend on feature B's abstract repository provider defined at the domain level, injected via Riverpod.

---

## 7. Data Flow

BankYar adheres to a strict **Unidirectional Data Flow (UDF)** mechanism, guaranteeing predictable state mutations and seamless test coverage.

### Sequence 1: Automated SMS Capture and UI Refresh (Event-Driven)
This loop occurs asynchronously. The UI is updated reactively when new data enters the encrypted database.

```
+---------------+      +------------------+      +---------------+      +----------------------+      +----------------------+      +---------------+
|  Android OS   |      | Native SMS Recv  |      | SmsParserRepo |      |  TxRepositoryImpl    |      | TxRepository Stream  |      |   Ledger UI   |
+-------+-------+      +--------+---------+      +-------+-------+      +----------+-----------+      +----------+-----------+      +-------+-------+
        |                       |                        |                         |                             |                          |
        | SMS Broadcast         |                        |                         |                             |                          |
        |---------------------->|                        |                         |                             |                          |
        |                       | Package raw SMS        |                         |                             |                          |
        |                       |----------------------->|                         |                             |                          |
        |                       | (Sender, Body, Time)   | Parse SMS               |                             |                          |
        |                       |                        |------------------------>|                             |                          |
        |                       |                        | (Extract amount, card)  | Write Encrypted             |                          |
        |                       |                        |                         |---------------------------->|                          |
        |                       |                        |                         | (Insert SQLCipher DB Page)  | Emit Stream update       |
        |                       |                        |                         |                             |------------------------->|
        |                       |                        |                         |                             |                          | (Re-renders)
```

### Sequence 2: User Action Data Flow (Manual Transaction Entry)
When the user submits a manual entry form:

```
+---------------+      +--------------------+      +--------------------+      +--------------------+      +--------------------+
|   Ledger UI   |      |   LedgerNotifier   |      |  AddManualEntryUC  |      |  TxRepositoryImpl  |      | SQLCipher Database |
+-------+-------+      +---------+----------+      +---------+----------+      +---------+----------+      +---------+----------+
        |                        |                           |                           |                           |
        | Click Submit Form      |                           |                           |                           |
        |----------------------->|                           |                           |                           |
        |                        | Invoke UseCase            |                           |                           |
        |                        |-------------------------->|                           |                           |
        |                        | (Pass Transaction Entity) | Invoke Repository Write   |                           |
        |                        |                           |-------------------------->|                           |
        |                        |                           |                           | Map Entity to DTO & Write |
        |                        |                           |                           |-------------------------->|
        |                        |                           |                           |                           | Save page
        |                        |                           |                           |<--------------------------| Success
        |                        |                           | Return success/error      |                           |
        |                        |                           |<--------------------------|                           |
        |                        | Update UI State           |                           |                           |
        |                        |<--------------------------|                           |                           |
        | Re-renders Screen      |                           |                           |                           |
        |<-----------------------|                           |                           |                           |
```

---

## 8. Application Lifecycle

As an offline-only finance tracker, application lifecycle transitions govern security states, encryption key caching, and background safety.

```
       +-------------------------------------------------------+
       |                     App Inactive                      |
       |  - Plaintext memory clear                             |
       |  - DB locked, file unopened                           |
       +--------------------------+----------------------------+
                                  |
                                  | Launch / User open app
                                  v
       +-------------------------------------------------------+
       |                     Active State                      |
       |  - Prompt secure authentication screen (PIN/Bio)      |
       |  - On pass: Retrieve Key & initialize SQLCipher       |
       |  - Stream active ledger & analytics view              |
       +--------------------------+----------------------------+
            |                                             ^
            | User suspends / background                  | Biometric authentication
            v                                             | matches (within 5 mins)
       +--------------------------------------------------+----+
       |                   Background State                    |
       |  - Blurred/Secure Overlay active (App switcher blurs)|
       |  - Start Inactivity Timer (5-minute countdown)       |
       |  - Background SMS Ingestion remains active (Android)  |
       +--------------------------+----------------------------+
                                  |
                                  | Timer Exceeds 5 Minutes
                                  v
       +-------------------------------------------------------+
       |                    Suspended State                    |
       |  - Evict Master Key from volatile RAM memory          |
       |  - Flush DB transaction pools & close SQLite handle   |
       |  - Next resume forces hard re-authentication lock     |
       +-------------------------------------------------------+
```

### Key Security Safeguards
* **Memory Protection (Key Eviction):** Plaintext variables containing the master database key must not remain in the app process's garbage-collectable memory indefinitely. When the system detects background status exceeding 5 minutes, it invokes a garbage-cleanable key disposal method, scrubbing the byte arrays from RAM.
* **Blank Preview Screen overlay (Screen Security):** During background transition, the app registers a native layout event `FLAG_SECURE` on Android (and configures the App Delegate's window preview in iOS) to completely redact the transaction totals from the multitasking drawer preview.

---

## 9. SMS Processing Pipeline

Since the incoming financial notification parsing is an asynchronous background activity, its pipeline must run reliably, avoiding memory leaks and frame-drops.

```
                                  Android OS SMS Captured
                                             |
                                             v
                              Native Android BroadcastReceiver
                                             |
                                             v
                               Native WorkManager Worker Thread
                                             |
                                             v
                              Flutter Native EventChannel (Dart)
                                             |
                                             v
                             Pipeline Deduplicator (Hash Check)
                                             |
                                             v
                              Deterministic Regex Router
                                /                      \
                    Pattern Match Found           No Match Found
                            /                              \
                           v                                v
                  Metadata Extraction            Lightweight Heuristic Engine
                           \                                /
                            \                              /
                             v                            v
                            Category & Tag Auto-Rule Ingestion
                                             |
                                             v
                              Save to Encrypted DB Page
```

### Step-by-Step Pipeline Specifications:
1. **Deduplication Phase:** Calculates a SHA-256 hash using the string concatenation of `Hash(sender + body + timestamp)`. If the database returns a matching hash index, the transaction is rejected as a duplicate duplicate event, preventing multiple transaction records from double-broadcast events.
2. **Deterministic Regex Engine:** Maps the raw body text against active JSON-structured matching templates stored locally. Match loops execute in `< 100ms`.
3. **Heuristic Fallback Engine:** If zero deterministic templates match, the fallback parser acts on regularized statistical boundaries:
   * Extracts currency markers (e.g. `$`, `USD`, `EUR`).
   * Extracts decimal patterns matching high-probability financial formats (e.g. `XX,XXX.XX`).
   * Extracts transactional verbs (e.g., "withdrawn", "credited", "charged").
   * Categorizes the confidence level as "Heuristic - Low Confidence" and marks the record visually in the UI for user review.
4. **Auto-Rule Engine:** Runs custom user definitions (e.g., if body contains "Shell" -> category = "Fuel").
5. **Database Transaction Pool:** Persists the final transaction in a write-ahead logging (WAL) transactional statement block.

---

## 10. Dependency Injection Strategy

Dependency Injection (DI) is achieved cleanly using **Riverpod Providers**. Since Riverpod serves as both the state framework and the DI container, it completely replaces service locators like `GetIt` and code-generators like `Injectable`, maximizing build speed and keeping the architecture simple.

### Provider Hierarchy & DI Configuration

```
+---------------------------------------------------------------------------------------------------+
|                                     GLOBAL INFRASTRUCTURE PROVIDERS                               |
|                                                                                                   |
|  +-------------------------------------+                 +-------------------------------------+  |
|  | secureStorageProvider               |                 | dbConnectionProvider                |  |
|  | (Exposes FlutterSecureStorage client|                 | (Manages SQLCipher connection pool) |  |
|  +------------------+------------------+                 +------------------+------------------+  |
+---------------------|-------------------------------------------------------|---------------------+
                      |                                                       |
                      | Injected into                                         | Injected into
                      v                                                       v
+---------------------------------------------------------------------------------------------------+
|                                         REPOSITORY PROVIDERS                                      |
|                                                                                                   |
|  +---------------------------------------------------------------------------------------------+  |
|  | transactionRepositoryProvider                                                               |  |
|  | (Binds abstract TransactionRepository to TransactionRepositoryImpl concrete class)           |  |
|  +------------------+--------------------------------------------------------------------------+  |
+---------------------|-----------------------------------------------------------------------------+
                      |
                      | Injected into
                      v
+---------------------------------------------------------------------------------------------------+
|                                          USE CASE PROVIDERS                                       |
|                                                                                                   |
|  +---------------------------------------------------------------------------------------------+  |
|  | getTransactionsStreamUseCaseProvider                                                        |  |
|  | (Provides instances of GetTransactionsStreamUseCase with injected repository dependency)     |  |
|  +------------------+--------------------------------------------------------------------------+  |
+---------------------|-----------------------------------------------------------------------------+
                      |
                      | Injected / Watched by
                      v
+---------------------------------------------------------------------------------------------------+
|                                        PRESENTATION STATE PROVIDERS                               |
|                                                                                                   |
|  +---------------------------------------------------------------------------------------------+  |
|  | ledgerStateNotifierProvider                                                                 |  |
|  | (Watches UseCase Streams and exposes LedgerUIState to Presentation widgets)                 |  |
|  +---------------------------------------------------------------------------------------------+  |
+---------------------------------------------------------------------------------------------------+
```

### Mocking & Testing Strategy
Because Riverpod allows overriding providers dynamically, writing high-coverage unit and integration tests is incredibly clean. During test initialization, the system can override infrastructure and data layers without complex boilerplate:

```dart
// Mocking data sources inside a Dart unit test:
final container = ProviderContainer(
  overrides: [
    transactionRepositoryProvider.overrideWithValue(MockTransactionRepository()),
    secureStorageProvider.overrideWithValue(MockSecureStorage()),
  ],
);
```

---

## 11. Error Handling Strategy

An offline-only application must be resilient to local filesystem crashes, key synchronization losses, and database corruption without losing user data.

```
       +-------------------------------------------------------------------+
       |                            Exception Type                         |
       +--------------------+---------------------+---------------------+
                            |                     |
             SQLite / Disk Issues           Keystore Issues        Parsing Exception
                            |                     |                     |
                            v                     v                     v
       +--------------------+-------+     +-------+------------+     +--+------------------+
       | DatabaseException          |     | AuthException      |     | ParserException     |
       | - Corruption               |     | - Key Lost         |     | - Unknown Format    |
       | - Out of Space             |     | - Auth Cancelled   |     | - Bad RegEx         |
       +--------------------+-------+     +-------+------------+     +--+------------------+
                            |                     |                     |
                            v                     v                     v
       +--------------------+-------+     +-------+------------+     +--+------------------+
       |   DATA LAYER       |       |     |   SECURITY LAYER   |     |   DATA LAYER        |
       | - Catch & Map raw  |       |     | - Re-init Keystore |     | - Fallback to       |
       |   errors to clean  |       |     |   keys             |     |   unparsed item     |
       |   Failures         |       |     | - Clear cache      |     | - Save raw body     |
       +--------------------+-------+     +-------+------------+     +--+------------------+
                            |                     |                     |
                            v                     v                     v
       +--------------------+-------+     +-------+------------+     +--+------------------+
       |   DOMAIN LAYER     |       |     |   DOMAIN LAYER     |     |   DOMAIN LAYER      |
       | - Evaluate failure |       |     | - Notify UI of lock|     | - Complete domain   |
       | - Trigger disaster |       |     |   failure          |     |   mapping cleanly   |
       |   recovery protocol|       |     |                    |     |                     |
       +--------------------+-------+     +-------+------------+     +--+------------------+
                            |                     |                     |
                            v                     v                     v
       +--------------------+-------+     +-------+------------+     +--+------------------+
       | PRESENTATION LAYER |       |     | PRESENTATION LAYER |     | PRESENTATION LAYER  |
       | - Show safe backup |       |     | - Redirect to Lock |     | - Display manual    |
       |   restore screen   |       |     |   with error code  |     |   enrichment view   |
       +----------------------------------+------------------------------------------------+
```

### Core Exception-to-Failure Translation Mechanism
Instead of bubbling unstable database exceptions up to Flutter views, Repository implementations capture platform errors and return functional Dart unions or domain-specific objects using standard patterns:

1. **Failure Hierarchy:** Base class `Failure` with specializations:
   * `DatabaseCorruptionFailure`: Triggered when SQLCipher database signature verification fails.
   * `AuthenticationTimeoutFailure`: Triggered when key retention time expires.
   * `ParserTemplateFailure`: Indicates a corrupt template configuration file.
2. **Disaster Recovery Strategy:**
   * In the rare event of database corruption or file-access issues, the UI intercepts `DatabaseCorruptionFailure` and presents a dedicated **Disaster Recovery Interface**.
   * The user is guided to safely initialize a fresh, empty database and import their most recent manual backup export.

---

## 12. Logging Strategy

Since the application contains no network pipeline, diagnostic telemetry must be generated locally, encrypted, and manually exported under direct user supervision.

```
       +-------------------------------------------------------+
       |                      Log Event                        |
       +--------------------------+----------------------------+
                                  |
                                  v
       +-------------------------------------------------------+
       |                    Logger Sanitizer                   |
       |  - Scrub all numerical sequences (PII risk)           |
       |  - Scrub possible merchant names & currency keys      |
       +--------------------------+----------------------------+
                                  |
                                  v
       +-------------------------------------------------------+
       |                    In-Memory buffer                   |
       |  - Store up to 100 entries for fast diagnostics       |
       +--------------------------+----------------------------+
                                  |
                                  | Rotates / flushes
                                  v
       +-------------------------------------------------------+
       |               Local Encrypted Log File                |
       |  - Encrypted via AES-256-GCM using app storage key    |
       |  - Rotates at 2 Megabytes (keeps last 3 rotations)    |
       +-------------------------------------------------------+
                                  |
                                  | Explicit User Consent Action
                                  v
       +-------------------------------------------------------+
       |                  Local Export Folder                  |
       |  - Decrypted and packaged as standard human-readable  |
       |    JSON file when user clicks "Export Diagnostics"    |
       +-------------------------------------------------------+
```

### Strict PII Scrubbing Specifications:
Before any entry is serialized into the local diagnostic file:
* **Rule 1:** Regex-scrub sequences resembling credit cards, account balances, or transaction amounts: `[0-9]+` patterns within log bodies are replaced with `[REDACTED_NUM]`.
* **Rule 2:** Filter out the actual raw body of SMS messages from the logs, keeping only the matching template ID or the specific exception type.

---

## 13. Configuration Management

BankYar stores its static and dynamic behaviors in an offline-friendly, sandboxed configurations container.

### System Configuration Scope & Rules

```
+-------------------------------------------------------------------------------------------+
|                                  LOCAL CONFIGURATION CONTAINER                            |
|                                                                                           |
|  +-----------------------------+  +----------------------------+  +--------------------+  |
|  | Standard Engine Config      |  | Deterministic Regex Maps   |  | In-App Prefs       |  |
|  | - System schema version     |  | - Template ID              |  | - App Lock enabled |  |
|  | - Logging verbosity flags   |  | - Match Expressions        |  | - Theme Mode       |  |
|  | - Diagnostics enabled flags |  | - Extraction Target Indices|  | - Diagnostic count |  |
|  +-----------------------------+  +----------------------------+  +--------------------+  |
+-------------------------------------------------------------------------------------------+
```

### Parser Ingestion and Custom Rules Updates
Without internet permissions, configuration drifts (such as a bank updating its SMS template) are resolved via secure, localized offline vectors:
1. **Offline QR Scan:** A user scans a custom QR code (shared by the community or generated by developers). The scanned payload contains a signed JSON array outlining the updated Regex configurations. The app decodes, cryptographically signs, and appends the new rules into the local configurations database table.
2. **Local Text Import:** The user copies an updated configuration JSON string to their clipboard or selects a file from their local storage, initiating safe local verification before update.

---

## 14. Future Extension Points

The architecture is built to support evolutionary iterations without requiring a deep redesign of current modules.

```
+---------------------------------------------------------------------------------------------------------+
|                                       FUTURE EXTENSION PARADIGMS                                        |
+---------------------------------------------------------------------------------------------------------+
|                                                                                                         |
|  1. Notification Listener Integration ( capture transactions from NeoBanks without SMS )                |
|     - Android Notification Service -> Native Host Interface -> Unified Stream -> Parse Ingestion        |
|                                                                                                         |
|  2. Cross-Platform Clipboard Auto-Detection ( iOS Background Fallback UX )                              |
|     - App Resume Hook -> Clipboard Inspection -> Match Ingestion Rules -> Quick-Import Dialog Overlay   |
|                                                                                                         |
|  3. Advanced AI/NLP Parser Integration ( TFLite Mini Heuristics )                                       |
|     - Replace current heuristic matcher with on-device BERT-mini or lightweight Naive Bayes tokenizer    |
|                                                                                                         |
|  4. Local Wi-Fi Sync Backup Network ( P2P Direct Local Network Synchronization )                       |
|     - Local network socket listeners (No-Internet) -> Direct sync with NAS or trusted Desktop companion |
|                                                                                                         |
+---------------------------------------------------------------------------------------------------------+
```

---

## 15. Technical Risks & Mitigations

As an offline-first financial application, BankYar faces several structural environment risks:

| Risk Identifier | Technical Risk Scenario | Architectural Severity | Architectural Mitigation Strategy |
| :--- | :--- | :--- | :--- |
| **TR-01** | Aggressive background worker termination by customized Android battery optimization. | High | Utilize native `WorkManager` paired with foreground notification prompts for large batches of SMS processing, ensuring background worker tasks run with high OS priority. |
| **TR-02** | Decryption failure due to Keystore corruption or hardware-bound cryptographic key loss. | High | Implement a standard, password-protected **Export Backup** protocol using `AES-256-GCM` with keys derived via `PBKDF2`. If the Keystore resets, users restore from this external offline recovery file. |
| **TR-03** | Future deprecation of classic SMS alerts in favor of proprietary, interactive banking apps. | Medium | Design the ingestion service to process abstract text objects. This allows a seamless addition of an **Android Notification Listener Service** without modifying the parser or database schemas. |
| **TR-04** | Execution blocks and frame-drops during large-volume historical imports (such as importing a 10-year CSV statement). | Medium | Use Dart Isolates for parsing, processing, and batching DB entries, keeping the main Flutter UI isolate completely unblocked. |

---

## 16. Trade-off Decisions

Every architectural decision involves balancing multiple priorities. Below is the justification for the trade-offs made in BankYar's architecture:

### 1. Flutter vs. Native Android (Background Service Execution)
* **The Choice:** We choose Flutter with Native platform channel abstraction rather than 100% Native Kotlin.
* **The Trade-off:** Native Kotlin would provide simpler background lifecycle bindings. However, committing to Flutter yields 95% code parity across platforms. This ensures that the Domain, Data models, Parser schemas, State Management, and UI remain 100% reusable for the iOS Phase 2 migration, significantly lowering long-term maintenance costs and facilitating easier AI integration.

### 2. Riverpod vs. BLoC (State Management & Dependency Injection)
* **The Choice:** We choose Riverpod for both state management and dependency injection.
* **The Trade-off:** BLoC is excellent for complex state isolation but introduces high boilerplate, which can confuse AI code-generation agents. Riverpod provides highly descriptive, declarative dependency graph binding natively in Dart, reducing boilerplate and providing cleaner mocking surfaces for unit tests.

### 3. SQLite (SQLCipher) vs. Hive/NoSQL (Local Storage)
* **The Choice:** We choose SQLCipher over unencrypted/semi-encrypted NoSQL stores like Hive or SharedPreferences.
* **The Trade-off:** SQLCipher adds slightly larger binary overhead (~10MB compilation footprint) and minor query latencies. However, NoSQL options lack robust, audited, page-level encryption. For financial tracking, data privacy is our paramount NFR, making SQLCipher the correct choice.

### 4. Direct Parsing vs. Dart Isolates
* **The Choice:** We run SMS parsing and SQLite writes off the main thread.
* **The Trade-off:** This requires minor asynchronous orchestration overhead. However, it completely avoids main-thread UI frame-drops, guaranteeing a responsive 60fps+ layout even during bulk transaction streams.

---

## 17. Architectural Decision Records (ADR)

The system baseline conforms to five core Architectural Decision Records:

### ADR-001: Architecture Pattern Selection
* **Status:** Accepted
* **Context:** The application needs to support rapid development, unit testing, and future iOS migration.
* **Decision:** We commit to Clean Architecture combined with Feature-First Organization.
* **Rationale:** Decouples core business logic (pure Domain) from framework dependencies. Feature-first organization isolates feature logic, making it extremely straightforward for developer teams and AI models to modify features with zero structural side effects.

### ADR-002: Local Database Selection
* **Status:** Accepted
* **Context:** Financial transaction records require strict transactional guarantees (ACID) and robust encryption.
* **Decision:** Utilize SQLite encrypted at rest via SQLCipher.
* **Rationale:** Structured relational tables are ideal for searching, filtering, and running complex analytical queries. SQLCipher is the industry standard for on-device database encryption.

### ADR-003: State Management & DI Framework
* **Status:** Accepted
* **Context:** The system requires a highly testable, cohesive state synchronization model.
* **Decision:** Riverpod for State Management and Dependency Injection.
* **Rationale:** Avoids the boilerplate of BLoC while offering compile-time safety for dependency injection. It makes mocking repositories in unit tests extremely direct.

### ADR-004: Encryption & Key Management
* **Status:** Accepted
* **Context:** Plaintext keys must never reside on non-volatile storage.
* **Decision:** Store the master database encryption key inside `flutter_secure_storage` (which binds directly to Android KeyStore and iOS Secure Enclave).
* **Rationale:** Hardware-backed key preservation guarantees that keys cannot be extracted even from rooted devices.

### ADR-005: Platform-Independent Parser Schema
* **Status:** Accepted
* **Context:** Background SMS interception is blocked on iOS, but parsing must perform identically.
* **Decision:** Implement the text parsing engine inside pure Dart (Domain/Data layer), keeping it completely detached from native Android APIs.
* **Rationale:** By writing the Parser Engine in Dart, iOS can reuse the exact same matching schemas, regular expressions, and diagnostic configurations for clipboard imports, maintaining absolute parity in parsing results across devices.

---

## 18. Architecture Validation Checklist

To maintain architectural integrity throughout development, any code contribution must satisfy this validation checklist before merge:

* [ ] **No Internet Permission:** Ensure `android.permission.INTERNET` is absent from `AndroidManifest.xml` and no network request libraries are introduced.
* [ ] **Strict Layer Separation:** Verify that the `domain` layer has exactly zero references to external frameworks, libraries (such as SQLCipher, Riverpod, or Material), or native channels.
* [ ] **Unidirectional Data Flow:** Ensure that UI widgets do not directly mutate any repository state; they must dispatch intents through Riverpod Notifiers which invoke Domain Use-Cases.
* [ ] **PII Redaction in Log Operations:** Verify that any local diagnostic logging (`FR-2.6`) scrubs numbers and excludes raw SMS body strings to preserve security boundaries.
* [ ] **Secure Storage Keys:** Ensure that no cryptographic key, password, or master key byte array is stored in plaintext on disk or in system shared preferences.
* [ ] **60 FPS Performance Guarantee:** Verify that all parsing algorithms and database write operations execute asynchronously off the main UI thread.
* [ ] **Independent Unit Testability:** Verify that every feature repository has a matching mock implementation, and features achieve a high level of test coverage without needing a running database instance.

---
**End of Document**
