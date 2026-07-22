# 01_AIDevelopmentGuide.md

- **Version:** 1.0.0
- **Status:** APPROVED & ENFORCED
- **Owner:** Principal AI Systems Architect & Flutter Tech Lead
- **Last Updated:** October 2023
- **Related Documents:**
  - `CODING_CONSTITUTION.md`
  - `AI_CONSTITUTION.md`
  - `02_FlutterCodingStandards.md`
  - `03_FileEditingRules.md`
  - `04_PromptTemplates.md`
  - `05_ContextLoadingStrategy.md`
  - `06_DefinitionOfDone.md`
  - `07_TestingStandards.md`

---

## 1. Executive Summary

BankYar is an offline-first, highly secure, privacy-focused financial SMS parser and manager designed to keep sensitive user data strictly local. The application must operate without any internet permissions (`android.permission.INTERNET` is strictly prohibited) to guarantee that zero telemetry, transaction logs, or PII (Personally Identifiable Information) can leak.

To build and maintain this enterprise-grade software ecosystem, BankYar employs an **AI-First software development lifecycle**. This guide acts as the foundational governance blueprint, detailing the explicit division of labor, constraints, workflows, and strict compliance rules that AI agents must follow when collaborating with human engineers.

---

## 2. Purpose & Scope

### Purpose
The purpose of this document is to establish the core operational boundaries and high-density workflows for AI agents inside the BankYar project. This document serves as the "Rule of Law" for all code generation, refactoring, code review, and bug-fixing tasks.

### Scope
This guide applies to all source files, configurations, scripts, and documentation under the BankYar codebase hierarchy, including:
- Pure Dart business logic (Domain and Use Cases)
- Platform integrations (Android platform channels)
- Local persistence layers (SQLCipher encrypted databases)
- Presentation layer components (Flutter screens, widgets, and Riverpod StateNotifiers)
- Automated testing infrastructure (Unit, Widget, Integration, and Golden tests)

---

## 3. Definitions

| Term | Definition |
| :--- | :--- |
| **PII** | Personally Identifiable Information (e.g., phone numbers, names, financial account numbers). |
| **SQLCipher** | An extension to SQLite that provides transparent, 256-bit AES encryption of database files. |
| **Clean Architecture** | Architectural pattern separating concerns into Presentation, Domain, and Data vertical slices. |
| **Riverpod** | Unidirectional reactive state-management and compile-time safe dependency injection framework. |
| **RTL (Right-to-Left)** | Spatial support for languages like Persian (Farsi), including layouts, text alignments, and gesture mirrors. |
| **Deterministic Parser** | Regex-based parser rules that extract text with 100% predictable, non-probabilistic accuracy. |
| **AI Quality Gates** | Absolute numeric thresholds and validation criteria that all AI-generated code must satisfy. |

---

## 4. Project Philosophy & Core Pillars

The development of BankYar is guided by three non-negotiable core pillars:

1. **Privacy & Security by Design:** Zero-network reliance. The absolute absence of `android.permission.INTERNET` in manifests ensures that user data is perfectly protected inside local, hardware-encrypted databases.
2. **Deterministic Dominance over Stochastic Systems:** While AI is stochastic and probabilistic, the code it produces must be strictly deterministic, highly decoupled, and 100% verifiable.
3. **Decoupled Structural Purity:** Strict Clean Architecture (Feature-First) slices prevent domain pollution from database, platform, or visual framework libraries.

---

## 5. AI Responsibilities & Constraints

AI agents possess substantial development capability, but they must operate under strict, deterministic limits to ensure system integrity.

```
       +--------------------------------------------------------+
       |                  AI OPERATIONAL RANGE                  |
       +--------------------------------------------------------+
       |   ALLOWED ACTIVITIES      |      FORBIDDEN ACTIONS     |
       +---------------------------+----------------------------+
       |  - Write immutable models |  - Adding network access   |
       |  - Refactor monolithic UI |  - Bypassing repositories  |
       |  - Generate unit tests    |  - Adding unvetted deps    |
       |  - Implement pure mappers |  - Plaintext key storage   |
       |  - Draft triple-slash API |  - Dynamic type casting    |
       +---------------------------+----------------------------+
```

### Allowed Changes
- Generating scaffoldings for features under `lib/features/[feature_name]/` following the Feature-First directory layout.
- Implementing pure Dart UseCases obeying the Single Action Principle.
- Authoring database models (DTOs) with JSON serialization, mapping functions, and explicit entities.
- Refactoring and optimizing Flutter widgets to keep build methods under 40 lines.
- Creating comprehensive mock classes and deterministic unit, widget, and integration tests.

### Forbidden Changes
- **Adding Network Capabilities:** Never attempt to register network libraries, telemetry packages, Firebase, or configure any outgoing connections.
- **Bypassing Repository Contracts:** UI screens or Riverpod StateNotifiers must never access database models, raw SQL, or platform channels directly.
- **Plaintext Key Management:** Cryptographic keys or database passwords must never be stored in plain text or hardcoded inside source files.
- **Dynamic Casts & Implicit Types:** The compiler options `implicit-casts: false` and `implicit-dynamic: false` are strictly enforced. All models and variables must be explicitly typed.

---

## 6. Architecture Principles & Layer Separation

All feature additions must strictly adhere to the physical boundary model of Clean Architecture:

1. **Presentation Layer (`presentation/`):** Houses Screens, Widgets, and State Notifiers. Purely visual and reactive. No business rules, calculations, or direct storage calls are permitted here.
2. **Domain Layer (`domain/`):** Pure Dart logic. Houses entities, usecases, and abstract repository contracts. Contains exactly **zero** imports from Flutter, Riverpod, SQLCipher, or platform libraries.
3. **Data Layer (`data/`):** Houses concrete repository implementations, DTO models, mappers, encrypted database accessors, and Secure Storage adapters.

```
                      +------------------------+
                      |      PRESENTATION      |
                      |  (UI, State Notifiers) |
                      +-----------+------------+
                                  |
                        Uses      |  (Inward direction)
                        contracts |
                                  v
                      +------------------------+
                      |         DOMAIN         |
                      |   (Entities, Usecases) |
                      +-----------^------------+
                                  |
                        Implements|  (Inward direction)
                        contracts |
                                  v
                      +------------------------+
                      |          DATA          |
                      | (SQLCipher, DTO, Maps) |
                      +------------------------+
```

---

## 7. Development & Engineering Workflows

### 7.1 Feature Development Workflow
The step-by-step feature development pipeline is divided into five distinct stages:

```
+---------------+     Scaffold Files     +--------------------+
| 1. PLANNING   | ---------------------> | 2. DOMAIN CONTRACT |
| (Define Plan) |                        | (Entities/Contracts|
+---------------+                        +---------+----------+
                                                   |
                                                   | Write logic
                                                   v
+---------------+      Assemble UI       +--------------------+
| 4. PRESENT    | <--------------------- | 3. DATA PERSIST    |
| (Notifier/UI) |                        | (Mappers/DAO/Repo) |
+---------------+                        +--------------------+
        |
        | Verify & Test
        v
+---------------+
| 5. VALIDATION | => Run 'flutter test' and 'dart analyze'
+---------------+
```

### 7.2 Code Generation Workflow
- AI must inspect `pubspec.yaml` and existing libraries to prevent redundant dependencies.
- Generates precise, single-responsibility files (max 300 lines of code) with correct suffixes as specified in `CODING_CONSTITUTION.md`.
- All generated code must be run through the Dart formatter (`dart format --line-length=80 .`).

### 7.3 Review & Refactoring Workflow
- Before refactoring, AI must run the existing test suite to establish a behavioral baseline.
- Monolithic widgets exceeding 150 lines or build methods exceeding 40 lines must be split into private, stateless child widgets.
- Complex nested control blocks must be extracted into helper methods with a cyclomatic complexity strictly below 8.

---

## 8. Development Rules & Governance

### 8.1 Security Rules
- **Native Security Protections:** Ensure screens containing financial information, SMS logs, or setup fields implement Android secure overlay protection (`FLAG_SECURE`) to block screenshots, video capture, and recent task-switcher memory caching.
- **AES-256 Storage:** All transactions, categories, and SMS logs must go through page-encrypted SQLCipher instances.

### 8.2 Performance Rules
- **UI Thread Integrity:** The main Dart thread must remain completely unblocked to maintain a target 60fps/120fps. All cryptographic hashing, regex processing, and large SQLite queries must execute asynchronously.
- **Const Constructors:** Use `const` builders for widgets wherever possible to prevent unnecessary layout recalculations.

### 8.3 Accessibility & Inclusive Design (a11y)
- **Contrast & Font Scaling:** UI layouts must support dynamic text scaling up to 200% without clipping, overlapping, or throwing layout overflow errors.
- **Screen Reader Navigation:** All custom widgets must declare descriptive labels using Flutter `Semantics` tags. Focus chains must follow logical, left-to-right (LTR) or right-to-left (RTL) ordered patterns.

### 8.4 Localization & RTL Farsi Support
- All user-facing strings must be routed through the internationalization (`l10n`) manager. Hardcoded text strings are forbidden.
- Screen designs must support automatic Persian layout mirroring. Multi-column widgets, directional arrows, and navigation paths must mirror dynamically when Farsi is loaded.

### 8.5 Offline-First Rules
- BankYar assumes permanent offline mode. Data mutations must be applied locally and immediately to SQLCipher tables.
- There are no cloud fallbacks, remote sync procedures, or external endpoints.

### 8.6 Dependency Rules
- Riverpod is the sole approved framework for dependency injection. Direct service locators or manual instantiation loops are prohibited.
- Adding third-party packages requires approval from the Lead Architect and an exhaustive license review.

---

## 9. Git Commit & Release Guidelines

### Git Commit Guidelines
Commits must be small, logical, and follow the standard prefix format:
- `feat(feature-name): Commit message [Layer: Presentation|Domain|Data]`
- `fix(feature-name): Corrected bug [Layer: Domain]`
- `refactor(component): Optimized layout tree [Layer: Presentation]`

### Pre-Commit Checklist
Before submitting code, AI must execute and pass the following Quality Gates:
- `dart analyze` returns zero errors, warnings, or linting hints.
- `flutter test` executes and passes all existing and newly written unit, widget, and integration tests.
- File and class line limit guidelines are completely respected.

---

## 10. Collaboration & Escalation Rules

### Human & AI Responsibilities
- **AI Agent:** Responsible for code production, mock generation, localized refactoring, standard unit test development, and static policy validation.
- **Human Developer:** Acts as the Governor, defining architecture scope, reviewing security practices, verifying visually complex golden layouts, and providing final merge approvals.

### Escalation Rules
AI must immediately halt operations and request user input via `request_user_input` in the following scenarios:
1. When encountering ambiguous, conflicting, or incomplete specifications.
2. If compiling or testing results in recursive, non-trivial environment or dependency errors.
3. If fulfilling a feature request would require introducing external network configurations, violating the core Privacy-first constraint.

---

## 11. Common Mistakes & Anti-patterns

- **The "Data Leak" (The Network Breach):** Adding packages that attempt telemetry uploads or analytics integration in the background.
- **The "Direct Bypass" (Layer Contamination):** Importing SQLCipher classes or platform packages directly inside presentation files or widget trees.
- **The "Stiff UI" (Main Thread Block):** Compiling multi-character regular expressions or computing analytical aggregates synchronously inside the widget build process.
- **The "Over-Nested Tree":** Writing deep, hard-to-maintain nested layout structures (depth > 3) inside a single visual class.

---

## 12. Review Checklist

Before finalizing any development, the AI and developer must check:
- [ ] Compiles with zero static analysis errors and zero linter warnings.
- [ ] No file exceeds the maximum 300-line threshold.
- [ ] All public APIs are fully documented using triple-slash (`///`) comments.
- [ ] Standard secure overlay (`FLAG_SECURE`) is enabled on all financial pages.
- [ ] Complete Persian RTL mirroring has been verified on visual mockups.
- [ ] Unit and parser tests have 100% and 85% coverage respectively.

---
**End of Document**
