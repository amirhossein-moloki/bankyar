# BankYar Feature Architecture & Module Boundaries Specification

**Document Version:** 1.0.0
**Status:** Approved / Architectural Blueprint
**Classification:** Technical Architecture Specification
**Target Audience:** Enterprise Software Architects, Lead Developers, Security Engineers, AI Agents

---

## Executive Summary

BankYar is an offline-first, secure mobile personal finance manager that captures and processes cellular SMS transaction notifications. This document defines the **Feature-First modular architecture** and **strict module boundaries** for BankYar. Designed to support highly isolated development, clean boundaries, seamless future package extraction, and AI-first engineering, this architecture ensures zero-leakage, predictable dependency management, and ironclad offline privacy constraints.

---

## 1. Feature Architecture Taxonomy & Map

The application is modularized into vertical functional slices (Features) and horizontal support tiers.

```
+-------------------------------------------------------------------------------------------------+
|                                    PRESENTATION & SHELL TIER                                    |
|              [ secure_auth ]  [ ledger ]  [ analytics ]  [ settings ]  [ rules_builder ]        |
+-------------------------------------------------------------------------------------------------+
                                               │
                                               ▼
+-------------------------------------------------------------------------------------------------+
|                                      FEATURE SERVICES TIER                                      |
|              [ sms_detection ]   [ backup_restore ]   [ notification_gateway ]                  |
+-------------------------------------------------------------------------------------------------+
                                               │
                                               ▼
+-------------------------------------------------------------------------------------------------+
|                                        SHARED KERNEL TIER                                       |
|             [ core_common ]   [ core_security ]   [ core_database ]   [ core_logging ]          |
+-------------------------------------------------------------------------------------------------+
```

---

## 2. Feature Inventory & Classification

To decouple functional logic and maximize modularity, BankYar defines and isolates its features into four key classifications:

### 2.1 Core Features
These form the primary business value and intellectual property. They process text, match configurations, and produce the financial ledger.
1. **SMS Capture:** Background/foreground interception of raw messages.
2. **SMS Parser:** Text analysis, tokenization, deterministic Regex routing, and heuristic fallback classification.
3. **Bank Detection:** Analysis of sender IDs to determine financial institution affiliations.
4. **Transaction Management:** Maintaining, modifying, and manually entering structured transactions.
5. **Parser Rules:** Management of regex layouts and active token-index configurations.

### 2.2 Supporting Features
These augment the Core Features by offering enrichment, visualization, and manual workflow improvements.
6. **Notes:** Textual annotations directly owned by individual transaction entities.
7. **Search:** Advanced multi-attribute search over transactions.
8. **Filters:** Faceted structural constraints on the ledger.
9. **Statistics:** Offline spending trends, cash flow aggregations, and category allocation calculations.
10. **Import / Export:** CSV/JSON statements importing and user-triggered encrypted manual backup exports.
11. **Diagnostics:** In-app background service status verification and whitelisting guides.

### 2.3 Shared Features (The Shared Kernel)
These provide generic, reusable cross-cutting components with zero dependencies on other features.
12. **Permissions:** Platform-abstracted system authorization controllers.
13. **Notifications:** System-tray alerting when background transaction generation succeeds.
14. **Settings:** User application configuration storage.
15. **Security:** Hardware-backed biometric access controls, lock-screen triggers, and key managers.
16. **Theme:** Design system tokens, color parameters, and typography.
17. **Localization:** Multilingual support wrappers without cloud dependencies.

### 2.4 Infrastructure Features
These wrap low-level system services, database engines, and diagnostic facilities.
18. **Database:** Thread-isolated, SQLCipher-encrypted SQLite connection pools and migrations.
19. **Logging:** Sized-capped, PII-scrubbed offline diagnostic file handlers.
20. **Configuration:** Master static environment variables.
21. **Backup:** Local-file read-write wrappers.

---

## 3. Feature Hierarchy

The physical folder structure of BankYar aligns directly with this vertical modularity. Inside the `lib/` directory, code is divided into `features/` and `core/`:

```
lib/
├── core/                                   # Horizontal Shared Kernel (Shared Modules)
│   ├── common/                             # Generic models, functional utilities, common extensions
│   ├── database/                           # SQLCipher initialization, migrations, base DAO contracts
│   ├── logging/                            # PII-scrubbed local error logging and rotation engine
│   ├── localization/                       # Static offline dictionary files and translators
│   ├── security/                           # Master key derivation, biometric hooks, Keystore interfaces
│   └── ui/                                 # Central design system, style tokens, and generic widgets
│
└── features/                               # Vertical Functional Slices (Modular Features)
    ├── sms_detection/                      # SMS Capture, Bank Detection, and SMS Parser feature
    ├── transactions/                       # Transaction Management, Notes, Search, Filters, Parser Rules
    ├── analytics/                          # Statistics, Allocation Charts, and Trend Analyzer
    ├── backup_restore/                     # JSON/CSV Import/Export and Password-Derived Cryptography
    └── secure_auth/                        # Local PIN, Biometric lock screens, and Lockout monitors
```

---

## 4. Module Responsibilities & Ownership

To facilitate rapid parallel development, ownership is assigned to specialized teams (or AI-Agent workflows).

| Module Name | Tier | Domain / Business Responsibility | Primary Owner |
| :--- | :--- | :--- | :--- |
| `sms_detection` | Core | Intercepts cellular SMS, executes the hybrid parsing pipeline (deterministic & heuristic fallbacks), and issues parsed domain events. | Parsing & Engine Team |
| `transactions` | Core | Manages the unified Transaction Ledger, handles categories, rules matching, annotations (notes/tags), and supports manual entry. | Ledger Domain Team |
| `analytics` | Supporting | Calculates cash flows, groups category allocations, computes offline charts, and evaluates behavior trends. | Data Science & UI Team |
| `backup_restore` | Supporting | Executes PBKDF2 key derivations, handles AES-GCM file encryption, and reads/writes local backup files. | Security & Portability Team |
| `secure_auth` | Supporting | Interacts with device authenticators, enforces lockouts, blurs task switcher previews, and tracks PIN hashes. | Security & Platform Team |
| `core_security` | Shared | Standardizes Keystore wrappers and manages runtime key memory-eviction lifecycles. | Security & Platform Team |
| `core_database` | Infrastructure | Opens and secures SQLCipher databases, running ACID transactional statements and localized schema migrations. | Database Platform Team |

---

## 5. Extensive Feature-by-Feature Analysis

This section analyzes every expected feature, outlining its core structure, responsibilities, API, risks, and evolutionary paths.

---

### Feature 1: SMS Capture
* **Purpose:** Intercept incoming SMS broadcasts in real-time.
* **Business Responsibility:** Secure cellular message data, extract raw carrier text payload, and dispatch to ingestion.
* **Owned Entities:** `SMS` (Root)
* **Owned Services:** `SMSReceiverService` (Adapts platform events to Dart streams)
* **Owned Use Cases:** `CaptureIncomingSmsUseCase`
* **Owned Repositories:** `SmsCaptureRepository`
* **External Dependencies:** Android Telephony Broadcast API, `WorkManager` package
* **Internal Components:** `AndroidSmsBroadcastReceiver`, `SmsCaptureBackgroundWorker`
* **Public API:**
  ```dart
  abstract class SmsCaptureRepository {
    Stream<SmsRawPayload> get incomingSmsStream;
    Future<void> startListening();
    Future<void> stopListening();
  }
  ```
* **Extension Points:** Alternate inputs (e.g., Android Notification Listener Service for banking app push notifications).
* **Risks:** Operating system kills background service to save battery.
* **Future Evolution:** Fully integrated notification scraping matching neo-bank application trays.

---

### Feature 2: SMS Parser
* **Purpose:** Extract structured financial figures from raw unstructured texts.
* **Business Responsibility:** Run deterministic regex matching, falling back to on-device heuristic classifiers if no templates match.
* **Owned Entities:** `ParserTemplate` (Root)
* **Owned Services:** `ParserEngine` (Orchestrates regex and fallback tokenizers)
* **Owned Use Cases:** `ParseSmsPayloadUseCase`, `CompileRegexPatternUseCase`
* **Owned Repositories:** `ParserTemplateRepository`
* **External Dependencies:** Standard RegExp Engine, mathematical decimal packages
* **Internal Components:** `RegexMatcher`, `HeuristicFallbackClassifier`, `TokenExtractor`
* **Public API:**
  ```dart
  abstract class ParserEngine {
    Future<ParserOutput> parse(String text, {required String senderId});
  }
  ```
* **Extension Points:** On-device lightweight NLP models (e.g., TensorFlow Lite Tokenizers).
* **Risks:** Re-compiled regex patterns hanging due to catastrophic backtracking.
* **Future Evolution:** User-trainable local Naive Bayes classifiers to learn custom SMS structures dynamically.

---

### Feature 3: Bank Detection
* **Purpose:** Resolve the identity of the financial institution sending the transaction SMS.
* **Business Responsibility:** Normalise carrier Sender IDs (e.g., "CHASE_TX" $\rightarrow$ "Chase Bank").
* **Owned Entities:** None (Uses attributes of `ParserTemplate` and `Transaction`)
* **Owned Services:** `BankResolutionService`
* **Owned Use Cases:** `ResolveBankBySenderIdUseCase`
* **Owned Repositories:** `BankRegistryRepository`
* **External Dependencies:** None
* **Internal Components:** `SenderIdLookupTable`, `KeywordMatcher`
* **Public API:**
  ```dart
  class BankResolutionService {
    BankMetadata resolve(String senderId);
  }
  ```
* **Extension Points:** QR-code import of custom institution lists.
* **Risks:** Dynamic mapping collisions with non-bank commercial senders (e.g., "ALERTS" used by multiple vendors).
* **Future Evolution:** Cryptographic carrier validation if telecom standards evolve.

---

### Feature 4: Transaction Management
* **Purpose:** Core financial ledger control and operations.
* **Business Responsibility:** Create, read, update, and delete transaction histories; assign custom categories and manual records.
* **Owned Entities:** `Transaction` (Root)
* **Owned Services:** `CategorizationRuleService`
* **Owned Use Cases:** `GetTransactionsStreamUseCase`, `AddManualTransactionUseCase`, `UpdateTransactionUseCase`, `DeleteTransactionUseCase`
* **Owned Repositories:** `TransactionRepository`
* **External Dependencies:** `core_database`
* **Internal Components:** `LedgerFilterEngine`, `CategoryResolver`
* **Public API:**
  ```dart
  abstract class TransactionRepository {
    Stream<List<Transaction>> watchTransactions({TransactionQueryFilter? filter});
    Future<void> saveTransaction(Transaction transaction);
    Future<void> deleteTransaction(String id);
  }
  ```
* **Extension Points:** Integration of automated cash-back calculations.
* **Risks:** Database locked state during background ingestion writes.
* **Future Evolution:** Multiple independent sub-ledgers (e.g., separating personal vs. business expenses).

---

### Feature 5: Notes
* **Purpose:** Enrich financial transactions with user context.
* **Business Responsibility:** Allow users to write custom text notes directly attached to transactions.
* **Owned Entities:** `Note` (Owned by `TransactionAggregate`)
* **Owned Services:** None (Managed via the `Transaction` aggregate root)
* **Owned Use Cases:** `UpdateTransactionNoteUseCase`
* **Owned Repositories:** None (Persisted inside the `TransactionRepository` boundary)
* **External Dependencies:** None
* **Internal Components:** `NotesInputValidator`
* **Public API:**
  ```dart
  // Accessed strictly through TransactionAggregate
  class Transaction {
    final Note? note;
    Transaction copyWith({Note? note});
  }
  ```
* **Extension Points:** Tag extraction from notes text.
* **Risks:** Text field input bloat causing memory lag during large list scrolls.
* **Future Evolution:** Automatic markdown formatting inside notes for rich logs.

---

### Feature 6: Search
* **Purpose:** Instant local querying of transaction logs.
* **Business Responsibility:** Match query text against merchant names, notes, raw SMS strings, and tags.
* **Owned Entities:** None
* **Owned Services:** `LocalSearchService`
* **Owned Use Cases:** `SearchTransactionsUseCase`
* **Owned Repositories:** None (Queries transaction tables)
* **External Dependencies:** SQLCipher FTS (Full-Text Search) Module
* **Internal Components:** `SearchQueryTokenizer`, `FtsQueryBuilder`
* **Public API:**
  ```dart
  class LocalSearchService {
    Future<List<Transaction>> query(String text);
  }
  ```
* **Extension Points:** Soundex/Fuzzy-matching search for typo-tolerant queries.
* **Risks:** High execution latency when processing millions of historical transactions.
* **Future Evolution:** Semantic embeddings mapped on-device for concept-based search.

---

### Feature 7: Filters
* **Purpose:** Dynamic ledger segmentation.
* **Business Responsibility:** Parse multiple concurrent parameters (dates, amounts, categories, banks) and build query constraints.
* **Owned Entities:** None
* **Owned Services:** `LedgerFilterService`
* **Owned Use Cases:** `ApplyFiltersUseCase`
* **Owned Repositories:** None
* **External Dependencies:** None
* **Internal Components:** `QueryFilterBuilder`
* **Public API:**
  ```dart
  class TransactionQueryFilter {
    final DateTimeRange? dateRange;
    final double? minAmount;
    final List<String>? categoryIds;
    final TransactionType? type;
  }
  ```
* **Extension Points:** Filter template configurations (e.g., "Save Filter as Smart Folder").
* **Risks:** Query failures if database indices are missing for combined filters.
* **Future Evolution:** Multi-column relational filters across notes, hashtags, and institutions.

---

### Feature 8: Statistics
* **Purpose:** Offline visual analytics.
* **Business Responsibility:** Group historical records into financial structures, calculating ratios, spending velocities, and income-expense margins.
* **Owned Entities:** None (Uses `Transaction` datasets)
* **Owned Services:** `AnalyticsCalculationService`
* **Owned Use Cases:** `GenerateCashFlowReportUseCase`, `CalculateCategoryAllocationsUseCase`
* **Owned Repositories:** None
* **External Dependencies:** UI plotting libraries (e.g., `fl_chart`)
* **Internal Components:** `AllocationCalculator`, `VelocityTrendEngine`
* **Public API:**
  ```dart
  class CashFlowReport {
    final double totalIncome;
    final double totalExpenses;
    final Map<String, double> categorySums;
  }
  ```
* **Extension Points:** Automated budget ceiling alerts.
* **Risks:** Floating-point precision inaccuracies across massive datasets.
* **Future Evolution:** Local spending forecast using linear regression or ARIMA projections.

---

### Feature 9: Backup
* **Purpose:** Prevent user data loss under 100% offline bounds.
* **Business Responsibility:** Package database snapshots into a single password-protected, encrypted backup file.
* **Owned Entities:** None
* **Owned Services:** `BackupEncryptionService`
* **Owned Use Cases:** `ExportEncryptedBackupUseCase`, `ValidateBackupFileUseCase`
* **Owned Repositories:** `BackupRepository`
* **External Dependencies:** Platform Local File Systems, `PBKDF2`, `AES-256-GCM` encryption
* **Internal Components:** `KeyDerivationFunction`, `PayloadSerializer`, `ZipCompressor`
* **Public API:**
  ```dart
  abstract class BackupRepository {
    Future<void> exportBackup(String path, String password);
    Future<bool> verifyBackup(String path, String password);
  }
  ```
* **Extension Points:** Cross-device sync formats (JSON compatible).
* **Risks:** User forgets password, rendering backups permanently unrecoverable.
* **Future Evolution:** Seamless P2P syncing over local Wi-Fi to desktop app companion.

---

### Feature 10: Settings
* **Purpose:** Manage global configuration parameters.
* **Business Responsibility:** Persist user choices (Biometric toggles, themes, notifications, languages) securely.
* **Owned Entities:** None
* **Owned Services:** None
* **Owned Use Cases:** `GetSettingsUseCase`, `UpdateSettingsUseCase`
* **Owned Repositories:** `SettingsRepository`
* **External Dependencies:** `flutter_secure_storage` or Encrypted SharedPreferences
* **Internal Components:** `SettingsSerializer`
* **Public API:**
  ```dart
  abstract class SettingsRepository {
    Future<AppSettings> loadSettings();
    Future<void> saveSettings(AppSettings settings);
  }
  ```
* **Extension Points:** Cloudless config sharing via local files.
* **Risks:** Settings corruption on app updates.
* **Future Evolution:** Fine-grained notification grouping settings matching modern Android channels.

---

### Feature 11: Permissions
* **Purpose:** Abstract OS-level authorization requirements.
* **Business Responsibility:** Check and request cellular SMS receipt, background execution, and local storage read/write permissions.
* **Owned Entities:** None
* **Owned Services:** `SystemPermissionService`
* **Owned Use Cases:** `CheckPermissionUseCase`, `RequestPermissionUseCase`
* **Owned Repositories:** None
* **External Dependencies:** Platform permission API contracts (`permission_handler`)
* **Internal Components:** `AndroidPermissionAdapter`, `IosPermissionAdapter`
* **Public API:**
  ```dart
  abstract class SystemPermissionService {
    Future<PermissionStatus> checkStatus(PermissionType type);
    Future<PermissionStatus> request(PermissionType type);
  }
  ```
* **Extension Points:** Interactive setup onboarding flows.
* **Risks:** Operating system revokes permissions arbitrarily.
* **Future Evolution:** Custom deep-links guiding users to detailed OS settings partitions.

---

### Feature 12: Notifications
* **Purpose:** Dynamic transaction alert notifications.
* **Business Responsibility:** Raise alerts in the system tray when an SMS is parsed and committed in the background.
* **Owned Entities:** None
* **Owned Services:** `NotificationDisplayService`
* **Owned Use Cases:** `TriggerTransactionNotificationUseCase`
* **Owned Repositories:** None
* **External Dependencies:** Native OS Notification channels (`flutter_local_notifications`)
* **Internal Components:** `NotificationChannelBuilder`
* **Public API:**
  ```dart
  abstract class NotificationDisplayService {
    Future<void> showParsedAlert(String title, String body, {String? payload});
  }
  ```
* **Extension Points:** Deep-linking directly to specific transaction inspectors.
* **Risks:** Notifications blocked by OS configuration or focus modes.
* **Future Evolution:** Dynamic category-colored alerts with action buttons ("Tag", "Flag").

---

### Feature 13: Security
* **Purpose:** Access control and memory protection.
* **Business Responsibility:** Block interface with biometric prompts, enforce brute-force lockouts, and erase memory cryptokeys on timeout.
* **Owned Entities:** `SecurityConfig` (Root)
* **Owned Services:** `LocalAuthenticationService`, `MemoryKeyEvictionService`
* **Owned Use Cases:** `VerifyUserPinUseCase`, `EvictDbKeyUseCase`, `LockAppInterfaceUseCase`
* **Owned Repositories:** `SecurityConfigRepository`
* **External Dependencies:** Biometric Hardware Sensors (`local_auth`)
* **Internal Components:** `BiometricPromptAdapter`, `BruteForceLockoutCounter`
* **Public API:**
  ```dart
  abstract class LocalAuthenticationService {
    Future<bool> authenticateWithBiometrics();
    Future<bool> verifyPin(String pin);
  }
  ```
* **Extension Points:** Multi-factor local validation.
* **Risks:** Device lacks secure hardware (TEE/StrongBox), falling back to less secure PIN layers.
* **Future Evolution:** Panic-PIN input that executes a complete self-destruct sequence.

---

### Feature 14: Parser Rules
* **Purpose:** Structured user regex pattern creation.
* **Business Responsibility:** Provide rules-creation capabilities to process unsupported banks.
* **Owned Entities:** `ParserTemplate` (Root)
* **Owned Services:** `ParserRuleValidationService`
* **Owned Use Cases:** `CreateCustomTemplateUseCase`, `ValidateTemplateRegexUseCase`
* **Owned Repositories:** `ParserTemplateRepository`
* **External Dependencies:** None
* **Internal Components:** `InteractiveRegexTester`
* **Public API:**
  ```dart
  abstract class ParserTemplateRepository {
    Future<List<ParserTemplate>> loadTemplates();
    Future<void> saveTemplate(ParserTemplate template);
  }
  ```
* **Extension Points:** Import of verified shared community templates via secure, platform-independent QR codes.
* **Risks:** Malicious regular expressions causing CPU lockouts (ReDoS).
* **Future Evolution:** Visual non-regex template builder based on simple keyword selection tokens.

---

### Feature 15: Import / Export
* **Purpose:** Data portability.
* **Business Responsibility:** Map local transaction records to system-independent CSV/JSON arrays, and validate imported assets.
* **Owned Entities:** None
* **Owned Services:** `FileMappingService`
* **Owned Use Cases:** `ExportLedgerToCsvUseCase`, `ImportLedgerFromCsvUseCase`
* **Owned Repositories:** None (Leverages filesystem wrappers)
* **External Dependencies:** CSV parsing engine
* **Internal Components:** `CsvMarshaller`, `JsonUnmarshaller`, `SchemaValidator`
* **Public API:**
  ```dart
  class FileMappingService {
    Future<List<Transaction>> parseCsv(String rawCsv);
    String serializeToCsv(List<Transaction> list);
  }
  ```
* **Extension Points:** Support for multi-bank CSV dialects.
* **Risks:** Missing headers or corrupted field layouts during CSV imports.
* **Future Evolution:** Dynamic field-mapping UI enabling import from any financial CSV format.

---

### Feature 16: Logging
* **Purpose:** Safe error tracking.
* **Business Responsibility:** Record system events and stack traces to aid diagnostics while scrubbing financial data (PII).
* **Owned Entities:** `DiagnosticLog` (Root)
* **Owned Services:** `AnonymizationService`
* **Owned Use Cases:** `WriteDiagnosticLogUseCase`, `ClearLogsUseCase`
* **Owned Repositories:** `DiagnosticLogRepository`
* **External Dependencies:** File Storage System
* **Internal Components:** `LogSizer`, `PiiRegexScrubber`
* **Public API:**
  ```dart
  abstract class DiagnosticLogRepository {
    Future<void> log(LogLevel level, String message, {String? stackTrace});
    Future<List<DiagnosticLog>> getLogs();
  }
  ```
* **Extension Points:** Dynamic diagnostic level toggles.
* **Risks:** Log file exceeds maximum size allocations, swallowing important stack traces.
* **Future Evolution:** Categorized diagnostic exports showing parser execution timelines.

---

### Feature 17: Diagnostics
* **Purpose:** Background service health checks.
* **Business Responsibility:** Verify the background SMS listener's active status and guide users through battery optimization whitelists.
* **Owned Entities:** None
* **Owned Services:** `SystemHealthService`
* **Owned Use Cases:** `CheckBackgroundServiceHealthUseCase`
* **Owned Repositories:** None
* **External Dependencies:** Device manufacturer ROM identification systems
* **Internal Components:** `HealthCheckEngine`, `RomWhitelistManuals`
* **Public API:**
  ```dart
  class SystemHealthService {
    Future<ServiceHealthStatus> runSelfDiagnostics();
  }
  ```
* **Extension Points:** Interactive background heartbeats.
* **Risks:** Vendor ROM changes break whitelist guidance steps.
* **Future Evolution:** Automated diagnostic report generator.

---

### Feature 18: Configuration
* **Purpose:** Manage global system settings and environment variables.
* **Business Responsibility:** Expose compile-time flags and system variables.
* **Owned Entities:** None
* **Owned Services:** None
* **Owned Use Cases:** None
* **Owned Repositories:** None
* **External Dependencies:** None
* **Internal Components:** `ConfigManifest`
* **Public API:**
  ```dart
  class AppConfig {
    static const String dbName = "bankyar_secure.db";
    static const int maxLogEntries = 10000;
  }
  ```
* **Extension Points:** Conditional flags for staging or testing mode.
* **Risks:** Accidentally compiling with testing credentials or debug mode active.
* **Future Evolution:** Strict compile-time environments based on build tags.

---

### Feature 19: Theme
* **Purpose:** Unified look-and-feel of UI assets.
* **Business Responsibility:** Provide consistent colors, metrics, spacing, and typography boundaries.
* **Owned Entities:** None
* **Owned Services:** None
* **Owned Use Cases:** None
* **Owned Repositories:** None
* **External Dependencies:** Material UI frameworks
* **Internal Components:** `ColorTokens`, `TypographyTokens`, `DarkThemeConfiguration`
* **Public API:**
  ```dart
  class DesignSystemTheme {
    static ThemeData get darkTheme => ...;
    static ThemeData get lightTheme => ...;
  }
  ```
* **Extension Points:** Dynamic custom accent colors.
* **Risks:** Hardcoded color values bypassing theme settings in new screens.
* **Future Evolution:** Contrast settings to support accessibility requirements.

---

### Feature 20: Localization
* **Purpose:** Decoupled multi-language handling.
* **Business Responsibility:** Translate strings locally without contacting remote translate APIs.
* **Owned Entities:** None
* **Owned Services:** `StaticLanguageService`
* **Owned Use Cases:** None
* **Owned Repositories:** None
* **External Dependencies:** Static JSON asset collections
* **Internal Components:** `LocalAssetsDictionary`
* **Public API:**
  ```dart
  class LocalizationManager {
    String translate(String key, {List<String>? args});
  }
  ```
* **Extension Points:** Dynamic localization file updates via backup restore packages.
* **Risks:** Missing translation keys causing fallback failures.
* **Future Evolution:** Complete integration with platform native translation loaders.

---

### Feature 21: Database
* **Purpose:** Hardened local relational storage.
* **Business Responsibility:** Connect safely using SQLCipher AES-256 and isolate thread transactions.
* **Owned Entities:** None
* **Owned Services:** `DatabaseConnectionPool`
* **Owned Use Cases:** None
* **Owned Repositories:** None
* **External Dependencies:** SQLCipher, `sqflite` (SQLite Dart bindings)
* **Internal Components:** `DatabaseOpenHelper`, `MigrationScriptRunner`, `WAlJournalManager`
* **Public API:**
  ```dart
  abstract class DatabaseConnectionPool {
    Future<DatabaseExecutor> get writableDatabase;
    Future<void> initialize(List<int> keyBytes);
    Future<void> runInTransaction(Future<void> Function(DatabaseExecutor tx) action);
  }
  ```
* **Extension Points:** Custom migration runners.
* **Risks:** Disk full, database corruption, or master key mismatches.
* **Future Evolution:** Database defragmentation sequences to optimize file footprint.

---

## 6. Detailed Dependency Rules & Access Boundaries

To maintain high architectural separation and prevent code spaghetti, BankYar enforces strict modular boundaries.

```
       +───────────────────────────────────────────────────────────+
       │                      Allowed Imports                      │
       +───────────────────────────────────────────────────────────+
       │                                                           │
       │  [ core_common ]                                          │
       │         ▲                                                 │
       │         │ Imported by                                     │
       │         │                                                 │
       │  [ sms_detection (Domain) ]                               │
       │         ▲                                                 │
       │         │ Dispatches Domain Event                         │
       │         │                                                 │
       │  [ transactions (Domain) ]                                │
       │         ▲                                                 │
       │         │ Injected / Read via Providers                   │
       │         │                                                 │
       │  [ analytics (Presentation) ]                             │
       │                                                           │
       +───────────────────────────────────────────────────────────+
```

```
       +───────────────────────────────────────────────────────────+
       │                     Forbidden Imports                     │
       +───────────────────────────────────────────────────────────+
       │                                                           │
       │  [ sms_detection (Presentation) ]                         │
       │         X   CANNOT IMPORT                                 │
       │  [ transactions (Presentation) ]                          │
       │                                                           │
       │  [ analytics (Data) ]                                     │
       │         X   CANNOT IMPORT                                 │
       │  [ transactions (Data) ]                                  │
       │                                                           │
       │  [ Domain Layer (Any Feature) ]                           │
       │         X   CANNOT IMPORT                                 │
       │  [ core_database (Direct Driver APIs) ]                   │
       │                                                           │
       +───────────────────────────────────────────────────────────+
```

### 6.1 Allowed Dependencies
* **Inward Layer Flow:** Inside any feature, the dependency flow must match:
  $$\text{Presentation} \longrightarrow \text{Domain} \longleftarrow \text{Data}$$
* **Shared Core Reference:** Any Feature is allowed to import abstractions and utilities declared inside `lib/core/`.
* **Domain Events Decoupling:** Cross-feature interactions are allowed strictly via **immutable domain events** mediated by Riverpod listeners.

### 6.2 Forbidden Dependencies
* **No Direct Cross-Feature Data/Presentation Imports:** `analytics` presentation layer must *never* import widgets or views from `transactions` presentation layer.
* **No Repository Implementation Leaks:** Presentation widgets must never interact with concrete data layer classes (e.g., `TransactionRepositoryImpl`). They must reference abstract domain interfaces.
* **No SQLCipher Leakage:** Domain models must contain zero framework references. No entity files can import SQLite packages.

---

## 7. Inter-Module Communication Architecture

Modules are isolated, meaning direct synchronous procedure calls across boundaries are heavily restricted. Communication utilizes one of three approved architectural patterns:

### 7.1 Pattern A: Reactive Domain Event Dispatching (Asynchronous Decoupling)
When a feature completes a state transaction, it fires a Domain Event. Other features subscribe to this stream via Riverpod providers.

```
+───────────────────────+                         +────────────────────────+
| sms_detection Feature |                         |  transactions Feature  |
+───────────┬───────────+                         +───────────┬────────────+
            │                                                 │
            │ 1. Parses SMS                                   │
            │ 2. Publishes TransactionParsed                  │
            ├────────────────────────────────────────────────>│
            │                                                 │ 3. Captures event
            │                                                 │ 4. Applies auto-rules
            │                                                 │ 5. Writes ledger DB
```

### 7.2 Pattern B: Abstract Repository Interface Queries
If Feature A requires dataset parameters from Feature B, Feature A accesses the *abstract interface* defined in Feature B's domain directory, injected via Riverpod.

```
+─────────────────────+                           +────────────────────────+
|  analytics Feature  |                           |  transactions Feature  |
+──────────┬──────────+                           +───────────┬────────────+
           │                                                  │
           │ 1. Requests transaction data stream              │
           ├─────────────────────────────────────────────────>│
           │ (Queries abstract TransactionRepository interface)│
           │                                                  │ 2. Exposes stream
           │<─────────────────────────────────────────────────┤
```

### 7.3 Pattern C: Shared Kernel Mediated Transfers
For global infrastructure features (e.g., locking the UI when database key is evicted), the status is tracked inside `core_security`, and features query or listen to this central provider.

---

## 8. Shared Kernel Design

The **Shared Kernel** contains modules that are universally shared, generic, and hold zero knowledge of specific business features. It resides in `lib/core/` and is partitioned into:

```
lib/core/
├── common/
│   ├── errors/                 # Standardized Failure and Exception abstractions
│   ├── utils/                  # Safe mathematical, list, and string utilities
│   └── value_objects/          # Immutable standard types (MonetaryAmount, etc.)
│
├── database/
│   ├── database_pool.dart      # Thread-isolated SQLite executor contracts
│   └── base_dao.dart           # Standard relational CRUD helpers
│
├── security/
│   ├── keystore_interface.dart # Hardware storage adapters
│   └── key_eviction_timer.dart # Countdown timer tracking RAM clear operations
│
└── ui/
    ├── design_system/          # Core color tokens, typography parameters, and metrics
    └── widgets/                # Common loading indicators, lock screens, and error models
```

### Shared Kernel Constraints:
1. **Zero Feature Imports:** No file in `lib/core/` can import anything from `lib/features/`.
2. **Standard Interfaces Only:** Infrastructure items (e.g., database handles) are injected or retrieved through abstract interfaces, never concrete adapters.

---

## 9. Cross-Cutting Concerns Matrix

Cross-cutting concerns are capabilities that span multiple features.

| Concern | Core Abstraction | Shared Implementation | Application Hook |
| :--- | :--- | :--- | :--- |
| **Security** | `LocalAuthFacade` | `core_security` using hardware biometric API | Evaluated during launch and background-to-foreground transitions. |
| **Encryption** | `CipherFacade` | SQLCipher AES-256 (At-Rest), AES-GCM (Backups) | Automatically applied at database-page boundaries and file exports. |
| **Logging** | `LoggerFacade` | `core_logging` (PII Scrubbed + Rotator) | Trapped inside exception catch-blocks and parser error routines. |
| **Permissions**| `PermissionFacade` | `core_permissions` using OS wrappers | Triggered during feature onboarding or dynamic SMS capture restarts. |
| **Theme** | `ThemeContainer` | `core_ui/design_system` tokens | Renders declarative Flutter widgets uniformly. |
| **Error Handling**| `FailureTranslator`| `core_common/errors` abstractions | Converts platform Exceptions to clean UI Failure notifications. |

---

## 10. Feature Lifecycles & Initialization Ordering

Because BankYar contains tight inter-dependencies during startup (such as accessing secure storage to unlock database files), the bootstrap sequence must follow a strict, linear order.

```
[ App Launch Trigger ]
         │
         ▼
 1. Initialize Settings (Load offline theme & language preferences)
         │
         ▼
 2. Verify Secure Auth status (PIN/Biometrics registered)
         │
         ▼
 3. Present Lock Screen (Awaiting PIN or Biometrics match)
         │
         ▼
 4. Unlock Database (Extract key from KeyStore -> Pass to SQLCipher connection helper)
         │
         ▼
 5. Spawn Background Workers (Start Android WorkManager SMS interception queues)
         │
         ▼
 6. Render Dashboard (Launch transaction stream listeners)
```

### Initialization Dependency Hierarchy:
- **Phase 1: Hardware & Settings Boot:** `core_security` and `core_common` initialize basic files, reading user preferences.
- **Phase 2: Authentication Lock:** `secure_auth` holds the UI, blocking any access to underlying services.
- **Phase 3: Database & Ledger Boot:** Once authentication is verified, the decrypted key is passed to `core_database` to open database pages.
- **Phase 4: Ingestion Boot:** `sms_detection` starts background listeners once database operations are verified.

---

## 11. Feature Expansion & Extensibility Strategy

The feature-first design makes extending the app straightforward. When introducing a new feature (e.g., "P2P local sync" or "Budgeting Targets"):

1. **Create the Feature Folder:** Add the target folder structure inside `lib/features/budgeting/`.
2. **Define the Domain Core First:** Code entities, value objects, use-cases, and abstract repository contracts. Ensure **zero imports** of external packages.
3. **Implement Data Adapters:** Write the repository implementations inside `data/` implementing the domain contracts. Hook to `core_database` for storage operations.
4. **Build Presentation Layer:** Create state notifier providers using Riverpod and design widgets following design system guidelines.
5. **Connect via Providers:** Register the newly designed Use Cases and repositories into Riverpod providers, allowing other features to access or listen to the new flows.

---

## 12. Feature Dependency Matrix

This matrix maps allowed compile-time package dependencies between vertical modules. A value of **"Allowed"** indicates direct dependency is permitted; **"Forbidden"** indicates imports are strictly blocked; **"Event-Driven Only"** dictates asynchronous communication through decoupled streams.

| Target $\rightarrow$ <br> Source $\downarrow$ | `secure_auth` | `sms_detection` | `transactions` | `analytics` | `backup_restore` | `core` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **`secure_auth`** | — | Forbidden | Forbidden | Forbidden | Forbidden | **Allowed** |
| **`sms_detection`** | Forbidden | — | **Event-Driven** | Forbidden | Forbidden | **Allowed** |
| **`transactions`** | Forbidden | Forbidden | — | Forbidden | Forbidden | **Allowed** |
| **`analytics`** | Forbidden | Forbidden | **Allowed (Domain)** | — | Forbidden | **Allowed** |
| **`backup_restore`**| Forbidden | Forbidden | **Allowed (Domain)** | Forbidden | — | **Allowed** |
| **`core`** | Forbidden | Forbidden | Forbidden | Forbidden | Forbidden | — |

---

## 13. Module Isolation & Package Extraction Strategy

To prepare BankYar for future extraction into separate packages (such as moving the parsing engine to a reusable library), we enforce strict decoupling:

1. **No Circular References:** Compile-time circular dependencies between directories are blocked.
2. **Encapsulated Data Transfer Objects (DTOs):** All models used in the Data layer (e.g., database entities, SMS models) are fully contained within their respective features.
3. **Platform Channel Isolation:** Native MethodChannel drivers reside inside their feature wrappers. Flutter files communicate solely through abstract Dart interfaces.
4. **Interface Segregation:** No features can access platform configurations or database connection tools directly. They must access them through interfaces defined in `core`.

---

## 14. Future Plugin Strategy

To support dynamic parsing rules and third-party bank extensions offline:

1. **Abstract Plugin Contract:** Define a stable, platform-independent interface for parsing extensions:
   ```dart
   abstract class BankParserPlugin {
     String get targetBankId;
     ParserResult parseText(String text);
   }
   ```
2. **Sandboxed Evaluation:** Dynamic template files (JSON/text maps) are parsed locally.
3. **Decoupled Verification:** Dynamic plugins do not require application code recompilation. They are loaded at runtime through localized asset caches.

---

## 15. Feature Versioning Strategy

Since BankYar operates completely offline, module versioning manages schema changes during updates:

1. **Feature Major/Minor Versioning:** Every vertical feature defines a version string inside its documentation (e.g., `sms_detection: v1.0.0`).
2. **Migration Manifest:** The database DAO maintains a version lookup table.
3. **Incremental DB Upgrades:** When updates change schema layouts, localized SQLCipher scripts run sequentially:
   ```dart
   final migrations = {
     1: "ALTER TABLE transactions ADD COLUMN confidence_score REAL",
     2: "CREATE TABLE parser_templates ...",
   };
   ```

---

## 16. AI Implementation & Co-Pilot Strategy

To optimize BankYar for AI-assisted coding models, we implement a highly descriptive structural strategy:

1. **Highly Cohesive Files:** Feature vertical structures allow AI models to analyze files in isolation without context bloat.
2. **Strict File Naming Conventions:**
   - Entities: `*_entity.dart`
   - Use Cases: `*_usecase.dart`
   - ViewModels/Notifiers: `*_notifier.dart`
   - Data Sources: `*_source.dart`
3. **Explicit Type Signatures:** All methods must have defined types, avoiding ambiguous dynamic outputs. This allows AI models to parse API contracts with high accuracy.
4. **Detailed Code Documentation:** Standard Docstrings are used to describe classes, making it straightforward for LLMs to generate valid code.

---

## 17. Architecture Validation Matrix

The following table serves as an architectural gatekeeper checklist for developers and AI engines before submitting code modifications.

| Validation ID | Architectural Constraint | Verification Command / Target | Success Condition |
| :--- | :--- | :--- | :--- |
| **VAL-01** | Zero External Network Footprint | Inspection of `AndroidManifest.xml` & `Info.plist` | `android.permission.INTERNET` is **completely absent**. |
| **VAL-02** | Complete Layer Separation | Checking `lib/features/*/domain/` import statements | Exactly **zero references** to `Material`, `Riverpod`, `sqflite`, or `data` directories. |
| **VAL-03** | No Hardcoded Cryptographic Keys | Code audit on secure credentials and salts | Keys are fetched exclusively from hardware-bound storages. |
| **VAL-04** | PII Leakage Protection | Diagnostic logs inspection | Plaintext amounts and SMS bodies are **completely scrubbed** from local logs. |
| **VAL-05** | Relational Data Integrity | Execution of Category and Note deletions | Associated transaction links are safely nullified/updated; no orphans occur. |
| **VAL-06** | Asynchronous Thread Execution | Performance tracing during ingestion runs | SMS parsing and DB writes execute off the main thread, keeping rendering frame rates at **60fps+**. |

---
**End of Feature Architecture and Module Boundaries Specification**
