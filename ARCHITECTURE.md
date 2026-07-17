# BankYar Architectural Design Document (ADD)

**Project Name:** BankYar
**Product Type:** AI-First Offline Mobile Application
**Initial Platform:** Android First (Kotlin)
**Future Platform:** Cross-platform (Flutter)
**Author:** Principal Product Architect & AI Solution Designer

---

## 1. Executive Summary

BankYar is an intelligent, AI-first, offline-only banking SMS management application. It runs locally on Android, detects transaction SMS messages, extracts financial metadata (e.g., transaction amount, currency, account/card index, merchant, balance, type), stores them in an encrypted database, and provides users with queryable insights, custom notes, filtering, and rich analytics.

As a **Privacy-First** and **Security-by-Design** application, **no data ever leaves the device**. The app enforces a strict sandboxed execution model, explicitly declaring zero network permissions.

This document defines the high-level and low-level architectural blueprints of BankYar, applying Clean Architecture and Feature-First organization to guarantee maintainability, high testability, and a seamless future migration to Flutter.

---

## 2. Product & Design Vision

### 2.1 Core Pillars
* **AI-First Parsing:** Hybrid parsing using deterministic Rules/Regular Expressions and lightweight on-device Natural Language Processing (NLP) / Tokenizers to parse incoming SMS bodies accurately without cloud APIs.
* **Absolute Offline Guarantee:** Zero network connectivity. No tracking, no cloud telemetry, no remote crashes reporting (local diagnostics only).
* **Enterprise Security:** Hardened database encryption at rest, secure key generation utilizing the hardware-backed Android Keystore, and process-level sandboxing.
* **Actionable Financial Intelligence:** Users manage their history with manual categories, customizable text notes, and offline analytics visualization.

---

## 3. Core Architectural Principles

To ensure long-term maintainability, testability, and clean porting to Flutter, we commit to the following principles:

1. **Clean Architecture:**
   * **Presentation Layer:** Contains UI elements (Views/Activities/Fragments) and State Holders (ViewModels or BLoCs/Notifiers in Flutter).
   * **Domain Layer:** Represents the core business logic. Contains pure domain Entities, Use Cases, and Repository contracts. This layer is completely framework-independent.
   * **Data Layer:** Handles data retrieval and persistence. Contains Repository implementations, local Data Sources (Encrypted Database, SharedPreferences), Models (DTOs), and SMS BroadcastReceivers.

2. **Feature-First Organization:**
   * Instead of grouping files by generic technical types (e.g., all controllers, all models), code is structured around functional vertical slices (e.g., `sms_detection`, `transactions`, `analytics`, `notes`).
   * This simplifies navigation, isolation, and future migration.

3. **SOLID & Clean Code Principles:**
   * **Single Responsibility (SRP):** SMS BroadcastReceiver only listens and forwards. The parsing engine only parses.
   * **Open/Closed (OCP):** Parsing rules and templates are extensible without modifying core parsing pipelines.
   * **Interface Segregation & Dependency Inversion (DIP):** Repositories and local services are accessed through interfaces injected via dependency injection (DI).

4. **Offline & Privacy-First:**
   * Fully functional with airplane mode permanently active.
   * Direct hardware-bound cryptographic keys.
   * Manifest-level exclusion of the `android.permission.INTERNET` permission.

---

## 4. System & Layer Architecture

The system utilizes an event-driven flow triggered by incoming Android SMS broadcasts.

```
       +--------------------------------------------------------+
       |                 Android OS SMS Broadcast               |
       +----------------------------+---------------------------+
                                    |
                                    v
       +--------------------------------------------------------+
       |   DATA LAYER: SMSReceiver (BroadcastReceiver)           |
       +----------------------------+---------------------------+
                                    |
                                    v
       +--------------------------------------------------------+
       |   DATA LAYER: SmsParserEngine                          |
       |   - Static Regular Expressions (Regex)                 |
       |   - On-Device NLP / Deterministic Rule Parser          |
       +----------------------------+---------------------------+
                                    | Map to TransactionDTO
                                    v
       +--------------------------------------------------------+
       |   DATA LAYER: TransactionRepositoryImpl                |
       |   - Persists to SQLCipher Database                     |
       +----------------------------+---------------------------+
                                    | Emits Stream/Flow updates
                                    v
       +--------------------------------------------------------+
       |   DOMAIN LAYER: GetTransactionsUseCase                 |
       |   - Applies business policies (Category validation)    |
       +----------------------------+---------------------------+
                                    |
                                    v
       +--------------------------------------------------------+
       |   PRESENTATION LAYER: ViewModels / State Management    |
       |   - TransactionViewModel / AnalyticsViewModel          |
       +----------------------------+---------------------------+
                                    | Exposes UI State
                                    v
       +--------------------------------------------------------+
       |   PRESENTATION LAYER: Jetpack Compose / Flutter UI     |
       +--------------------------------------------------------+
```

### 4.1 Domain Layer (Core Business Rules)
Completely independent of UI libraries, frameworks, or database drivers.
* **Entities:**
  * `Transaction`: Represents a financial transaction record (id, amount, currency, bankName, accountEnding, transactionType [CREDIT/DEBIT], timestamp, rawSmsBody, category, userNote).
  * `AnalyticsReport`: Local aggregation of income vs. expenses grouped by bank, month, or category.
* **Repository Interfaces:**
  * `TransactionRepository`: Interface declaring CRUD operations and reactive Streams (`Flow` in Kotlin, `Stream` in Flutter) of transaction data.
  * `SmsParser`: Interface representing the extraction contract.
* **Use Cases:**
  * `ProcessIncomingSms`: Orchestrates extraction, formats into a transaction entity, and requests persistence.
  * `GetTransactions`: Fetches, filters, and searches transactions.
  * `UpdateTransactionNotes`: Allows appending user-specified notes to an existing transaction.
  * `GenerateAnalytics`: Evaluates transactional metrics.

### 4.2 Data Layer (Infrastructure & External Interfaces)
Contains implementations of core interfaces.
* **Local Data Sources:**
  * `EncryptedDbDataSource`: Uses SQLCipher (SQLite with 256-bit AES encryption) on Android.
  * `SecureStorage`: Manages shared configuration keys utilizing `EncryptedSharedPreferences` on Android, backed by Keystore.
* **SmsReceiver:**
  * Concrete `BroadcastReceiver` registering for `android.provider.Telephony.SMS_RECEIVED`.
  * Runs a background service (using WorkManager to survive OS process killing) to handle fast asynchronous processing of SMS packets.
* **SmsParserEngine (On-Device AI Engine):**
  * Uses a pipeline of high-performance regular expressions for known bank SMS syntax configurations (regular expression template map loaded locally).
  * Incorporates a local lightweight heuristic classifier (on-device Naive Bayes, decision tree, or localized BERT-mini model via TensorFlow Lite if complex processing is required) to extract metadata from previously unseen SMS structures without cloud interaction.

### 4.3 Presentation Layer (UI & Interaction)
Constructed reactively to decouple UI state from lifecycle complexities.
* **State Management:** Unidirectional Data Flow (UDF) implemented via `StateFlow` and ViewModels on Android (or `Bloc` / `Notifier` / `Riverpod` in Flutter).
* **UI Components:** Built using Jetpack Compose (Kotlin) with design tokens that map easily to Flutter's Widget ecosystem.

---

## 5. Privacy, Security, & Cryptographic Design

Because BankYar handles sensitive transaction notifications, security must be built directly into the codebase.

```
       +--------------------------------------------------------------+
       |                       Android Keystore                       |
       |  - TEE (Trusted Execution Environment) / StrongBox            |
       |  - Generates AES-256 Master Key                              |
       +------------------------------+-------------------------------+
                                      |
                         Retrieve Master Key securely
                                      |
                                      v
       +--------------------------------------------------------------+
       |                      SQLCipher Database                      |
       |  - Transaction and Note storage encrypted at rest via AES-GCM|
       +--------------------------------------------------------------+
```

### 5.1 Zero-Trust Network Footprint
* The Android Manifest explicitly excludes `<uses-permission android:name="android.permission.INTERNET" />`.
* No external SDK or library (e.g., analytics, crash report tools) requiring internet connectivity is included.

### 5.2 Cryptography at Rest
1. **Master Key Generation:**
   * App initializes an AES-256 key via the `AndroidKeyStore` provider.
   * Biometric or user password confirmation can optionally lock/unlock the keystore.
2. **Database Encryption:**
   * High-performance encrypted SQLite database (via SQLCipher) is opened on application startup using the Keystore-generated Master Key.
3. **Data Loss Prevention:**
   * Android Auto-Backup (`android:allowBackup="false"`) is disabled to prevent unencrypted SMS parsing history or databases from being synchronized with cloud providers (e.g., Google Drive) unless the user explicitly exports an encrypted manual file.

---

## 6. Directory Structure (Feature-First)

The project structure is split cleanly into features. Below is both the Android Kotlin reference and the target Flutter translation mapping.

### 6.1 Android Kotlin Folder Structure

```
app/
└── src/
    └── main/
        ├── java/com/bankyar/
        │   ├── core/                           # Shared foundational utils
        │   │   ├── di/                         # Dependency injection setup (Hilt)
        │   │   ├── security/                   # Keystore & SQLCipher setup
        │   │   └── database/                   # Base DB helper classes
        │   │
        │   └── features/                       # Vertical Slices
        │       ├── sms_detection/              # Feature: Listening and parsing SMS
        │       │   ├── data/
        │       │   │   ├── receiver/SmsReceiver.kt
        │       │   │   ├── parser/SmsParserEngine.kt
        │       │   │   └── parser/ParserTemplates.json
        │       │   │   └── models/SmsDto.kt
        │       │   └── domain/
        │       │       ├── repository/SmsParser.kt
        │       │       └── usecases/ProcessIncomingSms.kt
        │       │
        │       ├── transactions/               # Feature: Display and edit transactions
        │       │   ├── data/
        │       │   │   ├── datasources/TransactionDao.kt
        │       │   │   ├── models/TransactionDto.kt
        │       │   │   └── repository/TransactionRepositoryImpl.kt
        │       │   ├── domain/
        │       │   │   ├── entities/Transaction.kt
        │       │   │   ├── repository/TransactionRepository.kt
        │       │   │   └── usecases/GetTransactions.kt
        │       │   └── presentation/
        │       │       ├── viewmodels/TransactionViewModel.kt
        │       │       └── views/TransactionListScreen.kt
        │       │
        │       └── analytics/                  # Feature: Charts and aggregations
        │           ├── domain/
        │           │   └── usecases/GenerateAnalytics.kt
        │           └── presentation/
        │               ├── viewmodels/AnalyticsViewModel.kt
        │               └── views/AnalyticsScreen.kt
        └── AndroidManifest.xml
```

### 6.2 Target Flutter Folder Structure (Translation Mapping)

During Flutter migration, the same structure remains fully intact:

```
lib/
├── core/
│   ├── di/                             # get_it / Injectable
│   ├── security/                       # flutter_secure_storage + Hive/SQLCipher
│   └── theme/                          # Shared UI Tokens
│
└── features/
    ├── sms_detection/
    │   ├── data/
    │   │   ├── models/sms_model.dart
    │   │   └── datasources/local_parser_engine.dart
    │   └── domain/
    │       ├── repository/sms_parser_interface.dart
    │       └── usecases/process_incoming_sms.dart
    │
    ├── transactions/
    │   ├── data/
    │   │   ├── models/transaction_model.dart
    │   │   └── repository/transaction_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/transaction_entity.dart
    │   │   ├── repository/transaction_repository.dart
    │   │   └── usecases/get_transactions.dart
    │   └── presentation/
    │       ├── bloc/transaction_bloc.dart
    │       └── pages/transaction_list_page.dart
    │
    └── analytics/
        ├── domain/
        │   └── usecases/generate_analytics_report.dart
        └── presentation/
            ├── bloc/analytics_bloc.dart
            └── pages/analytics_page.dart
```

---

## 7. Flutter Migration & Cross-Platform Blueprint

Migrating an Android-first SMS listener to Flutter requires architectural foresight because of OS differences in sandbox boundaries.

### 7.1 Cross-Platform SMS Access Architectural Design
1. **Android Capability:** Fully capable. Can register a background service/receiver to capture incoming SMS instantly via native MethodChannels or event channels.
2. **iOS Capability:** Restricted. Apple does not allow third-party applications to inspect, intercept, or read incoming SMS messages for security and privacy reasons.
3. **Unified Interface Solution:**
   * Construct an abstraction layer (`SmsReceiverPlatformInterface`).
   * **Android Implementation:** Spawns a background service linking native SMS BroadcastReceiver into Dart using `MethodChannel` or `EventChannel` streaming.
   * **iOS / Alternative Implementation:** Falls back safely. Instead of automatic background interception, the UI adapts to offer a manual bulk import interface where users can copy/paste SMS blocks, upload an exported encrypted statement, or manual entry.
   * **Result:** No crashes. Feature degradation is handled gracefully, conforming to high UX standards.

---

## 8. Risk Management Matrix

| Risk ID | Risk Description | Severity | Likelihood | Mitigation Strategy |
| :--- | :--- | :--- | :--- | :--- |
| **R-01** | OS kills Background BroadcastReceiver, preventing transaction capture. | High | Medium | Implement standard Android WorkManager triggers or Foreground Service for parsing tasks. Persist states in secure queue. |
| **R-02** | Bank SMS formats change dynamically, causing parser failures. | Medium | High | Maintain structural isolation of templates. Read a parsing rules file dynamically from local storage that can be updated securely (e.g., via user importing raw config text locally) without app updates. |
| **R-03** | iOS platform constraints prevent auto SMS capture. | High | High | Graceful UI fallback. Support copy-paste parse, manual entry, and structured file import. |
| **R-04** | Master Cryptographic key lost if device security state is reset. | High | Low | Implement warning prompts. Offer safe local database export capability encrypted with a user-defined password to external storage. |

---

## 9. Assumptions & Constraints

1. **Assumptions:**
   * The device supports secure hardware-backed key storage (TEE/StrongBox) for maximum database protection.
   * Banks on the user's platform deliver transaction alerts with standard textual identification details.
2. **Constraints:**
   * Zero Internet policy means no cloud updates of parsing templates. The app must contain a modular local template system that allows local templates parsing.
   * High performance limit: Regex search operations must run efficiently to avoid overhead and frame-drops on low-end Android devices.

---
**End of Document**
