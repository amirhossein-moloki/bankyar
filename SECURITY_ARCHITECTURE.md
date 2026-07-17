# BankYar Security & Privacy Architecture Specification

**Project Name:** BankYar
**Classification:** Enterprise Security & Privacy Architecture (Restricted)
**Document Version:** 1.0.0
**Authors:** Principal Security Architect, Privacy Engineer & Mobile Security Specialist
**Status:** Approved / Production-Ready Baseline

---

## Executive Summary

BankYar is a highly secure, offline-first personal finance management application that parses sensitive financial SMS notifications directly on the user's mobile device. Because financial transactions, account balances, and personal habits represent some of the most private information a user possesses, BankYar is built upon the dual foundations of **Security by Design** and **Privacy by Design**.

Operating with an absolute **zero-network footprint** (no internet permission declared), the application ensures that no user banking information can leave the device. This document defines the complete Security & Privacy Architecture for BankYar, detailing threat mitigation frameworks, hardware-backed cryptographic lifecycles, local trust boundaries, tamper detection, and defensive controls. It is designed to resist both passive surveillance and active forensic attacks on lost, stolen, or compromised devices.

---

## Table of Contents
1. [Security Vision](#1-security-vision)
2. [Threat Model](#2-threat-model)
3. [Security Principles](#3-security-principles)
4. [Privacy Principles](#4-privacy-principles)
5. [Attack Surface Analysis](#5-attack-surface-analysis)
6. [Trust Boundaries](#6-trust-boundaries)
7. [Data Classification](#7-data-classification)
8. [Authentication Strategy](#8-authentication-strategy)
9. [Authorization Strategy](#9-authorization-strategy)
10. [Local Encryption Strategy](#10-local-encryption-strategy)
11. [Key Management Strategy](#11-key-management-strategy)
12. [Android Keystore Integration](#12-android-keystore-integration)
13. [PIN Strategy](#13-pin-strategy)
14. [Biometric Strategy](#14-biometric-strategy)
15. [Backup Encryption Strategy](#15-backup-encryption-strategy)
16. [Restore Verification Strategy](#16-restore-verification-strategy)
17. [Secure Import Strategy](#17-secure-import-strategy)
18. [Secure Export Strategy](#18-secure-export-strategy)
19. [Secure Storage Strategy](#19-secure-storage-strategy)
20. [Memory Protection Strategy](#20-memory-protection-strategy)
21. [Sensitive Data Handling](#21-sensitive-data-handling)
22. [Logging Security](#22-logging-security)
23. [Error Handling Security](#23-error-handling-security)
24. [Tamper Detection](#24-tamper-detection)
25. [Root Detection Strategy](#25-root-detection-strategy)
26. [Debug Protection](#26-debug-protection)
27. [Screenshot Protection](#27-screenshot-protection)
28. [Clipboard Policy](#28-clipboard-policy)
29. [Notification Privacy](#29-notification-privacy)
30. [Secure Configuration](#30-secure-configuration)
31. [Dependency Security](#31-dependency-security)
32. [Supply Chain Security](#32-supply-chain-security)
33. [Update Security](#33-update-security)
34. [Parser Security](#34-parser-security)
35. [Regex Safety](#35-regex-safety)
36. [Denial of Service Protection](#36-denial-of-service-protection)
37. [Backup Recovery Security](#37-backup-recovery-security)
38. [Incident Recovery Strategy](#38-incident-recovery-strategy)
39. [Security Risks](#39-security-risks)
40. [Security Roadmap](#40-security-roadmap)
41. [Threat & Risk Matrix](#41-threat--risk-matrix)
42. [Architectural Decision Records (SADR)](#42-architectural-decision-records-sadr)
43. [Security Checklists](#43-security-checklists)
44. [Trade-off Analysis](#44-trade-off-analysis)

---

## 1. Security Vision

The BankYar security vision is to establish an impenetrable local sanctuary for user financial data. We reject the modern fintech consensus that user convenience justifies cloud concentration, behavioral tracking, or centralized security risks. By demonstrating that high-accuracy automation and deep financial analytics can run completely offline behind hardware-backed cryptographic walls, BankYar sets a new paradigm: **Zero Cloud, Zero Trust, Zero Leaks**.

Our commitment is to defend user data against:
* **The Sovereign Intruder:** State-level or carrier-level surveillance intercepting cellular communications.
* **The Local Opportunist:** Forensic extraction of physical data from lost, stolen, or seized devices.
* **The Malicious Companion:** Rogue apps on the same device exploiting accessibility, overlays, or clipboard hooks to scrape financial intelligence.

---

## 2. Threat Model

To design effective defenses, we must think like an attacker. BankYar recognizes twenty specific physical, logical, and environmental threats:

### 2.1 Threat Inventory & Vectors
1. **Lost Device:** An unauthorized physical finder attempts to boot the device, guess simple lock-screen bypasses, or inspect visual screen previews in the multitasking drawer.
2. **Stolen Device:** An active adversary steals an unlocked phone or performs chip-off extraction to physically access flash storage chips.
3. **Rooted Device:** Compromised operating system integrity allows superuser (root) privilege execution, enabling other apps to inspect the BankYar private sandbox.
4. **Debugging:** An attacker hooks a debugger (e.g., JDWP, GDB) or instrumentation framework (e.g., Frida) to a debug-enabled application build to inspect variable states and bypass authentication.
5. **Memory Dump:** Physical or software cold-boot extraction of volatile RAM to retrieve plaintext master cryptographic keys or transaction variables.
6. **Database Theft:** Direct copying of the physical SQLite database file via file managers or debugging bridges, followed by offline brute-force attempts.
7. **Backup Theft:** Interception or unauthorized copying of local `.bankyar` backup files from unencrypted external storage directories or cloud-sync folders.
8. **Fake SMS:** A malicious on-device application triggers spoofed local SMS broadcast intents to inject fraudulent transactions into the ledger.
9. **SMS Replay:** Re-injecting historical transaction texts into the telephony layer to cause double-billing or ledger distortion.
10. **Template Tampering:** Modifying local JSON matching rules to reroute amounts or merchants to different categories or system targets.
11. **Parser Manipulation:** Exploiting parser vulnerabilities (e.g., buffer overflows, type confusion) via malformed, complex text strings to execute arbitrary code.
12. **Privilege Escalation:** Exploiting kernel vulnerabilities or exploiting OS permissions to bypass sandboxing boundaries.
13. **Dependency Compromise:** Attackers inject malicious backdoor payloads into third-party open-source libraries included during compile-time.
14. **Malicious Accessibility Services:** Rogue apps abusing Android Accessibility APIs to read screen contents, capture keystrokes, or click UI elements automatically.
15. **Overlay Attacks:** Presenting a transparent, invisible malicious window over BankYar's PIN entry screen to hijack user inputs (clickjacking).
16. **Notification Snooping:** Exploiting operating system Notification Listeners or lock-screen previews to read parsed transaction amounts.
17. **Screen Recording:** Background spyware capturing real-time screenshots or video streams of the active financial dashboard.
18. **Shoulder Surfing:** Visual observation of the device screen or PIN entry movements in public environments.
19. **Social Engineering:** Users tricked into scanning malicious QR rules templates or importing corrupted backup payloads.
20. **Future Cloud Risks:** Risks associated with transition to hybrid-cloud features, such as API vulnerabilities or transport-layer credential leaks.

---

## 3. Security Principles

BankYar's architecture enforces five fundamental Security Principles:
* **Least Privilege:** The application requests the minimum possible OS permissions (specifically excluding network access). Internal components are highly decoupled and isolated.
* **Defense in Depth:** Security is never dependent on a single barrier. If root protection fails, the hardware-backed keystore must hold. If the keystore is compromised, database-level encryption and RAM key-eviction must prevent total exposure.
* **Fail Securely:** If a failure occurs (e.g., database corruption, keystore key loss, or continuous PIN failures), the application locks down, zeroizes RAM caches, and transitions to a blocking recovery state rather than exposing fallback plaintexts.
* **Complete Mediation:** Every access to financial records must be validated. No session caches bypass authentication.
* **Open Design:** Cryptographic strength rests entirely on mathematically audited algorithms (AES-256, PBKDF2) and secure key preservation, never on security by obscurity or proprietary algorithms.

---

## 4. Privacy Principles

Our Privacy Principles follow the strict standards of **Privacy by Design**:
* **Zero Telemetry / No Tracking (NFR-1.3):** The application contains exactly zero bytes of telemetry, analytics, or remote crash reporting SDKs. Total network transmission equals exactly 0 bytes.
* **Data Minimization:** We only parse and persist details relevant to the transaction ledger. Non-financial SMS messages are ignored at the ingestion boundary and immediately discarded.
* **Purpose Limitation:** Captured SMS data is used solely to construct the financial ledger and local analytical reports. It is never cross-referenced with other device files or device identities.
* **Storage Limitation:** Users can configure strict data retention schedules to automatically purge raw audited SMS payloads while retaining structured ledger history.
* **Offline-First Axiom:** All computing (extraction, categorization, analytics) occurs strictly on-device. The application manifest does not declare `android.permission.INTERNET`.

---

## 5. Attack Surface Analysis

The mobile environment contains multiple threat vectors. The table below analyzes the attack vectors and the architecture's countermeasures:

| Attack Vector | Vulnerability | Threat Actor | Mitigation Mechanism |
| :--- | :--- | :--- | :--- |
| **Physical Storage** | Direct file read of private sandbox database. | Thief, Device Finder | SQLCipher AES-256 page-level encryption. Hardware-bound database key. |
| **Telephony Interface** | SMS spoofing or SMS broadcast injection. | Rogue local application | Caller identity validation via telephony source verification; deduplication hashing. |
| **Volatile RAM** | Memory scanning or cold-boot dump. | Forensic analyst, kernel exploit | Key eviction after 5 mins inactivity; RAM byte-array zeroization. |
| **Application GUI** | Overlay, screenshot scraping, task switcher leak. | Spyware, shoulder surfer | `FLAG_SECURE` layout flags; custom blurred background overlays; scrambled PIN keypads. |
| **Accessibility API** | Screen reader scraping and input hijacking. | Malicious service | Blocking execution if non-system accessibility services are active; custom secure input views. |
| **External Backups** | Extraction of exported database backups. | Attacker accessing storage | PBKDF2WithHmacSHA256 key derivation with 100,000 iterations and AES-GCM-256 backup encryption. |

---

## 6. Trust Boundaries

The Trust Boundary Diagram illustrates where data transitions from unverified/untrusted sources into the secure, encrypted application domain:

```
[ UNTRUSTED / EXTERNAL SPACE ]                [ SANDBOXED APPLICATION DOMAIN ]

 Cellular Telephony Network                  ┌──────────────────────────────────────────────┐
             │                               │  SMS Capture (BroadcastReceiver / Worker)    │
             │ SMS Broadcast                 │  - Deduplication & Sender Validation         │
             ▼                               │                                              │
 ──────────────────────[ Trust Boundary 1: Telephony Ingestion ]───────────────────────────
             │                               │  - Deduplicates raw payload details          │
             ▼                               │                                              │
    Raw Cellular Text ──────────────────────►│  SMS Parser Engine (Dart Domain Service)     │
                                             │  - Runs compiled local regex configurations  │
                                             │  - Resolves Bank detected metadata           │
                                             └──────────────┬───────────────────────────────┘
                                                            │
                                                            ▼ Issues TransactionParsed Event
                                             ┌──────────────────────────────────────────────┐
                                             │  Ledger Management Context                   │
                                             │  - Runs auto-rules classification            │
                                             │  - Binds User Notes & Hashtags               │
                                             └──────────────┬───────────────────────────────┘
                                                            │
 ──────────────────────[ Trust Boundary 2: Cryptographic Persistence ]──────────────────────
                                                            │
                                                            ▼ ACID Write WAL
                                             ┌──────────────────────────────────────────────┐
                                             │  SQLCipher Database (SQLite + AES-256)       │
                                             │  - Page-level Encryption (Locked / Unlocked)  │
                                             └──────────────────────────────────────────────┘
                                                            ▲
                                                            │ Unlocks Connection
                                             ┌──────────────┴───────────────────────────────┐
                                             │  Security Context                            │
                                             │  - Hardware KeyStore Master Key decryption   │
                                             │  - Evicts key bytes from volatile RAM        │
                                             └──────────────────────────────────────────────┘
                                                            ▲
 ──────────────────────[ Trust Boundary 3: Physical Authentication ]────────────────────────
                                                            │
                                                            │ Auth Match
                                             ┌──────────────┴───────────────────────────────┐
                                             │  User Entry Interceptor                      │
                                             │  - Biometric Sensor / Scrambled PIN keypad    │
                                             └──────────────────────────────────────────────┘
```

---

## 7. Data Classification

BankYar classifies all persistent data into four tiers, applying strict handling, encryption, and logging constraints:

### 7.1 Classification Schema & Policy

| Dimension | Highly Sensitive | Sensitive | Internal | Public |
| :--- | :--- | :--- | :--- | :--- |
| **Data Examples** | Master DB Key, PIN Hash, Salt, Raw SMS body, Transaction Amount, Card Identifier, User Notes. | Custom regex templates, auto-rules keywords, custom category names, hashtag list. | Diagnostic log texts, permissions states, active theme, locale selection. | App version string, static carrier bank list, static help guide text. |
| **Storage Policy** | SQLCipher Database or Android Keystore (TEE/StrongBox). | SQLCipher Database page. | Sandbox SecurePreferences or SQLCipher logs. | Plaintext SharedPreferences or assets package. |
| **Encryption Policy** | AES-256-CBC (SQLCipher) or AES-256-GCM (Hardware key wrappers). | AES-256-CBC (SQLCipher). | AES-256-GCM (SecurePreferences) or Unencrypted. | None. Unencrypted. |
| **Backup Policy** | Fully encrypted via AES-256-GCM with PBKDF2 derived keys. | Fully encrypted via AES-256-GCM with PBKDF2 derived keys. | Excluded from manual backups. | Excluded. Recreated on install. |
| **Export Policy** | Restricted: CSV/JSON ledger exports must be explicitly triggered. | Allowed: Templates can be exported via local JSON/QR code. | Restricted: Diagnostics require manual user export trigger. | Allowed: Open sharing of carrier profiles. |
| **Logging Policy** | **STRICTLY PROHIBITED:** Plaintext values must never appear in logs. | Prohibited: Metadata names must be scrubbed before logging. | Allowed: Exception types and system states are logged. | Allowed: System configurations. |
| **Retention Policy** | Preserved during active ledger lifecycle or custom retention bounds. | Preserved until explicitly modified. | FIFO queue size-capped at 10,000 logs or 30 days. | Persistent. |
| **Deletion Policy** | Permanent shredding (Zeroization of DB pages and RAM caches). | Removed on table deletion. | Erased on log clear or app reset. | Erased on app uninstall. |

---

## 8. Authentication Strategy

The authentication strategy protects the application from local access. Access is blocked by a secure entry screen that intercepts application launch and background-to-foreground transitions.

* **Mutual Lockouts:** The authentication screen prevents entry until a successful hardware biometric scan matches or a valid PIN is entered on a randomized keypad.
* **Task Switcher Isolation:** During transitions to the background, the application registers native OS flags (e.g., `WindowManager.LayoutParams.FLAG_SECURE` on Android) to block screenshots and display a blank, blurred screen preview in the task switcher.

---

## 9. Authorization Strategy

Because BankYar operates with a single-user local architecture, authorization is governed by the status of the local cryptographic session:

* **Session Validation:** Access to the database connection pool is denied until the database is successfully unlocked using the decrypted master key.
* **State Enforcement:** If the inactivity timer expires, the database connection is closed, the key is evicted, and all data streams are invalidated. Any attempt to query repositories triggers an `AuthenticationTimeoutException`, redirecting the user to the lock screen.

---

## 10. Local Encryption Strategy

The database is encrypted at rest using **SQLCipher (AES-256 in CBC mode)**.

* **Page-Level Security:** SQLCipher encrypts the database file in fixed pages (typically 4096 bytes). Each page contains a unique initialization vector (IV) and a random salt value, preventing attackers from analyzing patterns in the data pages.
* **PBKDF2 Key Derivation:** The key is derived using PBKDF2 with HMAC-SHA256 and a random salt, running 100,000 iterations to protect against brute-force attacks.

---

## 11. Key Management Strategy

The cryptographic key lifecycle is designed to prevent plaintext keys from being exposed on non-volatile storage:

```
[ Installation ] ──► Generate cryptographically secure random 256-bit DB Key
                           │
                           ▼ Wrapped via Hardware AES-GCM
                     Save to Platform Secure Preferences
                           │
[ App Boot ] ────────► Decrypt Wrapped DB Key via Android KeyStore
                           │
                           ▼ Injected as bytes array
                     SQLCipher Database Connection Opened
                           │
                           ├──────────────────────────────┐
                           ▼ Inactivity Timer (5 mins)    ▼ Manual Lock / Pause
                     [ Zeroize RAM Key Bytes & Close SQLCipher DB Connection ]
```

### 11.1 Key Lifecycle Rules
* **Generation:** On first boot, a secure random 256-bit key is generated on-device.
* **Storage:** The key is encrypted using AES-GCM and stored in SecurePreferences, protected by a hardware-backed key.
* **Usage:** The decrypted key is cached in volatile RAM only as a byte array.
* **Eviction:** The key is zeroized and cleared from memory after 5 minutes of inactivity or when the app is manually locked.

---

## 12. Android Keystore Integration

The master database key is secured using the **Android Keystore System**:

* **Hardware Binding:** Keys are generated inside the device's **TEE (Trusted Execution Environment)** or **StrongBox Keymaster** (if available), ensuring they cannot be extracted from the device even if superuser (root) privileges are obtained.
* **Purpose Constraints:** Key parameters are locked to secure operations (`PURPOSE_ENCRYPT` and `PURPOSE_DECRYPT`) and require user authentication (biometrics) for every decryption request.

---

## 13. PIN Strategy

When biometrics are unavailable or disabled, the user must register a strong 6-digit PIN:

* **PIN Hash Protection:** The PIN is never stored in plaintext. It is hashed using PBKDF2 with HMAC-SHA256, a unique salt, and 100,000 iterations.
* **Randomized PIN Keypad:** The PIN entry screen displays a randomized numeric keypad on every launch, preventing attackers from guessing the PIN based on screen grease patterns or finger tracking.
* **Rate Limiting & Lockout:** The application limits PIN entry to 3 consecutive failed attempts. On the third failure, the application locks out inputs for 1 minute, doubling the lockout duration for subsequent failures to prevent automated brute-force attacks.

---

## 14. Biometric Strategy

Biometric integration leverages the standard Android **BiometricPrompt API**:

* **Biometric Authentication Strength:** The application requires **Class 3 (Strong)** biometrics (e.g., secure fingerprint sensors or 3D facial recognition). Weak biometrics (e.g., standard 2D camera facial recognition) are rejected.
* **Hardware-Backed Validation:** Decrypting the database key requires successful biometric verification, which is validated directly by the hardware TEE before the key is released to volatile RAM.

---

## 15. Backup Encryption Strategy

To prevent data loss, users can manually export password-encrypted backups using **AES-256-GCM**:

```
[ User Input Password ] ──► PBKDF2 (HMAC-SHA256, Random Salt, 100,000 Iterations)
                                  │
                                  ▼ Derives
                            256-bit Encryption Key
                                  │
                                  ▼ Encrypts
         [ JSON Payload Data ] ──► AES-GCM-256 ──► [ Encrypted .bankyar Backup File ]
```

* **Cryptographic Strength:** Backups use AES-GCM with a unique 12-byte initialization vector (IV) and a 16-byte authentication tag to guarantee data integrity and prevent tampering.
* **Brute-Force Protection:** The derivation key uses PBKDF2 with a unique salt and 100,000 iterations, ensuring that exported backups are resilient against offline brute-force attacks.

---

## 16. Restore Verification Strategy

Restoring a backup file completely overwrites the active local database, requiring strict verification checks before execution:

1. **GCM Authentication Tag Check:** The restore service verifies the 16-byte GCM authentication tag. If the tag check fails, the recovery process is aborted, protecting the application from corrupted or modified backup files.
2. **Schema Version Check:** The decrypted backup metadata is analyzed to verify schema compatibility. If the schema version exceeds the active application version, the restore is aborted to prevent database corruption.

---

## 17. Secure Import Strategy

To support manual fallback imports (such as importing CSV files on sandboxed environments like iOS), the import pipeline implements strict security boundaries:

* **Isolate-Based Parsing:** File reading and parsing run in an isolated background thread (Dart Isolate), preventing main-thread blocking and DoS exploits.
* **Input Validation & Sanitization:** All fields parsed from CSV or JSON files are sanitized to remove special characters and control characters, protecting the database from injection attacks.

---

## 18. Secure Export Strategy

When exporting transaction ledgers to CSV or JSON formats, the export engine enforces strict security constraints:

* **Explicit User Intent:** Exports cannot run in the background. They must be explicitly triggered by the user from the settings panel.
* **Private Directory Target:** Exported files are written directly to the application's secure sandboxed directory. The user must use the native OS Share Sheet to copy the file to external storage, ensuring plaintext files are not left on shared directories.

---

## 19. Secure Storage Strategy

The application restricts all persistent storage to secure, sandboxed directories:

* **Zero External Storage Use:** No transaction data, custom notes, or database files are written to shared external storage directories (e.g., SD cards or public documents folders).
* **Excluded Cloud Backups:** To prevent unencrypted database syncs to cloud providers, the application disables automatic system backups by declaring `android:allowBackup="false"` in the Android Manifest.

---

## 20. Memory Protection Strategy

To prevent database keys and plaintext financial variables from being extracted via memory dumps, the memory protection engine implements strict rules:

* **RAM Zeroization:** Cryptographic keys and PIN byte arrays are zeroized (filled with zeros) as soon as they are no longer needed.
* **Immediate RAM Key Eviction:** When the application is sent to the background, an inactivity timer begins. If the timer exceeds 5 minutes, the database key is evicted from RAM, the database connection is closed, and the user is redirected to the lock screen.

---

## 21. Sensitive Data Handling

Sensitive financial variables require careful handling to prevent leaks:

* **No Plaintext String Caching:** Transaction amounts, account numbers, and merchant names are never stored in standard, garbage-collectable string fields. Instead, they are parsed and stored as byte arrays, which can be zeroized immediately.
* **Secure UI Rendering:** Declarative UI widgets read sensitive values directly from active state providers. When the screen is popped, the state is cleared, ensuring sensitive figures do not remain in UI caches.

---

## 22. Logging Security

To maintain user privacy, the local logger enforces strict **PII (Personally Identifiable Information) Scrubbing**:

```
[ Error Event Log Entry ] ──► Logger Sanitizer (Regex filter)
                                    │
                                    ├─► Redacts numeric sequences (Amounts, Card IDs)
                                    ├─► Redacts unparsed SMS texts
                                    ▼
                      [ Secure, PII-Scrubbed Log Text ]
```

* **PII Scrubbing:** The logging utility runs regex filters to detect and redact numeric patterns (e.g., amounts, balances, card indexes) and replaces them with `[REDACTED_NUM]`.
* **Excluded Raw SMS Texts:** Raw SMS texts are never written to diagnostic log files. Only error codes, exception types, and system state metrics are recorded.

---

## 23. Error Handling Security

To protect the application from information leakage, error handling is configured to be secure by default:

* **Sanitized Error Messages:** Detailed technical stack traces and SQL database error codes are caught and sanitized. The UI displays generic, safe error messages to prevent details from being exposed to potential attackers.
* **Secure Exception Mapping:** Technical database exceptions are mapped to clean, domain-specific failures (e.g., `DatabaseCorruptionFailure`), preventing system details from leaking.

---

## 24. Tamper Detection

The application monitors its own integrity to detect and prevent unauthorized modifications:

* **Signature Verification:** On startup, the application verifies its cryptographic signing signature against a hardcoded hash of the official developer key. If the signature does not match, the application terminates immediately.
* **Manifest Validation:** The application verifies key configurations in the Android Manifest (e.g., ensuring `android:debuggable` is disabled and zero network permissions are declared) to detect tampering attempts.

---

## 25. Root Detection Strategy

Operating on rooted devices exposes sandboxed directories to other applications. BankYar implements a multi-tiered root detection strategy:

* **Multi-Indicator Checks:** The root detection engine checks for known root binaries (e.g., `su`), superuser apps (e.g., Magisk), and writable system directories.
* **Graceful Degradation Policy:** If root indicators are detected, the application displays a security warning. Users can choose to bypass the warning and proceed at their own risk, but sensitive features (e.g., biometric unlocking and automated SMS reading) are disabled.

---

## 26. Debug Protection

To prevent attackers from attaching debuggers to analyze execution logic, BankYar implements active debug protections:

* **Anti-Debugging Flags:** The application sets native OS flags to disable debugging in production builds. On Android, `android:debuggable` is set to `false`.
* **Debugger Attachment Detection:** The application monitors debugger connection states during runtime. If a debugger attachment is detected (`isDebuggerConnected()`), the application terminates immediately.

---

## 27. Screenshot Protection

To protect financial details from background spyware and accidental exposure in the task switcher, BankYar implements screenshot protection:

* **FLAG_SECURE Enforcement:** The application sets the `FLAG_SECURE` layout flag on all window structures. This blocks screenshot capture, prevents screen recording, and forces the OS task switcher to render a blank card for the application.

---

## 28. Clipboard Policy

Rogue background applications can monitor clipboard contents to steal copied data. BankYar enforces a secure clipboard policy:

* **Fast-Expiry Clipboard Reads:** When the user utilizes clipboard fallback parsing (FR-1.6), the application reads the clipboard content, extracts the transaction details, and immediately prompts the user to clear the clipboard, protecting copied data from other apps.

---

## 29. Notification Privacy

Parsed transaction notifications displayed in the system tray are configured to protect user privacy:

* **Redacted Lock-Screen Previews:** Notifications are set to `VISIBILITY_PRIVATE`, ensuring that transaction amounts and merchant names are hidden on secure lock screens, and are only visible when the device is unlocked.

---

## 30. Secure Configuration

The application's static configurations are secured using best practices:

* **Obfuscated Build Configurations:** Build configurations and API constants are encrypted and obfuscated at build time.
* **Disabled Network Frameworks:** The compilation configuration explicitly excludes network libraries and HTTP clients, ensuring that even if an attacker attempts to inject network code, the application lacks the underlying libraries to compile.

---

## 31. Dependency Security

Third-party dependencies represent a common vector for security vulnerabilities. BankYar enforces strict dependency rules:

* **Pinned Dependency Versions:** All third-party library versions are pinned inside package manifests (`pubspec.yaml`), preventing automatic updates from pulling unverified or modified dependencies.
* **Security Audits:** Automated vulnerability scanners (e.g., `dart pub token` and `snyk`) run on every build to detect and flag outdated or vulnerable packages.

---

## 32. Supply Chain Security

To protect the application from supply chain compromises, our build pipeline uses verified sources:

* **Verified Dependency Registries:** Dependencies are downloaded exclusively from verified, official registries (e.g., `pub.dev`).
* **Source Code Auditing:** Core security packages (e.g., SQLCipher wrapper and encryption utilities) are audited to verify that no tracking or analytics codes exist.

---

## 33. Update Security

Without internet permissions, BankYar cannot fetch updates directly from a remote server. Update security is managed via official distribution platforms:

* **App Store Verification:** Updates are distributed exclusively through verified app stores (e.g., Google Play Store), which cryptographically verify the developer signature before delivering updates to users.

---

## 34. Parser Security

The on-device parsing engine is designed to handle malformed input safely:

* **Buffer Overflow Prevention:** The parsing engine uses memory-safe Dart string APIs, which are resilient against classic buffer overflow attacks.
* **Heuristic Sandboxing:** If a regex template fails to match, the fallback heuristic parser processes the text in a sandbox, preventing complex inputs from causing execution delays or app crashes.

---

## 35. Regex Safety

Malicious regular expressions can cause severe performance issues (Regular Expression Denial of Service - ReDoS). BankYar prevents this using strict regex guidelines:

* **No Backtracking Patterns:** Regular expressions are audited to ensure they do not contain nested quantifiers (e.g., `(a+)+`), which can cause exponential evaluation times when matched against complex strings.
* **Execution Timeout Limits:** All regex matching operations are configured with strict execution timeout limits (typically 100 milliseconds), aborting evaluations if they exceed limits.

---

## 36. Denial of Service Protection

The application protects itself from performance issues caused by large transaction histories:

* **Constant-Time Pagination:** The ledger uses keyset seek pagination to load transactions, ensuring constant-time queries ($O(1)$) even with 100,000+ historical records.
* **Isolate Isolation:** Heavy tasks, such as bulk CSV imports or backup exports, run in separate background isolates, keeping the main UI thread responsive.

---

## 37. Backup Recovery Security

To protect recovery archives from tampering, the backup recovery pipeline implements multiple verifications:

* **Decryption Password Requirements:** Users must enter their custom backup password. Decryption keys are derived using PBKDF2, protecting archives from offline brute-force attempts.
* **Integrity Validation:** Decrypted data must pass GCM integrity tag checks and schema validation checks before any data is written to the local database, preventing corrupted backups from compromising database state.

---

## 38. Incident Recovery Strategy

In the event of database corruption or file-access failures, the application transitions to a secure recovery state:

```
                  Local Storage / Disk IO Failure
                                │
                                ▼ Catch Exception
                  Run Integrity Verification Checks
                                │
                     ┌──────────┴──────────┐
               Pass Checks           Fail Checks (Corruption)
                     │                     │
                     ▼                     ▼
          Attempt Page Repair       Initialize Fresh Sandbox DB
                                           │
                                           v
                              Disaster Recovery Interface
                              - Prompt user to restore from latest
                                password-encrypted .bankyar backup file.
```

---

## 39. Security Risks

Despite our robust security architecture, several residual risks remain:

* **Risk 1: Unlocked Device Theft:** If a thief steals the device while it is unlocked and the user is actively using the application, the attacker can view transaction details until the inactivity timer (5 minutes) triggers.
* **Risk 2: Operating System Vulnerabilities:** If an attacker exploits zero-day kernel vulnerabilities to bypass Android's sandbox boundaries, they can access the private directories of other apps, including BankYar's databases.

---

## 40. Security Roadmap

The security roadmap defines sequential phases to continually strengthen BankYar's defenses:

* **Phase 1: Native Android Core (Current Target):** Implement SQLCipher page-level encryption, Android Keystore hardware-bound master keys, and standard biometric verification.
* **Phase 2: Advanced Heuristic Sandboxing:** Integrate on-device machine learning tokenizers (e.g., TensorFlow Lite BERT-mini) running in isolated thread sandboxes for high-accuracy fallback parsing.
* **Phase 3: Local Peer-to-Peer Syncing:** Implement localized peer-to-peer data synchronization over secure local networks, allowing users to sync data with a home NAS or private computer without passing through any public cloud.

---

## 41. Threat & Risk Matrix

This matrix categorizes the twenty identified threats, assessing their likelihood, severity, and architectural countermeasures:

| Threat ID | Threat Scenario | Likelihood | Severity | Risk Score | Architectural Countermeasure |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **T-01** | **Lost Device:** Unauthorized physical access. | Medium | High | **High** | Secure entry screen; `FLAG_SECURE` task previews; automatic lockouts. |
| **T-02** | **Stolen Device:** Forensic extraction of flash chips. | Low | Critical | **High** | SQLCipher page-level AES-256 encryption. Master key stored in Keystore (TEE). |
| **T-03** | **Rooted Device:** Compromised operating system. | Medium | High | **High** | Multi-indicator root check warnings; disable biometric key releases. |
| **T-04** | **Debugging:** Hooking instrumentation frameworks. | Low | High | **Medium** | production flags disable debug; debugger connection termination. |
| **T-05** | **Memory Dump:** Cold-boot RAM extraction. | Low | High | **Medium** | Zeroization of key bytes; RAM key eviction on 5 mins inactivity. |
| **T-06** | **Database Theft:** Copying the SQLite database. | Medium | Critical | **High** | SQLCipher page-level AES-256-CBC page encryption. |
| **T-07** | **Backup Theft:** Intercepting backup files. | Medium | High | **High** | PBKDF2 key derivation with 100,000 iterations and AES-GCM-256 backup encryption. |
| **T-08** | **Fake SMS:** Injecting spoofed cellular texts. | Medium | Low | **Low** | Validate caller identity; deduplication hash checks. |
| **T-09** | **SMS Replay:** Re-injecting historical transaction texts. | Low | Low | **Low** | Deduplication hash verification on `sms_records` indexed tables. |
| **T-10** | **Template Tampering:** Modifying matching rules. | Low | Medium | **Low** | Read-only pre-packaged templates; signature checks on custom QR imports. |
| **T-11** | **Parser Manipulation:** Executing arbitrary exploits. | Low | High | **Medium** | Safe Dart string handling APIs; isolate-isolated fallback parsers. |
| **T-12** | **Privilege Escalation:** Bypassing sandboxes. | Low | Critical | **High** | Hardware-backed key isolation inside the Keystore TEE. |
| **T-13** | **Dependency Compromise:** Malicious package codes. | Medium | High | **High** | Pinned dependency versions; automated vulnerability scanners. |
| **T-14** | **Malicious Accessibility Services:** Screen scraping. | High | High | **High** | Block app interaction if untrusted accessibility services are active. |
| **T-15** | **Overlay Attacks:** Clickjacking input screens. | High | Medium | **High** | Enforce overlay prevention flags; custom scrambled input PIN view. |
| **T-16** | **Notification Snooping:** Reading tray notifications. | Medium | Medium | **Medium** | Set `VISIBILITY_PRIVATE` to hide notifications on secure lock screens. |
| **T-17** | **Screen Recording:** Capturing background video. | Medium | High | **High** | Set `FLAG_SECURE` layout flags on all window structures. |
| **T-18** | **Shoulder Surfing:** Visual observation of screens. | High | Low | **Medium** | Obfuscated numeric entry fields; masked ledger totals. |
| **T-19** | **Social Engineering:** Tricking users to scan malicious QR rules.| Medium | Medium | **Medium** | Sanity-checks and confirmation dialogs on rules configurations. |
| **T-20** | **Future Cloud Risks:** API or transport vulnerabilities. | Low | High | **Medium** | Strict TLS pinning; certificate validation; multi-factor authorization. |

---

## 42. Architectural Decision Records (SADR)

The security architecture of BankYar is governed by five core Security Architectural Decision Records:

### SADR-001: SQLCipher Page-Level Encryption
* **Status:** Approved
* **Context:** Financial transaction records require strict transactional guarantees (ACID) and robust encryption.
* **Decision:** SQLite encrypted at rest using SQLCipher.
* **Rationale:** Relational tables are ideal for search, filtering, and running complex offline aggregations. SQLCipher provides audited, page-level AES-256 encryption, ensuring database files copied directly off disk are unreadable.

### SADR-002: Keystore Hardware Binding
* **Status:** Approved
* **Context:** Plaintext keys must never reside on non-volatile storage.
* **Decision:** Store the master database key wrapped inside `flutter_secure_storage` (which binds directly to Android Keystore and iOS Secure Enclave).
* **Rationale:** Hardware-backed key storage ensures that keys cannot be extracted from the device even if superuser (root) privileges are obtained.

### SADR-003: Memory Key Eviction & Inactivity Timeout
* **Status:** Approved
* **Context:** Plaintet database keys cached in memory are vulnerable to RAM dumps or inspection.
* **Decision:** Evict database keys from RAM and close connection pools after 5 minutes of background inactivity.
* **Rationale:** This reduces the window of vulnerability for devices stolen or seized while the application is in the background.

### SADR-004: FLAG_SECURE Screenshot Protection
* **Status:** Approved
* **Context:** Spyware can capture screenshot streams, and system task switchers cache plaintext transaction figures.
* **Decision:** Enforce `FLAG_SECURE` layout flags on all window structures.
* **Rationale:** This blocks screenshots and screen recording, and forces the OS task switcher to render a blank card for the application, protecting user privacy.

### SADR-005: AES-GCM Backup Encryption with PBKDF2
* **Status:** Approved
* **Context:** Exported backups must be resilient against tampering and offline brute-force attacks.
* **Decision:** Encrypt backups using AES-256-GCM, with keys derived using PBKDF2, HMAC-SHA256, and a unique salt.
* **Rationale:** GCM guarantees backup integrity, and PBKDF2 with 100,000 iterations protects archives from offline brute-force attempts.

---

## 43. Security Checklists

The following checklists serve as security gates that must be satisfied before code modifications are merged:

### 43.1 Build & Manifest Checklist
- [ ] Ensure `android.permission.INTERNET` is completely absent from `AndroidManifest.xml` and no network request libraries are introduced.
- [ ] Confirm `android:allowBackup` is set to `false` in the manifest to prevent unencrypted cloud backups.
- [ ] Verify `android:debuggable` is set to `false` in production build configurations.
- [ ] Ensure `FLAG_SECURE` layout flags are active on all app windows.

### 43.2 Cryptography & Key Management Checklist
- [ ] Confirm no cryptographic keys, PIN hashes, or salt values are hardcoded in source code files.
- [ ] Verify that database keys are stored exclusively in hardware-backed storage (Keystore/Enclave).
- [ ] Ensure that keys and PIN byte arrays are zeroized immediately after usage.
- [ ] Confirm backup encryption derives keys using PBKDF2 with a minimum of 100,000 iterations.

---

## 44. Trade-off Analysis

Every security decision involves balancing multiple priorities. Below is the justification for the trade-offs made in BankYar's architecture:

### 1. Zero Network Access vs. Automated Template Updates
* **The Choice:** Zero Network Access.
* **Trade-off Analysis:** Restricting internet access prevents the application from fetching updated parsing templates from a remote server, meaning users must manually scan QR codes or update the app to receive new templates. However, this trade-off is necessary to deliver an absolute guarantee of 100% data privacy and zero cloud dependencies, which is our core value proposition.

### 2. Immediate RAM Key Eviction vs. Seamless User Resume
* **The Choice:** Key Eviction after 5 minutes of background inactivity.
* **Trade-off Analysis:** Evicting keys forces users to re-authenticate with biometrics or PINs if they return to the app after 5 minutes, adding minor friction. However, this significantly reduces the risk of memory dumps on stolen devices, prioritizing security over convenience.

### 3. FTS5 Virtual Search Tables vs. Storage Footprint
* **The Choice:** FTS5 Virtual Tables.
* **Trade-off Analysis:** FTS5 virtual tables increase the database file size by approximately 15% due to duplicated text indexes. However, this trade-off is necessary to deliver sub-200ms search results over large transaction histories, satisfying our usability requirements.

---
**End of Security & Privacy Architecture Specification**
