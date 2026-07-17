# BankYar State Management Architecture Specification

**Project Name:** BankYar
**Classification:** Enterprise Architecture Specification (State Management & Data Flow)
**Document Version:** 1.0.0
**Authors:** Principal Flutter Architect, Enterprise State Management Expert & Clean Architecture Specialist
**Status:** Approved / Production-Ready Baseline

---

## Executive Summary

BankYar is an offline-first, highly secure mobile application for intelligent banking SMS capture, cryptographic storage, and offline finance analytics. Operating with a strict **zero-network constraint** (no internet permission declared), BankYar relies entirely on on-device computations.

To deliver a reactive, predictable, highly testable, and modular user interface, this document establishes the complete **State Management Architecture** for BankYar. Powered by **Riverpod** as both the State Preservation engine and the Dependency Injection (DI) framework, this design enforces a strict **Unidirectional Data Flow (UDF)**, solidifies module boundaries, and optimizes CPU/memory utilization on older mobile hardware.

This specification remains strictly at the **Architectural Level**. It contains zero Flutter UI code, zero Riverpod provider implementation code, and zero repositories implementation code, serving as a clean, definitive blueprint for AI-assisted and human-led engineering.

---

## Table of Contents
1. [State Management Philosophy](#1-state-management-philosophy)
2. [State Ownership Model](#2-state-ownership-model)
3. [Global State](#3-global-state)
4. [Feature State](#4-feature-state)
5. [Screen State](#5-screen-state)
6. [Widget State](#6-widget-state)
7. [Session State](#7-session-state)
8. [Settings State](#8-settings-state)
9. [Navigation State](#9-navigation-state)
10. [Permission State](#10-permission-state)
11. [Authentication State (Future)](#11-authentication-state-future)
12. [Notification State](#12-notification-state)
13. [Database State](#13-database-state)
14. [Search State](#14-search-state)
15. [Filter State](#15-filter-state)
16. [Statistics State](#16-statistics-state)
17. [Parser State](#17-parser-state)
18. [Synchronization State (Future)](#18-synchronization-state-future)
19. [Error State](#19-error-state)
20. [Loading State](#20-loading-state)
21. [Empty State](#21-empty-state)
22. [Offline State](#22-offline-state)
23. [Event Flow](#23-event-flow)
24. [Data Flow](#24-data-flow)
25. [Provider Hierarchy](#25-provider-hierarchy)
26. [Dependency Rules](#26-dependency-rules)
27. [State Lifecycle](#27-state-lifecycle)
28. [State Restoration Strategy](#28-state-restoration-strategy)
29. [Memory Management](#29-memory-management)
30. [Performance Guidelines](#30-performance-guidelines)
31. [Testing Strategy](#31-testing-strategy)
32. [Future Extension Strategy](#32-future-extension-strategy)
33. [Feature-by-Feature Detailed State Analysis](#33-feature-by-feature-detailed-state-analysis)
34. [Provider Design Specifications](#34-provider-design-specifications)
35. [Event Design Catalog](#35-event-design-catalog)
36. [State Rules & Integrity Policies](#36-state-rules--integrity-policies)
37. [Performance Engineering & Metrics](#37-performance-engineering--metrics)
38. [Architectural Decision Records (ADR)](#38-architectural-decision-records-adr)
39. [Architectural Trade-off Analysis](#39-architectural-trade-off-analysis)
40. [Best Practices & Code-Generation Alignment](#40-best-practices--code-generation-alignment)

---

## 1. State Management Philosophy

BankYar's state management architecture is guided by five core architectural tenets:

* **Strict Unidirectional Data Flow (UDF):** State flows downwards from providers to declarative UI widgets. Actions/Intents flow upwards from widgets to state notifiers, invoking domain Use Cases which modify local repositories. Under no circumstances can widgets mutate state directly.
* **Compile-Time Safety & Dependency Injection:** By utilizing Riverpod, dependency injection and state management are combined into a compile-time safe dependency graph. Dynamic service locator patterns (e.g., `GetIt`) are excluded to prevent runtime missing-dependency crashes.
* **Immutability of State Objects:** All state models (representing screens, data lists, configurations, or sessions) are strictly immutable. State updates are achieved exclusively by instantiating new states using copy-with mechanisms, preventing concurrent-access race conditions between main UI threads and background isolates.
* **Separation of Concerns (Clean Architecture Integration):** UI elements (Views) depend solely on ViewModels/Notifiers. Notifiers depend exclusively on abstract Domain Use Cases. Use Cases contain pure business rules and depend on abstract repository contracts. Concrete Data Sources (SQLCipher database, hardware secure preferences) reside on the outer data boundary.
* **Explicit Lifecycle and Disposal Controls:** Since mobile devices are resource-constrained and security-critical, state must not leak in memory. Security states, database decryption keys, and UI cache lists must enforce explicit, automated eviction and cleanup strategies.

```
       +──────────────────────────────────────────────────────────+
       │                    UNIDIRECTIONAL STATE FLOW             │
       +────────────────────────────┬─────────────────────────────+
                                    │
                                    ▼ Emits State (Immutable UI Model)
       +────────────────────────────┴─────────────────────────────+
       │                      Presentation Layer                  │
       │                      (Declarative UI Views)              │
       +────────────────────────────┬─────────────────────────────+
                                    │
                                    ▼ Dispatches Action (Intent / Command)
       +────────────────────────────┴─────────────────────────────+
       │                      State Provider Container            │
       │                      (Riverpod Notifier Class)           │
       +────────────────────────────┬─────────────────────────────+
                                    │
                                    ▼ Invokes Business Rule
       +────────────────────────────┴─────────────────────────────+
       │                       Domain Use Case                    │
       │                       (Pure Dart Business Logic)         │
       +────────────────────────────┬─────────────────────────────+
                                    │
                                    ▼ Persists / Fetches
       +────────────────────────────┴─────────────────────────────+
       │                    Concrete Repository Implementation    │
       │                    (Data Layer - SQLCipher / Secure Storage)│
       +──────────────────────────────────────────────────────────+
```

---

## 2. State Ownership Model

To prevent spaghetti logic and ensure feature isolation, state is partitioned based on scope, lifetime, and access boundaries:

```
+-----------------------------------------------------------------------------------------+
|                                    STATE OWNERSHIP SCOPES                               |
|                                                                                         |
|  +---------------------------+  +---------------------------+  +---------------------+  |
|  |       GLOBAL SCOPE        |  |       FEATURE SCOPE       |  |    SCREEN / WIDGET  |  |
|  |                           |  |                           |  |       SCOPE         |  |
|  | - SessionState            |  | - TransactionsList        |  | - ScrollPosition    |  |
|  | - SettingsState           |  | - AnalyticsReportState    |  | - DialogVisibility  |  |
|  | - PermissionState         |  | - BackupProgressState     |  | - FormValidationState|  |
|  | - AppLockState            |  | - ParserTemplateState     |  | - SearchBarQuery    |  |
|  +-------------┬-------------+  +-------------┬-------------+  +----------┬----------+  |
+────────────────┼──────────────────────────────┼───────────────────────────┼─────────────+
                 │                              │                           │
                 ▼                              ▼                           ▼
          Permanent Memory                Scoped Navigation               Short-Lived
          (Keeps active)                  (Keeps active on view)          (Cleared on pop)
```

| Scope | Lifetime | Primary Owner | Read / Write Access Boundary |
| :--- | :--- | :--- | :--- |
| **Global Scope** | Application process lifetime. | Core Application Container | Read by all features; modified exclusively through Core Security / System Notifiers. |
| **Feature Scope** | Variable (scoped to navigation stack or active background pipeline). | Feature Module ViewModels | Accessible only by UI elements inside the parent feature. Cross-feature data is exposed via read-only streams. |
| **Screen Scope** | Short-lived; bound to active Route presentation. | Screen Page State Notifier | Cleared immediately from memory (RAM) when the route is popped from the navigator. |
| **Widget Scope**| Short-lived; bound to widget rendering tree. | Declarative Widget Instance | Private to the specific widget (e.g., local expand toggles, immediate text fields). |

---

## 3. Global State

**Global State** tracks variables that affect the entire application ecosystem.

* **Core Components:**
  - `SessionState`: Tracking current user lock status and inactive periods.
  - `SettingsState`: Tracks user preferences (ThemeMode, Language, active configurations).
  - `PermissionState`: Tracks OS platform authorization statuses.
* **Inter-State Coordination:** Updates to Settings (e.g., changing PIN requirements) trigger immediate updates to the global Security state.
* **Storage Pattern:** Persisted inside device SecurePreferences or encrypted SQLCipher database pages.

---

## 4. Feature State

**Feature State** represents the domain and presentation state of a specific vertical module.

* **Decoupled Isolation:** Feature states are completely isolated from one another. For example, `analytics` cannot modify `transactions` state.
* **Integration Vector:** Feature states react to updates in other features by listening to domain event streams (e.g., `analytics_notifier` observes `transaction_repository_stream` via Riverpod's `ref.watch`).
* **Storage Pattern:** Encapsulated in specialized `AsyncNotifier` structures, pulling from and persisting to local SQLite database tables.

---

## 5. Screen State

**Screen State** handles the volatile presentation states of full-screen UI views.

* **Encapsulation:** Holds state for validation errors, active tab selections, text controller selections, and modal visibility states.
* **State Lifecycle:** Screen State is strictly transient. By implementing Riverpod's `.autoDispose` modifier, all screen-level states are completely cleared from volatile memory (RAM) the moment the user navigates away from the screen, preventing memory leaks.

---

## 6. Widget State

**Widget State** represents transient visual states local to specific UI controls (e.g., whether a custom category card is expanded, or whether a chart segment is highlighted).

* **Architecture Pattern:** Since this state has zero business significance, it is managed locally inside the widget tree using Flutter's lightweight UI state mechanisms, bypassing global Riverpod state graphs to prevent redundant rebuilds.

---

## 7. Session State

**Session State** manages user session lifecycles and cryptographic key access permissions.

```
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                  SESSION STATE MACHINE                                  |
|                                                                                         |
|       +───────────────+      Launch      +───────────────+   Authenticate  +─────────+  |
|       |  UNINITIALIZED|─────────────────►|    LOCKED     |────────────────►| ACTIVE  |  |
|       +───────────────+                  +───────▲───────+                 +────┬────+  |
|                                                  │                              │       |
|                                                  │ Inactivity Timeout           │       |
|                                                  │ (Exceeds 5 Minutes)          │       |
|                                                  +──────────────────────────────+       |
+─────────────────────────────────────────────────────────────────────────────────────────+
```

* **Core Attributes:**
  - `status`: Enum representing `UNINITIALIZED`, `LOCKED`, `ACTIVE`.
  - `unlockedAt`: Timestamp tracking successful login.
  - `lastInteractionTime`: Tracks active user taps to determine inactivity intervals.
* **Cryptographic Integration:** When `status` transitions to `LOCKED` or `UNINITIALIZED`, the master database encryption key bytes are immediately overwritten with zeros in RAM, and active SQLite connection pools are flushed and closed.

---

## 8. Settings State

**Settings State** manages offline-first configuration values and visual themes.

* **Attributes:**
  - `themeMode`: Enum representing `SYSTEM`, `LIGHT`, or `DARK` templates.
  - `appLocale`: String tracking target translation dictionary codes (e.g., "en", "fa").
  - `retentionPolicyDays`: Tracks automatic cleanup thresholds for raw cellular SMS records.
* **Reactivity Rule:** Modifying Settings triggers immediate rebuilds of localized design-system theme managers and layout engines.

---

## 9. Navigation State

**Navigation State** tracks the active application screen path and modal stack.

* **Architecture Pattern:** Standardizes navigation parameters through declarative, compile-time safe routing interfaces (e.g., GoRouter configurations).
* **State Bounds:** Navigating to secure features (e.g., Ledger view or Backup settings) requires a prior check against `SessionState.status`. If the state is `LOCKED`, navigation is aborted, redirecting the user to the Lock Screen view.

---

## 10. Permission State

**Permission State** tracks operating system authorization flags on-device.

* **States Monitored:**
  - `SMS_RECEIVE`: Background SMS interception permissions (Android only).
  - `BIOMETRICS`: System biometric sensor validation check.
  - `LOCAL_FILES`: Read/Write storage authorizations (required for CSV/backup file manipulation).
* **Graceful Degradation Hook:** If `SMS_RECEIVE` state transitions to `DENIED`, the dashboard reactively hides setup prompts, rendering prominent clipboard-paste manual buttons instead.

---

## 11. Authentication State (Future)

Although BankYar remains 100% offline-first in V1, the authentication state architecture is prepared to support future secure cloud synchronization features.

* **Future Alignment:**
  - Designed as a decoupled provider (`auth_state_provider`) managed via abstract interfaces.
  - In V1, it exposes a static `OfflineUser` mock.
  - In future phases, it will transition to managing hardware-bound OAuth tokens, OAuth2 flows, and dynamic local-cloud session keys, without requiring refactoring of transactions or parsing features.

---

## 12. Notification State

**Notification State** manages visual alerts triggered in the system tray when background processing completes.

* **Attributes:**
  - `lastTriggeredNotificationId`: Integer sequence key.
  - `activePayload`: Deep-link action targets (such as launching directly into the detail inspector of a newly parsed transaction).

---

## 13. Database State

**Database State** monitors the active lifecycle of the SQLCipher relational database.

* **Attributes:**
  - `connectionPoolStatus`: Enum representing `CLOSED`, `CONNECTING`, `OPEN`, `CORRUPTED`.
  - `schemaVersion`: Tracks active database structural iterations.
* **Disaster Recovery Trigger:** If the state transitions to `CORRUPTED`, all ledger stream listeners are paused, and the application displays the disaster recovery screen to guide users through fresh imports.

---

## 14. Search State

**Search State** manages full-text query parameters.

* **Attributes:**
  - `queryText`: Case-insensitive text query.
  - `searchScope`: Enum representing `MERCHANTS`, `NOTES`, `TAGS`, or `ALL_FIELDS`.
* **Performance Hook:** Standardizes search triggers by executing a 300ms debounce buffer on text input, preventing redundant database queries on every keystroke.

---

## 15. Filter State

**Filter State** manages structured parameters used to segment financial records.

* **Attributes:**
  - `dateRange`: Start and End DateTime parameters.
  - `categoryIds`: List of active category filter constraints.
  - `transactionType`: Enum filter (`DEBIT`, `CREDIT`, or `ALL`).
  - `bankNames`: List of target bank carrier groups.

---

## 16. Statistics State

**Statistics State** compiles cash flow statistics and spending trend allocations.

* **State Model:**
  - `monthlyCashFlow`: Calculated debit/credit ratio metrics.
  - `categoryAllocations`: Map containing category totals and percentages.
  - `behaviorTrends`: List of spending behavior messages (e.g., "Spent 10% less on Food this month").
* **Optimization Pattern:** Pulls computed figures from the pre-calculated `statistics_cache` database table to accelerate dashboard rendering.

---

## 17. Parser State

**Parser State** tracks active regular expressions and token matching metrics.

* **State Model:**
  - `activeRulesList`: List of compiled regular expressions mapped to bank carrier IDs.
  - `validationResult`: Diagnostic metrics verifying Regex safety against catastrophic backtracking.

---

## 18. Synchronization State (Future)

Prepared for future P2P synchronization over local Wi-Fi or secure cloud vaults.

* **Future Model:**
  - `syncStatus`: Enum representing `IDLE`, `SYNCING`, `COMPLETED`, `FAILED`.
  - `pendingUploadCount`: Tracks local transactions that have not yet been synchronized.
  - `conflictQueue`: Queue of transactions with conflicting timestamps.

---

## 19. Error State

**Error State** standardizes local exception tracking across modules.

* **Architecture Pattern:** Leverages Riverpod's `AsyncValue.error` pattern, ensuring that failures (e.g., `DatabaseException`, `ParserTemplateException`) are caught and mapped to domain-specific `Failure` entities before reaching the UI. This keeps technical details out of the presentation layer.

---

## 20. Loading State

**Loading State** manages the presentation of visual indicators during heavy background operations.

* **Architecture Pattern:** Screen Notifiers expose state as an `AsyncValue` union. The UI uses pattern-matching (`state.when`) to automatically display loading indicators when background tasks (such as CSV imports or backup exports) are running.

---

## 21. Empty State

**Empty State** governs the presentation of educational and fallback layouts when no data is returned.

* **Architecture Pattern:** If transaction streams return empty lists, the ledger view automatically renders a custom empty layout, showing onboarding tips (such as how to import a CSV statement or scan a rules QR code).

---

## 22. Offline State

As an offline-first app, this state manages device cellular statuses and diagnostic guidance.

* **Architecture Pattern:** Since the app lacks internet permission, "offline" is our system default, not an exception state. This state tracks cellular signal availability to help diagnose background SMS worker health.

---

## 23. Event Flow

Application state transitions are event-driven, triggered by native operating system broadcasts or direct user interactions.

```
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                    EVENT FLOW DIAGRAM                                   |
+─────────────────────────────────────────────────────────────────────────────────────────+

   OS Telephony Event (SMS_RECEIVED)
         │
         ▼ Native Intercept
   SmsCaptured (SmsRawPayload)
         │
         ▼ Ingest & Deduplicate
   SmsReceived (SmsId, Hash)
         │
         ▼ Match Regex Rules
   TransactionParsed (TransactionId, Extracted Metadata)
         │
         ▼ Run Categorization Rules
   TransactionStored (TransactionId)
         │
         ▼ Reactive Stream Emit
   LedgerStreamUpdated ──► [ UI Rebuilds Dashboard Components ]

+─────────────────────────────────────────────────────────────────────────────────────────+
```

---

## 24. Data Flow

This section outlines the detailed sequence from user action to physical persistence and layout refresh, illustrating the unidirectional loop:

### Sequence: Manual Transaction Entry

```
   User Actions (Clicks "Add Transaction" with Form Data)
         │
         ▼ Tap Submit
   Presentation Layer (ManualEntryScreen - captures form input values)
         │
         ▼ Calls Command Method
   State Provider (LedgerStateNotifier - extracts input and prepares entity)
         │
         ▼ Calls UseCase
   Use Case (AddManualTransactionUseCase - validates domain rules & invariants)
         │
         ▼ Invokes Save
   Repository (TransactionRepositoryImpl - converts Entity to relational DTO)
         │
         ▼ Executes Transaction Write
   Local Database (SQLCipher - performs AES-256 encrypted write to disk pages)
         │
         ▼ Return Success / Update Stream
   Repository (TransactionRepositoryImpl - emits new transaction list via Stream)
         │
         ▼ Detects Change
   State Provider (LedgerStateNotifier - updates state with the new list)
         │
         ▼ Emits State
   UI Refresh (LedgerScreen - reactively rebuilds the list views at 60fps+)
```

---

## 25. Provider Container Hierarchy

The application's dependency and state graph is designed as a clean, hierarchical structure:

```
+─────────────────────────────────────────────────────────────────────────────────────────+
|                               GLOBAL INFRASTRUCTURE PROVIDERS                           |
|                                                                                         |
|   +───────────────────────────────+           +─────────────────────────────────────+   |
|   | secureStorageProvider         |           | databaseConnectionProvider          |   |
|   | (Platform SecurePreferences)  |           | (Isolates thread SQLCipher DB Pool) |   |
|   +───────────────┬───────────────+           +──────────────────┬──────────────────+   |
+───────────────────┼──────────────────────────────────────────────┼──────────────────────+
                    │                                              │
                    │ Inject                                       │ Inject
                    v                                              v
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                 CORE SERVICES / REPOSITORIES                            |
|                                                                                         |
|   +───────────────────────────────────+       +─────────────────────────────────────+   |
|   | transactionRepositoryProvider     |       | securityConfigRepositoryProvider    |   |
|   | (Abstract Interface contract)     |       | (System AppLock & PIN configs)      |   |
|   +───────────────┬───────────────────+       +──────────────────┬──────────────────+   |
+───────────────────┼──────────────────────────────────────────────┼──────────────────────+
                    │                                              │
                    │ Inject                                       │ Inject
                    v                                              v
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                      DOMAIN USE CASES                                   |
|                                                                                         |
|   +───────────────────────────────────+       +─────────────────────────────────────+   |
|   | getTransactionsUseCaseProvider    |       | authenticateUserUseCaseProvider     |   |
|   | (Fetches stream of ledger data)   |       | (Validates user access credentials) |   |
|   +───────────────┬───────────────────+       +──────────────────┬──────────────────+   |
+───────────────────┼──────────────────────────────────────────────┼──────────────────────+
                    │                                              │
                    │ Watches                                      │ Watches / Reads
                    v                                              v
+─────────────────────────────────────────────────────────────────────────────────────────+
|                                    PRESENTATION VIEW MODELS                             |
|                                                                                         |
|   +───────────────────────────────────+       +─────────────────────────────────────+   |
|   | ledgerNotifierProvider            |       | secureAuthNotifierProvider          |   |
|   | (AsyncNotifier ledger state)      |       | (Notifier app authentication state) |   |
|   +───────────────────────────────────+       +─────────────────────────────────────+   |
+─────────────────────────────────────────────────────────────────────────────────────────+
```

---

## 26. Dependency Rules

To prevent circular dependencies and maintain modular feature boundaries, the following import and dependency rules are strictly enforced:

* **Inward Layer Decoupling:** Presentation components can only depend on Domain and Shared Core layers. The Domain layer is pure Dart and must contain zero references to external frameworks, libraries (such as Riverpod or sqflite), or the Presentation layer.
* **Feature Isolation Rules:** Features are self-contained. Files inside `features/analytics` are strictly prohibited from importing any files from `features/transactions/presentation` or `features/transactions/data`.
* **State Mutation Isolation:** Features can read state from other features via read-only providers, but are strictly prohibited from mutating another feature's state. All mutations must be handled by dispatching commands to that feature's specific public notifier.

---

## 27. State Lifecycle

The state lifecycle is designed to protect sensitive financial data and optimize device memory usage:

```
[ App Launch / Process Spawns ]
              │
              ▼ Reads Settings & App Lock Preference
   Session State = UNINITIALIZED (Keystore connection closed)
              │
              ▼ Present Lock UI Screen
   Session State = LOCKED (Database locked; RAM key evicted)
              │
              ▼ Successful Biometric or PIN Authentication
   Session State = ACTIVE (Database connection opened; Key cached in RAM)
              │
              ├──────────────────────────────────────────┐
              ▼ User locks app or closes view            ▼ User background timeout (> 5 mins)
   Session State = LOCKED                                Session State = LOCKED
   - Close SQLite Connection Pools                       - Close SQLite Connection Pools
   - Overwrite RAM Key byte array with zeros             - Overwrite RAM Key byte array with zeros
```

---

## 28. State Restoration Strategy

Operating 100% offline means that if the application process is terminated in the background by the operating system, the user's active session state must restore gracefully:

* **Secured Non-Volatile Restoration:** Non-sensitive visual settings (e.g., active tab selection or dark mode settings) are persisted in SecurePreferences and restored automatically on boot.
* **Zero Database Key Persistence:** To prevent security compromises, the database encryption key is never saved on non-volatile storage. If the app process is terminated, the user must re-authenticate with biometrics or PIN to unlock the database and restore the ledger view.

---

## 29. Memory Management

To prevent memory leaks and protect sensitive data in RAM:

* **Auto-Disposal of Unused Providers:** Providers representing specific screens or forms must utilize Riverpod's `.autoDispose` modifier, ensuring they are completely cleared from volatile memory when the user navigates away from the screen.
* **String Cache Eviction:** Parsed transaction strings, custom notes, and search queries are stored as temporary byte arrays, which are zeroized immediately after rendering, preventing sensitive values from remaining in system memory.

---

## 30. Performance Guidelines

To maintain standard 60fps+ rendering performance on older mobile hardware:

* **Fine-Grained Rebuild Filters:** Presentation widgets must use Riverpod's `select` modifier to listen only to the specific attributes they render (e.g., `ref.watch(settingsProvider.select((s) => s.themeMode)`), avoiding unnecessary widget rebuilds when other settings attributes change.
* **Compute Offloading (Dart Isolates):** Heavy computations, such as bulk CSV statement imports or generating complex financial reports, are processed off the main thread using separate Dart Isolates, keeping the main UI thread unblocked.

---

## 31. Testing Strategy

The state management and data flow layer are verified using automated test suites running in isolated environments:

```
   [ Unit Tests ] ────────► Pure Dart Use Cases & State Notifiers (Using mocked repositories)
   [ Integration Tests ] ──► Complete State Container Flows (Using in-memory SQLCipher database)
```

* **Unit Testing ViewModels:** Tests are written to verify that notifiers correctly invoke domain use cases and transition states appropriately in response to user actions.
* **Mocking Dependencies:** Because Riverpod allows overriding providers dynamically, test suites can override repositories with mock implementations without requiring complex setup.

---

## 32. Future Extension Strategy

The state architecture is designed to support future capabilities without requiring a redesign of core components:

* **Notification Interception:** The parsing state models are abstracted to process generic text streams, preparing the system to support push notifications from digital banking apps in future phases.
* **P2P Local Syncing:** The sync state models are defined using platform-independent schemas, preparing the system to support peer-to-peer database synchronization over secure local Wi-Fi networks in future releases.

---

## 33. Feature-by-Feature Detailed State Analysis

### 1. `secure_auth` Feature
* **State Owner:** `SecureAuthNotifier`
* **Provider Type:** `StateNotifierProvider<SecureAuthNotifier, SecureAuthState>`
* **Dependencies:** `VerifyPinUseCase`, `LocalAuthenticationService`, `MemoryKeyEvictionService`
* **Events:** `ApplicationStarted`, `ApplicationResumed`, `ApplicationPaused`, `PinEntered`, `BiometricAuthTriggered`
* **Commands:** `UnlockDatabaseCommand`, `LockDatabaseCommand`, `LockoutUserCommand`
* **Read Models:** `SecureAuthState` (Lock status, lockout duration, failed attempts count).
* **Write Models:** `PinInputModel` (for PIN changes).
* **Cache Strategy:** Unlocked connection states are cached in volatile RAM only. Lockout timers are persisted in SecurePreferences.
* **Refresh Strategy:** Triggered automatically on application lifecycle resume events.
* **Lifecycle:** Active during application process lifetime.
* **Disposal Strategy:** Never disposed; runs continuously to monitor inactive intervals.
* **Error Recovery:** Excess failed attempts trigger input lockouts. If biometrics fail, the system falls back to PIN entry.
* **Future Evolution:** Integrate duress PIN support to trigger self-destruct sequences on threats.

---

### 2. `sms_detection` Feature
* **State Owner:** `SmsParserNotifier`
* **Provider Type:** `AsyncNotifierProvider<SmsParserNotifier, ParserState>`
* **Dependencies:** `ProcessSmsUseCase`, `SmsParserRepository`, `DeduplicationService`
* **Events:** `SMSReceived`, `SmsProcessingStarted`, `SmsProcessingCompleted`, `SmsProcessingFailed`
* **Commands:** `TriggerTextParsingCommand`, `UpdateParserTemplatesCommand`
* **Read Models:** `ActiveTemplatesList`, `IngestedSmsStatus`.
* **Write Models:** `ParserTemplateDto` (for custom rules modifications).
* **Cache Strategy:** Parsed rules are cached in memory for sub-100ms regex evaluations.
* **Refresh Strategy:** Re-evaluates rules when a user scans a custom QR configuration.
* **Lifecycle:** Scoped to background SMS interception worker lifecycles.
* **Disposal Strategy:** Automatically disposed when background parsing tasks complete.
* **Error Recovery:** Unmatched formats are written to raw database tables as unparsed transactions, letting users manually enrich them.
* **Future Evolution:** Implement local Naive Bayes classifiers to learn custom SMS patterns over time.

---

### 3. `transactions` Feature
* **State Owner:** `LedgerNotifier`
* **Provider Type:** `StreamNotifierProvider<LedgerNotifier, List<Transaction>>`
* **Dependencies:** `GetTransactionsStreamUseCase`, `SaveTransactionUseCase`, `DeleteTransactionUseCase`
* **Events:** `TransactionCreated`, `TransactionUpdated`, `TransactionDeleted`, `CategoryAssigned`, `NoteUpdated`
* **Commands:** `AddTransactionCommand`, `UpdateTransactionCommand`, `DeleteTransactionCommand`, `AssignCategoryCommand`
* **Read Models:** `TransactionLedgerView` (Chronological paginated list of transactions).
* **Write Models:** `TransactionDto`, `NoteDto`.
* **Cache Strategy:** Uses write-ahead logging (WAL) database states to keep query responses fast.
* **Refresh Strategy:** Reactive streams automatically update UI views when database changes occur.
* **Lifecycle:** Scoped to ledger screen navigation views.
* **Disposal Strategy:** Auto-disposes when the user navigates away from the ledger screen.
* **Error Recovery:** Transaction write failures are caught, and the UI displays a warning message to prevent data loss.
* **Future Evolution:** Support for independent ledger divisions (e.g., separating personal and business transactions).

---

### 4. `analytics` Feature
* **State Owner:** `AnalyticsNotifier`
* **Provider Type:** `AsyncNotifierProvider<AnalyticsNotifier, AnalyticsReportState>`
* **Dependencies:** `GenerateCashFlowReportUseCase`, `CalculateCategoryAllocationsUseCase`
* **Events:** `StatisticsUpdated`, `DateRangeChanged`, `CategoryFilterToggled`
* **Commands:** `RecalculateAnalyticsCommand`
* **Read Models:** `CashFlowReport`, `CategoryAllocationPieChart`.
* **Write Models:** None (Read-only analytical representations).
* **Cache Strategy:** Pre-calculated reports are cached in the `statistics_cache` database table to accelerate dashboard boot.
* **Refresh Strategy:** Automatically invalidates and recalculates reports when a new transaction is saved.
* **Lifecycle:** Scoped to the analytics screen navigation view.
* **Disposal Strategy:** Auto-disposes when the user exits the analytics view.
* **Error Recovery:** Catches precision errors and falls back to safe mathematical representations.
* **Future Evolution:** Implement local spending forecasts using simple linear regression models.

---

### 5. `backup_restore` Feature
* **State Owner:** `BackupNotifier`
* **Provider Type:** `StateNotifierProvider<BackupNotifier, BackupState>`
* **Dependencies:** `ExportEncryptedBackupUseCase`, `ImportEncryptedBackupUseCase`
* **Events:** `BackupStarted`, `BackupCompleted`, `BackupFailed`, `RestoreStarted`, `RestoreCompleted`, `RestoreFailed`
* **Commands:** `TriggerBackupCommand`, `TriggerRestoreCommand`
* **Read Models:** `BackupMetadataView` (File path, size, schema compatibility, and salt).
* **Write Models:** `PasswordInputModel` (User password input).
* **Cache Strategy:** Backup files are written directly to local sandboxed directories, leaving no plaintexts in temporary directories.
* **Refresh Strategy:** Manual trigger by the user.
* **Lifecycle:** Short-lived; active only during backup and recovery operations.
* **Disposal Strategy:** Disposed immediately when export/import operations complete.
* **Error Recovery:** Decryption password errors abort the process, zeroizing temporary decryption keys in RAM.
* **Future Evolution:** Support P2P synchronization over local Wi-Fi with personal storage systems.

---

## 34. Provider Design Specifications

### 1. `secureStorageProvider`
* **Purpose:** Provides a secure wrapper to access platform-specific secure preferences.
* **Responsibilities:** Reads and writes non-sensitive app configurations (e.g., whether the app lock is active) using hardware-backed encryption.
* **Input:** Configuration keys and string values.
* **Output:** Decrypted preferences.
* **Lifetime:** Permanent; alive for the application process lifecycle.
* **Dependencies:** `flutter_secure_storage` package interface.
* **Rebuild Conditions:** Never rebuilds.
* **Shared Scope:** Global.
* **Testing Strategy:** Overridden with a mock implementation in test suites.

---

### 2. `databaseConnectionProvider`
* **Purpose:** Manages active SQLCipher database connection pools.
* **Responsibilities:** Opens, secures, and closes database connections; executes relational updates.
* **Input:** Decrypted master key bytes.
* **Output:** SQLCipher Database Connection instance.
* **Lifetime:** Scoped; remains active only while `SessionState` is `ACTIVE`.
* **Dependencies:** `secureStorageProvider`.
* **Rebuild Conditions:** Rebuilds when the master database key is evicted or updated.
* **Shared Scope:** Global.
* **Testing Strategy:** Overridden with an in-memory database implementation.

---

### 3. `transactionRepositoryProvider`
* **Purpose:** Exposes the transaction repository contract to domain components.
* **Responsibilities:** Maps abstract database models to pure domain entities; exposes reactive transaction streams.
* **Input:** Database connection handles.
* **Output:** Abstract repository contract interface.
* **Lifetime:** Permanent.
* **Dependencies:** `databaseConnectionProvider`.
* **Rebuild Conditions:** Rebuilds if the database connection state changes.
* **Shared Scope:** Global.
* **Testing Strategy:** Overridden with mock repositories in unit tests.

---

### 4. `ledgerNotifierProvider`
* **Purpose:** Manages the presentation state of the transaction ledger dashboard.
* **Responsibilities:** Connects to transaction streams, handles seek-pagination, and processes user search queries.
* **Input:** Search queries, active filters, and last-seen transaction anchors.
* **Output:** `AsyncValue` list of transactions.
* **Lifetime:** Scoped; active only when the user is on the ledger dashboard.
* **Dependencies:** `transactionRepositoryProvider`.
* **Rebuild Conditions:** Rebuilds when search parameters or active filters change.
* **Shared Scope:** Presentation.
* **Testing Strategy:** Verified by testing state outputs against simulated database updates.

---

## 35. Event Design Catalog

This section documents BankYar's core event catalog, detailing triggers and payloads:

| Event Identifier | Triggering Source | Payload Attributes | State Transition Effect |
| :--- | :--- | :--- | :--- |
| **`ApplicationStarted`**| OS Launch Trigger | None | Sets session state to `UNINITIALIZED`, loading visual themes and presenting the secure Lock Screen. |
| **`ApplicationResumed`**| OS Lifecycle Hook | None | Starts background diagnostics and checks session timeouts; locks app if background inactive exceeds 5 mins. |
| **`ApplicationPaused`** | OS Lifecycle Hook | None | Starts the 5-minute background inactivity countdown; blurs task switcher previews. |
| **`SMSReceived`** | OS Broadcast API | `rawText`, `senderId`, `receivedAt` | Computes deduplication hash; drops duplicates; routes text to parser. |
| **`ParserCompleted`** | Parser Engine | `TransactionId`, `Metadata` | Creates transaction record; runs auto-rules; saves entry. |
| **`ParserFailed`** | Parser Engine | `SmsId`, `rawText` | Logs warning; creates an unparsed transaction record for manual enrichment. |
| **`DatabaseUpdated`** | Database Trigger | `tableName`, `action` | Refreshes active UI transaction streams; invalidates analytics view caches. |
| **`NoteCreated`** | User Input | `TransactionId`, `noteText` | Commits note to the transaction; updates FTS5 search index. |
| **`NoteUpdated`** | User Input | `TransactionId`, `noteText` | Modifies note; updates FTS5 search index. |
| **`SearchChanged`** | User Input | `queryText` | Applies a 300ms debounce filter, updating search results. |
| **`FilterChanged`** | User Input | `FilterParameters` | Triggers seek-pagination, updating ledger lists. |
| **`ThemeChanged`** | User Input | `ThemeMode` | Updates design system tokens, rebuilding visual layouts. |
| **`BackupCompleted`** | Backup Service | `filePath`, `timestamp` | Generates success notification, clear temporary backup cache directories. |
| **`BackupFailed`** | Backup Service | `errorDetails` | Logs failure in diagnostics, alerts user of export failure. |
| **`PermissionGranted`**| OS Callback | `PermissionType` | Updates permission state, starting background listeners. |
| **`PermissionDenied`** | OS Callback | `PermissionType` | Updates permission state, displaying fallback clipboard guides. |

---

## 36. State Rules & Integrity Policies

### Single Source of Truth (SSOT)
All financial details are stored in the SQLCipher database. ViewModels are prohibited from caching duplicates of data; they must listen directly to database streams to ensure the UI remains in sync with the database.

### Immutability of State
State objects are strictly immutable, matching the following architecture pattern:
```dart
// Pure Dart representation of State Immutability:
class LedgerState {
  final List<Transaction> items;
  final bool isLoading;
  final String? errorMessage;

  LedgerState({required this.items, this.isLoading = false, this.errorMessage});

  LedgerState copyWith({List<Transaction>? items, bool? isLoading, String? errorMessage}) {
    return LedgerState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
```

### Derived and Computed State
Computed visual metrics, such as monthly totals or category allocations, are derived dynamically from the active ledger stream using Riverpod's `select` modifier, preventing unnecessary database recalculations.

### Caching and Invalidation
* Pre-computed analytics are stored in the `statistics_cache` database table to keep dashboards responsive.
* When a write transaction commits to the database, the analytics cache is invalidated and recalculated in the background.

### Optimistic Updates
Because local relational database writes are fast (typically under 100ms), optimistic UI updates are not implemented, keeping state synchronization predictable and avoiding state-reversal bugs.

---

## 37. Performance Engineering & Metrics

### 1. Minimal Widget Rebuilds
To maintain high frame rates during fast scrolls, UI widgets utilize Riverpod's `select` modifier to observe only the specific parameters they render, avoiding rebuilding whole layout lists when other attributes change:
```dart
// Renders specific state parameter updates only:
final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
```

### 2. Constant-Time Keyset Seek Pagination
Traditional offset-based pagination slows down as offsets increase ($O(N)$ complexity). To ensure sub-200ms loading speeds even with 100,000+ transaction records, BankYar uses constant-time keyset pagination ($O(1)$) using timestamp and UUID anchors:
$$\text{Query Constraint: } (\text{timestamp} < \text{anchor\_timestamp}) \lor (\text{timestamp} = \text{anchor\_timestamp} \land \text{id} < \text{anchor\_id})$$

### 3. Dedicated Background Isolates
The main UI thread is kept unblocked. Background tasks, such as bulk CSV statement imports or generating complex financial reports, run in separate Dart Isolates, ensuring the main UI thread continues rendering smoothly at 60fps+.

---

## 38. Architectural Decision Records (ADR)

### ADR-001: Riverpod as State and DI Framework
* **Status:** Approved
* **Context:** The application needs to support rapid development, unit testing, and future iOS migration.
* **Decision:** Riverpod for both State Management and Dependency Injection.
* **Rationale:** It avoids the boilerplate of BLoC while offering compile-time safety for dependency injection. It makes mocking repositories in unit tests extremely direct, accelerating AI-assisted development.

### ADR-002: Stream-Based Database Synchronization
* **Status:** Approved
* **Context:** The transaction ledger dashboard must display updates reactively when background SMS parsing completes.
* **Decision:** ViewModels connect directly to database streams, rebuilding views reactively when changes occur.
* **Rationale:** This ensures that the UI remains in sync with the database, avoiding manual state updates or sync issues.

### ADR-003: Auto-Disposal of Transient States
* **Status:** Approved
* **Context:** Mobile devices have limited memory, and financial data is highly sensitive.
* **Decision:** Enforce Riverpod's `.autoDispose` modifier on all transient screen-level providers.
* **Rationale:** This ensures that form parameters, search queries, and transient transaction lists are immediately cleared from RAM when the user exits the screen, preventing memory leaks and protecting sensitive data.

---

## 39. Architectural Trade-off Analysis

### 1. Unified Riverpod Graph vs. Decoupled Service Locators
* **The Choice:** Unified Riverpod dependency graph.
* **Trade-off Analysis:** Decoupled service locators (such as `GetIt`) can be simpler to set up in small projects. However, they lack compile-time safety, exposing the app to missing-dependency crashes during runtime. Riverpod's compile-time checked graph ensures dependencies are resolved at build time, prioritizing stability over minor setup convenience.

### 2. Stream-Based Reactive UI vs. Event-Driven Updates
* **The Choice:** Stream-Based Reactive UI.
* **Trade-off Analysis:** Event-driven architectures can reduce database reads by updating the UI cache directly. However, they introduce complexity in maintaining consistency across screens. Stream-based UI architectures rely on the database as the single source of truth, guaranteeing consistency and simplicity at the cost of minor database read overhead.

### 3. Keyset Seek Pagination vs. Offset-Limit Pagination
* **The Choice:** Keyset Seek Pagination.
* **Trade-off Analysis:** Keyset pagination is slightly more complex to implement because it requires tracking anchor records on scrolling. However, it avoids the linear performance degradation of offset pagination over large datasets, ensuring smooth scrolling performance over large transaction histories.

---

## 40. Best Practices & Code-Generation Alignment

To optimize the architecture for human-AI collaboration:

* **Strict File Naming Conventions:**
  - Entities: `*_entity.dart`
  - ViewModels / Notifiers: `*_notifier.dart`
  - Use Cases: `*_usecase.dart`
  - Data Sources: `*_source.dart`
* **Explicit Type Signatures:** All methods and provider definitions must declare explicit return types, avoiding ambiguous dynamic signatures and helping AI code-generation agents parse contracts with high accuracy.
* **Pure Dart Domain Layer:** The domain layer must remain free of external packages or Flutter dependencies (no imports referencing `material.dart` or `flutter_riverpod.dart`), ensuring high testability and platform portability.

---
**End of State Management Architecture Document**
