# BankYar Flutter Project Structure & Folder Architecture Guide

**Project Name:** BankYar
**Classification:** Enterprise Mobile Architecture Standard
**Document Version:** 1.0.0
**Authors:** Principal Flutter Software Architect, Clean Architecture Specialist & Mobile Security Expert
**Status:** Approved / Official Structural Blueprint

---

## Executive Summary

BankYar is an offline-first, highly secure mobile application designed for intelligent on-device banking SMS capture, cryptographic relational persistence, and offline spending analytics. Because of its 100% offline nature (zero network permissions declared), the application relies on robust local computing, high-performance regex matching, and hardware-backed data protection.

This document establishes the official **Project Organization Standard** and folder architecture for BankYar. Built on **Clean Architecture** and **Feature-First Organization**, this design minimizes coupling, maximizes cohesion, and supports seamless team collaboration, independent feature development, automated testability, on-device AI integration, future iOS graceful degradation, and future modular extraction. It serves as the definitive reference guide for human developers and AI co-pilots throughout the lifecycle of the project.

---

## Table of Contents
1. [Project Organization Philosophy](#1-project-organization-philosophy)
2. [Root Folder Structure](#2-root-folder-structure)
3. [Feature Folder Structure](#3-feature-folder-structure)
4. [Shared Modules](#4-shared-modules)
5. [Core Modules](#5-core-modules)
6. [Infrastructure Modules](#6-infrastructure-modules)
7. [Asset Organization](#7-asset-organization)
8. [Localization Structure](#8-localization-structure)
9. [Configuration Structure](#9-configuration-structure)
10. [Dependency Organization](#10-dependency-organization)
11. [Generated Code Strategy](#11-generated-code-strategy)
12. [Environment Configuration](#12-environment-configuration)
13. [Build Configuration](#13-build-configuration)
14. [Test Folder Organization](#14-test-folder-organization)
15. [Documentation Folder](#15-documentation-folder)
16. [Scripts Folder](#16-scripts-folder)
17. [Tooling Folder](#17-tooling-folder)
18. [AI Prompt Folder](#18-ai-prompt-folder)
19. [Naming Convention](#19-naming-convention)
20. [Import Rules](#20-import-rules)
21. [Export Rules](#21-export-rules)
22. [File Ownership Rules](#22-file-ownership-rules)
23. [Package Boundaries](#23-package-boundaries)
24. [Dependency Rules](#24-dependency-rules)
25. [Module Visibility Rules](#25-module-visibility-rules)
26. [Future Monorepo Strategy](#26-future-monorepo-strategy)
27. [Future Package Extraction Strategy](#27-future-package-extraction-strategy)
28. [Folder Evolution Strategy](#28-folder-evolution-strategy)
29. [Migration Strategy](#29-migration-strategy)
30. [Project Governance Rules](#30-project-governance-rules)

---

## 1. Project Organization Philosophy

BankYar organizes its codebase using three key pillars:

1. **Feature-First Slicing:** Code is organized around vertical business features rather than horizontal framework layers. This allows developers and AI models to inspect, modify, and test features in isolation, reducing cognitive load and preventing changes in one feature from breaking another.
2. **Clean Architecture Laying:** Inside every vertical feature, code is divided into three distinct layers: Presentation (UI and State Notifiers), Domain (Pure Dart Business Entities and Use Cases), and Data (Repositories, Models, and Data Sources). This decouples business logic from external libraries, database drivers, and frameworks.
3. **Hardware-Backed Isolation:** Infrastructure layers (SQLCipher database, platform Keystore, biometric sensors) are separated from business rules using dependency inversion, ensuring the core domain remains highly testable and ready for future platform expansion.

---

## 2. Root Folder Structure

The physical root of the BankYar project is structured as follows:

```
bankyar/
├── .github/                            # CI/CD pipelines, workflows, and action configs
│   └── workflows/
│       ├── pr_verification.yaml        # Compiles code, runs linters, and executes tests
│       └── release_android.yaml        # Packages offline production Android APK
├── android/                            # Platform-specific Android configuration
├── ios/                                # Platform-specific iOS configuration (Graceful degradation)
├── assets/                             # Global application assets
│   ├── fonts/                          # Typography fonts
│   ├── icons/                          # Non-localized system graphics
│   ├── images/                         # Illustrations
│   └── locales/                        # Static local translations (Farsi, English, etc.)
├── scripts/                            # Project automation scripts
│   ├── run_tests.sh                    # Executes and aggregates unit and integration tests
│   ├── compile_db.sh                   # Builds SQLCipher modules locally
│   └── generate_code.sh                # Script to run build_runner commands
├── docs/                               # Developer manuals and architecture specs
│   ├── ADR/                            # Architectural Decision Records (ADRs)
│   ├── schemas/                        # Relational database diagrams
│   └── setup_guide.md                  # Developer onboarding manual
├── tooling/                            # Code analysis, linting, and IDE configurations
│   ├── analysis_options.yaml           # Pinned strict Dart analysis rules
│   └── .vscode/                        # Shared workspace configurations and tasks
├── ai/                                 # AI prompt libraries and guidelines
│   ├── guidelines.md                   # AI agent coding guidelines
│   └── system_instructions.txt         # Custom instructions for AI code generation
└── lib/                                # Core application directory
    ├── main.dart                       # Entrypoint of the application
    ├── app.dart                        # Configures MaterialApp, theme wrappers, and routing
    ├── core/                           # Shared Kernel (Abstractions and horizontal modules)
    │   ├── common/                     # Common extensions, errors, and value objects
    │   ├── database/                   # Relational database configurations (SQLCipher connection helper)
    │   ├── logging/                    # PII-scrubbed local logger
    │   ├── security/                   # Key derivation and platform KeyStore wrappers
    │   └── ui/                         # Design system tokens and generic widgets
    └── features/                       # Vertical business modules
        ├── secure_auth/                # Feature: Biometric/PIN Lock Control
        ├── sms_detection/              # Feature: Ingestion & Parser Engine
        ├── transactions/               # Feature: Ledger & Annotations
        ├── analytics/                  # Feature: Spending Statistics
        └── backup_restore/             # Feature: Backup Cryptography
```

---

## 3. Feature Folder Structure

To ensure consistency and high co-pilot performance, every vertical business feature must strictly implement the following folder structure:

```
lib/features/my_feature_name/
├── data/                               # Data Layer
│   ├── datasources/                    # Raw I/O data streams
│   │   ├── my_feature_local_source.dart# Reads/writes SQLCipher tables
│   │   └── my_feature_platform_api.dart# Accesses platform-specific APIs (MethodChannels)
│   ├── models/                         # Relational data transfer objects (DTOs)
│   │   └── my_feature_dto.dart         # Extends/maps domain entities; handles JSON serialization
│   └── repositories/                   # Concrete repository implementations
│       └── my_feature_repository_impl.dart# Implements domain contracts; handles mappers
├── domain/                             # Domain Layer (Pure Dart; zero package/framework references)
│   ├── entities/                       # Pure business models and aggregates
│   │   └── my_feature_entity.dart      # Standard domain model with immutable parameters
│   ├── repository/                     # Abstract repository contracts
│   │   └── my_feature_repository.dart  # Defines interfaces used by business Use Cases
│   └── usecases/                       # Executable atomic business rule workflows
│       ├── get_my_data_usecase.dart    # Standard query Use Case
│       └── save_my_data_usecase.dart   # Standard mutation Use Case
├── presentation/                       # Presentation Layer
│   ├── screens/                        # Full-screen declarative UI views
│   │   └── my_feature_dashboard.dart   # View layer; watches state and triggers interactions
│   ├── state/                          # Riverpod state management viewmodels
│   │   ├── my_feature_notifier.dart    # Extends AsyncNotifier; dispatches Use Cases
│   │   └── my_feature_ui_state.dart    # Immutable screen state models
│   └── widgets/                        # Private visual components
│       └── my_feature_card.dart        # Reusable component private to this feature
├── doc/                                # Feature-specific documentation
│   └── readme.md                       # Description of feature states, entities, and risks
└── test/                               # Feature-specific test suites
    ├── data/                           # Data-layer tests (DAOs, DTO mappers)
    ├── domain/                         # Domain-layer tests (Entities, Use Cases)
    └── presentation/                   # Presentation-layer tests (Notifiers, Widget behaviors)
```

### Feature Layers Responsibility Matrix

| Layer | Primary Responsibilities | Allowed Content | Forbidden Content |
| :--- | :--- | :--- | :--- |
| **Presentation** | Renders UI, listens to user events, manages UI state machines, and formats data for rendering. | Declarative Widgets, Animation Controllers, Riverpod Notifiers, UI state models. | Direct database operations, native MethodChannels, cryptographic operations. |
| **Domain** | Holds core business rules, models invariants, and orchestrates workflows. | Pure Dart classes, Domain Entities, Use Cases, Abstract Repository Interfaces. | Flutter/Material packages, Riverpod references, SQLCipher engines, filesystem paths. |
| **Data** | Reads and persists data, implements repository contracts, maps database tables to entities. | Concrete Repository Impls, SQLCipher DAOs, JSON serializers, MethodChannel interfaces. | UI triggers, direct state mutations, exposing raw cursor maps outside repositories. |

---

## 4. Shared Modules

Shared modules are generic, utility-level features placed in the `lib/core/` directory. They provide universal interfaces and services used across features, without holding any business logic:

```
lib/core/common/
├── errors/
│   ├── exceptions.dart                 # Raw platform exceptions (e.g., SQLiteException)
│   └── failures.dart                   # Mapped domain failures (e.g., DatabaseCorruptionFailure)
├── extensions/
│   ├── date_extensions.dart            # Standard date calculations
│   └── number_extensions.dart          # Currency precision formatting
├── utils/
│   └── math_utils.dart                 # Precise decimal calculations
└── value_objects/
    └── monetary_amount.dart            # Immutable standard currency object
```

### Shared Kernel Constraints:
1. **Zero Business Dependencies:** Code inside `lib/core/common/` must contain exactly **zero references** to files in `lib/features/`.
2. **Platform-Independent Types:** Abstractions (such as `monetary_amount.dart`) use pure Dart types, ensuring they remain portable.

---

## 5. Core Modules

Core modules manage global application states and structures. They reside in `lib/core/` and define essential global contexts:

```
lib/core/ui/
├── design_system/
│   ├── color_tokens.dart               # Theme colors
│   ├── typography_tokens.dart          # Font sizes, weights, and heights
│   └── spacing_tokens.dart             # Standard margins and paddings
└── widgets/
    ├── custom_button.dart              # Shared button components
    ├── loading_overlay.dart            # Global blocking loading indicators
    └── error_dialog.dart               # Consistent error presentation panels
```

---

## 6. Infrastructure Modules

Infrastructure modules encapsulate low-level operating system bindings, secure file-system interfaces, and database drivers:

```
lib/core/database/
├── database_pool.dart                  # Thread-isolated SQLite executor interfaces
├── base_dao.dart                       # Basic relational CRUD statement builders
└── schema_migrations.dart              # Migration scripts
```

```
lib/core/security/
├── keystore_interface.dart             # Platform KeyStore / Secure Enclave adapters
├── key_eviction_manager.dart           # Key-eviction timers
└── password_deriver.dart               # PBKDF2 with 100,000 iterations helper
```

```
lib/core/logging/
├── logger_interface.dart               # Shared diagnostic logging protocols
├── log_rotator.dart                    # Keeps logs size-capped under 2MB
└── pii_scrubber.dart                   # Redacts numeric sequences (amounts, balances, card IDs)
```

---

## 7. Asset Organization

To optimize build compilation and keep image directories clean, visual assets are structured as follows:

```
assets/
├── fonts/
│   ├── Vazirmatn-Regular.ttf           # Standard Farsi/Arabic font
│   └── Roboto-Medium.ttf               # Standard Latin font
├── icons/
│   ├── ic_app_logo.png                 # Main launcher icon
│   └── ic_shield_lock.svg              # Biometric lock indicator icon
└── images/
    ├── img_empty_ledger.svg            # Fallback graphic for empty dashboard lists
    └── img_warning_corruption.svg      # Graphic for the disaster recovery screen
```

### Asset Management Policy:
* **Vector Over Raster:** Use vector graphics (`.svg`) for system icons and illustrations to ensure clean rendering on high-density displays.
* **Naming Convention:** Prefix icon filenames with `ic_` (e.g., `ic_key.svg`) and illustration filenames with `img_` (e.g., `img_onboarding.png`).

---

## 8. Localization Structure

To meet privacy requirements, all translations are resolved locally on-device:

```
assets/locales/
├── en.json                             # English static dictionary
├── fa.json                             # Farsi static dictionary
└── static_translation_loader.dart      # Parses locale files into application memories
```

### Localization Guidelines:
* **No Cloud Calls:** The translation engine must resolve keys completely offline.
* **Key-Based Organization:** String keys use dot-notation for quick lookup:
  ```json
  {
    "auth.pin.prompt": "Enter your secure PIN",
    "ledger.empty.title": "No transactions found"
  }
  ```

---

## 9. Configuration Structure

Configurations manage static environment variables and parameters:

```
lib/core/config/
├── app_config.dart                     # Database filenames and maximum logs size boundaries
├── build_flags.dart                    # Obstacles to toggle debug flags during releases
└── version_manifest.dart               # Feature version metadata
```

### Configuration Guidelines:
* **Explicit Constants:** Standard settings (e.g., `dbName = "bankyar_secure.db"`) are defined as compile-time constants.
* **Secure Defaults:** Safety features (e.g., `debugModeAllowed`) default to `false` for release builds.

---

## 10. Dependency Organization

To maintain clean architecture, dependencies are configured using **Riverpod Providers**:

```
lib/core/di/
├── database_provider.dart              # Provides active SQLCipher instances
└── security_provider.dart              # Provides KeyStore and authentication interfaces
```

### Dependency Rules:
1. **No Direct DAOs in UI:** UI files can never import platform drivers. They access services exclusively through repository providers.
2. **Provider Overrides for Testing:** Dependencies are easily mocked in tests by overriding providers, eliminating the need for complex service locators.

---

## 11. Generated Code Strategy

To speed up compiles and maintain clean repository structures, build generators are strictly managed:

* **Approved Code Generators:** `freezed` (for immutable states), `json_serializable` (for DTOs), and `riverpod_generator` (for DI containers).
* **Git Exclusions:** Generated code files (`*.g.dart` and `*.freezed.dart`) are checked in to the repository to guarantee reproducible builds on any workspace.
* **Code Generator Rules:** Developers must run the build runner using the official script:
  ```bash
  ./scripts/generate_code.sh
  ```

---

## 12. Environment Configuration

Because BankYar operates completely offline, environments manage build targets:

```
tooling/environments/
├── prod.env                            # Absolute zero-network, secure production settings
└── dev.env                             # Enables verbose local logging for debugging
```

### Environment Safeguards:
* `prod.env` enforces `allowBackup = false` and disables all debug mechanisms, protecting production environments.

---

## 13. Build Configuration

Build systems configure the offline, secure compiler targets:

* **Android ProGuard Rules (`android/app/proguard-rules.pro`):** Obfuscates class names and removes debugging symbols.
* **Excluded Network Permissions:** The Android Manifest strictly excludes `android.permission.INTERNET`, ensuring compile-time safety.

---

## 14. Test Folder Organization

The test suite structure mirrors the logical layout of the application, ensuring high test coverage:

```
test/
├── core/                               # Tests for common modules and utilities
│   ├── common/                         # Tests for decimal calculations and formatters
│   ├── database/                       # Tests for migrations and SQLCipher schemas
│   └── security/                       # Tests for PBKDF2 derivations and salts
├── features/                           # Unit and widget tests for vertical features
│   ├── secure_auth/
│   │   ├── domain/usecases_test.dart   # Tests lockouts and PIN hashing
│   │   └── presentation/notifier_test.dart
│   ├── sms_detection/
│   │   ├── data/parser_engine_test.dart# Tests regex configurations
│   │   └── domain/ingestion_test.dart
│   └── transactions/
│       ├── data/sqlite_dao_test.dart   # Relational checks using in-memory SQLite
│       └── presentation/ledger_test.dart
├── integration/                        # E2E integration test flows
│   └── secure_ingestion_flow_test.dart # Verifies SMS captures to database writes
└── mocks/                              # Centralized mock and fake definitions
    ├── mock_secure_storage.dart
    └── mock_transaction_repository.dart
```

---

## 15. Documentation Folder

Developer documentation resides in the `docs/` directory:

```
docs/
├── ADR/
│   ├── ADR-001_architecture_pattern.md # Clean architecture selection rationale
│   └── ADR-002_database_selection.md   # SQLCipher relational selection rationale
├── database_schema_guide.md            # Detailed table indices and mappings
└── developer_onboarding.md             # Guide to workspace setups
```

---

## 16. Scripts Folder

Automation scripts reside in the `scripts/` folder:

```
scripts/
├── run_tests.sh                        # Runs all unit, integration, and linter checks
├── compile_db.sh                       # Local SQLCipher dependency compiler
└── generate_code.sh                    # Triggers build_runner commands
```

---

## 17. Tooling Folder

Linter and workspace configurations reside in the `tooling/` folder:

* **`analysis_options.yaml`:** Configures strict Dart rules (e.g., enforcing `always_declare_return_types`, `avoid_print`, and `prefer_const_constructors`).
* **`vs_tasks.json`:** Visual Studio Code shortcuts to run tests and code generation scripts.

---

## 18. AI Prompt Folder

To optimize development for AI assistants and co-pilots, specialized prompt guidelines are stored in `ai/`:

```
ai/
├── templates/
│   ├── create_usecase.txt              # Prompt template to generate Clean Use Cases
│   └── create_notifier.txt             # Prompt template to generate Riverpod Notifiers
└── coding_guidelines.md                # Strict rules for code generation (no network, types)
```

---

## 19. Naming Convention

Naming conventions enforce absolute consistency across variables, directories, and files:

| Target | Convention | Example |
| :--- | :--- | :--- |
| **Directory Paths** | Lowercase Snake Case | `features/sms_detection/` |
| **Dart Files** | Lowercase Snake Case | `transaction_repository_impl.dart` |
| **Widget Classes** | Upper Camel Case | `LedgerDashboardScreen` |
| **Notifiers / ViewModels** | Upper Camel Case with suffix `Notifier` | `SecureAuthNotifier` |
| **Repository Interfaces** | Upper Camel Case with `Repository` suffix | `TransactionRepository` |
| **Repository Implementations**| Upper Camel Case with `RepositoryImpl` suffix| `TransactionRepositoryImpl` |
| **Use Cases** | Upper Camel Case with `UseCase` suffix | `ProcessIncomingSmsUseCase` |
| **Domain Entities** | Upper Camel Case with `Entity` suffix | `ParserTemplateEntity` |
| **Data Models (DTOs)** | Upper Camel Case with `Dto` suffix | `TransactionDto` |
| **Provider Variables** | Lower Camel Case with `Provider` suffix | `transactionRepositoryProvider` |
| **Mock Classes** | Upper Camel Case with `Mock` prefix | `MockSecureStorage` |

---

## 20. Import Rules

Import configurations are verified by analysis options to prevent layer leaks and circular references:

* **Strict Package Imports:** Use absolute package imports (`import 'package:bankyar/core/...'`) for files outside a directory. Relative imports are allowed only for files inside the same folder boundary.
* **No Outward Layer Imports:** Domain files can never import files from Data or Presentation layers.
* **No Direct Feature-to-Feature Cross-Imports:** Features cannot import presentation or data files from other features. Shared models must use interfaces defined in `core`.

---

## 21. Export Rules

To prevent interface bloat and speed up compiling, export declarations must follow clean design practices:

* **No Barrel File Pollution:** Avoid creating universal barrel files (e.g., `features_barrel.dart` exporting every widget). This can confuse compiler tree-shaking algorithms and cause circular references.
* **Explicit Imports:** Features import only the specific classes they require.

---

## 22. File Ownership Rules

To streamline development in large teams, directories are assigned to specific area owners:

| Module / Directory | Area Owner | Responsible Team |
| :--- | :--- | :--- |
| `lib/features/sms_detection/` | Parsing & Extraction Engine | Platform & Core Parser Team |
| `lib/features/transactions/` | Ledger, Annotation, Categorization | UI & Domain Ledger Team |
| `lib/features/analytics/` | Spending allocations & visual reports | Data Visualization & UI Team |
| `lib/features/secure_auth/` | Authentication controls, PINs, biometrics| Security & Compliance Team |
| `lib/core/security/` | Key generation & Keystore integrations | Security Platform Team |
| `lib/core/database/` | SQLCipher, migrations, schema drivers | Core Platform Team |

---

## 23. Package Boundaries

Package boundaries isolate features, preparing them for future modular extraction:

* **Independent Package Targets:** Features are written to communicate through abstract interfaces, ensuring they can be converted to standalone packages (`pub` packages) with minimal refactoring.

---

## 24. Dependency Rules

BankYar's dependency rules enforce a clean, unidirectional flow:

$$\text{Presentation Layer} \longrightarrow \text{Domain Layer} \longleftarrow \text{Data Layer}$$

* **Domain Independency:** The domain layer must be pure Dart and contain no references to Flutter, Riverpod, SQLCipher, or UI components.
* **Dependency Inversion:** Repositories in the data layer implement the abstract interfaces defined in the domain layer, ensuring the core domain is completely independent of external dependencies.

---

## 25. Module Visibility Rules

Module visibility limits access to internal components:

* **Public Interface:** Only Use Cases and abstract repository interfaces are exposed.
* **Private Implementation:** Local Data Sources (DAOs), DTO models, and private widgets remain encapsulated inside their folders, hidden from other features.

---

## 26. Future Monorepo Strategy

If BankYar scales to support additional applications (e.g., a merchant interface), the project is ready to transition to a monorepo structure:

```
bankyar_monorepo/
├── melos.yaml                          # Monorepo management configuration
├── apps/
│   ├── bankyar_mobile/                 # Current core offline mobile app
│   └── bankyar_companion/              # Desktop/tablet companion dashboard app
└── packages/
    ├── core_database/                  # Standalone SQLCipher package
    ├── sms_parser_engine/              # Shared regex extraction library
    └── design_system/                  # Shared design tokens and UI widgets
```

---

## 27. Future Package Extraction Strategy

To extract a feature (e.g., `sms_parser`) into a separate reusable package:

1. **Move Folder:** Move the target feature directory (e.g., `lib/features/sms_detection/`) to the `packages/` directory.
2. **Create Manifest (`pubspec.yaml`):** Define dependencies and export public APIs.
3. **Reference Local Package:** Update the main app's dependencies to reference the new package locally:
   ```yaml
   dependencies:
     sms_parser_engine:
       path: ./packages/sms_parser_engine
   ```

---

## 28. Folder Evolution Strategy

As features grow, directories adapt gracefully without breaking logical structures:

```
# Example: Adding a feature sub-domain (e.g., Food Budgets)
lib/features/transactions/
├── domain/
│   ├── entities/
│   │   ├── transaction_entity.dart
│   │   └── budget_entity.dart          # Natural evolution: nested sub-aggregates
```

---

## 29. Migration Strategy

When migrating from the initial prototype codebase, we implement a systematic process:

```
[ Phase 1: Infrastructure Isolation ] ──► Decouple SQLCipher and Keystore drivers into core
                                                │
                                                ▼
[ Phase 2: Domain Modeling ] ──────────► Establish pure Dart entities and Use Cases
                                                │
                                                ▼
[ Phase 3: Presentation Clean-up ] ────► Refactor screens to use Riverpod Notifiers
```

---

## 30. Project Governance Rules

To maintain high code quality and architectural integrity throughout the project lifecycle:

* **PR Code Quality Gates:** All Pull Requests must pass linter analysis, static security scans, and achieve a minimum of **80% unit test coverage** before merging.
* **No Direct Mutator Calls:** UI widgets must never mutate repository state directly. All mutations must be triggered by dispatching commands to state notifiers.
* **Manifest Protection:** Any PR attempting to add network permissions (e.g., `android.permission.INTERNET`) is automatically rejected by the pre-commit checks.

---
**End of Project Structure Guide**
