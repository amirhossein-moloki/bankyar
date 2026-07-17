# BankYar Configuration, Environment, and Build Architecture Specification

**Project Name:** BankYar
**Classification:** Enterprise Architecture Specification (Restricted)
**Document Version:** 1.0.0
**Authors:** Principal Software Architect, DevOps Architect & Mobile Platform Engineer
**Status:** Approved / Architecture Baseline

---

## Executive Summary

BankYar is an offline-first, highly secure mobile application designed to capture, parse, and analyze banking SMS messages on-device with zero network overhead. Because BankYar mandates absolute privacy, its configuration, environment, and build system must be structured with extreme predictability, high security, and clear separation of concerns.

This specification defines the complete **Configuration, Environment, and Build Architecture** for the BankYar application. It provides an enterprise-grade framework for managing multiple builds, environment variables, feature flags, local secrets, database configurations, and asset variations. It outlines the transition from a 100% offline local development state to future cloud-synchronized and enterprise-white-labeled architectures. Designed with AI-assisted development in mind, this document establishes strict schemas, naming conventions, and validation systems so that both humans and automated agents can scale the application without architectural drift.

---

## Table of Contents
1. [Configuration Philosophy](#1-configuration-philosophy)
2. [Environment Strategy](#2-environment-strategy)
3. [Build Variants](#3-build-variants)
4. [Configuration Layers](#4-configuration-layers)
5. [Runtime Configuration](#5-runtime-configuration)
6. [Compile-time Configuration](#6-compile-time-configuration)
7. [Feature Flags](#7-feature-flags)
8. [Environment Variables](#8-environment-variables)
9. [Secrets Management Strategy](#9-secrets-management-strategy)
10. [Application Metadata](#10-application-metadata)
11. [Versioning Strategy](#11-versioning-strategy)
12. [Build Number Strategy](#12-build-number-strategy)
13. [Flavor Strategy](#13-flavor-strategy)
14. [Asset Configuration](#14-asset-configuration)
15. [Localization Configuration](#15-localization-configuration)
16. [Theme Configuration](#16-theme-configuration)
17. [Logging Configuration](#17-logging-configuration)
18. [Security Configuration](#18-security-configuration)
19. [Database Configuration](#19-database-configuration)
20. [Parser Configuration](#20-parser-configuration)
21. [Notification Configuration](#21-notification-configuration)
22. [Backup Configuration](#22-backup-configuration)
23. [Performance Configuration](#23-performance-configuration)
24. [Debug Configuration](#24-debug-configuration)
25. [Release Configuration](#25-release-configuration)
26. [Testing Configuration](#26-testing-configuration)
27. [Future Remote Configuration](#27-future-remote-configuration)
28. [Migration Strategy](#28-migration-strategy)
29. [Configuration Validation](#29-configuration-validation)
30. [Risks & Trade-offs](#30-risks--trade-offs)
31. [Architectural Decision Records (CADR)](#31-architectural-decision-records-cadr)

---

## 1. Configuration Philosophy

The BankYar Configuration Philosophy is built upon five architectural pillars designed to guarantee stability, security, and developer velocity:

* **Offline-First Predictability:** Configurations must never depend on active network calls to resolve on boot. The fallback behavior for every parameter must be completely deterministic, resolving to secure local defaults.
* **Strict Immobility (Compile-time Determinism):** Configurations that define environments, API stubs, security features, and native build variables must be frozen at compile time, eliminating the risk of runtime environment injection attacks.
* **Hermetic Environment Isolation:** Different environments (e.g., Development, QA, Production) must be strictly isolated. No configuration parameters, assets, or databases can leak across environment boundaries.
* **Declarative and Strongly Typed:** Configuration values must not be accessed via arbitrary string-lookup maps (such as raw JSON keys or raw dictionary lookups). They must resolve to immutable, strongly typed Dart configuration models injected through Riverpod dependency containers.
* **AI-Assisted Friendliness:** Configuration structures, validation rules, and feature flags must use highly structured schemas, descriptive variable names, and explicit validation scripts. This allows automated coding agents to safely add, modify, and verify parameters without breaking existing systems.

---

## 2. Environment Strategy

BankYar defines **eight distinct environments** to support the full lifecycle of a secure, enterprise-grade mobile application. Each environment serves a specific role in development, quality assurance, distribution, and future business models:

1. **Development (`dev`):** Used for daily local engineering. Emphasis is placed on rapid compile times, verbose local logging, mock SMS injectors, and unlocked debugger access.
2. **Local Testing (`local_test`):** A specialized environment dedicated to local automated unit, integration, and widget testing. It utilizes completely mock data sources and bypasses hardware-bound biometrics for automated environments.
3. **QA (`qa`):** Dedicated to manual and automated quality assurance. Contains simulated transaction data streams, high logging verbosity, and testing diagnostic menus, but operates within the locked application sandbox.
4. **Internal Testing (`internal`):** Used for internal alpha testing among developers, product managers, and internal stakeholders. Distributed via private internal testing tracks (e.g., Google Play Console Internal Track).
5. **Beta (`beta`):** Used for public pre-release testing. Distributed to a subset of real-world users. Operates with production-level security settings, but retains safe diagnostic telemetry (manually exported by users) to track parsing drifts.
6. **Production (`prod`):** The standard consumer release. Hardened with maximum security, active obfuscation, disabled debugging ports, and strict biometric-bound database unlocking. 100% offline with zero network declarations.
7. **Future Staging (`staging`):** Configured to support testing of future cloud-synchronization, secure peer-to-peer syncing, and hybrid backend connections before they are deployed to production.
8. **Future Enterprise (`enterprise`):** A white-labeled environment designed to support distribution to corporate partners. Allows customized brand themes, specific pre-configured bank parsing regexes, and integration with enterprise identity providers.

### Environment Specification Matrix

| Parameter / Capability | Development (`dev`) | Local Testing (`test`) | QA (`qa`) | Internal (`internal`) | Beta (`beta`) | Production (`prod`) | Future Staging (`staging`) | Future Enterprise (`enterprise`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Internet Access** | Forbidden | Forbidden | Forbidden | Forbidden | Forbidden | Forbidden | Allowed (Future Sync) | Optional (Intranet) |
| **Mock SMS Injector** | Active | Active | Active | Disabled | Disabled | Disabled | Disabled | Disabled |
| **Logging Level** | Verbose | Warning | Debug | Info | Warning | Error Only | Info | Info |
| **Developer Menu** | Enabled | Disabled | Enabled | Enabled | Disabled | Disabled | Disabled | Disabled |
| **Security (FLAG_SECURE)**| Disabled | Disabled | Enabled | Enabled | Enabled | Enabled | Enabled | Enabled |
| **Biometric Bypass** | Allowed | Allowed (Mock) | Disabled | Disabled | Disabled | Disabled | Disabled | Disabled |
| **DB Encryption** | Enabled | Mock/RAM | Enabled | Enabled | Enabled | Enabled | Enabled | Enabled |
| **Database Key Source** | Mock / Hard | Mock | Keystore | Keystore | Keystore | Keystore (TEE) | Keystore (TEE) | Keystore (Enclave) |
| **Code Obfuscation** | Disabled | Disabled | Enabled | Enabled | Enabled | Enabled | Enabled | Enabled |
| **Verification Level** | Minimal | Standard | Strict | Strict | Hardened | Extreme | Extreme | Hardened |

---

## 3. Build Variants

To support the environments outlined above, the build architecture defines a structured mapping of **Flavors** and **Build Types** (Build Profiles). This matrix is translated natively by the platform build systems (Gradle on Android, Xcode Build Schemes on iOS) and Flutter's compilation engine.

```
       ┌────────────────────────────── Flavors ──────────────────────────────┐
       │     dev     │  test/qa  │   internal   │  beta/prod  │  enterprise  │
┌──────┼─────────────┼───────────┼──────────────┼─────────────┼──────────────┤
│Debug │   devDebug  │  qaDebug  │  internalDbg │     N/A     │  entDebug    │
├──────┼─────────────┼───────────┼──────────────┼─────────────┼──────────────┤
│Profile│     N/A     │ qaProfile │  internalProf│ prodProfile │  entProfile  │
├──────┼─────────────┼───────────┼──────────────┼─────────────┼──────────────┤
│Release│  devRelease │ qaRelease │  internalRel │ prodRelease │  entRelease  │
└──────┴─────────────┴───────────┴──────────────┴─────────────┴──────────────┘
```

### Build Type / Profile Responsibilities
* **Debug (`debug`):** Optimized for development. Enables Dart observatory service (VM Service), hot reload, asserts, and detailed debugging logs. Obfuscation is disabled.
* **Profile (`profile`):** Configured to analyze application performance. Retains enough debugging information to populate performance timelines and trace frame-drops, but runs near release speed. Obfuscation is disabled.
* **Release (`release`):** Optimized for distribution. Enables tree-shaking, aggressive code compression, native compilation optimization, ProGuard/R8 shrinking, and strict resource obfuscation. Debugging ports are permanently locked.

---

## 4. Configuration Layers

BankYar resolves configuration parameters through a hierarchical, layered approach. This structure ensures that compile-time constants, runtime user inputs, and local storage variables resolve predictably:

```
                  ┌──────────────────────────────────────────────┐
                  │          Layer 1: Compile-time               │
                  │  - Environment flags (--dart-define)         │
                  │  - App Flavor, Package ID, Build Profile      │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼ Inherits / Customizes
                  ┌──────────────────────────────────────────────┐
                  │          Layer 2: Static Assets              │
                  │  - JSON Rules (bundled by flavor)            │
                  │  - Localization files, Visual asset paths    │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼ Validates / Overrides
                  ┌──────────────────────────────────────────────┐
                  │          Layer 3: Local Storage              │
                  │  - Decrypted SharedPreferences               │
                  │  - SQLCipher config parameters               │
                  └──────────────────────┬───────────────────────┘
                                         │
                                         ▼ Resolves / Overrides
                  ┌──────────────────────────────────────────────┐
                  │          Layer 4: User/Runtime               │
                  │  - Dynamic feature toggles                   │
                  │  - Custom regular expression overrides       │
                  │  - In-app preference modifications           │
                  └──────────────────────────────────────────────┘
```

1. **Layer 1: Compile-time Constants:** Set during compile-time using command-line variables or build scripts. Defines the hard boundaries of the build (e.g., whether the debugger is compile-time stripped).
2. **Layer 2: Static Local Assets:** Immutable files bundled directly inside the application archive (APK/IPA). These contain static localization strings, built-in bank templates, and theme parameters.
3. **Layer 3: Local Secure Preferences:** Editable key-value states stored in local storage, encrypted via AES-256-GCM. Stores settings like "Is Biometric Auth Enabled" or "Diagnostic Level Preference".
4. **Layer 4: Runtime/Database Configurations:** Dynamic data stored in the encrypted SQLCipher database, such as custom parsing templates or custom user-defined merchant category matching rules.

---

## 5. Runtime Configuration

At runtime, the application state is governed by a unified configuration model. Instead of reading scattered global files, runtime configurations are centralized and managed using **Riverpod Providers**:

```
 ┌────────────────────────────────────────────────────────────────────────┐
 │                      appRuntimeConfigProvider                          │
 │  - Initializes dependencies asynchronously during startup.             │
 │  - Reads compile-time variables.                                       │
 │  - Unlocks and reads local Secure Preferences.                         │
 │  - Merges database configurations after Keystore verification.        │
 └───────────────────────────────────┬────────────────────────────────────┘
                                     │
                 ┌───────────────────┼───────────────────┐
                 ▼                   ▼                   ▼
     ┌───────────────────────┐ ┌───────────┐ ┌───────────────────────────┐
     │  securityConfig       │ │ parserCfg │ │     analyticsConfig       │
     │  - Lockout limits     │ │ - Regex   │ │  - Timeframe bounds       │
     │  - Retention window   │ │   timeout │ │  - Asset tracking         │
     └───────────────────────┘ └───────────┘ └───────────────────────────┘
```

### Runtime Initialization Lifecycle
1. **Engine Warmup:** The Flutter bindings are initialized. The static compile-time constants are parsed into a strongly typed `CompileTimeConfig` entity.
2. **Bootstrap Security:** The Keystore/Enclave wrapper is initialized. The application attempts to verify hardware signature boundaries.
3. **Decrypt Secure Storage:** `SecureStorageRepository` reads encrypted runtime configurations (e.g., authentication preferences and theme states).
4. **Database Verification & Lock Release:** The user authenticates with biometric/PIN. The decrypted key unlocks SQLCipher, which loads custom user-defined rules and parsing templates.
5. **State Exposure:** Riverpod projects the unified `AppConfig` state to the presentation widgets. The UI reacts to the parsed configurations, locking down or showing panels instantly based on current permissions.

---

## 6. Compile-time Configuration

Compile-time parameters are injected into the Dart environment during compilation using `--dart-define` or `--dart-define-from-file`. This mechanism ensures that environment properties are embedded directly into the binary, preventing environment spoofing attacks on rooted devices.

### Compile-time Keys Schema
* `BY_APP_FLAVOR`: Defines the active flavor (`dev`, `qa`, `internal`, `beta`, `prod`, `enterprise`).
* `BY_BUILD_ID`: A unique identifier tracing the compilation back to a specific build runner instance.
* `BY_DIAGNOSTICS_ENABLED`: Compile-time flag to permanently strip or preserve logging components.
* `BY_SCREENSHOT_PROTECTION`: Absolute compile-time override to enforce window flag constraints.
* `BY_OFFLINE_BYPASS`: Used in `local_test` variant to bypass hardware dependencies during CI loops.

By mapping these keys directly to a strongly typed Dart configuration class (`BYCompileTimeConfig`), the compiler can optimize dead-code pathways:

```dart
// Compile-time Dead-Code Elimination Example (Conceptual)
const bool isDiagnosticsActive = bool.fromEnvironment('BY_DIAGNOSTICS_ENABLED', defaultValue: false);

if (isDiagnosticsActive) {
  // Compiler retains logging codes
  _initializeLoggingEngine();
} else {
  // Compiler strips code block entirely from Release build
}
```

---

## 7. Feature Flags

Feature Flags control the exposure of experimental or environment-specific features. To guarantee stability and prevent security leaks, BankYar classifies feature flags into two categories:

1. **Compile-time Flags:** Static boundaries checked during compilation. If a flag is disabled, its code path is pruned by the compiler, ensuring that unreleased features (like future cloud sync components) do not exist inside the production binary.
2. **Runtime Flags:** Dynamically parsed parameters controlled via local secure configurations or the Developer Menu (only in `dev` and `qa` environments). Allows on-device testing of new capabilities.

### Feature Flag Matrix

| Feature Flag Identifier | Type | `dev` | `qa` | `internal` | `beta` | `prod` | `staging` | `enterprise` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| `FLAG_EXPERIMENTAL_FEATURES` | Runtime | ON | ON | OFF | OFF | OFF | OFF | OFF |
| `FLAG_AI_FEATURES` | Compile | ON | ON | ON | ON | ON | ON | ON |
| `FLAG_CLOUD_SYNC` | Compile | OFF | OFF | OFF | OFF | OFF | ON | OFF |
| `FLAG_NOTIFICATION_LISTENER`| Compile | ON | ON | ON | ON | ON | ON | ON |
| `FLAG_BACKUP` | Runtime | ON | ON | ON | ON | ON | ON | ON |
| `FLAG_IMPORT` | Runtime | ON | ON | ON | ON | ON | ON | ON |
| `FLAG_EXPORT` | Runtime | ON | ON | ON | ON | ON | ON | ON |
| `FLAG_PARSER_RULES` | Runtime | ON | ON | ON | ON | ON | ON | ON |
| `FLAG_PERFORMANCE_TOOLS` | Runtime | ON | ON | ON | OFF | OFF | ON | OFF |
| `FLAG_DEBUG_TOOLS` | Compile | ON | ON | ON | OFF | OFF | OFF | OFF |
| `FLAG_DEVELOPER_MENU` | Compile | ON | ON | OFF | OFF | OFF | OFF | OFF |
| `FLAG_FUTURE_MODULES` | Compile | OFF | OFF | OFF | OFF | OFF | OFF | OFF |

---

## 8. Environment Variables

Environment variables manage non-secret system metadata. They are injected during build time and mapped to a strongly-typed configuration class.

### Environment Variable Dictionary

```
BY_VAR_APP_TITLE=BankYar
BY_VAR_SUPPORT_EMAIL=support@bankyar.local
BY_VAR_RETENTION_DAYS_DEFAULT=90
BY_VAR_MAX_LOG_SIZE_MB=2
BY_VAR_REGEX_TIMEOUT_MS=100
BY_VAR_BACKUP_VERSION_SCHEMA=1.0.0
BY_VAR_DEDUPLICATION_WINDOW_SEC=3600
```

### Environment Variable Injection Pipeline
1. **Config Read:** The build runner reads the `.json` or environment file corresponding to the target flavor (e.g., `config_prod.json`).
2. **Build Injection:** The runner converts configurations to `--dart-define` key-value pairs during compile-time.
3. **Runtime Asset Mapping:** The application maps variables to the immutable `EnvironmentVariables` configuration entity.

---

## 9. Secrets Management Strategy

Because BankYar operates with a strict **zero-network footprint** in its standard consumer release, managing secrets requires high local security. Secrets must never be stored in plaintext inside the source repository or build configurations.

### Secret Isolation & Provisioning Architecture
* **No Git Commits:** Plaintext secrets files (such as local encryption salts, obfuscation keys, or signing keys) are added to `.gitignore` and are managed through environment variables or secure credential managers (e.g., Vault, 1Password CLI) on development machines and build runners.
* **Separation by Environment:** Developer keys (e.g., dev local DB encryption salts) must be completely distinct from production keys. Production signing keys and production local salts are provisioned only during the final release build run on an isolated build agent.
* **Hardware-Backed Wrapping:** Any static runtime secrets (such as localized signature verification constants or QR configuration salts) are encrypted at build time and decrypted during runtime using keys stored in the device's **hardware-backed Keystore/Secure Enclave**.
* **Zeroization:** In-memory secrets are stored in secure byte arrays and zeroized immediately after usage.

---

## 10. Application Metadata

Application Metadata defined in platform manifests must be configured uniquely per build variant. This prevents multi-environment collision and provides clear environment identification.

### Metadata Definition Matrix

| Parameter / Manifest | `dev` | `qa` / `internal` | `beta` / `prod` | `enterprise` |
| :--- | :---: | :---: | :---: | :---: |
| **Application ID (Android)**| `ir.bankyar.app.dev` | `ir.bankyar.app.qa` | `ir.bankyar.app` | `ir.bankyar.app.enterprise` |
| **Bundle ID (iOS)** | `ir.bankyar.dev` | `ir.bankyar.qa` | `ir.bankyar` | `ir.bankyar.enterprise` |
| **App Name Label** | `BankYar Dev` | `BankYar QA` | `BankYar` | `BankYar Enterprise` |
| **Manifest Permissions** | SMS, Biometrics | SMS, Biometrics | SMS, Biometrics | Biometrics Only (Default) |
| **Cleartext Traffic Allowed**| True (Localhost only) | False | False | False |
| **AllowBackup Flag** | `false` | `false` | `false` | `false` |

---

## 11. Versioning Strategy

BankYar follows the **Semantic Versioning 2.0.0 (SemVer)** standard. App versions represent the precise scope of functionality and coordinate with the database schema versioning:

$$\text{Format: } \mathbf{MAJOR.MINOR.PATCH}$$

* **MAJOR:** Increment when structural, backward-incompatible changes are made to the core database schemas, migration structures, or major system architectures.
* **MINOR:** Increment when new offline-first features are added (e.g., adding localized heuristic modules or custom QR scan imports) in a backward-compatible manner.
* **PATCH:** Increment when backwards-compatible bugs, parsing regular expressions, or security patches are resolved.

### Build Metadata Mapping
To differentiate build tracks in logs and diagnostics, pre-release tags and build numbers are appended to the version string:
* Development build: `1.0.0-dev.453`
* QA testing build: `1.0.0-qa.12+3042`
* Production stable release: `1.0.0+3120`

---

## 12. Build Number Strategy

The application Build Number is a monotonically increasing integer that is unique for every build. To ensure that build numbers are unique across various build pipelines and flavors, BankYar implements a **Coordinate Indexing Scheme**:

$$\mathbf{\text{Build Number} = (FlavorID \times 10^7) + (YYMMDD \times 10) + BuildSequence}$$

### Parameters:
1. **FlavorID (1 digit):**
   - `dev` = 1
   - `qa` / `internal` = 2
   - `beta` / `prod` = 3
   - `enterprise` = 4
2. **Date Code (6 digits):** `YYMMDD` representing the date of the build (e.g., `251015` for October 15, 2025).
3. **Build Sequence (1 digit):** A daily incremental counter representing the build run sequence (0 to 9).

*Example Build Number:* A production build (`3`) generated on October 15, 2025 (`251015`) as the first build of the day (`1`) resolves to build number `32510151`.

This strategy guarantees unique build numbers across all build runners, supports sorting, and allows developer teams to immediately identify the compilation date and flavor directly from crash logs.

---

## 13. Flavor Strategy

Flavors allow the compilation of distinct variants of the application using the same codebase. BankYar utilizes standard native build dimensions to map flavors to execution directories:

```
                      ┌─────────────────────────┐
                      │    Shared Dart Code     │
                      │  (lib/core, lib/feats)  │
                      └────────────┬────────────┘
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         ▼                         ▼                         ▼
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│   dev Flavor    │       │   prod Flavor   │       │   ent Flavor    │
│  - Dev assets   │       │  - Prod assets  │       │  - Ent assets   │
│  - Mock services│       │  - Zero network │       │  - White label  │
└─────────────────┘       └─────────────────┘       └─────────────────┘
```

### Flavor Selection Architecture
* **Android Product Flavors:** Configured inside the main app configuration to define distinct dimensions: `dev`, `qa`, `prod`, `enterprise`.
* **iOS Build Schemes:** Configured as distinct build schemes pointing to environment configuration property lists (plist), controlling the output bundle signatures.
* **Main Entry Target Routing:**
  - `dev` entry: `lib/main_dev.dart`
  - `qa` entry: `lib/main_qa.dart`
  - `prod` entry: `lib/main_prod.dart`
  - `enterprise` entry: `lib/main_enterprise.dart`

---

## 14. Asset Configuration

Assets are packaged selectively based on the target flavor to reduce the application installation footprint:

* **Flavor-Specific Asset Directories:** Asset paths are split inside structural folders:
  - `assets/dev/`: Includes test data sets, mock SMS files, and testing templates.
  - `assets/prod/`: Includes production bank configuration JSON profiles and clean icons.
  - `assets/enterprise/`: Includes brand-specific logos and corporate styling configurations.
* **Manifest Injection:** Custom build scripts parse the target flavor during compilation and pack only the matching asset directories into the asset bundle, preventing test mock data from leaking into production.

---

## 15. Localization Configuration

Localization utilizes standard Flutter l10n localization patterns. For our offline architecture:

* **Strict Local Bundling:** Translation resources (ARB files) are compiled to Dart classes at build-time.
* **System-Based Locale Auto-Resolution:** On launch, the application reads the system locale (via `PlatformDispatcher`). If the locale matches supported targets (e.g., Farsi, English), it sets the matching localization context.
* **No Over-The-Air Translations:** To maintain zero-network stability, translation updates are distributed solely through application store packages, preventing dynamic code execution issues.

---

## 16. Theme Configuration

The Design Token System abstracts colors, typography, shapes, and layouts into platform-independent JSON tokens.

* **Mode Variations:** Light, Dark, and High-Contrast (Accessibility) themes are pre-configured.
* **Dynamic White-Label Theme Override:** In the `enterprise` flavor, the theme provider evaluates runtime parameters. If an enterprise configuration file is present, the app overrides standard tokens (e.g., corporate colors, brand typeface) dynamically during initialization, preserving the core architecture.

---

## 17. Logging Configuration

Logging configurations are strictly bound to build variants to prevent data leaks:

* **Logging Levels:**
  - `dev` / `qa`: Verbose level active. Prints exceptions, DB queries, UI states, and performance metrics.
  - `prod`: Error only. Suppresses all trace logs, database queries, and system state transitions.
* **PII Scrubbing Enforcer:** For any logging engine enabled (even local file systems), the PII filter is enabled by default. It replaces numbers and merchant patterns with `[REDACTED_NUM]`, as defined in `LOGGING_ARCHITECTURE.md`.
* **Log Rotation Constraints:** File-based logging is size-capped. When a log file reaches 2MB, it rotates. Only the 3 most recent rotations are kept, ensuring that logs do not consume device storage.

---

## 18. Security Configuration

Security configurations define the local trust and encryption parameters of the application:

* **Master Key Derivation Iterations:** Sets the iteration count for key derivation:
  - `dev` / `test` = 1,000 iterations (optimized for speed).
  - `prod` / `enterprise` = 100,000 iterations (maximum security).
* **Biometric Expiry Window:** Set to 5 minutes (300 seconds). If the application remains in the background longer than this window, keys are purged from volatile memory, requiring re-authentication.
* **Screenshot & Task Preview Protection:** In `prod` and `enterprise` environments, native window flags are enforced (`FLAG_SECURE`), rendering screens black in multitasking views.

---

## 19. Database Configuration

SQLCipher database configurations are tuned to maximize performance and security:

* **Page Size Configuration:** Explicitly configured to 4096 bytes to match standard mobile flash storage block sizes, minimizing storage read-write amplification.
* **Cache Size:** Allocated to 2000 pages (~8MB RAM cache pool), ensuring that searching and paging operations remain responsive.
* **Write-Ahead Logging (WAL):** Enabled to allow read operations to execute concurrently with background writes (such as incoming background SMS insertions) without blocking.
* **Auto-Vacuum Mode:** Set to `INCREMENTAL` to reclaim space on transaction deletion without causing write spikes.

---

## 20. Parser Configuration

The parser configuration controls the limits and regex constraints of the on-device text processing pipeline:

```
 ┌─────────────────────────────────────────────────────────┐
 │                      smsParserConfig                    │
 ├─────────────────────────────────────────────────────────┤
 │  - deduplicationWindowSeconds: 3600                     │
 │  - regexExecutionTimeoutMilliseconds: 100               │
 │  - heuristicFallbackThreshold: 0.75                     │
 │  - maximumSmsTextLengthCharacters: 1000                 │
 └─────────────────────────────────────────────────────────┘
```

* **Execution Timeout:** Regular expressions execution is hard-capped at 100ms. If a match operation exceeds this limit, the parser aborts, logged as an unparsed exception, to protect the application from Regular Expression Denial of Service (ReDoS) attacks.
* **Maximum Text Length:** Direct input string limits are set to 1000 characters. Input strings exceeding this length are truncated at the boundary before passing to regex match pools.

---

## 21. Notification Configuration

System tray notifications are pre-configured to ensure privacy:

* **Notification Channel Structure:**
  - Channel: `bankyar_parser_channel` (High importance, system sounds active for real-time transaction ingestion).
  - Channel: `bankyar_system_channel` (Medium importance, system warnings).
* **Visibility Control:** Configured to `NotificationCompat.VISIBILITY_PRIVATE`. On locked devices, notification previews read "New Transaction Parsed", hiding the amount and merchant details until the device is unlocked.

---

## 22. Backup Configuration

Backups are user-controlled and are configured for portability:

* **Encryption Protocol:** AES-256-GCM using keys derived via PBKDF2 with 100,000 iterations and a random salt.
* **Directory Constraints:** Write operations are restricted to the application's secure sandbox directory (`getApplicationDocumentsDirectory()`). Direct exports to public folders are forbidden.
* **File Header Schema:** Backup files contain a 128-byte unencrypted header containing:
  - Encryption algorithm signature (`BY-AESGCM-256`).
  - Schema version integer (`BY-V1`).
  - Iteration count (`100000`).
  - PBKDF2 Salt bytes.

This header allows the import utility to verify compatibility before initiating decryption.

---

## 23. Performance Configuration

Performance configurations optimize device resources and avoid UI thread blocks:

* **Isolate Pool Allocation:** Heavily intensive tasks (e.g., parsing bulk historical statements or executing backup encryption) are processed in dedicated background isolates.
* **Page Loading Limits:** Keyset seek pagination is limited to 50 records per page.
* **RAM Asset Caching:** Keeps a maximum of 10 compiled regular expression patterns in the active parser cache pool, lazy-loading additional templates on demand.

---

## 24. Debug Configuration

The Debug Configuration is exclusive to `dev` and `qa` environments:

* **Mock SMS Broadcaster:** Exposes an in-app utility to simulate incoming bank messages (e.g., credit/debit alerts) to test parser templates.
* **Database Inspector Tool:** Exposes an in-app visual representation of local database tables, letting developers inspect SQL records directly.
* **Simulated Latency:** Allows developers to simulate slow database writes and slower parse iterations to test UI loading states and animation smoothness.

---

## 25. Release Configuration

Release builds are hardened to prevent tampering and reverse engineering:

* **Code Obfuscation:** Enabled using Flutter’s `--obfuscate` flag, replacing class names, variable identifiers, and method names with non-descriptive tokens.
* **Native Shrinking:** Configured with ProGuard/R8 to strip unused Java and Kotlin classes.
* **Disabled Developer Tools:** Rebuilds compilation chains to strip the Dart VM Service, debugging hooks, and developer logging bridges.

---

## 26. Testing Configuration

Testing configurations guarantee stable and hermetic testing environments:

* **Database Mocking:** In `local_test` builds, SQLCipher is configured to use in-memory SQLite storage (`:memory:`), ensuring that tests are isolated, run in constant time, and leave no database files on disk.
* **Provider Overrides:** Riverpod providers are pre-configured to allow dynamic mock overrides during integration tests:

```dart
// Mocking data sources inside integration tests (Conceptual)
final container = ProviderContainer(
  overrides: [
    secureStorageProvider.overrideWithValue(MockSecureStorage()),
    databaseProvider.overrideWithValue(MockInMemoryDatabase()),
  ],
);
```

---

## 27. Future Remote Configuration

To prepare BankYar for future cloud synchronization and remote template updates, we define a secure path for remote configuration:

```
               [ Developer Dashboard / Admin Panel ]
                                │
                                ▼ Cryptographically Signs Configuration
               [ Encrypted JSON Payload (Signature check) ]
                                │
 ───────────────────────────────┼──────────────────────────────────────────────
                                │ (Pushed via future secure TLS socket sync)
                                ▼
               [ BankYar Client Application Ingestion ]
                                │
               - Validates payload signature via Public Key
               - Checks Configuration Version Sequence
               - Persists and unlocks new template configs in Local DB
```

* **Local Preference Precedence:** If a conflict occurs, local custom rules defined by the user always take precedence over remote updates, ensuring that users retain complete control over their local configurations.
* **No Remote Executable Code:** Remote updates are restricted to static JSON mapping schemas and templates. Dynamic executable code blocks or remote scripts are strictly forbidden.

---

## 28. Migration Strategy

When database schemas or configuration structures change in app updates, the application follows a strict migration path:

1. **Local Migration Scripts:** Migration scripts must be bundled directly inside the app assets.
2. **Launch-Time Schema Checks:** On launch, the database manager reads the current schema version from `PRAGMA user_version`. If the database version is older than the app version, the migration script executes.
3. **Rollback Strategy:** Prior to executing migrations, the app copies the database file to a temporary recovery file (`bankyar.db.bak`). If the migration fails, the app restores the backup file, logs the exception, and prompts the user to submit an encrypted diagnostic report.
4. **Data Drift Checks:** Automated data validator scripts verify table columns, indexes, and constraints post-migration to confirm that no data was corrupted during the upgrade.

---

## 29. Configuration Validation

To guarantee build integrity and prevent runtime crashes, BankYar implements a multi-tiered configuration validation system:

* **Build-Time Schema Verification:** A pre-compile Dart script parses and validates environment files (`config_*.json`) against a strict JSON Schema definition, checking for missing parameters, malformed types, or invalid regex syntax.
* **Runtime Sanity Validation:** On application startup, a validation service verifies critical configurations before unlocking the UI:
  - Confirms database signature patterns are intact.
  - Verifies encryption key sizes are exactly 256-bit.
  - Checks that critical security flags (such as `FLAG_SECURE`) are enabled in production builds.

---

## 30. Risks & Trade-offs

Designing a secure, offline-first configuration architecture involves balancing several trade-offs:

| Decided Architecture | Primary Benefit | Technical Trade-off / Risk | Mitigation Strategy |
| :--- | :--- | :--- | :--- |
| **Strict Offline-First** | Complete privacy; zero network leakage risk. | Cannot fetch live parser templates or update banking rules automatically. | Provide localized QR code scanning and clipboard imports for template updates. |
| **Compile-Time Obfuscation** | Prevents reverse engineering and reverse extraction. | Makes debugging production crash reports extremely difficult. | Generate and archive obfuscation symbol maps (`dSYM`, Proguard mappings) securely for every release build. |
| **Monotonic Coordinate Build Numbers** | Uniquely identifies compilation targets across pipelines. | Larger build integers require larger variable sizes. | Use standard 64-bit integers (`long` / `int64`) for build variable mappings. |
| **No-Cloud Telemetry** | 100% compliance with zero-network requirements. | No automated crash reporting or usability analytics. | Maintain a highly detailed, local diagnostic log panel, allowing users to manually export logs to share with developers. |

---

## 31. Architectural Decision Records (CADR)

The configuration architecture is governed by five core Architectural Decision Records:

### CADR-001: Strong-Typed Configuration Models
* **Status:** Approved
* **Context:** Using raw maps or string lookups for configuration values introduces typing errors and runtime crashes.
* **Decision:** We commit to mapping all environment variables, compile-time configurations, and feature flags to immutable, strongly typed Dart configuration classes on startup.
* **Rationale:** This ensures compile-time type safety, supports autocomplete in IDEs, and allows the compiler to prune dead code pathways in production builds.

### CADR-002: Monotonic Coordinate Build Numbering
* **Status:** Approved
* **Context:** Incremental build numbers can collide across different developer machines and build runners.
* **Decision:** Utilize a multi-parameter numbering scheme: `(FlavorID * 10^7) + (YYMMDD * 10) + BuildSequence`.
* **Rationale:** This ensures unique build numbers across all build pipelines, tracks compilation dates, and prevents version collisions.

### CADR-003: Absolute Compile-Time Feature Stripping
* **Status:** Approved
* **Context:** Including unreleased or future cloud features in production binaries exposes those features to reverse-engineering attacks.
* **Decision:** Enforce compile-time flags (`--dart-define`) to strip unfinished or platform-incompatible feature modules from production binaries.
* **Rationale:** This minimizes the application package size and guarantees that cloud-synchronization or experimental modules are completely absent from the production build.

### CADR-004: Isolate-Based Import Parsing
* **Status:** Approved
* **Context:** Processing bulk statements or large configurations on the main UI thread causes frame-drops and UI lag.
* **Decision:** Enforce separate Dart Isolates for all heavy import, parsing, and database write operations.
* **Rationale:** This ensures the main UI thread remains responsive (60fps+) even during bulk import operations.

### CADR-005: Dual-Key Backups (AES-GCM + PBKDF2)
* **Status:** Approved
* **Context:** Exported user backups must be protected against brute-force attacks and tampering.
* **Decision:** Encrypt exported backups using AES-256-GCM, with keys derived using PBKDF2 with 100,000 iterations and a unique salt.
* **Rationale:** GCM guarantees backup integrity, and PBKDF2 with 100,000 iterations protects files from offline brute-force attempts.

---
**End of Configuration, Environment, and Build Architecture Specification**
