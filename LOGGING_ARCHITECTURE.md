# BankYar Logging, Diagnostics, and Observability Architecture Specification

**Project Name:** BankYar
**Classification:** Enterprise Observability & Privacy Architecture (Restricted)
**Document Version:** 1.0.0
**Authors:** Principal Site Reliability Engineer, Enterprise Observability Architect, & Senior Flutter Software Architect
**Status:** Approved / Production-Ready Baseline

---

## Executive Summary

BankYar is an offline-first, privacy-first, and AI-assisted mobile application that captures and parses banking SMS messages with strict privacy and zero-network access (no internet permission, no remote servers, and no third-party telemetry/analytics SDKs).

Because the application handles extremely sensitive financial transaction notifications and raw SMS content directly on the user's mobile device, its observability system cannot rely on standard cloud-based logging platforms (such as Firebase Crashlytics, Sentry, Datadog, or New Relic).

This document defines the comprehensive **Logging, Diagnostics, and Observability Architecture** for BankYar. It provides a highly debuggable environment for both local troubleshooting and future AI-assisted diagnostics, while enforcing strict privacy-preserving boundaries. No personally identifiable information (PII), unmasked financial figures, or raw SMS content ever leak into persistent logs or leave the device.

---

## Table of Contents
1. [Logging Philosophy](#1-logging-philosophy)
2. [Observability Principles](#2-observability-principles)
3. [Log Classification](#3-log-classification)
4. [Log Levels](#4-log-levels)
5. [Structured Logging Strategy](#5-structured-logging-strategy)
6. [Log Ownership](#6-log-ownership)
7. [Log Lifecycle](#7-log-lifecycle)
8. [Sensitive Data Policy](#8-sensitive-data-policy)
9. [Redaction Strategy](#9-redaction-strategy)
10. [Correlation ID Strategy](#10-correlation-id-strategy)
11. [Session Tracking](#11-session-tracking)
12. [Performance Logging](#12-performance-logging)
13. [Parser Logging](#13-parser-logging)
14. [Database Logging](#14-database-logging)
15. [Security Logging](#15-security-logging)
16. [Permission Logging](#16-permission-logging)
17. [Backup Logging](#17-backup-logging)
18. [Import / Export Logging](#18-import--export-logging)
19. [Notification Logging](#19-notification-logging)
20. [Navigation Logging](#20-navigation-logging)
21. [Crash Diagnostics](#21-crash-diagnostics)
22. [Startup Diagnostics](#22-startup-diagnostics)
23. [Memory Diagnostics](#23-memory-diagnostics)
24. [Battery Diagnostics](#24-battery-diagnostics)
25. [Storage Diagnostics](#25-storage-diagnostics)
26. [Audit Events](#26-audit-events)
27. [Future Remote Diagnostics](#27-future-remote-diagnostics)
28. [Log Rotation Strategy](#28-log-rotation-strategy)
29. [Log Retention Strategy](#29-log-retention-strategy)
30. [Diagnostic Export Strategy](#30-diagnostic-export-strategy)
31. [Privacy Compliance](#31-privacy-compliance)
32. [Testing Strategy](#32-testing-strategy)
33. [Monitoring Strategy](#33-monitoring-strategy)
34. [Future Evolution](#34-future-evolution)
35. [Architectural Decision Records (LADR)](#35-architectural-decision-records-ladr)
36. [Trade-off Analysis](#36-trade-off-analysis)

---

## 1. Logging Philosophy

BankYar's logging philosophy is designed specifically to support a secure, local, and AI-assisted financial application:

* **Zero Leaks by Default (Privacy First):** Standard diagnostic logs are inherently insecure when they capture user input. In BankYar, every logger is "blind" to raw SMS payloads, specific monetary values, card numbers, bank account numbers, names, and customized notes. Data masking and redaction occur *before* log messages are constructed.
* **Deterministic Structured Output:** Observability is useless if logs are unstructured strings. All logs are formatted as structured, schema-validated JSON objects, simplifying local debugging and making them highly readable for on-device AI debugging assistants.
* **Diagnostics Without Network:** Standard APM solutions rely on real-time network streaming. BankYar implements a high-performance, ring-buffered, encrypted local database sink using **SQLCipher**, utilizing native system notifications and specialized offline dashboards to surface diagnostic metrics.
* **AI-Assisted Self-Healing:** The system structures metadata with unambiguous error taxonomy codes so that local AI models (such as on-device NLP parsers) can ingest diagnostic structures directly and suggest repairs (e.g., indicating regex capture group drift).

---

## 2. Observability Principles

The architecture is governed by five core Observability Principles:

```
┌────────────────────────────────────────────────────────┐
│               CORE OBSERVABILITY PRINCIPLES            │
├────────────────────────────────────────────────────────┤
│ 1. Unified Structure  │ 2. Contextual Isolation       │
│ 3. Security-First     │ 4. Zero Thread Interference   │
│ 5. Absolute Transparency                               │
└────────────────────────────────────────────────────────┘
```

1. **Unified Structure:** All logging channels emit to a centralized, unified schema interface.
2. **Contextual Isolation:** Logs are decoupled from the active UI state. If a crash or state timeout occurs, the logger continues operating in an isolated system process or worker thread to document the failure context.
3. **Security-First Storage:** Diagnostic logs are treated as "Internal Sensitive" information. They are stored inside the encrypted SQLCipher database, protecting them from unauthorized physical access or backup tampering.
4. **Zero Thread Interference:** Heavy log serialization and writes must never degrade rendering performance (60fps+ scrolling). Disk I/O for logging runs on dedicated background isolates or during system idle cycles.
5. **Absolute Transparency:** The user retains complete authority over log files. Logs can be inspected, completely wiped, or manually exported through the diagnostics settings panel.

---

## 3. Log Classification

To determine how logs are routed, cached, or encrypted, the system classifies events into four tiers:

| Class | Severity Range | Storage Location | Encryption Method | Retention Policy | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Highly Sensitive / Security** | ERROR, CRITICAL | SQLCipher Database Table | SQLCipher AES-256 | 30 Days (Strict FIFO) | Covers PIN lockouts, biometric failures, signature mismatch, tamper checks, and master key evictions. |
| **System Diagnostics** | WARNING, ERROR | SQLCipher Database Table | SQLCipher AES-256 | FIFO capped at 10,000 logs | Database corruption checks, startup durations, storage full metrics, and memory diagnostics. |
| **Feature Ingestion Logs** | INFO, WARNING | SQLCipher Database Table | SQLCipher AES-256 | FIFO capped at 5,000 logs | SMS matching statuses, parser execution times, category rules mapping, and notification schedules. |
| **Console Diagnostics** | DEBUG, INFO | Volatile Memory (Stream) | None (Dev Builds Only) | Discarded on app close | Real-time stream for active local debugging during development. Automatically stripped from production builds. |

---

## 4. Log Levels

BankYar strictly maps application events to six standardized log levels:

| Level | Value | Architectural Application | Example Scenario |
| :--- | :---: | :--- | :--- |
| **TRACE** | 0 | Highly verbose execution tracking. Stripped completely from production binaries. | Tracing individual character tokenization steps in the heuristic parser. |
| **DEBUG** | 1 | Developer insights for active troubleshooting. Present only in debug-enabled builds. | State notifier provider initialization states or UI widget rebuild triggers. |
| **INFO** | 2 | Significant, successful system state transitions. Recorded in production. | Database connection pool successfully opened, or backup generation successfully completed. |
| **WARN** | 3 | Non-fatal execution errors or system warnings. Requires self-repair or fallback. | SMS format drift detected (unparsed message), or database page file size exceeds 100MB. |
| **ERROR** | 4 | Operational failures that block a specific feature, but do not crash the app. | CSV import schema mismatch, or biometric sensor timeout. |
| **FATAL** | 5 | Critical system failures that halt core operations and require immediate app lock. | SQLCipher database page corruption, or Keystore decryption key loss. |

---

## 5. Structured Logging Strategy

All log entries are serialized into a standardized, unified JSON schema.

### Core JSON Schema Specification
```json
{
  "$schema": "https://bankyar.org/schemas/diagnostic-log-v1.json",
  "correlation_id": "8f3b6c2d-9e1a-4f5c-8b3d-7e2a1b3c4d5e",
  "session_id": "s_7a2b9c3d-1e4f-5a6b-7c8d-9e0f1a2b3c4d",
  "timestamp": 1698183002145,
  "level": "ERROR",
  "category": "DATABASE",
  "taxonomy_code": "BY_INF_DB_LOCK_TIMEOUT",
  "component": "SqliteConnectionPool",
  "message": "Database write connection lock timeout occurred after multiple retry attempts.",
  "metadata": {
    "retry_attempts": 3,
    "elapsed_ms": 1500,
    "journal_mode": "WAL"
  },
  "device_context": {
    "os_version": "Android 13",
    "free_storage_bytes": 104857600,
    "is_battery_restricted": false,
    "ram_free_mb": 512
  },
  "exception": {
    "type": "SqliteException",
    "message": "database is locked",
    "stack_trace": "package:bankyar/core/database/database_pool.dart:45:12..."
  }
}
```

### Metadata Requirements:
* **`correlation_id`:** Multi-layered tracing token tracking operations across asynchronous thread boundaries.
* **`taxonomy_code`:** Unique string code conforming to `BY_[FEATURE]_[CATEGORY]_[DETAIL_CODE]`.
* **No Plaintext String Concatenation:** Log messages are static templates. Variable parameters are isolated inside the `metadata` dictionary to support automated AI-driven parsing and indexing.

---

## 6. Log Ownership

Responsibility for the logging infrastructure, validation, and retention is assigned to specific modules in compliance with the modular Feature Architecture:

```
┌────────────────────────────────────────────────────────┐
│                        LOG OWNERSHIP                   │
├────────────────────────────────────────────────────────┤
│                   [ core_logging ]                     │
│               (Main Infrastructure Owner)              │
│                           │                            │
│         ┌─────────────────┼─────────────────┐          │
│         ▼                 ▼                 ▼          │
│   [ core_security ] [ core_database ] [ Feature Logs ] │
│   (Sensitive Logs)   (Storage Sink)   (Domain Modules) │
└────────────────────────────────────────────────────────┘
```

| Module | Responsibility | Primary Architectural Role |
| :--- | :--- | :--- |
| **`core_logging`** | Logging Engine | Exposes logging APIs, executes regex PII sanitization, formats JSON schemas, and manages background thread isolates. |
| **`core_database`** | SQLite Storage | Manages the `diagnostic_logs` table in SQLCipher, handles write locks, and executes FIFO log pruning. |
| **`core_security`** | Sensitive Log Guard | Validates that security, authentication, and key eviction logs contain exactly zero cryptographic leaks. |
| **Feature Modules** | Context Providers | Emits structured logging records to the logging engine with accurate metadata and taxonomy codes. |

---

## 7. Log Lifecycle

Log entries transition through five distinct stages, ensuring high performance and data security:

```
1. Emit ──────► 2. Scrub ──────► 3. Buffer ──────► 4. Persist ──────► 5. Purge
(Feature)      (PII Scrub)      (Isolate)       (SQLCipher)       (FIFO Capped)
```

1. **Emit:** A feature module registers an event (e.g. parser exception) and triggers the logger.
2. **Scrub (PII Sanitization):** Before leaving the caller's thread, raw text payloads and numeric balances are processed by regular expression filters, redacting sensitive parameters.
3. **Buffer (Isolate Queue):** The sanitized JSON structure is dispatched to a background Dart Isolate thread queue, keeping the main UI thread free from serialization overhead.
4. **Persist:** The background isolate batches write operations and writes them to the `diagnostic_logs` table in the encrypted SQLCipher database.
5. **Purge:** As new logs are written, the database checks the log count. If it exceeds limits (e.g. 10,000 logs), it executes a fast FIFO delete query to purge the oldest entries.

---

## 8. Sensitive Data Policy

To enforce ironclad user privacy, BankYar defines a zero-tolerance policy for sensitive data in persistent logs.

### Absolute Prohibitions:
* **No Raw SMS Payload Body:** The raw body of intercepted SMS notifications must never be written to logs.
* **No Unmasked Financial Values:** No specific transaction amounts (e.g., "$1,245.50") or account balances can appear in plaintext.
* **No Personal Identifiers (PII):** User names, email addresses, phone numbers, and physical addresses must never be captured.
* **No Account Identifiers:** Credit/debit card numbers or bank account numbers must be fully redacted.
* **No Plaintext Cryptographic Keys:** Cryptographic keys, PIN hashes, passwords, or salt bytes must never be printed or written to disk.

---

## 9. Redaction Strategy

To enforce the Sensitive Data Policy, the logging engine runs a high-speed, compiled regex filtering pipeline prior to writing any data to disk.

```
Incoming Log Parameters (Text & Metadata)
                   │
                   ├─► Apply Masking Regex 1 (Financial figures: \b\d+([.,]\d{2})?\b) -> [REDACTED_AMOUNT]
                   ├─► Apply Masking Regex 2 (Card/Account references: \b(?:\d[ -]*?){4,19}\b) -> [REDACTED_CARD]
                   ├─► Apply Masking Regex 3 (SMS content structures) -> [REDACTED_TEXT]
                   ▼
Sanitized Parameter Output -> Central Logger Output
```

### Masking Definitions & Regex Rules:
* **Financial Amounts Masking:** Detects decimal patterns and replaces them:
  - Pattern: `\b\d+([.,]\d{2})?\b`
  - Replacement: `"[REDACTED_AMOUNT]"`
* **Card and Account Number Masking:** Recognizes strings of 4 to 19 contiguous digits and preserves only the last 4 indices:
  - Pattern: `\b\d(?=\d{4})\b` (Matches all digits preceding the final 4)
  - Replacement: `"*"` (e.g., "4111222233334444" becomes `"************4444"`)
* **SMS Raw Body Safeguard:** Any log tracking a parser exception must discard the raw message. The logger captures only the matching parser template ID and the specific regex capture group index that failed to match.

---

## 10. Correlation ID Strategy

Asynchronous processing in Flutter/Dart uses independent microtask queues and isolates, which can make debugging background processes difficult. BankYar implements a multi-layered correlation tracing token system:

* **Creation Point:** A unique, cryptographically secure UUID v4 `correlation_id` is generated at the system boundary for every incoming event (e.g. when an SMS broadcast is received or a manual CSV import is triggered).
* **Propagation Pattern:** The `correlation_id` is passed through repositories, use cases, and background parsing workers.
* **Trace Verification:** If an exception occurs, the logger records the `correlation_id` in the JSON metadata. This allows developers to trace the entire lifecycle of an SMS from receipt to database insertion by filtering logs by the correlation ID.

---

## 11. Session Tracking

To support diagnostics of state timeouts, app lockouts, and memory leaks, the logging system tracks local, secure session boundaries:

* **Logical Session Token (`session_id`):** Generated on application boot. It changes when the user successfully unlocks the app.
* **State Lifecycle Correlation:** The `session_id` is linked to all system events during that active session.
* **Security Isolation:** If the inactivity timer (5 minutes) triggers, the database key is evicted, the SQLite connection is closed, the active `session_id` is invalidated, and subsequent startup events generate a new session token, preventing cross-session tracking.

---

## 12. Performance Logging

To guarantee 60fps+ rendering and smooth performance, BankYar logs and tracks performance metrics locally:

```
[ Ingest SMS / Search Query / DB Write ]
                   │
                   ├─► StopWatch Start
                   ├─► Execute Target Operation
                   ├─► StopWatch Stop
                   ▼
         Check Execution Time
                   ├─► Time <= Limit (e.g. 300ms) -> Silently proceed
                   └─► Time > Limit -> Log WARN (BY_PERF_LATENCY_EXCEEDED) with duration metadata
```

* **Latency Benchmarks:**
  - Standard transaction FTS search queries must resolve in `< 50ms`.
  - Background SMS parsing and database insertion must execute in `< 300ms`.
  - App cold startup duration must complete in `< 500ms`.
* **Actionable Warnings:** If an operation exceeds these limits, the system logs a warning with the exact execution duration, helping developers pinpoint performance issues.

---

## 13. Parser Logging

To debug carrier format updates and custom user template rules without compromising privacy, the parsing engine implements structured parser logs:

* **Allowed Metadata:** Logs the matching parser template ID, sender ID prefix, pattern match duration, parsing confidence score, and parsing method (`DETERMINISTIC`, `HEURISTIC`, `MANUAL`).
* **Strict Redactions:** The unparsed message body is excluded. If a match fails, the parser logs the exact character index where the regex evaluation failed, helping developers diagnose regex issues safely.

---

## 14. Database Logging

Database logs track SQLCipher connection lifecycles and transactions while protecting user data:

* **No Plaintext SQL Queries:** Standard SQL queries with parameter bindings (`SELECT * FROM transactions WHERE amount > 500`) are strictly prohibited in logs.
* **Abstract Performance Logs:** The database wrapper logs transaction events using abstract indicators (e.g. "Transaction commit succeeded on table 'transactions' in 12ms"), protecting the underlying financial data.
* **System Event Logs:** Records page allocations, write-ahead logging (WAL) checkpoints, vacuum operations, and integrity checks, supporting offline corruption diagnostics.

---

## 15. Security Logging

Security events are classified as highly sensitive and require immediate logging:

* **Monitored Security Actions:**
  - Failed PIN attempts (increments failed lockout metrics).
  - PIN brute-force lockouts (records lockout durations).
  - Biometric authentication mismatches or timeouts.
  - Root checks and signature validation integrity checks.
  - Automatic key-eviction timer triggers.
* **No Credential Logging:** The logging system does not log PIN hashes, biometric hashes, or salt values, ensuring credentials are never exposed in logs.

---

## 16. Permission Logging

Permission logs help debug background SMS ingestion failures caused by operating system restrictions:

* **Tracked State Transitions:**
  - SMS capture permission grants or denials (`android.permission.RECEIVE_SMS`).
  - Background execution whitelisting status.
  - OS-initiated permission revocations.
* **Onboarding Diagnostics:** Integrates permission logs with the in-app troubleshooting dashboard, providing clear instructions to guide users on how to restore missing permissions.

---

## 17. Backup Logging

Backup operations require strict logging to ensure backup file integrity and prevent data loss:

* **Captured Metadata:** Backup file paths, file sizes (in bytes), compression ratios, encryption durations, and cryptographic validation hashes.
* **No Key Leakage:** The derived encryption key and password are never logged. If backup generation fails due to a weak password, the system logs a standard validation warning (`BY_BCK_PASS_WEAK`).

---

## 18. Import / Export Logging

Import and export operations are logged to track data portability and handle malformed files:

* **Import Logging Parameters:** Logs the source format (CSV/JSON), total row counts, validation checks, parsing durations, and duplicate records detected.
* **Export Logging Parameters:** Records file destinations, record counts, and export durations. Plaintext exported data is not cached in logs.

---

## 19. Notification Logging

Notification logs help verify that background transaction alerts are displayed correctly:

* **Tracked Metrics:** Notification channel registration, notification schedule times, display successes, and user click actions.
* **Privacy Controls:** To protect user privacy, notification bodies (which contain transaction details) are hidden on secure lock screens and are only logged using abstract, redacted tokens.

---

## 20. Navigation Logging

Navigation logs help reconstruct user flows leading up to an error or crash:

* **Tracked Navigation Actions:** Screen transitions, modal interactions, tab changes, and background-to-foreground transitions.
* **Redacted Parameters:** Navigation arguments that contain sensitive data (e.g., showing details for a specific transaction ID) are stripped, keeping only the screen route name (`/transaction/details`) in logs.

---

## 21. Crash Diagnostics

Since BankYar cannot stream crash reports to a remote cloud server, crash diagnostics are managed locally:

```
[ Application Crash / Unhandled Exception ]
                    │
                    ▼ Platform Error Hook
       Catch Platform Exception in Native Host Thread
                    │
                    ▼ Write to Local Log File
       Write Stack Trace to Anonymized Native Crash Log
                    │
                    ▼ App Boot Recovery
       On Next Boot: Check for Crash Log
                    ├─► Exists -> Show "App Recovered" banner with diagnostic report
                    └─► Does not exist -> Standard boot flow
```

* **Unhandled Dart Exceptions:** Caught via `PlatformDispatcher.onError`. The exception message is scrubbed of PII and written to a dedicated, persistent local crash file.
* **Native Android Exceptions (Java/C++):** Captured by a native uncaught exception handler, writing details to secure sandboxed storage.
* **Crash Recovery UI:** On next boot, the app checks for crash files. If found, it displays an alert banner, letting the user view the sanitized report or share it with developers.

---

## 22. Startup Diagnostics

Startup logs help identify slow app boots or system initialization issues:

* **Monitored Startup Phases:**
  - Core configuration load.
  - Keystore key retrieval.
  - SQLCipher database decryption and connection pool opening.
  - UI design tokens and settings loading.
* **Diagnostics Interface:** If the boot sequence exceeds 500ms, the system logs a performance warning (`BY_PERF_STARTUP_SLOW`) and maps the initialization durations for each phase.

---

## 23. Memory Diagnostics

Memory logs prevent application crashes caused by low-memory conditions on older devices:

* **Monitored Metrics:** Virtual RAM footprint, garbage collection counts, and platform low-memory alerts (`onTrimMemory` on Android).
* **Self-Healing Actions:** If free memory falls below 15MB, the app logs a memory warning (`BY_SYS_LOW_MEMORY`), invalidates the analytics cache, and flushes unused state providers to free up memory.

---

## 24. Battery Diagnostics

Battery diagnostics help identify why background SMS capture workers may be delayed or killed by aggressive operating system power management:

* **Monitored Parameters:** System battery levels, charging status, and device-specific battery restriction flags (such as Doze Mode status or manufacturer battery saver profiles).
* **Onboarding Guidance:** If battery restrictions delay background tasks, the system logs a warning (`BY_SYS_BATTERY_RESTRICTED`), prompting the user with an interactive onboarding card to whitelist the app from power savings.

---

## 25. Storage Diagnostics

Storage logs prevent database write failures caused by running out of disk space:

* **Monitored Metrics:** Secure application folder footprint, total device free space, database page fragmentation levels, and SQLCipher write safety margins.
* **Self-Healing Actions:** If free space falls below 20MB, the system logs a storage warning (`BY_INF_STORAGE_FULL`), blocks new database writes, and guides the user to clean up logs or database files to prevent data corruption.

---

## 26. Audit Events

Audit events track critical database changes and modifications to ensure data integrity:

* **Tracked Changes:** Category additions, custom rules creations, transaction deletions, note edits, and backup file restorations.
* **Abstract Audit Log:** Records who, when, and what changed using abstract identifiers, ensuring sensitive financial details are not recorded in plaintext logs.

---

## 27. Future Remote Diagnostics

Although Version 1 runs completely offline with zero internet access, the logging architecture is designed to scale to future cloud sync or remote diagnostics features:

```
[ Sync/Remote Diagnostics Enabled ]
                   │
                   ▼ User Opt-In
        Verify Explicit User Consent in Settings
                   │
                   ▼ Prepare Logs
        Package Encrypted SQLCipher logs
                   │
                   ▼ Secure Transmission
        Transmit over HTTPS with TLS Pinning to private servers
```

* **Required Constraints:**
  - Strict user opt-in consent flows must be completed before any logs are shared.
  - All logs must be encrypted using a public key-wrapper prior to transmission.
  - Network transmission must use HTTPS with strict SSL pinning, ensuring logs are delivered safely to private servers.

---

## 28. Log Rotation Strategy

To prevent diagnostic logs from exhausting device storage space, BankYar implements a high-performance log rotation strategy:

| Rotation Trigger | Threshold | Rotation Action |
| :--- | :--- | :--- |
| **Log Count Limit** | 10,000 entries | Triggers a fast SQLite delete query to purge the oldest 1,000 records, maintaining a stable database footprint. |
| **File Size Limit** | 5MB | Rotates active log tables in the background, copying current records to a history partition and starting a fresh log file. |
| **Time Limit** | 30 Days | Purges logs older than 30 days during background maintenance tasks, keeping diagnostic files current and relevant. |

---

## 29. Log Retention Strategy

The log retention strategy enforces strict storage durations for different log categories, balancing debuggability and privacy:

```
┌────────────────────────────────────────────────────────┐
│                   LOG RETENTION SUMMARY                │
├────────────────────────────────────────────────────────┤
│ - Security Logs: 30 Days (Strict, secure deletion)     │
│ - Diagnostic Logs: FIFO capped at 10,000 logs           │
│ - Performance Logs: FIFO capped at 2,000 logs          │
│ - Search Cache: Deleted instantly on session exit      │
└────────────────────────────────────────────────────────┘
```

* **Security Logs:** Retained for 30 days to track lockouts and biometrics, then securely deleted.
* **Diagnostic Logs:** Capped at 10,000 records using a FIFO queue, preventing storage bloat on old devices.
* **Performance Logs:** Capped at 2,000 records, automatically purging historical entries during database maintenance.
* **Search Cache:** Stored in volatile RAM and deleted instantly on session exit or app lock.

---

## 30. Diagnostic Export Strategy

When troubleshooting background SMS capture issues, users can manually export diagnostic log packages safely:

1. **Explicit User Trigger:** Exports cannot run in the background. They must be explicitly triggered by the user from the settings panel.
2. **Double-Sanitization Pass:** Prior to generation, logs are scanned again using the compiled regex sanitization pipeline to guarantee no plaintext financial or personal details exist in the export file.
3. **Encrypted Export Option:** Users can choose to encrypt the export file using a developer-provided public key, ensuring logs can only be read by the BankYar development team.
4. **Secure OS Share Sheet:** The exported file is written to the app's secure private directory and shared using the native OS Share Sheet, ensuring no unencrypted plain text files are saved to shared directories.

---

## 31. Privacy Compliance

The observability system complies with strict international privacy regulations (such as GDPR, CCPA, and local financial guidelines) by enforcing Privacy by Design:

* **GDPR compliance:** Since all logs are stored locally, encrypted, and controlled entirely by the user, GDPR compliance is achieved by default.
* **Right to be Forgotten:** Users can completely wipe all transaction histories and diagnostic logs instantly from the app's settings panel.
* **Explicit Opt-In:** If future remote diagnostics are enabled, the system requires explicit user opt-in consent before any data is transmitted.

---

## 32. Testing Strategy

The logging and diagnostics infrastructure is covered by automated unit and integration tests:

* **Sanitization Regex Tests:** Verifies that masking regular expressions correctly detect and redact transaction amounts, account numbers, and card details under various text configurations.
* **Isolate Queue Tests:** Simulates rapid, concurrent log writes to verify that the background Dart Isolate processes log buffers without causing UI thread delays.
* **FIFO Rotation Tests:** Inserts 11,000 mock log entries into the SQLCipher database and verifies that the database successfully prunes the oldest records, maintaining a stable count.
* **PII Leakage Verification:** Scans generated log files using static code analysis to ensure no plaintext monetary numbers, card indices, or raw SMS structures exist.

---

## 33. Monitoring Strategy

Since BankYar operates with zero network access, monitoring is managed locally through in-app dashboards and notification triggers:

```
[ Background Worker Executing ] ──► Compute Performance Metrics
                                         │
                                         ▼
                             Check Health Thresholds
                                         │
                    ┌────────────────────┴────────────────────┐
          Within Limits                            Exceeds Limits (e.g. Storage Full)
                │                                             │
                ▼                                             ▼
          Silently proceed                       Raise System Tray Alert
                                                 & Log CRITICAL Event
```

* **In-App Health Dashboard:** Provides an interactive diagnostics screen showing SMS capture worker status, Keystore validation, and database sizes.
* **System Tray Alerts:** If a critical error occurs in the background (such as storage full or database write blocks), the system displays a native notification, guiding the user to open the app to resolve the issue.

---

## 34. Future Evolution

The logging and diagnostics architecture is designed to support future evolutionary iterations:

* **On-Device ML Log Classification:** Integrates a lightweight local tokenizer to analyze diagnostic logs and suggest potential troubleshooting actions automatically.
* **P2P Diagnostics Syncing:** Supports secure local syncing over local networks (such as home NAS or companion desktop apps), allowing users to back up and view log files without cloud dependencies.
* **Dynamic Log Level Adjustments:** Allows advanced users to adjust log level verbosity in settings, optimizing storage space on low-end devices.

---

## 35. Logging Architectural Decision Records (LADR)

The logging design of BankYar is governed by three core Logging Architectural Decision Records:

### LADR-001: Local SQLCipher Persistent Log Sink
* **Status:** Approved
* **Context:** Offline financial tracking requires highly secure, crash-resilient local logging that cannot be read by other applications.
* **Decision:** Store diagnostic logs inside the encrypted SQLCipher database file.
* **Rationale:** Writing logs to unencrypted plain text files exposes sensitive system execution details to other apps or physical extraction. SQLCipher secures log structures behind hardware-backed encryption keys, protecting user privacy.

### LADR-002: Background Isolate Logging
* **Status:** Approved
* **Context:** heavy JSON serialization and database write operations can block the main thread and cause UI frame rate drops.
* **Decision:** Process log buffers and database writes on a dedicated, background Dart Isolate thread.
* **Rationale:** This ensures that logging operations do not interfere with rendering performance, maintaining smooth 60fps+ UI scrolling over large transaction histories.

### LADR-003: Double-Sanitization Export Pipeline
* **Status:** Approved
* **Context:** Exporting logs to share with developers risks exposing sensitive transaction details or personal information if sanitization fails.
* **Decision:** Enforce a double-sanitization pass before logs are exported, scanning log contents with regular expressions to ensure no plaintext values exist.
* **Rationale:** This ensures absolute privacy compliance, preventing accidental leaks of financial information during user-driven log sharing.

---

## 36. Trade-off Analysis

### 1. Persistent SQLCipher Logging vs. Plaintext File Logging
* **The Choice:** Persistent SQLCipher Logging.
* **Trade-off Analysis:** Plaintext file loggers are easier to implement and require less CPU overhead during write operations. However, unencrypted files are vulnerable to unauthorized access and security breaches. For financial tracking, data privacy is our paramount priority, making SQLCipher the correct choice despite minor write performance trade-offs.

### 2. Strict PII Redaction vs. Detailed Troubleshooting
* **The Choice:** Strict PII Redaction.
* **Trade-off Analysis:** Preserving raw SMS content and transaction details in logs makes debugging parsing issues straightforward. However, this violates our privacy-first principles and risks exposing sensitive financial data. Redacting PII makes diagnosing parser drift slightly more complex but guarantees user privacy.

### 3. Background Isolate Logging vs. Synchronous Main-Thread Logging
* **The Choice:** Background Isolate Logging.
* **Trade-off Analysis:** Writing logs synchronously on the main thread is simpler and requires no isolate boundary management. However, this causes rendering frame rate drops during heavy database writes. Moving logging tasks to background isolates requires extra setup but guarantees a responsive UI.

---
**End of Logging, Diagnostics, and Observability Architecture Specification**
